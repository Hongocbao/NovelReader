import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/novel.dart';
import '../models/reading_history.dart';
import '../repositories/reading_history_remote.dart';

/// Lịch sử cloud có bản cục bộ riêng theo tài khoản, dùng trên cả web/native.
/// Không tham chiếu FK đến kho truyện mẫu vì ID cloud có thể khác ID trên máy.
class ReadingHistoryCache {
  ReadingHistoryCache(this.db, this.remote);

  final Database db;
  final ReadingHistoryRemote remote;
  final Map<String, Future<void>> _operations = {};
  static const table = 'lich_su_doc_dong_bo';

  // Ghi máy chủ tuần tự để một lần lưu đang chờ mạng không xuất hiện lại
  // sau thao tác xóa. Tài khoản khác vẫn có hàng đợi riêng.
  Future<T> _run<T>(String userId, Future<T> Function() action) {
    final next = (_operations[userId] ?? Future<void>.value()).then(
      (_) => action(),
    );
    _operations[userId] = next.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return next;
  }

  Future<void> waitForPendingSync() async {
    await Future.wait(_operations.values.toList());
  }

  static Future<void> ensureSchema(Database db) => db.execute('''
    CREATE TABLE IF NOT EXISTS $table (
      user_id TEXT NOT NULL,
      novel_id INTEGER NOT NULL,
      last_chapter_id INTEGER NOT NULL,
      scroll_offset REAL NOT NULL,
      last_read_at INTEGER NOT NULL,
      novel_json TEXT,
      chapter_index INTEGER,
      chapter_title TEXT,
      pending INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY (user_id, novel_id)
    )
  ''');

  Future<List<Map<String, Object?>>> _rows(String userId, {int? novelId}) =>
      db.query(
        table,
        where: novelId == null ? 'user_id = ?' : 'user_id = ? AND novel_id = ?',
        whereArgs: novelId == null ? [userId] : [userId, novelId],
        orderBy: 'last_read_at DESC',
      );

  ReadingHistory _decode(Map<String, Object?> row) {
    final json = row['novel_json'] as String?;
    final novel = json == null
        ? null
        : Novel.fromMap(Map<String, Object?>.from(jsonDecode(json) as Map));
    return ReadingHistory.fromMap(row).copyWith(novel: novel);
  }

  Future<bool> _put(
    ReadingHistory history,
    String userId, {
    required bool pending,
  }) => db.transaction((txn) async {
    final existing = await txn.query(
      table,
      columns: ['last_read_at', 'pending'],
      where: 'user_id = ? AND novel_id = ?',
      whereArgs: [userId, history.novelId],
      limit: 1,
    );
    final previous = existing.firstOrNull;
    final timestamp = history.lastReadAt.millisecondsSinceEpoch;
    final previousTimestamp = previous?['last_read_at'] as int?;
    if (previousTimestamp != null &&
        (previousTimestamp > timestamp ||
            (!pending &&
                previousTimestamp == timestamp &&
                previous?['pending'] == 1))) {
      return false;
    }
    await txn.insert(table, {
      ...history.toMap(),
      'user_id': userId,
      'novel_json': history.novel == null
          ? null
          : jsonEncode(history.novel!.toMap()),
      'chapter_index': history.chapterIndex,
      'chapter_title': history.chapterTitle,
      'pending': pending ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  });

  Future<void> _acknowledge(ReadingHistory history, String userId) => db
      .update(
        table,
        {'pending': 0},
        // Do not acknowledge a newer save that arrived during the HTTP request.
        where: 'user_id = ? AND novel_id = ? AND last_read_at = ? AND last_chapter_id = ? AND scroll_offset = ?',
        whereArgs: [
          userId,
          history.novelId,
          history.lastReadAt.millisecondsSinceEpoch,
          history.lastChapterId,
          history.scrollOffset,
        ],
      )
      .then((_) {});

  Future<void> save(ReadingHistory history, String userId) async {
    if (!await _put(history, userId, pending: true) || userId.isEmpty) return;
    // Trả về ngay sau khi ghi SQLite; mạng chậm không chặn lần lưu tiếp theo.
    unawaited(
      _run(userId, () async {
        try {
          final rows = await _rows(userId, novelId: history.novelId);
          if (rows.isEmpty || rows.single['pending'] != 1) return;
          final current = _decode(rows.single);
          await remote.saveHistories([current], userId: userId);
          await _acknowledge(current, userId);
        } catch (error) {
          debugPrint('Giữ tiến độ cục bộ để đồng bộ lại: $error');
        }
      }),
    );
  }

  Future<void> _mergeAndSync(
    List<ReadingHistory> cloud,
    List<Map<String, Object?>> before,
    String userId, {
    int? novelId,
  }) async {
    final cloudIds = cloud.map((h) => h.novelId).toSet();
    for (final history in cloud) {
      await _put(history, userId, pending: false);
    }
    // Honor deletions on another device, but never discard an unsent local save.
    for (final row in before) {
      if (row['pending'] == 0 && !cloudIds.contains(row['novel_id'])) {
        await db.delete(
          table,
          where: 'user_id = ? AND novel_id = ? AND pending = 0 AND last_read_at <= ?',
          whereArgs: [userId, row['novel_id'], row['last_read_at']],
        );
      }
    }
    final pending = (await _rows(
      userId,
      novelId: novelId,
    )).where((row) => row['pending'] == 1).map(_decode).toList();
    if (pending.isEmpty) return;
    await remote.saveHistories(pending, userId: userId);
    for (final history in pending) {
      await _acknowledge(history, userId);
    }
  }

  Future<List<ReadingHistory>> load(
    String userId, {
    int? novelId,
  }) => _run(userId, () async {
    final before = await _rows(userId, novelId: novelId);
    if (userId.isNotEmpty) {
      try {
        final List<ReadingHistory> cloud;
        if (novelId == null) {
          cloud = await remote.getHistory(userId: userId);
        } else {
          final item = await remote.getHistoryFor(novelId, userId: userId);
          cloud = [?item];
        }
        await _mergeAndSync(cloud, before, userId, novelId: novelId);
      } catch (error) {
        debugPrint('Dùng lịch sử cục bộ khi chưa đồng bộ được: $error');
      }
    }
    // Read again so a save made while waiting for the network remains visible.
    return (await _rows(userId, novelId: novelId)).map(_decode).toList();
  });

  Future<void> remove(int novelId, String userId) => _run(userId, () async {
    if (userId.isNotEmpty) await remote.deleteHistory(novelId, userId: userId);
    await db.delete(
      table,
      where: 'user_id = ? AND novel_id = ?',
      whereArgs: [userId, novelId],
    );
  });

  Future<void> clear(String userId) => _run(userId, () async {
    if (userId.isNotEmpty) await remote.clearHistory(userId: userId);
    await db.delete(table, where: 'user_id = ?', whereArgs: [userId]);
  });
}
