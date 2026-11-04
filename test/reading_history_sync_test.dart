import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/database/reading_history_cache.dart';
import 'package:novel_reader/models/bookmark.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/models/library_item.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/models/reading_history.dart';
import 'package:novel_reader/providers/library_provider.dart';
import 'package:novel_reader/repositories/reading_history_remote.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Novel _novel(int id) => Novel(
  id: id,
  title: 'Truyện $id',
  author: 'Tác giả',
  coverUrl: '',
  description: 'Giới thiệu',
  status: 'ongoing',
  type: 'novel',
  genres: const [],
  totalChapters: 5,
  rating: 4,
  views: 1,
  updatedAt: DateTime(2026),
);

ReadingHistory _history({
  int novelId = 7001,
  int time = 100,
  double offset = .4,
}) => ReadingHistory(
  novelId: novelId,
  lastChapterId: novelId * 10,
  scrollOffset: offset,
  lastReadAt: DateTime.fromMillisecondsSinceEpoch(time),
  novel: _novel(novelId),
  chapterIndex: 2,
  chapterTitle: 'Chương hai',
);

class _HistoryRemote implements ReadingHistoryRemote {
  final accounts = <String, Map<int, ReadingHistory>>{};
  bool offline = false;
  int requests = 0;
  Future<void> Function()? beforeSave;
  Future<void> Function()? beforeRead;

  Map<int, ReadingHistory> _account(String? userId) {
    requests++;
    if (offline) throw StateError('Mất mạng giả lập');
    if (userId == null || userId.isEmpty) {
      throw StateError('Khách không được gửi yêu cầu lịch sử cloud');
    }
    return accounts.putIfAbsent(userId, () => {});
  }

  @override
  Future<List<ReadingHistory>> getHistory({String? userId}) async {
    final snapshot = _account(userId).values.toList();
    await beforeRead?.call();
    return snapshot;
  }

  @override
  Future<ReadingHistory?> getHistoryFor(int novelId, {String? userId}) async =>
      _account(userId)[novelId];

  @override
  Future<void> saveHistories(
    List<ReadingHistory> histories, {
    String? userId,
  }) async {
    final account = _account(userId);
    await beforeSave?.call();
    for (final history in histories) {
      account[history.novelId] = history;
    }
  }

  @override
  Future<void> deleteHistory(int novelId, {String? userId}) async {
    _account(userId).remove(novelId);
  }

  @override
  Future<void> clearHistory({String? userId}) async => _account(userId).clear();
}

class _LibraryDatabase extends AppDatabase {
  final historyRequests = <String?>[];
  final firstLoad = Completer<List<LibraryItem>>();
  final firstLoadStarted = Completer<void>();
  Completer<void>? saveReply;
  final saveStarted = Completer<void>();
  String? savedUserId;

  @override
  Future<List<LibraryItem>> getLibrary({String? userId}) async {
    if (userId == 'A' && !firstLoad.isCompleted) {
      if (!firstLoadStarted.isCompleted) firstLoadStarted.complete();
      return firstLoad.future;
    }
    return [];
  }

  @override
  Future<List<ReadingHistory>> getHistory({String? userId}) async {
    historyRequests.add(userId);
    return userId == 'A'
        ? [_history()]
        : userId == 'B'
        ? [_history(novelId: 8001)]
        : [];
  }

  @override
  Future<List<QuoteItem>> getQuotes({String? userId}) async => [];

  @override
  Future<List<ReadingSessionStat>> getReadingSessions({String? userId}) async =>
      [];

