import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import '../repositories/auth_repository.dart';
import '../utils/constants.dart';
import '../utils/role_guard.dart';

/// Quản lý trạng thái xác thực, phiên đăng nhập, chế độ Khách và phân quyền.
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

  /// Có hiển thị giao diện AdminShell hay không.
  bool get shouldShowAdminShell => isAdmin && !_adminPreviewAsReader;

  /// Khôi phục phiên đăng nhập đã lưu từ SharedPreferences.
  Future<void> restoreSession() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final savedId = _prefs.getInt(PrefKeys.currentUserId) ?? 0;
      _hasEnteredApp = _prefs.getBool(PrefKeys.hasSeenSplashGate) ?? false;
      if (savedId > 0) {
        final user = await _repo.getUserById(savedId);
        if (user != null && !user.isBanned) {
          _currentUser = user;
          _hasEnteredApp = true;
        } else {
          await _prefs.remove(PrefKeys.currentUserId);
          _currentUser = AppUser.guest();
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tiếp tục với tư cách Khách (dữ liệu lưu cục bộ trên thiết bị).
  Future<void> continueAsGuest() async {
    _currentUser = AppUser.guest();
    _adminPreviewAsReader = false;
    _hasEnteredApp = true;
    _error = null;
    await _prefs.remove(PrefKeys.currentUserId);
    await _prefs.setBool(PrefKeys.hasSeenSplashGate, true);
    notifyListeners();
  }

  /// Đăng nhập bằng email & mật khẩu.
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final user = await _repo.login(email, password);
      _currentUser = user;
      _adminPreviewAsReader = false;
      _hasEnteredApp = true;
      await _prefs.setInt(PrefKeys.currentUserId, user.id);
      await _prefs.setBool(PrefKeys.hasSeenSplashGate, true);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Bad state: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Đăng ký tài khoản mới và giữ nguyên toàn bộ tủ sách, lịch sử, bookmark cục bộ.
  Future<bool> register({
    required String email,
    required String displayName,
    required String password,
    String secretQuestion = 'Thể loại truyện yêu thích của bạn là gì?',
    String secretAnswer = 'tien hiep',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final user = await _repo.register(
        email: email,
        displayName: displayName,
        password: password,
        secretQuestion: secretQuestion,
        secretAnswer: secretAnswer,
      );
      _currentUser = user;
      _adminPreviewAsReader = false;
      _hasEnteredApp = true;
      await _prefs.setInt(PrefKeys.currentUserId, user.id);
      await _prefs.setBool(PrefKeys.hasSeenSplashGate, true);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Bad state: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Đăng xuất và quay về màn hình cổng đăng nhập (SplashGate).
  Future<void> logout() async {
    _currentUser = AppUser.guest();
    _adminPreviewAsReader = false;
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

  /// Đổi mật khẩu (đặc biệt dùng khi Admin đăng nhập lần đầu).
  Future<void> changePassword(String newPassword) async {
    RoleGuard.requirePermission(_currentUser, AppPermission.interactAndGamify);
    _currentUser = await _repo.changePassword(_currentUser.id, newPassword);
    notifyListeners();
  }

  /// Đặt lại mật khẩu qua câu hỏi bí mật.
  Future<void> resetPassword({
    required String email,
    required String secretAnswer,
    required String newPassword,
  }) async {
    await _repo.resetPasswordWithSecret(
      email: email,
      secretAnswer: secretAnswer,
      newPassword: newPassword,
    );
  }

  /// Cập nhật tên hiển thị, avatar, khung avatar hoặc huy hiệu ghim.
  Future<void> updateProfile({
    String? displayName,
    String? avatar,
    String? avatarFrame,
    List<String>? pinnedAchievements,
  }) async {
    RoleGuard.requirePermission(_currentUser, AppPermission.interactAndGamify);
    final nextPinned = pinnedAchievements != null
        ? pinnedAchievements.take(3).toList()
        : _currentUser.pinnedAchievements;
    final updated = _currentUser.copyWith(
      displayName: displayName?.trim().isNotEmpty == true
          ? displayName!.trim()
          : _currentUser.displayName,
      avatar: avatar ?? _currentUser.avatar,
      avatarFrame: avatarFrame ?? _currentUser.avatarFrame,
      pinnedAchievements: nextPinned,
    );
    _currentUser = await _repo.updateUser(updated);
    notifyListeners();
  }

  /// Cộng hoặc trừ Linh Thạch của người dùng hiện tại.
  Future<void> adjustLinhThach(int delta) async {
    if (_currentUser.isGuest) return;
    final nextBalance = (_currentUser.linhThach + delta).clamp(0, 9999999);
    _currentUser = await _repo.updateUser(
      _currentUser.copyWith(linhThach: nextBalance),
    );
    notifyListeners();
  }

  /// Mua vật phẩm trong Cửa hàng Linh Thạch (khung avatar, nền đọc, hiệu ứng).
  Future<bool> purchaseShopItem(String itemKey, int cost) async {
    RoleGuard.requirePermission(_currentUser, AppPermission.interactAndGamify);
    if (_currentUser.unlockedItems.contains(itemKey)) return true;
    if (_currentUser.linhThach < cost) return false;
    final updated = _currentUser.copyWith(
      linhThach: _currentUser.linhThach - cost,
      unlockedItems: [..._currentUser.unlockedItems, itemKey],
    );
    _currentUser = await _repo.updateUser(updated);
    notifyListeners();
    return true;
  }

  /// Mua Khiên bảo vệ Streak (tiêu 20 Linh Thạch để giữ chuỗi 1 ngày bỏ lỡ).
  Future<bool> buyStreakShield() async {
    RoleGuard.requirePermission(_currentUser, AppPermission.interactAndGamify);
    if (_currentUser.hasStreakShield) return true;
    if (_currentUser.linhThach < 20) return false;
    _currentUser = await _repo.updateUser(
      _currentUser.copyWith(
        linhThach: _currentUser.linhThach - 20,
        hasStreakShield: true,
      ),
    );
    notifyListeners();
    return true;
  }

  /// Làm mới dữ liệu tài khoản hiện tại từ DB.
  Future<void> refreshCurrentUser() async {
    if (_currentUser.isGuest) return;
    final fresh = await _repo.getUserById(_currentUser.id);
    if (fresh != null) {
      _currentUser = fresh;
      notifyListeners();
    }
  }
}
