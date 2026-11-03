import '../models/app_user.dart';

class QuestRewardClaim {
  final AppUser user;
  final int reward;

  const QuestRewardClaim({required this.user, required this.reward});
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
  Future<AppUser?> purchaseShopItem(String itemKey, int cost);
  Future<AppUser?> buyStreakShield();
  Future<QuestRewardClaim?> claimQuestReward(int questId);
}
