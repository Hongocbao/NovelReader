import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/database/quote_store.dart';
import 'package:novel_reader/models/bookmark.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/providers/library_provider.dart';
import 'package:novel_reader/repositories/quote_remote.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _Remote implements QuoteRemote {
  final accounts = <String, Map<int, QuoteItem>>{};
  bool offline = false;
  int requests = 0, adds = 0, nextId = 100;
  final deleted = <int>[];
  String? delayedUser;
  Completer<void>? started, reply;
  Map<int, QuoteItem> account(String? uid) {
    requests++;
    if (uid == null || uid.isEmpty) throw StateError('Guest must stay local');
    if (offline) throw StateError('Offline');
    return accounts.putIfAbsent(uid, () => {});
  }

  @override
  Future<List<QuoteItem>> getQuotes({String? userId}) async {
    final rows = account(userId).values.toList();
    if (userId == delayedUser) {
      if (!started!.isCompleted) started!.complete();
      await reply!.future;
    }
    return rows;
  }

  @override
  Future<int> addQuote(QuoteItem quote, {String? userId}) async {
    if (quote.novelId < 0) throw StateError('Local novels must stay local');
    final rows = account(userId);
    adds++;
    final id = nextId++;
    rows[id] = QuoteItem.fromMap({...quote.toMap(), 'id': id});
    return id;
  }

  @override
  Future<void> deleteQuote(int id, {String? userId}) async {
    account(userId).remove(id);
    deleted.add(id);
  }
}

