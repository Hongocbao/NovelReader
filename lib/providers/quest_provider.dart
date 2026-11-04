import 'dart:async';

import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../models/achievement.dart';
import '../models/app_user.dart';
import '../models/notification_item.dart';
import '../models/quest.dart';
import '../repositories/quest_repository.dart';
import '../utils/role_guard.dart';
import 'auth_provider.dart';

/// Nhiệm vụ và huy hiệu đang hiển thị luôn thuộc tài khoản được bind.
class QuestProvider extends ChangeNotifier {
  QuestProvider(AppDatabase appDb, {QuestRepository? repository})
    : _repository = repository ?? DatabaseQuestRepository(appDb);
  final QuestRepository _repository;
  List<Quest> _quests = [];
  Map<int, UserQuest> _userQuests = {};
  List<Achievement> _achievements = [];
  List<UserAchievement> _unlocked = [];
  String? _userId;
  int _identity = 0, _loadRequest = 0, _progressRequest = 0, _badgeRequest = 0;
  bool _managedBinding = false, _disposed = false, _isLoading = false;
  String? _error;
  final _claims = <({int identity, String userId, int questId})>{};

  List<Quest> get quests => List.unmodifiable(_quests);
  Map<int, UserQuest> get userQuests => Map.unmodifiable(_userQuests);
  List<Achievement> get achievements => List.unmodifiable(_achievements);
  List<UserAchievement> get unlocked => List.unmodifiable(_unlocked);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userId => _userId;
  Set<String> get unlockedCodes => _unlocked.map((e) => e.code).toSet();
  int progressOf(int questId) => _userQuests[questId]?.progress ?? 0;
  bool isClaimed(int questId) => _userQuests[questId]?.claimed ?? false;

  bool _current(String userId, int identity) =>
      !_disposed && _userId == userId && _identity == identity;

  void _switchUser(String userId) {
    _userId = userId;
    _identity++;
    _loadRequest++;
    _progressRequest++;
    _badgeRequest++;
    _quests = [];
    _achievements = [];
    _userQuests = {};
    _unlocked = [];
    _error = null;
    _isLoading = true;
  }

  /// ProxyProvider gọi khi Auth đổi; không notify trong lúc cây widget build.
  void bindUser(String userId) {
    _managedBinding = true;
    if (_disposed || _userId == userId) return;
    _switchUser(userId);
    final identity = _identity;
    scheduleMicrotask(() {
      if (_current(userId, identity)) unawaited(loadForUser(userId));
    });
  }

  Future<void> loadForUser(String userId) async {
    if (_disposed) return;
    if (_userId != userId) {
      // A delayed old reader callback must not rebind the active account.
      if (_managedBinding) return;
      _switchUser(userId);
    }
    final identity = _identity;
    final request = ++_loadRequest;
    final progressRequest = _progressRequest;
    final badgeRequest = _badgeRequest;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      // Collect first; never publish a partially loaded mixed-account snapshot.
      final quests = await _repository.getActiveQuests();
      final achievements = await _repository.getAchievements();
      final progress = userId.isEmpty
          ? <int, UserQuest>{}
          : await _repository.getUserQuests(userId);
      final badges = userId.isEmpty
          ? <UserAchievement>[]
          : await _repository.getUserAchievements(userId);
      if (!_current(userId, identity) || request != _loadRequest) return;
      _quests = quests;
      _achievements = achievements;
      if (progressRequest == _progressRequest) {
        _userQuests = Map.fromEntries(
          progress.entries.where((e) => e.value.userId == userId),
        );
      }
      if (badgeRequest == _badgeRequest) {
        _unlocked = badges.where((b) => b.userId == userId).toList();
      }
    } catch (error) {
      if (_current(userId, identity) && request == _loadRequest) {
        _error = error.toString();
      }
    } finally {
      if (_current(userId, identity) && request == _loadRequest) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> recordProgress({
    required AppUser user,
    required String goalType,
    int delta = 1,
  }) async {
    if (user.isGuest || delta <= 0 || _userId != user.id || _disposed) return;
    final identity = _identity;
    await _repository.recordProgress(user.id, goalType, delta);
    if (!_current(user.id, identity)) return;
    final request = ++_progressRequest;
    final progress = await _repository.getUserQuests(user.id);
    if (!_current(user.id, identity) || request != _progressRequest) return;
    _userQuests = Map.fromEntries(
      progress.entries.where((e) => e.value.userId == user.id),
    );
    notifyListeners();
  }

  Future<int> claimQuestReward({
    required AuthProvider auth,
    required Quest quest,
  }) async {
    final user = auth.currentUser;
    RoleGuard.requirePermission(user, AppPermission.interactAndGamify);
    final identity = _identity;
    if (!_current(user.id, identity)) return 0;
    final currentQuest = _quests.where((q) => q.id == quest.id).firstOrNull;
    final uq = _userQuests[quest.id];
    final now = DateTime.now();
    if (currentQuest == null ||
        !currentQuest.isActive ||
        currentQuest.goalValue <= 0 ||
        now.isBefore(currentQuest.startsAt) ||
        now.isAfter(currentQuest.endsAt) ||
        uq == null ||
        uq.claimed ||
        uq.progress < currentQuest.goalValue) {
      return 0;
    }
    final key = (identity: identity, userId: user.id, questId: quest.id);
    if (!_claims.add(key)) return 0;
    try {
      final reward = await auth.claimQuestReward(quest.id, currentQuest.reward);
      if (reward == null) return 0;
      final claim = UserQuest(
        userId: user.id,
        questId: quest.id,
        progress: uq.progress,
        claimed: true,
      );
      if (_current(user.id, identity) && auth.currentUser.id == user.id) {
        ++_progressRequest; // Ignore reads that started before the claim.
        _userQuests = {..._userQuests, quest.id: claim};
        notifyListeners();
      }
      // Coins have already been committed. Secondary cache/notification errors
      // must not turn a successful claim into a failed-payment message.
      try {
        await _repository.cacheClaim(claim);
      } catch (error) {
        debugPrint('Chưa lưu được bộ nhớ thưởng nhiệm vụ: $error');
      }
      try {
        await _repository.notifyReward(
          NotificationItem(
            userId: user.id,
            title: '🎁 Nhận thưởng nhiệm vụ thành công!',
            body:
                'Bạn nhận được +$reward Linh Thạch từ "${currentQuest.title}".',
            kind: 'quest_reward',
            createdAt: DateTime.now(),
          ),
        );
      } catch (error) {
        debugPrint('Chưa lưu được thông báo nhận thưởng: $error');
      }
      if (_current(user.id, identity) &&
          auth.currentUser.id == user.id &&
          auth.currentUser.linhThach >= 500) {
        try {
          await unlockBadge(user.id, 'dai_gia_linh_thach');
        } catch (error) {
          debugPrint('Chưa lưu được huy hiệu nhận thưởng: $error');
        }
      }
      return reward;
    } finally {
      _claims.remove(key);
    }
  }

  Future<bool> unlockBadge(String userId, String code) async {
    if (userId.isEmpty || _disposed || _userId != userId) return false;
    final identity = _identity;
    final added = await _repository.unlockAchievement(userId, code);
    if (!_current(userId, identity)) return added;
    final request = ++_badgeRequest;
    final badges = await _repository.getUserAchievements(userId);
    if (_current(userId, identity) && request == _badgeRequest) {
      _unlocked = badges.where((b) => b.userId == userId).toList();
      notifyListeners();
    }
    return added;
  }

  @override
  void dispose() {
    _disposed = true;
    _identity++;
    super.dispose();
  }
}
