import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../database/v2_database_store.dart';
import '../models/app_user.dart';
import '../repositories/auth_repository.dart';
import '../utils/csv_exporter.dart';
import '../utils/role_guard.dart';

/// Quản lý người dùng dành cho Admin: tìm kiếm, khóa/mở khóa, cấp quyền Author/Admin & xuất CSV (Mục 6.4).
class AdminUserProvider extends ChangeNotifier {
  final AppDatabase _appDb;
  final AuthRepository _authRepo;

  List<AppUser> _users = [];
  bool _isLoading = false;
  String? _error;

  AdminUserProvider(this._appDb, this._authRepo);

  List<AppUser> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Tải danh sách người dùng.
  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _users = await _authRepo.getAllUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Khóa tài khoản người dùng (1 ngày, 7 ngày hoặc vĩnh viễn) kèm lý do.
  Future<void> banUser({
    required AppUser admin,
    required AppUser target,
    required String reason,
    int? durationDays,
  }) async {
    RoleGuard.requireAdmin(admin);
    if (admin.id == target.id) {
      throw StateError('Admin không thể tự khóa chính mình.');
    }
    if (target.isAdmin && _countActiveAdmins() <= 1) {
      throw StateError('Hệ thống phải luôn còn ít nhất 1 Admin hoạt động.');
    }
    final until = durationDays != null
        ? DateTime.now().add(Duration(days: durationDays))
        : null;
    final updated = target.copyWith(
      status: UserStatus.banned,
      banReason: reason.trim().isEmpty ? 'Vi phạm nội quy' : reason.trim(),
      banUntil: until,
    );
    await _authRepo.updateUser(updated);
    final db = await _appDb.database;
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'BAN_USER',
      target: 'user#${target.id} (${target.email})',
      detail:
          'Thời hạn: ${durationDays != null ? "$durationDays ngày" : "Vĩnh viễn"} | Lý do: ${updated.banReason}',
    );
    await loadUsers();
  }

  /// Mở khóa tài khoản người dùng.
  Future<void> unbanUser({
    required AppUser admin,
    required AppUser target,
  }) async {
    RoleGuard.requireAdmin(admin);
    final updated = target.copyWith(
      status: UserStatus.active,
      banReason: null,
      banUntil: null,
    );
    await _authRepo.updateUser(updated);
    final db = await _appDb.database;
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'UNBAN_USER',
      target: 'user#${target.id} (${target.email})',
      detail: 'Mở khóa tài khoản',
    );
    await loadUsers();
  }

  /// Cấp hoặc thu hồi quyền Tác giả (`is_author`).
  Future<void> toggleAuthorRole({
    required AppUser admin,
    required AppUser target,
    required bool isAuthor,
  }) async {
    RoleGuard.requireAdmin(admin);
    final updated = target.copyWith(isAuthor: isAuthor);
    await _authRepo.updateUser(updated);
    final db = await _appDb.database;
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: isAuthor ? 'GRANT_AUTHOR' : 'REVOKE_AUTHOR',
      target: 'user#${target.id} (${target.email})',
      detail: isAuthor ? 'Cấp quyền đăng truyện' : 'Thu hồi quyền đăng truyện',
    );
    await loadUsers();
  }

  /// Đổi vai trò `user` / `admin` (chặn tự hạ quyền hoặc làm mất Admin cuối cùng).
  Future<void> changeUserRole({
    required AppUser admin,
    required AppUser target,
    required String newRole,
  }) async {
    RoleGuard.requireAdmin(admin);
    if (admin.id == target.id && newRole != UserRole.admin) {
      throw StateError('Admin không thể tự hạ quyền của chính mình.');
    }
    if (target.isAdmin &&
        newRole != UserRole.admin &&
        _countActiveAdmins() <= 1) {
      throw StateError('Hệ thống phải luôn còn ít nhất 1 Admin.');
    }
    final updated = target.copyWith(role: newRole);
    await _authRepo.updateUser(updated);
    final db = await _appDb.database;
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'CHANGE_ROLE',
      target: 'user#${target.id} (${target.email})',
      detail: 'Đổi role từ ${target.role} sang $newRole',
    );
    await loadUsers();
  }

  /// Đặt lại mật khẩu cho tài khoản người dùng qua email.
  Future<void> resetTemporaryPassword({
    required AppUser admin,
    required AppUser target,
    String? tempPassword,
  }) async {
    RoleGuard.requireAdmin(admin);
    await _authRepo.resetPassword(target.email);
    final db = await _appDb.database;
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'RESET_PASSWORD',
      target: 'user#${target.id} (${target.email})',
      detail: 'Gửi yêu cầu đặt lại mật khẩu qua email',
    );
    await loadUsers();
  }

  /// Xuất danh sách người dùng hiện tại ra chuỗi CSV.
  String exportUsersCsv() {
    return CsvExporter.toCsv(
      headers: const [
        'ID',
        'Email',
        'Tên hiển thị',
        'Vai trò',
        'Tác giả',
        'Trạng thái',
        'Linh Thạch',
        'Streak',
      ],
      rows: _users
          .map(
            (u) => [
              u.id,
              u.email,
              u.displayName,
              u.role,
              u.isAuthor ? 'Có' : 'Không',
              u.status,
              u.linhThach,
              u.streak,
            ],
          )
          .toList(),
    );
  }

  int _countActiveAdmins() =>
      _users.where((u) => u.isAdmin && !u.isBanned).length;
}
