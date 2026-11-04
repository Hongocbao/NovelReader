import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/models/library_item.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/models/reading_history.dart';
import 'package:novel_reader/providers/library_provider.dart';
import 'package:novel_reader/repositories/library_remote.dart';
import 'package:novel_reader/repositories/reading_history_remote.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _Remote implements LibraryRemote {
  final accounts = <String, Map<int, LibraryItem>>{};
  bool offline = false;
  int requests = 0;
  Completer<void>? readStarted;
  Completer<void>? readReply;
  Map<int, LibraryItem> account(String? uid) {
    requests++;
    if (uid == null || uid.isEmpty) throw StateError('Guest must stay local');
    if (offline) throw StateError('Offline');
    return accounts.putIfAbsent(uid, () => {});
  }

  @override
  Future<List<LibraryItem>> getLibrary({String? userId}) async {
    final rows = account(userId).values.toList();
    if (readStarted != null && !readStarted!.isCompleted) {
      readStarted!.complete();
    }
    await readReply?.future;
    return rows;
  }

  @override
  Future<void> upsertLibrary(LibraryItem item, {String? userId}) async {
    account(userId)[item.novelId] = item;
  }

  @override
  Future<void> removeFromLibrary(int novelId, {String? userId}) async {
    account(userId).remove(novelId);
  }
}

class _History implements ReadingHistoryRemote {
  @override
  Future<List<ReadingHistory>> getHistory({String? userId}) async => [];
  @override
  Future<ReadingHistory?> getHistoryFor(int id, {String? userId}) async => null;
  @override
  Future<void> saveHistories(
    List<ReadingHistory> rows, {
    String? userId,
  }) async {}
  @override
  Future<void> deleteHistory(int id, {String? userId}) async {}
  @override
  Future<void> clearHistory({String? userId}) async {}
}

Novel novel(int id) => Novel(
  id: id,
  title: 'Truyện $id',
  author: 'Tác giả',
  coverUrl: '',
  description: '',
  status: 'ongoing',
  type: 'novel',
  genres: const [],
  totalChapters: 4,
  rating: 0,
  views: 0,
  updatedAt: DateTime(2026),
);
LibraryItem item(int id, {String category = 'want'}) => LibraryItem(
  novelId: id,
  novel: novel(id),
  category: category,
  addedAt: DateTime(2026),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  late AppDatabase db;
  late _Remote remote;
  late Directory folder;
  late String sample;
  setUpAll(() async {
    sample = await File('assets/data/sample_novels.json').readAsString();
  });
  AppDatabase database(String name) => AppDatabase(
    factory: databaseFactoryFfi,
    path: '${folder.path}/$name.db',
    libraryRemote: remote,
    historyRemote: _History(),
    sampleJsonLoader: () async => sample,
  );
  setUp(() async {
    final root = await Directory('build/library_cache_tests')
        .create(recursive: true);
    folder = await root.createTemp('case_');
    remote = _Remote();
    db = database('source');
  });
  tearDown(() async {
    await db.close();
    final root = Directory('build/library_cache_tests').absolute.path;
    if (!folder.absolute.path.startsWith('$root${Platform.pathSeparator}')) {
      throw StateError('Unexpected test folder');
    }
    await folder.delete(recursive: true);
  });

  test('Guest saves cloud-only IDs locally, moves categories and reloads reading progress', () async {
    final library = LibraryProvider(db)..bindUser('');
    try {
      await library.load();
      await library.setCategory(7001, 'want', novel: novel(7001));
      expect(library.items.single.novel!.title, 'Truyện 7001');
      await library.saveProgress(
        novel(7001),
        const Chapter(
          id: 70010,
          novelId: 7001,
          chapterIndex: 1,
          title: 'Chương 1',
        ),
        .5,
      );
      expect(library.categoryOf(7001), 'reading');
      await library.load();
      expect(library.items.single.progress, .25);
      expect(remote.requests, 0);
      await library.remove(7001);
      expect(library.items, isEmpty);
    } finally {
      library.dispose();
    }
  });

  test(
    'Cached shelves remain available offline and isolated by account',
    () async {
      await db.upsertLibrary(item(7001), userId: 'A');
      await db.upsertLibrary(item(8001), userId: 'B');
      await db.upsertLibrary(item(9001), userId: '');
      await db.getLibrary(userId: 'A');
      remote.offline = true;
      expect((await db.getLibrary(userId: 'A')).single.novelId, 7001);
      expect((await db.getLibrary(userId: 'B')).single.novelId, 8001);
      expect((await db.getLibrary(userId: '')).single.novelId, 9001);
      await db.close();
      db = database('source');
      expect(
        (await db.getLibrary(userId: 'A')).single.novel!.title,
        'Truyện 7001',
      );
    },
  );

  test(
    'Failed server edits retain cached state and successful removals clear it',
    () async {
      await db.upsertLibrary(item(7001), userId: 'A');
      remote.offline = true;
      await expectLater(
        db.upsertLibrary(item(7001, category: 'finished'), userId: 'A'),
        throwsStateError,
      );
      await expectLater(
        db.removeFromLibrary(7001, userId: 'A'),
        throwsStateError,
      );
      expect((await db.getLibrary(userId: 'A')).single.category, 'want');
      remote.offline = false;
      await db.upsertLibrary(item(7001, category: 'finished'), userId: 'A');
      expect((await db.getLibrary(userId: 'A')).single.category, 'finished');
      remote.accounts['A']!.clear();
      expect(await db.getLibrary(userId: 'A'), isEmpty);
    },
  );

  test(
    'A delayed shelf load cannot overwrite a later category update',
    () async {
      await db.upsertLibrary(item(7001), userId: 'A');
      remote.readStarted = Completer<void>();
      remote.readReply = Completer<void>();
      final loading = db.getLibrary(userId: 'A');
      await remote.readStarted!.future;
      final saving = db.upsertLibrary(
        item(7001, category: 'reading'),
        userId: 'A',
      );
      remote.readReply!.complete();
      await loading;
      await saving;
      expect((await db.getLibrary(userId: 'A')).single.category, 'reading');
    },
  );

  test(
    'Backup exports the selected shelf and restored members sync it to cloud',
    () async {
      await db.upsertLibrary(item(7001), userId: '');
      await db.upsertLibrary(item(8001), userId: 'B');
      final backup = await db.exportUserBackupJson(userId: '');
      final rows = (jsonDecode(backup) as Map)['cached_library'] as List;
      expect(rows.single['novel_id'], 7001);
      expect(rows.single.containsKey('user_id'), isFalse);
      final target = database('target');
      try {
        await target.importUserBackupJson(backup, userId: 'A');
        remote.offline = true;
        expect((await target.getLibrary(userId: 'A')).single.novelId, 7001);
        remote.offline = false;
        expect((await target.getLibrary(userId: 'A')).single.novelId, 7001);
        expect(remote.accounts['A']!.keys, [7001]);
        expect((await target.getLibrary(userId: 'B')).single.novelId, 8001);
        expect(await target.getLibrary(userId: ''), isEmpty);
      } finally {
        await target.close();
      }
    },
  );
}
