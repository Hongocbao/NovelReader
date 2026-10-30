/// Bản tóm tắt chương phục vụ tính năng "Previously on..." (Recap).
class ChapterSummary {
  final int chapterId;
  final int novelId;
  final int chapterIndex;
  final String summary;

  const ChapterSummary({
    required this.chapterId,
    required this.novelId,
    required this.chapterIndex,
    required this.summary,
  });

  Map<String, Object?> toMap() => {
        'chapter_id': chapterId,
        'novel_id': novelId,
        'chapter_index': chapterIndex,
        'summary': summary,
      };

  factory ChapterSummary.fromMap(Map<String, Object?> map) => ChapterSummary(
        chapterId: (map['chapter_id'] as int?) ?? 0,
        novelId: (map['novel_id'] as int?) ?? 0,
        chapterIndex: (map['chapter_index'] as int?) ?? 1,
        summary: (map['summary'] as String?) ?? '',
      );
}

/// Phản ứng cảm xúc (emoji) gắn vào một đoạn văn trong chương.
class ParagraphReaction {
  final int userId;
  final int chapterId;
  final int paragraphIndex;
  final String emoji;

  const ParagraphReaction({
    required this.userId,
    required this.chapterId,
    required this.paragraphIndex,
    required this.emoji,
  });

  Map<String, Object?> toMap() => {
        'user_id': userId,
        'chapter_id': chapterId,
        'paragraph_index': paragraphIndex,
        'emoji': emoji,
      };

  factory ParagraphReaction.fromMap(Map<String, Object?> map) =>
      ParagraphReaction(
        userId: (map['user_id'] as int?) ?? 0,
        chapterId: (map['chapter_id'] as int?) ?? 0,
        paragraphIndex: (map['paragraph_index'] as int?) ?? 0,
        emoji: (map['emoji'] as String?) ?? '❤️',
      );
}

/// Ghi chú Hộp thư thời gian (Time Capsule) gửi cho chính mình ở tương lai.
class TimeCapsuleNote {
  final int? id;
  final int userId;
  final int novelId;
  final int chapterId;
  final String note;
  final int unlockAfterDays;
  final DateTime createdAt;

  const TimeCapsuleNote({
    this.id,
    required this.userId,
    required this.novelId,
    required this.chapterId,
    required this.note,
    this.unlockAfterDays = 30,
    required this.createdAt,
  });

  bool get isUnlocked =>
      DateTime.now().difference(createdAt).inDays >= unlockAfterDays;

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'user_id': userId,
        'novel_id': novelId,
        'chapter_id': chapterId,
        'note': note,
        'unlock_after_days': unlockAfterDays,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory TimeCapsuleNote.fromMap(Map<String, Object?> map) => TimeCapsuleNote(
        id: map['id'] as int?,
        userId: (map['user_id'] as int?) ?? 0,
        novelId: (map['novel_id'] as int?) ?? 0,
        chapterId: (map['chapter_id'] as int?) ?? 0,
        note: (map['note'] as String?) ?? '',
        unlockAfterDays: (map['unlock_after_days'] as int?) ?? 30,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          (map['created_at'] as int?) ?? 0,
        ),
      );
}

/// Đề xuất / Yêu cầu truyện mới từ cộng đồng độc giả.
class NovelRequestItem {
  final int? id;
  final int userId;
  final String userName;
  final String title;
  final String authorHint;
  final String description;
  final int votes;
  final DateTime createdAt;

  const NovelRequestItem({
    this.id,
    required this.userId,
    required this.userName,
    required this.title,
    this.authorHint = '',
    this.description = '',
    this.votes = 1,
    required this.createdAt,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'user_id': userId,
        'user_name': userName,
        'title': title,
        'author_hint': authorHint,
        'description': description,
        'votes': votes,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory NovelRequestItem.fromMap(Map<String, Object?> map) =>
      NovelRequestItem(
        id: map['id'] as int?,
        userId: (map['user_id'] as int?) ?? 0,
        userName: (map['user_name'] as String?) ?? 'Độc giả',
        title: (map['title'] as String?) ?? '',
        authorHint: (map['author_hint'] as String?) ?? '',
        description: (map['description'] as String?) ?? '',
        votes: (map['votes'] as int?) ?? 1,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          (map['created_at'] as int?) ?? 0,
        ),
      );
}
