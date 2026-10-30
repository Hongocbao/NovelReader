/// Đánh dấu một vị trí trong chương.
/// [scrollOffset] là tỉ lệ 0..1 (giống [ReadingHistory]).
class Bookmark {
  final int? id;
  final int novelId;
  final int chapterId;
  final double scrollOffset;
  final String note;
  final DateTime createdAt;

  // Thông tin chương kèm theo khi JOIN
  final int? chapterIndex;
  final String? chapterTitle;

  const Bookmark({
    this.id,
    required this.novelId,
    required this.chapterId,
    required this.scrollOffset,
    this.note = '',
    required this.createdAt,
    this.chapterIndex,
    this.chapterTitle,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'novel_id': novelId,
        'chapter_id': chapterId,
        'scroll_offset': scrollOffset,
        'note': note,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory Bookmark.fromMap(Map<String, Object?> map) => Bookmark(
        id: map['id'] as int?,
        novelId: map['novel_id'] as int,
        chapterId: map['chapter_id'] as int,
        scrollOffset: ((map['scroll_offset'] as num?) ?? 0).toDouble(),
        note: (map['note'] as String?) ?? '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            (map['created_at'] as int?) ?? 0),
        chapterIndex: map['chapter_index'] as int?,
        chapterTitle: map['chapter_title'] as String?,
      );

  Bookmark copyWith({
    int? id,
    int? novelId,
    int? chapterId,
    double? scrollOffset,
    String? note,
    DateTime? createdAt,
    int? chapterIndex,
    String? chapterTitle,
  }) {
    return Bookmark(
      id: id ?? this.id,
      novelId: novelId ?? this.novelId,
      chapterId: chapterId ?? this.chapterId,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      chapterTitle: chapterTitle ?? this.chapterTitle,
    );
  }
}

/// Một đoạn trích dẫn tâm đắc được lưu từ nội dung chương (Quote Card).
class QuoteItem {
  final int? id;
  final int novelId;
  final String novelTitle;
  final String author;
  final String chapterTitle;
  final String content;
  final DateTime createdAt;

  const QuoteItem({
    this.id,
    required this.novelId,
    required this.novelTitle,
    required this.author,
    required this.chapterTitle,
    required this.content,
    required this.createdAt,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'novel_id': novelId,
        'novel_title': novelTitle,
        'author': author,
        'chapter_title': chapterTitle,
        'content': content,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory QuoteItem.fromMap(Map<String, Object?> map) => QuoteItem(
        id: map['id'] as int?,
        novelId: map['novel_id'] as int,
        novelTitle: (map['novel_title'] as String?) ?? '',
        author: (map['author'] as String?) ?? '',
        chapterTitle: (map['chapter_title'] as String?) ?? '',
        content: (map['content'] as String?) ?? '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          (map['created_at'] as int?) ?? 0,
        ),
      );
}

/// Bình luận cho một chương hoặc đánh giá cho một bộ truyện.
/// Hỗ trợ Spoiler Shield ([chapterIndex]), ẩn bình luận ([isHidden]), thích ([likes]) và trả lời ([parentId]).
class ChapterComment {
  final int? id;
  final int novelId;
  final int chapterId;
  final int userId;
  final String userName;
  final String content;
  final int stars;
  final int chapterIndex;
  final bool isHidden;
  final int likes;
  final int? parentId;
  final DateTime createdAt;

  const ChapterComment({
    this.id,
    required this.novelId,
    required this.chapterId,
    this.userId = 0,
    this.userName = 'Độc giả',
    required this.content,
    this.stars = 5,
    this.chapterIndex = 1,
    this.isHidden = false,
    this.likes = 0,
    this.parentId,
    required this.createdAt,
  });

  /// Kiểm tra bình luận có nguy cơ tiết lộ nội dung (spoil) với độc giả mới đọc tới [readerMaxChapterIndex] không.
  bool isSpoilerFor(int readerMaxChapterIndex) =>
      chapterIndex > readerMaxChapterIndex;

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'novel_id': novelId,
        'chapter_id': chapterId,
        'user_id': userId,
        'user_name': userName,
        'content': content,
        'stars': stars,
        'chapter_index': chapterIndex,
        'is_hidden': isHidden ? 1 : 0,
        'likes': likes,
        'parent_id': parentId,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory ChapterComment.fromMap(Map<String, Object?> map) => ChapterComment(
        id: map['id'] as int?,
        novelId: map['novel_id'] as int,
        chapterId: map['chapter_id'] as int,
        userId: (map['user_id'] as int?) ?? 0,
        userName: (map['user_name'] as String?) ?? 'Độc giả',
        content: (map['content'] as String?) ?? '',
        stars: (map['stars'] as int?) ?? 5,
        chapterIndex: (map['chapter_index'] as int?) ?? 1,
        isHidden: (map['is_hidden'] as int?) == 1,
        likes: (map['likes'] as int?) ?? 0,
        parentId: map['parent_id'] as int?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          (map['created_at'] as int?) ?? 0,
        ),
      );
}
