import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_user.dart';
import 'auth_repository.dart';

/// Triển khai AuthRepository bằng Supabase Auth (auth.users) và bảng `profiles`.
class SupabaseAuthRepository implements AuthRepository {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<AppUser> login(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    final res = await _client.auth.signInWithPassword(
      email: cleanEmail,
      password: password,
    );

    final authUser = res.user;
    if (authUser == null) {
      throw StateError('Đăng nhập thất bại.');
    }

    var profileRes = await _client
        .from('profiles')
        .select()
        .eq('id', authUser.id)
        .maybeSingle();

    if (profileRes == null) {
      final newProfile = {
        'id': authUser.id,
        'email': cleanEmail,
        'display_name': authUser.userMetadata?['display_name'] ?? cleanEmail.split('@').first,
        'role': 'user',
        'is_author': 0,
        'status': 'active',
        'last_active_at': DateTime.now().millisecondsSinceEpoch,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      };
      await _client.from('profiles').insert(newProfile);
      profileRes = newProfile;
    }

    final user = AppUser.fromMap(profileRes);
    if (user.isBanned) {
      await _client.auth.signOut();
      final reason = user.banReason?.isNotEmpty == true
          ? ' Lý do: ${user.banReason}'
          : '';
      throw StateError('Tài khoản của bạn đã bị khóa.$reason');
    }

    await _client.from('profiles').update({
      'last_active_at': DateTime.now().millisecondsSinceEpoch,
    }).eq('id', user.id);

    return user;
  }

  @override
  Future<AppUser> register({
    required String email,
    required String displayName,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final res = await _client.auth.signUp(
      email: cleanEmail,
      password: password,
      data: {'display_name': displayName.trim()},
    );

    final authUser = res.user;
    if (authUser == null) {
      throw StateError('Đăng ký thất bại.');
    }

    // Sau khi signUp, đăng nhập ngay để thiết lập JWT session hợp lệ
    try {
      await _client.auth.signInWithPassword(
        email: cleanEmail,
        password: password,
      );
    } catch (_) {}

    final now = DateTime.now().millisecondsSinceEpoch;
    final profileMap = {
      'id': authUser.id,
      'email': cleanEmail,
      'display_name': displayName.trim(),
      'role': 'user',
      'is_author': 0,
      'status': 'active',
      'linh_thach': 150,
      'streak': 1,
      'has_streak_shield': 0,
      'pinned_achievements': '',
      'unlocked_items': 'default',
      'last_active_at': now,
      'created_at': now,
    };

    // Thử cập nhật profile (nếu trigger DB chưa kịp chạy hoặc cần bổ sung tên hiển thị)
    try {
      await _client.from('profiles').upsert(profileMap);
    } catch (_) {}

    final existing = await getUserById(authUser.id);
    return existing ?? AppUser.fromMap(profileMap);
  }

  @override
  Future<AppUser?> getUserById(String id) async {
    if (id.isEmpty) return null;
    final res = await _client.from('profiles').select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return AppUser.fromMap(res);
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final session = _client.auth.currentSession;
    if (session == null) return null;
    return getUserById(session.user.id);
  }

  @override
  Future<List<AppUser>> getAllUsers() async {
    final res = await _client.from('profiles').select().order('created_at', ascending: false);
    return (res as List).map((r) => AppUser.fromMap(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<AppUser> updateUser(AppUser user) async {
    await _client.from('profiles').update(user.toMap()).eq('id', user.id);
    return user;
  }

  @override
  Future<void> changePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  @override
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email.trim().toLowerCase());
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
