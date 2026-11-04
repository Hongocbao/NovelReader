import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  /// Khôi phục phiên đăng nhập từ Supabase Auth session.
  Future<void> restoreSession() async {
    _identityRevision++;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _hasEnteredApp = _prefs.getBool(PrefKeys.hasSeenSplashGate) ?? false;
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        // Supabase Auth lưu session cục bộ. Đặt trạng thái tài khoản trước,
        // rồi tải hồ sơ; lỗi mạng không được biến phiên hợp lệ thành Khách.
        _currentUser = _userFromSession(session.user);
        _profileNeedsRefresh = true;
        _balanceNeedsRefresh = true;
        _hasEnteredApp = true;
        try {
          final user = await _repo.getUserById(session.user.id);
          if (user?.isBanned == true) {
            await _repo.logout();
            _currentUser = AppUser.guest();
            _profileNeedsRefresh = false;
            _balanceNeedsRefresh = false;
            _hasEnteredApp = false;
            await _prefs.remove(PrefKeys.currentUserId);
            await _prefs.setBool(PrefKeys.hasSeenSplashGate, false);
          } else if (user != null) {
            _currentUser = user;
            _profileNeedsRefresh = false;
            _balanceNeedsRefresh = false;
          }
        } catch (_) {
          // Giữ session và danh tính cơ bản; lần mở app sau sẽ thử tải lại.
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tiếp tục với tư cách Khách.
  Future<void> continueAsGuest() async {
    _identityRevision++;
    _currentUser = AppUser.guest();
    _adminPreviewAsReader = false;
    _profileNeedsRefresh = false;
    _balanceNeedsRefresh = false;
    _hasEnteredApp = true;
    _error = null;
    await _prefs.remove(PrefKeys.currentUserId);
    await _prefs.setBool(PrefKeys.hasSeenSplashGate, true);
    notifyListeners();
  }

  /// Đăng nhập bằng Supabase Auth (signInWithPassword).
  Future<bool> login(String email, String password) async {
    _identityRevision++;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final user = await _repo.login(email, password);
      _currentUser = user;
      _adminPreviewAsReader = false;
      _profileNeedsRefresh = false;
      _balanceNeedsRefresh = false;
      _hasEnteredApp = true;
      await _prefs.setString(PrefKeys.currentUserId, user.id);
      await _prefs.setBool(PrefKeys.hasSeenSplashGate, true);
      return true;
    } catch (e) {
      final pendingProfile = e is AuthenticatedProfileUnavailable ? e : null;
      final session = pendingProfile != null
          ? Supabase.instance.client.auth.currentSession
          : null;
      if (pendingProfile != null &&
          session != null &&
          session.user.id == pendingProfile.userId) {
        _currentUser = _userFromSession(session.user);
        _adminPreviewAsReader = false;
        _profileNeedsRefresh = true;
        _balanceNeedsRefresh = true;
        _hasEnteredApp = true;
        await _prefs.setString(PrefKeys.currentUserId, _currentUser.id);
        await _prefs.setBool(PrefKeys.hasSeenSplashGate, true);
        _error = 'Đã đăng nhập; hồ sơ sẽ được đồng bộ khi kết nối ổn định.';
        return true;
      }
      _error = _friendlyError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Đăng ký tài khoản mới bằng Supabase Auth (signUp).
  Future<bool> register({
    required String email,
    required String displayName,
    required String password,
  }) async {
    _identityRevision++;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final user = await _repo.register(
        email: email,
        displayName: displayName,
        password: password,
      );
      _currentUser = user;
      _adminPreviewAsReader = false;
      _profileNeedsRefresh = false;
      _balanceNeedsRefresh = false;
      _hasEnteredApp = true;
      await _prefs.setString(PrefKeys.currentUserId, user.id);
      await _prefs.setBool(PrefKeys.hasSeenSplashGate, true);
      return true;
    } catch (e) {
      final pendingProfile = e is AuthenticatedProfileUnavailable ? e : null;
      final session = pendingProfile != null
          ? Supabase.instance.client.auth.currentSession
          : null;
      if (pendingProfile != null &&
          session != null &&
          session.user.id == pendingProfile.userId) {
        _currentUser = _userFromSession(session.user);
        _adminPreviewAsReader = false;
        _profileNeedsRefresh = true;
        _balanceNeedsRefresh = true;
        _hasEnteredApp = true;
        await _prefs.setString(PrefKeys.currentUserId, _currentUser.id);
        await _prefs.setBool(PrefKeys.hasSeenSplashGate, true);
        _error = 'Tài khoản đã đăng nhập; hồ sơ sẽ được đồng bộ khi có mạng.';
        return true;
      }
      _error = _friendlyError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Đăng xuất khỏi Supabase Auth và quay về màn hình SplashGate.
  Future<void> logout() async {
    _identityRevision++;
    try {
      await _repo.logout();
    } catch (_) {}
    _currentUser = AppUser.guest();
    _adminPreviewAsReader = false;
    _profileNeedsRefresh = false;
    _balanceNeedsRefresh = false;
    _hasEnteredApp = false;
    _error = null;
    await _prefs.remove(PrefKeys.currentUserId);
    await _prefs.setBool(PrefKeys.hasSeenSplashGate, false);
    notifyListeners();
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
    await _repo.changePassword(newPassword);
    notifyListeners();
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

  AppUser _userFromSession(User user) {
    final email = user.email?.trim() ?? '';
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    final metadataName = metadata['display_name'] ?? metadata['name'];
    final displayName = metadataName is String && metadataName.trim().isNotEmpty
        ? metadataName.trim()
        : (email.contains('@') ? email.split('@').first : 'Độc giả');
    final now = DateTime.now();
    return AppUser(
      id: user.id,
      email: email,
      displayName: displayName,
      role: UserRole.user,
      isAuthor: false,
      lastActiveAt: now,
      createdAt: now,
    );
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
