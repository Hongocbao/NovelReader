"""Run against a NEW disposable PostgreSQL container, with no production data.

Example (PostgreSQL official image; no host ports or network needed):
  docker run -d --name novelreader-chapter-tests --network none \
    -e POSTGRES_HOST_AUTH_METHOD=trust -e POSTGRES_DB=novelreader_test postgres:17-alpine
  python test/postgres/atomic_chapter_append.py --container novelreader-chapter-tests
  docker rm -f novelreader-chapter-tests

Uses only Python's standard library and psql inside the container. Concurrent
calls use separate PostgreSQL sessions, so they exercise actual row locking.
"""

import argparse
from concurrent.futures import ThreadPoolExecutor
import json
from pathlib import Path
import subprocess


ROOT = Path(__file__).resolve().parents[2]
OWNER = '11111111-1111-4111-8111-111111111111'
OTHER = '22222222-2222-4222-8222-222222222222'
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--container', required=True)
parser.add_argument('--docker', default='docker')
args = parser.parse_args()


def sql(statement, *, user=None, expect_error=False):
    if user is not None:
        statement = (
            "SET ROLE authenticated; "
            f"SET request.jwt.claim.sub = '{user}'; " + statement
        )
    result = subprocess.run(
        [args.docker, 'exec', '-i', args.container,
         'psql', '-X', '-qAt', '-v', 'ON_ERROR_STOP=1',
         '-U', 'postgres', '-d', 'novelreader_test'],
        input=statement, text=True, encoding='utf-8', capture_output=True,
        timeout=90,
    )
    if expect_error:
        assert result.returncode != 0, 'Expected SQL failure, but it succeeded'
        return result.stderr
    if result.returncode:
        raise AssertionError(result.stderr)
    return result.stdout.strip()


def literal(value):
    return "'" + value.replace("'", "''") + "'"


def append(book, key, title='Tiếp theo', content='Nội dung chương', user=OWNER):
    return json.loads(sql(
        f'SELECT public.append_novel_chapter({book}, {literal(title)}, '
        f'{literal(content)}, {literal(key)});', user=user,
    ))


def create(key):
    book = json.dumps({
        'title': 'Truyện mới', 'author': 'Tác giả', 'owner_id': OWNER,
        'moderation_status': 'pending',
    }, ensure_ascii=False)
    chapters = json.dumps([
        {'title': 'Chương 1', 'content': 'Nội dung đầu'},
        {'title': 'Chương 2', 'content': 'Nội dung sau'},
    ], ensure_ascii=False)
    return json.loads(sql(
        f'SELECT public.create_novel_with_chapters({literal(book)}::jsonb, '
        f'{literal(chapters)}::jsonb, {literal(key)});', user=OWNER,
    ))


# Refuse to initialize an existing app database, even a local one.
assert sql('SELECT current_database();') == 'novelreader_test'
assert sql("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';") == '0'
sql('''
CREATE ROLE anon;
CREATE ROLE authenticated;
CREATE ROLE service_role;
CREATE SCHEMA auth;
CREATE TABLE auth.users(id UUID PRIMARY KEY);
CREATE FUNCTION auth.uid() RETURNS UUID LANGUAGE sql STABLE AS $$
  SELECT NULLIF(current_setting('request.jwt.claim.sub', true), '')::uuid;
$$;
GRANT USAGE ON SCHEMA auth TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION auth.uid() TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES TO authenticated;
''')
schema = (ROOT / 'supabase/01_schema.sql').read_text(encoding='utf-8')
upgrade = (ROOT / 'supabase/13_atomic_chapter_append.sql').read_text(encoding='utf-8')
reorder_upgrade = (ROOT / 'supabase/14_atomic_chapter_reorder.sql').read_text(encoding='utf-8')
assert upgrade in schema and schema.endswith(reorder_upgrade), 'Fresh schema and upgrades must use the same functions'
sql(schema[:schema.index('-- Tạo truyện và thêm chương trong các giao dịch nguyên tử.')])
sql((ROOT / 'supabase/10_atomic_novel_import.sql').read_text(encoding='utf-8'))
sql(f'''
INSERT INTO auth.users VALUES ('{OWNER}'), ('{OTHER}');
INSERT INTO public.ho_so (id,email,display_name,last_active_at,created_at)
VALUES ('{OWNER}','owner@example.invalid','Owner',1,1),
       ('{OTHER}','other@example.invalid','Other',1,1);
INSERT INTO public.truyen (id,title,author,total_chapters,updated_at,owner_id)
VALUES (1,'Nhiều chương','Tác giả',2,1,'{OWNER}'),
       (2,'Truyện kế tiếp','Tác giả',1,1,'{OWNER}'),
       (3,'Fail totals','Tác giả',0,1,'{OWNER}');
SELECT setval(pg_get_serial_sequence('public.truyen','id'),3);
INSERT INTO public.chuong (id,novel_id,chapter_index,title,content)
VALUES (10001,1,1,'Chương 1','Cũ'),(20000,1,10000,'Chương 10000','Cũ'),
       (20001,2,1,'Chương 1','Sách khác');
''')
before = sql('SELECT id,novel_id,chapter_index,title,content FROM chuong ORDER BY id;')
sql(upgrade)
assert before == sql('SELECT id,novel_id,chapter_index,title,content FROM chuong ORDER BY id;')
first = append(1, 'first', title='')
assert first['chapter_index'] == 10001 and first['id'] > 20001
assert first['title'] == 'Chương 10001' and first['is_downloaded'] == 0
assert sql('SELECT total_chapters FROM truyen WHERE id=1;') == '3'
print('PASS upgrade preserves existing data, removes ID-block limit, counts actual chapters')

