import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../models/bookmark.dart';
import '../models/chapter.dart';
import '../models/library_item.dart';
import '../models/novel.dart';
import '../models/reading_history.dart';
import '../utils/constants.dart';

/// Kiểu sắp xếp tủ sách.
enum LibrarySort { time, name }

/// Quản lý tủ sách, lịch sử đọc (kèm vị trí cuộn) và bookmark.
class LibraryProvider extends ChangeNotifier {
  LibraryProvider(this._db);

  final AppDatabase _db;

  List<LibraryItem> _items = [];
  List<ReadingHistory> _history = [];
  List<QuoteItem> _quotes = [];
  List<ReadingSessionStat> _sessions = [];
  final Map<int, List<Bookmark>> _bookmarks = {};
  final Map<int, List<ChapterComment>> _comments = {};
  final Set<int> _recordedChapterSessions = {};
  bool _loading = false;
  bool _loaded = false;
  String? _error;
  LibrarySort _sort = LibrarySort.time;

  bool get isLoading => _loading;
  bool get isLoaded => _loaded;
  String? get error => _error;
  LibrarySort get sort => _sort;
  List<LibraryItem> get items => List.unmodifiable(_items);
  List<ReadingHistory> get history => List.unmodifiable(_history);
  List<QuoteItem> get quotes => List.unmodifiable(_quotes);
  List<ReadingSessionStat> get sessions => List.unmodifiable(_sessions);

  /// Tổng số từ đã đọc trên toàn bộ các ngày.
  int get totalWordsRead =>
      _sessions.fold<int>(0, (s, e) => s + e.wordsRead);

  /// Tổng số phút đã đọc trên toàn bộ các ngày.
  int get totalMinutesRead =>
      _sessions.fold<int>(0, (s, e) => s + e.minutesRead);

