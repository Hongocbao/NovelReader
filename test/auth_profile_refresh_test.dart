import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/models/app_user.dart';
import 'package:novel_reader/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'security_and_roles_test.dart' show FakeAuthRepository;

class _DelayedProfileRepository extends FakeAuthRepository {
  final requests = <({String userId, Completer<AppUser?> reply})>[];

  @override
  Future<AppUser?> getUserById(String id) {
    final reply = Completer<AppUser?>();
    requests.add((userId: id, reply: reply));
    return reply.future;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _DelayedProfileRepository repository;
  late AuthProvider auth;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = _DelayedProfileRepository();
    auth = AuthProvider(repository, await SharedPreferences.getInstance());
    expect(await auth.login('user@novelreader.local', 'User@1234'), isTrue);
  });
  tearDown(() => auth.dispose());

  test('A late profile response cannot restore a logged-out account', () async {
    final oldUser = auth.currentUser;
    final refresh = auth.refreshCurrentUser();
    await auth.logout();
    repository.requests.single.reply.complete(oldUser);
    await refresh;

    expect(auth.isGuest, isTrue);
    expect(auth.hasEnteredApp, isFalse);
  });

  test('A late profile response cannot leave guest mode', () async {
    final oldUser = auth.currentUser;
    final refresh = auth.refreshCurrentUser();
    await auth.continueAsGuest();
    repository.requests.single.reply.complete(oldUser);
    await refresh;

    expect(auth.isGuest, isTrue);
    expect(auth.hasEnteredApp, isTrue);
  });

  test(
    'A new account can refresh while the previous account is still pending',
    () async {
      final oldUser = auth.currentUser;
      final oldRefresh = auth.refreshCurrentUser();
      expect(
        await auth.login('author@novelreader.local', 'Author@123'),
        isTrue,
      );
      final newUser = auth.currentUser;
      final newRefresh = auth.refreshCurrentUser();
      expect(repository.requests.map((request) => request.userId), [
        oldUser.id,
        newUser.id,
      ]);

      repository.requests[0].reply.complete(oldUser);
      await oldRefresh;
      expect(auth.currentUser.id, newUser.id);

      // Completing the old request must not unlock a duplicate current request.
      await auth.refreshCurrentUser();
      expect(repository.requests.length, 2);
      repository.requests[1].reply.complete(
        newUser.copyWith(displayName: 'Đã đồng bộ'),
      );
      await newRefresh;
      expect(auth.currentUser.displayName, 'Đã đồng bộ');
    },
  );

  test(
    'Signing in again to the same account rejects the previous session profile',
    () async {
      final oldUser = auth.currentUser;
      final oldRefresh = auth.refreshCurrentUser();
      await repository.updateUser(oldUser.copyWith(displayName: 'Phiên mới'));
      expect(await auth.login(oldUser.email, 'User@1234'), isTrue);
      repository.requests.single.reply.complete(
        oldUser.copyWith(displayName: 'Hồ sơ cũ'),
      );
      await oldRefresh;

      expect(auth.currentUser.displayName, 'Phiên mới');
    },
  );

  test(
    'A temporary profile error keeps the account and allows retry',
    () async {
      final user = auth.currentUser;
      final failedRefresh = auth.refreshCurrentUser();
      repository.requests.single.reply.completeError(
        StateError('Temporary network failure'),
      );
      await failedRefresh;
      expect(auth.currentUser.id, user.id);
      expect(auth.isLoggedIn, isTrue);

      final retry = auth.refreshCurrentUser();
      expect(repository.requests.length, 2);
      repository.requests[1].reply.complete(
        user.copyWith(displayName: 'Kết nối lại'),
      );
      await retry;
      expect(auth.currentUser.displayName, 'Kết nối lại');
    },
  );
}
