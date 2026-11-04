import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/delayed_economy_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late DelayedEconomyRepository repository;
  late AuthProvider auth;
  var disposed = false;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = DelayedEconomyRepository();
    auth = AuthProvider(repository, await SharedPreferences.getInstance());
    await auth.login('user@novelreader.local', 'Password');
    disposed = false;
  });
  tearDown(() {
    if (!disposed) auth.dispose();
  });

  for (final kind in ['claim', 'shop', 'shield', 'profile']) {
    test('late $kind response cannot replace the next account', () async {
      final original = auth.currentUser;
      final pending = switch (kind) {
        'claim' => auth.claimQuestReward(1, 50),
        'shop' => auth.purchaseShopItem('gold', 80),
        'shield' => auth.buyStreakShield(),
        _ => auth.updateProfile(displayName: 'Tên mới'),
      };
      expect(repository.calls, hasLength(1));
      await auth.login('author@novelreader.local', 'Password');
      final next = auth.currentUser;
      repository.calls.single.reply.complete(original.copyWith(linhThach: 999));
      await pending;
      expect(auth.currentUser.id, next.id);
      expect(auth.currentUser.linhThach, next.linhThach);
      expect(auth.currentUser.displayName, next.displayName);
    });
  }

  test(
    'signing back into the same account rejects the previous session result',
    () async {
      final original = auth.currentUser;
      final pending = auth.claimQuestReward(1, 50);
      await auth.login(original.email, 'Password');
      repository.calls.single.reply.complete(original.copyWith(linhThach: 999));
      expect(await pending, isNull);
      expect(auth.currentUser.linhThach, original.linhThach);
    },
  );

  test('a purchase cannot restore a logged-out or disposed user', () async {
    final original = auth.currentUser;
    final pending = auth.purchaseShopItem('gold', 80);
    await auth.logout();
    repository.calls.single.reply.complete(original.copyWith(linhThach: 20));
    expect(await pending, isFalse);
    expect(auth.isGuest, isTrue);
    await auth.login(original.email, 'Password');
    final shield = auth.buyStreakShield();
    auth.dispose();
    disposed = true;
    repository.calls.last.reply.complete(
      original.copyWith(hasStreakShield: true),
    );
    expect(await shield, isFalse);
  });

  test(
    'profile writes queue behind a reward and use its latest balance',
    () async {
      final original = auth.currentUser;
      final reward = auth.claimQuestReward(1, 50);
      final profile = auth.updateProfile(displayName: 'Đã đổi tên');
      expect(repository.calls.map((c) => c.kind), ['claim']);
      repository.calls.first.reply.complete(original.copyWith(linhThach: 150));
      expect(await reward, 50);
      await Future<void>.delayed(Duration.zero);
      expect(repository.calls.map((c) => c.kind), ['claim', 'profile']);
      expect(repository.calls.last.user.linhThach, 150);
      repository.calls.last.reply.complete(repository.calls.last.user);
      await profile;
      expect(auth.currentUser.linhThach, 150);
      expect(auth.currentUser.displayName, 'Đã đổi tên');
    },
  );

  test(
    'new account mutations do not wait for the previous account request',
    () async {
      final original = auth.currentUser;
      final old = auth.purchaseShopItem('gold', 80);
      await auth.login('author@novelreader.local', 'Password');
      final next = auth.currentUser;
      final current = auth.buyStreakShield();
      expect(repository.calls, hasLength(2));
      repository.calls.last.reply.complete(
        next.copyWith(hasStreakShield: true),
      );
      expect(await current, isTrue);
      repository.calls.first.reply.complete(original.copyWith(linhThach: 20));
      expect(await old, isFalse);
      expect(auth.currentUser.id, next.id);
      expect(auth.currentUser.hasStreakShield, isTrue);
    },
  );

  test('failed mutation releases the queue for retry', () async {
    final user = auth.currentUser;
    final reward = auth.claimQuestReward(1, 50);
    final failure = expectLater(reward, throwsStateError);
    final shield = auth.buyStreakShield();
    repository.calls.first.reply.completeError(StateError('offline'));
    await failure;
    await Future<void>.delayed(Duration.zero);
    expect(repository.calls.last.kind, 'shield');
    repository.calls.last.reply.complete(user.copyWith(hasStreakShield: true));
    expect(await shield, isTrue);
  });

  test(
    'profile read started before a completed reward cannot roll balance back',
    () async {
      final user = auth.currentUser;
      repository.profileRead = Completer();
      final refresh = auth.refreshCurrentUser();
      final reward = auth.claimQuestReward(1, 50);
      repository.calls.single.reply.complete(user.copyWith(linhThach: 150));
      await reward;
      repository.profileRead!.complete(user);
      await refresh;
      expect(auth.currentUser.linhThach, 150);
    },
  );

  test('duplicate shield purchases queue and only charge once', () async {
    final user = auth.currentUser;
    final first = auth.buyStreakShield();
    final second = auth.buyStreakShield();
    repository.calls.single.reply.complete(
      user.copyWith(linhThach: user.linhThach - 20, hasStreakShield: true),
    );
    expect(await first, isTrue);
    expect(await second, isTrue);
    expect(repository.calls, hasLength(1));
    expect(auth.currentUser.linhThach, user.linhThach - 20);
  });

  test(
    'queued old-session operations are cancelled before contacting server',
    () async {
      final user = auth.currentUser;
      final first = auth.purchaseShopItem('gold', 80);
      final queued = auth.buyStreakShield();
      await auth.login('author@novelreader.local', 'Password');
      repository.calls.single.reply.complete(user.copyWith(linhThach: 20));
      expect(await first, isFalse);
      expect(await queued, isFalse);
      expect(repository.calls, hasLength(1));
      expect(auth.currentUser.id, 'author-id');
    },
  );

  test(
    'response with another profile ID is rejected in the same session',
    () async {
      final user = auth.currentUser;
      final request = auth.claimQuestReward(1, 50);
      final other = (await repository.getUserById('author-id'))!;
      repository.calls.single.reply.complete(other);
      expect(await request, isNull);
      expect(auth.currentUser.id, user.id);
      expect(auth.currentUser.linhThach, user.linhThach);
    },
  );
}
