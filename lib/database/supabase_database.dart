import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/bookmark.dart';
import '../models/chapter.dart';
import '../models/library_item.dart';
import '../models/novel.dart';
import '../models/reading_history.dart';
import '../utils/constants.dart';
import '../utils/format.dart';

/// Lớp truy cập Cloud Database Supabase thay thế hoàn toàn cho SQLite.
class SupabaseDatabase {
  SupabaseDatabase._();
  static final SupabaseDatabase instance = SupabaseDatabase._();

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
    var query = _client.from('novels').select();

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

    final res = await query
        .order(orderCol, ascending: ascending)
        .order('id', ascending: true)
        .range(offset, offset + limit - 1);

    var list = (res as List).map((e) => Novel.fromMap(e as Map<String, dynamic>)).toList();

    // Lọc genres nếu có
    if (genres.isNotEmpty) {
      list = list.where((novel) {
        return genres.every((g) => novel.genres.contains(g));
      }).toList();
    }

    return list;
  }

  Future<Novel?> getNovel(int id) async {
    final res = await _client.from('novels').select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return Novel.fromMap(res);
  }

  Future<Map<String, int>> genreCounts() async {
    final res = await _client.from('novels').select('genres');
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
    List<String>? chapterContents,
    String? coverUrl,
    String moderationStatus = ModerationStatus.approved,
    String ownerId = '',
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Step 3: id do Postgres tự sinh, không tính MAX(id)+1 ở client
    final novelMap = {
      'title': title,
      'author': author,
      'cover_url': coverUrl ?? '',
      'description': description,
      'status': status,
      'type': type,
      'genres': genres.join(','),
      'total_chapters': chapterTitles.length,
      'rating': 5.0,
      'views': 0,
      'updated_at': now,
      'search_text': Format.normalize('$title $author'),
      'moderation_status': moderationStatus,
      'owner_id': ownerId,
    };

    final inserted = await _client.from('novels').insert(novelMap).select().single();
    final generatedId = inserted['id'] as int;

    // Thêm các chương
    if (chapterTitles.isNotEmpty) {
      final chapterRows = <Map<String, dynamic>>[];
      for (var i = 0; i < chapterTitles.length; i++) {
        final cIndex = i + 1;
        chapterRows.add({
          'id': generatedId * 10000 + cIndex,
          'novel_id': generatedId,
          'chapter_index': cIndex,
          'title': chapterTitles[i],
          'content': chapterContents != null && i < chapterContents.length ? chapterContents[i] : '',
          'is_downloaded': 1,
        });
      }
      await _client.from('chapters').insert(chapterRows);
    }

    return Novel.fromMap(inserted);
  }

  Future<Chapter> appendChapter({
    required int novelId,
    required String title,
    required String content,
  }) async {
    final maxRes = await _client
        .from('chapters')
        .select('chapter_index')
        .eq('novel_id', novelId)
        .order('chapter_index', ascending: false)
        .limit(1);

    final nextIndex = (maxRes.isNotEmpty ? (maxRes.first['chapter_index'] as int) : 0) + 1;
    final chapterId = novelId * 10000 + nextIndex;

    final chMap = {
      'id': chapterId,
      'novel_id': novelId,
      'chapter_index': nextIndex,
      'title': title,
      'content': content,
      'is_downloaded': 1,
    };

    await _client.from('chapters').insert(chMap);

    // Cập nhật số chương novel
    await _client.from('novels').update({
      'total_chapters': nextIndex,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    }).eq('id', novelId);

    return Chapter.fromMap(chMap);
  }

  // ---------------------------------------------------------------------------
  // CHƯƠNG (chapters)
  // ---------------------------------------------------------------------------

  Future<List<Chapter>> getChapters(int novelId) async {
    final res = await _client
        .from('chapters')
        .select('id, novel_id, chapter_index, title, is_downloaded, publish_at')
        .eq('novel_id', novelId)
        .order('chapter_index', ascending: true);

    return (res as List).map((e) => Chapter.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<Chapter?> getChapter(int id) async {
    final res = await _client.from('chapters').select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return Chapter.fromMap(res);
  }

  Future<String> fetchChapterContent(int novelId, int chapterIndex) async {
    final res = await _client
        .from('chapters')
        .select('content')
        .eq('novel_id', novelId)
        .eq('chapter_index', chapterIndex)
        .maybeSingle();

    if (res != null && res['content'] != null) {
      return res['content'] as String;
    }
    return 'Nội dung chương đang được cập nhật...';
  }

  Future<void> saveChapterContent(int chapterId, String content) async {
    await _client.from('chapters').update({
      'content': content,
      'is_downloaded': 1,
    }).eq('id', chapterId);
  }

  Future<void> deleteChapterContent(int chapterId) async {
    await _client.from('chapters').update({
      'is_downloaded': 0,
    }).eq('id', chapterId);
  }

  Future<int> deleteDownloads({int? novelId}) async {
    if (novelId != null) {
      await _client.from('chapters').update({'is_downloaded': 0}).eq('novel_id', novelId);
    } else {
      await _client.from('chapters').update({'is_downloaded': 0});
    }
    return 1;
  }

  Future<List<DownloadedChapter>> getDownloadedChapters() async {
    final res = await _client
        .from('chapters')
        .select('id, novel_id, chapter_index, title, content, is_downloaded, publish_at, novels!inner(title, cover_url)')
        .eq('is_downloaded', 1);

    return (res as List).map((row) {
      final novel = row['novels'] as Map<String, dynamic>;
      final chapter = Chapter.fromMap(row);
      return DownloadedChapter(
        chapter: chapter,
        novelTitle: novel['title'] as String? ?? '',
        coverUrl: novel['cover_url'] as String? ?? '',
        sizeInBytes: (chapter.content?.length ?? 0) * 2,
      );
    }).toList();
  }

  Future<int> countDownloaded() async {
    final res = await _client.from('chapters').select('id').eq('is_downloaded', 1);
    return (res as List).length;
  }

  // ---------------------------------------------------------------------------
  // TỦ SÁCH (library)
  // Step 5: Truyền auth.uid(), bỏ giá trị mặc định userId = 1
  // ---------------------------------------------------------------------------

  Future<List<LibraryItem>> getLibrary({String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client
        .from('library')
        .select('novel_id, category, added_at, novels!inner(*)')
        .eq('user_id', uid)
        .order('added_at', ascending: false);

    return (res as List).map((r) {
      final novelMap = r['novels'] as Map<String, dynamic>;
      final novel = Novel.fromMap(novelMap);
      return LibraryItem(
        novelId: r['novel_id'] as int,
        novel: novel,
        category: r['category'] as String,
        addedAt: DateTime.fromMillisecondsSinceEpoch(r['added_at'] as int),
      );
    }).toList();
  }

  Future<void> upsertLibrary(LibraryItem item, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    await _client.from('library').upsert({
      'user_id': uid,
      'novel_id': item.novelId,
      'category': item.category,
      'added_at': item.addedAt.millisecondsSinceEpoch,
    });
  }

  Future<void> removeFromLibrary(int novelId, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    await _client.from('library').delete().eq('user_id', uid).eq('novel_id', novelId);
  }

  // ---------------------------------------------------------------------------
  // LỊCH SỬ ĐỌC (reading_history)
  // Step 5: Truyền auth.uid(), bỏ giá trị mặc định userId = 1
  // ---------------------------------------------------------------------------

  Future<List<ReadingHistory>> getHistory({String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client
        .from('reading_history')
        .select('novel_id, last_chapter_id, scroll_offset, last_read_at, novels!inner(*), chapters(*)')
        .eq('user_id', uid)
        .order('last_read_at', ascending: false);

    return (res as List).map((r) {
      final novel = Novel.fromMap(r['novels'] as Map<String, dynamic>);
      final chapterMap = r['chapters'] as Map<String, dynamic>?;
      final chapterIndex = chapterMap != null ? (chapterMap['chapter_index'] as int? ?? 1) : 1;
      final chapterTitle = chapterMap != null ? (chapterMap['title'] as String? ?? 'Chương 1') : 'Chương 1';
      return ReadingHistory(
        novelId: r['novel_id'] as int,
        lastChapterId: r['last_chapter_id'] as int,
        novel: novel,
        chapterIndex: chapterIndex,
        chapterTitle: chapterTitle,
        scrollOffset: (r['scroll_offset'] as num).toDouble(),
        lastReadAt: DateTime.fromMillisecondsSinceEpoch(r['last_read_at'] as int),
      );
    }).toList();
  }

  Future<ReadingHistory?> getHistoryFor(int novelId, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client
        .from('reading_history')
        .select('novel_id, last_chapter_id, scroll_offset, last_read_at, novels!inner(*), chapters(*)')
        .eq('user_id', uid)
        .eq('novel_id', novelId)
        .maybeSingle();

    if (res == null) return null;
    final novel = Novel.fromMap(res['novels'] as Map<String, dynamic>);
    final chapterMap = res['chapters'] as Map<String, dynamic>?;
    final chapterIndex = chapterMap != null ? (chapterMap['chapter_index'] as int? ?? 1) : 1;
    final chapterTitle = chapterMap != null ? (chapterMap['title'] as String? ?? 'Chương 1') : 'Chương 1';
    return ReadingHistory(
      novelId: res['novel_id'] as int,
      lastChapterId: res['last_chapter_id'] as int,
      novel: novel,
      chapterIndex: chapterIndex,
      chapterTitle: chapterTitle,
      scrollOffset: (res['scroll_offset'] as num).toDouble(),
      lastReadAt: DateTime.fromMillisecondsSinceEpoch(res['last_read_at'] as int),
    );
  }

  Future<void> saveHistory(ReadingHistory history, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    await _client.from('reading_history').upsert({
      'user_id': uid,
      'novel_id': history.novelId,
      'last_chapter_id': history.lastChapterId,
      'scroll_offset': history.scrollOffset,
      'last_read_at': history.lastReadAt.millisecondsSinceEpoch,
    });
  }

  Future<void> deleteHistory(int novelId, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    await _client.from('reading_history').delete().eq('user_id', uid).eq('novel_id', novelId);
  }

  Future<void> clearHistory({String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    await _client.from('reading_history').delete().eq('user_id', uid);
  }

  // ---------------------------------------------------------------------------
  // DẤU TRANG (bookmarks)
  // Step 5: Truyền auth.uid(), bỏ giá trị mặc định userId = 1
  // ---------------------------------------------------------------------------

  Future<List<Bookmark>> getBookmarks(int novelId, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client
        .from('bookmarks')
        .select('id, novel_id, chapter_id, scroll_offset, note, created_at, chapters!inner(chapter_index, title)')
        .eq('user_id', uid)
        .eq('novel_id', novelId)
        .order('created_at', ascending: false);

    return (res as List).map((r) {
      final ch = r['chapters'] as Map<String, dynamic>;
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

  Future<int> addBookmark(Bookmark bookmark, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client.from('bookmarks').insert({
      'user_id': uid,
      'novel_id': bookmark.novelId,
      'chapter_id': bookmark.chapterId,
      'scroll_offset': bookmark.scrollOffset,
      'note': bookmark.note,
      'created_at': bookmark.createdAt.millisecondsSinceEpoch,
    }).select('id').single();

    return res['id'] as int;
  }

  Future<void> deleteBookmark(int id) async {
    await _client.from('bookmarks').delete().eq('id', id);
  }

  // ---------------------------------------------------------------------------
  // TRÍCH DẪN (quotes)
  // ---------------------------------------------------------------------------

  Future<List<QuoteItem>> getQuotes({String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client
        .from('quotes')
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

  Future<int> addQuote(QuoteItem quote, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client.from('quotes').insert({
      'user_id': uid,
      'novel_id': quote.novelId,
      'novel_title': quote.novelTitle,
      'author': quote.author,
      'chapter_title': quote.chapterTitle,
      'content': quote.content,
      'created_at': quote.createdAt.millisecondsSinceEpoch,
    }).select('id').single();

    return res['id'] as int;
  }

  Future<void> deleteQuote(int id) async {
    await _client.from('quotes').delete().eq('id', id);
  }

  // ---------------------------------------------------------------------------
  // BÌNH LUẬN (comments)
  // Step 5: Truyền auth.uid(), bỏ giá trị mặc định userId = 1
  // ---------------------------------------------------------------------------

  Future<List<ChapterComment>> getComments(int chapterId) async {
    final res = await _client
        .from('comments')
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
    await _client.from('comments').insert({
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
    await _client.from('comments').delete().eq('id', id);
  }

  // Step 6: Dùng bảng ratings riêng
  Future<double> updateNovelRating(int novelId, double userStars, {String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id;
    if (uid != null && uid.isNotEmpty) {
      await _client.from('ratings').upsert({
        'user_id': uid,
        'novel_id': novelId,
        'stars': userStars.round().clamp(1, 5),
      });
    }

    final ratingsRes = await _client.from('ratings').select('stars').eq('novel_id', novelId);
    double newRating = userStars;
    if ((ratingsRes as List).isNotEmpty) {
      final totalStars = ratingsRes.fold<num>(0, (sum, r) => sum + (r['stars'] as num));
      newRating = double.parse((totalStars / ratingsRes.length).toStringAsFixed(1));
    }

    await _client.from('novels').update({
      'rating': newRating,
    }).eq('id', novelId);

    return newRating;
  }

  // ---------------------------------------------------------------------------
  // THỐNG KÊ PHIÊN ĐỌC (reading_sessions)
  // ---------------------------------------------------------------------------

  Future<void> recordReadingSession({
    required int wordsRead,
    required int minutesRead,
    String? userId,
    int novelId = 0,
    int chapterId = 0,
  }) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final existing = await _client
        .from('reading_sessions')
        .select()
        .eq('user_id', uid)
        .eq('date_key', dateKey)
        .maybeSingle();

    final prevWords = (existing?['words_read'] as int?) ?? 0;
    final prevMins = (existing?['minutes_read'] as int?) ?? 0;

    await _client.from('reading_sessions').upsert({
      'user_id': uid,
      'date_key': dateKey,
      'words_read': prevWords + wordsRead,
      'minutes_read': prevMins + minutesRead,
    });

    if (wordsRead > 0 || minutesRead > 0) {
      await _client.from('reading_session_logs').insert({
        'user_id': uid,
        'novel_id': novelId,
        'chapter_id': chapterId,
        'started_at': now.subtract(Duration(minutes: minutesRead)).millisecondsSinceEpoch,
        'ended_at': now.millisecondsSinceEpoch,
        'words_read': wordsRead,
        'hour_of_day': now.hour,
      });
    }
  }

  Future<List<ReadingSessionStat>> getReadingSessions({String? userId}) async {
    final uid = userId ?? _client.auth.currentUser?.id ?? '';
    final res = await _client
        .from('reading_sessions')
        .select()
        .eq('user_id', uid)
        .order('date_key', ascending: false)
        .limit(30);

    return (res as List).map((r) {
      return ReadingSessionStat(
        dateKey: r['date_key'] as String,
        wordsRead: r['words_read'] as int,
        minutesRead: r['minutes_read'] as int,
      );
    }).toList();
  }
}
