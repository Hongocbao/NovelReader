import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/models/app_user.dart';
import 'package:novel_reader/providers/auth_provider.dart';
import 'package:novel_reader/providers/notification_provider.dart';
import 'package:novel_reader/providers/quest_provider.dart';
import 'package:novel_reader/repositories/supabase_auth_repository.dart';
import 'package:novel_reader/screens/user/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _Notifications extends NotificationProvider {
  _Notifications() : super(AppDatabase());
  @override
  Future<void> loadAll(String userId) async {}
}

class _Quests extends QuestProvider {
  _Quests() : super(AppDatabase());
  @override
  Future<void> loadForUser(String userId) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const owner = '11111111-1111-4111-8111-111111111111';
  late SupabaseClient client;
  late SupabaseAuthRepository repository;
  late AuthProvider auth;
  late AppUser serverProfile;
  final requests = <http.Request>[];
  final results = <String, Map<String, Object?>>{};
  var profileAvailable = true;
  var rpcOffline = false;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    requests.clear();
    profileAvailable = true;
    rpcOffline = false;
    serverProfile = AppUser(
      id: owner,
      email: 'reader@example.test',
      displayName: 'Độc giả',
      linhThach: 100,
      role: UserRole.user,
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );
    results
      ..clear()
      ..addAll({
        'claim_quest_reward': {'claimed': true, 'reward': 50, 'balance': 612},
        'purchase_shop_item': {'success': true},
        'buy_streak_shield': {'success': true, 'balance': 80},
      });
    client = SupabaseClient(
      'https://novelreader-test.invalid',
      'fake-public-key',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
      postgrestOptions: const PostgrestClientOptions(retryEnabled: false),
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/auth/v1/token') {
          String part(Object value) => base64Url
              .encode(utf8.encode(jsonEncode(value)))
              .replaceAll('=', '');
          final exp = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600;
          return http.Response(
            jsonEncode({
              'access_token':
                  '${part({'alg': 'HS256'})}.${part({'sub': owner, 'exp': exp})}.signature',
              'refresh_token': 'fake-refresh',
              'token_type': 'bearer',
              'expires_in': 3600,
              'user': {
                'id': owner,
                'email': serverProfile.email,
                'aud': 'authenticated',
                'role': 'authenticated',
                'created_at': DateTime.now().toIso8601String(),
                'app_metadata': {},
                'user_metadata': {},
              },
            }),
            200,
            request: request,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        if (request.url.path == '/rest/v1/ho_so') {
          if (request.method == 'GET') {
            if (!profileAvailable) {
              throw http.ClientException('profile offline');
            }
            return http.Response(
              jsonEncode([serverProfile.toMap()]),
              200,
              request: request,
              headers: {'content-type': 'application/json; charset=utf-8'},
            );
          }
          if (request.url.queryParameters['select'] != null) {
            serverProfile = AppUser.fromMap({
              ...serverProfile.toMap(),
              ...jsonDecode(request.body) as Map<String, dynamic>,
            });
            return http.Response(
              jsonEncode(serverProfile.toMap()),
              200,
              request: request,
              headers: {'content-type': 'application/json; charset=utf-8'},
            );
          }
          return http.Response('', 204, request: request);
        }
        if (request.url.path.startsWith('/rest/v1/rpc/')) {
          if (rpcOffline) {
            throw http.ClientException('RPC response unavailable');
          }
          return http.Response(
            jsonEncode(results[request.url.pathSegments.last]),
            200,
            request: request,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        throw StateError(
          'Unexpected mocked request: ${request.method} ${request.url.path}',
        );
      }),
    );
    repository = SupabaseAuthRepository(client: client);
    auth = AuthProvider(repository, await SharedPreferences.getInstance());
    expect(await auth.login(serverProfile.email, 'fake-password'), isTrue);
    requests.clear();
    profileAvailable = false;
  });
  tearDown(() async {
    auth.dispose();
    await client.dispose();
  });

  for (final action in ['claim', 'shop', 'shield']) {
    test(
      '$action returns its committed receipt without a profile request',
      () async {
        final receipt = await switch (action) {
          'claim' => repository.claimQuestReward(7),
          'shop' => repository.purchaseShopItem('gold', 80),
          _ => repository.buyStreakShield(),
        };
        expect(receipt, isNotNull);
        expect(receipt!.userId, owner);
        expect(receipt.profile, isNull);
        expect(requests, hasLength(1));
        expect(requests.single.method, 'POST');
        expect(requests.single.url.path, contains('/rpc/'));
        if (action == 'claim') {
          expect(receipt.reward, 50);
          expect(receipt.balance, 612);
        } else if (action == 'shop') {
          expect(receipt.unlockedItem, 'gold');
          expect(receipt.balance, isNull);
        } else {
          expect(receipt.hasStreakShield, isTrue);
          expect(receipt.balance, 80);
        }
      },
    );
  }

  test(
    'reward uses exact server balance and survives failed profile refresh',
    () async {
      expect(await auth.claimQuestReward(7, 50), 50);
      expect(auth.currentUser.linhThach, 612); // Not old local 100 + reward 50.
      expect(auth.profileNeedsRefresh, isTrue);
      expect(auth.balanceNeedsRefresh, isFalse);
      await auth.refreshCurrentUser();
      expect(auth.isLoggedIn, isTrue);
      expect(auth.currentUser.id, owner);
      expect(auth.currentUser.linhThach, 612);
      expect(auth.profileNeedsRefresh, isTrue);
      profileAvailable = true;
      serverProfile = serverProfile.copyWith(linhThach: 700);
      await auth.refreshCurrentUser();
      expect(auth.currentUser.linhThach, 700);
      expect(auth.profileNeedsRefresh, isFalse);
      expect(auth.balanceNeedsRefresh, isFalse);
      expect(requests.where((r) => r.url.path.contains('/rpc/')), hasLength(1));
    },
  );

  test(
    'legacy shop response unlocks item with explicitly unknown balance',
    () async {
      expect(await auth.purchaseShopItem('gold', 80), isTrue);
      expect(auth.currentUser.unlockedItems, contains('gold'));
      expect(
        auth.currentUser.linhThach,
        100,
      ); // Keep last known; do not invent 20.
      expect(auth.balanceNeedsRefresh, isTrue);
      expect(auth.profileNeedsRefresh, isTrue);
      expect(await auth.purchaseShopItem('gold', 80), isTrue);
      expect(requests, hasLength(1));
      // Local 100 is unknown now; it must not reject a valid server-funded buy.
      results['purchase_shop_item'] = {'success': true, 'balance': 450};
      expect(await auth.purchaseShopItem('jade', 120), isTrue);
      expect(auth.currentUser.linhThach, 450);
      expect(auth.balanceNeedsRefresh, isFalse);
      expect(auth.currentUser.unlockedItems, containsAll(['gold', 'jade']));
      expect(requests, hasLength(2));
    },
  );

  test(
    'already-owned shield does not invent a second charge and can resync',
    () async {
      results['buy_streak_shield'] = {'success': true, 'already_owned': true};
      expect(await auth.buyStreakShield(), isTrue);
      expect(auth.currentUser.hasStreakShield, isTrue);
      expect(auth.balanceNeedsRefresh, isTrue);
      expect(auth.currentUser.linhThach, 100);
      expect(await auth.buyStreakShield(), isTrue);
      expect(requests, hasLength(1));
      profileAvailable = true;
      serverProfile = serverProfile.copyWith(
        linhThach: 60,
        hasStreakShield: true,
      );
      await auth.refreshCurrentUser();
      expect(auth.currentUser.linhThach, 60);
      expect(auth.balanceNeedsRefresh, isFalse);
    },
  );

  test('declined or unconfirmed RPC does not manufacture success', () async {
    results['purchase_shop_item'] = {
      'success': false,
      'reason': 'insufficient_funds',
    };
    expect(await auth.purchaseShopItem('gold', 80), isFalse);
    expect(auth.currentUser.unlockedItems, isNot(contains('gold')));
    rpcOffline = true;
    await expectLater(
      auth.buyStreakShield(),
      throwsA(isA<http.ClientException>()),
    );
    expect(auth.currentUser.hasStreakShield, isFalse);
    expect(auth.currentUser.linhThach, 100);
    expect(auth.balanceNeedsRefresh, isFalse);
    expect(auth.profileNeedsRefresh, isFalse);
  });

  test(
    'switching to guest clears a previously unknown member balance',
    () async {
      await auth.purchaseShopItem('gold', 80);
      expect(auth.balanceNeedsRefresh, isTrue);
      await auth.continueAsGuest();
      expect(auth.isGuest, isTrue);
      expect(auth.balanceNeedsRefresh, isFalse);
    },
  );

  test('equipping after a confirmed buy sends only profile fields and gets fresh balance', () async {
    await auth.purchaseShopItem('gold', 80);
    serverProfile = serverProfile.copyWith(
      linhThach: 20,
      unlockedItems: ['default', 'gold'],
    );
    await auth.updateProfile(avatarFrame: 'gold');
    final patch = requests.where((r) => r.method == 'PATCH').single;
    expect(jsonDecode(patch.body), {
      'display_name': serverProfile.displayName,
      'avatar': serverProfile.avatar,
      'avatar_frame': 'gold',
      'pinned_achievements': '',
    });
    expect(patch.url.queryParameters['id'], 'eq.$owner');
    expect(auth.currentUser.avatarFrame, 'gold');
    expect(auth.currentUser.linhThach, 20);
    expect(auth.balanceNeedsRefresh, isFalse);
    expect(auth.profileNeedsRefresh, isFalse);
    expect(requests.where((r) => r.method == 'GET'), isEmpty);
  });

  testWidgets(
    'mobile shop shows confirmed item, unknown balance, retry and errors',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(360, 1000);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final quests = _Quests();
      final notifications = _Notifications();
      addTearDown(quests.dispose);
      addTearDown(notifications.dispose);
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: auth),
            ChangeNotifierProvider<QuestProvider>.value(value: quests),
            ChangeNotifierProvider<NotificationProvider>.value(
              value: notifications,
            ),
          ],
          child: const MaterialApp(home: UserProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cửa hàng Linh Thạch'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('80 💎'));
      await tester.tap(find.text('80 💎'));
      await tester.pumpAndSettle();
      expect(auth.balanceNeedsRefresh, isTrue);
      await tester.drag(
        find.byType(ListView).hitTestable(),
        const Offset(0, 600),
      );
      await tester.pumpAndSettle();
      expect(find.text('Đang đồng bộ số dư'), findsOneWidget);
      expect(
        find.textContaining('Đã mở khóa Khung Avatar Hoàng Kim'),
        findsOneWidget,
      );
      expect(find.text('80 💎'), findsNothing);
      expect(auth.currentUser.unlockedItems, contains('gold'));
      profileAvailable = true;
      serverProfile = serverProfile.copyWith(
        linhThach: 500,
        unlockedItems: ['default', 'gold'],
      );
      await tester.tap(find.byTooltip('Tải lại số dư'));
      await tester.pumpAndSettle();
      expect(find.text('Số dư hiện tại: 500 Linh Thạch'), findsOneWidget);
      ScaffoldMessenger.of(tester.element(find.byType(UserProfileScreen)))
          .clearSnackBars();
      await tester.pumpAndSettle();
      rpcOffline = true;
      await tester.ensureVisible(find.text('120 💎'));
      await tester.tap(find.text('120 💎'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Chưa mua được vật phẩm'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
