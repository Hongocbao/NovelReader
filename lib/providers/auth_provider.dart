import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import '../repositories/auth_repository.dart';
import '../utils/constants.dart';
import '../utils/role_guard.dart';

/// Quản lý trạng thái xác thực, phiên đăng nhập, chế độ Khách và phân quyền bằng Supabase Auth.
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;
  final SharedPreferences _prefs;

  AppUser _currentUser = AppUser.guest();
  bool _isLoading = false;
  String? _error;

  /// Cho phép Admin tạm chuyển sang giao diện Độc giả để kiểm tra trải nghiệm.
  bool _adminPreviewAsReader = false;

  /// Đánh dấu người dùng đã qua màn hình SplashGate trong phiên hiện tại.
  bool _hasEnteredApp = false;

  /// Hồ sơ chưa tải đủ hoặc cần đồng bộ sau một giao dịch đã xác nhận.
  /// Khi chỉ có session cơ bản, tài khoản tạm dùng quyền Độc giả.
  bool _profileNeedsRefresh = false;
  bool _balanceNeedsRefresh = false;
  int _identityRevision = 0;
  int? _profileRefreshRevision;
  bool _disposed = false;
  int _profileMutationVersion = 0;
  final _mutationTails = <int, Future<void>>{};
  Future<void>? _identityTail;
  Future<void>? _preferenceTail;
  int? _authenticatingRevision;
  String? _committedMode;
  static const identityPreferenceKey = 'auth_identity_v1';

  bool _sameIdentity(String userId, int revision) =>
      !_disposed && revision == _identityRevision && _currentUser.id == userId;

  /// Serialize profile/economy responses within one session. A pending request
  /// from an old session neither blocks nor overwrites the next account.
  Future<T> _mutateUser<T>(
    T cancelled,
    Future<T> Function(AppUser user, int revision) action,
  ) async {
    final revision = _identityRevision;
    final userId = _currentUser.id;
    _profileMutationVersion++;
    final previous = _mutationTails[revision];
    final done = Completer<void>();
    _mutationTails[revision] = done.future;
    try {
      if (previous != null) await previous;
      if (!_sameIdentity(userId, revision)) return cancelled;
      return await action(_currentUser, revision);
    } finally {
      done.complete();
      if (identical(_mutationTails[revision], done.future)) {
        _mutationTails.remove(revision);
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _identityRevision++;
    super.dispose();
  }

  AuthProvider(this._repo, this._prefs);

  AppUser get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isGuest => _currentUser.isGuest;
  bool get isLoggedIn => !_currentUser.isGuest;
  bool get isAdmin => _currentUser.isAdmin;
  bool get isAuthor => _currentUser.isAuthor || _currentUser.isAdmin;
  bool get adminPreviewAsReader => _adminPreviewAsReader;
  bool get hasEnteredApp => _hasEnteredApp;
  bool get profileNeedsRefresh => _profileNeedsRefresh;
  bool get balanceNeedsRefresh => _balanceNeedsRefresh;
  int get sessionRevision => _identityRevision;

  bool _applyEconomyReceipt(
    AppUser user,
    int revision,
    EconomyReceipt receipt,
  ) {
    if (!_sameIdentity(user.id, revision) ||
        receipt.userId != user.id ||
        (receipt.profile != null && receipt.profile!.id != user.id)) {
      return false;
    }
    final profile = receipt.profile;
    final base = profile ?? user;
    final item = receipt.unlockedItem;
    _currentUser = base.copyWith(
      linhThach: profile?.linhThach ?? receipt.balance ?? base.linhThach,
      unlockedItems: item == null || base.unlockedItems.contains(item)
          ? base.unlockedItems
          : [...base.unlockedItems, item],
      hasStreakShield: receipt.hasStreakShield || base.hasStreakShield,
    );
    _profileNeedsRefresh = profile == null;
    _balanceNeedsRefresh = profile == null && receipt.balance == null;
    notifyListeners();
    return true;
  }

  /// Có hiển thị giao diện AdminShell hay không.
  bool get shouldShowAdminShell => isAdmin && !_adminPreviewAsReader;

  bool _currentRequest(int revision) =>
      !_disposed && revision == _identityRevision;

  AppUser? get _sessionIdentity => _repo is SessionIdentityRepository
      ? (_repo as SessionIdentityRepository).sessionIdentity
      : null;

  /// Serialize identity-changing SDK calls so an old login/sign-out cannot
  /// mutate the SDK session after a newer login. Profile refreshes stay separate.
  Future<T> _identityOperation<T>(Future<T> Function() action) async {
    final previous = _identityTail;
    final done = Completer<void>();
    _identityTail = done.future;
    try {
      if (previous != null) await previous;
      return await action();
    } finally {
      done.complete();
      if (identical(_identityTail, done.future)) {
        _identityTail = null;
      }
    }
  }

  String? _savedMode() {
    if (_committedMode != null) return _committedMode;
    try {
      final raw = _prefs.getString(identityPreferenceKey);
      if (raw == null) return null;
      final record = jsonDecode(raw);
      if (record is Map &&
          record['v'] == 1 &&
          const ['member', 'guest', 'welcome'].contains(record['mode'])) {
        return _committedMode = record['mode'] as String;
      }
    } catch (_) {
      // Legacy installations and unreadable app preferences still use the SDK
      // session. A preference parsing error must not log out a valid user.
    }
    return null;
  }

  Future<void> _persistIdentity(String mode, String userId, bool entered) {
    _committedMode = mode;
    final snapshot = jsonEncode({
      'v': 1,
      'mode': mode,
      'user_id': userId,
      'entered': entered,
    });
    // Persist committed states in order, even when a new login is pending.
    // The whole intent is one value; compatibility keys are secondary.
    final previous = _preferenceTail;
    final done = Completer<void>();
    final current = done.future;
    _preferenceTail = current;
    return () async {
      try {
        if (previous != null) await previous;
        if (!await _prefs.setString(identityPreferenceKey, snapshot)) {
          throw StateError('Không lưu được lựa chọn tài khoản.');
        }
        if (userId.isEmpty) {
          await _prefs.remove(PrefKeys.currentUserId);
        } else {
          await _prefs.setString(PrefKeys.currentUserId, userId);
        }
        await _prefs.setBool(PrefKeys.hasSeenSplashGate, entered);
      } catch (error) {
        // Authentication already succeeded; a preference error is not a failed
        // login and must not destroy the current identity.
        debugPrint('Chưa lưu được trạng thái đăng nhập trên thiết bị: $error');
      } finally {
        done.complete();
        if (identical(_preferenceTail, current)) {
          _preferenceTail = null;
        }
      }
    }();
  }

  void _guestState({required bool entered}) {
    _currentUser = AppUser.guest();
    _adminPreviewAsReader = false;
    _profileNeedsRefresh = false;
    _balanceNeedsRefresh = false;
    _hasEnteredApp = entered;
    _isLoading = false;
    _authenticatingRevision = null;
    _error = null;
  }

  void _adoptUser(AppUser user, {required bool pendingProfile}) {
    _currentUser = user;
    _adminPreviewAsReader = false;
    _profileNeedsRefresh = pendingProfile;
    _balanceNeedsRefresh = pendingProfile;
    _hasEnteredApp = true;
  }

  /// Restores the SDK identity immediately, then enriches it from ho_so.
  /// A slow/offline profile read never blocks entering the reader or drops Auth.
  Future<void> restoreSession() async {
    if (_disposed || _authenticatingRevision == _identityRevision) return;
    final revision = ++_identityRevision;
    final mutationVersion = _profileMutationVersion;
    final mode = _savedMode();
    if (mode == 'guest' || mode == 'welcome') {
      _guestState(entered: mode == 'guest');
      notifyListeners();
      // Honor an explicit local choice even if SDK cleanup was interrupted.
      if (_sessionIdentity != null) unawaited(_signOutInOrder());
      return;
    }
    final identity = _sessionIdentity;
    if (identity == null) {
      _guestState(entered: _prefs.getBool(PrefKeys.hasSeenSplashGate) ?? false);
      notifyListeners();
      return;
    }
    _adoptUser(identity, pendingProfile: true);
    _isLoading = false;
    _error = null;
    _profileRefreshRevision = revision;
    unawaited(_persistIdentity('member', identity.id, true));
    notifyListeners();
    try {
      final user = await _repo.getUserById(identity.id);
      if (!_currentRequest(revision) ||
          mutationVersion != _profileMutationVersion) {
        return;
      }
      if (user != null && user.id == identity.id) {
        if (user.isBanned) {
          await logout();
        } else {
          _adoptUser(user, pendingProfile: false);
        }
      }
    } catch (_) {
      // Keep the authenticated identity; retry enrichment after reconnecting.
    } finally {
      if (_profileRefreshRevision == revision) _profileRefreshRevision = null;
      if (_currentRequest(revision)) {
        notifyListeners();
        if (_profileNeedsRefresh &&
            mutationVersion != _profileMutationVersion) {
          unawaited(refreshCurrentUser());
        }
      }
    }
  }

  Future<void> _signOutInOrder() => _identityOperation(() async {
    try {
      await _repo.logout();
    } catch (error) {
      // Supabase clears its local token before attempting the remote sign-out.
      // The persisted guest/welcome intent also survives a failed network call.
      debugPrint(
        'Đã thoát trên thiết bị; chưa xác nhận được đăng xuất từ xa: $error',
      );
    }
  });

  /// Guest and explicit logout publish immediately, without waiting for Auth IO.
  Future<void> continueAsGuest() async {
    if (_disposed) return;
    _identityRevision++;
    _guestState(entered: true);
    final persisted = _persistIdentity('guest', '', true);
    final signedOut = _signOutInOrder();
    notifyListeners();
    await persisted;
    await signedOut;
  }

  /// Busy forms reject duplicate identity requests; guest/logout may supersede
  /// one, and their SDK cleanup runs before the next login in the same queue.
  Future<bool> _authenticate(
    Future<AppUser> Function() action, {
    required bool registering,
  }) async {
    if (_disposed || _authenticatingRevision == _identityRevision) return false;
    final revision = ++_identityRevision;
    _authenticatingRevision = revision;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final user = await _identityOperation<AppUser?>(() async {
        if (!_currentRequest(revision)) return null;
        return action();
      });
      if (!_currentRequest(revision) || user == null) return false;
      _adoptUser(user, pendingProfile: false);
      await _persistIdentity('member', user.id, true);
      return _currentRequest(revision);
    } catch (error) {
      if (!_currentRequest(revision)) return false;
      final identity = error is AuthenticatedProfileUnavailable
          ? _sessionIdentity
          : null;
      if (error is AuthenticatedProfileUnavailable &&
          identity?.id == error.userId) {
        _adoptUser(identity!, pendingProfile: true);
        _error = registering
            ? 'Tài khoản đã đăng nhập; hồ sơ sẽ được đồng bộ khi có mạng.'
            : 'Đã đăng nhập; hồ sơ sẽ được đồng bộ khi kết nối ổn định.';
        await _persistIdentity('member', identity.id, true);
        return _currentRequest(revision);
      }
      // If an attempted account switch ended a banned/invalid SDK session,
      // never leave the UI advertising the old account without its token.
      if (_repo is SessionIdentityRepository &&
          !_currentUser.isGuest &&
          _sessionIdentity?.id != _currentUser.id) {
        _guestState(entered: true);
        await _persistIdentity('guest', '', true);
      }
      if (_currentRequest(revision)) _error = _friendlyError(error);
      return false;
    } finally {
      if (_authenticatingRevision == revision) _authenticatingRevision = null;
      if (_currentRequest(revision)) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> login(String email, String password) =>
      _authenticate(() => _repo.login(email, password), registering: false);

  Future<bool> register({
    required String email,
    required String displayName,
    required String password,
  }) => _authenticate(
    () => _repo.register(
      email: email,
      displayName: displayName,
      password: password,
    ),
    registering: true,
  );

  Future<void> logout() async {
    if (_disposed) return;
    _identityRevision++;
    _guestState(entered: false);
    final persisted = _persistIdentity('welcome', '', false);
    final signedOut = _signOutInOrder();
    notifyListeners();
    await persisted;
    await signedOut;
  }

  /// Bật/tắt chế độ xem thử giao diện Độc giả dành cho Admin.
  void toggleAdminPreviewMode() {
    RoleGuard.requireAdmin(_currentUser);
    _adminPreviewAsReader = !_adminPreviewAsReader;
    notifyListeners();
  }

  /// Đổi mật khẩu tài khoản hiện tại qua Supabase Auth.
  Future<void> changePassword(String newPassword) async {
    RoleGuard.requirePermission(_currentUser, AppPermission.interactAndGamify);
    final revision = _identityRevision;
    final owner = _currentUser.id;
    await _identityOperation(() async {
      if (!_sameIdentity(owner, revision)) return;
      await _repo.changePassword(newPassword);
      if (_sameIdentity(owner, revision)) notifyListeners();
    });
  }

  /// Gửi email đặt lại mật khẩu qua Supabase Auth.
  Future<void> resetPassword({required String email}) async {
    await _repo.resetPassword(email);
  }

  /// Cập nhật tên hiển thị, avatar, khung avatar hoặc huy hiệu ghim.
  Future<void> updateProfile({
    String? displayName,
    String? avatar,
    String? avatarFrame,
    List<String>? pinnedAchievements,
  }) async {
    RoleGuard.requirePermission(_currentUser, AppPermission.interactAndGamify);
    final pins = pinnedAchievements?.take(3).toList();
    await _mutateUser<bool>(false, (user, revision) async {
      final proposal = user.copyWith(
        displayName: displayName?.trim().isNotEmpty == true
            ? displayName!.trim()
            : user.displayName,
        avatar: avatar ?? user.avatar,
        avatarFrame: avatarFrame ?? user.avatarFrame,
        pinnedAchievements: pins ?? user.pinnedAchievements,
      );
      final profileRepo = _repo is ProfileFieldsRepository
          ? _repo as ProfileFieldsRepository
          : null;
      final updated = profileRepo == null
          ? await _repo.updateUser(proposal)
          : await profileRepo.updateProfileFields(proposal);
      if (!_sameIdentity(user.id, revision) || updated.id != user.id) {
        return false;
      }
      _currentUser = updated;
      if (profileRepo != null) {
        _profileNeedsRefresh = false;
        _balanceNeedsRefresh = false;
      }
      notifyListeners();
      return true;
    });
  }

  /// Nhận thưởng bằng RPC để đánh dấu nhiệm vụ và cộng tiền nguyên tử.
  Future<int?> claimQuestReward(int questId, int reward) async {
    if (_currentUser.isGuest || reward < 0 || reward > 100000) return null;
    return _mutateUser<int?>(null, (user, revision) async {
      final economyRepo = _repo is AtomicEconomyRepository
          ? _repo as AtomicEconomyRepository
          : null;
      if (economyRepo == null) {
        _currentUser = user.copyWith(
          linhThach: (user.linhThach + reward).clamp(0, 9999999),
        );
        notifyListeners();
        return reward;
      }
      final claim = await economyRepo.claimQuestReward(questId);
      if (claim == null || !_applyEconomyReceipt(user, revision, claim)) {
        return null;
      }
      return claim.reward;
    });
  }

  /// Mua vật phẩm trong Cửa hàng Linh Thạch (khung avatar, nền đọc, hiệu ứng).
  Future<bool> purchaseShopItem(String itemKey, int cost) async {
    RoleGuard.requirePermission(_currentUser, AppPermission.interactAndGamify);
    if (itemKey.trim().isEmpty || cost <= 0) return false;
    return _mutateUser<bool>(false, (user, revision) async {
      if (user.unlockedItems.contains(itemKey)) return true;
      if (!_balanceNeedsRefresh && user.linhThach < cost) return false;
      final economyRepo = _repo is AtomicEconomyRepository
          ? _repo as AtomicEconomyRepository
          : null;
      if (economyRepo == null) {
        _currentUser = user.copyWith(
          linhThach: user.linhThach - cost,
          unlockedItems: [...user.unlockedItems, itemKey],
        );
        notifyListeners();
        return true;
      }
      final updated = await economyRepo.purchaseShopItem(itemKey, cost);
      return updated != null && _applyEconomyReceipt(user, revision, updated);
    });
  }

  /// Mua Khiên bảo vệ Streak (tiêu 20 Linh Thạch để giữ chuỗi 1 ngày bỏ lỡ).
  Future<bool> buyStreakShield() async {
    RoleGuard.requirePermission(_currentUser, AppPermission.interactAndGamify);
    return _mutateUser<bool>(false, (user, revision) async {
      if (user.hasStreakShield) return true;
      if (!_balanceNeedsRefresh && user.linhThach < 20) return false;
      final economyRepo = _repo is AtomicEconomyRepository
          ? _repo as AtomicEconomyRepository
          : null;
      if (economyRepo == null) {
        _currentUser = user.copyWith(
          linhThach: user.linhThach - 20,
          hasStreakShield: true,
        );
        notifyListeners();
        return true;
      }
      final updated = await economyRepo.buyStreakShield();
      return updated != null && _applyEconomyReceipt(user, revision, updated);
    });
  }

  /// Cộng hoặc trừ Linh Thạch trực tiếp (Điểm danh ngày, Rút quẻ may mắn, Ủng hộ Tác giả).
  Future<bool> adjustSpiritStones(int delta, {int streakDelta = 0}) async {
    RoleGuard.requirePermission(_currentUser, AppPermission.interactAndGamify);
    return _mutateUser<bool>(false, (user, revision) async {
      final nextBalance = user.linhThach + delta;
      if (nextBalance < 0) return false;
      final nextStreak = (user.streak + streakDelta).clamp(0, 99999);
      _currentUser = user.copyWith(
        linhThach: nextBalance,
        streak: nextStreak,
      );
      _balanceNeedsRefresh = false;
      notifyListeners();
      try {
        await _repo.updateUser(_currentUser);
      } catch (_) {}
      return true;
    });
  }

  /// Làm mới dữ liệu tài khoản hiện tại từ bảng ho_so.
  Future<void> refreshCurrentUser() async {
    final revision = _identityRevision;
    if (_currentUser.isGuest || _profileRefreshRevision == revision) return;
    final userId = _currentUser.id;
    _profileRefreshRevision = revision;
    try {
      // A read started before a purchase must not restore its old balance.
      final pendingMutation = _mutationTails[revision];
      if (pendingMutation != null) await pendingMutation;
      if (!_sameIdentity(userId, revision)) return;
      final mutationVersion = _profileMutationVersion;
      final fresh = await _repo.getUserById(userId);
      // Hồ sơ cũ có thể trả về sau khi đăng xuất, đổi tài khoản hoặc đăng nhập
      // lại cùng tài khoản. Chỉ cập nhật phiên đã gửi yêu cầu này.
      if (!_sameIdentity(userId, revision) ||
          mutationVersion != _profileMutationVersion ||
          _mutationTails.containsKey(revision)) {
        return;
      }
      if (fresh != null && fresh.id == userId) {
        _currentUser = fresh;
        _profileNeedsRefresh = false;
        _balanceNeedsRefresh = false;
        notifyListeners();
      }
    } catch (_) {
      // Lỗi mạng tạm thời không xóa session hoặc hồ sơ đang dùng.
    } finally {
      if (_profileRefreshRevision == revision) _profileRefreshRevision = null;
    }
  }

  String _friendlyError(Object e) {
    if (e is AuthenticatedProfileUnavailable) {
      return 'Đã xác thực nhưng chưa tải được hồ sơ. Vui lòng thử lại khi kết nối ổn định.';
    }
    final str = e.toString();
    if (str.contains('email_address_invalid') || str.contains('is invalid')) {
      return 'Địa chỉ email không hợp lệ (Lưu ý: Gmail yêu cầu tên người dùng từ 6 ký tự trở lên).';
    }
    if (str.contains('over_email_send_rate_limit') ||
        str.contains('rate limit')) {
      return 'Đã vượt giới hạn gửi email trong 1 giờ. Vui lòng tắt "Confirm email" trong cài đặt Supabase hoặc thử lại sau.';
    }
    if (str.contains('User already registered') ||
        str.contains('user_already_exists')) {
      return 'Email này đã được sử dụng. Vui lòng đăng nhập hoặc dùng email khác.';
    }
    if (str.contains('Invalid login credentials') ||
        str.contains('invalid_credentials')) {
      return 'Email hoặc mật khẩu không chính xác.';
    }
    if (str.contains('row-level security policy') || str.contains('42501')) {
      return 'Lỗi phân quyền hồ sơ. Vui lòng thử lại hoặc đăng nhập trực tiếp.';
    }
    return str
        .replaceFirst('Bad state: ', '')
        .replaceFirst('AuthException: ', '')
        .replaceFirst(RegExp(r'^AuthApiException\(message:\s*'), '')
        .replaceFirst(RegExp(r',\s*statusCode:\s*\d+.*$'), '');
  }
}
