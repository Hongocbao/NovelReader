import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../database/v2_database_store.dart';
import '../models/app_user.dart';
import '../models/chapter.dart';
import '../models/chapter_summary.dart';
import '../models/glossary_term.dart';
import '../models/notification_item.dart';
import '../models/novel.dart';
import '../repositories/novel_repository.dart';
import '../utils/role_guard.dart';

/// Quản lý CRUD Truyện & Chương, Hàng chờ duyệt, Thuật ngữ và Tóm tắt chương (Mục 6.2 & 6.3).
class AdminNovelProvider extends ChangeNotifier {
  final AppDatabase _appDb;
  final NovelRepository _novelRepo;

  List<Novel> _allNovels = [];
  List<Novel> _pendingNovels = [];
  bool _isLoading = false;
  String? _error;

  AdminNovelProvider(this._appDb, this._novelRepo);

  List<Novel> get allNovels => _allNovels;
  List<Novel> get pendingNovels => _pendingNovels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Tải danh sách toàn bộ truyện (kể cả chờ duyệt/đã xóa mềm) và hàng chờ duyệt.
  Future<void> loadNovels({bool includeDeleted = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _allNovels = await _novelRepo.getAllNovels(
        includeDeleted: includeDeleted,
      );
      _pendingNovels = await _novelRepo.getPendingNovels();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Lấy danh sách truyện do một Tác giả sở hữu.
  Future<List<Novel>> getAuthorNovels(int ownerId) =>
      _novelRepo.getNovelsByOwner(ownerId);

  /// Tạo mới hoặc cập nhật thông tin một bộ truyện.
  Future<Novel> saveNovel({
    required AppUser actor,
    required Novel novel,
  }) async {
    RoleGuard.requireAuthorOrAdmin(actor);
    final db = await _appDb.database;
    var toSave = novel;
    if (novel.id <= 0) {
      final maxId = Sqflite.firstIntValue(
            await db.rawQuery('SELECT MAX(id) FROM novels'),
          ) ??
          100;
      toSave = novel.copyWith(
        id: maxId + 1,
        ownerId: actor.id,
        moderationStatus: actor.isAdmin
            ? ModerationStatus.approved
            : ModerationStatus.pending,
        updatedAt: DateTime.now(),
      );
    }
    final saved = await _novelRepo.saveNovel(toSave);
    if (actor.isAdmin) {
      await V2DatabaseStore.writeAuditLog(
        db,
        admin: actor,
        action: novel.id <= 0 ? 'CREATE_NOVEL' : 'UPDATE_NOVEL',
        target: 'novel#${saved.id} (${saved.title})',
        detail: 'Trạng thái duyệt: ${saved.moderationStatus}',
      );
    }
    await loadNovels();
    return saved;
  }

  /// Duyệt một hoặc nhiều truyện trong hàng chờ duyệt.
  Future<void> approveNovels({
    required AppUser admin,
    required List<int> novelIds,
    String note = 'Đạt tiêu chuẩn xuất bản',
  }) async {
    RoleGuard.requireAdmin(admin);
    final db = await _appDb.database;
    for (final id in novelIds) {
      final novel = await _appDb.getNovel(id);
      if (novel == null) continue;
      await db.update(
        'novels',
        {
          'moderation_status': ModerationStatus.approved,
          'rejection_reason': null,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      await V2DatabaseStore.createNotification(
        db,
        NotificationItem(
          userId: novel.ownerId,
          title: '✅ Truyện "${novel.title}" đã được duyệt!',
          body: 'Tác phẩm của bạn đã lên sóng trang chủ. Ghi chú: $note',
          kind: 'moderation',
          createdAt: DateTime.now(),
        ),
      );
      await V2DatabaseStore.writeAuditLog(
        db,
        admin: admin,
        action: 'APPROVE_NOVEL',
        target: 'novel#$id (${novel.title})',
        detail: note,
      );
    }
    await loadNovels();
  }

  /// Từ chối duyệt truyện kèm lý do bắt buộc.
  Future<void> rejectNovel({
    required AppUser admin,
    required int novelId,
    required String reason,
  }) async {
    RoleGuard.requireAdmin(admin);
    if (reason.trim().isEmpty) {
      throw StateError('Vui lòng nhập lý do từ chối duyệt truyện.');
    }
    final db = await _appDb.database;
    final novel = await _appDb.getNovel(novelId);
    await db.update(
      'novels',
      {
        'moderation_status': ModerationStatus.rejected,
        'rejection_reason': reason.trim(),
      },
      where: 'id = ?',
      whereArgs: [novelId],
    );
    if (novel != null) {
      await V2DatabaseStore.createNotification(
        db,
        NotificationItem(
          userId: novel.ownerId,
          title: '⚠️ Truyện "${novel.title}" cần chỉnh sửa thêm',
          body: 'Lý do từ chối: ${reason.trim()}',
          kind: 'moderation',
          createdAt: DateTime.now(),
        ),
      );
    }
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'REJECT_NOVEL',
      target: 'novel#$novelId',
      detail: 'Lý do: ${reason.trim()}',
    );
    await loadNovels();
  }

  /// Gắn hoặc gỡ nổi bật (Featured Banner) cho danh sách truyện.
  Future<void> setFeaturedStatus({
    required AppUser admin,
    required List<int> novelIds,
    required bool featured,
  }) async {
    RoleGuard.requireAdmin(admin);
    final db = await _appDb.database;
    for (var i = 0; i < novelIds.length; i++) {
      final id = novelIds[i];
      await db.update(
        'novels',
        {
          'is_featured': featured ? 1 : 0,
          'featured_order': featured ? i + 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: featured ? 'SET_FEATURED' : 'UNSET_FEATURED',
      target: 'novels:${novelIds.join(",")}',
      detail: 'Cập nhật trạng thái đề cử trang chủ',
    );
    await loadNovels();
  }

  /// Xóa mềm (Soft Delete) một bộ truyện.
  Future<void> softDeleteNovel(AppUser admin, int novelId) async {
    RoleGuard.requireAdmin(admin);
    final db = await _appDb.database;
    await _novelRepo.softDeleteNovel(novelId);
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'SOFT_DELETE_NOVEL',
      target: 'novel#$novelId',
      detail: 'Đã chuyển truyện vào thùng rác (khôi phục trong 30 ngày)',
    );
    await loadNovels(includeDeleted: true);
  }

  /// Khôi phục truyện đã xóa mềm.
  Future<void> restoreNovel(AppUser admin, int novelId) async {
    RoleGuard.requireAdmin(admin);
    final db = await _appDb.database;
    await _novelRepo.restoreNovel(novelId);
    await V2DatabaseStore.writeAuditLog(
      db,
      admin: admin,
      action: 'RESTORE_NOVEL',
      target: 'novel#$novelId',
      detail: 'Khôi phục truyện từ thùng rác',
    );
    await loadNovels(includeDeleted: true);
  }

  /// Đổi thứ tự danh sách chương bằng kéo thả.
  Future<void> reorderChapters(
    AppUser actor,
    int novelId,
    List<Chapter> ordered,
  ) async {
    RoleGuard.requireAuthorOrAdmin(actor);
    await _novelRepo.saveChaptersOrder(novelId, ordered);
    notifyListeners();
  }

  /// Lưu nội dung chương kèm bản tóm tắt chương (Recap).
  Future<Chapter> saveChapterWithSummary({
    required AppUser actor,
    required Chapter chapter,
    String? summary,
  }) async {
    RoleGuard.requireAuthorOrAdmin(actor);
    final db = await _appDb.database;
    var toSave = chapter;
    if (chapter.id <= 0) {
      final maxIdx = Sqflite.firstIntValue(
            await db.rawQuery(
              'SELECT MAX(chapter_index) FROM chapters WHERE novel_id = ?',
              [chapter.novelId],
            ),
          ) ??
          0;
      final nextIdx = maxIdx + 1;
      toSave = chapter.copyWith(
        id: chapter.novelId * 10000 + nextIdx,
        chapterIndex: nextIdx,
        isDownloaded: true,
      );
    }
    final saved = await _novelRepo.saveChapter(toSave);
    if (summary != null && summary.trim().isNotEmpty) {
      await db.insert(
        'chapter_summaries',
        ChapterSummary(
          chapterId: saved.id,
          novelId: saved.novelId,
          chapterIndex: saved.chapterIndex,
          summary: summary.trim(),
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await loadNovels();
    return saved;
  }

  /// Thêm thuật ngữ từ điển cho một bộ truyện.
  Future<void> addGlossaryTerm(AppUser actor, GlossaryTerm term) async {
    RoleGuard.requireAuthorOrAdmin(actor);
    final db = await _appDb.database;
    await db.insert('glossary_terms', term.toMap());
    notifyListeners();
  }

  /// Xóa thuật ngữ từ điển.
  Future<void> deleteGlossaryTerm(AppUser actor, int termId) async {
    RoleGuard.requireAuthorOrAdmin(actor);
    final db = await _appDb.database;
    await db.delete('glossary_terms', where: 'id = ?', whereArgs: [termId]);
    notifyListeners();
  }
}
