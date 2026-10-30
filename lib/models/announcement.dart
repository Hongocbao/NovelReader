/// Thông báo hệ thống do Admin phát hành.
class Announcement {
  final int? id;
  final String title;
  final String body;

  /// `all` | `authors`
  final String audience;
  final bool pinned;
  final int createdBy;
  final DateTime createdAt;

  const Announcement({
    this.id,
    required this.title,
    required this.body,
    this.audience = 'all',
    this.pinned = false,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'body': body,
        'audience': audience,
        'pinned': pinned ? 1 : 0,
        'created_by': createdBy,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory Announcement.fromMap(Map<String, Object?> map) => Announcement(
        id: map['id'] as int?,
        title: (map['title'] as String?) ?? '',
        body: (map['body'] as String?) ?? '',
        audience: (map['audience'] as String?) ?? 'all',
        pinned: (map['pinned'] as int?) == 1,
        createdBy: (map['created_by'] as int?) ?? 1,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          (map['created_at'] as int?) ?? 0,
        ),
      );
}
