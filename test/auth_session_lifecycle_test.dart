import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/models/app_user.dart';
import 'package:novel_reader/providers/auth_provider.dart';
import 'package:novel_reader/repositories/auth_repository.dart';
import 'package:novel_reader/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'security_and_roles_test.dart' show FakeAuthRepository;

class _Attempt {
  _Attempt(this.kind, this.user);
  final String kind;
  final AppUser user;
  final reply = Completer<AppUser>();
}

class _Sessions extends FakeAuthRepository
    implements SessionIdentityRepository {
  AppUser? sdkUser;
  bool holdAuthentication = false;
  bool profileUnavailable = false;
  bool failSignOut = false;
  Completer<void>? signOutGate;
  Completer<AppUser?>? profileGate;
  final attempts = <_Attempt>[];
  final events = <String>[];
  int profileReads = 0;

  Future<AppUser> baseUser(String email) => super.login(email, 'Password');

  @override
  AppUser? get sessionIdentity =>
      sdkUser?.copyWith(role: UserRole.user, isAuthor: false, linhThach: 0);

  @override
  Future<AppUser> login(String email, String password) async {
    final user = await super.login(email, password);
    return _authenticate('login', user);
  }

  Future<AppUser> _authenticate(String kind, AppUser user) async {
    events.add('$kind:${user.id}');
    final attempt = _Attempt(kind, user);
    attempts.add(attempt);
    final authenticated = holdAuthentication
        ? await attempt.reply.future
        : user;
    sdkUser = authenticated;
    if (profileUnavailable) {
      throw AuthenticatedProfileUnavailable(authenticated.id);
    }
    return authenticated;
  }

  @override
  Future<AppUser> register({
    required String email,
    required String displayName,
    required String password,
  }) => _authenticate(
    'register',
    AppUser(
      id: 'new-user-id',
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    ),
  );

  @override
  Future<void> logout() async {
    events.add('logout');
    sdkUser = null; // Same local-first ordering as the actual Supabase SDK.
    await signOutGate?.future;
    if (failSignOut) throw StateError('sign-out offline');
  }

  @override
  Future<AppUser?> getUserById(String id) {
    profileReads++;
    return profileGate?.future ?? super.getUserById(id);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences prefs;
  late _Sessions repository;
  late AuthProvider auth;
  late AppUser a, b;
  var disposed = false;
  Future<void> drain() => Future<void>.delayed(Duration.zero);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repository = _Sessions();
    a = await repository.baseUser('user@novelreader.local');
    b = await repository.baseUser('author@novelreader.local');
    auth = AuthProvider(repository, prefs);
    disposed = false;
  });
  tearDown(() {
    if (!disposed) auth.dispose();
  });

  test(
    'restored identity enters reader before a slow profile and stays on error',
    () async {
      repository.sdkUser = a;
      repository.profileGate = Completer();
      final restore = auth.restoreSession();
      expect(auth.currentUser.id, a.id);
      expect(auth.hasEnteredApp, isTrue);
      expect(auth.isLoading, isFalse);
      expect(auth.profileNeedsRefresh, isTrue);
      expect(auth.balanceNeedsRefresh, isTrue);
      await auth
          .refreshCurrentUser(); // Coalesced with the pending restoration.
      expect(repository.profileReads, 1);
      repository.profileGate!.completeError(StateError('offline'));
      await restore;
      expect(auth.currentUser.id, a.id);
      expect(repository.sdkUser!.id, a.id);
      expect(auth.error, isNull);
      expect(auth.isLoading, isFalse);
    },
  );

  test(
    'late restore including a banned profile cannot log out the next account',
    () async {
      repository.sdkUser = a;
      repository.profileGate = Completer();
      final restore = auth.restoreSession();
      expect(await auth.login(b.email, 'Password'), isTrue);
      repository.profileGate!.complete(
        a.copyWith(status: UserStatus.banned, banReason: 'old profile'),
      );
      await restore;
      expect(auth.currentUser.id, b.id);
      expect(repository.sdkUser!.id, b.id);
      expect(repository.events, isNot(contains('logout')));
    },
  );

  test(
    'logout publishes welcome immediately and cannot clear a later login',
    () async {
      await auth.login(a.email, 'Password');
      repository.signOutGate = Completer();
      final logout = auth.logout();
      expect(auth.isGuest, isTrue);
      expect(auth.hasEnteredApp, isFalse);
      expect(auth.isLoading, isFalse);
      await drain();
      final login = auth.login(b.email, 'Password');
      await drain();
      expect(
        repository.attempts,
        hasLength(1),
      ); // B waits for the SDK sign-out.
      expect(auth.isLoading, isTrue);
      repository.signOutGate!.complete();
      await logout;
      expect(await login, isTrue);
      expect(auth.currentUser.id, b.id);
      expect(repository.sdkUser!.id, b.id);
      expect(prefs.getString(PrefKeys.currentUserId), b.id);
      final saved = jsonDecode(
        prefs.getString(AuthProvider.identityPreferenceKey)!,
      );
      expect(saved['mode'], 'member');
      expect(saved['user_id'], b.id);
    },
  );

  for (final kind in ['login', 'register']) {
    test('duplicate $kind requests do not race SDK sessions', () async {
      repository.holdAuthentication = true;
      Future<bool> attempt() => kind == 'login'
          ? auth.login(a.email, 'Password')
          : auth.register(
              email: 'new@example.test',
              displayName: 'New',
              password: 'Password',
            );
      final first = attempt();
      final revision = auth.sessionRevision;
      expect(await attempt(), isFalse);
      expect(auth.sessionRevision, revision);
      await drain();
      expect(repository.attempts, hasLength(1));
      repository.attempts.single.reply.complete(
        repository.attempts.single.user,
      );
      expect(await first, isTrue);
      expect(auth.currentUser.id, repository.sdkUser!.id);
      expect(auth.isLoading, isFalse);
    });
  }

  test(
    'abandoned login, guest cleanup and a new login preserve SDK/UI ordering',
    () async {
      repository.holdAuthentication = true;
      final first = auth.login(a.email, 'Password');
      await drain();
      final guest = auth.continueAsGuest();
      expect(auth.isGuest, isTrue);
      expect(auth.hasEnteredApp, isTrue);
      final next = auth.login(b.email, 'Password');
      await drain();
      expect(repository.attempts, hasLength(1));
      repository.attempts.first.reply.complete(a);
      expect(await first, isFalse);
      await drain();
      expect(repository.events, ['login:${a.id}', 'logout', 'login:${b.id}']);
      expect(auth.isLoading, isTrue);
      expect(auth.error, isNull);
      repository.attempts.last.reply.complete(b);
      await guest;
      expect(await next, isTrue);
      expect(auth.currentUser.id, b.id);
      expect(repository.sdkUser!.id, b.id);
      expect(prefs.getString(PrefKeys.currentUserId), b.id);
    },
  );

  test(
    'old login error cannot replace the next attempt error/loading',
    () async {
      repository.holdAuthentication = true;
      final first = auth.login(a.email, 'Password');
      await drain();
      final guest = auth.continueAsGuest();
      final next = auth.login(b.email, 'Password');
      repository.attempts.first.reply.completeError(
        StateError('old network error'),
      );
      expect(await first, isFalse);
      await drain();
      expect(auth.isLoading, isTrue);
      expect(auth.error, isNull);
      repository.attempts.last.reply.complete(b);
      await guest;
      expect(await next, isTrue);
      expect(auth.error, isNull);
    },
  );

  test(
    'guest and welcome choices survive leftover SDK tokens after restart',
    () async {
      for (final mode in ['guest', 'welcome']) {
        if (mode == 'guest') {
          await auth.continueAsGuest();
        } else {
          await auth.logout();
        }
        repository.sdkUser = a; // Interrupted cleanup left an old stored token.
        auth.dispose();
        auth = AuthProvider(repository, prefs);
        final reads = repository.profileReads;
        await auth.restoreSession();
        await drain();
        expect(auth.isGuest, isTrue);
        expect(auth.hasEnteredApp, mode == 'guest');
        expect(repository.profileReads, reads);
        expect(repository.sdkUser, isNull);
      }
    },
  );

  test('profile failure after authentication keeps a basic session for login/register', () async {
    repository.profileUnavailable = true;
    expect(await auth.login(a.email, 'Password'), isTrue);
    expect(auth.currentUser.id, a.id);
    expect(auth.profileNeedsRefresh, isTrue);
    expect(auth.balanceNeedsRefresh, isTrue);
    expect(auth.isLoading, isFalse);
    await auth.logout();
    expect(
      await auth.register(
        email: 'new@example.test',
        displayName: 'New',
        password: 'Password',
      ),
      isTrue,
    );
    expect(auth.currentUser.id, 'new-user-id');
    expect(auth.profileNeedsRefresh, isTrue);
  });

  test('unreadable preference does not destroy a valid SDK session', () async {
    await prefs.setString(AuthProvider.identityPreferenceKey, '{invalid');
    repository.sdkUser = a;
    await auth.restoreSession();
    expect(auth.currentUser.id, a.id);
    expect(auth.profileNeedsRefresh, isFalse);
    expect(repository.sdkUser!.id, a.id);
  });

  test(
    'failed remote signout still leaves a durable local welcome state',
    () async {
      await auth.login(a.email, 'Password');
      repository.failSignOut = true;
      await auth.logout();
      expect(auth.isGuest, isTrue);
      expect(auth.hasEnteredApp, isFalse);
      expect(repository.sdkUser, isNull);
      final saved = jsonDecode(
        prefs.getString(AuthProvider.identityPreferenceKey)!,
      );
      expect(saved['mode'], 'welcome');
      expect(prefs.getString(PrefKeys.currentUserId), isNull);
    },
  );

  test(
    'disposing while authenticating or restoring ignores the eventual reply',
    () async {
      repository.holdAuthentication = true;
      final login = auth.login(a.email, 'Password');
      await drain();
      auth.dispose();
      disposed = true;
      repository.attempts.single.reply.complete(a);
      expect(await login, isFalse);
      auth = AuthProvider(repository, prefs);
      disposed = false;
      repository.profileGate = Completer();
      final restore = auth.restoreSession();
      auth.dispose();
      disposed = true;
      repository.profileGate!.complete(a);
      await restore;
    },
  );
}
