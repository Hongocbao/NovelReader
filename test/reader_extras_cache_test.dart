import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/models/chapter_summary.dart';
import 'package:novel_reader/models/glossary_term.dart';
import 'package:novel_reader/providers/reader_provider.dart';
import 'package:novel_reader/repositories/reader_extras_source.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

GlossaryTerm term(int book, int index, [String? text]) => GlossaryTerm(
  id: index,
  novelId: book,
  term: text ?? 'Thuật ngữ $index',
  meaning: 'Nghĩa $index',
  firstChapterIndex: index,
);
ChapterSummary summary(int book, int index) => ChapterSummary(
  chapterId: book * 100 + index,
  novelId: book,
  chapterIndex: index,
  summary: 'Tóm tắt $index',
);

class _Remote implements ReaderExtrasRemote {
  @override
  String extrasUserId = 'reader-a';
  bool offline = false;
  int calls = 0;
  List<GlossaryTerm> terms = [term(1, 1), term(1, 2), term(1, 4), term(99, 1)];
  List<ChapterSummary> summaries = [
    for (var i = 1; i <= 5; i++) summary(1, i),
    summary(99, 1),
  ];
  Completer<List<GlossaryTerm>>? delayed;
  Completer<void>? requested;
  @override
  Future<List<GlossaryTerm>> getReaderGlossary(
    int novelId,
    int chapterIndex,
  ) async {
    calls++;
    requested?.complete();
    if (offline) throw StateError('Mất mạng giả lập');
    return delayed != null ? delayed!.future : terms;
  }

