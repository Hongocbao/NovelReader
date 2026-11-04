import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/library_item.dart';
import '../models/novel.dart';
import '../repositories/library_remote.dart';

class LibraryCache {
  LibraryCache(this.db, this.remote);
  final Database db;
  final LibraryRemote remote;
  static const table = 'tu_sach_dong_bo';
  final _operations = <String, Future<void>>{};

  static Future<void> ensureSchema(Database db) => db.execute('''
    CREATE TABLE IF NOT EXISTS $table (
      user_id TEXT NOT NULL, novel_id INTEGER NOT NULL,
      category TEXT NOT NULL, added_at INTEGER NOT NULL, novel_json TEXT NOT NULL,
      pending INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY(user_id, novel_id)
    )
  ''');

  Future<T> _run<T>(String uid, Future<T> Function() action) {
    final next = (_operations[uid] ?? Future<void>.value()).then(
      (_) => action(),
    );
    _operations[uid] = next.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return next;
  }

  Map<String, Object?> _encode(LibraryItem item, String uid) => {
    ...item.toMap(),
    'user_id': uid,
    'novel_json': jsonEncode(item.novel!.toMap()),
    'pending': 0,
  };

  LibraryItem _decode(Map<String, Object?> row) => LibraryItem.fromMap(row)
      .copyWith(
        novel: Novel.fromMap(
          Map<String, Object?>.from(
            jsonDecode(row['novel_json'] as String) as Map,
          ),
        ),
      );

  Future<List<LibraryItem>> load(String uid) => _run(uid, () async {
    if (uid.isNotEmpty) {
      try {
        final pending = await db.query(
          table,
          where: 'user_id = ? AND pending = 1',
          whereArgs: [uid],
        );
        for (final row in pending) {
          await remote.upsertLibrary(_decode(row), userId: uid);
          await db.update(
            table,
            {'pending': 0},
            where: 'user_id = ? AND novel_id = ? AND category = ? AND added_at = ?',
            whereArgs: [uid, row['novel_id'], row['category'], row['added_at']],
          );
        }
        final rows = await remote.getLibrary(userId: uid);
        await db.transaction((txn) async {
          await txn.delete(
            table,
            where: 'user_id = ? AND pending = 0',
            whereArgs: [uid],
          );
          for (final item in rows) {
            if ((await txn.query(
              table,
              columns: ['novel_id'],
              where: 'user_id = ? AND novel_id = ? AND pending = 1',
              whereArgs: [uid, item.novelId],
            )).isNotEmpty) {
              continue;
            }
            await txn.insert(table, _encode(item, uid));
          }
        });
      } catch (error) {
        debugPrint('Dùng tủ sách đã lưu trên thiết bị: $error');
      }
    }
    final rows = await db.query(
      table,
      where: 'user_id = ?',
      whereArgs: [uid],
      orderBy: 'added_at DESC',
    );
    return rows.map(_decode).toList();
  });

  Future<void> save(LibraryItem item, String uid) => _run(uid, () async {
    if (item.novel == null) {
      throw StateError('Thiếu thông tin truyện để lưu tủ sách.');
    }
    // Thành viên chỉ báo thành công khi máy chủ đã ghi nhận thay đổi.
    if (uid.isNotEmpty) await remote.upsertLibrary(item, userId: uid);
    await db.insert(
      table,
      _encode(item, uid),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  });

  Future<void> remove(int novelId, String uid) => _run(uid, () async {
    if (uid.isNotEmpty) await remote.removeFromLibrary(novelId, userId: uid);
    await db.delete(
      table,
      where: 'user_id = ? AND novel_id = ?',
      whereArgs: [uid, novelId],
    );
  });
}
