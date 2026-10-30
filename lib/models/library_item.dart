import 'novel.dart';

/// Một truyện nằm trong tủ sách, kèm thông tin tiến độ (lấy bằng JOIN).
class LibraryItem {
  final int novelId;

  /// reading | want | finished
  final String category;
  final DateTime addedAt;

  /// Thông tin truyện (có khi truy vấn kèm JOIN).
  final Novel? novel;

  /// Số thứ tự chương đọc gần nhất (null nếu chưa đọc).
  final int? lastChapterIndex;

  /// Thời điểm đọc gần nhất.
  final DateTime? lastReadAt;

  const LibraryItem({
    required this.novelId,
    required this.category,
    required this.addedAt,
    this.novel,
    this.lastChapterIndex,
    this.lastReadAt,
  });

  /// Tỉ lệ tiến độ 0..1 theo số chương.
  double get progress {
    final total = novel?.totalChapters ?? 0;
    if (total == 0 || lastChapterIndex == null) return 0;
    return (lastChapterIndex! / total).clamp(0, 1).toDouble();
  }

  /// Chỉ các cột của bảng library.
  Map<String, Object?> toMap() => {
        'novel_id': novelId,
        'category': category,
        'added_at': addedAt.millisecondsSinceEpoch,
      };

  /// Đọc từ dòng SQLite; nếu có cột của bảng novels (JOIN) thì tạo kèm [novel].
  factory LibraryItem.fromMap(Map<String, Object?> map) {
    final hasNovel = map.containsKey('title') && map['id'] != null;
    final lastRead = map['last_read_at'] as int?;
    return LibraryItem(
      novelId: map['novel_id'] as int,
      category: map['category'] as String,
      addedAt:
          DateTime.fromMillisecondsSinceEpoch((map['added_at'] as int?) ?? 0),
      novel: hasNovel ? Novel.fromMap(map) : null,
      lastChapterIndex: map['last_chapter_index'] as int?,
      lastReadAt:
          lastRead == null ? null : DateTime.fromMillisecondsSinceEpoch(lastRead),
    );
  }

  LibraryItem copyWith({
    int? novelId,
    String? category,
    DateTime? addedAt,
    Novel? novel,
    int? lastChapterIndex,
    DateTime? lastReadAt,
  }) {
    return LibraryItem(
      novelId: novelId ?? this.novelId,
      category: category ?? this.category,
      addedAt: addedAt ?? this.addedAt,
      novel: novel ?? this.novel,
      lastChapterIndex: lastChapterIndex ?? this.lastChapterIndex,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }
}
