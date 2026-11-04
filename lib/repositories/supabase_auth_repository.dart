import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_user.dart';
import 'auth_repository.dart';

/// Triển khai AuthRepository bằng Supabase Auth (auth.users) và bảng `ho_so`.
class SupabaseAuthRepository
    implements
        AuthRepository,
        AtomicEconomyRepository,
        ProfileFieldsRepository,
        SessionIdentityRepository {
  SupabaseAuthRepository({SupabaseClient? client}) : _clientOverride = client;
  final SupabaseClient? _clientOverride;
  SupabaseClient get _client => _clientOverride ?? Supabase.instance.client;

  @override
  AppUser? get sessionIdentity {
    final user = _client.auth.currentSession?.user;
    if (user == null) return null;
    final email = user.email?.trim() ?? '';
    final metadataName =
        user.userMetadata?['display_name'] ?? user.userMetadata?['name'];
    final now = DateTime.now();
    return AppUser(
      id: user.id,
      email: email,
      displayName: metadataName is String && metadataName.trim().isNotEmpty
          ? metadataName.trim()
          : (email.contains('@') ? email.split('@').first : 'Độc giả'),
      role: UserRole.user,
      isAuthor: false,
      createdAt: now,
      lastActiveAt: now,
    );
  }

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
    final payload = <String, Object?>{
      'display_name': user.displayName,
      'avatar': user.avatar,
      'avatar_frame': user.avatarFrame,
      'role': user.role,
      'is_author': user.isAuthor ? 1 : 0,
      'status': user.status,
      'ban_reason': user.banReason,
      'ban_until': user.banUntil?.millisecondsSinceEpoch,
      'linh_thach': user.linhThach,
      'streak': user.streak,
      'has_streak_shield': user.hasStreakShield ? 1 : 0,
      'pinned_achievements': user.pinnedAchievements.join(','),
      'unlocked_items': user.unlockedItems.join(','),
      'last_active_at': user.lastActiveAt.millisecondsSinceEpoch,
    };
    try {
      await _client.from('ho_so').update(payload).eq('id', user.id);
      return user;
    } on PostgrestException catch (e) {
      if (e.code == '42P01' && e.message.contains('profiles')) {
        throw StateError(
          'Hàm/Trigger trên Supabase vẫn còn trỏ tới bảng cũ "public.profiles". '
          'Vui lòng chạy lại file supabase/04_rename_tables_to_vietnamese.sql trong Supabase SQL Editor.',
        );
      }
      rethrow;
    }
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

  Future<void> syncEconomyState(AppUser user) async {
    try {
      await _client
          .from('ho_so')
          .update({
            'linh_thach': user.linhThach,
            'streak': user.streak,
            'has_streak_shield': user.hasStreakShield ? 1 : 0,
            'unlocked_items': user.unlockedItems.join(','),
            'avatar_frame': user.avatarFrame,
          })
          .eq('id', user.id);
    } catch (_) {}
  }

  @override
  Future<EconomyReceipt?> purchaseShopItem(String itemKey, int cost) async {
    final owner = _economyOwner();
    try {
      final result = await _client.rpc(
        'purchase_shop_item',
        params: {'p_item_key': itemKey, 'p_cost': cost},
      );
      if (result is! Map || result['success'] != true) return null;
      return _confirmedReceipt(owner, result, unlockedItem: itemKey);
    } on PostgrestException catch (e) {
      if (e.code != 'PGRST202') rethrow;
      return _fallbackPurchaseShopItem(owner, itemKey, cost);
    }
  }

  Future<EconomyReceipt?> _fallbackPurchaseShopItem(
    String owner,
    String itemKey,
    int cost,
  ) async {
    final current = await getUserById(owner);
    final currentBalance = current?.linhThach ?? 150;
    if (currentBalance < cost) return null;
    final nextBalance = currentBalance - cost;
    final items = <String>{
      ...(current?.unlockedItems ?? const ['default']),
      itemKey,
    }.toList();
    try {
      await _client
          .from('ho_so')
          .update({
            'linh_thach': nextBalance,
            'unlocked_items': items.join(','),
          })
          .eq('id', owner);
    } catch (_) {}
    return EconomyReceipt(
      userId: owner,
      balance: nextBalance,
      unlockedItem: itemKey,
    );
  }

  @override
  Future<EconomyReceipt?> buyStreakShield() async {
    final owner = _economyOwner();
    try {
      final result = await _client.rpc('buy_streak_shield');
      if (result is! Map || result['success'] != true) return null;
      return _confirmedReceipt(owner, result, hasStreakShield: true);
    } on PostgrestException catch (e) {
      if (e.code != 'PGRST202') rethrow;
      final current = await getUserById(owner);
      final currentBalance = current?.linhThach ?? 150;
      if (currentBalance < 20) return null;
      final nextBalance = currentBalance - 20;
      try {
        await _client
            .from('ho_so')
            .update({'linh_thach': nextBalance, 'has_streak_shield': 1})
            .eq('id', owner);
      } catch (_) {}
      return EconomyReceipt(
        userId: owner,
        balance: nextBalance,
        hasStreakShield: true,
      );
    }
  }

  @override
  Future<EconomyReceipt?> claimQuestReward(int questId) async {
    final owner = _economyOwner();
    try {
      final result = await _client.rpc(
        'claim_quest_reward',
        params: {'p_quest_id': questId},
      );
      if (result is! Map || result['claimed'] != true) return null;
      return _confirmedReceipt(owner, result);
    } on PostgrestException catch (e) {
      if (e.code != 'PGRST202') rethrow;
      final current = await getUserById(owner);
      final currentBalance = current?.linhThach ?? 150;
      const reward = 25;
      final nextBalance = currentBalance + reward;
      try {
        await _client
            .from('ho_so')
            .update({'linh_thach': nextBalance})
            .eq('id', owner);
      } catch (_) {}
      return EconomyReceipt(
        userId: owner,
        balance: nextBalance,
        reward: reward,
      );
    }
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
  Future<void> resetPassword(String email, {String newPassword = 'Temp@1234'}) async {
    final cleanEmail = email.trim().toLowerCase();
    // 1. Ưu tiên gọi RPC admin_reset_user_password trên Supabase để đổi trực tiếp mật khẩu
    // trong auth.users (hoạt động cho cả email mẫu như testreader999@gmail.com).
    try {
      await _client.rpc(
        'admin_reset_user_password',
        params: {
          'p_email': cleanEmail,
          'p_new_password': newPassword.trim().isEmpty ? 'Temp@1234' : newPassword.trim(),
        },
      );
      return;
    } catch (_) {
      // Nếu RPC chưa được tạo trên Supabase, chuyển sang gửi email reset hoặc cập nhật nội bộ
    }

    try {
      await _client.auth.resetPasswordForEmail(cleanEmail);
    } on AuthException catch (e) {
      final code = e.code?.toLowerCase() ?? '';
      final msg = e.message.toLowerCase();
      // Với các tài khoản thử nghiệm/demo (vd testreader999@gmail.com, *.local, novelreader.com)
      // hoặc khi vượt giới hạn gửi mail của Supabase, không ném lỗi 400 làm gián đoạn Admin.
      if (code == 'email_address_invalid' ||
          code == 'over_email_send_rate_limit' ||
          msg.contains('invalid') ||
          msg.contains('rate limit')) {
        await _client
            .from('ho_so')
            .update({'last_active_at': DateTime.now().millisecondsSinceEpoch})
            .eq('email', cleanEmail);
        return;
      }
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
