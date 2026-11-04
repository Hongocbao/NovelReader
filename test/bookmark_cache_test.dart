import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/models/bookmark.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/providers/library_provider.dart';
import 'package:novel_reader/repositories/bookmark_remote.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _Remote implements BookmarkRemote {
  final accounts = <String, Map<int, Bookmark>>{};
  bool offline = false;
  int requests = 0;
  int adds = 0;
  int nextId = 100;
  String? delayedUser;
  Completer<void>? started;
  Completer<void>? reply;
  final deleted = <int>[];
  Map<int, Bookmark> account(String? uid) {
    requests++;
    if (uid == null || uid.isEmpty) throw StateError('Guest must stay local');
    if (offline) throw StateError('Offline');
    return accounts.putIfAbsent(uid, () => {});
  }

  @override
  Future<List<Bookmark>> getBookmarks(int novelId, {String? userId}) async {
    final rows = account(userId).values
        .where((b) => b.novelId == novelId)
        .toList();
    if (userId == delayedUser) {
      if (!started!.isCompleted) started!.complete();
      await reply!.future;
    }
    return rows;
  }

  @override
  Future<int> addBookmark(Bookmark b, {String? userId}) async {
    final rows = account(userId);
    adds++;
    final id = nextId++;
    rows[id] = b.copyWith(id: id);
    return id;
  }

  @override
  Future<void> deleteBookmark(int id, {String? userId}) async {
    account(userId).remove(id);
    deleted.add(id);
  }
}