  @override
  Future<void> saveHistory(ReadingHistory history, {String? userId}) async {
    savedUserId = userId;
    if (!saveStarted.isCompleted) saveStarted.complete();
    await saveReply?.future;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  late Database db;
  late _HistoryRemote remote;
  late ReadingHistoryCache cache;

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(singleInstance: false),
    );
    await ReadingHistoryCache.ensureSchema(db);
    remote = _HistoryRemote();
    cache = ReadingHistoryCache(db, remote);
  });

  tearDown(() async {
    await cache.waitForPendingSync();
    await db.close();
  });

  test(
    'Offline history survives a new cache instance with book/chapter metadata',
    () async {
      remote.offline = true;
      await cache.save(_history(), 'A');
      await cache.waitForPendingSync();
      final reopened = ReadingHistoryCache(db, remote);
      final saved = (await reopened.load('A', novelId: 7001)).single;
      expect(saved.scrollOffset, .4);
      expect(saved.novel!.title, 'Truyện 7001');
      expect(saved.chapterIndex, 2);
      expect(saved.chapterTitle, 'Chương hai');
    },
  );

  test(
    'Reconnect uploads pending progress and keeps the newer reading timestamp',
    () async {
      remote.offline = true;
      await cache.save(_history(time: 200), 'A');
      await cache.waitForPendingSync();
      remote.offline = false;
      remote.accounts['A'] = {7001: _history(time: 100, offset: .1)};
      expect((await cache.load('A')).single.scrollOffset, .4);
      expect(
        remote.accounts['A']![7001]!.lastReadAt.millisecondsSinceEpoch,
        200,
      );

      remote.offline = true;
      await cache.save(_history(time: 300, offset: .5), 'A');
      await cache.waitForPendingSync();
      remote.offline = false;
      remote.accounts['A']![7001] = _history(time: 400, offset: .8);
      expect((await cache.load('A')).single.scrollOffset, .8);
      expect(remote.accounts['A']![7001]!.scrollOffset, .8);
    },
  );

  test(
    'A delayed save cannot block newer local progress or acknowledge it early',
    () async {
      final started = Completer<void>();
      final reply = Completer<void>();
      remote.beforeSave = () async {
        if (!started.isCompleted) {
          started.complete();
          await reply.future;
        }
      };
      await cache.save(_history(time: 100, offset: .1), 'A');
      await started.future;
      await cache.save(_history(time: 200, offset: .9), 'A');
      final local = (await db.query(ReadingHistoryCache.table)).single;
      expect(local['scroll_offset'], .9);
      expect(local['pending'], 1);
      reply.complete();
      await cache.waitForPendingSync();
      expect(remote.accounts['A']![7001]!.scrollOffset, .9);
      expect((await cache.load('A')).single.scrollOffset, .9);
    },
  );

  test(
    'Account and guest histories stay separate and guest never contacts cloud',
    () async {
      remote.offline = true;
      await cache.save(_history(offset: .2), 'A');
      await cache.save(_history(offset: .6), 'B');
      await cache.waitForPendingSync();
      final requestsBefore = remote.requests;
      await cache.save(_history(offset: .8), '');
      expect((await cache.load('')).single.scrollOffset, .8);
      expect(remote.requests, requestsBefore);
      expect((await cache.load('A')).single.scrollOffset, .2);
      expect((await cache.load('B')).single.scrollOffset, .6);
    },
  );

  test(
    'A delayed cloud read cannot overwrite progress saved while it was loading',
    () async {
      await cache.save(_history(time: 100, offset: .1), 'A');
      await cache.waitForPendingSync();
      final started = Completer<void>();
      final reply = Completer<void>();
      remote.beforeRead = () async {
        started.complete();
        await reply.future;
      };
      final loading = cache.load('A');
      await started.future;
      await cache.save(_history(time: 200, offset: .9), 'A');
      reply.complete();
      expect((await loading).single.scrollOffset, .9);
      await cache.waitForPendingSync();
      expect(remote.accounts['A']![7001]!.scrollOffset, .9);
    },
  );

  test('Clearing history after a delayed save cannot resurrect it or erase another account', () async {
    final started = Completer<void>();
    final reply = Completer<void>();
    await cache.save(_history(offset: .6), 'B');
    await cache.waitForPendingSync();
    remote.beforeSave = () async {
      started.complete();
      await reply.future;
    };
    await cache.save(_history(), 'A');
    await started.future;
    final cleared = cache.clear('A');
    reply.complete();
    await cleared;
    expect(await cache.load('A'), isEmpty);
    expect(remote.accounts['A'], isEmpty);
    expect((await cache.load('B')).single.scrollOffset, .6);
  });

  test('Failed deletion retains history; successful cloud deletion also removes local cache', () async {
    await cache.save(_history(), 'A');
    await cache.waitForPendingSync();
    remote.offline = true;
    await expectLater(cache.remove(7001, 'A'), throwsStateError);
    expect((await cache.load('A')).single.novelId, 7001);
    remote.offline = false;
    await cache.remove(7001, 'A');
    expect(await cache.load('A'), isEmpty);
    await cache.save(_history(), 'A');
    await cache.waitForPendingSync();
    remote.accounts['A']!.clear();
    expect(await cache.load('A'), isEmpty);
  });

  test('AppDatabase caches cloud-only IDs and backup restores into the selected account', () async {
    final sampleJson = await File('assets/data/sample_novels.json')
        .readAsString();
    final appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
      historyRemote: remote,
      sampleJsonLoader: () async => sampleJson,
    );
    remote.offline = true;
    try {
      await appDb.saveHistory(_history(), userId: 'A');
      await appDb.saveHistory(_history(novelId: 8001), userId: 'B');
      expect(
        (await appDb.getHistory(userId: 'A')).single.novel!.title,
        'Truyện 7001',
      );
      final backup = await appDb.exportUserBackupJson(userId: 'A');
      final rows =
          (jsonDecode(backup) as Map)['cached_reading_history'] as List;
      expect(rows.single['novel_id'], 7001);
      expect(rows.single.containsKey('user_id'), isFalse);
      await appDb.importUserBackupJson(backup, userId: '');
      expect((await appDb.getHistoryFor(7001, userId: ''))!.scrollOffset, .4);
      expect((await appDb.getHistory(userId: 'B')).single.novelId, 8001);
      await appDb.clearHistory(userId: '');
      expect(await appDb.getHistory(userId: ''), isEmpty);
      expect((await appDb.getHistory(userId: 'A')).single.novelId, 7001);
    } finally {
      await appDb.close();
    }
  });

  test('Switching accounts reloads library and ignores the previous account response', () async {
    final database = _LibraryDatabase();
    final library = LibraryProvider(database);
    try {
      library.bindUser('A');
      await database.firstLoadStarted.future;
      library.bindUser('B');
      await library.load();
      expect(library.history.single.novelId, 8001);
      database.firstLoad.complete([]);
      await Future<void>.delayed(Duration.zero);
      expect(library.history.single.novelId, 8001);
      library.bindUser('');
      await library.load();
      expect(library.history, isEmpty);
      expect(library.isLoaded, isTrue);
    } finally {
      library.dispose();
    }
  });

  test(
    'A save started before account switch cannot populate the next account UI',
    () async {
      final database = _LibraryDatabase()..firstLoad.complete([]);
      final library = LibraryProvider(database);
      try {
        library.bindUser('A');
        await library.load();
        database.saveReply = Completer<void>();
        final save = library.saveProgress(
          _novel(7001),
          const Chapter(
            id: 70010,
            novelId: 7001,
            chapterIndex: 2,
            title: 'Chương hai',
          ),
          .9,
        );
        await database.saveStarted.future;
        library.bindUser('B');
        await library.load();
        database.saveReply!.complete();
        await save;
        expect(database.savedUserId, 'A');
        expect(library.history.single.novelId, 8001);
      } finally {
        library.dispose();
      }
    },
  );

  test('History restore keeps newer/acknowledged progress and scopes newer imports to the selected account', () async {
    remote.offline = true;
    await cache.save(_history(time: 200, offset: .8), 'A');
    await cache.save(_history(time: 500, offset: .5), 'B');
    await cache.waitForPendingSync();
    Map<String, dynamic> row(int time, double offset) => {
      ..._history(time: time, offset: offset).toMap(),
      'novel_json': jsonEncode(_novel(7001).toMap()),
      'chapter_index': 2,
      'chapter_title': 'Chương hai',
    };
    await db.transaction(
      (txn) => ReadingHistoryCache.restore(txn, [row(100, .1)], 'A'),
    );
    expect((await cache.load('A', novelId: 7001)).single.scrollOffset, .8);
    await db.transaction(
      (txn) => ReadingHistoryCache.restore(txn, [row(300, .3)], 'A'),
    );
    expect((await cache.load('A', novelId: 7001)).single.scrollOffset, .3);
    expect((await cache.load('B', novelId: 7001)).single.scrollOffset, .5);
    await db.update(
      ReadingHistoryCache.table,
      {'pending': 0},
      where: 'user_id = ?',
      whereArgs: ['A'],
    );
    await db.transaction(
      (txn) => ReadingHistoryCache.restore(txn, [row(300, .1)], 'A'),
    );
    final saved = (await db.query(
      ReadingHistoryCache.table,
      where: 'user_id = ?',
      whereArgs: ['A'],
    )).single;
    expect(saved['scroll_offset'], .3);
    expect(saved['pending'], 0);
  });

  test('Reconnecting retries the current account library once', () async {
    final database = _LibraryDatabase()..firstLoad.complete([]);
    final library = LibraryProvider(database);
    try {
      library.bindUser('A');
      library.updateConnectivity(true);
      await library.load();
      final before = database.historyRequests.length;
      library.updateConnectivity(false);
      library.updateConnectivity(true);
      library.updateConnectivity(true);
      await Future<void>.delayed(Duration.zero);
      expect(database.historyRequests.length, before + 1);
      expect(database.historyRequests.last, 'A');
      expect(library.history.single.novelId, 7001);
    } finally {
      library.dispose();
    }
  });
}
