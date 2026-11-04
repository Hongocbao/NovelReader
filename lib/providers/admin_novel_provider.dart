import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../models/chapter.dart';
import '../models/chapter_summary.dart';
import '../models/glossary_term.dart';
import '../models/novel.dart';
import '../repositories/novel_repository.dart';
import '../utils/role_guard.dart';

/// Quản lý CRUD Truyện & Chương, Hàng chờ duyệt, Thuật ngữ và Tóm tắt chương (Mục 6.2 & 6.3).
/// Step 4: Mọi hàm của AdminNovelProvider (duyệt, từ chối, thông báo, audit log) gọi qua repository Supabase, không dùng sqflite.
class AdminNovelProvider extends ChangeNotifier {
  final NovelRepository _novelRepo;

  List<Novel> _allNovels = [];
  List<Novel> _pendingNovels = [];
  bool _isLoading = false;
  String? _error;
  String? _saveWarning;

  AdminNovelProvider(dynamic _, this._novelRepo);

  List<Novel> get allNovels => _allNovels;
  List<Novel> get pendingNovels => _pendingNovels;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get saveWarning => _saveWarning;

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
  Future<List<Novel>> getAuthorNovels(String ownerId) =>
      _novelRepo.getNovelsByOwner(ownerId);

  /// Tạo mới hoặc cập nhật thông tin một bộ truyện.
  Future<Novel> saveNovel({
    required AppUser actor,
    required Novel novel,
    String? requestId,
    List<({String title, String content})> chapters = const [],
  }) async {
    RoleGuard.requireAuthorOrAdmin(actor);
    _saveWarning = null;
    final parts = List<({String title, String content})>.unmodifiable(chapters);
    var toSave = novel;
    if (novel.id <= 0) {
      // Step 3: id do Postgres tự sinh, không tính MAX(id)+1 ở client
      toSave = novel.copyWith(
        ownerId: actor.id,
        moderationStatus: actor.isAdmin
            ? ModerationStatus.approved
            : ModerationStatus.pending,
        updatedAt: DateTime.now(),
      );
    }
    final saved = await _novelRepo.saveNovel(
      toSave,
      requestId: requestId,
      chapters: parts,
    );
    if (actor.isAdmin) {
      try {
        await _novelRepo.writeAuditLog(
          admin: actor,
          action: novel.id <= 0 ? 'CREATE_NOVEL' : 'UPDATE_NOVEL',
          target: 'novel#${saved.id} (${saved.title})',
          detail: 'Trạng thái duyệt: ${saved.moderationStatus}',
        );
      } catch (error) {
        // The primary write already succeeded; asking the user to submit again
        // would be misleading. Surface the secondary failure separately.
        _saveWarning = 'Tác phẩm đã lưu, nhưng chưa ghi được nhật ký quản trị.';
        debugPrint('Could not record novel audit log: $error');
      }
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
    for (final id in novelIds) {
      await _novelRepo.approveNovel(
        novelId: id,
        admin: admin,
        note: note,
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
    await _novelRepo.rejectNovel(
      novelId: novelId,
      reason: reason.trim(),
      admin: admin,
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
    await _novelRepo.setFeaturedStatus(
      novelIds: novelIds,
      featured: featured,
      admin: admin,
    );
    await loadNovels();
  }

  /// Xóa mềm (Soft Delete) một bộ truyện.
  Future<void> softDeleteNovel(AppUser admin, int novelId) async {
    RoleGuard.requireAdmin(admin);
    await _novelRepo.softDeleteNovel(novelId, admin: admin);
    await loadNovels(includeDeleted: true);
  }

  /// Khôi phục truyện đã xóa mềm.
  Future<void> restoreNovel(AppUser admin, int novelId) async {
    RoleGuard.requireAdmin(admin);
    await _novelRepo.restoreNovel(novelId, admin: admin);
    await loadNovels(includeDeleted: true);
  }

  Future<List<Chapter>> getChaptersForNovel(int novelId) => _novelRepo.getChapters(novelId);
  Future<List<GlossaryTerm>> getGlossaryForNovel(int novelId) => _novelRepo.getGlossaryTerms(novelId);

  /// Đổi thứ tự danh sách chương bằng kéo thả.
  Future<void> reorderChapters(
    AppUser actor,
    int novelId,
    List<Chapter> ordered,
  ) async {
    RoleGuard.requireAuthorOrAdmin(actor);
    await _novelRepo.saveChaptersOrder(novelId, List<Chapter>.unmodifiable(ordered));
    notifyListeners();
  }

  /// Lưu nội dung chương kèm bản tóm tắt chương (Recap).
  Future<Chapter> saveChapterWithSummary({
    required AppUser actor,
    required Chapter chapter,
    String? summary,
    String? requestId,
  }) async {
    RoleGuard.requireAuthorOrAdmin(actor);
    final saved = await _novelRepo.saveChapter(chapter, requestId: requestId);
    if (summary != null && summary.trim().isNotEmpty) {
      await _novelRepo.saveChapterSummary(
        ChapterSummary(
          chapterId: saved.id,
          novelId: saved.novelId,
          chapterIndex: saved.chapterIndex,
          summary: summary.trim(),
        ),
      );
    }
    await loadNovels();
    return saved;
  }

  /// Thêm thuật ngữ từ điển cho một bộ truyện.
  Future<void> addGlossaryTerm(AppUser actor, GlossaryTerm term) async {
    RoleGuard.requireAuthorOrAdmin(actor);
    await _novelRepo.addGlossaryTerm(term);
    notifyListeners();
  }

  /// Xóa thuật ngữ từ điển.
  Future<void> deleteGlossaryTerm(AppUser actor, int termId) async {
    RoleGuard.requireAuthorOrAdmin(actor);
    await _novelRepo.deleteGlossaryTerm(termId);
    notifyListeners();
  }
}
