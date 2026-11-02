/// Một thông báo trong Trung tâm thông báo của người dùng.
class NotificationItem {
  final int? id;
  final String userId;
  final String title;
  final String body;

  /// `new_chapter` | `system` | `moderation` | `quest_reward`
  final String kind;
  final bool isRead;
  final DateTime createdAt;

  const NotificationItem({
    this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.kind = 'system',
    this.isRead = false,
    required this.createdAt,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'user_id': userId,
        'title': title,
        'body': body,
        'kind': kind,
        'is_read': isRead ? 1 : 0,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory NotificationItem.fromMap(Map<String, Object?> map) =>
      NotificationItem(
        id: map['id'] as int?,
        userId: map['user_id']?.toString() ?? '',
        title: (map['title'] as String?) ?? '',
        body: (map['body'] as String?) ?? '',
        kind: (map['kind'] as String?) ?? 'system',
        isRead: (map['is_read'] as int?) == 1,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          (map['created_at'] as int?) ?? 0,
        ),
      );
}