QuoteItem quote(String content, {int novelId = 7001}) => QuoteItem(
  novelId: novelId,
  novelTitle: 'Truyện $novelId',
  author: 'Tác giả',
  chapterTitle: 'Chương hai',
  content: content,
  createdAt: DateTime.utc(2026),
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
    quoteRemote: remote,
    sampleJsonLoader: () async => sample,
  );
  setUp(() async {
    folder = await (await Directory(
      'build/quote_store_tests',
    ).create(recursive: true)).createTemp('case_');
    remote = _Remote();
    db = database('source');
  });
  tearDown(() async {
    await db.close();
    final root = Directory('build/quote_store_tests').absolute.path;
    if (!folder.absolute.path.startsWith('$root${Platform.pathSeparator}')) {
      throw StateError('Unexpected test folder');
    }
    await folder.delete(recursive: true);
  });

  Future<Novel> custom(AppDatabase target, String title) =>
      target.insertCustomNovel(
        title: title,
        author: 'Tác giả',
        description: '',
        status: 'ongoing',
        type: 'novel',
        genres: const [],
        chapters: const [(title: 'Chương hai', content: 'Nội dung gốc')],
      );

  test(
    'Guest quotes persist content and metadata without cloud calls',
    () async {
      final novel = await custom(db, 'Truyện tự nhập');
      final chapter = (await db.getChapters(novel.id)).single;
      final library = LibraryProvider(db)..bindUser('');
      try {
        await library.load();
        await expectLater(
          library.saveQuote(novel: novel, chapter: chapter, content: '  '),
          throwsArgumentError,
        );
        await library.saveQuote(
          novel: novel,
          chapter: chapter,
          content: '  Một câu đáng nhớ.  ',
        );
        expect(library.quotes.single.content, 'Một câu đáng nhớ.');
        expect(library.quotes.single.novelTitle, novel.title);
        expect(library.quotes.single.chapterTitle, chapter.title);
        expect(remote.requests, 0);
        await db.close();
        db = database('source');
        final saved = (await db.getQuotes(userId: '')).single;
        expect(saved.content, 'Một câu đáng nhớ.');
        await db.deleteQuote(saved.id!, userId: '');
        expect(await db.getQuotes(userId: ''), isEmpty);
        expect(remote.requests, 0);
      } finally {
        library.dispose();
      }
    },
  );

  test(
    'Signed-in local novel quotes never upload and remain account scoped',
    () async {
      await db.addQuote(quote('Local A', novelId: -1), userId: 'A');
      await db.addQuote(quote('Local B', novelId: -1), userId: 'B');
      expect(remote.adds, 0);
      expect((await db.getQuotes(userId: 'A')).single.content, 'Local A');
      remote.offline = true;
      await db.addQuote(quote('Offline A', novelId: -2), userId: 'A');
      expect((await db.getQuotes(userId: 'A')).length, 2);
      expect((await db.getQuotes(userId: 'B')).single.content, 'Local B');
      expect(await db.getQuotes(userId: ''), isEmpty);
      expect(remote.adds, 0);
    },
  );

  test(
    'Member quotes cache offline and deletion uses the actual server ID',
    () async {
      final localId = await db.addQuote(quote('Cloud A'), userId: 'A');
      await db.addQuote(quote('Cloud B'), userId: 'B');
      expect(localId, isNot(100));
      expect((await db.getQuotes(userId: 'A')).single.id, localId);
      remote.offline = true;
      await expectLater(
        db.addQuote(quote('Not saved'), userId: 'A'),
        throwsStateError,
      );
      await expectLater(db.deleteQuote(localId, userId: 'A'), throwsStateError);
      expect((await db.getQuotes(userId: 'A')).single.content, 'Cloud A');
      remote.offline = false;
      await db.deleteQuote(localId, userId: 'A');
      expect(remote.deleted, [100]);
      expect(await db.getQuotes(userId: 'A'), isEmpty);
      remote.accounts['B']!.clear();
      expect(await db.getQuotes(userId: 'B'), isEmpty);
    },
  );

  test('Backup keeps selected quotes, remaps local novels and avoids cloud duplicates', () async {
    final imported = await custom(db, 'Trong sao lưu');
    await db.addQuote(quote('Local quote', novelId: imported.id), userId: '');
    await db.addQuote(quote('Cloud quote'), userId: '');
    await db.addQuote(quote('Other account'), userId: 'B');
    final backup = await db.exportUserBackupJson(userId: '');
    final rows = (jsonDecode(backup) as Map)['quotes'] as List;
    expect(rows.length, 2);
    expect(
      rows.every(
        (r) => !r.containsKey('user_id') && !r.containsKey('remote_id'),
      ),
      isTrue,
    );
    await remote.addQuote(quote('Cloud quote'), userId: 'A');
    final addsBefore = remote.adds;
    final target = database('target');
    try {
      await custom(target, 'Giữ trên máy đích');
      await target.importUserBackupJson(backup, userId: 'A');
      remote.offline = true;
      expect((await target.getQuotes(userId: 'A')).length, 2);
      remote.offline = false;
      final restored = await target.getQuotes(userId: 'A');
      expect(
        restored.singleWhere((q) => q.content == 'Local quote').novelId,
        isNot(imported.id),
      );
      expect(restored.length, 2);
      expect(remote.adds, addsBefore);
      await target.importUserBackupJson(backup, userId: 'A');
      expect((await target.getQuotes(userId: 'A')).length, 2);
      expect(remote.adds, addsBefore);
    } finally {
      await target.close();
    }
  });

  test(
    'Upgrading the old quotes table preserves its records in guest mode',
    () async {
      final old = await databaseFactoryFfi.openDatabase(
        '${folder.path}/legacy.db',
      );
      try {
        await old.execute(
          'CREATE TABLE trich_dan (id INTEGER PRIMARY KEY AUTOINCREMENT, novel_id INTEGER NOT NULL, novel_title TEXT NOT NULL, author TEXT NOT NULL, chapter_title TEXT NOT NULL, content TEXT NOT NULL, created_at INTEGER NOT NULL)',
        );
        await old.insert('trich_dan', quote('Dữ liệu cũ').toMap());
        await QuoteStore.ensureSchema(old);
        await QuoteStore.ensureSchema(old);
        final store = QuoteStore(old, remote);
        expect((await store.load('')).single.content, 'Dữ liệu cũ');
        expect(await store.load('A'), isEmpty);
      } finally {
        await old.close();
      }
    },
  );

  test('Late quote loads cannot restore another account UI', () async {
    await db.addQuote(quote('A'), userId: 'A');
    await db.addQuote(quote('B'), userId: 'B');
    remote.delayedUser = 'A';
    remote.started = Completer<void>();
    remote.reply = Completer<void>();
    final library = LibraryProvider(db)..bindUser('A');
    try {
      final loading = library.load();
      await remote.started!.future;
      library.bindUser('B');
      await library.load();
      expect(library.quotes.single.content, 'B');
      remote.reply!.complete();
      await loading;
      expect(library.quotes.single.content, 'B');
    } finally {
      library.dispose();
    }
  });

  test(
    'Restoring during a delayed cloud load does not create duplicate quotes',
    () async {
      await db.addQuote(quote('Backup'), userId: '');
      final backup = await db.exportUserBackupJson(userId: '');
      await remote.addQuote(quote('Backup'), userId: 'A');
      remote.delayedUser = 'A';
      remote.started = Completer<void>();
      remote.reply = Completer<void>();
      final loading = db.getQuotes(userId: 'A');
      await remote.started!.future;
      await db.importUserBackupJson(backup, userId: 'A');
      remote.reply!.complete();
      expect((await loading).length, 1);
      expect((await db.getQuotes(userId: 'A')).length, 1);
      expect(remote.adds, 1);
    },
  );
}
