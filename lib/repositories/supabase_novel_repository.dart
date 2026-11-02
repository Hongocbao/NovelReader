import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_user.dart';
import '../models/audit_log.dart';
import '../models/chapter.dart';
import '../models/chapter_summary.dart';
import '../models/glossary_term.dart';
import '../models/notification_item.dart';
import '../models/novel.dart';
import '../utils/format.dart';
import 'novel_repository.dart';

/// Triển khai NovelRepository hoàn toàn trên Supabase (Cloud Database).
class SupabaseNovelRepository implements NovelRepository {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<List<Novel>> getAllNovels({bool includeDeleted = false}) async {
    var query = _client.from('novels').select();
    if (!includeDeleted) {
      query = query.filter('deleted_at', 'is', null);
    }
    final res = await query.order('updated_at', ascending: false).order('id', ascending: false);
    return (res as List).map((r) => Novel.fromMap(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Novel>> getNovelsByOwner(String ownerId) async {
    final res = await _client
        .from('novels')
        .select()
        .eq('owner_id', ownerId)
        .filter('deleted_at', 'is', null)
        .order('updated_at', ascending: false);

    return (res as List).map((r) => Novel.fromMap(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Novel>> getPendingNovels() async {
    final res = await _client
        .from('novels')
        .select()
        .eq('moderation_status', ModerationStatus.pending)
        .filter('deleted_at', 'is', null)
        .order('updated_at', ascending: false);

    return (res as List).map((r) => Novel.fromMap(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<Novel?> getNovelById(int novelId) async {
    final res = await _client.from('novels').select().eq('id', novelId).maybeSingle();
    if (res == null) return null;
    return Novel.fromMap(res);
  }

  @override
  Future<Novel> saveNovel(Novel novel) async {
    final map = {
      ...novel.toMap(),
      'search_text': Format.normalize('${novel.title} ${novel.author}'),
    };

    if (novel.id > 0) {
      final existing = await _client.from('novels').select('id').eq('id', novel.id).maybeSingle();
      if (existing != null) {
        await _client.from('novels').update(map).eq('id', novel.id);
        return novel;
      }
    }

    // Step 3: id do Postgres tự sinh, không tính MAX(id)+1 ở client
    map.remove('id');
    final inserted = await _client.from('novels').insert(map).select().single();
    return Novel.fromMap(inserted);
  }

  @override
  Future<void> softDeleteNovel(int novelId, {AppUser? admin}) async {
    await _client.from('novels').update({
      'deleted_at': DateTime.now().millisecondsSinceEpoch,
    }).eq('id', novelId);

    if (admin != null) {
      await writeAuditLog(
        admin: admin,
        action: 'SOFT_DELETE_NOVEL',
        target: 'novel#$novelId',
        detail: 'Đã chuyển truyện vào thùng rác (khôi phục trong 30 ngày)',
      );
    }
  }

  @override
  Future<void> restoreNovel(int novelId, {AppUser? admin}) async {
    await _client.from('novels').update({
      'deleted_at': null,
    }).eq('id', novelId);

    if (admin != null) {
      await writeAuditLog(
        admin: admin,
        action: 'RESTORE_NOVEL',
        target: 'novel#$novelId',
        detail: 'Khôi phục truyện từ thùng rác',
      );
    }
  }

  @override
  Future<void> approveNovel({
    required int novelId,
    required AppUser admin,
    String note = 'Đạt tiêu chuẩn xuất bản',
  }) async {
    final novel = await getNovelById(novelId);
    if (novel == null) return;

    await _client.from('novels').update({
      'moderation_status': ModerationStatus.approved,
      'rejection_reason': null,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    }).eq('id', novelId);

    if (novel.ownerId.isNotEmpty) {
      await createNotification(
        NotificationItem(
          userId: novel.ownerId,
          title: '✅ Truyện "${novel.title}" đã được duyệt!',
          body: 'Tác phẩm của bạn đã lên sóng trang chủ. Ghi chú: $note',
          kind: 'moderation',
          createdAt: DateTime.now(),
        ),
      );
    }

    await writeAuditLog(
      admin: admin,
      action: 'APPROVE_NOVEL',
      target: 'novel#$novelId (${novel.title})',
      detail: note,
    );
  }

  @override
  Future<void> rejectNovel({
    required int novelId,
    required String reason,
    required AppUser admin,
  }) async {
    final novel = await getNovelById(novelId);

    await _client.from('novels').update({
      'moderation_status': ModerationStatus.rejected,
      'rejection_reason': reason.trim(),
    }).eq('id', novelId);

    if (novel != null && novel.ownerId.isNotEmpty) {
      await createNotification(
        NotificationItem(
          userId: novel.ownerId,
          title: '⚠️ Truyện "${novel.title}" cần chỉnh sửa thêm',
          body: 'Lý do từ chối: ${reason.trim()}',
          kind: 'moderation',
          createdAt: DateTime.now(),
        ),
      );
    }

    await writeAuditLog(
      admin: admin,
      action: 'REJECT_NOVEL',
      target: 'novel#$novelId',
      detail: 'Lý do: ${reason.trim()}',
    );
  }

  @override
  Future<void> setFeaturedStatus({
    required List<int> novelIds,
    required bool featured,
    required AppUser admin,
  }) async {
    for (var i = 0; i < novelIds.length; i++) {
      final id = novelIds[i];
      await _client.from('novels').update({
        'is_featured': featured ? 1 : 0,
        'featured_order': featured ? i + 1 : 0,
      }).eq('id', id);
    }

    await writeAuditLog(
      admin: admin,
      action: featured ? 'SET_FEATURED' : 'UNSET_FEATURED',
      target: 'novels:${novelIds.join(",")}',
      detail: 'Cập nhật trạng thái đề cử trang chủ',
    );
  }

  @override
  Future<List<Chapter>> getChapters(int novelId) async {
    final res = await _client
        .from('chapters')
        .select()
        .eq('novel_id', novelId)
        .order('chapter_index', ascending: true);

    return (res as List).map((r) => Chapter.fromMap(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveChaptersOrder(int novelId, List<Chapter> orderedChapters) async {
    for (var i = 0; i < orderedChapters.length; i++) {
      await _client.from('chapters').update({
        'chapter_index': -(i + 1),
      }).eq('id', orderedChapters[i].id);
    }
    for (var i = 0; i < orderedChapters.length; i++) {
      await _client.from('chapters').update({
        'chapter_index': i + 1,
      }).eq('id', orderedChapters[i].id);
    }
  }

  @override
  Future<Chapter> saveChapter(Chapter chapter) async {
    final map = chapter.toMap();
    final existing = await _client.from('chapters').select('id').eq('id', chapter.id).maybeSingle();

    if (existing == null) {
      await _client.from('chapters').insert(map);
    } else {
      await _client.from('chapters').update(map).eq('id', chapter.id);
    }

    // Cập nhật total_chapters
    final countRes = await _client.from('chapters').select('id').eq('novel_id', chapter.novelId);
    final total = (countRes as List).length;

    await _client.from('novels').update({
      'total_chapters': total,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    }).eq('id', chapter.novelId);

    return chapter;
  }

  @override
  Future<List<GlossaryTerm>> getGlossaryTerms(int novelId) async {
    final res = await _client
        .from('glossary_terms')
        .select()
        .eq('novel_id', novelId)
        .order('first_chapter_index', ascending: true);

    return (res as List).map((r) => GlossaryTerm.fromMap(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> addGlossaryTerm(GlossaryTerm term) async {
    final map = term.toMap();
    if (term.id == null || term.id! <= 0) {
      map.remove('id');
    }
    await _client.from('glossary_terms').insert(map);
  }

  @override
  Future<void> deleteGlossaryTerm(int termId) async {
    await _client.from('glossary_terms').delete().eq('id', termId);
  }

  @override
  Future<List<ChapterSummary>> getChapterSummaries(int novelId) async {
    final res = await _client
        .from('chapter_summaries')
        .select()
        .eq('novel_id', novelId)
        .order('chapter_index', ascending: true);

    return (res as List).map((r) => ChapterSummary.fromMap(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveChapterSummary(ChapterSummary summary) async {
    await _client.from('chapter_summaries').upsert(summary.toMap());
  }

  @override
  Future<void> writeAuditLog({
    required AppUser admin,
    required String action,
    required String target,
    required String detail,
  }) async {
    final map = AuditLog(
      adminId: admin.id,
      adminName: admin.displayName,
      action: action,
      target: target,
      detail: detail,
      createdAt: DateTime.now(),
    ).toMap();
    map.remove('id');
    await _client.from('audit_logs').insert(map);
  }

  @override
  Future<void> createNotification(NotificationItem item) async {
    final map = item.toMap();
    map.remove('id');
    await _client.from('notifications').insert(map);
  }
}
