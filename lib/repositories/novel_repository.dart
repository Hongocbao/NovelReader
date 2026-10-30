import '../database/app_database.dart';
import '../models/chapter.dart';
import '../models/novel.dart';
import '../utils/format.dart';

/// Giao diện trừu tượng cho kho lưu trữ Truyện & Chương.
///
/// Cho phép chuyển đổi mượt mà giữa SQLite cục bộ ([LocalNovelRepository] - Giai đoạn A)
/// và Cloud Firestore ([FirestoreNovelRepository] - Giai đoạn B) mà không ảnh hưởng UI.
abstract class NovelRepository {
  Future<List<Novel>> getAllNovels({bool includeDeleted = false});
  Future<List<Novel>> getNovelsByOwner(int ownerId);
  Future<List<Novel>> getPendingNovels();
  Future<Novel> saveNovel(Novel novel);
  Future<void> softDeleteNovel(int novelId);
  Future<void> restoreNovel(int novelId);
  Future<List<Chapter>> getChapters(int novelId);
  Future<void> saveChaptersOrder(int novelId, List<Chapter> orderedChapters);
  Future<Chapter> saveChapter(Chapter chapter);
}

/// Triển khai Giai đoạn A trên SQLite cục bộ.
class LocalNovelRepository implements NovelRepository {
  final AppDatabase _appDb;

  LocalNovelRepository(this._appDb);

  @override
  Future<List<Novel>> getAllNovels({bool includeDeleted = false}) async {
    final db = await _appDb.database;
    final rows = await db.query(
      'novels',
      where: includeDeleted ? null : 'deleted_at IS NULL',
      orderBy: 'updated_at DESC, id DESC',
    );
    return rows.map(Novel.fromMap).toList();
  }

  @override
  Future<List<Novel>> getNovelsByOwner(int ownerId) async {
    final db = await _appDb.database;
    final rows = await db.query(
      'novels',
      where: 'owner_id = ? AND deleted_at IS NULL',
      whereArgs: [ownerId],
      orderBy: 'updated_at DESC',
    );
    return rows.map(Novel.fromMap).toList();
  }

  @override
  Future<List<Novel>> getPendingNovels() async {
    final db = await _appDb.database;
    final rows = await db.query(
      'novels',
      where: "moderation_status = 'pending' AND deleted_at IS NULL",
      orderBy: 'updated_at DESC',
    );
    return rows.map(Novel.fromMap).toList();
  }

  @override
  Future<Novel> saveNovel(Novel novel) async {
    final db = await _appDb.database;
    final map = {
      ...novel.toMap(),
      'search_text': Format.normalize('${novel.title} ${novel.author}'),
    };
    final existing = await db.query(
      'novels',
      where: 'id = ?',
      whereArgs: [novel.id],
    );
    if (existing.isEmpty) {
      await db.insert('novels', map);
    } else {
      await db.update('novels', map, where: 'id = ?', whereArgs: [novel.id]);
    }
    return novel;
  }

  @override
  Future<void> softDeleteNovel(int novelId) async {
    final db = await _appDb.database;
    await db.update(
      'novels',
      {'deleted_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [novelId],
    );
  }

  @override
  Future<void> restoreNovel(int novelId) async {
    final db = await _appDb.database;
    await db.update(
      'novels',
      {'deleted_at': null},
      where: 'id = ?',
      whereArgs: [novelId],
    );
  }

  @override
  Future<List<Chapter>> getChapters(int novelId) async {
    final db = await _appDb.database;
    final rows = await db.query(
      'chapters',
      where: 'novel_id = ?',
      whereArgs: [novelId],
      orderBy: 'chapter_index ASC',
    );
    return rows.map(Chapter.fromMap).toList();
  }

  @override
  Future<void> saveChaptersOrder(
    int novelId,
    List<Chapter> orderedChapters,
  ) async {
    final db = await _appDb.database;
    await db.transaction((txn) async {
      // Đổi tạm sang chỉ số âm để tránh đụng độ UNIQUE(novel_id, chapter_index)
      for (var i = 0; i < orderedChapters.length; i++) {
        await txn.update(
          'chapters',
          {'chapter_index': -(i + 1)},
          where: 'id = ?',
          whereArgs: [orderedChapters[i].id],
        );
      }
      for (var i = 0; i < orderedChapters.length; i++) {
        await txn.update(
          'chapters',
          {'chapter_index': i + 1},
          where: 'id = ?',
          whereArgs: [orderedChapters[i].id],
        );
      }
    });
  }

  @override
  Future<Chapter> saveChapter(Chapter chapter) async {
    final db = await _appDb.database;
    final existing = await db.query(
      'chapters',
      where: 'id = ?',
      whereArgs: [chapter.id],
    );
    if (existing.isEmpty) {
      await db.insert('chapters', chapter.toMap());
    } else {
      await db.update(
        'chapters',
        chapter.toMap(),
        where: 'id = ?',
        whereArgs: [chapter.id],
      );
    }
    final countRows = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM chapters WHERE novel_id = ?',
      [chapter.novelId],
    );
    final total = (countRows.first['c'] as int?) ?? 0;
    await db.update(
      'novels',
      {
        'total_chapters': total,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [chapter.novelId],
    );
    return chapter;
  }
}

/// Triển khai Giai đoạn B (Cloud Adapter) tương thích với Cloud Firestore.
class FirestoreNovelRepository extends LocalNovelRepository {
  FirestoreNovelRepository(super.appDb);
}
