import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Tiện ích băm mật khẩu một chiều bằng SHA-256 kết hợp chuỗi muối (salt) ngẫu nhiên.
///
/// Đảm bảo không bao giờ lưu mật khẩu thô trong SQLite cục bộ (Giai đoạn A).
class PasswordHasher {
  PasswordHasher._();

  static final Random _random = Random.secure();

  /// Sinh chuỗi salt ngẫu nhiên dài [length] byte (mã hóa hex).
  static String generateSalt([int length = 16]) {
    final bytes = List<int>.generate(length, (_) => _random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Băm mật khẩu [password] cùng với [salt] bằng thuật toán SHA-256.
  static String hashPassword(String password, String salt) {
    final input = utf8.encode('$salt::$password::novelreader_v2');
    return sha256.convert(input).toString();
  }

  /// Kiểm tra mật khẩu người dùng nhập có khớp với [expectedHash] và [salt] hay không.
  static bool verify(String password, String salt, String expectedHash) {
    final actual = hashPassword(password, salt);
    return actual == expectedHash;
  }
}
