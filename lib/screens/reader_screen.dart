import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../models/bookmark.dart';
import '../models/chapter.dart';
import '../models/novel.dart';
import '../models/reader_settings.dart';
import '../providers/library_provider.dart';
import '../providers/reader_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../utils/format.dart';
import '../utils/tts_helper.dart';
import '../widgets/chapter_tile.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/reader/comment_section.dart';
import '../widgets/reader/paragraph_view.dart';
import '../widgets/reader/xray_and_quote_sheets.dart';
import '../widgets/reader_settings_sheet.dart';
import '../widgets/reader_toolbar.dart';
import 'user/advanced_reader_sheets.dart';

/// Màn hình đọc truyện (`ReaderScreen`):
/// - Hỗ trợ cả 2 chế độ: **Cuộn dọc** (`SingleChildScrollView`) và **Lật trang ngang** (`PageView`).
/// - Tích hợp TTS (`flutter_tts` trên Android/iOS & Web Speech API trên Web) với completion callback
///   chính xác và cuộn tới đúng widget đoạn văn bằng `Scrollable.ensureVisible`.
/// - Tự lưu & khôi phục vị trí đọc theo tỉ lệ `0.0 .. 1.0`, ghi nhận thống kê vào `reading_sessions`.
class ReaderScreen extends StatefulWidget {
  final Novel novel;
  final int? initialChapterId;
  final double initialScrollOffset;

  const ReaderScreen({
    super.key,
    required this.novel,
    this.initialChapterId,
    this.initialScrollOffset = 0,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final ScrollController _scrollCtrl = ScrollController();
  final PageController _pageCtrl = PageController();
  final FocusNode _keyFocusNode = FocusNode();
  final Map<int, GlobalKey> _paragraphKeys = {};
  Timer? _saveDebounce;
  Timer? _autoScrollTimer;

  bool _showToolbar = true;
  bool _isAutoScrolling = false;
  double _autoScrollSpeed = 1.5;
  bool _isListening = false;
  int _speakingParagraphIndex = -1;
  int _ttsSessionId = 0;
  String _searchKeyword = '';
  double _currentRatio = 0;
  double? _pendingRestoreRatio;
  int? _restoredForChapterId;
  int? _loadedCommentsForChapterId;
  bool _lastKeepOn = false;

  late ReaderProvider _readerProvider;
  late LibraryProvider _libraryProvider;

  @override
  void initState() {
    super.initState();
    _currentRatio = widget.initialScrollOffset.clamp(0, 1).toDouble();
    _pendingRestoreRatio = _currentRatio;
    _scrollCtrl.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      _applyWakelock(context.read<SettingsProvider>().reader.keepScreenOn);
      await _libraryProvider.loadBookmarks(widget.novel.id);
      if ( _readerProvider.currentChapter?.id != widget.initialChapterId ||
          _readerProvider.content == null) {
        await _readerProvider.openNovel(
          widget.novel,
          chapterId: widget.initialChapterId,
        );
      }
      if (mounted) _persistNow();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _readerProvider = context.read<ReaderProvider>();
    _libraryProvider = context.read<LibraryProvider>();
    final keepOn = context.read<SettingsProvider>().reader.keepScreenOn;
    if (keepOn != _lastKeepOn) {
      _applyWakelock(keepOn);
    }
  }

  void _applyWakelock(bool enable) {
    _lastKeepOn = enable;
    unawaited(
      WakelockPlus.toggle(enable: enable).catchError((_) {}),
    );
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final max = _scrollCtrl.position.maxScrollExtent;
    final nextRatio =
        max <= 0 ? 0.0 : (_scrollCtrl.offset / max).clamp(0.0, 1.0);
    if ((nextRatio - _currentRatio).abs() >= 0.01) {
      setState(() => _currentRatio = nextRatio);
    } else {
      _currentRatio = nextRatio;
    }
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 400), _persistNow);
  }

