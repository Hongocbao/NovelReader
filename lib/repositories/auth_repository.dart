import '../models/app_user.dart';

/// Confirmed server transaction, independent of the following profile read.
/// [balance] is null when an older server function omits it; callers must not
/// present an estimated balance as the server's current value.
class EconomyReceipt {
  final String userId;
  final AppUser? profile;
  final int? balance;
  final int reward;
  final String? unlockedItem;
  final bool hasStreakShield;

  const EconomyReceipt({
    required this.userId,
    this.profile,
    this.balance,
    this.reward = 0,
    this.unlockedItem,
    this.hasStreakShield = false,
  });
}

/// Auth đã xác thực thành công nhưng chưa đọc/ghi được hồ sơ ứng dụng.
class AuthenticatedProfileUnavailable implements Exception {
  final String userId;

  const AuthenticatedProfileUnavailable(this.userId);
}

/// Giao diện trừu tượng của tầng xác thực và quản lý tài khoản.
abstract class AuthRepository {
  /// Đăng nhập bằng [email] và [password].
  Future<AppUser> login(String email, String password);

  /// Đăng ký tài khoản mới.
  Future<AppUser> register({
    required String email,
    required String displayName,
    required String password,
  });

  /// Lấy thông tin người dùng theo [id] (UUID).
  Future<AppUser?> getUserById(String id);

  /// Lấy thông tin người dùng hiện tại từ session.
  Future<AppUser?> getCurrentUser();

  /// Lấy danh sách toàn bộ người dùng (dành cho Admin).
  Future<List<AppUser>> getAllUsers();

  /// Cập nhật thông tin hồ sơ người dùng trong bảng ho_so.
  Future<AppUser> updateUser(AppUser user);

  /// Đổi mật khẩu mới cho tài khoản.
  Future<void> changePassword(String newPassword);

  /// Gửi email đặt lại mật khẩu qua Supabase Auth.
  Future<void> resetPassword(String email);

  /// Đăng xuất khỏi hệ thống.
  Future<void> logout();
}

/// Optional capability for repositories that can perform economy changes
/// transactionally on the server. Keeping it separate preserves compatibility
/// with local and test AuthRepository implementations.
abstract interface class AtomicEconomyRepository {
  Future<EconomyReceipt?> purchaseShopItem(String itemKey, int cost);
  Future<EconomyReceipt?> buyStreakShield();
  Future<EconomyReceipt?> claimQuestReward(int questId);
}

/// Self-service profile fields can be saved without resending a stale balance.
abstract interface class ProfileFieldsRepository {
  Future<AppUser> updateProfileFields(AppUser user);
}

/// Authenticated identity from local session storage; requires no profile query.
abstract interface class SessionIdentityRepository {
  AppUser? get sessionIdentity;
}
