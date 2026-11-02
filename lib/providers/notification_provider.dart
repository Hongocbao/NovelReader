import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../database/v2_database_store.dart';
import '../models/announcement.dart';
import '../models/app_user.dart';
import '../models/chapter_summary.dart';
import '../models/notification_item.dart';
import '../utils/role_guard.dart';

/// Quản lý Trung tâm Thông báo, Thông báo hệ thống (Announcements) và Yêu cầu truyện mới.
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

  /// Tải thông báo, bảng tin hệ thống và danh sách yêu cầu truyện.
  Future<void> loadAll(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final db = await _appDb.database;
      _notifications = await V2DatabaseStore.getNotifications(db, userId);
      _announcements = await V2DatabaseStore.getAnnouncements(db);
      final reqRows = await db.query(
        'novel_requests',
        orderBy: 'votes DESC, created_at DESC',
      );
      _requests = reqRows.map(NovelRequestItem.fromMap).toList();
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
    await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
    _notifications = await V2DatabaseStore.getNotifications(db, userId);
    notifyListeners();
  }

  /// Đánh dấu đã đọc toàn bộ thông báo của người dùng.
  Future<void> markAllAsRead(String userId) async {
    final db = await _appDb.database;
    await db.update(
      'notifications',
      {'is_read': 1},
      where: 'user_id = ? OR user_id = ?',
      whereArgs: [userId, ''],
    );
    _notifications = await V2DatabaseStore.getNotifications(db, userId);
    notifyListeners();
  }

  /// Độc giả gửi yêu cầu truyện mới («Mình muốn đọc truyện X»).
  Future<void> submitNovelRequest({
    required AppUser user,
    required String title,
    String authorHint = '',
    String description = '',
  }) async {
    RoleGuard.requirePermission(user, AppPermission.interactAndGamify);
    final db = await _appDb.database;
    final item = NovelRequestItem(
      userId: user.id,
      userName: user.displayName,
      title: title.trim(),
      authorHint: authorHint.trim(),
      description: description.trim(),
      votes: 1,
      createdAt: DateTime.now(),
    );
    await db.insert('novel_requests', item.toMap());
    await loadAll(user.id);
  }

  /// Bình chọn (+1 vote) cho một yêu cầu truyện.
  Future<void> voteNovelRequest(int requestId, String userId) async {
    final db = await _appDb.database;
    await db.rawUpdate(
      'UPDATE novel_requests SET votes = votes + 1 WHERE id = ?',
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
    await db.insert(
      'announcements',
      Announcement(
        title: title.trim(),
        body: body.trim(),
        audience: audience,
        pinned: pinned,
        createdBy: admin.id,
        createdAt: now,
      ).toMap(),
    );
    await V2DatabaseStore.createNotification(
      db,
      NotificationItem(
        userId: '',
        title: '📢 $title',
        body: body.trim(),
        kind: 'system',
        createdAt: now,
      ),
    );
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
    await db.delete('announcements', where: 'id = ?', whereArgs: [id]);
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