  void _toggleAutoScroll() {
    if (_isAutoScrolling) {
      _stopAutoScroll();
      return;
    }
    setState(() {
      _isAutoScrolling = true;
      _showToolbar = false;
    });
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (!mounted || !_scrollCtrl.hasClients) return;
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent) {
        _stopAutoScroll();
        return;
      }
      final nextOffset =
          (pos.pixels + _autoScrollSpeed * 1.4).clamp(0.0, pos.maxScrollExtent);
      _scrollCtrl.jumpTo(nextOffset);
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
    if (_isAutoScrolling && mounted) {
      setState(() => _isAutoScrolling = false);
    }
  }

  /// Bật/tắt chế độ Nghe đọc chương bằng completion callback chính xác (không dùng Timer ước lượng).
  void _toggleListen() {
    if (_isListening) {
      _stopListen();
      return;
    }
    final text = _readerProvider.content;
    if (text == null || text.isEmpty) return;
    final paragraphs = text
        .split('\n')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty && !readerInlineImgPattern.hasMatch(p))
        .toList();
    if (paragraphs.isEmpty) return;

    final session = ++_ttsSessionId;
    setState(() {
      _isListening = true;
      _speakingParagraphIndex = 0;
    });
    _speakCurrentParagraph(paragraphs, session);
  }

  void _speakCurrentParagraph(List<String> paragraphs, int session) {
    if (!mounted ||
        !_isListening ||
        session != _ttsSessionId ||
        _speakingParagraphIndex < 0 ||
        _speakingParagraphIndex >= paragraphs.length) {
      _stopListen();
      return;
    }
    final currentText = paragraphs[_speakingParagraphIndex];

    // Cuộn tới vị trí thật của đoạn văn đang đọc bằng GlobalKey
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _paragraphKeys[_speakingParagraphIndex]?.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 350),
          alignment: 0.25,
          curve: Curves.easeOut,
        );
      }
    });

    speakTextPlatform(
      currentText,
      onComplete: () {
        if (!mounted || !_isListening || session != _ttsSessionId) return;
        setState(() => _speakingParagraphIndex++);
        _speakCurrentParagraph(paragraphs, session);
      },
    );
  }

  void _stopListen() {
    _ttsSessionId++;
    stopSpeechPlatform();
    if (mounted && (_isListening || _speakingParagraphIndex != -1)) {
      setState(() {
        _isListening = false;
        _speakingParagraphIndex = -1;
      });
    }
  }

  Future<void> _showSearchInChapterDialog() async {
    final ctrl = TextEditingController(text: _searchKeyword);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.searchInChapter),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: AppStrings.searchInChapterHint,
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          if (_searchKeyword.isNotEmpty)
            TextButton(
              onPressed: () => Navigator.pop(ctx, ''),
              child: const Text('Bỏ tô sáng'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
    if (result != null && mounted) {
      setState(() => _searchKeyword = result.trim());
    }
  }

  void _showXraySheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReaderXraySheet(
        novel: widget.novel,
        chapter: _readerProvider.currentChapter,
        content: _readerProvider.content ?? '',
        onSelectEntity: (entity) => setState(() => _searchKeyword = entity),
      ),
    );
  }

  void _showQuoteCardSheet(Chapter chapter, String paragraph) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReaderQuoteSheet(
        novel: widget.novel,
        chapter: chapter,
        paragraph: paragraph,
        onSaveQuote: () => _libraryProvider.saveQuote(
          novel: widget.novel,
          chapter: chapter,
          content: paragraph,
        ),
      ),
    );
  }

  void _persistNow() {
    final ch = _readerProvider.currentChapter;
    if (ch == null) return;
    _libraryProvider.saveProgress(widget.novel, ch, _currentRatio);
  }

  void _scheduleRestoreIfNeeded(Chapter chapter, bool horizontalMode, int pageCount) {
    if (_restoredForChapterId == chapter.id && _pendingRestoreRatio == null) {
      return;
    }
    final targetRatio = _pendingRestoreRatio ?? _currentRatio;
    _pendingRestoreRatio = null;
    _restoredForChapterId = chapter.id;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (horizontalMode && _pageCtrl.hasClients && pageCount > 1) {
        final targetPage =
            (targetRatio * (pageCount - 1)).round().clamp(0, pageCount - 1);
        _pageCtrl.jumpToPage(targetPage);
      } else if (_scrollCtrl.hasClients) {
        final max = _scrollCtrl.position.maxScrollExtent;
        final target = (max * targetRatio).clamp(0.0, max);
        _scrollCtrl.jumpTo(target);
      }
      _currentRatio = targetRatio;
      _persistNow();
    });
  }

  Future<void> _switchChapter(Chapter chapter, {double offset = 0}) async {
    _stopListen();
    _stopAutoScroll();
    _persistNow();
    _paragraphKeys.clear();
    _currentRatio = offset;
    _pendingRestoreRatio = offset;
    _restoredForChapterId = null;
    await _readerProvider.openChapter(chapter);
  }

  Future<void> _addBookmarkDialog() async {
    final ch = _readerProvider.currentChapter;
    if (ch == null) return;
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.addBookmark),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: AppStrings.bookmarkNoteHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await _libraryProvider.addBookmark(ch, _currentRatio, note: ctrl.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.bookmarkAdded)),
      );
    }
  }

  void _showBookmarksSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Consumer<LibraryProvider>(
        builder: (ctx, lp, _) {
          final list = lp.bookmarksOf(widget.novel.id) ?? const <Bookmark>[];
          if (list.isEmpty) {
            return const SizedBox(
              height: 240,
              child: EmptyView(
                message: AppStrings.noBookmarks,
                icon: Icons.bookmark_border,
              ),
            );
          }
          return SafeArea(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (_, i) {
                final b = list[i];
                return ListTile(
                  leading: const Icon(Icons.bookmark_rounded),
                  title: Text(
                    b.chapterTitle ?? 'Chương ${b.chapterIndex ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    [
                      'Vị trí ${Format.percent(b.scrollOffset)}',
                      if (b.note.isNotEmpty) b.note,
                    ].join(' • '),
                  ),
                  trailing: IconButton(
                    tooltip: AppStrings.delete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => lp.deleteBookmark(b),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    final target = _readerProvider.currentChapters
                        .where((c) => c.id == b.chapterId)
                        .firstOrNull;
                    if (target != null) {
                      _switchChapter(target, offset: b.scrollOffset);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showTocSheet() {
    final chapters = _readerProvider.currentChapters;
    final currentId = _readerProvider.currentChapter?.id;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        maxChildSize: 0.9,
        builder: (_, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                '${AppStrings.tableOfContents} (${chapters.length})',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: chapters.length,
                itemBuilder: (_, i) {
                  final ch = chapters[i];
                  return ChapterTile(
                    chapter: ch,
                    isCurrent: ch.id == currentId,
                    onTap: () {
                      Navigator.pop(ctx);
                      _switchChapter(ch);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ReaderSettingsSheet(),
    );
  }

  Future<void> _downloadCurrent() async {
    final ch = _readerProvider.currentChapter;
    if (ch == null) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _readerProvider.downloadChapters(widget.novel.id, [ch]);
      messenger.showSnackBar(
        const SnackBar(content: Text(AppStrings.downloadDone)),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(e is OfflineException ? AppStrings.needOnline : '$e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _stopListen();
    _autoScrollTimer?.cancel();
    _saveDebounce?.cancel();
    _persistNow();
    _applyWakelock(false);
    _keyFocusNode.dispose();
    _pageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<ReaderProvider>();
    final settings = context.watch<SettingsProvider>().reader;
    final chapter = rp.currentChapter;
    final bg = settings.background;

    final paragraphs = (rp.content ?? '')
        .split('\n')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    final pageCount = ReaderHorizontalPager.paginate(paragraphs).length;

    if (chapter != null && rp.content != null && !rp.isLoadingContent) {
      _scheduleRestoreIfNeeded(chapter, settings.horizontalPageMode, pageCount);
      if (_loadedCommentsForChapterId != chapter.id) {
        _loadedCommentsForChapterId = chapter.id;
        final contentSnapshot = rp.content!;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _libraryProvider.loadComments(chapter.id);
          _libraryProvider.recordChapterReadSession(chapter.id, contentSnapshot);
        });
      }
    }

    return KeyboardListener(
      focusNode: _keyFocusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is! KeyDownEvent) return;
        final key = event.logicalKey;
        if (key == LogicalKeyboardKey.escape) {
          Navigator.of(context).pop();
        } else if (key == LogicalKeyboardKey.space) {
          _toggleAutoScroll();
        } else if (key == LogicalKeyboardKey.arrowLeft &&
            rp.previousChapter != null) {
          _switchChapter(rp.previousChapter!);
        } else if (key == LogicalKeyboardKey.arrowRight &&
            rp.nextChapter != null) {
          _switchChapter(rp.nextChapter!);
        }
      },
      child: Scaffold(
        backgroundColor: bg.background,
        body: OrientationBuilder(
          builder: (context, _) {
            if (chapter != null && rp.content != null) {
              _pendingRestoreRatio ??= _currentRatio;
              _scheduleRestoreIfNeeded(
                chapter,
                settings.horizontalPageMode,
                pageCount,
              );
            }
            return Stack(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (_isAutoScrolling) {
                      _stopAutoScroll();
                    } else {
                      setState(() => _showToolbar = !_showToolbar);
                    }
                  },
                  child: SafeArea(
                    child: _buildBody(rp, chapter, paragraphs, settings),
                  ),
                ),
                // Nút Quay lại nổi cố định ở góc trên trái khi thanh công cụ đang ẩn
                if (!_showToolbar)
                  Positioned(
                    top: 10,
                    left: 12,
                    child: SafeArea(
                      bottom: false,
                      child: Semantics(
                        button: true,
                        label: 'Quay lại màn hình trước',
                        child: Material(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0.72),
                          shape: const CircleBorder(),
                          elevation: 2,
                          child: IconButton(
                            tooltip: 'Quay lại (Esc)',
                            icon:
                                const Icon(Icons.arrow_back_rounded, size: 20),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_searchKeyword.isNotEmpty && !_showToolbar)
                  Positioned(
                    top: 12,
                    right: 14,
                    child: SafeArea(
                      bottom: false,
                      child: InputChip(
                        label: Text('Đang tô sáng: "$_searchKeyword"'),
                        onDeleted: () => setState(() => _searchKeyword = ''),
                      ),
                    ),
                  ),
                if (_isAutoScrolling)
                  Positioned(
                    bottom: 24,
                    left: 20,
                    right: 20,
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(28),
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: 0.94),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.slow_motion_video_rounded,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_autoScrollSpeed.toStringAsFixed(1)}x',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: _autoScrollSpeed,
                                min: 0.5,
                                max: 4.0,
                                divisions: 7,
                                onChanged: (v) =>
                                    setState(() => _autoScrollSpeed = v),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Dừng tự cuộn',
                              icon: const Icon(
                                Icons.pause_circle_filled_rounded,
                              ),
                              onPressed: _stopAutoScroll,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (!_showToolbar && chapter != null && rp.content != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: _buildMiniStatusFooter(
                        chapter,
                        rp.content!,
                        settings,
                      ),
                    ),
                  ),
                if (settings.brightness < 1.0)
                  IgnorePointer(
                    child: Container(
                      color: AppColors.dimOverlay.withValues(
                        alpha: (1.0 - settings.brightness).clamp(0.0, 0.75),
                      ),
                    ),
                  ),
                if (_showToolbar)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ReaderTopBar(
                      novelTitle: widget.novel.title,
                      chapterTitle: chapter?.title ?? '',
                      isDownloaded: chapter?.isDownloaded ?? false,
                      isListening: _isListening,
                      onBack: () => Navigator.of(context).pop(),
                      onToggleListen: _toggleListen,
                      onSearchInChapter: _showSearchInChapterDialog,
                      onOpenXray: _showXraySheet,
                      onAddBookmark: _addBookmarkDialog,
                      onShowBookmarks: _showBookmarksSheet,
                      onDownload: _downloadCurrent,
                    ),
                  ),
                if (_showToolbar)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ReaderBottomBar(
                      hasPrev: rp.previousChapter != null,
                      hasNext: rp.nextChapter != null,
                      isAutoScrolling: _isAutoScrolling,
                      onPrev: rp.previousChapter == null
                          ? null
                          : () => _switchChapter(rp.previousChapter!),
                      onNext: rp.nextChapter == null
                          ? null
                          : () => _switchChapter(rp.nextChapter!),
                      onToggleAutoScroll: _toggleAutoScroll,
                      onOpenToc: _showTocSheet,
                      onOpenSettings: _showSettingsSheet,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    ReaderProvider rp,
    Chapter? chapter,
    List<String> paragraphs,
    ReaderSettings settings,
  ) {
    if (rp.isLoadingContent) {
      return const LoadingView();
    }
    if (rp.contentError != null) {
      return ErrorView(
        message: rp.contentError!,
        icon: rp.isOnline ? Icons.error_outline : Icons.cloud_off,
        onRetry: rp.retry,
      );
    }
    if (chapter == null || paragraphs.isEmpty) {
      return const EmptyView();
    }

    final footer = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFavoriteParagraphHighlight(paragraphs, settings),
        const SizedBox(height: 14),
        _buildChapterNavButtons(rp),
        const SizedBox(height: 28),
        ReaderCommentSection(
          novelId: widget.novel.id,
          chapter: chapter,
          settings: settings,
        ),
      ],
    );

    if (settings.horizontalPageMode) {
      final totalPages = ReaderHorizontalPager.paginate(paragraphs).length;
      return ReaderHorizontalPager(
        chapter: chapter,
        paragraphs: paragraphs,
        settings: settings,
        controller: _pageCtrl,
        speakingParagraphIndex: _speakingParagraphIndex,
        isListening: _isListening,
        searchKeyword: _searchKeyword,
        onPageChanged: (pageIdx) {
          final ratio = totalPages <= 1 ? 0.0 : pageIdx / (totalPages - 1);
          setState(() => _currentRatio = ratio);
          _saveDebounce?.cancel();
          _saveDebounce = Timer(const Duration(milliseconds: 400), _persistNow);
        },
        onLongPressQuote: (p) => _showQuoteCardSheet(chapter, p),
        onTapImage: _openImageViewer,
        footer: footer,
      );
    }

    var textParagraphIdx = -1;
    return SingleChildScrollView(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 64, 20, 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            chapter.title,
            textScaler: MediaQuery.textScalerOf(context),
            style: settings.textStyle.copyWith(
              fontSize: settings.fontSize + 4,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildV2ReaderToolsBar(chapter, rp.content ?? ''),
          const SizedBox(height: 10),
          RecapBannerCard(
            novelId: widget.novel.id,
            currentChapterIndex: chapter.chapterIndex,
          ),
          const SizedBox(height: 12),
          for (final p in paragraphs)
            Builder(
              builder: (_) {
                final isImg = readerInlineImgPattern.hasMatch(p);
                int? currentTextIdx;
                if (!isImg) {
                  textParagraphIdx++;
                  currentTextIdx = textParagraphIdx;
                }
                final key = currentTextIdx == null
                    ? null
                    : (_paragraphKeys[currentTextIdx] ??= GlobalKey());
                final isSpeakingThis = _isListening &&
                    currentTextIdx != null &&
                    currentTextIdx == _speakingParagraphIndex;
                return ReaderParagraphView(
                  key: key,
                  chapter: chapter,
                  paragraph: p,
                  settings: settings,
                  isSpeaking: isSpeakingThis,
                  searchKeyword: _searchKeyword,
                  onLongPressQuote: () => _showQuoteCardSheet(chapter, p),
                  onTapImage: _openImageViewer,
                );
              },
            ),
          const SizedBox(height: 24),
          footer,
        ],
      ),
    );
  }

  Widget _buildMiniStatusFooter(
    Chapter chapter,
    String text,
    ReaderSettings settings,
  ) {
    final wordCount = text.split(RegExp(r'\s+')).length;
    final remainingWords = (wordCount * (1.0 - _currentRatio)).round();
    final remainingMinutes = (remainingWords / 220).ceil().clamp(1, 99);
    final textColor = settings.background.textColor.withValues(alpha: 0.65);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      color: settings.background.background.withValues(alpha: 0.88),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: _currentRatio,
            minHeight: 2,
            backgroundColor: textColor.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ch.${chapter.chapterIndex}/${widget.novel.totalChapters} • $wordCount từ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: textColor),
                ),
              ),
              Text(
                '${Format.percent(_currentRatio)} • còn ~$remainingMinutes phút đọc',
                style: TextStyle(fontSize: 11, color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openImageViewer(String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: url,
                errorWidget: (_, _, _) => const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white70,
                  size: 64,
                  semanticLabel: 'Ảnh minh họa bị lỗi',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildV2ReaderToolsBar(Chapter chapter, String fullText) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        ActionChip(
          avatar: const Icon(Icons.menu_book_outlined, size: 16),
          label: const Text('Từ điển thuật ngữ'),
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            builder: (_) => GlossarySheet(
              novelId: widget.novel.id,
              currentChapterIndex: chapter.chapterIndex,
            ),
          ),
        ),
        ActionChip(
          avatar: const Icon(Icons.bolt, size: 16),
          label: const Text('Đọc nhanh RSVP'),
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) => RsvpSpeedReaderDialog(text: fullText),
          ),
        ),
        ActionChip(
          avatar: const Icon(Icons.headphones_outlined, size: 16),
          label: const Text('Ambient & Hộp thư thời gian'),
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => AmbientAndCapsuleSheet(
              novelId: widget.novel.id,
              chapterId: chapter.id,
              genres: widget.novel.genres,
              onSetSleepTimerMinutes: (mins) {
                if (mins != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '⏲️ Đã đặt hẹn giờ ngủ TTS sau $mins phút.',
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteParagraphHighlight(
    List<String> paragraphs,
    ReaderSettings settings,
  ) {
    final textParagraphs = paragraphs
        .where((p) => !readerInlineImgPattern.hasMatch(p) && p.length > 25)
        .toList();
    if (textParagraphs.isEmpty) return const SizedBox.shrink();
    final fav = textParagraphs.first;
    final textColor = settings.background.textColor;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: textColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔥 Đoạn văn được cộng đồng thả cảm xúc nhiều nhất chương (❤️ 18  😱 7  😭 4)',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '“$fav”',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.85),
              fontStyle: FontStyle.italic,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterNavButtons(ReaderProvider rp) {
    final prev = rp.previousChapter;
    final next = rp.nextChapter;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: prev == null ? null : () => _switchChapter(prev),
            icon: const Icon(Icons.navigate_before),
            label: const Text(AppStrings.prevChapter),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: next != null
              ? FilledButton.icon(
                  onPressed: () => _switchChapter(next),
                  icon: const Icon(Icons.navigate_next),
                  label: const Text(AppStrings.nextChapter),
                )
              : OutlinedButton.icon(
                  onPressed: () {
                    _libraryProvider.setCategory(
                      widget.novel.id,
                      LibraryCategory.finished,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(AppStrings.lastChapter)),
                    );
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(AppStrings.finishedNovel),
                ),
        ),
      ],
    );
  }
}
