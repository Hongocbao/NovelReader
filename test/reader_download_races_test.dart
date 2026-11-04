import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/providers/reader_provider.dart';

const first = Chapter(id: 11, novelId: 1, chapterIndex: 1, title: 'Chương 1');
const second = Chapter(id: 12, novelId: 1, chapterIndex: 2, title: 'Chương 2');
const other = Chapter(
  id: 21,
  novelId: 2,
  chapterIndex: 1,
  title: 'Truyện khác',
);
typedef _Key = ({int novel, int chapter});
Novel book(int id) => Novel(
  id: id,
  title: 'Truyện $id',
  author: 'Test',
  coverUrl: '',
  description: '',
  status: 'ongoing',
  type: 'novel',
  genres: const [],
  totalChapters: 2,
  rating: 0,
  views: 0,
  updatedAt: DateTime(2026),
);

class _Database extends AppDatabase {
  final saved = <_Key, Chapter>{};
  final fetched = <_Key>[];
  final fetchGates = <_Key, Completer<String>>{};
  final fetchSignals = <_Key, Completer<void>>{};
  final chapterReplies = <Completer<List<Chapter>>>[];
  Completer<void>? fetchStarted,
      saveStarted,
      saveGate,
      downloadsStarted,
      downloadsGate;
  bool failSave = false;
  int writes = 0, chapterReads = 0;
  @override
  Future<List<Chapter>> getChapters(int novelId, {Novel? novel}) async {
    chapterReads++;
    if (chapterReplies.isNotEmpty) return chapterReplies.removeAt(0).future;
    return novelId == 1 ? [first, second] : [other];
  }

  @override
  Future<List<Chapter>> getCachedChapters(int novelId) => getChapters(novelId);
  @override
  Future<Chapter?> getChapter(int id, {int? novelId}) async =>
      saved[(novel: novelId!, chapter: id)];
  @override
  Future<String> fetchChapterContent(int novelId, int chapterIndex) async {
    final key = (novel: novelId, chapter: chapterIndex);
    fetched.add(key);
    fetchSignals[key]?.complete();
    if (fetchStarted != null && !fetchStarted!.isCompleted) {
      fetchStarted!.complete();
    }
    return fetchGates[key]?.future ??
        Future.value('Nội dung $novelId/$chapterIndex');
  }

  @override
  Future<void> saveChapterContent(
    Chapter chapter,
    String content, {
    Novel? novel,
  }) async {
    if (saveStarted != null && !saveStarted!.isCompleted) {
      saveStarted!.complete();
    }
    await saveGate?.future;
    if (failSave) throw StateError('Disk full');
    saved[(novel: chapter.novelId, chapter: chapter.id)] = chapter.copyWith(
      content: content,
      isDownloaded: true,
    );
    writes++;
  }

  @override
  Future<void> deleteChapterContent(Chapter chapter) async {
    saved.remove((novel: chapter.novelId, chapter: chapter.id));
  }

  @override
  Future<int> deleteDownloads({int? novelId}) async {
    final before = saved.length;
    saved.removeWhere((key, value) => novelId == null || key.novel == novelId);
    return before - saved.length;
  }

