import 'package:sqflite/sqflite.dart';

import '../models/chapter.dart';
import '../models/novel.dart';
import '../utils/format.dart';

/// Khôi phục truyện cá nhân trong cùng transaction với tủ sách và lịch sử.
/// ID âm của máy nguồn có thể trùng máy đích nên phải ánh xạ lại cả chương.
class CustomNovelBackup {
  final novelIds = <int, int>{};
  final chapterIds = <int, int>{};

  static bool _matches(
    Map<String, Object?> novel,
    List<Map<String, Object?>> chapters,
    Map<String, Object?> other,
    List<Map<String, Object?>> otherChapters,
  ) {
    if (chapters.length != otherChapters.length) return false;
    for (final key in ['title', 'author', 'description', 'type', 'genres']) {
      if (novel[key] != other[key]) return false;
    }
    for (var i = 0; i < chapters.length; i++) {
      for (final key in ['chapter_index', 'title', 'content']) {
        if (chapters[i][key] != otherChapters[i][key]) return false;
      }
    }
    return true;
  }

  static Future<CustomNovelBackup> restore(
    Transaction txn,
    Map<String, dynamic> backup,
  ) async {
    final result = CustomNovelBackup();
    final novels = backup['custom_novels'];
    final chapters = backup['custom_chapters'];
    if (novels == null && chapters == null) return result; // Bản sao lưu cũ.
    if (novels is! List || chapters is! List) {
      throw const FormatException('Dữ liệu truyện sao lưu không hợp lệ.');
    }
    final sourceChapters = chapters
        .map((row) => Chapter.fromMap(Map<String, Object?>.from(row as Map)))
        .toList();
    final seen = <int>{};
    for (final raw in novels) {
      final novel = Novel.fromMap(Map<String, Object?>.from(raw as Map));
      if (novel.id >= 0 || !seen.add(novel.id)) {
        throw const FormatException('Mã truyện cá nhân không hợp lệ.');
      }
      final parts = sourceChapters.where((c) => c.novelId == novel.id).toList()
        ..sort((a, b) => a.chapterIndex.compareTo(b.chapterIndex));
      if (parts.isEmpty ||
          parts.any((c) => c.id >= 0 || c.content == null) ||
          parts.map((c) => c.id).toSet().length != parts.length ||
          parts.map((c) => c.chapterIndex).toSet().length != parts.length) {
        throw const FormatException(
          'Thiếu nội dung hoặc trùng chương trong bản sao lưu.',
        );
      }
      final sourceRows = parts.map((c) => c.toMap()).toList();
      final candidates = await txn.query(
        'truyen',
        where: 'id < 0 AND title = ? AND author = ?',
        whereArgs: [novel.title, novel.author],
      );
      int? reused;
      for (final candidate in candidates) {
        final saved = await txn.query(
          'chuong',
          where: 'novel_id = ?',
          whereArgs: [candidate['id']],
          orderBy: 'chapter_index',
        );
        if (_matches(novel.toMap(), sourceRows, candidate, saved)) {
          reused = candidate['id'] as int;
          for (var i = 0; i < parts.length; i++) {
            result.chapterIds[parts[i].id] = saved[i]['id'] as int;
          }
          break;
        }
      }
      if (reused != null) {
        result.novelIds[novel.id] = reused;
        continue;
      }
      var targetId = novel.id;
      if ((await txn.query(
        'truyen',
        columns: ['id'],
        where: 'id = ?',
        whereArgs: [targetId],
      )).isNotEmpty) {
        targetId =
            (Sqflite.firstIntValue(
                  await txn.rawQuery('SELECT MIN(id) FROM truyen WHERE id < 0'),
                ) ??
                0) -
            1;
      }
      result.novelIds[novel.id] = targetId;
      await txn.insert('truyen', {
        ...novel.copyWith(id: targetId, totalChapters: parts.length).toMap(),
        'search_text': Format.normalize('${novel.title} ${novel.author}'),
      });
      for (final part in parts) {
        var chapterId = part.id;
        if ((await txn.query(
          'chuong',
          columns: ['id'],
          where: 'id = ?',
          whereArgs: [chapterId],
        )).isNotEmpty) {
          chapterId =
              (Sqflite.firstIntValue(
                    await txn.rawQuery(
                      'SELECT MIN(id) FROM chuong WHERE id < 0',
                    ),
                  ) ??
                  0) -
              1;
        }
        result.chapterIds[part.id] = chapterId;
        await txn.insert('chuong', {
          ...part.toMap(),
          'id': chapterId,
          'novel_id': targetId,
          'is_downloaded': 1,
        });
      }
    }
    if (sourceChapters.any((c) => !seen.contains(c.novelId)) ||
        sourceChapters.map((c) => c.id).toSet().length !=
            sourceChapters.length) {
      throw const FormatException(
        'Chương không thuộc truyện hoặc mã chương bị trùng.',
      );
    }
    return result;
  }

  Map<String, Object?> remap(Map<String, dynamic> row) => {
    ...row,
    if (row['novel_id'] is int)
      'novel_id': novelIds[row['novel_id']] ?? row['novel_id'],
    if (row['chapter_id'] is int)
      'chapter_id': chapterIds[row['chapter_id']] ?? row['chapter_id'],
    if (row['last_chapter_id'] is int)
      'last_chapter_id':
          chapterIds[row['last_chapter_id']] ?? row['last_chapter_id'],
  };
}
