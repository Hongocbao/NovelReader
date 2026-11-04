import 'dart:async';

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

typedef _ChapterSessionKey = ({
  int identity,
  String userId,
  int novelId,
  int chapterId,
});

/// Quản lý tủ sách, lịch sử đọc (kèm vị trí cuộn) và bookmark.
class LibraryProvider extends ChangeNotifier {
  LibraryProvider(this._db);

  final AppDatabase _db;
  String? _userId;
  int _identityRevision = 0;
  int _historyRevision = 0;
  int _statsRevision = 0;
  bool _disposed = false;
  bool? _wasOnline;
  final _autoStartAttempts = <({int identity, int novelId})>{};
  final _autoStartsInFlight = <({int identity, int novelId})>{};
  final _shelfRemovalsInFlight = <({int identity, int novelId})>{};
  final _activeRemainders =
      <({int identity, String userId, String day}), Duration>{};
  final _activeWords = <({int identity, String userId, String day}), int>{};
  final _chapterActiveTime =
      <
        ({int identity, String userId, String day, int novelId, int chapterId}),
        Duration
      >{};
  final _chapterActiveWords =
      <
        ({int identity, String userId, String day, int novelId, int chapterId}),
        int
      >{};

  /// Thử đồng bộ lịch sử đang chờ khi mạng trở lại, kể cả lúc đang đọc.
  void updateConnectivity(bool online) {
    final reconnecting = _wasOnline == false && online;
    _wasOnline = online;
    if (!reconnecting || _userId == null || _userId!.isEmpty) return;
    final revision = _identityRevision;
    Future.microtask(() async {
      if (!_disposed && revision == _identityRevision) await load();
    });
  }

