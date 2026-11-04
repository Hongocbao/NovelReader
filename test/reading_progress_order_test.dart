import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/models/bookmark.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/models/library_item.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/models/reading_history.dart';
import 'package:novel_reader/providers/library_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _Database extends AppDatabase {
  Completer<void>? oldSave;
  final writes = <ReadingHistory>[];
  @override
  Future<void> saveHistory(ReadingHistory history, {String? userId}) async {
    writes.add(history);
    if (history.scrollOffset == .2) await oldSave?.future;
  }

  @override
  Future<List<LibraryItem>> getLibrary({String? userId}) async => [];
  @override
  Future<List<ReadingHistory>> getHistory({String? userId}) async => [];
  @override
  Future<List<QuoteItem>> getQuotes({String? userId}) async => [];
  @override
  Future<List<ReadingSessionStat>> getReadingSessions({String? userId}) async =>
      [];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  final novel = Novel(
    id: 1,
    title: 'Test',
    author: 'Test',
    coverUrl: '',
    description: '',
    status: 'ongoing',
    type: 'novel',
    genres: const [],
    totalChapters: 1,
    rating: 0,
    views: 0,
    updatedAt: DateTime(2026),
  );
  const chapter = Chapter(
    id: 11,
    novelId: 1,
    chapterIndex: 1,
    title: 'Chương 1',
  );

  test(
    'Progress timestamps preserve strict event order within one millisecond',
    () {
      final library = LibraryProvider(_Database());
      final times = List.generate(100, (_) => library.captureProgressTime());
      for (var i = 1; i < times.length; i++) {
        expect(times[i].isAfter(times[i - 1]), isTrue);
      }
      library.dispose();
    },
  );

  test('Late progress saves and old queued events cannot replace a newer position in memory', () async {
    final db = _Database()..oldSave = Completer<void>();
    final library = LibraryProvider(db)..bindUser('A');
    try {
      await library.load();
      final firstTime = library.captureProgressTime();
      final laterTime = library.captureProgressTime();
      final first = library.saveProgress(
        novel,
        chapter,
        .2,
        readAt: firstTime,
        userId: 'A',
      );
      await library.saveProgress(
        novel,
        chapter,
        .8,
        readAt: laterTime,
        userId: 'A',
      );
      db.oldSave!.complete();
      await first;
      expect(library.historyFor(1)!.scrollOffset, .8);
      await library.saveProgress(
        novel,
        chapter,
        .1,
        readAt: firstTime,
        userId: 'A',
      );
      expect(db.writes.length, 2);
      expect(library.historyFor(1)!.scrollOffset, .8);
      library.bindUser('B');
      await library.load();
      await library.saveProgress(novel, chapter, .3, userId: 'A');
      expect(db.writes.length, 2);
      expect(library.history, isEmpty);
    } finally {
      library.dispose();
    }
  });

  test(
    'SQLite rejects older imported-story progress, including after reopening',
    () async {
      final sample = await File('assets/data/sample_novels.json')
          .readAsString();
      final folder = await (await Directory(
        'build/progress_order_tests',
      ).create(recursive: true)).createTemp('case_');
      final db = AppDatabase(
        factory: databaseFactoryFfi,
        path: '${folder.path}/progress.db',
        sampleJsonLoader: () async => sample,
      );
      try {
        final book = await db.insertCustomNovel(
          title: 'Test',
          author: 'Test',
          description: '',
          status: 'ongoing',
          type: 'novel',
          genres: const [],
          chapters: const [(title: 'Chương 1', content: 'Nội dung')],
        );
        final chapters = await db.getChapters(book.id);
        ReadingHistory history(int timestamp, double offset) => ReadingHistory(
          novelId: book.id,
          lastChapterId: chapters.single.id,
          scrollOffset: offset,
          lastReadAt: DateTime.fromMillisecondsSinceEpoch(timestamp),
        );
        await db.saveHistory(history(2000, .8));
        await db.saveHistory(history(1000, .2));
        expect((await db.getHistoryFor(book.id))!.scrollOffset, .8);
        await db.close();
        expect((await db.getHistoryFor(book.id))!.scrollOffset, .8);
      } finally {
        await db.close();
        final root = Directory('build/progress_order_tests').absolute.path;
        if (!folder.absolute.path.startsWith(
          '$root${Platform.pathSeparator}',
        )) {
          throw StateError('Unexpected test folder');
        }
        await folder.delete(recursive: true);
      }
    },
  );
}
