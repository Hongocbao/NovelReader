import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../models/chapter.dart';
import '../models/novel.dart';
import '../utils/constants.dart';

/// Tiến trình tải xuống của một truyện.
@immutable
class DownloadTask {
  final int novelId;
  final int total;
  final int done;
  final bool running;
  final String? error;

  const DownloadTask({
    required this.novelId,
    required this.total,
    this.done = 0,
    this.running = true,
    this.error,
  });

  /// Tỉ lệ hoàn thành 0..1.
  double get progress => total == 0 ? 1 : done / total;

  DownloadTask copyWith({int? done, bool? running, String? error}) =>
      DownloadTask(
        novelId: novelId,
        total: total,
        done: done ?? this.done,
        running: running ?? this.running,
        error: error ?? this.error,
      );
}

/// Ngoại lệ khi cần mạng nhưng đang offline.
class OfflineException implements Exception {
  const OfflineException();
  @override
  String toString() => AppStrings.chapterOfflineError;
}

/// Quản lý việc đọc: danh sách chương, nội dung chương hiện tại,
/// trạng thái mạng và tải chương để đọc offline.
class ReaderProvider extends ChangeNotifier {
  /// [connectivityStream]/[checkConnectivity] cho phép thay thế khi test.
  ReaderProvider(this._db, {this.connectivityStream, this.checkConnectivity});

  final AppDatabase _db;
  final Stream<bool>? connectivityStream;
  final Future<bool> Function()? checkConnectivity;
  StreamSubscription<bool>? _connSub;

  // ---------------------------------------------------------------------------
  // Trạng thái mạng
  // ---------------------------------------------------------------------------

  bool _networkAvailable = true;
  bool _forceOffline = false;

  /// Có thể dùng mạng không (có kết nối và không bật offline giả lập).
  bool get isOnline => _networkAvailable && !_forceOffline;

  /// Bắt đầu theo dõi kết nối mạng.
  Future<void> init() async {
    final check = checkConnectivity ?? _defaultCheck;
    final stream =
        connectivityStream ??
        Connectivity().onConnectivityChanged.map(_hasNetwork);
    try {
      _networkAvailable = await check();
    } catch (_) {
      _networkAvailable = true;
    }
    _connSub = stream.listen((online) {
      if (online == _networkAvailable) return;
      _networkAvailable = online;
      notifyListeners();
    });
    notifyListeners();
  }

  static Future<bool> _defaultCheck() async =>
      _hasNetwork(await Connectivity().checkConnectivity());

