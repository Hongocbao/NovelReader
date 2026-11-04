import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/database/v2_database_store.dart';
import 'package:novel_reader/models/achievement.dart';
import 'package:novel_reader/models/notification_item.dart';
import 'package:novel_reader/models/quest.dart';
import 'package:novel_reader/providers/auth_provider.dart';
import 'package:novel_reader/providers/quest_provider.dart';
import 'package:novel_reader/repositories/quest_repository.dart';
import 'package:novel_reader/screens/user/quests_and_achievements_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'helpers/delayed_economy_repository.dart';

class _Quests implements QuestRepository {
  final quest = Quest(
    id: 7,
    type: 'daily',
    title: 'Đọc hai chương',
    goalType: 'read_chapters',
    goalValue: 2,
    reward: 50,
    startsAt: DateTime.now().subtract(const Duration(days: 1)),
    endsAt: DateTime.now().add(const Duration(days: 1)),
  );
  final progress = <String, Map<int, UserQuest>>{};
  final badges = <String, List<UserAchievement>>{};
  Future<Map<int, UserQuest>> Function(String)? readProgress;
  Future<List<UserAchievement>> Function(String)? readBadges;
  Completer<void>? recordGate, badgeGate;
  bool failSecondary = false;
  int recordCalls = 0;
  final cached = <UserQuest>[];
  final notices = <NotificationItem>[];

  @override
  Future<List<Quest>> getActiveQuests() async => [quest];
  @override
  Future<List<Achievement>> getAchievements() async => [
    const Achievement(
      code: 'reader',
      name: 'Người đọc',
      description: 'Đã đọc truyện',
      icon: '📚',
    ),
  ];
  @override
  Future<Map<int, UserQuest>> getUserQuests(String userId) =>
      readProgress?.call(userId) ??
      Future.value(Map.of(progress[userId] ?? {}));
  @override
  Future<List<UserAchievement>> getUserAchievements(String userId) =>
      readBadges?.call(userId) ?? Future.value(List.of(badges[userId] ?? []));
  @override
  Future<void> recordProgress(String userId, String goalType, int delta) async {
    recordCalls++;
    await recordGate?.future;
    progress[userId] = {
      7: UserQuest(userId: userId, questId: 7, progress: delta),
    };
  }

  @override
  Future<void> cacheClaim(UserQuest claim) async {
    cached.add(claim);
    if (failSecondary) throw StateError('local cache unavailable');
    (progress[claim.userId] ??= {})[claim.questId] = claim;
  }

  @override
  Future<void> notifyReward(NotificationItem notification) async {
    notices.add(notification);
    if (failSecondary) throw StateError('notification unavailable');
  }