with ThreadPoolExecutor(max_workers=12) as pool:
    chapters = list(pool.map(lambda i: append(1, f'parallel-{i}'), range(24)))
assert len({c['id'] for c in chapters}) == 24
assert sorted(c['chapter_index'] for c in chapters) == list(range(10002, 10026))
assert sql('SELECT total_chapters FROM truyen WHERE id=1;') == '27'
print('PASS 24 parallel sessions allocate unique indexes and keep totals consistent')

with ThreadPoolExecutor(max_workers=12) as pool:
    replies = list(pool.map(lambda _: append(1, 'retry', title='Chương 10026: Gửi lại'), range(12)))
assert len({c['id'] for c in replies}) == 1
assert all(c['title'] == 'Chương 10026: Gửi lại' for c in replies)
assert sql('SELECT total_chapters FROM truyen WHERE id=1;') == '28'
assert append(1, 'retry', title='Chương 10026: Gửi lại')['id'] == replies[0]['id']
sql("SELECT append_novel_chapter(1,'Nội dung khác','Khác','retry');", user=OWNER, expect_error=True)
print('PASS concurrent and later retries return the same chapter; conflicting payload is rejected')

with ThreadPoolExecutor(max_workers=12) as pool:
    futures = [pool.submit(create, f'book-{i}') for i in range(8)]
    futures += [pool.submit(append, 2, f'book2-{i}') for i in range(8)]
    for future in futures:
        future.result()
assert sql('SELECT COUNT(*) = COUNT(DISTINCT id) FROM chuong;') == 't'
assert sql('SELECT COUNT(*) FROM truyen n WHERE n.total_chapters <> (SELECT COUNT(*) FROM chuong c WHERE c.novel_id=n.id);') == '0'
assert create('book-0')['id'] == create('book-0')['id']
print('PASS concurrent book imports and appends share safe IDs; import retries remain compatible')

sql('''
CREATE FUNCTION fail_test_total() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.title='Fail totals' AND NEW.total_chapters>OLD.total_chapters THEN
    RAISE EXCEPTION 'Simulated failure while updating total';
  END IF;
  RETURN NEW;
END;
$$;
CREATE TRIGGER fail_test_total BEFORE UPDATE ON truyen
FOR EACH ROW EXECUTE FUNCTION fail_test_total();
''')
error = sql("SELECT append_novel_chapter(3,'Tổng lỗi','Nội dung','rollback');", user=OWNER, expect_error=True)
assert 'Simulated failure' in error
assert sql('SELECT COUNT(*) FROM chuong WHERE novel_id=3;') == '0'
assert sql('SELECT total_chapters FROM truyen WHERE id=3;') == '0'
sql('DROP TRIGGER fail_test_total ON truyen; DROP FUNCTION fail_test_total();')
assert append(3, 'rollback')['chapter_index'] == 1
print('PASS failed total update rolls back chapter; retry succeeds after recovery')

sql("SELECT append_novel_chapter(1,'X','Y','other');", user=OTHER, expect_error=True)
sql("SELECT append_novel_chapter(1,'X',E' \\n\\t','empty');", user=OWNER, expect_error=True)
sql("SELECT append_novel_chapter(99999,'X','Y','missing');", user=OWNER, expect_error=True)
sql("SELECT append_novel_chapter(1,'X','Y','');", user=OWNER, expect_error=True)
print('PASS missing book, empty content/key, and different owner do not insert chapters')

sql('UPDATE truyen SET updated_at=1 WHERE id=2;')
original_index = sql('SELECT chapter_index FROM chuong WHERE id=20001;')
sql("UPDATE chuong SET title='Chương đã biên tập' WHERE id=20001;", user=OWNER)
assert sql('SELECT chapter_index FROM chuong WHERE id=20001;') == original_index
assert sql('SELECT updated_at>1 FROM truyen WHERE id=2;') == 't'
sql("INSERT INTO chuong(id,novel_id,chapter_index,title,content) VALUES (900000,2,9999,'Mẫu','Nội dung');")
seed = (ROOT / 'supabase/03_seed_novels.sql').read_text(encoding='utf-8')
sql(seed[seed.index('-- Manual seed IDs must advance'):])
assert append(2, 'after-seed')['id'] > 900000
print('PASS chapter edits touch book timestamp and seeding advances the chapter sequence')