  @override
  Future<List<DownloadedChapter>> getDownloadedChapters() async {
    final snapshot = [
      for (final ch in saved.values)
        DownloadedChapter(
          chapter: ch,
          novelTitle: 'Truyện',
          coverUrl: '',
          sizeInBytes: 1,
        ),
    ];
    if (downloadsStarted != null && !downloadsStarted!.isCompleted) {
      downloadsStarted!.complete();
    }
    final gate = downloadsGate;
    await gate?.future;
    return snapshot;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _Database db;
  late ReaderProvider reader;
  var disposed = false;
  setUp(() {
    db = _Database();
    reader = ReaderProvider(
      db,
      connectivityStream: const Stream.empty(),
      checkConnectivity: () async => true,
    );
    disposed = false;
  });
  tearDown(() {
    if (!disposed) reader.dispose();
  });

  test('Overlapping download requests queue distinct chapters and skip real cached copies', () async {
    db.fetchStarted = Completer<void>();
    final gate = db.fetchGates[(novel: 1, chapter: 1)] = Completer<String>();
    final one = reader.downloadChapters(1, [first, first]);
    await db.fetchStarted!.future;
    final two = reader.downloadChapters(1, [first, second]);
    reader.clearTask(1);
    expect(reader.taskOf(1)!.running, isTrue);
    expect(db.fetched.length, 1);
    gate.complete('Nội dung một');
    expect(await Future.wait([one, two]), [1, 1]);
    expect(db.fetched, [(novel: 1, chapter: 1), (novel: 1, chapter: 2)]);
    expect(reader.downloadedCount, 2);
    expect(reader.taskOf(1), isNull);
    reader.forceOffline = true;
    expect(await reader.downloadChapters(1, [first, second]), 0);
  });

  test('Deleting while network bytes are waiting cancels queued old requests and prevents resurrection', () async {
    db.fetchStarted = Completer<void>();
    final gate = db.fetchGates[(novel: 1, chapter: 1)] = Completer<String>();
    final one = reader.downloadChapters(1, [first]);
    await db.fetchStarted!.future;
    final two = reader.downloadChapters(1, [second]);
    final errors = Future.wait([
      expectLater(one, throwsA(isA<DownloadCancelledException>())),
      expectLater(two, throwsA(isA<DownloadCancelledException>())),
    ]);
    await reader.deleteDownloads(novelId: 1);
    gate.complete('Trả về sau khi xóa');
    await errors;
    expect(db.saved, isEmpty);
    expect(db.writes, 0);
    expect(reader.downloaded, isEmpty);
    expect(await reader.downloadChapters(1, [second]), 1);
  });

  test('Deleting during an in-progress disk write runs after the write and removes it', () async {
    db.saveStarted = Completer<void>();
    db.saveGate = Completer<void>();
    final download = reader.downloadChapters(1, [first]);
    final error = expectLater(
      download,
      throwsA(isA<DownloadCancelledException>()),
    );
    await db.saveStarted!.future;
    final deletion = reader.deleteDownload(first);
    db.saveGate!.complete();
    await Future.wait([error, deletion]);
    expect(db.saved, isEmpty);
    expect(reader.downloaded, isEmpty);
  });

  test(
    'A failed save is not counted as downloaded and the next request can retry',
    () async {
      await reader.loadChapters(1);
      db.failSave = true;
      await expectLater(reader.downloadChapters(1, [first]), throwsStateError);
      expect(reader.taskOf(1)!.done, 0);
      expect(reader.taskOf(1)!.running, isFalse);
      expect(reader.chaptersOf(1)!.first.isDownloaded, isFalse);
      expect(reader.downloaded, isEmpty);
      db.failSave = false;
      expect(await reader.downloadChapters(1, [first]), 1);
      expect(reader.chaptersOf(1)!.first.isDownloaded, isTrue);
    },
  );

  test('Missing bytes behind a stale downloaded flag are fetched again; empty content is rejected', () async {
    expect(
      await reader.downloadChapters(1, [first.copyWith(isDownloaded: true)]),
      1,
    );
    final gate = db.fetchGates[(novel: 1, chapter: 2)] = Completer<String>()
      ..complete(' \n ');
    await expectLater(reader.downloadChapters(1, [second]), throwsStateError);
    expect(gate.isCompleted, isTrue);
    expect(db.saved.length, 1);
    expect(reader.taskOf(1)!.done, 0);
  });

  test(
    'Mixed-novel chapter requests are rejected before fetch or disk writes',
    () async {
      await expectLater(
        reader.downloadChapters(1, [first, other]),
        throwsArgumentError,
      );
      expect(db.fetched, isEmpty);
      expect(db.saved, isEmpty);
    },
  );

  test(
    'A late chapter list cannot undo a completed download or newer refresh',
    () async {
      final oldReply = Completer<List<Chapter>>();
      final newReply = Completer<List<Chapter>>();
      db.chapterReplies.addAll([oldReply, newReply]);
      final old = reader.loadChapters(1);
      final newest = reader.loadChapters(1, force: true);
      expect(reader.loadChapters(1), same(newest));
      await reader.downloadChapters(1, [second]);
      newReply.complete([second]);
      await newest;
      oldReply.complete([first]);
      expect((await old).single.id, second.id);
      expect(reader.chaptersOf(1)!.single.id, second.id);
      expect(reader.chaptersOf(1)!.single.isDownloaded, isTrue);
      expect(reader.isLoadingChapters(1), isFalse);
      expect(db.chapterReads, 2);
    },
  );

  test(
    'A delayed downloads snapshot cannot restore deleted items in the UI',
    () async {
      await reader.downloadChapters(1, [first]);
      db.downloadsStarted = Completer<void>();
      final gate = db.downloadsGate = Completer<void>();
      final old = reader.loadDownloads();
      await db.downloadsStarted!.future;
      db.downloadsGate = null;
      await reader.deleteDownloads();
      gate.complete();
      await old;
      expect(reader.downloaded, isEmpty);
      expect(reader.downloadsLoading, isFalse);
    },
  );

  test('A partial failed batch retains completed chapters and retries only the missing chapter', () async {
    final signal = db.fetchSignals[(novel: 1, chapter: 2)] = Completer<void>();
    final gate = db.fetchGates[(novel: 1, chapter: 2)] = Completer<String>();
    final downloading = reader.downloadChapters(1, [first, second]);
    final error = expectLater(downloading, throwsStateError);
    await signal.future;
    expect(reader.taskOf(1)!.done, 1);
    db.failSave = true;
    gate.complete('Nội dung hai');
    await error;
    expect(reader.taskOf(1)!.done, 1);
    expect(reader.downloadedCount, 1);
    db.failSave = false;
    db.fetchSignals.clear();
    expect(await reader.downloadChapters(1, [first, second]), 1);
    expect(db.fetched.where((key) => key.chapter == 1).length, 1);
    expect(reader.downloadedCount, 2);
  });

  test('Opening a stale chapter from another novel cannot replace the current reading content', () async {
    await reader.openNovel(book(1), chapterId: first.id);
    final content = reader.content;
    await reader.openChapter(other);
    expect(reader.currentChapter!.id, first.id);
    expect(reader.content, content);
  });

  test('Disposal stops pending chapter loads, downloads and scheduled notifications', () async {
    final reply = Completer<List<Chapter>>();
    db.chapterReplies.add(reply);
    final loading = reader.loadChapters(1);
    db.fetchStarted = Completer<void>();
    final gate = db.fetchGates[(novel: 1, chapter: 1)] = Completer<String>();
    final download = reader.downloadChapters(1, [first]);
    final error = expectLater(
      download,
      throwsA(isA<DownloadCancelledException>()),
    );
    await db.fetchStarted!.future;
    reader.forceOffline = true;
    reader.dispose();
    disposed = true;
    reply.complete([first]);
    gate.complete('Late bytes');
    expect(await loading, isEmpty);
    await error;
    expect(db.saved, isEmpty);
  });

  test(
    'Connectivity initialization is shared and never subscribes after disposal',
    () async {
      reader.dispose();
      disposed = true;
      final connection = StreamController<bool>.broadcast();
      final check = Completer<bool>();
      final pending = ReaderProvider(
        db,
        connectivityStream: connection.stream,
        checkConnectivity: () => check.future,
      );
      final one = pending.init();
      final two = pending.init();
      expect(one, same(two));
      pending.dispose();
      check.complete(true);
      await Future.wait([one, two]);
      expect(connection.hasListener, isFalse);
      await connection.close();
    },
  );
}
