/// Bản ghi chi tiết một phiên đọc truyện của người dùng (phục vụ Heatmap, Wrapped & Nhiệm vụ).
class ReadingSession {
  final int? id;
  /// UUID Supabase hoặc mã người dùng cũ ở dữ liệu local.
  final String userId;
  final int novelId;
  final int chapterId;
  final DateTime startedAt;
  final DateTime endedAt;
  final int wordsRead;
  final int hourOfDay;

  const ReadingSession({
    this.id,
    required this.userId,
    required this.novelId,
    required this.chapterId,
    required this.startedAt,
    required this.endedAt,
    required this.wordsRead,
    required this.hourOfDay,
  });

  /// Thời lượng phiên đọc tính bằng phút (tối thiểu 1 phút nếu có đọc từ).
  int get durationMinutes {
    final diff = endedAt.difference(startedAt).inMinutes;
    if (diff <= 0 && wordsRead > 0) return 1;
    return diff.clamp(0, 720);
  }

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'user_id': userId,
        'novel_id': novelId,
        'chapter_id': chapterId,
        'started_at': startedAt.millisecondsSinceEpoch,
        'ended_at': endedAt.millisecondsSinceEpoch,
        'words_read': wordsRead,
        'hour_of_day': hourOfDay,
      };

  factory ReadingSession.fromMap(Map<String, Object?> map) => ReadingSession(
        id: map['id'] as int?,
        userId: map['user_id']?.toString() ?? '',
        novelId: (map['novel_id'] as int?) ?? 0,
        chapterId: (map['chapter_id'] as int?) ?? 0,
        startedAt: DateTime.fromMillisecondsSinceEpoch(
          (map['started_at'] as int?) ?? 0,
        ),
        endedAt: DateTime.fromMillisecondsSinceEpoch(
          (map['ended_at'] as int?) ?? 0,
        ),
        wordsRead: (map['words_read'] as int?) ?? 0,
        hourOfDay: (map['hour_of_day'] as int?) ?? 0,
      );
}
