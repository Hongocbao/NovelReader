import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../models/novel.dart';
import '../utils/constants.dart';

/// Điều kiện truy vấn danh sách truyện.
@immutable
class NovelQuery {
  final String keyword;
  final List<String> genres;
  final String? status;
  final String? type;
  final NovelSort sort;

  const NovelQuery({
    this.keyword = '',
    this.genres = const [],
    this.status,
    this.type,
    this.sort = NovelSort.updated,
  });

  /// Có đang áp dụng bộ lọc nào không (ngoài từ khóa).
  bool get hasFilters => genres.isNotEmpty || status != null || type != null;

  /// [clearStatus]/[clearType] để đặt lại về null.
  NovelQuery copyWith({
    String? keyword,
    List<String>? genres,
    String? status,
    String? type,
    NovelSort? sort,
    bool clearStatus = false,
    bool clearType = false,
  }) {
    return NovelQuery(
      keyword: keyword ?? this.keyword,
      genres: genres ?? this.genres,
      status: clearStatus ? null : (status ?? this.status),
      type: clearType ? null : (type ?? this.type),
      sort: sort ?? this.sort,
    );
  }
}

/// Danh sách truyện có phân trang (infinite scroll + pull-to-refresh).
/// Mỗi màn hình danh sách tạo một [NovelPager] riêng.
class NovelPager extends ChangeNotifier {
  NovelPager(this._db, [NovelQuery query = const NovelQuery()])
    : _query = query;

  final AppDatabase _db;
  NovelQuery _query;
  final List<Novel> _items = [];
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  bool _loadedOnce = false;
  String? _error;

  /// Mã yêu cầu – bỏ qua kết quả cũ khi điều kiện thay đổi liên tục.
  int _requestId = 0;
  bool _disposed = false;

  NovelQuery get query => _query;
  List<Novel> get items => List.unmodifiable(_items);
  bool get isLoading => _loading;
  bool get isLoadingMore => _loadingMore;
  bool get hasMore => _hasMore;
  bool get loadedOnce => _loadedOnce;
  String? get error => _error;

  /// Đổi điều kiện và tải lại từ đầu.
  Future<void> setQuery(NovelQuery query) {
    _query = query;
    return refresh();
  }

  /// Tải lại trang đầu tiên.
  Future<void> refresh() async {
    final id = ++_requestId;
    _loading = true;
    _error = null;
    _notify();
    try {
      final page = await _fetch(0);
      if (id != _requestId) return;
      _items
        ..clear()
        ..addAll(page);
      _hasMore = page.length == AppInfo.pageSize;
    } catch (e) {
      if (id != _requestId) return;
      _error = '${AppStrings.loadFailed}: $e';
    } finally {
      if (id == _requestId) {
        _loading = false;
        _loadingMore = false;
        _loadedOnce = true;
        _notify();
      }
    }
  }

  /// Tải trang kế tiếp khi cuộn gần cuối.
  Future<void> loadMore() async {
    if (_loading || _loadingMore || !_hasMore || _error != null) return;
    final id = _requestId;
    _loadingMore = true;
    _notify();
    try {
      final page = await _fetch(_items.length);
      if (id != _requestId) return;
      _items.addAll(page);
      _hasMore = page.length == AppInfo.pageSize;
    } catch (e) {
      if (id != _requestId) return;
      _error = '${AppStrings.loadFailed}: $e';
    } finally {
      if (id == _requestId) {
        _loadingMore = false;
        _notify();
      }
    }
  }

  /// Thử tải lại trang kế tiếp sau khi phân trang gặp lỗi.
  Future<void> retryLoadMore() async {
    if (_items.isEmpty || _loading || _loadingMore || !_hasMore) return;
    _error = null;
    await loadMore();
  }

  Future<List<Novel>> _fetch(int offset) => _db.queryNovels(
    keyword: _query.keyword,
    genres: _query.genres,
    status: _query.status,
    type: _query.type,
    sort: _query.sort,
    offset: offset,
  );

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// Dữ liệu khám phá: trang chủ, thể loại, tìm kiếm và chi tiết truyện.
class NovelProvider extends ChangeNotifier {
  NovelProvider(this._db, this._prefs)
    : searchPager = NovelPager(_db, const NovelQuery(sort: NovelSort.views)) {
    _searchHistory = _prefs.getStringList(PrefKeys.searchHistory) ?? [];
  }

  final AppDatabase _db;
  final SharedPreferences _prefs;