Bookmark mark(String note, {double offset = .4}) => Bookmark(
  novelId: 7001,
  chapterId: 70010,
  chapterIndex: 2,
  chapterTitle: 'Chương hai',
  note: note,
  scrollOffset: offset,
  createdAt: DateTime(2026),
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
    bookmarkRemote: remote,
    sampleJsonLoader: () async => sample,
  );
  setUp(() async {
    folder = await (await Directory(
      'build/bookmark_cache_tests',
    ).create(recursive: true)).createTemp('case_');
    remote = _Remote();
    db = database('source');
  });
  tearDown(() async {
    await db.close();
    final root = Directory('build/bookmark_cache_tests').absolute.path;
    if (!folder.absolute.path.startsWith('$root${Platform.pathSeparator}')) {
      throw StateError('Unexpected test folder');
    }
    await folder.delete(recursive: true);
  });

  test('Guest bookmarks persist chapter metadata and exact position without cloud calls', () async {
    final library = LibraryProvider(db)..bindUser('');
    try {
      await library.load();
      await library.addBookmark(
        const Chapter(
          id: 70010,
          novelId: 7001,
          chapterIndex: 2,
          title: 'Chương hai',
        ),
        1.7,
        note: '  Hay  ',
      );
      final b = library.bookmarksOf(7001)!.single;
      expect(b.scrollOffset, 1);
      expect(b.note, 'Hay');
      expect(b.chapterTitle, 'Chương hai');
      expect(b.chapterIndex, 2);
      expect(remote.requests, 0);
      await db.close();
      db = database('source');
      final saved = (await db.getBookmarks(7001, userId: '')).single;
      expect(saved.scrollOffset, 1);
      expect(saved.chapterId, 70010);
      await db.deleteBookmark(saved.id!, userId: '');
      expect(await db.getBookmarks(7001, userId: ''), isEmpty);
      expect(remote.requests, 0);
    } finally {
      library.dispose();
    }
  });

  test('Account caches survive network errors and delete using the correct server ID', () async {
    final a = await db.addBookmark(mark('A'), userId: 'A');
    await db.addBookmark(mark('B'), userId: 'B');
    await db.addBookmark(mark('Guest'), userId: '');
    expect(a, isNot(100));
    expect((await db.getBookmarks(7001, userId: 'A')).single.id, a);
    expect((await db.getBookmarks(7001, userId: 'A')).single.id, a);
    remote.offline = true;
    expect((await db.getBookmarks(7001, userId: 'A')).single.note, 'A');
    expect((await db.getBookmarks(7001, userId: 'B')).single.note, 'B');
    expect((await db.getBookmarks(7001, userId: '')).single.note, 'Guest');
    await expectLater(db.deleteBookmark(a, userId: 'A'), throwsStateError);
    expect((await db.getBookmarks(7001, userId: 'A')).single.id, a);
    remote.offline = false;
    await db.deleteBookmark(a, userId: 'A');
    expect(remote.deleted, [100]);
    expect(await db.getBookmarks(7001, userId: 'A'), isEmpty);
    expect((await db.getBookmarks(7001, userId: 'B')).single.note, 'B');
    remote.accounts['B']!.clear();
    expect(await db.getBookmarks(7001, userId: 'B'), isEmpty);
  });

  test(
    'Failed member add reports failure and cannot create a false local success',
    () async {
      remote.offline = true;
      await expectLater(
        db.addBookmark(mark('A'), userId: 'A'),
        throwsStateError,
      );
      expect(await db.getBookmarks(7001, userId: 'A'), isEmpty);
    },
  );

  test(
    'An old account bookmark response cannot populate a new account UI',
    () async {
      await db.addBookmark(mark('A'), userId: 'A');
      await db.addBookmark(mark('B'), userId: 'B');
      remote.delayedUser = 'A';
      remote.started = Completer<void>();
      remote.reply = Completer<void>();
      final library = LibraryProvider(db)..bindUser('A');
      try {
        final first = library.loadBookmarks(7001);
        await remote.started!.future;
        library.bindUser('B');
        await library.loadBookmarks(7001);
        expect(library.bookmarksOf(7001)!.single.note, 'B');
        remote.reply!.complete();
        await first;
        expect(library.bookmarksOf(7001)!.single.note, 'B');
        await library.load();
      } finally {
        library.dispose();
      }
    },
  );

  test(
    'Restored bookmark keeps its metadata offline and avoids server duplicates',
    () async {
      await db.addBookmark(mark('Backup'), userId: '');
      await db.addBookmark(mark('Other'), userId: 'B');
      final backup = await db.exportUserBackupJson(userId: '');
      final rows = (jsonDecode(backup) as Map)['cached_bookmarks'] as List;
      expect(rows.single['note'], 'Backup');
      expect(rows.single.containsKey('remote_id'), isFalse);
      await remote.addBookmark(mark('Backup'), userId: 'A');
      final addsBefore = remote.adds;
      final target = database('target');
      try {
        await target.importUserBackupJson(backup, userId: 'A');
        remote.offline = true;
        final offline = (await target.getBookmarks(7001, userId: 'A')).single;
        expect(offline.chapterTitle, 'Chương hai');
        expect(offline.scrollOffset, .4);
        remote.offline = false;
        expect(
          (await target.getBookmarks(7001, userId: 'A')).single.note,
          'Backup',
        );
        expect(remote.adds, addsBefore);
        await target.importUserBackupJson(backup, userId: 'A');
        expect((await target.getBookmarks(7001, userId: 'A')).length, 1);
        expect(remote.adds, addsBefore);
      } finally {
        await target.close();
      }
    },
  );

  test(
    'Restoring during a delayed cloud read cannot duplicate cached bookmarks',
    () async {
      await db.addBookmark(mark('Backup'), userId: '');
      final backup = await db.exportUserBackupJson(userId: '');
      await remote.addBookmark(mark('Backup'), userId: 'A');
      remote.delayedUser = 'A';
      remote.started = Completer<void>();
      remote.reply = Completer<void>();
      final loading = db.getBookmarks(7001, userId: 'A');
      await remote.started!.future;
      await db.importUserBackupJson(backup, userId: 'A');
      remote.reply!.complete();
      expect((await loading).length, 1);
      expect((await db.getBookmarks(7001, userId: 'A')).length, 1);
      expect(remote.adds, 1);
    },
  );

  test('A delayed load cannot erase a bookmark added while the response was pending', () async {
    await db.addBookmark(mark('First'), userId: 'A');
    remote.delayedUser = 'A';
    remote.started = Completer<void>();
    remote.reply = Completer<void>();
    final loading = db.getBookmarks(7001, userId: 'A');
    await remote.started!.future;
    final saving = db.addBookmark(mark('Second', offset: .8), userId: 'A');
    remote.reply!.complete();
    await loading;
    await saving;
    expect((await db.getBookmarks(7001, userId: 'A')).map((b) => b.note), [
      'First',
      'Second',
    ]);
  });
}
