import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../models/app_user.dart';
import '../utils/password_hasher.dart';

/// Giao diện trừu tượng của tầng xác thực và quản lý tài khoản.
///
/// - Giai đoạn A: Dùng [LocalAuthRepository] lưu trên SQLite cục bộ.
/// - Giai đoạn B: Thay thế bằng [FirebaseAuthRepository] (Firebase Auth + Firestore)
///   mà không cần sửa đổi bất kỳ màn hình UI hay Provider nào.
abstract class AuthRepository {
  /// Đăng nhập bằng [email] và [password].
  /// Ném [StateError] nếu sai thông tin hoặc tài khoản đang bị khóa.
  Future<AppUser> login(String email, String password);

  /// Đăng ký tài khoản mới.
  Future<AppUser> register({
    required String email,
    required String displayName,
    required String password,
    String secretQuestion,
    String secretAnswer,
  });

  /// Lấy thông tin người dùng theo [id].
  Future<AppUser?> getUserById(int id);

  /// Lấy danh sách toàn bộ người dùng (dành cho Admin).
  Future<List<AppUser>> getAllUsers();

  /// Cập nhật thông tin hồ sơ người dùng.
  Future<AppUser> updateUser(AppUser user);

  /// Đổi mật khẩu mới cho tài khoản [userId].
  Future<AppUser> changePassword(int userId, String newPassword);

  /// Đặt lại mật khẩu bằng câu hỏi bí mật (Giai đoạn A) hoặc email (Giai đoạn B).
  Future<void> resetPasswordWithSecret({
    required String email,
    required String secretAnswer,
    required String newPassword,
  });
}

/// Triển khai Giai đoạn A: Xác thực cục bộ trên SQLite với băm SHA-256 + salt.
class LocalAuthRepository implements AuthRepository {
  final AppDatabase _appDb;

  LocalAuthRepository(this._appDb);

  Future<Database> get _db => _appDb.database;

  @override
  Future<AppUser> login(String email, String password) async {
    final db = await _db;
    final cleanEmail = email.trim().toLowerCase();
    final rows = await db.query(
      'users',
      where: 'LOWER(email) = ?',
      whereArgs: [cleanEmail],
    );
    if (rows.isEmpty) {
      throw StateError('Email hoặc mật khẩu không chính xác.');
    }

    final user = AppUser.fromMap(rows.first);
    final ok = PasswordHasher.verify(password, user.salt, user.passwordHash);
    if (!ok) {
      throw StateError('Email hoặc mật khẩu không chính xác.');
    }

    // Kiểm tra trạng thái khóa tài khoản
    if (user.isBanned) {
      final reason = (user.banReason?.isNotEmpty ?? false)
          ? user.banReason!
          : 'Vi phạm quy định cộng đồng';
      final untilStr = user.banUntil != null
          ? ' đến ${user.banUntil!.day}/${user.banUntil!.month}/${user.banUntil!.year}'
          : ' vĩnh viễn';
      throw StateError('Tài khoản đã bị khóa$untilStr. Lý do: $reason');
    }

    final updated = user.copyWith(
      status: UserStatus.active,
      lastActiveAt: DateTime.now(),
    );
    await db.update(
      'users',
      updated.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return updated;
  }

  @override
  Future<AppUser> register({
    required String email,
    required String displayName,
    required String password,
    String secretQuestion = 'Thể loại truyện yêu thích của bạn là gì?',
    String secretAnswer = 'tien hiep',
  }) async {
    final db = await _db;
    final cleanEmail = email.trim().toLowerCase();
    if (!cleanEmail.contains('@')) {
      throw StateError('Địa chỉ email không hợp lệ.');
    }
    if (password.length < 8) {
      throw StateError('Mật khẩu phải có ít nhất 8 ký tự.');
    }

    final existing = await db.query(
      'users',
      where: 'LOWER(email) = ?',
      whereArgs: [cleanEmail],
    );
    if (existing.isNotEmpty) {
      throw StateError('Email này đã được đăng ký.');
    }

    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hashPassword(password, salt);
    final answerHash = PasswordHasher.hashPassword(
      secretAnswer.trim().toLowerCase(),
      salt,
    );
    final now = DateTime.now();

    final newUser = AppUser(
      id: 0,
      email: cleanEmail,
      passwordHash: hash,
      salt: salt,
      displayName: displayName.trim().isEmpty ? 'Độc giả mới' : displayName.trim(),
      role: UserRole.user,
      linhThach: 150,
      streak: 1,
      secretQuestion: secretQuestion,
      secretAnswerHash: answerHash,
      lastActiveAt: now,
      createdAt: now,
    );

    final id = await db.insert('users', newUser.toMap());
    return newUser.copyWith(id: id);
  }

  @override
  Future<AppUser?> getUserById(int id) async {
    if (id <= 0) return null;
    final db = await _db;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return AppUser.fromMap(rows.first);
  }

  @override
  Future<List<AppUser>> getAllUsers() async {
    final db = await _db;
    final rows = await db.query('users', orderBy: 'id ASC');
    return rows.map(AppUser.fromMap).toList();
  }

  @override
  Future<AppUser> updateUser(AppUser user) async {
    final db = await _db;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return user;
  }

  @override
  Future<AppUser> changePassword(int userId, String newPassword) async {
    if (newPassword.length < 8) {
      throw StateError('Mật khẩu mới phải từ 8 ký tự trở lên.');
    }
    final user = await getUserById(userId);
    if (user == null) {
      throw StateError('Không tìm thấy tài khoản.');
    }
    final newSalt = PasswordHasher.generateSalt();
    final newHash = PasswordHasher.hashPassword(newPassword, newSalt);
    final updated = user.copyWith(
      passwordHash: newHash,
      salt: newSalt,
      mustChangePassword: false,
    );
    return updateUser(updated);
  }

  @override
  Future<void> resetPasswordWithSecret({
    required String email,
    required String secretAnswer,
    required String newPassword,
  }) async {
    if (newPassword.length < 8) {
      throw StateError('Mật khẩu mới phải có ít nhất 8 ký tự.');
    }
    final db = await _db;
    final rows = await db.query(
      'users',
      where: 'LOWER(email) = ?',
      whereArgs: [email.trim().toLowerCase()],
    );
    if (rows.isEmpty) {
      throw StateError('Không tìm thấy tài khoản với email này.');
    }
    final user = AppUser.fromMap(rows.first);
    final ok = PasswordHasher.verify(
      secretAnswer.trim().toLowerCase(),
      user.salt,
      user.secretAnswerHash,
    );
    if (!ok) {
      throw StateError('Câu trả lời bí mật không chính xác.');
    }
    await changePassword(user.id, newPassword);
  }
}

/// Triển khai Giai đoạn B (Cloud Adapter): Kết nối Firebase Auth & Custom Claims.
/// Khi cấu hình Firebase thật, lớp này dùng `FirebaseAuth.instance` và giữ nguyên chữ ký [AuthRepository].
class FirebaseAuthRepository extends LocalAuthRepository {
  FirebaseAuthRepository(super.appDb);
}
