import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  late AppDatabase db;
  late Directory folder;
  late Database sql;
  late String sample;
  setUpAll(
    () async =>
        sample = await File('assets/data/sample_novels.json').readAsString(),
  );
  setUp(() async {
    folder = await (await Directory(
      'build/custom_novel_concurrency_tests',
    ).create(recursive: true)).createTemp('case_');
    db = AppDatabase(
      factory: databaseFactoryFfi,
      path: '${folder.path}/novels.db',
      sampleJsonLoader: () async => sample,
    );
    sql = await db.database;
  });
  tearDown(() async {
    await db.close();
    final root = Directory('build/custom_novel_concurrency_tests')
        .absolute
        .path;
    if (!folder.absolute.path.startsWith('$root${Platform.pathSeparator}')) {
      throw StateError('Unexpected test folder');
    }
    await folder.delete(recursive: true);
  });
  Future<Novel> create(
    String title, {
    List<({String title, String content})>? chapters,
    List<String>? genres,
  }) => db.insertCustomNovel(
    title: title,
    author: 'Test',
    description: '',
    status: 'ongoing',
    type: 'novel',
    genres: genres ?? const [],
    chapters: chapters ?? [(title: 'Chương 1', content: 'Nội dung $title')],
  );

  test('Concurrent imports allocate unique book and chapter IDs and preserve every chapter', () async {
    final novels = await Future.wait(
      List.generate(
        12,
        (i) => create(
          'Truyện $i',
          chapters: [
            (title: 'Chương 1', content: 'Nội dung $i/1'),
            (title: 'Chương 2', content: 'Nội dung $i/2'),
          ],
        ),
      ),
    );
    expect(novels.map((n) => n.id).toSet().length, 12);
    expect(novels.every((n) => n.id < 0 && n.totalChapters == 2), isTrue);
    final chapterIds = <int>{};
    for (var i = 0; i < novels.length; i++) {
      final chapters = await db.getChapters(novels[i].id);
      expect(chapters.map((c) => c.chapterIndex), [1, 2]);
      for (final chapter in chapters) {
        expect(chapterIds.add(chapter.id), isTrue);
        expect(chapter.id, lessThan(0));
        expect(
          (await db.getChapter(chapter.id, novelId: novels[i].id))!.content,
          'Nội dung $i/${chapter.chapterIndex}',
        );
      }
    }
    expect(chapterIds.length, 24);
  });

  test('Concurrent appends to one story keep chapter indices and total count correct', () async {
    final novel = await create('Truyện');
    final appended = await Future.wait(
      List.generate(
        20,
        (i) => db.appendChapter(
          novelId: novel.id,
          title: 'Thêm $i',
          content: 'Nội dung thêm $i',
        ),
      ),
    );
    expect(appended.map((c) => c.id).toSet().length, 20);
    expect(
      (await db.getChapters(novel.id)).map((c) => c.chapterIndex),
      List.generate(21, (i) => i + 1),
    );
    expect((await db.getNovel(novel.id))!.totalChapters, 21);
    for (var i = 0; i < appended.length; i++) {
      expect(appended[i].content, 'Nội dung thêm $i');
      expect(appended[i].title, 'Chương ${appended[i].chapterIndex}: Thêm $i');
    }
  });

  test('Imports and appends to different stories share the same safe local ID allocation', () async {
    final first = await create('Một');
    final second = await create('Hai');
    await Future.wait<Object>([
      for (var i = 0; i < 8; i++) create('Truyện mới $i'),
      for (var i = 0; i < 8; i++)
        db.appendChapter(
          novelId: i.isEven ? first.id : second.id,
          title: 'Thêm',
          content: 'Nội dung $i',
        ),
    ]);
    expect((await sql.query('truyen', where: 'id < 0')).length, 10);
    final chapters = (await sql.query(
      'chuong',
      where: 'id < 0',
    )).map(Chapter.fromMap).toList();
    expect(chapters.length, 18);
    expect(chapters.map((c) => c.id).toSet().length, 18);
    expect((await db.getNovel(first.id))!.totalChapters, 5);
    expect((await db.getNovel(second.id))!.totalChapters, 5);
  });

  test('An interrupted import or append rolls back without empty stories or partial numbering', () async {
    await sql.execute(
      "CREATE TRIGGER test_failed_content BEFORE INSERT ON chuong WHEN NEW.content = 'FAIL_WRITE' BEGIN SELECT RAISE(ABORT, 'Simulated storage failure'); END",
    );
    await expectLater(
      create(
        'Lỗi',
        chapters: const [
          (title: 'Chương 1', content: 'Nội dung'),
          (title: 'Chương 2', content: 'FAIL_WRITE'),
        ],
      ),
      throwsA(isA<DatabaseException>()),
    );
    expect(await sql.query('truyen', where: 'id < 0'), isEmpty);
    expect(await sql.query('chuong', where: 'id < 0'), isEmpty);
    final novel = await create('Giữ nguyên');
    await expectLater(
      db.appendChapter(novelId: novel.id, title: 'Lỗi', content: 'FAIL_WRITE'),
      throwsA(isA<DatabaseException>()),
    );
    expect((await db.getNovel(novel.id))!.totalChapters, 1);
    expect((await db.getChapters(novel.id)).length, 1);
    final next = await db.appendChapter(
      novelId: novel.id,
      title: '',
      content: 'Nội dung tiếp',
    );
    expect(next.chapterIndex, 2);
    expect((await db.getNovel(novel.id))!.totalChapters, 2);
  });

  test(
    'Appending after an index gap reports the actual number of chapters',
    () async {
      final novel = await create('Gián đoạn');
      await sql.update(
        'chuong',
        {'chapter_index': 5},
        where: 'novel_id = ?',
        whereArgs: [novel.id],
      );
      final added = await db.appendChapter(
        novelId: novel.id,
        title: '',
        content: 'Nội dung tiếp',
      );
      expect(added.chapterIndex, 6);
      expect((await db.getNovel(novel.id))!.totalChapters, 2);
    },
  );

  test('The content selected for import is stable while another database transaction is pending', () async {
    final started = Completer<void>();
    final release = Completer<void>();
    final blocking = sql.transaction((txn) async {
      started.complete();
      await release.future;
    });
    await started.future;
    final chapters = [(title: 'Chương 1', content: 'Nội dung đã chọn')];
    final genres = ['Fantasy'];
    final importing = create('Không đổi', chapters: chapters, genres: genres);
    chapters.clear();
    genres.clear();
    release.complete();
    await blocking;
    final novel = await importing;
    expect(novel.totalChapters, 1);
    expect(novel.genres, ['Fantasy']);
    final saved = (await db.getChapters(novel.id)).single;
    expect(
      (await db.getChapter(saved.id, novelId: novel.id))!.content,
      'Nội dung đã chọn',
    );
  });
}
