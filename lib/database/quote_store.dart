import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/bookmark.dart';
import '../repositories/quote_remote.dart';

/// Dùng bảng trích dẫn có sẵn; dữ liệu cũ được giữ trong chế độ Khách.
class QuoteStore {
  QuoteStore(this.db, this.remote);
  final Database db;
  final QuoteRemote? remote;
  final _operations = <String, Future<void>>{};

  static Future<void> ensureSchema(Database db) async {
    final columns = (await db.rawQuery('PRAGMA table_info(trich_dan)'))
        .map((row) => row['name'])
        .toSet();
    for (final entry in {
      'user_id': "TEXT NOT NULL DEFAULT ''",
      'remote_id': 'INTEGER',
      'pending': 'INTEGER NOT NULL DEFAULT 0',
    }.entries) {
      if (!columns.contains(entry.key)) {
        await db.execute(
          'ALTER TABLE trich_dan ADD COLUMN ${entry.key} ${entry.value}',
        );
      }
    }
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_trich_dan_remote ON trich_dan(user_id, remote_id)',
    );
  }

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

  static Map<String, Object?> _values(QuoteItem q) => q.toMap()..remove('id');
  static bool _same(QuoteItem a, QuoteItem b) =>
      a.novelId == b.novelId &&
      a.novelTitle == b.novelTitle &&
      a.author == b.author &&
      a.chapterTitle == b.chapterTitle &&
      a.content == b.content &&
      a.createdAt.millisecondsSinceEpoch == b.createdAt.millisecondsSinceEpoch;
  static Future<List<Map<String, Object?>>> _matching(
    DatabaseExecutor db,
    QuoteItem q,
    String uid,
  ) => db.query(
    'trich_dan',
    where: 'user_id = ? AND novel_id = ? AND novel_title = ? AND author = ? AND chapter_title = ? AND content = ? AND created_at = ?',
    whereArgs: [
      uid,
      q.novelId,
      q.novelTitle,
      q.author,
      q.chapterTitle,
      q.content,
      q.createdAt.millisecondsSinceEpoch,
    ],
  );

  Future<List<QuoteItem>> load(String uid) => _run(uid, () async {
    final server = remote;
    if (uid.isNotEmpty && server != null) {
      try {
        final cloud = (await server.getQuotes(userId: uid)).toList();
        final pending = await db.query(
          'trich_dan',
          where: 'user_id = ? AND novel_id >= 0 AND pending = 1',
          whereArgs: [uid],
        );
        for (final row in pending) {
          final quote = QuoteItem.fromMap(row);
          final values = _values(quote);
          final existing = cloud.where((q) => _same(q, quote)).firstOrNull;
          final remoteId =
              existing?.id ?? await server.addQuote(quote, userId: uid);
          await db.update(
            'trich_dan',
            {'remote_id': remoteId, 'pending': 0},
            where: 'id = ?',
            whereArgs: [quote.id],
          );
          if (existing == null) {
            cloud.add(QuoteItem.fromMap({...values, 'id': remoteId}));
          }
        }
        await db.transaction((txn) async {
          final remoteIds = <int>{};
          for (final q in cloud) {
            if (q.id == null) continue;
            remoteIds.add(q.id!);
            var saved = await txn.query(
              'trich_dan',
              columns: ['id'],
              where: 'user_id = ? AND remote_id = ?',
              whereArgs: [uid, q.id],
            );
            if (saved.isEmpty) saved = await _matching(txn, q, uid);
            final data = {
              ..._values(q),
              'user_id': uid,
              'remote_id': q.id,
              'pending': 0,
            };
            if (saved.isEmpty) {
              await txn.insert('trich_dan', data);
            } else {
              await txn.update(
                'trich_dan',
                data,
                where: 'id = ?',
                whereArgs: [saved.first['id']],
              );
            }
          }
          final rows = await txn.query(
            'trich_dan',
            columns: ['id', 'remote_id'],
            where: 'user_id = ? AND remote_id IS NOT NULL AND pending = 0',
            whereArgs: [uid],
          );
          for (final row in rows) {
            if (!remoteIds.contains(row['remote_id'])) {
              await txn.delete(
                'trich_dan',
                where: 'id = ?',
                whereArgs: [row['id']],
              );
            }
          }
        });
      } catch (error) {
        debugPrint('Dùng trích dẫn đã lưu trên thiết bị: $error');
      }
    }
    return (await db.query(
      'trich_dan',
      where: 'user_id = ?',
      whereArgs: [uid],
      orderBy: 'created_at DESC, id DESC',
    )).map(QuoteItem.fromMap).toList();
  });

  Future<int> add(QuoteItem quote, String uid) => _run(uid, () async {
    if (quote.content.trim().isEmpty) {
      throw ArgumentError('Trích dẫn không được để trống.');
    }
    final remoteId = uid.isNotEmpty && quote.novelId >= 0 && remote != null
        ? await remote!.addQuote(quote, userId: uid)
        : null;
    return db.insert('trich_dan', {
      ..._values(quote),
      'user_id': uid,
      'remote_id': remoteId,
    });
  });

  Future<void> remove(int id, String uid) => _run(uid, () async {
    final rows = await db.query(
      'trich_dan',
      columns: ['remote_id'],
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, uid],
    );
    if (rows.isEmpty) return;
    final remoteId = rows.single['remote_id'] as int?;
    if (remoteId != null && remote != null) {
      await remote!.deleteQuote(remoteId, userId: uid);
    }
    await db.delete(
      'trich_dan',
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, uid],
    );
  });

  static Future<void> restore(Transaction txn, List rows, String uid) async {
    for (final row in rows.whereType<Map<String, dynamic>>()) {
      final quote = QuoteItem.fromMap(row);
      if ((await _matching(txn, quote, uid)).isEmpty) {
        await txn.insert('trich_dan', {
          ..._values(quote),
          'user_id': uid,
          'pending': quote.novelId >= 0 ? 1 : 0,
        });
      }
    }
  }
}
