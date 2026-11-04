import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/bookmark.dart';
import '../repositories/bookmark_remote.dart';

class BookmarkCache {
  BookmarkCache(this.db, this.remote);
  final Database db;
  final BookmarkRemote remote;
  static const table = 'dau_trang_dong_bo';
  final _operations = <String, Future<void>>{};

  static Future<void> ensureSchema(Database db) => db.execute('''
    CREATE TABLE IF NOT EXISTS $table (
      local_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id TEXT NOT NULL, remote_id INTEGER,
      novel_id INTEGER NOT NULL, chapter_id INTEGER NOT NULL,
      scroll_offset REAL NOT NULL, note TEXT NOT NULL, created_at INTEGER NOT NULL,
      chapter_index INTEGER, chapter_title TEXT,
      pending INTEGER NOT NULL DEFAULT 0,
      UNIQUE(user_id, remote_id)
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

  static Map<String, Object?> _values(Bookmark b) => {
    ...(b.toMap()..remove('id')),
    'chapter_index': b.chapterIndex,
    'chapter_title': b.chapterTitle,
  };
  static Bookmark _decode(Map<String, Object?> row) =>
      Bookmark.fromMap({...row, 'id': row['local_id']});
  static bool _same(Bookmark a, Bookmark b) =>
      a.novelId == b.novelId &&
      a.chapterId == b.chapterId &&
      a.scrollOffset == b.scrollOffset &&
      a.note == b.note &&
      a.createdAt == b.createdAt;

  Future<List<Bookmark>> load(int novelId, String uid) => _run(uid, () async {
    if (uid.isNotEmpty) {
      try {
        final cloud = (await remote.getBookmarks(
          novelId,
          userId: uid,
        )).toList();
        final pending = await db.query(
          table,
          where: 'user_id = ? AND novel_id = ? AND pending = 1',
          whereArgs: [uid, novelId],
        );
        for (final row in pending) {
          final bookmark = _decode(row);
          var existing = cloud.where((b) => _same(b, bookmark)).firstOrNull;
          if (existing == null) {
            existing = bookmark.copyWith(
              id: await remote.addBookmark(bookmark, userId: uid),
            );
            cloud.add(existing);
          }
          await db.update(
            table,
            {'remote_id': existing.id, 'pending': 0},
            where: 'local_id = ?',
            whereArgs: [row['local_id']],
          );
        }
        await db.transaction((txn) async {
          final remoteIds = <int>{};
          for (final b in cloud) {
            if (b.id == null) continue;
            remoteIds.add(b.id!);
            var saved = await txn.query(
              table,
              columns: ['local_id'],
              where: 'user_id = ? AND remote_id = ?',
              whereArgs: [uid, b.id],
            );
            if (saved.isEmpty) {
              saved = await txn.query(
                table,
                columns: ['local_id'],
                where: 'user_id = ? AND novel_id = ? AND chapter_id = ? AND scroll_offset = ? AND note = ? AND created_at = ? AND pending = 1',
                whereArgs: [
                  uid,
                  b.novelId,
                  b.chapterId,
                  b.scrollOffset,
                  b.note,
                  b.createdAt.millisecondsSinceEpoch,
                ],
              );
            }
            final row = {
              ..._values(b),
              'user_id': uid,
              'remote_id': b.id,
              'pending': 0,
            };
            if (saved.isEmpty) {
              await txn.insert(table, row);
            } else {
              await txn.update(
                table,
                row,
                where: 'local_id = ?',
                whereArgs: [saved.single['local_id']],
              );
            }
          }
          final cached = await txn.query(
            table,
            columns: ['local_id', 'remote_id'],
            where: 'user_id = ? AND novel_id = ? AND pending = 0',
            whereArgs: [uid, novelId],
          );
          for (final row in cached) {
            if (!remoteIds.contains(row['remote_id'])) {
              await txn.delete(
                table,
                where: 'local_id = ?',
                whereArgs: [row['local_id']],
              );
            }
          }
        });
      } catch (error) {
        debugPrint('Dùng dấu trang đã lưu trên thiết bị: $error');
      }
    }
    return (await db.query(
      table,
      where: 'user_id = ? AND novel_id = ?',
      whereArgs: [uid, novelId],
      orderBy: 'chapter_index, scroll_offset',
    )).map(_decode).toList();
  });

  Future<int> add(Bookmark bookmark, String uid) => _run(uid, () async {
    final remoteId = uid.isEmpty
        ? null
        : await remote.addBookmark(bookmark, userId: uid);
    return db.insert(table, {
      ..._values(bookmark),
      'user_id': uid,
      'remote_id': remoteId,
    });
  });

  Future<void> remove(int localId, String uid) => _run(uid, () async {
    final rows = await db.query(
      table,
      where: 'local_id = ? AND user_id = ?',
      whereArgs: [localId, uid],
    );
    if (rows.isEmpty) return;
    final remoteId = rows.single['remote_id'] as int?;
    if (uid.isNotEmpty && remoteId != null) {
      await remote.deleteBookmark(remoteId, userId: uid);
    }
    await db.delete(
      table,
      where: 'local_id = ? AND user_id = ?',
      whereArgs: [localId, uid],
    );
  });

  static Future<void> restore(Transaction txn, List rows, String uid) async {
    for (final row in rows.whereType<Map<String, dynamic>>()) {
      final b = Bookmark.fromMap(row);
      final saved = await txn.query(
        table,
        where: 'user_id = ? AND novel_id = ? AND chapter_id = ? AND scroll_offset = ? AND note = ? AND created_at = ?',
        whereArgs: [
          uid,
          b.novelId,
          b.chapterId,
          b.scrollOffset,
          b.note,
          b.createdAt.millisecondsSinceEpoch,
        ],
      );
      if (saved.isEmpty) {
        await txn.insert(table, {..._values(b), 'user_id': uid, 'pending': 1});
      }
    }
  }
}