  // ---- Trang chủ ----
  List<Novel> _featured = [];
  List<Novel> _newest = [];
  List<Novel> _hot = [];
  List<Novel> _completed = [];
  List<Novel> _comics = [];
  bool _homeLoading = false;
  String? _homeError;
  bool _homeLoaded = false;
  int _homeRequestId = 0;

  List<Novel> get featured => _featured;
  List<Novel> get newest => _newest;
  List<Novel> get hot => _hot;
  List<Novel> get completed => _completed;
  List<Novel> get comics => _comics;
  bool get homeLoading => _homeLoading;
  String? get homeError => _homeError;
  bool get homeLoaded => _homeLoaded;

  /// Tải dữ liệu trang chủ (đề cử, mới cập nhật, hot, hoàn thành, truyện tranh).
  Future<void> loadHome() async {
    final requestId = ++_homeRequestId;
    _homeLoading = true;
    _homeError = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _db.queryNovels(sort: NovelSort.rating, limit: 6),
        _db.queryNovels(sort: NovelSort.updated, limit: 12),
        _db.queryNovels(sort: NovelSort.views, limit: 12),
        _db.queryNovels(
          status: NovelStatus.completed,
          sort: NovelSort.rating,
          limit: 12,
        ),
        _db.queryNovels(
          type: NovelType.comic,
          sort: NovelSort.views,
          limit: 12,
        ),
      ]);
      if (requestId != _homeRequestId) return;
      _featured = results[0];
      _newest = results[1];
      _hot = results[2];
      _completed = results[3];
      _comics = results[4];
      _homeLoaded = true;
    } catch (e) {
      if (requestId != _homeRequestId) return;
      _homeError = '${AppStrings.loadFailed}: $e';
    } finally {
      if (requestId == _homeRequestId) {
        _homeLoading = false;
        notifyListeners();
      }
    }
  }

  // ---- Thể loại ----
  Map<String, int> _genreCounts = {};
  bool _genresLoading = false;
  String? _genresError;
  int _genresRequestId = 0;

  Map<String, int> get genreCounts => _genreCounts;
  bool get genresLoading => _genresLoading;
  String? get genresError => _genresError;

  /// Đếm số truyện theo thể loại.
  Future<void> loadGenres() async {
    final requestId = ++_genresRequestId;
    _genresLoading = true;
    _genresError = null;
    notifyListeners();
    try {
      final counts = await _db.genreCounts();
      if (requestId != _genresRequestId) return;
      _genreCounts = counts;
    } catch (e) {
      if (requestId != _genresRequestId) return;
      _genresError = '${AppStrings.loadFailed}: $e';
    } finally {
      if (requestId == _genresRequestId) {
        _genresLoading = false;
        notifyListeners();
      }
    }
  }

  // ---- Tìm kiếm ----
  /// Kết quả tìm kiếm (phân trang).
  final NovelPager searchPager;
  Timer? _debounce;
  List<String> _searchHistory = [];

  List<String> get searchHistory => List.unmodifiable(_searchHistory);
  NovelQuery get searchQuery => searchPager.query;

  /// Gõ từ khóa: đợi 300ms không gõ nữa mới tìm (debounce).
  void onKeywordChanged(String keyword) {
    _debounce?.cancel();
    _debounce = Timer(AppInfo.searchDebounce, () {
      searchPager.setQuery(searchPager.query.copyWith(keyword: keyword.trim()));
    });
  }

  /// Tìm ngay (khi bấm Enter hoặc chọn lịch sử) và lưu lịch sử.
  Future<void> submitKeyword(String keyword) {
    _debounce?.cancel();
    final kw = keyword.trim();
    if (kw.isNotEmpty) _addHistory(kw);
    return searchPager.setQuery(searchPager.query.copyWith(keyword: kw));
  }

  /// Bật/tắt một thể loại trong bộ lọc.
  void toggleGenre(String genre) {
    final genres = [...searchPager.query.genres];
    genres.contains(genre) ? genres.remove(genre) : genres.add(genre);
    searchPager.setQuery(searchPager.query.copyWith(genres: genres));
    notifyListeners();
  }

  /// Lọc trạng thái (null = tất cả).
  void setStatusFilter(String? status) {
    searchPager.setQuery(
      searchPager.query.copyWith(status: status, clearStatus: status == null),
    );
    notifyListeners();
  }

  /// Lọc loại truyện (null = tất cả).
  void setTypeFilter(String? type) {
    searchPager.setQuery(
      searchPager.query.copyWith(type: type, clearType: type == null),
    );
    notifyListeners();
  }

  /// Bỏ toàn bộ bộ lọc (giữ từ khóa).
  void clearFilters() {
    searchPager.setQuery(
      NovelQuery(
        keyword: searchPager.query.keyword,
        sort: searchPager.query.sort,
      ),
    );
    notifyListeners();
  }

  void _addHistory(String keyword) {
    _searchHistory
      ..remove(keyword)
      ..insert(0, keyword);
    if (_searchHistory.length > AppInfo.maxSearchHistory) {
      _searchHistory = _searchHistory.sublist(0, AppInfo.maxSearchHistory);
    }
    _prefs.setStringList(PrefKeys.searchHistory, _searchHistory);
    notifyListeners();
  }

  /// Xóa 1 mục lịch sử tìm kiếm.
  Future<void> removeSearchHistory(String keyword) async {
    _searchHistory.remove(keyword);
    notifyListeners();
    await _prefs.setStringList(PrefKeys.searchHistory, _searchHistory);
  }

  /// Xóa toàn bộ lịch sử tìm kiếm.
  Future<void> clearSearchHistory() async {
    _searchHistory = [];
    notifyListeners();
    await _prefs.remove(PrefKeys.searchHistory);
  }

  // ---- Chi tiết ----
  /// Tạo pager mới cho một màn hình danh sách (thể loại, xem tất cả...).
  NovelPager createPager(NovelQuery query) => NovelPager(_db, query);

  /// Lấy thông tin 1 truyện.
  Future<Novel?> getNovel(int id) => _db.getNovel(id);

  Future<int?> recordNovelView(int id) => _db.recordNovelView(id);

  /// Chấm điểm sao cho bộ truyện và làm mới danh sách Trang chủ / Tìm kiếm.
  Future<double> rateNovel(int novelId, double stars) async {
    final newRating = await _db.updateNovelRating(novelId, stars);
    await Future.wait([loadHome(), searchPager.refresh()]);
    return newRating;
  }

  /// Tạo truyện mới (hoặc tách từ văn bản nhiều chương) rồi làm mới Trang chủ / Tìm kiếm.
  Future<Novel> createCustomNovel({
    required String title,
    required String author,
    required String description,
    required String status,
    required String type,
    required List<String> genres,
    required String rawChaptersText,
    String? coverUrl,
  }) async {
    final parsed = parseChaptersFromText(rawChaptersText);
    final novel = await _db.insertCustomNovel(
      title: title,
      author: author,
      description: description,
      status: status,
      type: type,
      genres: genres,
      chapters: parsed,
      coverUrl: coverUrl,
    );
    await Future.wait([loadHome(), loadGenres(), searchPager.refresh()]);
    return novel;
  }

  /// Thêm chương mới vào bộ truyện hiện có.
  Future<void> addChapterToNovel({
    required int novelId,
    required String title,
    required String content,
    required String requestId,
  }) async {
    await _db.appendChapter(
      novelId: novelId,
      title: title,
      content: content,
      requestId: requestId,
    );
    await Future.wait([loadHome(), searchPager.refresh()]);
  }

  /// Tự động tách văn bản dài thành nhiều chương nếu có dòng tiêu đề dạng
  /// `Chương 1: ...`, `Hồi 1: ...`, `Phần 1: ...`; nếu không có thì gom thành Chương 1.
  static List<({String title, String content})> parseChaptersFromText(
    String raw,
  ) {
    final headerRegex = RegExp(
      r'^(Chương|Hồi|Phần|Quyển)\s+\d+[^\n]*$',
      multiLine: true,
      caseSensitive: false,
    );
    final matches = headerRegex.allMatches(raw).toList();
    if (matches.isEmpty) {
      return [
        (
          title: 'Chương 1: Mở đầu',
          content: raw.trim().isEmpty
              ? 'Nội dung chương đang được cập nhật.'
              : raw.trim(),
        ),
      ];
    }
    final result = <({String title, String content})>[];
    for (var i = 0; i < matches.length; i++) {
      final m = matches[i];
      final title = m.group(0)!.trim();
      final start = m.end;
      final end = (i + 1 < matches.length) ? matches[i + 1].start : raw.length;
      final body = raw.substring(start, end).trim();
      result.add((title: title, content: body.isEmpty ? title : body));
    }
    return result;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchPager.dispose();
    super.dispose();
  }
}
