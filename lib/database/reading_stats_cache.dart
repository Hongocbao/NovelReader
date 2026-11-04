import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/reading_history.dart';
import '../repositories/reading_stats_remote.dart';

/// `phien_doc` giữ tổng gần nhất đã biết; `phien_doc_cuc_bo` chỉ chứa phần
/// đọc trên thiết bị chưa nằm trong thống kê máy chủ (bao gồm truyện tự nhập).
class ReadingStatsCache {
  ReadingStatsCache(this.db, this.remote);
  final Database db;
  final ReadingStatsRemote? remote;
  final _revisions = <String, int>{};
  final _loads = <String, int>{};

  void changed(String uid) => _revisions[uid] = (_revisions[uid] ?? 0) + 1;

  static Future<void> ensureSchema(
    Database db, {
    bool inMigration = false,
  }) async {
    // Một transaction giữ hai bảng cùng phiên bản, kể cả khi ứng dụng bị dừng.
    Future<void> migrate(DatabaseExecutor txn) async {
      var migratedTotals = false;
      for (final table in ['phien_doc', 'phien_doc_cuc_bo']) {
        final columns = await txn.rawQuery('PRAGMA table_info($table)');
        final legacy =
            columns.isNotEmpty && !columns.any((c) => c['name'] == 'user_id');
        if (legacy) {
          await txn.execute('ALTER TABLE $table RENAME TO ${table}_cu');
        }
        await txn.execute('''CREATE TABLE IF NOT EXISTS $table (
          user_id TEXT NOT NULL DEFAULT '', date_key TEXT NOT NULL,
          words_read INTEGER NOT NULL DEFAULT 0, minutes_read INTEGER NOT NULL DEFAULT 0,
          PRIMARY KEY (user_id, date_key))''');
        if (legacy) {
          await txn.execute(
            "INSERT INTO $table (user_id,date_key,words_read,minutes_read) SELECT '',date_key,words_read,minutes_read FROM ${table}_cu",
          );
          await txn.execute('DROP TABLE ${table}_cu');
          if (table == 'phien_doc') migratedTotals = true;
        }
      }
      // Không thể xác định chủ của tổng cũ: giữ đầy đủ ở Khách và không tự
      // gán sang tài khoản đang đăng nhập sau nâng cấp.
      if (migratedTotals) {
        for (final row in await txn.query('phien_doc', where: "user_id = ''")) {
          await mergeMaximum(txn, 'phien_doc_cuc_bo', '', row);
        }
      }
    }

    if (inMigration) {
      await migrate(db);
    } else {
      await db.transaction(migrate);
    }
  }

