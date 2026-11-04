import 'dart:async';

import 'package:novel_reader/models/app_user.dart';
import 'package:novel_reader/repositories/auth_repository.dart';

import '../security_and_roles_test.dart' show FakeAuthRepository;

class EconomyCall {
  EconomyCall(this.kind, this.user);
  final String kind;
  final AppUser user;
  final reply = Completer<AppUser?>();
}

class DelayedEconomyRepository extends FakeAuthRepository
    implements AtomicEconomyRepository {
  late AppUser signedIn;
  final calls = <EconomyCall>[];
  Completer<AppUser?>? profileRead;

  @override
  Future<AppUser> login(String email, String password) async {
    signedIn = await super.login(email, password);
    return signedIn;
  }

  Future<AppUser?> _request(String kind, [AppUser? proposal]) {
    final call = EconomyCall(kind, proposal ?? signedIn);
    calls.add(call);
    return call.reply.future;
  }

  @override
  Future<QuestRewardClaim?> claimQuestReward(int questId) async {
    final updated = await _request('claim');
    return updated == null ? null : QuestRewardClaim(user: updated, reward: 50);
  }

  @override
  Future<AppUser?> purchaseShopItem(String itemKey, int cost) =>
      _request('shop');

  @override
  Future<AppUser?> buyStreakShield() => _request('shield');

  @override
  Future<AppUser> updateUser(AppUser user) async =>
      (await _request('profile', user))!;

  @override
  Future<AppUser?> getUserById(String id) =>
      profileRead?.future ?? super.getUserById(id);
}
