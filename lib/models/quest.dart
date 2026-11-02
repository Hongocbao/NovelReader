/// Định nghĩa nhiệm vụ ngày, tuần hoặc sự kiện do Admin tạo.
class Quest {
  final int id;

  /// `daily` | `weekly` | `event`
  final String type;
  final String title;

  /// `read_minutes` | `read_chapters` | `comment` | `finish_novel`
  final String goalType;
  final int goalValue;
  final int reward;
  final DateTime startsAt;
  final DateTime endsAt;
  final bool isActive;

  const Quest({
    required this.id,
    required this.type,
    required this.title,
    required this.goalType,
    required this.goalValue,
    required this.reward,
    required this.startsAt,
    required this.endsAt,
    this.isActive = true,
  });

  Map<String, Object?> toMap() => {
        if (id > 0) 'id': id,
        'type': type,
        'title': title,
        'goal_type': goalType,
        'goal_value': goalValue,
        'reward': reward,
        'starts_at': startsAt.millisecondsSinceEpoch,
        'ends_at': endsAt.millisecondsSinceEpoch,
        'is_active': isActive ? 1 : 0,
      };

  factory Quest.fromMap(Map<String, Object?> map) => Quest(
        id: (map['id'] as int?) ?? 0,
        type: (map['type'] as String?) ?? 'daily',
        title: (map['title'] as String?) ?? '',
        goalType: (map['goal_type'] as String?) ?? 'read_minutes',
        goalValue: (map['goal_value'] as int?) ?? 10,
        reward: (map['reward'] as int?) ?? 20,
        startsAt: DateTime.fromMillisecondsSinceEpoch(
          (map['starts_at'] as int?) ?? 0,
        ),
        endsAt: DateTime.fromMillisecondsSinceEpoch(
          (map['ends_at'] as int?) ?? 0,
        ),
        isActive: (map['is_active'] as int?) != 0,
      );
}

/// Tiến độ thực hiện một nhiệm vụ của người dùng.
class UserQuest {
  final String userId;
  final int questId;
  final int progress;
  final bool claimed;

  const UserQuest({
    required this.userId,
    required this.questId,
    required this.progress,
    this.claimed = false,
  });

  Map<String, Object?> toMap() => {
        'user_id': userId,
        'quest_id': questId,
        'progress': progress,
        'claimed': claimed ? 1 : 0,
      };

  factory UserQuest.fromMap(Map<String, Object?> map) => UserQuest(
        userId: map['user_id']?.toString() ?? '',
        questId: (map['quest_id'] as int?) ?? 0,
        progress: (map['progress'] as int?) ?? 0,
        claimed: (map['claimed'] as int?) == 1,
      );
}
