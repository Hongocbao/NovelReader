import '../models/app_user.dart';

/// Các quyền thao tác trong hệ thống theo Ma trận phân quyền (Mục 2).
enum AppPermission {
  /// Đọc truyện, tìm kiếm, tải offline, tủ sách cục bộ.
  readAndBrowse,

  /// Đồng bộ, bình luận, đánh giá, nhiệm vụ, huy hiệu.
  interactAndGamify,

  /// Đăng truyện và chương (chờ duyệt đối với Author, đăng thẳng đối với Admin).
  publishContent,

  /// Duyệt truyện, xử lý báo cáo, khóa tài khoản.
  moderateContent,

  /// Bảng thống kê hệ thống, cấu hình, nhật ký thao tác (Audit Log).
  manageSystem,
}

/// Lớp bảo vệ phân quyền ở 3 tầng:
/// 1. Route guard khi điều hướng màn hình.
/// 2. Provider từ chối thao tác trái quyền.
/// 3. Repository/DB kiểm tra trước khi ghi dữ liệu.
class RoleGuard {
  RoleGuard._();

  /// Kiểm tra người dùng [user] (null = Khách) có quyền [permission] hay không.
  static bool can(AppUser? user, AppPermission permission) {
    // Tài khoản đang bị khóa chỉ được đọc cơ bản như khách.
    if (user != null && user.isBanned) {
      return permission == AppPermission.readAndBrowse;
    }

    switch (permission) {
      case AppPermission.readAndBrowse:
        return true;
      case AppPermission.interactAndGamify:
        return user != null && !user.isGuest;
      case AppPermission.publishContent:
        // Hợp nhất tác giả & độc giả: Mọi độc giả đã đăng nhập đều có thể sáng tác truyện và gửi duyệt
        return user != null && !user.isGuest;
      case AppPermission.moderateContent:
      case AppPermission.manageSystem:
        return user != null && user.isAdmin;
    }
  }

  /// Ném [StateError] nếu người dùng không đủ quyền thực hiện thao tác.
  static void requirePermission(
    AppUser? user,
    AppPermission permission, [
    String? customMessage,
  ]) {
    if (!can(user, permission)) {
      throw StateError(
        customMessage ??
            'Từ chối truy cập: Tài khoản không có quyền ${permission.name}.',
      );
    }
  }

  /// Kiểm tra nhanh quyền Admin; ném lỗi nếu không phải Admin hoạt động.
  static void requireAdmin(AppUser? user) {
    requirePermission(
      user,
      AppPermission.manageSystem,
      'Chỉ Quản trị viên (Admin) mới được phép thực hiện thao tác này.',
    );
  }

  /// Kiểm tra nhanh quyền Sáng tác / Tác giả: Mọi độc giả đã đăng nhập đều được phép viết truyện.
  static void requireAuthorOrAdmin(AppUser? user) {
    requirePermission(
      user,
      AppPermission.publishContent,
      'Vui lòng đăng nhập tài khoản để sáng tác truyện và gửi duyệt tác phẩm.',
    );
  }
}
