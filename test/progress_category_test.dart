import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/models/bookmark.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/models/library_item.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/models/reading_history.dart';
import 'package:novel_reader/providers/library_provider.dart';

Novel novel(String uid) => Novel(
  id: 7001,
  title: 'Truyện $uid',
  author: '',
  coverUrl: '',
  description: '',
  status: 'ongoing',
  type: 'novel',
  genres: const [],
  totalChapters: 5,
  rating: 0,
  views: 0,
  updatedAt: DateTime(2026),
);
const chapter = Chapter(
  id: 70012,
  novelId: 7001,
  chapterIndex: 2,
  title: 'Chương 2',
);

class _Database extends AppDatabase {
  final items = <String, LibraryItem>{
    for (final uid in ['A', 'B'])
      uid: LibraryItem(
        novelId: 7001,
        category: 'want',
        addedAt: DateTime(2026),
        novel: novel(uid),
      ),
  };
  final history = <String, ReadingHistory>{};
  final changes = <String>[];
  final replies = <String, Completer<void>>{};
  final started = Completer<void>();
  bool failCategory = false;
  bool failHistory = false;
  Completer<void>? removeReply;
  final removeStarted = Completer<void>();
  @override
  Future<List<LibraryItem>> getLibrary({String? userId}) async => [
    ?items[userId],
  ];
  @override
  Future<List<ReadingHistory>> getHistory({String? userId}) async => [
    ?history[userId],
  ];
  @override
  Future<void> removeFromLibrary(int id, {String? userId}) async {
    removeStarted.complete();
    await removeReply?.future;
    items.remove(userId);
  }

  @override
  Future<List<QuoteItem>> getQuotes({String? userId}) async => [];
  @override
  Future<List<ReadingSessionStat>> getReadingSessions({String? userId}) async =>
      [];
  @override
  Future<void> saveHistory(ReadingHistory value, {String? userId}) async {
    if (failHistory) throw StateError('SQLite unavailable');
    history[userId!] = value;
  }

  @override
  Future<void> upsertLibrary(LibraryItem value, {String? userId}) async {
    changes.add(userId!);
    if (!started.isCompleted) started.complete();
    await replies[userId]?.future;
    if (failCategory) throw StateError('Network unavailable');
    items[userId] = value;
  }
}

Future<void> reading(LibraryProvider library) {
  final result = Completer<void>();
  void observe() {
    if (library.categoryOf(7001) == 'reading' && !result.isCompleted) {
      result.complete();
    }
  }

  library.addListener(observe);
  observe();
  return result.future
      .timeout(const Duration(seconds: 5))
      .whenComplete(() => library.removeListener(observe));
}

void main() {
  late _Database db;
  late LibraryProvider library;
  setUp(() async {
    db = _Database();
    library = LibraryProvider(db)..bindUser('A');
    await library.load();
  });
  tearDown(() => library.dispose());

  test(
    'Optional category failure cannot reject progress or retry on each scroll',
    () async {
      db.failCategory = true;
      var notifications = 0;
      library.addListener(() => notifications++);
      await library.saveProgress(novel('A'), chapter, .4);
      await Future<void>.delayed(Duration.zero);
      expect(db.history['A']!.scrollOffset, .4);
      expect(library.historyFor(7001)!.scrollOffset, .4);
      expect(library.items.single.progress, .4);
      expect(library.categoryOf(7001), 'want');
      expect(notifications, greaterThan(0));
      await library.saveProgress(novel('A'), chapter, .7);
      await Future<void>.delayed(Duration.zero);
      expect(db.changes, ['A']);
      expect(db.history['A']!.scrollOffset, .7);

      db.failCategory = false;
      await library.load();
      await library.saveProgress(novel('A'), chapter, .8);
      await reading(library);
      expect(db.changes, ['A', 'A']);
      expect(library.historyFor(7001)!.scrollOffset, .8);
    },
  );

  test(
    'An unanswered category request cannot block the next local progress save',
    () async {
      db.replies['A'] = Completer<void>();
      await library
          .saveProgress(novel('A'), chapter, .2)
          .timeout(const Duration(seconds: 1));
      await db.started.future;
      await library
          .saveProgress(novel('A'), chapter, .9)
          .timeout(const Duration(seconds: 1));
      expect(db.history['A']!.scrollOffset, .9);
      expect(library.historyFor(7001)!.scrollOffset, .9);
      expect(db.changes, ['A']);
      final moved = reading(library);
      db.replies['A']!.complete();
      await moved;
      expect(library.items.single.progress, .4);
      expect(library.historyFor(7001)!.scrollOffset, .9);
    },
  );

  test(
    'Saving progress cannot re-add a book while the user removes it',
    () async {
      db.failCategory = true;
      await library.saveProgress(novel('A'), chapter, .2);
      await Future<void>.delayed(Duration.zero);
      db.removeReply = Completer<void>();
      final removal = library.remove(7001);
      await db.removeStarted.future;
      await library.load();
      await library.saveProgress(novel('A'), chapter, .8);
      db.removeReply!.complete();
      await removal;
      expect(db.changes, ['A']);
      expect(library.items, isEmpty);
      expect(library.historyFor(7001)!.scrollOffset, .8);
    },
  );

  test(
    'Actual local save failures remain visible and do not change history UI',
    () async {
      db.failHistory = true;
      await expectLater(
        library.saveProgress(novel('A'), chapter, .4),
        throwsStateError,
      );
      expect(library.historyFor(7001), isNull);
      expect(library.items.single.progress, 0);
      expect(db.changes, isEmpty);
    },
  );

  test(
    'A previous account background transition cannot update the new account UI',
    () async {
      db.replies['A'] = Completer<void>();
      await library.saveProgress(novel('A'), chapter, .2);
      await db.started.future;
      library.bindUser('B');
      await library.load();
      await library.saveProgress(novel('B'), chapter, .8);
      await reading(library);
      db.replies['A']!.complete();
      await Future<void>.delayed(Duration.zero);
      expect(db.changes, ['A', 'B']);
      expect(library.items.single.novel!.title, 'Truyện B');
      expect(library.historyFor(7001)!.scrollOffset, .8);
      expect(db.history['A']!.scrollOffset, .2);
    },
  );
}
