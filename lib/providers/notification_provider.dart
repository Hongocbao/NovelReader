import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import '../database/v2_database_store.dart';
import '../models/announcement.dart';
import '../models/app_user.dart';
import '../models/chapter_summary.dart';
import '../models/notification_item.dart';
import '../utils/constants.dart';
import '../utils/role_guard.dart';

bool get _isSupabaseReady {
  try {
    Supabase.instance.client;
    return SupabaseConfig.anonKey != 'YOUR_SUPABASE_ANON_KEY' &&
        SupabaseConfig.anonKey.trim().isNotEmpty;
  } catch (_) {
    return false;
  }
}

/// Quản lý Trung tâm Thông báo, Tin nhắn Cộng đồng, Thông báo hệ thống (Announcements) và Yêu cầu truyện mới.
class NotificationProvider extends ChangeNotifier {
  final AppDatabase _appDb;

  List<NotificationItem> _notifications = [];
  List<Announcement> _announcements = [];
  List<NovelRequestItem> _requests = [];
  bool _isLoading = false;
  String? _error;

  NotificationProvider(this._appDb);

  List<NotificationItem> get notifications => _notifications;
  List<Announcement> get announcements => _announcements;
  List<NovelRequestItem> get requests => _requests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Tải thông báo, bảng tin hệ thống và danh sách yêu cầu truyện (hợp nhất Cloud Supabase + SQLite).
  Future<void> loadAll(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final db = await _appDb.database;

      // 1. Hợp nhất Thông báo cá nhân & thông báo chung
      final cloudNotifs = await V2DatabaseStore.getNotifications(db, userId);
      final localNotifRows = await db.query(
        'thong_bao',
        where: 'user_id = ? OR user_id = ? OR user_id = ?',
        whereArgs: [userId, '', '1'],
        orderBy: 'created_at DESC',
      );
      final localNotifs = localNotifRows.map(NotificationItem.fromMap).toList();
      final seenNotifs = <String>{};
      final mergedNotifs = <NotificationItem>[];
      for (final n in [...cloudNotifs, ...localNotifs]) {
        final key = '${n.title}|${n.body}';
        if (seenNotifs.add(key)) mergedNotifs.add(n);
      }
      mergedNotifs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _notifications = mergedNotifs;

      // 2. Hợp nhất Bảng tin Hệ thống (Announcements)
      final cloudAnn = await V2DatabaseStore.getAnnouncements(db);
      final localAnnRows = await db.query(
        'thong_bao_chung',
        orderBy: 'pinned DESC, created_at DESC',
      );
      final localAnn = localAnnRows.map(Announcement.fromMap).toList();
      final seenAnn = <String>{};
      final mergedAnn = <Announcement>[];
      for (final a in [...cloudAnn, ...localAnn]) {
        final key = '${a.title}|${a.body}';
        if (seenAnn.add(key)) mergedAnn.add(a);
      }
      _announcements = mergedAnn;

      // 3. Hợp nhất Danh sách Yêu cầu Truyện (Novel Requests)
      final cloudReqs = await V2DatabaseStore.getNovelRequests(db);
      final localReqRows = await db.query(
        'yeu_cau_truyen',
        orderBy: 'votes DESC, created_at DESC',
      );
      final localReqs = localReqRows.map(NovelRequestItem.fromMap).toList();
      final seenReqs = <String>{};
      final mergedReqs = <NovelRequestItem>[];
      for (final r in [...cloudReqs, ...localReqs]) {
        final key = '${r.title.toLowerCase()}|${r.userName.toLowerCase()}';
        if (seenReqs.add(key)) mergedReqs.add(r);
      }
      mergedReqs.sort((a, b) => b.votes.compareTo(a.votes));
      _requests = mergedReqs;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Đánh dấu đã đọc một thông báo.
  Future<void> markAsRead(int notificationId, String userId) async {
    final db = await _appDb.database;
    await V2DatabaseStore.markNotificationRead(
      db,
      notificationId: notificationId,
      userId: userId,
    );
    await loadAll(userId);
  }

  /// Đánh dấu đã đọc toàn bộ thông báo của người dùng.
  Future<void> markAllAsRead(String userId) async {
    final db = await _appDb.database;
    await V2DatabaseStore.markAllNotificationsRead(db, userId: userId);
    await loadAll(userId);
  }

  /// Gửi thông báo / tin nhắn thực tế tới người nhận (hoặc toàn cộng đồng) và lưu biên nhận cho người gửi.
  Future<void> sendCommunityNotification({
    required AppUser sender,
    required String recipientUserId,
    required String recipientLabel,
    required String title,
    required String body,
  }) async {
    RoleGuard.requirePermission(sender, AppPermission.interactAndGamify);
    final db = await _appDb.database;
    final now = DateTime.now();

    final incomingItem = NotificationItem(
      userId: recipientUserId.trim(),
      title: '📩 Từ ${sender.displayName}: ${title.trim()}',
      body: body.trim(),
      kind: 'community_msg',
      createdAt: now,
    );

    // Ghi lên Cloud Supabase để người nhận thấy ngay khi mở Hộp thư
    if (_isSupabaseReady) {
      try {
        await Supabase.instance.client
            .from('thong_bao')
            .insert(incomingItem.toMap()..remove('id'));
      } catch (_) {}
    }
    // Ghi đồng thời vào SQLite cục bộ
    await db.insert('thong_bao', incomingItem.toMap()..remove('id'));

    // Nếu người gửi gửi cho người khác, tạo thêm 1 biên nhận xác nhận trong hộp thư người gửi
    if (recipientUserId.trim() != sender.id) {
      final receiptItem = NotificationItem(
        userId: sender.id,
        title: '✅ [Đã gửi tới $recipientLabel] ${title.trim()}',
        body:
            'Nội dung đã chuyển thành công tới hộp thư của $recipientLabel: "${body.trim()}"',
        kind: 'sent_receipt',
        isRead: true,
        createdAt: now,
      );
      if (_isSupabaseReady) {
        try {
          await Supabase.instance.client
              .from('thong_bao')
              .insert(receiptItem.toMap()..remove('id'));
        } catch (_) {}
      }
      await db.insert('thong_bao', receiptItem.toMap()..remove('id'));
    }

    await loadAll(sender.id);
  }

  /// Độc giả gửi yêu cầu truyện mới («Mình muốn đọc truyện X») kèm thông báo xác nhận.
  Future<void> submitNovelRequest({
    required AppUser user,
    required String title,
    String authorHint = '',
    String description = '',
  }) async {
    RoleGuard.requirePermission(user, AppPermission.interactAndGamify);
    final db = await _appDb.database;
    final now = DateTime.now();
    final item = NovelRequestItem(
      userId: user.id,
      userName: user.displayName,
      title: title.trim(),
      authorHint: authorHint.trim(),
      description: description.trim(),
      votes: 1,
      createdAt: now,
    );
    await V2DatabaseStore.submitNovelRequest(db, item);
    // Đảm bảo bản ghi cục bộ luôn có votes >= 1 để hiển thị ngay lập tức
    await db.insert(
      'yeu_cau_truyen',
      item.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Tạo thông báo xác nhận cho người gửi & cộng đồng
    final confirmNotif = NotificationItem(
      userId: user.id,
      title: '📚 Đã gửi yêu cầu truyện: "${title.trim()}"',
      body:
          'Đề xuất của bạn đã được đăng lên Bảng Yêu Cầu Truyện Cộng Đồng và gửi tới các Tác giả / Admin.',
      kind: 'system',
      createdAt: now,
    );
    await db.insert('thong_bao', confirmNotif.toMap()..remove('id'));
    if (_isSupabaseReady) {
      try {
        await Supabase.instance.client
            .from('thong_bao')
            .insert(confirmNotif.toMap()..remove('id'));
      } catch (_) {}
    }

    await loadAll(user.id);
  }

  /// Bình chọn (+1 vote) cho một yêu cầu truyện.
  Future<void> voteNovelRequest(int requestId, String userId) async {
    final db = await _appDb.database;
    await V2DatabaseStore.voteNovelRequest(
      db,
      requestId: requestId,
      userId: userId,
    );
    await db.rawUpdate(
      'UPDATE yeu_cau_truyen SET votes = votes + 1 WHERE id = ?',
      [requestId],
    );
    await loadAll(userId);
  }

  /// Admin phát hành thông báo hệ thống mới.
  Future<void> publishAnnouncement({
    required AppUser admin,
    required String title,
    required String body,
    String audience = 'all',
    bool pinned = false,
  }) async {
    RoleGuard.requireAdmin(admin);
    final db = await _appDb.database;
    final now = DateTime.now();
    final ann = Announcement(
      title: title.trim(),
      body: body.trim(),
      audience: audience,
      pinned: pinned,
      createdBy: admin.id,
      createdAt: now,
    );
    await V2DatabaseStore.createAnnouncement(db, ann);
    await db.insert('thong_bao_chung', ann.toMap()..remove('id'));
    final notif = NotificationItem(
      userId: '',
      title: '📢 $title',
      body: body.trim(),
      kind: 'system',
      createdAt: now,
    );
    await V2DatabaseStore.createNotification(db, notif);
    await db.insert('thong_bao', notif.toMap()..remove('id'));
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'CREATE_ANNOUNCEMENT',
      target: title.trim(),
      detail: 'Đối tượng: $audience, Ghim: $pinned',
    );
    await loadAll(admin.id);
  }

  /// Admin xóa một thông báo hệ thống.
  Future<void> deleteAnnouncement(AppUser admin, int id) async {
    RoleGuard.requireAdmin(admin);
    final db = await _appDb.database;
    await V2DatabaseStore.deleteAnnouncement(db, id);
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'DELETE_ANNOUNCEMENT',
      target: 'announcement#$id',
      detail: 'Đã xóa thông báo hệ thống #$id',
    );
    await loadAll(admin.id);
  }
}