  /// Chuỗi ngày đọc liên tiếp (Streak 🔥) tính đến hôm nay hoặc hôm qua.
  int get currentStreak {
    if (_sessions.isEmpty) return 0;
    final map = {
      for (final s in _sessions)
        if (s.wordsRead > 0 || s.minutesRead > 0) s.dateKey,
    };
    var day = DateTime.now();
    String keyOf(DateTime d) =>
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    if (!map.contains(keyOf(day))) {
      day = day.subtract(const Duration(days: 1));
    }
    var streak = 0;
    while (map.contains(keyOf(day))) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Danh hiệu độc giả dựa trên hoạt động đọc & lưu trữ.
  String get readerRankTitle {
    final score = _history.length * 3 + _items.length * 2 + _quotes.length * 2;
    if (score >= 30) return 'Kiếm Tiên Độc Thư';
    if (score >= 16) return 'Đại Học Sĩ';
    if (score >= 6) return 'Mọt Sách Chính Hiệu';
    return 'Độc Giả Tân Thủ';
  }

  /// Tải tủ sách + lịch sử + trích dẫn từ DB.
  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _db.getLibrary(),
        _db.getHistory(),
        _db.getQuotes(),
        _db.getReadingSessions(),
      ]);
      _items = results[0] as List<LibraryItem>;
      _history = results[1] as List<ReadingHistory>;
      _quotes = results[2] as List<QuoteItem>;
      _sessions = results[3] as List<ReadingSessionStat>;
      _loaded = true;
    } catch (e) {
      _error = '${AppStrings.loadFailed}: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Đổi kiểu sắp xếp.
  void setSort(LibrarySort sort) {
    if (_sort == sort) return;
    _sort = sort;
    notifyListeners();
  }

  /// Các truyện thuộc 1 danh mục, đã sắp xếp theo [sort].
  List<LibraryItem> itemsOf(String category) {
    final list = _items.where((e) => e.category == category).toList();
    if (_sort == LibrarySort.name) {
      list.sort((a, b) => (a.novel?.title ?? '')
          .toLowerCase()
          .compareTo((b.novel?.title ?? '').toLowerCase()));
    } else {
      // Mới đọc/mới thêm lên đầu
      list.sort((a, b) =>
          (b.lastReadAt ?? b.addedAt).compareTo(a.lastReadAt ?? a.addedAt));
    }
    return list;
  }

  /// Danh mục hiện tại của truyện trong tủ sách (null nếu chưa thêm).
  String? categoryOf(int novelId) {
    for (final item in _items) {
      if (item.novelId == novelId) return item.category;
    }
    return null;
  }

  /// Thêm truyện vào tủ sách hoặc chuyển danh mục.
  Future<void> setCategory(int novelId, String category) async {
    final existing = _items.where((e) => e.novelId == novelId).firstOrNull;
    await _db.upsertLibrary(LibraryItem(
      novelId: novelId,
      category: category,
      addedAt: existing?.addedAt ?? DateTime.now(),
    ));
    await _reloadLibrary();
  }

  /// Xóa truyện khỏi tủ sách.
  Future<void> remove(int novelId) async {
    await _db.removeFromLibrary(novelId);
    await _reloadLibrary();
  }

  Future<void> _reloadLibrary() async {
    _items = await _db.getLibrary();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Lịch sử & tiến độ
  // ---------------------------------------------------------------------------

  /// Lịch sử đọc của 1 truyện (null nếu chưa đọc).
  ReadingHistory? historyFor(int novelId) {
    for (final h in _history) {
      if (h.novelId == novelId) return h;
    }
    return null;
  }

  /// Lưu tiến độ đọc: chương hiện tại + vị trí cuộn (tỉ lệ 0..1).
  /// Tự gọi khi mở chương, khi cuộn (có debounce), khi thoát màn hình đọc.
  /// Nếu truyện đang ở "Muốn đọc" sẽ tự chuyển sang "Đang đọc".
  Future<void> saveProgress(Novel novel, Chapter chapter, double offset) async {
    final now = DateTime.now();
    await _db.saveHistory(ReadingHistory(
      novelId: novel.id,
      lastChapterId: chapter.id,
      scrollOffset: offset.clamp(0, 1).toDouble(),
      lastReadAt: now,
    ));
    final updated = ReadingHistory(
      novelId: novel.id,
      lastChapterId: chapter.id,
      scrollOffset: offset.clamp(0, 1).toDouble(),
      lastReadAt: now,
      novel: novel,
      chapterIndex: chapter.chapterIndex,
      chapterTitle: chapter.title,
    );
    _history = [updated, ..._history.where((h) => h.novelId != novel.id)];

    if (categoryOf(novel.id) == LibraryCategory.want) {
      await setCategory(novel.id, LibraryCategory.reading);
      return; // setCategory đã notify
    }
    // Cập nhật tiến độ trong tủ sách mà không cần đọc lại DB.
    _items = [
      for (final item in _items)
        item.novelId == novel.id
            ? item.copyWith(
                lastChapterIndex: chapter.chapterIndex, lastReadAt: now)
            : item,
    ];
    notifyListeners();
  }

  /// Xóa 1 mục lịch sử.
  Future<void> deleteHistory(int novelId) async {
    await _db.deleteHistory(novelId);
    _history = _history.where((h) => h.novelId != novelId).toList();
    _items = await _db.getLibrary();
    notifyListeners();
  }

  /// Xóa toàn bộ lịch sử.
  Future<void> clearHistory() async {
    await _db.clearHistory();
    _history = [];
    _items = await _db.getLibrary();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Bookmark
  // ---------------------------------------------------------------------------

  /// Bookmark đã tải của truyện (null nếu chưa tải).
  List<Bookmark>? bookmarksOf(int novelId) => _bookmarks[novelId];

  /// Tải bookmark của 1 truyện.
  Future<void> loadBookmarks(int novelId) async {
    _bookmarks[novelId] = await _db.getBookmarks(novelId);
    notifyListeners();
  }

  /// Thêm bookmark tại vị trí [offset] (0..1) của chương.
  Future<void> addBookmark(Chapter chapter, double offset, {String note = ''}) async {
    await _db.addBookmark(Bookmark(
      novelId: chapter.novelId,
      chapterId: chapter.id,
      scrollOffset: offset.clamp(0, 1).toDouble(),
      note: note.trim(),
      createdAt: DateTime.now(),
    ));
    await loadBookmarks(chapter.novelId);
  }

  /// Xóa bookmark.
  Future<void> deleteBookmark(Bookmark bookmark) async {
    if (bookmark.id == null) return;
    await _db.deleteBookmark(bookmark.id!);
    await loadBookmarks(bookmark.novelId);
  }

  // ---------------------------------------------------------------------------
  // Trích dẫn (Quotes) & Bình luận chương
  // ---------------------------------------------------------------------------

  /// Lưu một đoạn trích dẫn tâm đắc.
  Future<void> saveQuote({
    required Novel novel,
    required Chapter chapter,
    required String content,
  }) async {
    await _db.addQuote(
      QuoteItem(
        novelId: novel.id,
        novelTitle: novel.title,
        author: novel.author,
        chapterTitle: chapter.title,
        content: content.trim(),
        createdAt: DateTime.now(),
      ),
    );
    _quotes = await _db.getQuotes();
    notifyListeners();
  }

  /// Xóa một trích dẫn.
  Future<void> removeQuote(int id) async {
    await _db.deleteQuote(id);
    _quotes = _quotes.where((q) => q.id != id).toList();
    notifyListeners();
  }

  /// Danh sách bình luận đã tải của 1 chương.
  List<ChapterComment> commentsOf(int chapterId) =>
      _comments[chapterId] ?? const [];

  /// Tải bình luận của chương.
  Future<void> loadComments(int chapterId) async {
    _comments[chapterId] = await _db.getComments(chapterId);
    notifyListeners();
  }

  /// Gửi bình luận mới cho chương.
  Future<void> addComment({
    required int novelId,
    required int chapterId,
    required String content,
    int stars = 5,
  }) async {
    await _db.addComment(
      ChapterComment(
        novelId: novelId,
        chapterId: chapterId,
        content: content.trim(),
        stars: stars,
        createdAt: DateTime.now(),
      ),
    );
    await loadComments(chapterId);
  }

  /// Xóa bình luận.
  Future<void> deleteComment(ChapterComment comment) async {
    if (comment.id == null) return;
    await _db.deleteComment(comment.id!);
    await loadComments(comment.chapterId);
  }

  // ---------------------------------------------------------------------------
  // Thống kê đọc sách & Sao lưu / Khôi phục JSON
  // ---------------------------------------------------------------------------

  /// Ghi nhận 1 chương vừa được mở đọc vào bảng `reading_sessions` (mỗi chương tính 1 lần/phiên).
  Future<void> recordChapterReadSession(int chapterId, String content) async {
    if (_recordedChapterSessions.contains(chapterId)) return;
    _recordedChapterSessions.add(chapterId);
    final words = content.trim().isEmpty
        ? 0
        : content.trim().split(RegExp(r'\s+')).length;
    final minutes = (words / 220).ceil().clamp(1, 60);
    await _db.recordReadingSession(words: words, minutes: minutes);
    _sessions = await _db.getReadingSessions();
    notifyListeners();
  }

  /// Xuất dữ liệu cá nhân ra chuỗi JSON.
  Future<String> exportBackupJson() => _db.exportUserBackupJson();

  /// Nhập dữ liệu cá nhân từ chuỗi JSON và tải lại trạng thái.
  Future<void> importBackupJson(String jsonString) async {
    await _db.importUserBackupJson(jsonString);
    await load();
  }
}
