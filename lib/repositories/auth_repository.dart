import '../models/app_user.dart';

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

  /// Cập nhật thông tin hồ sơ người dùng trong bảng profiles.
  Future<AppUser> updateUser(AppUser user);

  /// Đổi mật khẩu mới cho tài khoản.
  Future<void> changePassword(String newPassword);

  /// Gửi email đặt lại mật khẩu qua Supabase Auth.
  Future<void> resetPassword(String email);

  /// Đăng xuất khỏi hệ thống.
  Future<void> logout();
}
