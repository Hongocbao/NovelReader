import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../models/chapter.dart';
import '../models/chapter_summary.dart';
import '../models/glossary_term.dart';
import '../models/novel.dart';
import '../repositories/reader_extras_source.dart';
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

class DownloadCancelledException implements Exception {
  const DownloadCancelledException();
  @override
  String toString() =>
      'Đã dừng lượt tải do bản tải đã bị xóa hoặc ứng dụng đã đóng.';
}

@immutable
class ReaderSnapshot {
  const ReaderSnapshot({
    required this.novel,
    required this.chapter,
    required this.content,
  });
  final Novel novel;
  final Chapter chapter;
  final String content;
}

/// Quản lý việc đọc: danh sách chương, nội dung chương hiện tại,
/// trạng thái mạng và tải chương để đọc offline.
class ReaderProvider extends ChangeNotifier implements ReaderExtrasSource {
  /// [connectivityStream]/[checkConnectivity] cho phép thay thế khi test.
  ReaderProvider(this._db, {this.connectivityStream, this.checkConnectivity});

  final AppDatabase _db;

  @override
  Future<ReaderExtrasPage<GlossaryTerm>> getGlossaryForReader(
    int novelId,
    int chapterIndex, {
    int version = 0,
    bool offline = false,
  }) => _db.getGlossaryForReader(
    novelId,
    chapterIndex,
    version: version,
    offline: offline || !isOnline,
  );

  @override
  Future<ReaderExtrasPage<ChapterSummary>> getSummariesForReader(
    int novelId,
    int chapterIndex, {
    int version = 0,
    bool offline = false,
  }) => _db.getSummariesForReader(
    novelId,
    chapterIndex,
    version: version,
    offline: offline || !isOnline,
  );
  final Stream<bool>? connectivityStream;
  final Future<bool> Function()? checkConnectivity;
  StreamSubscription<bool>? _connSub;
  bool _disposed = false;
  Future<void>? _initializing;