  static Future<void> increment(
    DatabaseExecutor db,
    String table,
    String uid,
    String day,
    int words,
    int minutes,
  ) async {
    final existing = await db.query(
      table,
      where: 'user_id = ? AND date_key = ?',
      whereArgs: [uid, day],
    );
    final row = existing.firstOrNull;
    await db.insert(table, {
      'user_id': uid,
      'date_key': day,
      'words_read': ((row?['words_read'] as int?) ?? 0) + words,
      'minutes_read': ((row?['minutes_read'] as int?) ?? 0) + minutes,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> mergeMaximum(
    DatabaseExecutor db,
    String table,
    String uid,
    Map<String, Object?> incoming,
  ) async {
    final stat = ReadingSessionStat.fromMap(incoming);
    if (DateTime.tryParse(stat.dateKey) == null ||
        stat.wordsRead < 0 ||
        stat.minutesRead < 0) {
      throw const FormatException(
        'Thống kê đọc trong bản sao lưu không hợp lệ.',
      );
    }
    final existing = await db.query(
      table,
      where: 'user_id = ? AND date_key = ?',
      whereArgs: [uid, stat.dateKey],
    );
    final row = existing.firstOrNull;
    int maximum(int a, int b) => a > b ? a : b;
    await db.insert(table, {
      'user_id': uid,
      'date_key': stat.dateKey,
      'words_read': maximum(stat.wordsRead, (row?['words_read'] as int?) ?? 0),
      'minutes_read': maximum(
        stat.minutesRead,
        (row?['minutes_read'] as int?) ?? 0,
      ),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> restore(
    DatabaseExecutor db,
    Map<String, dynamic> backup,
    String uid,
  ) async {
    Map<String, ReadingSessionStat> index(Object? rows) => rows is List
        ? {
            for (final row in rows.whereType<Map<String, dynamic>>())
              ReadingSessionStat.fromMap(row)
                  .dateKey: ReadingSessionStat.fromMap(
                row,
              ),
          }
        : {};
    final totals = index(backup['reading_sessions']);
    final local = index(
      backup['local_reading_sessions'] ?? backup['reading_sessions'],
    );
    final oldTotals = index(
      await db.query('phien_doc', where: 'user_id = ?', whereArgs: [uid]),
    );
    final oldLocal = index(
      await db.query(
        'phien_doc_cuc_bo',
        where: 'user_id = ?',
        whereArgs: [uid],
      ),
    );
    int maximum(int a, int b) => a > b ? a : b;
    for (final day in {...totals.keys, ...local.keys}) {
      // Ghép phần trên máy chủ và phần cục bộ riêng biệt: 100 từ đã tải
      // từ server + 30 từ trong bản sao lưu phải hiển thị 130 cả khi offline.
      // Dùng mức cao nhất từng phần để khôi phục lặp không cộng trùng.
      final localWords = maximum(
        oldLocal[day]?.wordsRead ?? 0,
        local[day]?.wordsRead ?? 0,
      );
      final localMinutes = maximum(
        oldLocal[day]?.minutesRead ?? 0,
        local[day]?.minutesRead ?? 0,
      );
      final cloudWords = maximum(
        0,
        maximum(
          (oldTotals[day]?.wordsRead ?? 0) - (oldLocal[day]?.wordsRead ?? 0),
          (totals[day]?.wordsRead ?? 0) - (local[day]?.wordsRead ?? 0),
        ),
      );
      final cloudMinutes = maximum(
        0,
        maximum(
          (oldTotals[day]?.minutesRead ?? 0) -
              (oldLocal[day]?.minutesRead ?? 0),
          (totals[day]?.minutesRead ?? 0) - (local[day]?.minutesRead ?? 0),
        ),
      );
      for (final stat in [totals[day], local[day]].nonNulls) {
        if (stat.wordsRead < 0 ||
            stat.minutesRead < 0 ||
            DateTime.tryParse(stat.dateKey) == null) {
          throw const FormatException(
            'Thống kê đọc trong bản sao lưu không hợp lệ.',
          );
        }
      }
      await mergeMaximum(
        db,
        'phien_doc',
        uid,
        ReadingSessionStat(
          dateKey: day,
          wordsRead: cloudWords + localWords,
          minutesRead: cloudMinutes + localMinutes,
        ).toMap(),
      );
      if (local.containsKey(day)) {
        await mergeMaximum(db, 'phien_doc_cuc_bo', uid, local[day]!.toMap());
      }
    }
  }

  Future<List<ReadingSessionStat>> load(String uid) async {
    final revision = _revisions[uid] ?? 0;
    final request = (_loads[uid] ?? 0) + 1;
    _loads[uid] = request;
    final server = remote;
    if (uid.isNotEmpty && server != null) {
      try {
        final cloud = await server.getReadingSessions(userId: uid);
        await db.transaction((txn) async {
          // Một lần đọc/khôi phục mới hơn hoặc lần tải mới hơn đã cập nhật tổng.
          if (revision != (_revisions[uid] ?? 0) || request != _loads[uid]) {
            return;
          }
          final merged = {for (final stat in cloud) stat.dateKey: stat};
          for (final row in await txn.query(
            'phien_doc_cuc_bo',
            where: 'user_id = ?',
            whereArgs: [uid],
          )) {
            final local = ReadingSessionStat.fromMap(row);
            final prior = merged[local.dateKey];
            merged[local.dateKey] = ReadingSessionStat(
              dateKey: local.dateKey,
              wordsRead: local.wordsRead + (prior?.wordsRead ?? 0),
              minutesRead: local.minutesRead + (prior?.minutesRead ?? 0),
            );
          }
          await txn.delete('phien_doc', where: 'user_id = ?', whereArgs: [uid]);
          for (final stat in merged.values) {
            await txn.insert('phien_doc', {...stat.toMap(), 'user_id': uid});
          }
        });
      } catch (error) {
        debugPrint(
          'Chưa tải được thống kê đọc, dùng bản lưu của tài khoản: $error',
        );
      }
    }
    return (await db.query(
      'phien_doc',
      where: 'user_id = ?',
      whereArgs: [uid],
      orderBy: 'date_key ASC',
    )).map(ReadingSessionStat.fromMap).toList();
  }
}
