import 'dart:async';
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/bookmark.dart';
import '../models/chapter.dart';
import '../models/library_item.dart';
import '../models/novel.dart';
import '../models/reading_history.dart';
import '../repositories/reading_history_remote.dart';
import '../repositories/library_remote.dart';
import '../repositories/bookmark_remote.dart';
import '../repositories/quote_remote.dart';
import '../repositories/reading_stats_remote.dart';
import '../utils/constants.dart';
import '../utils/format.dart';

/// Lớp truy cập Cloud Database Supabase thay thế hoàn toàn cho SQLite.
class SupabaseDatabase
    implements
        ReadingHistoryRemote,
        LibraryRemote,
        BookmarkRemote,
        QuoteRemote,
        ReadingStatsRemote {
  SupabaseDatabase._();
  static final SupabaseDatabase instance = SupabaseDatabase._();

  static String newImportRequestId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Object().hashCode}';

  SupabaseClient get _client => Supabase.instance.client;

  // ---------------------------------------------------------------------------
  // TRUYỆN (novels)
  // ---------------------------------------------------------------------------

  Future<List<Novel>> queryNovels({
    String keyword = '',
    List<String> genres = const [],
    String? status,
    String? type,
    NovelSort sort = NovelSort.updated,
    int limit = AppInfo.pageSize,
    int offset = 0,
    bool includeUnapproved = false,
  }) async {
    var query = _client.from('truyen').select();

    query = query.filter('deleted_at', 'is', null);

    if (!includeUnapproved) {
      query = query.eq('moderation_status', 'approved');
    }

    final kw = Format.normalize(keyword).trim();
    if (kw.isNotEmpty) {
      query = query.ilike('search_text', '%$kw%');
    }

    if (status != null) {
      query = query.eq('status', status);
    }

    if (type != null) {
      query = query.eq('type', type);
    }

    // Sắp xếp
    final ascending = sort == NovelSort.title;
    final orderCol = switch (sort) {
      NovelSort.updated => 'updated_at',
      NovelSort.views => 'views',
      NovelSort.rating => 'rating',
      NovelSort.title => 'title',
    };

    if (genres.isEmpty) {
      final res = await query
          .order(orderCol, ascending: ascending)
          .order('id', ascending: true)
          .range(offset, offset + limit - 1);
      return (res as List)
          .map((e) => Novel.fromMap(e as Map<String, dynamic>))
          .toList();
    }

    // Genre đang được lưu dạng CSV. Lọc sau khi lấy đúng trang khiến trang
    // thiếu kết quả; quét cloud theo lô và chỉ phân trang sau khi lọc chính xác.
    const batchSize = 100;
    final matches = <Novel>[];
    var scanOffset = 0;
    final requiredCount = offset + limit;
    while (matches.length < requiredCount) {
      final res = await query
          .order(orderCol, ascending: ascending)
          .order('id', ascending: true)
          .range(scanOffset, scanOffset + batchSize - 1);
      final rows = (res as List)
          .map((e) => Novel.fromMap(e as Map<String, dynamic>))
          .toList();
      matches.addAll(
        rows.where(
          (novel) => genres.every((genre) => novel.genres.contains(genre)),
        ),
      );
      if (rows.length < batchSize) break;
      scanOffset += batchSize;
    }
    return matches.skip(offset).take(limit).toList();
  }

  Future<Novel?> getNovel(int id) async {
    final res = await _client
        .from('truyen')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (res == null) return null;
    return Novel.fromMap(res);
  }

  /// Tăng bộ đếm lượt xem một cách nguyên tử trên Supabase.
  Future<int?> recordNovelView(int novelId) async {
    final result = await _client.rpc(
      'increment_novel_view',
      params: {'p_novel_id': novelId},
    );
    return (result as num?)?.toInt();
  }

  Future<Map<String, int>> genreCounts({bool includeUnapproved = false}) async {
    var query = _client
        .from('truyen')
        .select('genres')
        .filter('deleted_at', 'is', null);
    if (!includeUnapproved) {
      query = query.eq('moderation_status', 'approved');
    }
    final res = await query;
    final result = <String, int>{};
    for (final row in (res as List)) {
      final raw = (row['genres'] as String?) ?? '';
      for (final g in raw.split(',')) {
        final name = g.trim();
        if (name.isNotEmpty) {
          result[name] = (result[name] ?? 0) + 1;
        }
      }
    }
    return result;
  }

  Future<Novel> insertCustomNovel({
    required String title,
    required String author,
    required String description,
    required String status,
    required String type,
    required List<String> genres,
    required List<String> chapterTitles,
    required String requestId,
    List<String>? chapterContents,
    String? coverUrl,
    String moderationStatus = ModerationStatus.approved,
    String ownerId = '',
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (requestId.trim().isEmpty || requestId.length > 128) {
      throw ArgumentError.value(
        requestId,
        'requestId',
        'Khóa gửi không hợp lệ.',
      );
    }
    if (chapterTitles.length > 2000) {
      throw ArgumentError('Mỗi lần gửi tối đa 2.000 chương.');
    }
    if (chapterContents != null &&
        chapterContents.length != chapterTitles.length) {
      throw ArgumentError('Số nội dung phải khớp với số tiêu đề chương.');
    }
    final contents = [
      for (var i = 0; i < chapterTitles.length; i++)
        chapterContents != null ? chapterContents[i] : '',
    ];
    final totalTextBytes =
        contents.fold<int>(
          0,
          (total, content) => total + utf8.encode(content).length,
        ) +
        chapterTitles.fold<int>(
          0,
          (total, chapterTitle) => total + utf8.encode(chapterTitle).length,
        );
    if (totalTextBytes > 16 * 1024 * 1024) {
      throw ArgumentError(
        'Nội dung gửi cộng đồng vượt giới hạn 16 MB mỗi tác phẩm.',
      );
    }

    // Step 3: id do Postgres tự sinh, không tính MAX(id)+1 ở client.
    final novelMap = {
      'title': title,
      'author': author,
      'cover_url': coverUrl ?? '',
      'description': description,
      'status': status,
      'type': type,
      'genres': genres.join(','),
      'total_chapters': chapterTitles.length,
      'updated_at': now,
      'search_text': Format.normalize('$title $author'),
      'moderation_status': moderationStatus,
      'owner_id': ownerId,
    };

    final inserted = await _client.rpc(
      'create_novel_with_chapters',
      params: {
        'p_novel': novelMap,
        'p_request_id': requestId,
        'p_chapters': [
          for (var i = 0; i < chapterTitles.length; i++)
            {'title': chapterTitles[i], 'content': contents[i]},
        ],
      },
    );
    if (inserted is! Map) {
      throw StateError('Supabase trả về dữ liệu tác phẩm không hợp lệ.');
    }

    return Novel.fromMap(Map<String, dynamic>.from(inserted));
  }

  Future<Chapter> appendChapter({
    required int novelId,
    required String title,
    required String content,
  }) async {
    final maxRes = await _client
        .from('chuong')
        .select('chapter_index')
        .eq('novel_id', novelId)
        .order('chapter_index', ascending: false)
        .limit(1);

    final nextIndex =
        (maxRes.isNotEmpty ? (maxRes.first['chapter_index'] as int) : 0) + 1;
    final chapterId = novelId * 10000 + nextIndex;
    final normalizedTitle = title.trim();
    final chapterTitle = normalizedTitle.isEmpty
        ? 'Chương $nextIndex'
        : normalizedTitle.startsWith('Chương')
        ? normalizedTitle
        : 'Chương $nextIndex: $normalizedTitle';

    final chMap = {
      'id': chapterId,
      'novel_id': novelId,
      'chapter_index': nextIndex,
      'title': chapterTitle,
      'content': content,
      // This column is shared in the cloud schema; a newly published chapter
      // must not appear downloaded for every reader. Offline content is cached
      // per device in SQLite instead.
      'is_downloaded': 0,
    };

    await _client.from('chuong').insert(chMap);

    // Cập nhật số chương novel
    await _client
        .from('truyen')
        .update({
          'total_chapters': nextIndex,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        })
        .eq('id', novelId);

    return Chapter.fromMap(chMap);
  }

  // ---------------------------------------------------------------------------
  // CHƯƠNG (chapters)
  // ---------------------------------------------------------------------------

  Future<List<Chapter>> getChapters(int novelId) async {
    final res = await _client
        .from('chuong')
        .select('id, novel_id, chapter_index, title, is_downloaded, publish_at')
        .eq('novel_id', novelId)
        .order('chapter_index', ascending: true);

    return (res as List)
        .map((e) => Chapter.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<Chapter?> getChapter(int id) async {
    final res = await _client
        .from('chuong')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (res == null) return null;
    return Chapter.fromMap(res);
  }

  Future<String> fetchChapterContent(int novelId, int chapterIndex) async {
    final res = await _client
        .from('chuong')
        .select('content')
        .eq('novel_id', novelId)
        .eq('chapter_index', chapterIndex)
        .maybeSingle();

    if (res != null && res['content'] != null) {
      return res['content'] as String;
    }
    throw StateError(
      'Không tìm thấy nội dung chương $chapterIndex của truyện $novelId trên Supabase.',
    );
  }

  // ---------------------------------------------------------------------------
  // TỦ SÁCH (library)
  // Step 5: Truyền auth.uid(), bỏ giá trị mặc định userId = 1
  // ---------------------------------------------------------------------------

  @override
  Future<List<LibraryItem>> getLibrary({String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client
        .from('tu_sach')
        .select('novel_id, category, added_at, truyen!inner(*)')
        .eq('user_id', uid)
        .order('added_at', ascending: false);

    return (res as List).map((r) {
      final novelMap = r['truyen'] as Map<String, dynamic>;
      final novel = Novel.fromMap(novelMap);
      return LibraryItem(
        novelId: r['novel_id'] as int,
        novel: novel,
        category: r['category'] as String,
        addedAt: DateTime.fromMillisecondsSinceEpoch(r['added_at'] as int),
      );
    }).toList();
  }

  @override
  Future<void> upsertLibrary(LibraryItem item, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    await _client.from('tu_sach').upsert({
      'user_id': uid,
      'novel_id': item.novelId,
      'category': item.category,
      'added_at': item.addedAt.millisecondsSinceEpoch,
    });
  }

  @override
  Future<void> removeFromLibrary(int novelId, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    await _client
        .from('tu_sach')
        .delete()
        .eq('user_id', uid)
        .eq('novel_id', novelId);
  }

  // ---------------------------------------------------------------------------
  // LỊCH SỬ ĐỌC (reading_history)
  // Step 5: Truyền auth.uid(), bỏ giá trị mặc định userId = 1
  // ---------------------------------------------------------------------------

  @override
  Future<List<ReadingHistory>> getHistory({String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client
        .from('lich_su_doc')
        .select(
          'novel_id, last_chapter_id, scroll_offset, last_read_at, truyen!inner(*), chuong(*)',
        )
        .eq('user_id', uid)
        .order('last_read_at', ascending: false);

    return (res as List).map((r) {
      final novel = Novel.fromMap(r['truyen'] as Map<String, dynamic>);
      final chapterMap = r['chuong'] as Map<String, dynamic>?;
      final chapterIndex = chapterMap != null
          ? (chapterMap['chapter_index'] as int? ?? 1)
          : 1;
      final chapterTitle = chapterMap != null
          ? (chapterMap['title'] as String? ?? 'Chương 1')
          : 'Chương 1';
      return ReadingHistory(
        novelId: r['novel_id'] as int,
        lastChapterId: r['last_chapter_id'] as int,
        novel: novel,
        chapterIndex: chapterIndex,
        chapterTitle: chapterTitle,
        scrollOffset: (r['scroll_offset'] as num).toDouble(),
        lastReadAt: DateTime.fromMillisecondsSinceEpoch(
          r['last_read_at'] as int,
        ),
      );
    }).toList();
  }

  @override
  Future<ReadingHistory?> getHistoryFor(int novelId, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client
        .from('lich_su_doc')
        .select(
          'novel_id, last_chapter_id, scroll_offset, last_read_at, truyen!inner(*), chuong(*)',
        )
        .eq('user_id', uid)
        .eq('novel_id', novelId)
        .maybeSingle();

    if (res == null) return null;
    final novel = Novel.fromMap(res['truyen'] as Map<String, dynamic>);
    final chapterMap = res['chuong'] as Map<String, dynamic>?;
    final chapterIndex = chapterMap != null
        ? (chapterMap['chapter_index'] as int? ?? 1)
        : 1;
    final chapterTitle = chapterMap != null
        ? (chapterMap['title'] as String? ?? 'Chương 1')
        : 'Chương 1';
    return ReadingHistory(
      novelId: res['novel_id'] as int,
      lastChapterId: res['last_chapter_id'] as int,
      novel: novel,
      chapterIndex: chapterIndex,
      chapterTitle: chapterTitle,
      scrollOffset: (res['scroll_offset'] as num).toDouble(),
      lastReadAt: DateTime.fromMillisecondsSinceEpoch(
        res['last_read_at'] as int,
      ),
    );
  }

  Future<void> saveHistory(ReadingHistory history, {String? userId}) =>
      saveHistories([history], userId: userId);

  @override
  Future<void> saveHistories(
    List<ReadingHistory> histories, {
    String? userId,
  }) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    if (histories.isEmpty || uid.isEmpty) return;
    await _client.from('lich_su_doc').upsert([
      for (final history in histories) {'user_id': uid, ...history.toMap()},
    ]);
  }

  @override
  Future<void> deleteHistory(int novelId, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    await _client
        .from('lich_su_doc')
        .delete()
        .eq('user_id', uid)
        .eq('novel_id', novelId);
  }

  @override
  Future<void> clearHistory({String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    await _client.from('lich_su_doc').delete().eq('user_id', uid);
  }

  // ---------------------------------------------------------------------------
  // DẤU TRANG (bookmarks)
  // Step 5: Truyền auth.uid(), bỏ giá trị mặc định userId = 1
  // ---------------------------------------------------------------------------

  @override
  Future<List<Bookmark>> getBookmarks(int novelId, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client
        .from('dau_trang')
        .select(
          'id, novel_id, chapter_id, scroll_offset, note, created_at, chuong!inner(chapter_index, title)',
        )
        .eq('user_id', uid)
        .eq('novel_id', novelId)
        .order('created_at', ascending: false);

    return (res as List).map((r) {
      final ch = r['chuong'] as Map<String, dynamic>;
      return Bookmark(
        id: r['id'] as int,
        novelId: r['novel_id'] as int,
        chapterId: r['chapter_id'] as int,
        chapterIndex: ch['chapter_index'] as int,
        chapterTitle: ch['title'] as String,
        scrollOffset: (r['scroll_offset'] as num).toDouble(),
        note: (r['note'] as String?) ?? '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(r['created_at'] as int),
      );
    }).toList();
  }

  @override
  Future<int> addBookmark(Bookmark bookmark, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client
        .from('dau_trang')
        .insert({
          'user_id': uid,
          'novel_id': bookmark.novelId,
          'chapter_id': bookmark.chapterId,
          'scroll_offset': bookmark.scrollOffset,
          'note': bookmark.note,
          'created_at': bookmark.createdAt.millisecondsSinceEpoch,
        })
        .select('id')
        .single();

    return res['id'] as int;
  }

  @override
  Future<void> deleteBookmark(int id, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    await _client.from('dau_trang').delete().eq('id', id).eq('user_id', uid);
  }

  // ---------------------------------------------------------------------------
  // TRÍCH DẪN (quotes)
  // ---------------------------------------------------------------------------

  @override
  Future<List<QuoteItem>> getQuotes({String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client
        .from('trich_dan')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false);

    return (res as List).map((r) {
      return QuoteItem(
        id: r['id'] as int,
        novelId: r['novel_id'] as int,
        novelTitle: r['novel_title'] as String,
        author: r['author'] as String,
        chapterTitle: r['chapter_title'] as String,
        content: r['content'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(r['created_at'] as int),
      );
    }).toList();
  }

  @override
  Future<int> addQuote(QuoteItem quote, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client
        .from('trich_dan')
        .insert({
          'user_id': uid,
          'novel_id': quote.novelId,
          'novel_title': quote.novelTitle,
          'author': quote.author,
          'chapter_title': quote.chapterTitle,
          'content': quote.content,
          'created_at': quote.createdAt.millisecondsSinceEpoch,
        })
        .select('id')
        .single();

    return res['id'] as int;
  }

  @override
  Future<void> deleteQuote(int id, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    await _client.from('trich_dan').delete().eq('id', id).eq('user_id', uid);
  }

  // ---------------------------------------------------------------------------
  // BÌNH LUẬN (comments)
  // Step 5: Truyền auth.uid(), bỏ giá trị mặc định userId = 1
  // ---------------------------------------------------------------------------

  Future<List<ChapterComment>> getComments(int chapterId) async {
    final res = await _client
        .from('binh_luan')
        .select()
        .eq('chapter_id', chapterId)
        .order('created_at', ascending: false);

    return (res as List).map((r) {
      return ChapterComment(
        id: r['id'] as int,
        novelId: r['novel_id'] as int,
        chapterId: r['chapter_id'] as int,
        userId: r['user_id']?.toString() ?? '',
        userName: (r['user_name'] as String?) ?? 'Độc giả',
        content: r['content'] as String,
        stars: (r['stars'] as int?) ?? 5,
        chapterIndex: (r['chapter_index'] as int?) ?? 1,
        createdAt: DateTime.fromMillisecondsSinceEpoch(r['created_at'] as int),
      );
    }).toList();
  }

  Future<void> addComment(ChapterComment comment, {String? userId}) async {
    final uid = userId ?? (_client.auth.currentUser?.id ?? comment.userId);
    await _client.from('binh_luan').insert({
      'novel_id': comment.novelId,
      'chapter_id': comment.chapterId,
      'user_id': uid,
      'user_name': comment.userName,
      'content': comment.content,
      'stars': comment.stars,
      'chapter_index': comment.chapterIndex,
      'created_at': comment.createdAt.millisecondsSinceEpoch,
    });
  }

  Future<void> deleteComment(int id) async {
    await _client.from('binh_luan').delete().eq('id', id);
  }

  // Step 6: Dùng bảng ratings riêng
  Future<double> updateNovelRating(
    int novelId,
    double userStars, {
    String? userId,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null || (userId != null && userId.isNotEmpty && userId != uid)) {
      throw StateError('Vui lòng đăng nhập để đánh giá truyện.');
    }
    await _client.from('danh_gia').upsert({
      'user_id': uid,
      'novel_id': novelId,
      'stars': userStars.round().clamp(1, 5),
    });

    final ratingsRes = await _client
        .from('danh_gia')
        .select('stars')
        .eq('novel_id', novelId);
    double newRating = userStars;
    if ((ratingsRes as List).isNotEmpty) {
      final totalStars = ratingsRes.fold<num>(
        0,
        (sum, r) => sum + (r['stars'] as num),
      );
      newRating = double.parse(
        (totalStars / ratingsRes.length).toStringAsFixed(1),
      );
    }

    return newRating;
  }

  // ---------------------------------------------------------------------------
  // THỐNG KÊ PHIÊN ĐỌC (reading_sessions)
  // ---------------------------------------------------------------------------

  @override
  Future<bool> recordReadingSession({
    required int wordsRead,
    required int minutesRead,
    String? userId,
    int novelId = 0,
    int chapterId = 0,
  }) async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null ||
        (userId != null && userId.isNotEmpty && userId != currentUserId)) {
      return false;
    }
    final now = DateTime.now();
    final dateKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    if (wordsRead <= 0 && minutesRead <= 0) return false;

    // One server transaction writes the daily aggregate, session log, and quest
    // progress. A client-side read-then-upsert could lose increments on overlap.
    await _client.rpc(
      'record_reading_session',
      params: {
        'p_words_read': wordsRead,
        'p_minutes_read': minutesRead,
        'p_novel_id': novelId,
        'p_chapter_id': chapterId,
        'p_date_key': dateKey,
        'p_hour_of_day': now.hour,
      },
    );
    return true;
  }

  @override
  Future<List<ReadingSessionStat>> getReadingSessions({String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    if (uid.isEmpty) return [];
    final sessions = <ReadingSessionStat>[];
    const pageSize = 1000;
    for (var offset = 0; ; offset += pageSize) {
      if (_client.auth.currentUser?.id != uid) {
        throw StateError('Tài khoản đã thay đổi.');
      }
      final rows = await _client
          .from('phien_doc')
          .select()
          .eq('user_id', uid)
          .order('date_key', ascending: true)
          .range(offset, offset + pageSize - 1);
      if (_client.auth.currentUser?.id != uid) {
        throw StateError('Tài khoản đã thay đổi.');
      }
      sessions.addAll(rows.map((r) => ReadingSessionStat.fromMap(r)));
      if (rows.length < pageSize) return sessions;
    }
  }
}
