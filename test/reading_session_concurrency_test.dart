import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/database/v2_database_store.dart';
import 'package:novel_reader/models/bookmark.dart';
import 'package:novel_reader/models/library_item.dart';
import 'package:novel_reader/models/quest.dart';
import 'package:novel_reader/models/reading_history.dart';
import 'package:novel_reader/providers/library_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

typedef _Write = ({
  String userId,
  int novelId,
  int chapterId,
  int words,
  int minutes,
});

class _RecordingDatabase extends AppDatabase {
  final attempts = <_Write>[];
  final committed = <_Write>[];
  final gates = <String, Completer<void>>{};
  bool failing = false;
  @override
  Future<void> recordReadingSession({
    required int words,
    required int minutes,
    DateTime? date,
    String userId = '',
    int novelId = 0,
    int chapterId = 0,
  }) async {
    final write = (
      userId: userId,
      novelId: novelId,
      chapterId: chapterId,
      words: words,
      minutes: minutes,
    );
    attempts.add(write);
    await gates[userId]?.future;
    if (failing) throw StateError('Recording failed');
    committed.add(write);
  }

  @override
  Future<List<ReadingSessionStat>> getReadingSessions({String? userId}) async =>
      [
        ReadingSessionStat(
          dateKey: '2026-11-04',
          wordsRead: committed
              .where((w) => w.userId == userId)
              .fold(0, (sum, w) => sum + w.words),
          minutesRead: 0,
        ),
      ];
  @override
  Future<List<LibraryItem>> getLibrary({String? userId}) async => [];
  @override
  Future<List<ReadingHistory>> getHistory({String? userId}) async => [];
  @override
  Future<List<QuoteItem>> getQuotes({String? userId}) async => [];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  group('Provider session deduplication', () {
    late _RecordingDatabase db;
    late LibraryProvider library;
    setUp(() {
      db = _RecordingDatabase();
      library = LibraryProvider(db);
    });
    tearDown(() => library.dispose());

    test('Concurrent duplicate chapter callbacks commit once', () async {
      db.gates['A'] = Completer<void>();
      final first = library.recordChapterReadSession(
        10,
        'Một hai ba',
        userId: 'A',
        novelId: 1,
      );
      final second = library.recordChapterReadSession(
        10,
        'Một hai ba',
        userId: 'A',
        novelId: 1,
      );
      expect(db.attempts.length, 1);
      db.gates['A']!.complete();
      await Future.wait([first, second]);
      await library.recordChapterReadSession(
        10,
        'Một hai ba',
        userId: 'A',
        novelId: 1,
      );
      expect(db.committed.length, 1);
      expect(db.committed.single.words, 3);
    });

    test('A failed shared write can be retried once', () async {
      db.failing = true;
      db.gates['A'] = Completer<void>();
      final first = library.recordChapterReadSession(
        10,
        'Một hai',
        userId: 'A',
        novelId: 1,
      );
      final second = library.recordChapterReadSession(
        10,
        'Một hai',
        userId: 'A',
        novelId: 1,
      );
      final failures = Future.wait([
        expectLater(first, throwsStateError),
        expectLater(second, throwsStateError),
      ]);
      db.gates['A']!.complete();
      await failures;
      expect(db.committed, isEmpty);
      db.failing = false;
      await library.recordChapterReadSession(
        10,
        'Một hai',
        userId: 'A',
        novelId: 1,
      );
      expect(db.attempts.length, 2);
      expect(db.committed.length, 1);
    });

    test(
      'Novel/user keys stay distinct and image tags are not counted as words',
      () async {
        await library.recordChapterReadSession(
          10,
          'Một [img]data:image/png;base64,AAAA[/img] hai',
          userId: 'A',
          novelId: 1,
        );
        await library.recordChapterReadSession(
          10,
          'Ba',
          userId: 'A',
          novelId: 2,
        );
        await library.recordChapterReadSession(
          10,
          'Bốn',
          userId: 'B',
          novelId: 1,
        );
        expect(db.committed.length, 3);
        expect(db.committed.first.words, 2);
      },
    );

    test(
      'An old account completion cannot suppress a new account session',
      () async {
        library.bindUser('A');
        await library.load();
        db.gates['A'] = Completer<void>();
        final first = library.recordChapterReadSession(
          10,
          'Một hai',
          userId: 'A',
          novelId: 1,
        );
        library.bindUser('B');
        await library.load();
        await library.recordChapterReadSession(
          10,
          'Một hai ba bốn',
          userId: 'B',
          novelId: 1,
        );
        db.gates['A']!.complete();
        await first;
        expect(library.totalWordsRead, 4);
        await library.recordChapterReadSession(
          10,
          'Một hai ba bốn',
          userId: 'B',
          novelId: 1,
        );
        expect(db.committed.length, 2);
      },
    );

    test(
      'A stale reader callback cannot record against a different bound user',
      () async {
        library.bindUser('B');
        await library.load();
        await library.recordChapterReadSession(
          10,
          'Một hai',
          userId: 'A',
          novelId: 1,
        );
        expect(db.attempts, isEmpty);
      },
    );
  });