  static bool _hasNetwork(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  /// Được SettingsProvider cập nhật (ChangeNotifierProxyProvider).
  set forceOffline(bool value) {
    if (value == _forceOffline) return;
    _forceOffline = value;
    // Trì hoãn notify vì setter được gọi trong lúc build của ProxyProvider.
    scheduleMicrotask(notifyListeners);
  }

  // ---------------------------------------------------------------------------
  // Danh sách chương (cache theo truyện)
  // ---------------------------------------------------------------------------

  final Map<int, List<Chapter>> _chapters = {};
  final Map<int, String> _chapterErrors = {};
  final Set<int> _chaptersLoading = {};

  /// Danh sách chương đã tải của truyện (null nếu chưa tải).
  List<Chapter>? chaptersOf(int novelId) => _chapters[novelId];
  String? chaptersErrorOf(int novelId) => _chapterErrors[novelId];
  bool isLoadingChapters(int novelId) => _chaptersLoading.contains(novelId);

  /// Tải danh sách chương từ DB.
  Future<List<Chapter>> loadChapters(
    int novelId, {
    bool force = false,
    Novel? novel,
  }) async {
    if (!force && _chapters.containsKey(novelId)) return _chapters[novelId]!;
    _chaptersLoading.add(novelId);
    _chapterErrors.remove(novelId);
    notifyListeners();
    try {
      final list = !isOnline && novelId >= 0
          ? await _db.getCachedChapters(novelId)
          : await _db.getChapters(
              novelId,
              novel: novel ?? (_novel?.id == novelId ? _novel : null),
            );
      _chapters[novelId] = list;
      return list;
    } catch (e) {
      _chapterErrors[novelId] = '${AppStrings.loadFailed}: $e';
      return const [];
    } finally {
      _chaptersLoading.remove(novelId);
      notifyListeners();
    }
  }

  void _updateCachedChapter(int novelId, int chapterId, bool downloaded) {
    final list = _chapters[novelId];
    if (list == null) return;
    _chapters[novelId] = [
      for (final c in list)
        c.id == chapterId ? c.copyWith(isDownloaded: downloaded) : c,
    ];
    if (_current?.id == chapterId) {
      _current = _current!.copyWith(isDownloaded: downloaded);
    }
  }

  // ---------------------------------------------------------------------------
  // Đọc chương
  // ---------------------------------------------------------------------------

  Novel? _novel;
  Chapter? _current;
  String? _content;
  bool _loadingContent = false;
  String? _contentError;
  int _contentRequest = 0;

  Novel? get novel => _novel;
  Chapter? get currentChapter => _current;
  String? get content => _content;
  bool get isLoadingContent => _loadingContent;
  String? get contentError => _contentError;

  /// Danh sách chương của truyện đang đọc.
  List<Chapter> get currentChapters =>
      _novel == null ? const [] : (_chapters[_novel!.id] ?? const []);

  int get _currentPos => _current == null
      ? -1
      : currentChapters.indexWhere((c) => c.id == _current!.id);

  Chapter? get previousChapter {
    final i = _currentPos;
    return i > 0 ? currentChapters[i - 1] : null;
  }

  Chapter? get nextChapter {
    final i = _currentPos;
    return (i >= 0 && i < currentChapters.length - 1)
        ? currentChapters[i + 1]
        : null;
  }

  /// Mở truyện tại chương [chapterId] (mặc định chương đầu).
  Future<void> openNovel(Novel novel, {int? chapterId}) async {
    final request = ++_contentRequest;
    _novel = novel;
    _current = null;
    _content = null;
    _contentError = null;
    _loadingContent = true;
    notifyListeners();
    final chapters = await loadChapters(novel.id, novel: novel);
    if (request != _contentRequest) return;
    if (chapters.isEmpty) {
      _loadingContent = false;
      _contentError = !isOnline
          ? const OfflineException().toString()
          : _chapterErrors[novel.id] ?? AppStrings.noChapters;
      notifyListeners();
      return;
    }
    final target = chapters.firstWhere(
      (c) => c.id == chapterId,
      orElse: () => chapters.first,
    );
    await openChapter(target);
  }

  /// Mở 1 chương: lấy nội dung từ DB nếu đã tải, nếu chưa thì "tải online".
  Future<void> openChapter(Chapter chapter) async {
    final request = ++_contentRequest;
    _current = chapter;
    _content = null;
    _contentError = null;
    _loadingContent = true;
    notifyListeners();
    try {
      final text = await _loadContent(chapter);
      if (request != _contentRequest) return;
      _content = text;
    } catch (e) {
      if (request != _contentRequest) return;
      _contentError = e is OfflineException
          ? e.toString()
          : '${AppStrings.loadFailed}: $e';
    } finally {
      if (request == _contentRequest) {
        _loadingContent = false;
        notifyListeners();
      }
    }
  }

  /// Thử tải lại chương hiện tại.
  Future<void> retry() async {
    if (_current != null) {
      await openChapter(_current!);
    } else if (_novel != null) {
      await openNovel(_novel!);
    }
  }

  Future<String> _loadContent(Chapter chapter) async {
    if (chapter.isDownloaded) {
      final saved = await _db.getChapter(chapter.id, novelId: chapter.novelId);
      if (saved?.content != null) return saved!.content!;
    }
    if (!isOnline) throw const OfflineException();
    return _db.fetchChapterContent(chapter.novelId, chapter.chapterIndex);
  }

  /// Đóng truyện đang đọc (khi thoát màn hình đọc).
  void closeReader() {
    _contentRequest++;
    _novel = null;
    _current = null;
    _content = null;
    _contentError = null;
    _loadingContent = false;
  }

  // ---------------------------------------------------------------------------
  // Tải xuống (offline)
  // ---------------------------------------------------------------------------

  final Map<int, DownloadTask> _tasks = {};
  List<DownloadedChapter> _downloaded = [];
  bool _downloadsLoading = false;
  bool _downloadsLoaded = false;
  String? _downloadsError;

  DownloadTask? taskOf(int novelId) => _tasks[novelId];
  List<DownloadedChapter> get downloaded => List.unmodifiable(_downloaded);
  bool get downloadsLoading => _downloadsLoading;
  bool get downloadsLoaded => _downloadsLoaded;
  String? get downloadsError => _downloadsError;
  int get downloadedCount => _downloaded.length;
  int get downloadedBytes =>
      _downloaded.fold(0, (sum, d) => sum + d.sizeInBytes);

  /// Tải danh sách chương đã tải (cho màn hình Tải xuống).
  Future<void> loadDownloads() async {
    _downloadsLoading = true;
    _downloadsError = null;
    notifyListeners();
    try {
      _downloaded = await _db.getDownloadedChapters();
      _downloadsLoaded = true;
    } catch (e) {
      _downloadsError = '${AppStrings.loadFailed}: $e';
    } finally {
      _downloadsLoading = false;
      notifyListeners();
    }
  }

  /// Tải nhiều chương (1 chương, nhiều chương hoặc cả truyện).
  /// Bỏ qua chương đã tải. Trả về số chương tải thành công.
  /// Ném [OfflineException] nếu không có mạng.
  Future<int> downloadChapters(
    int novelId,
    List<Chapter> chapters, {
    Novel? novel,
  }) async {
    if (_tasks[novelId]?.running ?? false) return 0;
    if (!isOnline) throw const OfflineException();
    final pending = chapters.where((c) => !c.isDownloaded).toList();
    if (pending.isEmpty) return 0;

    var task = DownloadTask(novelId: novelId, total: pending.length);
    _tasks[novelId] = task;
    notifyListeners();
    var success = 0;
    try {
      for (final ch in pending) {
        if (!isOnline) throw const OfflineException();
        final text = await _db.fetchChapterContent(novelId, ch.chapterIndex);
        await _db.saveChapterContent(
          ch,
          text,
          novel: novel ?? (_novel?.id == novelId ? _novel : null),
        );
        _updateCachedChapter(novelId, ch.id, true);
        success++;
        task = task.copyWith(done: success);
        _tasks[novelId] = task;
        notifyListeners();
      }
      _tasks.remove(novelId);
    } catch (e) {
      _tasks[novelId] = task.copyWith(running: false, error: e.toString());
      rethrow;
    } finally {
      await _refreshDownloadsSilently();
      notifyListeners();
    }
    return success;
  }

  /// Xóa thông báo lỗi tải của truyện.
  void clearTask(int novelId) {
    if (_tasks.remove(novelId) != null) notifyListeners();
  }

  /// Xóa 1 chương đã tải.
  Future<void> deleteDownload(Chapter chapter) async {
    await _db.deleteChapterContent(chapter);
    _updateCachedChapter(chapter.novelId, chapter.id, false);
    await _refreshDownloadsSilently();
    notifyListeners();
  }

  /// Xóa các chương đã tải của 1 truyện, hoặc tất cả nếu [novelId] = null.
  Future<void> deleteDownloads({int? novelId}) async {
    await _db.deleteDownloads(novelId: novelId);
    final ids = novelId == null ? _chapters.keys.toList() : [novelId];
    for (final id in ids) {
      final list = _chapters[id];
      if (list == null) continue;
      _chapters[id] = [for (final c in list) c.copyWith(isDownloaded: false)];
    }
    if (_current != null && (novelId == null || _current!.novelId == novelId)) {
      _current = _current!.copyWith(isDownloaded: false);
    }
    await _refreshDownloadsSilently();
    notifyListeners();
  }

  Future<void> _refreshDownloadsSilently() async {
    try {
      _downloaded = await _db.getDownloadedChapters();
      _downloadsLoaded = true;
    } catch (_) {
      // Giữ danh sách cũ nếu lỗi; màn hình Tải xuống có nút thử lại.
    }
  }

  @override
  void dispose() {
    _connSub?.cancel();
    super.dispose();
  }
}