last_id = int(sql('SELECT MAX(id) FROM chuong;'))
sql(upgrade)
assert append(2, 'after-rerun')['id'] > last_id
# Also execute the complete fresh-install schema, with its actual RLS policies.
sql(schema)
assert append(2, 'after-schema')['id'] > last_id
print('PASS migration and full schema can be rerun without rewinding IDs')
print('All 8 PostgreSQL integration groups passed.')


def order_ids(book):
    return json.loads(sql(f'SELECT COALESCE(json_agg(id ORDER BY chapter_index),\'[]\'::json) FROM chuong WHERE novel_id={book};'))


def reorder(book, desired, expected, *, expect_error=False, user=OWNER):
    def array(ids):
        return 'ARRAY[' + ','.join(str(x) for x in ids) + ']::BIGINT[]'
    return sql(f'SELECT reorder_novel_chapters({book},{array(desired)},{array(expected)});',
               user=user, expect_error=expect_error)


book = create('reorder-book')['id']
append(book, 'third')
original = order_ids(book)
desired = original[1:] + original[:1]
sql(f"INSERT INTO thuat_ngu(novel_id,term,meaning,first_chapter_index) VALUES ({book},'Tên nhân vật','Giới thiệu',1);")
sql(f"INSERT INTO tom_tat_chuong(chapter_id,novel_id,chapter_index,summary) VALUES ({original[0]},{book},1,'Tóm tắt đầu');")
assert reorder(book, desired, original) == 't'
assert order_ids(book) == desired
assert sql(f'SELECT first_chapter_index FROM thuat_ngu WHERE novel_id={book};') == '3'
assert sql(f'SELECT chapter_index FROM tom_tat_chuong WHERE novel_id={book};') == '3'
assert reorder(book, desired, original) == 't'
assert sql(f'SELECT first_chapter_index FROM thuat_ngu WHERE novel_id={book};') == '3'
print('PASS reorder preserves IDs and moves recap/first-appearance indexes; retry is idempotent')

for invalid in [desired[:2], [desired[0]] * 3, [999999999] + desired[1:], [0] + desired[1:]]:
    reorder(book, invalid, desired, expect_error=True)
assert 'Thứ tự chương đã thay đổi' in reorder(book, original, original, expect_error=True)
reorder(book, original, desired, user=OTHER, expect_error=True)
assert order_ids(book) == desired
print('PASS missing/duplicate/foreign chapters, stale editor and different owner do not change order')

sql(f'''
CREATE FUNCTION fail_test_reorder() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.novel_id={book} AND NEW.chapter_index=2 THEN
    RAISE EXCEPTION 'Simulated reorder failure';
  END IF;
  RETURN NEW;
END;
$$;
CREATE TRIGGER fail_test_reorder BEFORE UPDATE OF chapter_index ON chuong
FOR EACH ROW EXECUTE FUNCTION fail_test_reorder();
''')
assert 'Simulated reorder failure' in reorder(book, original, desired, expect_error=True)
assert order_ids(book) == desired
assert sql(f'SELECT first_chapter_index FROM thuat_ngu WHERE novel_id={book};') == '3'
assert sql(f'SELECT chapter_index FROM tom_tat_chuong WHERE novel_id={book};') == '3'
assert sql(f'SELECT MIN(chapter_index) FROM chuong WHERE novel_id={book};') == '1'
sql('DROP TRIGGER fail_test_reorder ON chuong; DROP FUNCTION fail_test_reorder();')
print('PASS failure during final indexes rolls back chapter order and spoiler metadata together')

def attempt_reorder(book_id, target, before):
    try:
        reorder(book_id, target, before)
        return True
    except AssertionError as error:
        assert 'đã thay đổi' in str(error), error
        return False


for i in range(4):
    race_book = create(f'reorder-race-{i}')['id']
    append(race_book, 'third')
    baseline = order_ids(race_book)
    with ThreadPoolExecutor(max_workers=2) as pool:
        a = pool.submit(attempt_reorder, race_book, baseline[1:] + baseline[:1], baseline)
        b = pool.submit(attempt_reorder, race_book, list(reversed(baseline)), baseline)
        assert sum([a.result(), b.result()]) == 1
    assert set(order_ids(race_book)) == set(baseline)
    before_append = order_ids(race_book)
    with ThreadPoolExecutor(max_workers=2) as pool:
        a = pool.submit(attempt_reorder, race_book, list(reversed(before_append)), before_append)
        b = pool.submit(append, race_book, 'racing-append')
        a.result()
        appended = b.result()
    assert appended['id'] in order_ids(race_book)
    assert sql(f'SELECT total_chapters FROM truyen WHERE id={race_book};') == '4'
    assert sql(f'SELECT string_agg(chapter_index::text,\',\' ORDER BY chapter_index) FROM chuong WHERE novel_id={race_book};') == '1,2,3,4'
sql(reorder_upgrade)
assert reorder(book, original, desired) == 't'
print('PASS independent sessions serialize reorder/append; stale requests cannot overwrite newer order or drop chapters')
print('All 4 PostgreSQL reorder integration groups passed.')
