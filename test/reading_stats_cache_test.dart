import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/models/reading_history.dart';
import 'package:novel_reader/providers/library_provider.dart';
import 'package:novel_reader/repositories/reading_stats_remote.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

String day(DateTime value) =>
    '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
ReadingSessionStat stat(int words, int minutes, {String? date}) =>
    ReadingSessionStat(
      dateKey: date ?? day(DateTime.now()),
      wordsRead: words,
      minutesRead: minutes,
    );

class _Remote implements ReadingStatsRemote {
  final accounts = <String, List<ReadingSessionStat>>{};
  int reads = 0, writes = 0;
  bool offline = false;
  Completer<void>? started, reply;
  String? delayedUser;
  @override
  Future<List<ReadingSessionStat>> getReadingSessions({String? userId}) async {
    reads++;
    if (userId == null || userId.isEmpty) {
      throw StateError('Guest must stay local');
    }
    if (offline) throw StateError('Offline');
    final rows = (accounts[userId] ?? []).toList();
    if (userId == delayedUser) {
      if (!started!.isCompleted) started!.complete();
      await reply!.future;
    }
    return rows;
  }

  @override
  Future<bool> recordReadingSession({
    required int wordsRead,
    required int minutesRead,
    String? userId,
    int novelId = 0,
    int chapterId = 0,
  }) async {
    writes++;
    if (userId == null || userId.isEmpty) {
      throw StateError('Guest must stay local');
    }
    if (offline) throw StateError('Offline');
    final rows = accounts.putIfAbsent(userId, () => []);
    final currentDay = day(DateTime.now());
    final index = rows.indexWhere((s) => s.dateKey == currentDay);
    final previous = index < 0 ? stat(0, 0) : rows.removeAt(index);
    rows.add(
      stat(previous.wordsRead + wordsRead, previous.minutesRead + minutesRead),
    );
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  late AppDatabase db;
  late _Remote remote;
  late Directory folder;
  late String sample;
  setUpAll(
    () async =>
        sample = await File('assets/data/sample_novels.json').readAsString(),
  );
  AppDatabase database(String name, {bool withRemote = true}) => AppDatabase(
    factory: databaseFactoryFfi,
    path: '${folder.path}/$name.db',
    statsRemote: withRemote ? remote : null,
    sampleJsonLoader: () async => sample,
  );
  setUp(() async {
    folder = await (await Directory(
      'build/reading_stats_cache_tests',
    ).create(recursive: true)).createTemp('case_');
    remote = _Remote();
    db = database('source');
  });
  tearDown(() async {
    await db.close();
    final root = Directory('build/reading_stats_cache_tests').absolute.path;
    if (!folder.absolute.path.startsWith('$root${Platform.pathSeparator}')) {
      throw StateError('Unexpected test folder');
    }
    await folder.delete(recursive: true);
  });
  Future<void> record(String uid, int words, int minutes, {int novel = 1}) =>
      db.recordReadingSession(
        userId: uid,
        words: words,
        minutes: minutes,
        novelId: novel,
        chapterId: 10,
      );

  test(
    'Guest writes and loads never call the connected account server',
    () async {
      await record('', 12, 2);
      expect((await db.getReadingSessions(userId: '')).single.minutesRead, 2);
      expect(remote.reads, 0);
      expect(remote.writes, 0);
      expect(await db.getReadingSessions(userId: 'A'), isEmpty);
    },
  );

  test('Cloud totals and local/offline totals merge only within the selected account', () async {
    remote.accounts['A'] = [stat(100, 10)];
    remote.accounts['B'] = [stat(200, 20)];
    expect((await db.getReadingSessions(userId: 'A')).single.wordsRead, 100);
    await record('A', 20, 2); // Already acknowledged in cloud.
    await record('A', 30, 3, novel: -1); // Imported novel stays local.
    await record('B', 40, 4, novel: -2);
    expect((await db.getReadingSessions(userId: 'A')).single.wordsRead, 150);
    expect((await db.getReadingSessions(userId: 'A')).single.wordsRead, 150);
    expect((await db.getReadingSessions(userId: 'B')).single.wordsRead, 240);
    remote.offline = true;
    await record('A', 5, 1);
    expect((await db.getReadingSessions(userId: 'A')).single.wordsRead, 155);
    expect((await db.getReadingSessions(userId: 'B')).single.wordsRead, 240);
    expect(await db.getReadingSessions(userId: ''), isEmpty);
    expect(await db.getReadingSessions(userId: 'C'), isEmpty);
    remote.offline = false;
    expect((await db.getReadingSessions(userId: 'A')).single.wordsRead, 155);
    expect((await db.getDeviceReadingSessions()).single.wordsRead, 395);
  });

  test('A successful empty cloud response clears only that account server snapshot', () async {
    remote.accounts['A'] = [stat(100, 10)];
    remote.accounts['B'] = [stat(200, 20)];
    await db.getReadingSessions(userId: 'A');
    await db.getReadingSessions(userId: 'B');
    await record('A', 7, 1, novel: -1);
    remote.accounts['A'] = [];
    expect((await db.getReadingSessions(userId: 'A')).single.wordsRead, 7);
    expect((await db.getReadingSessions(userId: 'B')).single.wordsRead, 200);
  });

  test('A delayed cloud response cannot overwrite a newer acknowledged reading write', () async {
    remote.accounts['A'] = [stat(100, 10)];
    await db.getReadingSessions(userId: 'A');
    remote.delayedUser = 'A';
    remote.started = Completer<void>();
    remote.reply = Completer<void>();
    final loading = db.getReadingSessions(userId: 'A');
    await remote.started!.future;
    await record('A', 20, 2);
    remote.reply!.complete();
    expect((await loading).single.wordsRead, 120);
    remote.delayedUser = null;
    remote.offline = true;
    expect((await db.getReadingSessions(userId: 'A')).single.wordsRead, 120);
  });

  test('All returned days are cached, including days older than 30 and earlier years', () async {
    final now = DateTime.now();
    remote.accounts['A'] = List.generate(
      420,
      (i) => stat(1, 1, date: day(now.subtract(Duration(days: i)))),
    );
    expect((await db.getReadingSessions(userId: 'A')).length, 420);
    await db.close();
    remote.offline = true;
    expect((await db.getReadingSessions(userId: 'A')).length, 420);
  });

  test('Legacy device totals survive reopening as Guest and never appear under a member', () async {
    final raw = await databaseFactoryFfi.openDatabase(
      '${folder.path}/legacy.db',
    );
    for (final table in ['phien_doc', 'phien_doc_cuc_bo']) {
      await raw.execute(
        'CREATE TABLE $table (date_key TEXT PRIMARY KEY, words_read INTEGER NOT NULL, minutes_read INTEGER NOT NULL)',
      );
      await raw.insert(
        table,
        stat(
          table == 'phien_doc' ? 100 : 20,
          table == 'phien_doc' ? 10 : 2,
        ).toMap(),
      );
    }
    await raw.close();
    final legacy = database('legacy');
    try {
      expect(
        (await legacy.getReadingSessions(userId: '')).single.wordsRead,
        100,
      );
      expect(await legacy.getReadingSessions(userId: 'A'), isEmpty);
      await legacy.close();
      expect(
        (await legacy.getReadingSessions(userId: '')).single.wordsRead,
        100,
      );
      expect(
        (await (await legacy.database).query('phien_doc_cuc_bo'))
            .single['words_read'],
        100,
      );
    } finally {
      await legacy.close();
    }
  });

  test('Backup contains only selected statistics and repeated restore does not lower or duplicate totals', () async {
    await record('A', 30, 3, novel: -1);
    await record('B', 90, 9, novel: -1);
    await record('', 50, 5, novel: -1);
    final backup = await db.exportUserBackupJson(userId: 'A');
    final data = jsonDecode(backup) as Map<String, dynamic>;
    expect(data['backup_version'], 8);
    expect((data['reading_sessions'] as List).single['words_read'], 30);
    expect(
      (data['reading_sessions'] as List).single.containsKey('user_id'),
      isFalse,
    );
    final target = database('target');
    try {
      await target.recordReadingSession(
        userId: 'B',
        words: 100,
        minutes: 10,
        novelId: -1,
      );
      await target.importUserBackupJson(backup, userId: 'A');
      await target.importUserBackupJson(backup, userId: 'A');
      expect(
        (await target.getReadingSessions(userId: 'A')).single.wordsRead,
        30,
      );
      expect(
        (await target.getReadingSessions(userId: 'B')).single.wordsRead,
        100,
      );
      expect(await target.getReadingSessions(userId: ''), isEmpty);
      await target.recordReadingSession(
        userId: 'A',
        words: 10,
        minutes: 1,
        novelId: -1,
      );
      await target.importUserBackupJson(backup, userId: 'A');
      expect(
        (await target.getReadingSessions(userId: 'A')).single.wordsRead,
        40,
      );
    } finally {
      await target.close();
    }
  });

  test(
    'Restoring local totals onto a cached cloud snapshot stays correct offline',
    () async {
      remote.accounts['A'] = [stat(100, 10)];
      await db.getReadingSessions(userId: 'A');
      remote.offline = true;
      final backup = jsonEncode({
        'reading_sessions': [stat(30, 3).toMap()],
        'local_reading_sessions': [stat(30, 3).toMap()],
      });
      await db.importUserBackupJson(backup, userId: 'A');
      await db.importUserBackupJson(backup, userId: 'A');
      final offline = (await db.getReadingSessions(userId: 'A')).single;
      expect(offline.wordsRead, 130);
      expect(offline.minutesRead, 13);
      remote.offline = false;
      expect((await db.getReadingSessions(userId: 'A')).single.wordsRead, 130);
    },
  );

  test('An old account load cannot replace the current account statistics in the UI', () async {
    remote.accounts['A'] = [stat(100, 10)];
    remote.accounts['B'] = [stat(200, 20)];
    remote.delayedUser = 'A';
    remote.started = Completer<void>();
    remote.reply = Completer<void>();
    final library = LibraryProvider(db)..bindUser('A');
    try {
      final old = library.load();
      await remote.started!.future;
      library.bindUser('B');
      await library.load();
      expect(library.totalWordsRead, 200);
      remote.reply!.complete();
      await old;
      expect(library.totalWordsRead, 200);
    } finally {
      library.dispose();
    }
  });

  test('An old backup without local statistics binds its totals to the restore account only', () async {
    final backup = jsonEncode({
      'reading_sessions': [stat(25, 5).toMap()],
    });
    await db.importUserBackupJson(backup, userId: 'A');
    expect((await db.getReadingSessions(userId: 'A')).single.wordsRead, 25);
    expect(await db.getReadingSessions(userId: 'B'), isEmpty);
    expect(await db.getReadingSessions(userId: ''), isEmpty);
  });

  test(
    'Restore during a delayed server load preserves the restored local total',
    () async {
      remote.started = Completer<void>();
      remote.reply = Completer<void>();
      remote.delayedUser = 'A';
      final loading = db.getReadingSessions(userId: 'A');
      await remote.started!.future;
      await db.importUserBackupJson(
        jsonEncode({
          'reading_sessions': [stat(25, 5).toMap()],
        }),
        userId: 'A',
      );
      remote.reply!.complete();
      expect((await loading).single.wordsRead, 25);
    },
  );
}
