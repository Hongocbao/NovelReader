import '../models/app_user.dart';
import '../models/chapter.dart';
import '../models/chapter_summary.dart';
import '../models/glossary_term.dart';
import '../models/notification_item.dart';
import '../models/novel.dart';

/// Giao diện trừu tượng cho kho lưu trữ Truyện & Chương.
abstract class NovelRepository {
  Future<List<Novel>> getAllNovels({bool includeDeleted = false});
  Future<List<Novel>> getNovelsByOwner(String ownerId);
  Future<List<Novel>> getPendingNovels();
  Future<Novel?> getNovelById(int novelId);
  Future<Novel> saveNovel(
    Novel novel, {
    String? requestId,
    List<({String title, String content})> chapters = const [],
  });
  Future<void> softDeleteNovel(int novelId, {AppUser? admin});
  Future<void> restoreNovel(int novelId, {AppUser? admin});
  Future<void> approveNovel({required int novelId, required AppUser admin, String note = 'Đạt tiêu chuẩn xuất bản'});
  Future<void> rejectNovel({required int novelId, required String reason, required AppUser admin});
  Future<void> setFeaturedStatus({required List<int> novelIds, required bool featured, required AppUser admin});
  Future<List<Chapter>> getChapters(int novelId);
  Future<void> saveChaptersOrder(int novelId, List<Chapter> orderedChapters);
  Future<Chapter> saveChapter(Chapter chapter, {String? requestId});
  Future<List<GlossaryTerm>> getGlossaryTerms(int novelId);
  Future<void> addGlossaryTerm(GlossaryTerm term);
  Future<void> deleteGlossaryTerm(int termId);
  Future<List<ChapterSummary>> getChapterSummaries(int novelId);
  Future<void> saveChapterSummary(ChapterSummary summary);
  Future<void> writeAuditLog({
    required AppUser admin,
    required String action,
    required String target,
    required String detail,
  });
  Future<void> createNotification(NotificationItem item);
}
