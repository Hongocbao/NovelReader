/// Định nghĩa một huy hiệu thành tựu (Achievement) trong hệ thống.
class Achievement {
  final String code;
  final String name;
  final String description;
  final String icon;
  final String ruleJson;

  const Achievement({
    required this.code,
    required this.name,
    required this.description,
    required this.icon,
    this.ruleJson = '{}',
  });

  Map<String, Object?> toMap() => {
        'code': code,
        'name': name,
        'description': description,
        'icon': icon,
        'rule_json': ruleJson,
      };

  factory Achievement.fromMap(Map<String, Object?> map) => Achievement(
        code: (map['code'] as String?) ?? '',
        name: (map['name'] as String?) ?? '',
        description: (map['description'] as String?) ?? '',
        icon: (map['icon'] as String?) ?? '🏅',
        ruleJson: (map['rule_json'] as String?) ?? '{}',
      );
}

/// Huy hiệu đã được người dùng mở khóa.
class UserAchievement {
  final String userId;
  final String code;
  final DateTime unlockedAt;

  const UserAchievement({
    required this.userId,
    required this.code,
    required this.unlockedAt,
  });

  Map<String, Object?> toMap() => {
        'user_id': userId,
        'code': code,
        'unlocked_at': unlockedAt.millisecondsSinceEpoch,
      };

  factory UserAchievement.fromMap(Map<String, Object?> map) => UserAchievement(
        userId: map['user_id']?.toString() ?? '',
        code: (map['code'] as String?) ?? '',
        unlockedAt: DateTime.fromMillisecondsSinceEpoch(
          (map['unlocked_at'] as int?) ?? 0,
        ),
      );
}
