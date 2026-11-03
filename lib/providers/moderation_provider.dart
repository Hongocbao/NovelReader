import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../database/v2_database_store.dart';
import '../models/app_user.dart';
import '../models/audit_log.dart';
import '../models/notification_item.dart';
import '../models/quest.dart';
import '../models/report.dart';
import '../utils/role_guard.dart';

/// Quản lý Báo cáo vi phạm, Bộ lọc từ cấm, Sự kiện nhiệm vụ, Cấu hình hệ thống & Audit Log (Mục 6.5 - 6.7).
class ModerationProvider extends ChangeNotifier {
  final AppDatabase _appDb;

  List<ReportItem> _reports = [];
  List<String> _bannedWords = [];
  List<AuditLog> _auditLogs = [];
  List<Quest> _allQuests = [];
  Map<String, String> _appConfig = {};
  bool _isLoading = false;
  String? _error;

  ModerationProvider(this._appDb);

  List<ReportItem> get reports => _reports;
  List<String> get bannedWords => _bannedWords;
  List<AuditLog> get auditLogs => _auditLogs;
  List<Quest> get allQuests => _allQuests;
  Map<String, String> get appConfig => _appConfig;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isMaintenanceMode => _appConfig['maintenance_mode'] == 'true';
  String get maintenanceMessage =>
      _appConfig['maintenance_message'] ??
      'Hệ thống đang bảo trì nâng cấp định kỳ.';
  bool get isTtsEnabled => _appConfig['feature_tts'] != 'false';
  bool get isCommentsEnabled => _appConfig['feature_comments'] != 'false';
  bool get isRegistrationEnabled =>
      _appConfig['feature_registration'] != 'false';

  /// Tải toàn bộ dữ liệu kiểm duyệt, cấu hình, từ cấm và audit log.
  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final db = await _appDb.database;
      _reports = await V2DatabaseStore.getReports(db);
      _bannedWords = await V2DatabaseStore.getBannedWords(db);
      _auditLogs = await V2DatabaseStore.getAuditLogs(db);
      _allQuests = await V2DatabaseStore.getAllQuests(db);
      _appConfig = await V2DatabaseStore.getAppConfig(db);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Người dùng gửi báo cáo vi phạm (bình luận/truyện/chương).
  /// Nếu một bình luận bị báo cáo >= 3 lần, tự động ẩn bình luận đó.
  Future<void> submitReport({
    required AppUser reporter,
    required String targetType,
    required int targetId,
    required String targetSnapshot,
    required String reason,
  }) async {
    RoleGuard.requirePermission(reporter, AppPermission.interactAndGamify);
    final db = await _appDb.database;
    final report = ReportItem(
      reporterId: reporter.id,
      reporterName: reporter.displayName,
      targetType: targetType,
      targetId: targetId,
      targetSnapshot: targetSnapshot,
      reason: reason.trim(),
      createdAt: DateTime.now(),
    );
    await V2DatabaseStore.createReport(db, report);

    if (targetType == 'comment') {
      final count = await V2DatabaseStore.countReportsForTarget(
        db,
        targetType: 'comment',
        targetId: targetId,
      );
      if (count >= 3) {
        await V2DatabaseStore.hideComment(db, targetId);
      }
    }
    await loadAll();
  }

  /// Admin xử lý một báo cáo: `ignore` (bỏ qua), `hide_comment` (ẩn bình luận), `warn` (cảnh cáo).
  Future<void> resolveReport({
    required AppUser admin,
    required ReportItem report,
    required String actionType,
    String note = '',
  }) async {
    RoleGuard.requireAdmin(admin);
    final db = await _appDb.database;
    final newStatus = actionType == 'ignore' ? 'rejected' : 'resolved';
    await V2DatabaseStore.updateReport(
      db,
      ReportItem(
        id: report.id,
        reporterId: report.reporterId,
        reporterName: report.reporterName,
        targetType: report.targetType,
        targetId: report.targetId,
        targetSnapshot: report.targetSnapshot,
        reason: report.reason,
        status: newStatus,
        handledBy: admin.id,
        resolutionNote: note.trim(),
        createdAt: report.createdAt,
      ),
    );

    if (actionType == 'hide_comment' && report.targetType == 'comment') {
      await V2DatabaseStore.hideComment(db, report.targetId);
    } else if (actionType == 'warn') {
      await V2DatabaseStore.createNotification(
        db,
        NotificationItem(
          userId: report.reporterId,
          title: '⚠️ Nhắc nhở tiêu chuẩn cộng đồng',
          body:
              'Nội dung "${report.targetSnapshot}" đã bị báo cáo (${report.reason}). Ghi chú Admin: $note',
          kind: 'moderation',
          createdAt: DateTime.now(),
        ),
      );
    }

    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'RESOLVE_REPORT_${actionType.toUpperCase()}',
      target: '${report.targetType}#${report.targetId}',
      detail: 'Lý do báo cáo: ${report.reason} | Ghi chú: $note',
    );
    await loadAll();
  }

  /// Thêm từ cấm vào danh sách lọc tự động.
  Future<void> addBannedWords(AppUser admin, List<String> words) async {
    RoleGuard.requireAdmin(admin);
    final db = await _appDb.database;
    for (final raw in words) {
      final w = raw.trim().toLowerCase();
      if (w.isEmpty) continue;
      await V2DatabaseStore.addBannedWord(db, w);
    }
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'ADD_BANNED_WORDS',
      target: 'banned_words',
      detail: 'Đã thêm: ${words.join(", ")}',
    );
    await loadAll();
  }

  /// Xóa một từ cấm.
  Future<void> removeBannedWord(AppUser admin, String word) async {
    RoleGuard.requireAdmin(admin);
    final db = await _appDb.database;
    await V2DatabaseStore.removeBannedWord(db, word.trim().toLowerCase());
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'REMOVE_BANNED_WORD',
      target: word,
      detail: 'Đã xóa từ cấm "$word"',
    );
    await loadAll();
  }

  /// Admin tạo nhiệm vụ sự kiện mới.
  Future<void> createEventQuest({
    required AppUser admin,
    required String title,
    required String goalType,
    required int goalValue,
    required int reward,
    int durationDays = 14,
  }) async {
    RoleGuard.requireAdmin(admin);
    final db = await _appDb.database;
    final now = DateTime.now();
    final quest = Quest(
      id: 0,
      type: 'event',
      title: title.trim(),
      goalType: goalType,
      goalValue: goalValue,
      reward: reward,
      startsAt: now,
      endsAt: now.add(Duration(days: durationDays)),
      isActive: true,
    );
    await V2DatabaseStore.createQuest(db, quest);
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'CREATE_EVENT_QUEST',
      target: title.trim(),
      detail: 'Mục tiêu: $goalType=$goalValue, Thưởng: $reward Linh Thạch',
    );
    await loadAll();
  }

  /// Cập nhật một khóa cấu hình hệ thống (`maintenance_mode`, `feature_tts`...).
  Future<void> updateConfig({
    required AppUser admin,
    required String key,
    required String value,
  }) async {
    RoleGuard.requireAdmin(admin);
    final db = await _appDb.database;
    await V2DatabaseStore.setConfigValue(db, key, value);
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'UPDATE_CONFIG',
      target: key,
      detail: 'Giá trị mới: $value',
    );
    await loadAll();
  }
}