  group('Atomic local statistics', () {
    late AppDatabase db;
    late Directory folder;
    late Database sql;
    setUp(() async {
      folder = await (await Directory(
        'build/session_concurrency_tests',
      ).create(recursive: true)).createTemp('case_');
      final sample = await File('assets/data/sample_novels.json')
          .readAsString();
      db = AppDatabase(
        factory: databaseFactoryFfi,
        path: '${folder.path}/stats.db',
        sampleJsonLoader: () async => sample,
      );
      sql = await db.database;
      final now = DateTime.now();
      for (final (id, type) in [
        (9001, 'read_minutes'),
        (9002, 'read_chapters'),
      ]) {
        await sql.insert(
          'nhiem_vu',
          Quest(
            id: id,
            type: 'event',
            title: 'Test',
            goalType: type,
            goalValue: 300,
            reward: 1,
            startsAt: now.subtract(const Duration(days: 1)),
            endsAt: now.add(const Duration(days: 1)),
          ).toMap(),
        );
      }
    });
    tearDown(() async {
      await db.close();
      final root = Directory('build/session_concurrency_tests').absolute.path;
      if (!folder.absolute.path.startsWith('$root${Platform.pathSeparator}')) {
        throw StateError('Unexpected test folder');
      }
      await folder.delete(recursive: true);
    });

    test(
      'Concurrent session writes preserve every daily increment and log',
      () async {
        await Future.wait(
          List.generate(
            20,
            (i) => db.recordReadingSession(
              words: 3,
              minutes: 2,
              novelId: 1,
              chapterId: i + 1,
            ),
          ),
        );
        for (final table in ['phien_doc', 'phien_doc_cuc_bo']) {
          final row = (await sql.query(table)).single;
          expect(row['words_read'], 60);
          expect(row['minutes_read'], 40);
        }
        expect((await sql.query('nhat_ky_phien_doc')).length, 20);
      },
    );

    test('Concurrent sessions count a chapter once per quest window', () async {
      await Future.wait(
        List.generate(
          20,
          (_) => db.recordReadingSession(
            words: 1,
            minutes: 1,
            userId: '3',
            novelId: 1,
            chapterId: 10001,
          ),
        ),
      );
      final progress = await V2DatabaseStore.getUserQuests(sql, '3');
      expect(progress[9001]!.progress, 20);
      expect(progress[9002]!.progress, 1);
    });

    test(
      'Concurrent quest increments retain totals and honor claimed status',
      () async {
        await Future.wait(
          List.generate(
            40,
            (_) => V2DatabaseStore.incrementQuestProgress(
              sql,
              userId: '3',
              goalType: 'read_minutes',
              delta: 1,
              questIds: {9001},
            ),
          ),
        );
        expect(
          (await V2DatabaseStore.getUserQuests(sql, '3'))[9001]!.progress,
          40,
        );
        await sql.update(
          'nhiem_vu_nguoi_dung',
          {'claimed': 1},
          where: 'user_id = ? AND quest_id = ?',
          whereArgs: ['3', 9001],
        );
        await V2DatabaseStore.incrementQuestProgress(
          sql,
          userId: '3',
          goalType: 'read_minutes',
          delta: 5,
          questIds: {9001},
        );
        expect(
          (await V2DatabaseStore.getUserQuests(sql, '3'))[9001]!.progress,
          40,
        );
      },
    );
  });
}