  void _emit() {
    if (!_disposed) notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Trạng thái mạng
  // ---------------------------------------------------------------------------

  bool _networkAvailable = true;
  bool _forceOffline = false;

  /// Có thể dùng mạng không (có kết nối và không bật offline giả lập).
  bool get isOnline => _networkAvailable && !_forceOffline;

  /// Bắt đầu theo dõi kết nối mạng.
  Future<void> init() => _initializing ??= _initConnectivity();

  Future<void> _initConnectivity() async {
    if (_disposed) return;
    final check = checkConnectivity ?? _defaultCheck;
    final stream =
        connectivityStream ??
        Connectivity().onConnectivityChanged.map(_hasNetwork);
    try {
      _networkAvailable = await check();
    } catch (_) {
      _networkAvailable = true;
    }
    if (_disposed) return;
    _connSub = stream.listen(
      (online) {
        if (_disposed) return;
        if (online == _networkAvailable) return;
        _networkAvailable = online;
        _emit();
      },
      onError: (Object error) {
        if (_disposed) return;
        _networkAvailable = false;
        _emit();
      },
    );
    _emit();
  }

  static Future<bool> _defaultCheck() async =>
      _hasNetwork(await Connectivity().checkConnectivity());

  static bool _hasNetwork(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  /// Được SettingsProvider cập nhật (ChangeNotifierProxyProvider).
  set forceOffline(bool value) {
    if (_disposed || value == _forceOffline) return;
    _forceOffline = value;
    // Trì hoãn notify vì setter được gọi trong lúc build của ProxyProvider.
    scheduleMicrotask(_emit);
  }

  // ---------------------------------------------------------------------------
  // Danh sách chương (cache theo truyện)
  // ---------------------------------------------------------------------------

  final Map<int, List<Chapter>> _chapters = {};
  final Map<int, String> _chapterErrors = {};
  final Set<int> _chaptersLoading = {};
  final _chapterLoads = <int, Future<List<Chapter>>>{};
  final _chapterRequests = <int, int>{};
  final _downloadStatus = <({int novelId, int chapterId}), bool>{};

  /// Danh sách chương đã tải của truyện (null nếu chưa tải).
  List<Chapter>? chaptersOf(int novelId) => _chapters[novelId];
  String? chaptersErrorOf(int novelId) => _chapterErrors[novelId];
  bool isLoadingChapters(int novelId) => _chaptersLoading.contains(novelId);

  /// Tải danh sách chương từ DB.
  Future<List<Chapter>> loadChapters(
    int novelId, {
    bool force = false,
    Novel? novel,
  }) {
    if (_disposed) return Future.value(const []);
    if (!force && _chapterLoads.containsKey(novelId)) {
      return _chapterLoads[novelId]!;
    }
    if (!force && _chapters.containsKey(novelId)) {
      return Future.value(_chapters[novelId]!);
    }
    final request = (_chapterRequests[novelId] ?? 0) + 1;
    _chapterRequests[novelId] = request;
    late final Future<List<Chapter>> operation;
    operation = _loadChapters(novelId, novel, request).whenComplete(() {
      if (identical(_chapterLoads[novelId], operation)) {
        _chapterLoads.remove(novelId);
      }
    });
    _chapterLoads[novelId] = operation;
    return operation;
  }

  Future<List<Chapter>> _loadChapters(
    int novelId,
    Novel? novel,
    int request,
  ) async {
    _chaptersLoading.add(novelId);
    _chapterErrors.remove(novelId);
    _emit();
    try {
      final list = !isOnline && novelId >= 0
          ? await _db.getCachedChapters(novelId)
          : await _db.getChapters(
              novelId,
              novel: novel ?? (_novel?.id == novelId ? _novel : null),
            );
      if (_disposed) return const [];
      if (_chapterRequests[novelId] != request) {
        return await (_chapterLoads[novelId] ??
            Future.value(_chapters[novelId] ?? const []));
      }
      final updated = [
        for (final chapter in list)
          chapter.copyWith(
            isDownloaded:
                _downloadStatus[(novelId: novelId, chapterId: chapter.id)] ??
                chapter.isDownloaded,
          ),
      ];
      _chapters[novelId] = updated;
      return updated;
    } catch (e) {
      if (!_disposed && _chapterRequests[novelId] == request) {
        _chapterErrors[novelId] = '${AppStrings.loadFailed}: $e';
      }
      return const [];
    } finally {
      if (!_disposed && _chapterRequests[novelId] == request) {
        _chaptersLoading.remove(novelId);
        _emit();
      }
    }
  }

  void _updateCachedChapter(int novelId, int chapterId, bool downloaded) {
    if (_disposed) return;
    _downloadStatus[(novelId: novelId, chapterId: chapterId)] = downloaded;
    final list = _chapters[novelId];
    if (list != null) {
      _chapters[novelId] = [
        for (final c in list)
          c.id == chapterId ? c.copyWith(isDownloaded: downloaded) : c,
      ];
    }
    if (_current?.novelId == novelId && _current?.id == chapterId) {
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
  Object? _readerOwner;
  Object? get readerOwner => _readerOwner;

  void releaseReader(Object owner) {
    if (identical(_readerOwner, owner)) _readerOwner = null;
  }

  Novel? get novel => _novel;
  Chapter? get currentChapter => _current;
  String? get content => _content;
  bool get isLoadingContent => _loadingContent;
  String? get contentError => _contentError;

  ReaderSnapshot? captureReader() {
    final book = novel;
    final chapter = currentChapter;
    final text = content;
    if (book == null ||
        chapter?.novelId != book.id ||
        text == null ||
        text.trim().isEmpty ||
        isLoadingContent) {
      return null;
    }
    return ReaderSnapshot(novel: book, chapter: chapter!, content: text);
  }

  /// Khôi phục màn đọc đang nằm dưới màn khác, dùng lại nội dung trong RAM.
  void restoreReader(ReaderSnapshot snapshot, {Object? owner}) {
    if (_disposed) return;
    if (snapshot.chapter.novelId != snapshot.novel.id ||
        snapshot.content.trim().isEmpty) {
      throw ArgumentError('Nội dung khôi phục không thuộc truyện.');
    }
    _contentRequest++;
    _readerOwner = owner;
    _novel = snapshot.novel;
    _current = snapshot.chapter.copyWith(
      isDownloaded:
          _downloadStatus[(
            novelId: snapshot.novel.id,
            chapterId: snapshot.chapter.id,
          )] ??
          snapshot.chapter.isDownloaded,
    );
    _content = snapshot.content;
    _contentError = null;
    _loadingContent = false;
    _emit();
  }

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
  Future<void> openNovel(Novel novel, {int? chapterId, Object? owner}) async {
    if (_disposed) return;
    final request = ++_contentRequest;
    _readerOwner = owner;
    _novel = novel;
    _current = null;
    _content = null;
    _contentError = null;
    _loadingContent = true;
    _emit();
    final chapters = await loadChapters(novel.id, novel: novel);
    if (request != _contentRequest) return;
    if (chapters.isEmpty) {
      _loadingContent = false;
      _contentError = !isOnline
          ? const OfflineException().toString()
          : _chapterErrors[novel.id] ?? AppStrings.noChapters;
      _emit();
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
    if (_disposed) return;
    if (_novel != null && chapter.novelId != _novel!.id) return;
    final request = ++_contentRequest;
    _current = chapter;
    _content = null;
    _contentError = null;
    _loadingContent = true;
    _emit();
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
        _emit();
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
    Chapter? saved;
    try {
      saved = await _db.getChapter(chapter.id, novelId: chapter.novelId);
    } catch (error) {
      if (!isOnline) rethrow;
      debugPrint('Chưa đọc được bản lưu, thử tải nội dung online: $error');
    }
    if (_disposed) throw const DownloadCancelledException();
    if (saved?.novelId == chapter.novelId &&
        saved?.content?.trim().isNotEmpty == true) {
      _updateCachedChapter(chapter.novelId, chapter.id, true);
      return saved!.content!;
    }
    _updateCachedChapter(chapter.novelId, chapter.id, false);
    if (!isOnline) throw const OfflineException();
    return _db.fetchChapterContent(chapter.novelId, chapter.chapterIndex);
  }

  /// Đóng truyện đang đọc (khi thoát màn hình đọc).
  void closeReader() {
    _contentRequest++;
    _readerOwner = null;
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
  int _downloadsRequest = 0;
  int _downloadsRevision = 0;
  int _downloadEpoch = 0;
  final _novelDownloadRevisions = <int, int>{};
  final _downloadJobs = <int, Future<int>>{};
  Future<void> _storageOperation = Future<void>.value();

  Future<T> _mutateStorage<T>(Future<T> Function() action) {
    final next = _storageOperation.then((_) => action());
    _storageOperation = next.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return next;
  }

  bool _downloadCurrent(int novelId, int epoch, int revision) =>
      !_disposed &&
      epoch == _downloadEpoch &&
      revision == (_novelDownloadRevisions[novelId] ?? 0);

  void _cancelDownloads(int? novelId) {
    _downloadsRevision++;
    if (novelId == null) {
      _downloadEpoch++;
      _tasks.clear();
    } else {
      _novelDownloadRevisions[novelId] =
          (_novelDownloadRevisions[novelId] ?? 0) + 1;
      _tasks.remove(novelId);
    }
  }

  DownloadTask? taskOf(int novelId) => _tasks[novelId];
  List<DownloadedChapter> get downloaded => List.unmodifiable(_downloaded);
  bool get downloadsLoading => _downloadsLoading;
  bool get downloadsLoaded => _downloadsLoaded;
  String? get downloadsError => _downloadsError;
  int get downloadedCount => _downloaded.length;
  int get downloadedBytes =>
      _downloaded.fold(0, (sum, d) => sum + d.sizeInBytes);

  /// Tải danh sách chương đã tải (cho màn hình Tải xuống).
  Future<void> loadDownloads() => _readDownloads(reportError: true);

  Future<void> _readDownloads({required bool reportError}) async {
    if (_disposed) return;
    final request = ++_downloadsRequest;
    final revision = _downloadsRevision;
    _downloadsLoading = true;
    if (reportError) _downloadsError = null;
    _emit();
    try {
      final downloaded = await _db.getDownloadedChapters();
      if (_disposed ||
          request != _downloadsRequest ||
          revision != _downloadsRevision) {
        return;
      }
      _downloaded = downloaded;
      _downloadsLoaded = true;
      _downloadsError = null;
    } catch (e) {
      if (!_disposed && request == _downloadsRequest && reportError) {
        _downloadsError = '${AppStrings.loadFailed}: $e';
      }
    } finally {
      if (!_disposed && request == _downloadsRequest) {
        _downloadsLoading = false;
        _emit();
      }
    }
  }

  /// Tải nhiều chương (1 chương, nhiều chương hoặc cả truyện).
  /// Bỏ qua chương đã tải. Trả về số chương tải thành công.
  /// Các yêu cầu cùng truyện chạy nối tiếp, kiểm tra bản lưu thật trước khi tải.
  Future<int> downloadChapters(
    int novelId,
    List<Chapter> chapters, {
    Novel? novel,
  }) {
    if (_disposed) return Future.error(const DownloadCancelledException());
    if (chapters.any((c) => c.novelId != novelId) ||
        (novel != null && novel.id != novelId)) {
      return Future.error(
        ArgumentError('Danh sách chương không thuộc truyện đang tải.'),
      );
    }
    final unique = {for (final ch in chapters) ch.id: ch}.values.toList();
    final epoch = _downloadEpoch;
    final revision = _novelDownloadRevisions[novelId] ?? 0;
    final metadata = novel ?? (_novel?.id == novelId ? _novel : null);
    final previous = _downloadJobs[novelId] ?? Future<int>.value(0);
    late final Future<int> operation;
    operation = previous
        .then<void>((_) {}, onError: (Object _, StackTrace _) {})
        .then((_) => _downloadBatch(novelId, unique, metadata, epoch, revision))
        .whenComplete(() {
          if (identical(_downloadJobs[novelId], operation)) {
            _downloadJobs.remove(novelId);
          }
        });
    _downloadJobs[novelId] = operation;
    return operation;
  }

  Future<int> _downloadBatch(
    int novelId,
    List<Chapter> chapters,
    Novel? novel,
    int epoch,
    int revision,
  ) async {
    void checkCurrent() {
      if (!_downloadCurrent(novelId, epoch, revision)) {
        throw const DownloadCancelledException();
      }
    }

    checkCurrent();
    if (chapters.isEmpty || novelId < 0) return 0;
    var task = DownloadTask(novelId: novelId, total: chapters.length);
    _tasks[novelId] = task;
    _emit();
    var success = 0;
    var completed = 0;
    try {
      for (final ch in chapters) {
        checkCurrent();
        final saved = await _db.getChapter(ch.id, novelId: novelId);
        checkCurrent();
        if (saved?.novelId != novelId ||
            saved?.content?.trim().isNotEmpty != true) {
          if (!isOnline) throw const OfflineException();
          final text = await _db.fetchChapterContent(novelId, ch.chapterIndex);
          checkCurrent();
          if (text.trim().isEmpty) {
            throw StateError(
              'Chương ${ch.chapterIndex} không có nội dung để lưu.',
            );
          }
          await _mutateStorage(() async {
            checkCurrent();
            await _db.saveChapterContent(ch, text, novel: novel);
            _downloadsRevision++;
          });
          checkCurrent();
          success++;
        }
        _updateCachedChapter(novelId, ch.id, true);
        task = task.copyWith(done: ++completed);
        _tasks[novelId] = task;
        _emit();
      }
      _tasks.remove(novelId);
    } catch (e) {
      if (_downloadCurrent(novelId, epoch, revision)) {
        _tasks[novelId] = task.copyWith(running: false, error: e.toString());
      }
      rethrow;
    } finally {
      await _refreshDownloadsSilently();
    }
    return success;
  }

  /// Xóa thông báo lỗi tải của truyện.
  void clearTask(int novelId) {
    if (_tasks[novelId]?.running ?? false) return;
    if (_tasks.remove(novelId) != null) _emit();
  }

  /// Xóa 1 chương đã tải.
  Future<void> deleteDownload(Chapter chapter) async {
    if (_disposed || chapter.novelId < 0) return;
    _cancelDownloads(chapter.novelId);
    await _mutateStorage(() => _db.deleteChapterContent(chapter));
    _downloadsRevision++;
    _updateCachedChapter(chapter.novelId, chapter.id, false);
    await _refreshDownloadsSilently();
    _emit();
  }

  /// Xóa các chương đã tải của 1 truyện, hoặc tất cả nếu [novelId] = null.
  Future<void> deleteDownloads({int? novelId}) async {
    if (_disposed || (novelId != null && novelId < 0)) return;
    _cancelDownloads(novelId);
    await _mutateStorage(() => _db.deleteDownloads(novelId: novelId));
    _downloadsRevision++;
    for (final key in _downloadStatus.keys.toList()) {
      if (key.novelId >= 0 && (novelId == null || key.novelId == novelId)) {
        _downloadStatus[key] = false;
      }
    }
    final ids = novelId == null ? _chapters.keys.toList() : [novelId];
    for (final id in ids) {
      if (id < 0) continue;
      final list = _chapters[id];
      if (list == null) continue;
      for (final chapter in list) {
        _updateCachedChapter(id, chapter.id, false);
      }
    }
    if (_current != null &&
        _current!.novelId >= 0 &&
        (novelId == null || _current!.novelId == novelId)) {
      _current = _current!.copyWith(isDownloaded: false);
    }
    await _refreshDownloadsSilently();
    _emit();
  }

  Future<void> _refreshDownloadsSilently() =>
      _readDownloads(reportError: false);

  @override
  void dispose() {
    _disposed = true;
    _contentRequest++;
    _downloadEpoch++;
    _downloadsRequest++;
    _connSub?.cancel();
    super.dispose();
  }
}
