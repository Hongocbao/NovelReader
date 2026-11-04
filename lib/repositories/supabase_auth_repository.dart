import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_user.dart';
import 'auth_repository.dart';

/// Triển khai AuthRepository bằng Supabase Auth (auth.users) và bảng `ho_so`.
class SupabaseAuthRepository
    implements
        AuthRepository,
        AtomicEconomyRepository,
        ProfileFieldsRepository {
  SupabaseAuthRepository({SupabaseClient? client}) : _clientOverride = client;
  final SupabaseClient? _clientOverride;
  SupabaseClient get _client => _clientOverride ?? Supabase.instance.client;

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

    Map<String, dynamic>? profileRes;
    try {
      profileRes = await _client
          .from('ho_so')
          .select()
          .eq('id', authUser.id)
          .maybeSingle();

      if (profileRes == null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final newProfile = <String, dynamic>{
          'id': authUser.id,
          'email': cleanEmail,
          'display_name':
              authUser.userMetadata?['display_name'] ??
              cleanEmail.split('@').first,
          'role': 'user',
          'is_author': 0,
          'status': 'active',
          'linh_thach': 150,
          'streak': 0,
          'has_streak_shield': 0,
          'pinned_achievements': '',
          'unlocked_items': 'default',
          'last_active_at': now,
          'created_at': now,
        };
        await _client.from('ho_so').insert(newProfile);
        profileRes = newProfile;
      }
    } catch (_) {
      throw AuthenticatedProfileUnavailable(authUser.id);
    }
    late final AppUser user;
    try {
      user = AppUser.fromMap(profileRes);
    } catch (_) {
      throw AuthenticatedProfileUnavailable(authUser.id);
    }
    if (user.isBanned) {
      await _client.auth.signOut();
      final reason = user.banReason?.isNotEmpty == true
          ? ' Lý do: ${user.banReason}'
          : '';
      throw StateError('Tài khoản của bạn đã bị khóa.$reason');
    }

    try {
      await _client
          .from('ho_so')
          .update({'last_active_at': DateTime.now().millisecondsSinceEpoch})
          .eq('id', user.id);
    } catch (_) {
      // Cập nhật mốc hoạt động không được làm mất phiên vừa đăng nhập.
    }

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

    // Supabase có thể yêu cầu xác nhận email trước khi cấp session. Không được
    // giả lập trạng thái đã đăng nhập khi chưa có JWT; người dùng sẽ đăng nhập
    // sau khi bấm liên kết xác nhận, lúc đó login() tạo hồ sơ nếu còn thiếu.
    if (res.session == null) {
      throw StateError(
        'Tài khoản đã được tạo. Hãy xác nhận email trong hộp thư rồi đăng nhập.',
      );
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final profileMap = {
      'id': authUser.id,
      'email': cleanEmail,
      'display_name': displayName.trim(),
      'role': 'user',
      'is_author': 0,
      'status': 'active',
      'linh_thach': 150,
      'streak': 0,
      'has_streak_shield': 0,
      'pinned_achievements': '',
      'unlocked_items': 'default',
      'last_active_at': now,
      'created_at': now,
    };

    try {
      // Nếu trigger đã tạo hồ sơ nhưng upsert không thành công, thử lấy lại.
      try {
        await _client.from('ho_so').upsert(profileMap);
      } catch (_) {
        final existing = await getUserById(authUser.id);
        if (existing != null) return existing;
        rethrow;
      }

      final existing = await getUserById(authUser.id);
      return existing ?? AppUser.fromMap(profileMap);
    } catch (_) {
      throw AuthenticatedProfileUnavailable(authUser.id);
    }
  }

  @override
  Future<AppUser?> getUserById(String id) async {
    if (id.isEmpty) return null;
    final res = await _client.from('ho_so').select().eq('id', id).maybeSingle();
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
    final res = await _client
        .from('ho_so')
        .select()
        .order('created_at', ascending: false);
    return (res as List)
        .map((r) => AppUser.fromMap(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AppUser> updateUser(AppUser user) async {
    await _client.from('ho_so').update(user.toMap()).eq('id', user.id);
    return user;
  }

  @override
  Future<AppUser> updateProfileFields(AppUser user) async {
    final row = await _client
        .from('ho_so')
        .update({
          'display_name': user.displayName,
          'avatar': user.avatar,
          'avatar_frame': user.avatarFrame,
          'pinned_achievements': user.pinnedAchievements.join(','),
        })
        .eq('id', user.id)
        .select()
        .single();
    return AppUser.fromMap(row);
  }

  @override
  Future<EconomyReceipt?> purchaseShopItem(String itemKey, int cost) async {
    final owner = _economyOwner();
    final result = await _client.rpc(
      'purchase_shop_item',
      params: {'p_item_key': itemKey, 'p_cost': cost},
    );
    if (result is! Map || result['success'] != true) return null;
    return _confirmedReceipt(owner, result, unlockedItem: itemKey);
  }

  @override
  Future<EconomyReceipt?> buyStreakShield() async {
    final owner = _economyOwner();
    final result = await _client.rpc('buy_streak_shield');
    if (result is! Map || result['success'] != true) return null;
    return _confirmedReceipt(owner, result, hasStreakShield: true);
  }

  @override
  Future<EconomyReceipt?> claimQuestReward(int questId) async {
    final owner = _economyOwner();
    final result = await _client.rpc(
      'claim_quest_reward',
      params: {'p_quest_id': questId},
    );
    if (result is! Map || result['claimed'] != true) return null;
    return _confirmedReceipt(owner, result);
  }

  String _economyOwner() {
    final owner = _client.auth.currentUser?.id;
    if (owner == null) {
      throw StateError('Vui lòng đăng nhập trước khi giao dịch.');
    }
    return owner;
  }

  EconomyReceipt _confirmedReceipt(
    String owner,
    Map result, {
    String? unlockedItem,
    bool hasStreakShield = false,
  }) {
    // The RPC already committed. Profile synchronization is a separate read;
    // it must not block this receipt or change a successful buy into an error.
    return EconomyReceipt(
      userId: owner,
      balance: result['balance'] is num
          ? (result['balance'] as num).toInt()
          : null,
      reward: result['reward'] is num ? (result['reward'] as num).toInt() : 0,
      unlockedItem: unlockedItem,
      hasStreakShield: hasStreakShield,
    );
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
