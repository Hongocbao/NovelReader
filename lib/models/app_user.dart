/// Vai trò người dùng trong hệ thống.
class UserRole {
  UserRole._();
  static const String guest = 'guest';
  static const String user = 'user';
  static const String admin = 'admin';
}

/// Trạng thái hoạt động của tài khoản.
class UserStatus {
  UserStatus._();
  static const String active = 'active';
  static const String banned = 'banned';
}

/// Mô hình hồ sơ người dùng trong NovelReader v2 (đồng bộ với bảng `profiles` trên Supabase).
class AppUser {
  /// UUID từ Supabase Auth (auth.users.id)
  final String id;
  final String email;
  final String displayName;
  final String avatar;
  final String avatarFrame;

  /// `user` | `admin` | `guest`
  final String role;

  /// Cờ phụ cho phép đăng truyện/chương.
  final bool isAuthor;

  /// `active` | `banned`
  final String status;
  final String? banReason;
  final DateTime? banUntil;

  /// Đơn vị tiền tệ thưởng khi đọc & làm nhiệm vụ.
  final int linhThach;
  final int streak;
  final bool hasStreakShield;

  /// Danh sách mã huy hiệu được ghim trên hồ sơ (tối đa 3).
  final List<String> pinnedAchievements;

  /// Danh sách khung avatar/nền đọc/font đã mở khóa bằng Linh Thạch.
  final List<String> unlockedItems;

  final DateTime lastActiveAt;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatar = '📚',
    this.avatarFrame = 'default',
    this.role = UserRole.user,
    this.isAuthor = false,
    this.status = UserStatus.active,
    this.banReason,
    this.banUntil,
    this.linhThach = 100,
    this.streak = 0,
    this.hasStreakShield = false,
    this.pinnedAchievements = const [],
    this.unlockedItems = const ['default'],
    required this.lastActiveAt,
    required this.createdAt,
  });

  /// Tạo tài khoản Khách mặc định khi chưa đăng nhập.
  factory AppUser.guest() {
    final now = DateTime.now();
    return AppUser(
      id: '',
      email: 'guest@local',
      displayName: 'Độc giả Khách',
      avatar: '👤',
      role: UserRole.guest,
      lastActiveAt: now,
      createdAt: now,
    );
  }

  bool get isGuest => role == UserRole.guest || id.isEmpty || id == '0';
  bool get isAdmin => role == UserRole.admin;

  /// Kiểm tra tài khoản hiện có đang bị khóa (vĩnh viễn hoặc còn trong hạn khóa) hay không.
  bool get isBanned {
    if (status != UserStatus.banned) return false;
    if (banUntil == null) return true;
    return DateTime.now().isBefore(banUntil!);
  }

  Map<String, Object?> toMap() => {
        if (id.isNotEmpty) 'id': id,
        'email': email.toLowerCase().trim(),
        'display_name': displayName,
        'avatar': avatar,
        'avatar_frame': avatarFrame,
        'role': role,
        'is_author': isAuthor ? 1 : 0,
        'status': status,
        'ban_reason': banReason,
        'ban_until': banUntil?.millisecondsSinceEpoch,
        'linh_thach': linhThach,
        'streak': streak,
        'has_streak_shield': hasStreakShield ? 1 : 0,
        'pinned_achievements': pinnedAchievements.join(','),
        'unlocked_items': unlockedItems.join(','),
        'last_active_at': lastActiveAt.millisecondsSinceEpoch,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory AppUser.fromMap(Map<String, Object?> map) {
    final pinnedRaw = (map['pinned_achievements'] as String?) ?? '';
    final unlockedRaw = (map['unlocked_items'] as String?) ?? 'default';
    final banUntilMs = map['ban_until'] as int?;
    return AppUser(
      id: (map['id'] ?? '').toString(),
      email: (map['email'] as String?) ?? '',
      displayName: (map['display_name'] as String?) ?? 'Độc giả',
      avatar: (map['avatar'] as String?) ?? '📚',
      avatarFrame: (map['avatar_frame'] as String?) ?? 'default',
      role: (map['role'] as String?) ?? UserRole.user,
      isAuthor: map['is_author'] == 1 || map['is_author'] == true,
      status: (map['status'] as String?) ?? UserStatus.active,
      banReason: map['ban_reason'] as String?,
      banUntil: banUntilMs != null
          ? DateTime.fromMillisecondsSinceEpoch(banUntilMs)
          : null,
      linhThach: (map['linh_thach'] as int?) ?? 100,
      streak: (map['streak'] as int?) ?? 0,
      hasStreakShield: map['has_streak_shield'] == 1 || map['has_streak_shield'] == true,
      pinnedAchievements: pinnedRaw
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      unlockedItems: unlockedRaw
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      lastActiveAt: DateTime.fromMillisecondsSinceEpoch(
        (map['last_active_at'] as int?) ?? 0,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['created_at'] as int?) ?? 0,
      ),
    );
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatar,
    String? avatarFrame,
    String? role,
    bool? isAuthor,
    String? status,
    String? banReason,
    DateTime? banUntil,
    int? linhThach,
    int? streak,
    bool? hasStreakShield,
    List<String>? pinnedAchievements,
    List<String>? unlockedItems,
    DateTime? lastActiveAt,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      avatarFrame: avatarFrame ?? this.avatarFrame,
      role: role ?? this.role,
      isAuthor: isAuthor ?? this.isAuthor,
      status: status ?? this.status,
      banReason: banReason ?? this.banReason,
      banUntil: banUntil ?? this.banUntil,
      linhThach: linhThach ?? this.linhThach,
      streak: streak ?? this.streak,
      hasStreakShield: hasStreakShield ?? this.hasStreakShield,
      pinnedAchievements: pinnedAchievements ?? this.pinnedAchievements,
      unlockedItems: unlockedItems ?? this.unlockedItems,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
