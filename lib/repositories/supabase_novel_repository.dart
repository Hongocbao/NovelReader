import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/supabase_database.dart';
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
  SupabaseNovelRepository({SupabaseClient? client}) : _clientOverride = client;
  final SupabaseClient? _clientOverride;
  SupabaseClient get _client => _clientOverride ?? Supabase.instance.client;

  @override
  Future<List<Novel>> getAllNovels({bool includeDeleted = false}) async {
    var query = _client.from('truyen').select();
    if (!includeDeleted) {
      query = query.filter('deleted_at', 'is', null);
    }
    final res = await query.order('updated_at', ascending: false).order('id', ascending: false);
    return (res as List).map((r) => Novel.fromMap(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Novel>> getNovelsByOwner(String ownerId) async {
    final res = await _client
        .from('truyen')
        .select()
        .eq('owner_id', ownerId)
        .filter('deleted_at', 'is', null)
        .order('updated_at', ascending: false);

    return (res as List).map((r) => Novel.fromMap(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Novel>> getPendingNovels() async {
    final res = await _client
        .from('truyen')
        .select()
        .eq('moderation_status', ModerationStatus.pending)
        .filter('deleted_at', 'is', null)
        .order('updated_at', ascending: false);

    return (res as List).map((r) => Novel.fromMap(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<Novel?> getNovelById(int novelId) async {
    final res = await _client.from('truyen').select().eq('id', novelId).maybeSingle();
    if (res == null) return null;
    return Novel.fromMap(res);
  }

  @override
  Future<Novel> saveNovel(
    Novel novel, {
    String? requestId,
    List<({String title, String content})> chapters = const [],
  }) async {
    if (novel.id <= 0) {
      if (requestId == null) {
        throw ArgumentError('Cần mã lần gửi để tạo tác phẩm mới.');
      }
      return SupabaseDatabase.withClient(_client).insertCustomNovel(
        title: novel.title,
        author: novel.author,
        description: novel.description,
        status: novel.status,
        type: novel.type,
        genres: novel.genres,
        chapterTitles: [for (final chapter in chapters) chapter.title],
        chapterContents: [for (final chapter in chapters) chapter.content],
        requestId: requestId,
        coverUrl: novel.coverUrl,
        moderationStatus: novel.moderationStatus,
        ownerId: novel.ownerId,
      );
    }
    if (chapters.isNotEmpty) {
      throw ArgumentError('Nhập hàng loạt chỉ dùng khi tạo tác phẩm mới.');
    }
    // Only save fields shown in the editor. An old form must not overwrite
    // new chapter totals, ratings/views, moderation, or a soft deletion.
    final saved = await _client.from('truyen').update({
      'title': novel.title.trim(),
      'author': novel.author.trim(),
      'cover_url': novel.coverUrl,
      'description': novel.description,
      'status': novel.status,
      'type': novel.type,
      'genres': novel.genres.join(','),
      'updated_at': DateTime.now().millisecondsSinceEpoch,
      'search_text': Format.normalize('${novel.title} ${novel.author}'),
    }).eq('id', novel.id).filter('deleted_at', 'is', null).select().single();
    return Novel.fromMap(saved);
  }

  @override
  Future<void> softDeleteNovel(int novelId, {AppUser? admin}) async {
    await _client.from('truyen').update({
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
    await _client.from('truyen').update({
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

    await _client.from('truyen').update({
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

    await _client.from('truyen').update({
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
      await _client.from('truyen').update({
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
    const pageSize = 1000;
    final chapters = <Chapter>[];
    for (var offset = 0; ; offset += pageSize) {
      final rows = await _client.from('chuong')
          .select('id, novel_id, chapter_index, title, is_downloaded, publish_at')
          .eq('novel_id', novelId)
          // IDs remain stable while another editor changes chapter indexes.
          .order('id', ascending: true)
          .range(offset, offset + pageSize - 1);
      chapters.addAll(rows.map(Chapter.fromMap));
      if (rows.length < pageSize) {
        chapters.sort((a, b) => a.chapterIndex.compareTo(b.chapterIndex));
        return chapters;
      }
    }
  }

  @override
  Future<void> saveChaptersOrder(int novelId, List<Chapter> orderedChapters) async {
    final ordered = List<Chapter>.of(orderedChapters);
    if (novelId <= 0 || ordered.any((c) => c.novelId != novelId || c.id <= 0) ||
        ordered.map((c) => c.id).toSet().length != ordered.length ||
        ordered.map((c) => c.chapterIndex).toSet().length != ordered.length) {
      throw ArgumentError('Danh sách chương không hợp lệ.');
    }
    final previous = List<Chapter>.of(ordered)
      ..sort((a, b) => a.chapterIndex.compareTo(b.chapterIndex));
    dynamic result;
    try {
      result = await _client.rpc('reorder_novel_chapters', params: {
        'p_novel_id': novelId,
        'p_chapter_ids': [for (final chapter in ordered) chapter.id],
        'p_expected_ids': [for (final chapter in previous) chapter.id],
      });
    } on PostgrestException catch (error) {
      if (error.code == 'PGRST202') {
        throw StateError('Máy chủ chưa hỗ trợ đổi thứ tự chương. Vui lòng cập nhật cơ sở dữ liệu của ứng dụng.');
      }
      rethrow;
    }
    if (result != true) {
      throw StateError('Chưa xác nhận được thứ tự chương mới. Hãy tải lại danh sách.');
    }
  }

  @override
  Future<Chapter> saveChapter(Chapter chapter, {String? requestId}) async {
    if (chapter.id <= 0) {
      if (requestId == null) {
        throw ArgumentError('Cần mã lần gửi để tạo chương mới.');
      }
      return SupabaseDatabase.withClient(_client).appendChapter(
        novelId: chapter.novelId,
        title: chapter.title,
        content: chapter.content ?? '',
        requestId: requestId,
      );
    }
    // Editing an existing chapter must neither reassign its index nor recount
    // the book: another client may append/reorder while this editor is open.
    final saved = await _client
        .from('chuong')
        .update({
          'title': chapter.title.trim(),
          'content': chapter.content?.trim(),
          'publish_at': chapter.publishAt?.millisecondsSinceEpoch,
        })
        .eq('id', chapter.id)
        .eq('novel_id', chapter.novelId)
        .select()
        .single();
    return Chapter.fromMap(saved);
  }

  @override
  Future<List<GlossaryTerm>> getGlossaryTerms(int novelId) async {
    final res = await _client
        .from('thuat_ngu')
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
    await _client.from('thuat_ngu').insert(map);
  }

  @override
  Future<void> deleteGlossaryTerm(int termId) async {
    await _client.from('thuat_ngu').delete().eq('id', termId);
  }

  @override
  Future<List<ChapterSummary>> getChapterSummaries(int novelId) async {
    final res = await _client
        .from('tom_tat_chuong')
        .select()
        .eq('novel_id', novelId)
        .order('chapter_index', ascending: true);

    return (res as List).map((r) => ChapterSummary.fromMap(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveChapterSummary(ChapterSummary summary) async {
    await _client.from('tom_tat_chuong').upsert(summary.toMap());
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
    await _client.from('nhat_ky_quan_tri').insert(map);
  }

  @override
  Future<void> createNotification(NotificationItem item) async {
    final map = item.toMap();
    map.remove('id');
    await _client.from('thong_bao').insert(map);
  }
}
