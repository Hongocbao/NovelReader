import 'novel.dart';

/// Lịch sử đọc của một truyện: chương cuối và vị trí cuộn.
///
/// [scrollOffset] lưu theo TỈ LỆ 0..1 của chiều dài chương (không phải pixel),
/// nhờ vậy khi đổi cỡ chữ hay xoay màn hình vẫn nhảy đúng vị trí.
class ReadingHistory {
  final int novelId;
  final int lastChapterId;
  final double scrollOffset;
  final DateTime lastReadAt;

  // Thông tin kèm theo khi JOIN
  final Novel? novel;
  final int? chapterIndex;
  final String? chapterTitle;

  const ReadingHistory({
    required this.novelId,
    required this.lastChapterId,
    required this.scrollOffset,
    required this.lastReadAt,
    this.novel,
    this.chapterIndex,
    this.chapterTitle,
  });

  Map<String, Object?> toMap() => {
        'novel_id': novelId,
        'last_chapter_id': lastChapterId,
        'scroll_offset': scrollOffset,
        'last_read_at': lastReadAt.millisecondsSinceEpoch,
      };

  factory ReadingHistory.fromMap(Map<String, Object?> map) {
    final hasNovel = map.containsKey('title') && map['id'] != null;
    return ReadingHistory(
      novelId: map['novel_id'] as int,
      lastChapterId: map['last_chapter_id'] as int,
      scrollOffset: ((map['scroll_offset'] as num?) ?? 0).toDouble(),
      lastReadAt: DateTime.fromMillisecondsSinceEpoch(
          (map['last_read_at'] as int?) ?? 0),
      novel: hasNovel ? Novel.fromMap(map) : null,
      chapterIndex: map['chapter_index'] as int?,
      chapterTitle: map['chapter_title'] as String?,
    );
  }

  ReadingHistory copyWith({
    int? novelId,
    int? lastChapterId,
    double? scrollOffset,
    DateTime? lastReadAt,
    Novel? novel,
    int? chapterIndex,
    String? chapterTitle,
  }) {
    return ReadingHistory(
      novelId: novelId ?? this.novelId,
      lastChapterId: lastChapterId ?? this.lastChapterId,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      novel: novel ?? this.novel,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      chapterTitle: chapterTitle ?? this.chapterTitle,
    );
  }
}

/// Thống kê phiên đọc theo từng ngày (bảng `reading_sessions`).
class ReadingSessionStat {
  /// Chuỗi ngày dạng `yyyy-MM-dd`.
  final String dateKey;
  final int wordsRead;
  final int minutesRead;

  const ReadingSessionStat({
    required this.dateKey,
    required this.wordsRead,
    required this.minutesRead,
  });

  Map<String, Object?> toMap() => {
        'date_key': dateKey,
        'words_read': wordsRead,
        'minutes_read': minutesRead,
      };

  factory ReadingSessionStat.fromMap(Map<String, Object?> map) =>
      ReadingSessionStat(
        dateKey: (map['date_key'] as String?) ?? '',
        wordsRead: (map['words_read'] as int?) ?? 0,
        minutesRead: (map['minutes_read'] as int?) ?? 0,
      );
}