  /// Gọi từ ProxyProvider khi đăng nhập/đăng xuất; không giữ dữ liệu tài khoản cũ.
  void bindUser(String userId) {
    if (_userId == userId) return;
    _userId = userId;
    final revision = ++_identityRevision;
    _loadRequestId++;
    _items = [];
    _history = [];
    _quotes = [];
    _sessions = [];
    _bookmarks.clear();
    _comments.clear();
    _recordedChapterSessions.clear();
    _activeRemainders.clear();
    _activeWords.clear();
    _chapterActiveTime.clear();
    _chapterActiveWords.clear();
    _autoStartAttempts.clear();
    _loaded = false;
    _loading = false;
    _error = null;
    // update của ProxyProvider chạy trong build; thông báo ở microtask kế tiếp.
    Future.microtask(() async {
      if (!_disposed &&
          revision == _identityRevision &&
          !_loading &&
          !_loaded) {
        await load();
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _identityRevision++;
    _loadRequestId++;
    super.dispose();
  }

  List<LibraryItem> _items = [];
  List<ReadingHistory> _history = [];
  List<QuoteItem> _quotes = [];
  List<ReadingSessionStat> _sessions = [];
  final Map<int, List<Bookmark>> _bookmarks = {};
  final Map<int, List<ChapterComment>> _comments = {};
  final _recordedChapterSessions = <_ChapterSessionKey>{};
  final _recordingChapterSessions = <_ChapterSessionKey, Future<void>>{};
  bool _loading = false;
  bool _loaded = false;
  String? _error;
  int _loadRequestId = 0;
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
  int get totalWordsRead => _sessions.fold<int>(0, (s, e) => s + e.wordsRead);

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
  Future<void> load({String? userId}) async {
    // Một lần tải lại hoặc kết nối lại cho phép thử chuyển danh mục lần nữa.
    _autoStartAttempts.clear();
    final uid = userId ?? _userId;
    final requestId = ++_loadRequestId;
    final historyRevision = _historyRevision;
    final statsRevision = _statsRevision;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _db.getLibrary(userId: uid),
        _db.getHistory(userId: uid),
        _db.getQuotes(userId: uid),
        _db.getReadingSessions(userId: uid),
      ]);
      if (requestId != _loadRequestId) return;
      _items = results[0] as List<LibraryItem>;
      if (historyRevision == _historyRevision) {
        _history = results[1] as List<ReadingHistory>;
      }
      _items = _withProgress(_items);
      _quotes = results[2] as List<QuoteItem>;
      if (statsRevision == _statsRevision) {
        _sessions = results[3] as List<ReadingSessionStat>;
      }
      _loaded = true;
    } catch (e) {
      if (requestId == _loadRequestId) {
        _error = '${AppStrings.loadFailed}: $e';
      }
    } finally {
      if (requestId == _loadRequestId) {
        _loading = false;
        notifyListeners();
      }
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
      list.sort(
        (a, b) => (a.novel?.title ?? '').toLowerCase().compareTo(
          (b.novel?.title ?? '').toLowerCase(),
        ),
      );
    } else {
      // Mới đọc/mới thêm lên đầu
      list.sort(
        (a, b) =>
            (b.lastReadAt ?? b.addedAt).compareTo(a.lastReadAt ?? a.addedAt),
      );
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
  Future<void> setCategory(int novelId, String category, {Novel? novel}) async {
    _autoStartAttempts.remove((identity: _identityRevision, novelId: novelId));
    await _setCategory(novelId, category, novel: novel);
  }

  Future<void> _setCategory(
    int novelId,
    String category, {
    Novel? novel,
  }) async {
    final uid = _userId;
    final revision = _identityRevision;
    final existing = _items.where((e) => e.novelId == novelId).firstOrNull;
    await _db.upsertLibrary(
      LibraryItem(
        novelId: novelId,
        category: category,
        addedAt: existing?.addedAt ?? DateTime.now(),
        novel: novel ?? existing?.novel,
      ),
      userId: uid,
    );
    if (revision != _identityRevision) return;
    await _reloadLibrary();
  }

  /// Xóa truyện khỏi tủ sách.
  Future<void> remove(int novelId) async {
    final revision = _identityRevision;
    final key = (identity: revision, novelId: novelId);
    _autoStartAttempts.add(key);
    _shelfRemovalsInFlight.add(key);
    try {
      await _db.removeFromLibrary(novelId, userId: _userId);
      if (revision != _identityRevision) return;
      await _reloadLibrary();
    } finally {
      _shelfRemovalsInFlight.remove(key);
    }
  }

  Future<void> _reloadLibrary() async {
    final revision = _identityRevision;
    final items = await _db.getLibrary(userId: _userId);
    if (revision != _identityRevision) return;
    _items = _withProgress(items);
    notifyListeners();
  }

  List<LibraryItem> _withProgress(List<LibraryItem> items) => [
    for (final item in items)
      if (historyFor(item.novelId) case final ReadingHistory history)
        item.copyWith(
          lastChapterIndex: history.chapterIndex,
          lastReadAt: history.lastReadAt,
        )
      else
        item,
  ];

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
    final revision = _identityRevision;
    final uid = _userId;
    _historyRevision++;
    final now = DateTime.now();
    final updated = ReadingHistory(
      novelId: novel.id,
      lastChapterId: chapter.id,
      scrollOffset: offset.clamp(0, 1).toDouble(),
      lastReadAt: now,
      novel: novel,
      chapterIndex: chapter.chapterIndex,
      chapterTitle: chapter.title,
    );
    await _db.saveHistory(updated, userId: uid);
    if (revision != _identityRevision) return;
    _history = [updated, ..._history.where((h) => h.novelId != novel.id)];

    // Cập nhật tiến độ trong tủ sách mà không cần đọc lại DB.
    _items = [
      for (final item in _items)
        item.novelId == novel.id
            ? item.copyWith(
                lastChapterIndex: chapter.chapterIndex,
                lastReadAt: now,
              )
            : item,
    ];
    if (categoryOf(novel.id) == LibraryCategory.want) {
      _startReadingInBackground(novel, revision);
    }
    notifyListeners();
  }

  void _startReadingInBackground(Novel novel, int identity) {
    final key = (identity: identity, novelId: novel.id);
    if (_shelfRemovalsInFlight.contains(key) ||
        _autoStartsInFlight.contains(key) ||
        !_autoStartAttempts.add(key)) {
      return;
    }
    _autoStartsInFlight.add(key);
    unawaited(() async {
      try {
        await _setCategory(novel.id, LibraryCategory.reading, novel: novel);
      } catch (error) {
        // Tiến độ đã lưu thành công. Lỗi đổi danh mục không được làm hỏng
        // hàng đợi lưu vị trí, cũng không gửi lại yêu cầu ở mỗi lần cuộn.
        debugPrint('Chưa chuyển được truyện sang Đang đọc: $error');
      } finally {
        _autoStartsInFlight.remove(key);
      }
    }());
  }

  /// Xóa 1 mục lịch sử.
  Future<void> deleteHistory(int novelId) async {
    final revision = _identityRevision;
    _historyRevision++;
    await _db.deleteHistory(novelId, userId: _userId);
    if (revision != _identityRevision) return;
    _history = _history.where((h) => h.novelId != novelId).toList();
    final items = await _db.getLibrary(userId: _userId);
    if (revision != _identityRevision) return;
    _items = _withProgress(items);
    notifyListeners();
  }

  /// Xóa toàn bộ lịch sử.
  Future<void> clearHistory() async {
    final revision = _identityRevision;
    _historyRevision++;
    await _db.clearHistory(userId: _userId);
    if (revision != _identityRevision) return;
    _history = [];
    final items = await _db.getLibrary(userId: _userId);
    if (revision != _identityRevision) return;
    _items = _withProgress(items);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Bookmark
  // ---------------------------------------------------------------------------

  /// Bookmark đã tải của truyện (null nếu chưa tải).
  List<Bookmark>? bookmarksOf(int novelId) => _bookmarks[novelId];

  /// Tải bookmark của 1 truyện.
  Future<void> loadBookmarks(int novelId) async {
    final revision = _identityRevision;
    final bookmarks = await _db.getBookmarks(novelId, userId: _userId);
    if (revision != _identityRevision) return;
    _bookmarks[novelId] = bookmarks;
    notifyListeners();
  }

  /// Thêm bookmark tại vị trí [offset] (0..1) của chương.
  Future<void> addBookmark(
    Chapter chapter,
    double offset, {
    String note = '',
  }) async {
    final revision = _identityRevision;
    await _db.addBookmark(
      Bookmark(
        novelId: chapter.novelId,
        chapterId: chapter.id,
        scrollOffset: offset.clamp(0, 1).toDouble(),
        note: note.trim(),
        createdAt: DateTime.now(),
        chapterIndex: chapter.chapterIndex,
        chapterTitle: chapter.title,
      ),
      userId: _userId,
    );
    if (revision != _identityRevision) return;
    await loadBookmarks(chapter.novelId);
  }

  /// Xóa bookmark.
  Future<void> deleteBookmark(Bookmark bookmark) async {
    if (bookmark.id == null) return;
    final revision = _identityRevision;
    await _db.deleteBookmark(bookmark.id!, userId: _userId);
    if (revision != _identityRevision) return;
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
    final revision = _identityRevision;
    if (content.trim().isEmpty) {
      throw ArgumentError('Trích dẫn không được để trống.');
    }
    await _db.addQuote(
      QuoteItem(
        novelId: novel.id,
        novelTitle: novel.title,
        author: novel.author,
        chapterTitle: chapter.title,
        content: content.trim(),
        createdAt: DateTime.now(),
      ),
      userId: _userId,
    );
    if (revision != _identityRevision) return;
    final quotes = await _db.getQuotes(userId: _userId);
    if (revision != _identityRevision) return;
    _quotes = quotes;
    notifyListeners();
  }

  /// Xóa một trích dẫn.
  Future<void> removeQuote(int id) async {
    final revision = _identityRevision;
    await _db.deleteQuote(id, userId: _userId);
    if (revision != _identityRevision) return;
    _quotes = _quotes.where((q) => q.id != id).toList();
    notifyListeners();
  }

  /// Danh sách bình luận đã tải của 1 chương.
  List<ChapterComment> commentsOf(int chapterId) =>
      _comments[chapterId] ?? const [];

  /// Tải bình luận của chương.
  Future<void> loadComments(int chapterId) async {
    final revision = _identityRevision;
    final comments = await _db.getComments(chapterId);
    if (revision != _identityRevision) return;
    _comments[chapterId] = comments;
    notifyListeners();
  }

  /// Gửi bình luận mới cho chương (hỗ trợ gắn chapterIndex cho Spoiler Shield).
  Future<void> addComment({
    required int novelId,
    required int chapterId,
    required String content,
    int stars = 5,
    String userId = '',
    String userName = 'Độc giả',
    int chapterIndex = 1,
  }) async {
    await _db.addComment(
      ChapterComment(
        novelId: novelId,
        chapterId: chapterId,
        userId: userId,
        userName: userName,
        content: content.trim(),
        stars: stars,
        chapterIndex: chapterIndex,
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

  static int _readableWordCount(String content) {
    final text = content
        .replaceAll(RegExp(r'\[img\].*?\[/img\]', dotAll: true), ' ')
        .trim();
    return text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
  }

  /// Gộp thời gian hoạt động, giữ phần lẻ giữa các chương/truyện trong ngày.
  Future<void> recordActiveReading({
    required int novelId,
    required int chapterId,
    required String content,
    required Duration activeDuration,
    String userId = '',
    DateTime? date,
  }) async {
    if (_disposed ||
        activeDuration <= Duration.zero ||
        novelId == 0 ||
        chapterId == 0 ||
        (_userId != null && userId != _userId)) {
      return;
    }
    final identity = _identityRevision;
    final now = date ?? DateTime.now();
    final day = '${now.year}-${now.month}-${now.day}';
    final key = (identity: identity, userId: userId, day: day);
    final chapterKey = (
      identity: identity,
      userId: userId,
      day: day,
      novelId: novelId,
      chapterId: chapterId,
    );
    final elapsed =
        (_chapterActiveTime[chapterKey] ?? Duration.zero) + activeDuration;
    _chapterActiveTime[chapterKey] = elapsed;
    final estimatedWords = (elapsed.inMilliseconds * 220 ~/ 60000).clamp(
      0,
      _readableWordCount(content),
    );
    final newWords = (estimatedWords - (_chapterActiveWords[chapterKey] ?? 0))
        .clamp(0, estimatedWords);
    _chapterActiveWords[chapterKey] = estimatedWords;
    _activeWords[key] = (_activeWords[key] ?? 0) + newWords;
    final accumulated =
        (_activeRemainders[key] ?? Duration.zero) + activeDuration;
    final minutes = accumulated.inMinutes.clamp(0, 120);
    _activeRemainders[key] = accumulated - Duration(minutes: minutes);
    if (minutes == 0) return;
    final words = (_activeWords[key] ?? 0).clamp(0, 100000);
    _activeWords[key] = (_activeWords[key] ?? 0) - words;
    try {
      await _db.recordReadingSession(
        words: words,
        minutes: minutes,
        date: now,
        userId: userId,
        novelId: novelId,
        chapterId: chapterId,
      );
    } catch (_) {
      if (identity == _identityRevision && !_disposed) {
        _activeRemainders[key] =
            (_activeRemainders[key] ?? Duration.zero) +
            Duration(minutes: minutes);
        _activeWords[key] = (_activeWords[key] ?? 0) + words;
      }
      rethrow;
    }
    await _refreshReadingSessions(identity, userId);
  }

  Future<void> _refreshReadingSessions(int identity, String userId) async {
    if (identity != _identityRevision || _disposed) return;
    final request = ++_statsRevision;
    try {
      final sessions = await _db.getReadingSessions(userId: _userId ?? userId);
      if (identity != _identityRevision ||
          request != _statsRevision ||
          _disposed) {
        return;
      }
      _sessions = sessions;
      notifyListeners();
    } catch (error) {
      debugPrint('Phiên đọc đã ghi, chưa tải lại được thống kê: $error');
    }
  }

  /// Ghi nhận 1 chương vừa được mở đọc vào bảng `reading_sessions` (mỗi chương tính 1 lần/phiên).
  Future<void> recordChapterReadSession(
    int chapterId,
    String content, {
    String userId = '',
    int novelId = 0,
  }) {
    if (_userId != null && userId != _userId) return Future<void>.value();
    final key = (
      identity: _identityRevision,
      userId: userId,
      novelId: novelId,
      chapterId: chapterId,
    );
    if (_recordedChapterSessions.contains(key)) return Future<void>.value();
    return _recordingChapterSessions[key] ??=
        _recordChapterSession(key, content).whenComplete(() {
          _recordingChapterSessions.remove(key);
        });
  }

  Future<void> _recordChapterSession(
    _ChapterSessionKey key,
    String content,
  ) async {
    // Bỏ thẻ ảnh để không đếm base64/đường dẫn ảnh thành "từ" của truyện tranh.
    final words = _readableWordCount(content);
    final minutes = (words / 220).ceil().clamp(1, 60);
    await _db.recordReadingSession(
      words: words,
      minutes: minutes,
      userId: key.userId,
      novelId: key.novelId,
      chapterId: key.chapterId,
    );
    // Chỉ đánh dấu sau khi đã ghi local/cloud thành công để có thể thử lại
    // nếu ghi phiên đọc gặp lỗi tạm thời.
    if (key.identity != _identityRevision) return;
    _recordedChapterSessions.add(key);
    await _refreshReadingSessions(key.identity, key.userId);
  }

  /// Xuất dữ liệu cá nhân ra chuỗi JSON.
  Future<String> exportBackupJson() =>
      _db.exportUserBackupJson(userId: _userId);

  /// Nhập dữ liệu cá nhân từ chuỗi JSON và tải lại trạng thái.
  Future<void> importBackupJson(String jsonString) async {
    final revision = _identityRevision;
    await _db.importUserBackupJson(jsonString, userId: _userId);
    if (revision != _identityRevision) return;
    await load();
  }
}
