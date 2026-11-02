import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../database/v2_database_store.dart';
import '../models/achievement.dart';
import '../models/app_user.dart';
import '../models/notification_item.dart';
import '../models/quest.dart';
import '../utils/role_guard.dart';
import 'auth_provider.dart';

/// Quản lý Nhiệm vụ (Quests), Huy hiệu (Achievements) và thưởng Linh Thạch.
class QuestProvider extends ChangeNotifier {
  final AppDatabase _appDb;

  List<Quest> _quests = [];
  Map<int, UserQuest> _userQuests = {};
  List<Achievement> _achievements = [];
  List<UserAchievement> _unlocked = [];
  bool _isLoading = false;
  String? _error;

  QuestProvider(this._appDb);

  List<Quest> get quests => _quests;
  Map<int, UserQuest> get userQuests => _userQuests;
  List<Achievement> get achievements => _achievements;
  List<UserAchievement> get unlocked => _unlocked;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Set<String> get unlockedCodes => _unlocked.map((e) => e.code).toSet();

  /// Nạp danh sách nhiệm vụ và huy hiệu cho [userId].
  Future<void> loadForUser(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final db = await _appDb.database;
      _quests = await V2DatabaseStore.getActiveQuests(db);
      _achievements = await V2DatabaseStore.getAllAchievements(db);
      if (userId.isNotEmpty) {
        _userQuests = await V2DatabaseStore.getUserQuests(db, userId);
        _unlocked = await V2DatabaseStore.getUserAchievements(db, userId);
      } else {
        _userQuests = {};
        _unlocked = [];
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Lấy tiến độ hiện tại của một nhiệm vụ.
  int progressOf(int questId) => _userQuests[questId]?.progress ?? 0;

  /// Kiểm tra nhiệm vụ đã nhận thưởng hay chưa.
  bool isClaimed(int questId) => _userQuests[questId]?.claimed ?? false;

  /// Ghi nhận tiến độ nhiệm vụ theo loại mục tiêu (`read_minutes`, `read_chapters`, `comment`, `finish_novel`).
  Future<void> recordProgress({
    required AppUser user,
    required String goalType,
    int delta = 1,
  }) async {
    if (user.isGuest) return;
    final db = await _appDb.database;
    await V2DatabaseStore.incrementQuestProgress(
      db,
      userId: user.id,
      goalType: goalType,
      delta: delta,
    );
    _userQuests = await V2DatabaseStore.getUserQuests(db, user.id);
    notifyListeners();
  }

  /// Nhận thưởng Linh Thạch khi hoàn thành nhiệm vụ.
  Future<int> claimQuestReward({
    required AuthProvider auth,
    required Quest quest,
  }) async {
    final user = auth.currentUser;
    RoleGuard.requirePermission(user, AppPermission.interactAndGamify);
    final uq = _userQuests[quest.id];
    if (uq == null || uq.claimed || uq.progress < quest.goalValue) {
      return 0;
    }
    final db = await _appDb.database;
    await db.update(
      'user_quests',
      {'claimed': 1},
      where: 'user_id = ? AND quest_id = ?',
      whereArgs: [user.id, quest.id],
    );
    await auth.adjustLinhThach(quest.reward);
    await V2DatabaseStore.createNotification(
      db,
      NotificationItem(
        userId: user.id,
        title: '🎁 Nhận thưởng nhiệm vụ thành công!',
        body: 'Bạn nhận được +${quest.reward} Linh Thạch từ "${quest.title}".',
        kind: 'quest_reward',
        createdAt: DateTime.now(),
      ),
    );
    if (auth.currentUser.linhThach >= 500) {
      await unlockBadge(user.id, 'dai_gia_linh_thach');
    }
    _userQuests = await V2DatabaseStore.getUserQuests(db, user.id);
    notifyListeners();
    return quest.reward;
  }

  /// Mở khóa một huy hiệu cho người dùng nếu chưa có.
  Future<bool> unlockBadge(String userId, String code) async {
    if (userId.isEmpty) return false;
    final db = await _appDb.database;
    final added = await V2DatabaseStore.unlockAchievement(db, userId, code);
    if (added) {
      _unlocked = await V2DatabaseStore.getUserAchievements(db, userId);
      notifyListeners();
    }
    return added;
  }
}