  @override
  Future<List<ChapterSummary>> getReaderSummaries(
    int novelId,
    int chapterIndex,
  ) async {
    calls++;
    if (offline) throw StateError('Mất mạng giả lập');
    return summaries;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  late Directory folder;
  late AppDatabase db;
  late _Remote remote;
  late String sample;
  AppDatabase create() => AppDatabase(
    factory: databaseFactoryFfi,
    path: '${folder.path}/reader.db',
    extrasRemote: remote,
    sampleJsonLoader: () async => sample,
  );
  setUpAll(
    () async =>
        sample = await File('assets/data/sample_novels.json').readAsString(),
  );
  setUp(() async {
    folder = await (await Directory(
      'build/reader_extras_tests',
    ).create(recursive: true)).createTemp('case_');
    remote = _Remote();
    db = create();
    await db.database;
  });
  tearDown(() async {
    await db.close();
    final root = await Directory('build/reader_extras_tests')
        .resolveSymbolicLinks();
    final target = await folder.resolveSymbolicLinks();
    expect(target.startsWith('$root${Platform.pathSeparator}'), isTrue);
    await folder.delete(recursive: true);
  });

  test(
    'Cloud extras are bounded by book/chapter and survive reopening offline',
    () async {
      final terms = await db.getGlossaryForReader(1, 3, version: 10);
      final summaries = await db.getSummariesForReader(1, 3, version: 10);
      expect(terms.items.map((t) => t.firstChapterIndex), [1, 2]);
      expect(terms.fromCache, isFalse);
      expect(summaries.items.map((s) => s.chapterIndex), [3, 2, 1]);
      await db.close();
      db = create();
      remote.offline = true;
      final cached = await db.getGlossaryForReader(1, 3, version: 10);
      expect(cached.items.map((t) => t.term), ['Thuật ngữ 1', 'Thuật ngữ 2']);
      expect(cached.fromCache, isTrue);
      expect(
        (await db.getSummariesForReader(1, 3, version: 10)).fromCache,
        isTrue,
      );
    },
  );

  test('A successful empty response replaces old cached extras', () async {
    await db.getGlossaryForReader(1, 3);
    await db.getSummariesForReader(1, 3);
    remote.terms = [];
    remote.summaries = [];
    expect((await db.getGlossaryForReader(1, 3)).items, isEmpty);
    expect((await db.getSummariesForReader(1, 3)).items, isEmpty);
    remote.offline = true;
    expect((await db.getGlossaryForReader(1, 3)).items, isEmpty);
    expect((await db.getSummariesForReader(1, 3)).items, isEmpty);
  });

  test('Offline cache never crosses account, guest, book version, or chapter boundary', () async {
    await db.getGlossaryForReader(1, 4, version: 10);
    remote.offline = true;
    await expectLater(
      db.getGlossaryForReader(1, 1, version: 10),
      throwsStateError,
    );
    await expectLater(
      db.getGlossaryForReader(1, 4, version: 11),
      throwsStateError,
    );
    for (final uid in ['reader-b', '']) {
      remote.extrasUserId = uid;
      await expectLater(
        db.getGlossaryForReader(1, 4, version: 10),
        throwsStateError,
      );
    }
    remote.extrasUserId = 'reader-a';
    expect(
      (await db.getGlossaryForReader(1, 4, version: 10)).items,
      hasLength(3),
    );
  });

  test('Concurrent loads share a request and forced offline does not contact the server', () async {
    await db.getGlossaryForReader(1, 2);
    remote.delayed = Completer<List<GlossaryTerm>>();
    remote.requested = Completer<void>();
    final first = db.getGlossaryForReader(1, 2);
    final second = db.getGlossaryForReader(1, 2);
    await remote.requested!.future;
    expect(remote.calls, 2);
    final offline = await db.getGlossaryForReader(1, 2, offline: true);
    expect(offline.fromCache, isTrue);
    expect(remote.calls, 2);
    remote.delayed!.complete([term(1, 1, 'Đã cập nhật')]);
    expect((await first).items.single.term, 'Đã cập nhật');
    expect((await second).items.single.term, 'Đã cập nhật');
  });

  test('A late response after account change is not returned or cached for the new reader', () async {
    await db.getGlossaryForReader(1, 2);
    remote.delayed = Completer<List<GlossaryTerm>>();
    remote.requested = Completer<void>();
    final pending = db.getGlossaryForReader(1, 2);
    final expectation = expectLater(pending, throwsStateError);
    await remote.requested!.future;
    remote.extrasUserId = 'reader-b';
    remote.delayed!.complete([term(1, 1, 'Phản hồi cũ')]);
    await expectation;
    await expectLater(
      db.getGlossaryForReader(1, 2, offline: true),
      throwsStateError,
    );
    remote.extrasUserId = 'reader-a';
    expect(
      (await db.getGlossaryForReader(1, 2, offline: true)).items.first.term,
      'Thuật ngữ 1',
    );
  });

  test('Cache keeps only recent boundaries and does not substitute sample data for missing cloud cache', () async {
    for (var index = 1; index <= 25; index++) {
      await db.getGlossaryForReader(1, index);
    }
    final sql = await db.database;
    expect(
      (await sql.rawQuery(
        "SELECT COUNT(*) FROM bo_dem_ho_tro_doc WHERE kind='glossary'",
      )).single.values.single,
      20,
    );
    await expectLater(
      db.getGlossaryForReader(1, 1, offline: true),
      throwsStateError,
    );
    expect(
      (await db.getGlossaryForReader(1, 25, offline: true)).items,
      hasLength(3),
    );
    remote.extrasUserId = 'new-reader';
    remote.offline = true;
    await expectLater(db.getGlossaryForReader(1, 1), throwsStateError);
  });

  test('Imported local novels retain their own glossary and summaries without cloud IO', () async {
    final book = await db.insertCustomNovel(
      title: 'Truyện riêng',
      author: 'Tác giả',
      description: '',
      status: 'ongoing',
      type: 'novel',
      genres: const [],
      chapters: [(title: 'Chương 1', content: 'Nội dung')],
    );
    final sql = await db.database;
    final chapters = await db.getChapters(book.id);
    await sql.insert(
      'thuat_ngu',
      term(book.id, 1, 'Thuật ngữ riêng').toMap()..remove('id'),
    );
    await sql.insert(
      'tom_tat_chuong',
      summary(book.id, 1).toMap()..['chapter_id'] = chapters.single.id,
    );
    expect(
      (await db.getGlossaryForReader(book.id, 1)).items.single.term,
      'Thuật ngữ riêng',
    );
    expect(
      (await db.getSummariesForReader(book.id, 1)).items.single.summary,
      'Tóm tắt 1',
    );
    expect(remote.calls, 0);
  });

  test(
    'Reader force-offline uses extras cache without another remote request',
    () async {
      await db.getGlossaryForReader(1, 2);
      final reader = ReaderProvider(db)..forceOffline = true;
      addTearDown(reader.dispose);
      final before = remote.calls;
      expect((await reader.getGlossaryForReader(1, 2)).fromCache, isTrue);
      expect(remote.calls, before);
      expect((await reader.getGlossaryForReader(1, 0)).items, isEmpty);
    },
  );
}
