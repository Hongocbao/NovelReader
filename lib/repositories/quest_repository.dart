import '../database/app_database.dart';
import '../database/v2_database_store.dart';
import '../models/achievement.dart';
import '../models/notification_item.dart';
import '../models/quest.dart';

abstract interface class QuestRepository {
  Future<List<Quest>> getActiveQuests();
  Future<List<Achievement>> getAchievements();
  Future<Map<int, UserQuest>> getUserQuests(String userId);
  Future<List<UserAchievement>> getUserAchievements(String userId);
  Future<void> recordProgress(String userId, String goalType, int delta);
  Future<void> cacheClaim(UserQuest claim);
  Future<void> notifyReward(NotificationItem notification);
  Future<bool> unlockAchievement(String userId, String code);
}

class DatabaseQuestRepository implements QuestRepository {
  DatabaseQuestRepository(this._appDb);
  final AppDatabase _appDb;

  @override
  Future<List<Quest>> getActiveQuests() async =>
      V2DatabaseStore.getActiveQuests(await _appDb.database);
  @override
  Future<List<Achievement>> getAchievements() async =>
      V2DatabaseStore.getAllAchievements(await _appDb.database);
  @override
  Future<Map<int, UserQuest>> getUserQuests(String userId) async =>
      V2DatabaseStore.getUserQuests(await _appDb.database, userId);
  @override
  Future<List<UserAchievement>> getUserAchievements(String userId) async =>
      V2DatabaseStore.getUserAchievements(await _appDb.database, userId);
  @override
  Future<void> recordProgress(
    String userId,
    String goalType,
    int delta,
  ) async => V2DatabaseStore.incrementQuestProgress(
    await _appDb.database,
    userId: userId,
    goalType: goalType,
    delta: delta,
  );
  @override
  Future<void> cacheClaim(UserQuest claim) async =>
      V2DatabaseStore.cacheQuestClaim(
        await _appDb.database,
        userId: claim.userId,
        questId: claim.questId,
        progress: claim.progress,
      );
  @override
  Future<void> notifyReward(NotificationItem notification) async =>
      V2DatabaseStore.createNotification(await _appDb.database, notification);
  @override
  Future<bool> unlockAchievement(String userId, String code) async =>
      V2DatabaseStore.unlockAchievement(await _appDb.database, userId, code);
}
