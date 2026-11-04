import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../repositories/reader_extras_source.dart';

/// Cache the exact chapter boundary and book version. A response for a later
/// chapter must never become an offline fallback for an earlier chapter.
class ReaderExtrasCache {
  ReaderExtrasCache(this.db);
  final Database db;
  final _pending = <String, Future<ReaderExtrasPage<Map<String, Object?>>>>{};

  static Future<void> ensureSchema(DatabaseExecutor db) => db.execute('''
    CREATE TABLE IF NOT EXISTS bo_dem_ho_tro_doc (
      user_id TEXT NOT NULL, novel_id INTEGER NOT NULL, kind TEXT NOT NULL,
      chapter_index INTEGER NOT NULL, version INTEGER NOT NULL,
      payload TEXT NOT NULL, saved_at INTEGER NOT NULL,
      PRIMARY KEY(user_id, novel_id, kind, chapter_index, version)
    )
  ''');

  Future<ReaderExtrasPage<Map<String, Object?>>> load({
    required String userId,
    required int novelId,
    required String kind,
    required int chapterIndex,
    required int version,
    required bool offline,
    required bool Function() isCurrentUser,
    required Future<List<Map<String, Object?>>> Function() fetch,
  }) async {
    void checkUser() {
      if (!isCurrentUser()) {
        throw StateError('Tài khoản đã thay đổi. Hãy mở lại truyện.');
      }
    }

    final args = [userId, novelId, kind, chapterIndex, version];
    final key = jsonEncode(args);
    Future<ReaderExtrasPage<Map<String, Object?>>?> cached() async {
      final rows = await db.query(
        'bo_dem_ho_tro_doc',
        columns: ['payload'],
        where: 'user_id=? AND novel_id=? AND kind=? AND chapter_index=? AND version=?',
        whereArgs: args,
      );
      checkUser();
      if (rows.isEmpty) return null;
      try {
        final data = jsonDecode(rows.single['payload'] as String) as List;
        return ReaderExtrasPage(
          data.map((r) => Map<String, Object?>.from(r as Map)),
          fromCache: true,
        );
      } on FormatException {
        return null;
      } on TypeError {
        return null;
      }
    }

    checkUser();
    if (offline) {
      return await cached() ??
          (throw StateError('Chưa có bản hỗ trợ đọc đã lưu cho chương này.'));
    }
    final existing = _pending[key];
    if (existing != null) return existing;

    Future<ReaderExtrasPage<Map<String, Object?>>> request() async {
      late final List<Map<String, Object?>> data;
      try {
        data = await fetch();
        checkUser();
      } catch (_) {
        checkUser();
        final page = await cached();
        if (page != null) return page;
        rethrow;
      }
      try {
        await db.transaction((txn) async {
          checkUser();
          await txn.insert('bo_dem_ho_tro_doc', {
            'user_id': userId,
            'novel_id': novelId,
            'kind': kind,
            'chapter_index': chapterIndex,
            'version': version,
            'payload': jsonEncode(data),
            'saved_at': DateTime.now().millisecondsSinceEpoch,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
          // Keep the 20 most recent boundaries per book/kind/account.
          await txn.rawDelete(
            '''DELETE FROM bo_dem_ho_tro_doc WHERE rowid IN (
            SELECT rowid FROM bo_dem_ho_tro_doc WHERE user_id=? AND novel_id=? AND kind=?
            ORDER BY saved_at DESC, rowid DESC LIMIT -1 OFFSET 20
          )''',
            [userId, novelId, kind],
          );
        });
      } catch (error) {
        debugPrint('Không lưu được bản hỗ trợ đọc offline: $error');
      }
      checkUser();
      return ReaderExtrasPage(data);
    }

    final task = request();
    _pending[key] = task;
    try {
      return await task;
    } finally {
      if (identical(_pending[key], task)) _pending.remove(key);
    }
  }
}