  @override
  Future<bool> unlockAchievement(String userId, String code) async {
    await badgeGate?.future;
    (badges[userId] ??= []).add(
      UserAchievement(userId: userId, code: code, unlockedAt: DateTime.now()),
    );
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _Quests source;
  late QuestProvider quests;
  late AuthProvider auth;
  late DelayedEconomyRepository economy;
  var disposed = false;

  Future<void> drain() => Future<void>.delayed(Duration.zero);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    economy = DelayedEconomyRepository();
    auth = AuthProvider(economy, await SharedPreferences.getInstance());
    await auth.login('user@novelreader.local', 'Password');
    source = _Quests();
    source.progress['user-id'] = {
      7: const UserQuest(userId: 'user-id', questId: 7, progress: 2),
    };
    source.progress['author-id'] = {
      7: const UserQuest(userId: 'author-id', questId: 7, progress: 1),
    };
    quests = QuestProvider(AppDatabase(), repository: source);
    disposed = false;
  });
  tearDown(() {
    if (!disposed) quests.dispose();
    auth.dispose();
  });

  test(
    'binding clears old progress immediately and ignores a late old load',
    () async {
      final oldReply = Completer<Map<int, UserQuest>>();
      source.readProgress = (id) => id == 'user-id'
          ? oldReply.future
          : Future.value(source.progress[id]!);
      final old = quests.loadForUser('user-id');
      await drain();
      quests.bindUser('author-id');
      expect(quests.userQuests, isEmpty);
      expect(quests.unlocked, isEmpty);
      await drain();
      expect(quests.progressOf(7), 1);
      oldReply.complete(source.progress['user-id']);
      await old;
      expect(quests.userId, 'author-id');
      expect(quests.progressOf(7), 1);
      await quests.loadForUser(
        'user-id',
      ); // Old reader callback after the switch.
      expect(quests.userId, 'author-id');
      quests.bindUser('');
      expect(quests.userQuests, isEmpty);
      await drain();
      expect(quests.unlocked, isEmpty);
    },
  );

  test(
    'old load failures do not set the current account error or loading',
    () async {
      final oldReply = Completer<Map<int, UserQuest>>();
      source.readProgress = (id) => id == 'user-id'
          ? oldReply.future
          : Future.value(source.progress[id]!);
      final old = quests.loadForUser('user-id');
      await drain();
      quests.bindUser('author-id');
      await drain();
      oldReply.completeError(StateError('old account offline'));
      await old;
      expect(quests.error, isNull);
      expect(quests.isLoading, isFalse);
      expect(quests.progressOf(7), 1);
    },
  );

  test('latest refresh wins even when requests finish backwards', () async {
    await quests.loadForUser('user-id');
    final first = Completer<Map<int, UserQuest>>();
    final second = Completer<Map<int, UserQuest>>();
    var reads = 0;
    source.readProgress = (_) => reads++ == 0 ? first.future : second.future;
    final old = quests.loadForUser('user-id');
    await drain();
    final fresh = quests.loadForUser('user-id');
    await drain();
    second.complete({
      7: const UserQuest(userId: 'user-id', questId: 7, progress: 2),
    });
    await fresh;
    first.complete({
      7: const UserQuest(userId: 'user-id', questId: 7, progress: 0),
    });
    await old;
    expect(quests.progressOf(7), 2);
  });

  test(
    'pending progress and badge writes do not publish to another account',
    () async {
      await quests.loadForUser('user-id');
      source.recordGate = Completer<void>();
      source.badgeGate = Completer<void>();
      final record = quests.recordProgress(
        user: auth.currentUser,
        goalType: 'read_chapters',
        delta: 2,
      );
      final badge = quests.unlockBadge('user-id', 'reader');
      quests.bindUser('author-id');
      await drain();
      source.recordGate!.complete();
      source.badgeGate!.complete();
      await Future.wait([record, badge]);
      expect(quests.progressOf(7), 1);
      expect(quests.unlockedCodes, isEmpty);
      expect(await quests.unlockBadge('user-id', 'reader'), isFalse);
    },
  );

  test(
    'duplicate claims only send one RPC and secondary failures keep success',
    () async {
      await quests.loadForUser('user-id');
      source.failSecondary = true;
      final user = auth.currentUser;
      final first = quests.claimQuestReward(auth: auth, quest: source.quest);
      expect(await quests.claimQuestReward(auth: auth, quest: source.quest), 0);
      expect(economy.calls, hasLength(1));
      economy.calls.single.reply.complete(user.copyWith(linhThach: 150));
      expect(await first, 50);
      expect(auth.currentUser.linhThach, 150);
      expect(quests.isClaimed(7), isTrue);
      expect(source.cached.single.userId, user.id);
      expect(source.notices.single.userId, user.id);
      expect(quests.error, isNull);
      expect(await quests.claimQuestReward(auth: auth, quest: source.quest), 0);
      expect(economy.calls, hasLength(1));
    },
  );

  test(
    'refresh started before a claim cannot undo its claimed state',
    () async {
      await quests.loadForUser('user-id');
      final stale = Completer<Map<int, UserQuest>>();
      source.readProgress = (_) => stale.future;
      final refresh = quests.loadForUser('user-id');
      await drain();
      final claim = quests.claimQuestReward(auth: auth, quest: source.quest);
      economy.calls.single.reply.complete(
        auth.currentUser.copyWith(linhThach: 150),
      );
      expect(await claim, 50);
      stale.complete({
        7: const UserQuest(userId: 'user-id', questId: 7, progress: 2),
      });
      await refresh;
      expect(quests.isClaimed(7), isTrue);
    },
  );

  test('late reward cannot claim or notify the next account', () async {
    await quests.loadForUser('user-id');
    final user = auth.currentUser;
    final claim = quests.claimQuestReward(auth: auth, quest: source.quest);
    await auth.login('author@novelreader.local', 'Password');
    quests.bindUser(auth.currentUser.id);
    await drain();
    economy.calls.single.reply.complete(user.copyWith(linhThach: 150));
    expect(await claim, 0);
    expect(quests.userId, 'author-id');
    expect(quests.isClaimed(7), isFalse);
    expect(source.notices, isEmpty);
  });

  test('disposing during load ignores its eventual result', () async {
    final reply = Completer<Map<int, UserQuest>>();
    source.readProgress = (_) => reply.future;
    final load = quests.loadForUser('user-id');
    await drain();
    quests.dispose();
    disposed = true;
    reply.complete(source.progress['user-id']);
    await load;
  });

  test(
    'claimed cloud quest is cached even without a previous local row',
    () async {
      sqfliteFfiInit();
      final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      addTearDown(db.close);
      await db.execute(
        'CREATE TABLE nhiem_vu_nguoi_dung ('
        'user_id TEXT, quest_id INTEGER, progress INTEGER, claimed INTEGER, '
        'PRIMARY KEY(user_id, quest_id))',
      );
      await db.insert(
        'nhiem_vu_nguoi_dung',
        const UserQuest(userId: 'author-id', questId: 7, progress: 1).toMap(),
      );
      await V2DatabaseStore.cacheQuestClaim(
        db,
        userId: 'user-id',
        questId: 7,
        progress: 2,
      );
      await V2DatabaseStore.cacheQuestClaim(
        db,
        userId: 'user-id',
        questId: 7,
        progress: 2,
      );
      final cached = await V2DatabaseStore.getUserQuests(db, 'user-id');
      expect(cached[7]!.claimed, isTrue);
      expect(cached[7]!.progress, 2);
      expect(
        (await V2DatabaseStore.getUserQuests(db, 'author-id'))[7]!.claimed,
        isFalse,
      );
      expect(await db.query('nhiem_vu_nguoi_dung'), hasLength(2));
    },
  );

  testWidgets('mobile quest screen handles late claims and pin save errors', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 1000);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    source.badges['user-id'] = [
      UserAchievement(
        userId: 'user-id',
        code: 'reader',
        unlockedAt: DateTime.now(),
      ),
    ];
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: auth),
          ChangeNotifierProxyProvider<AuthProvider, QuestProvider>(
            create: (_) => quests,
            update: (_, auth, provider) =>
                provider!..bindUser(auth.currentUser.id),
          ),
        ],
        child: const MaterialApp(home: QuestsAndAchievementsScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nhận thưởng'));
    await tester.pump();
    final old = auth.currentUser;
    await auth.login('author@novelreader.local', 'Password');
    await tester.pump();
    economy.calls.single.reply.complete(old.copyWith(linhThach: 150));
    await tester.pumpAndSettle();
    expect(find.textContaining('Đã nhận +50'), findsNothing);
    expect(find.text('Nhận thưởng'), findsNothing);
    await auth.login('user@novelreader.local', 'Password');
    await tester.pumpAndSettle();
    await tester.tap(find.text('20 Huy hiệu Thành tựu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.push_pin_outlined));
    await tester.pump();
    economy.calls.last.reply.completeError(StateError('offline'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Chưa lưu được huy hiệu ghim'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    disposed = true; // ProxyProvider disposed this notifier.
  });
}
