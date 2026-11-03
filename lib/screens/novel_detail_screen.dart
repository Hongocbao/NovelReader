import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';
import '../models/chapter.dart';
import '../models/novel.dart';
import '../providers/auth_provider.dart';
import '../providers/library_provider.dart';
import '../providers/novel_provider.dart';
import '../providers/reader_provider.dart';
import '../utils/constants.dart';
import '../utils/format.dart';
import '../utils/theme.dart';
import '../widgets/chapter_tile.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/genre_chip.dart';
import '../widgets/loading_view.dart';
import '../widgets/novel_card.dart';
import 'genre_screen.dart';
import 'reader_screen.dart';

/// Màn hình Chi tiết truyện: bìa, tên, tác giả, mô tả (rút gọn/mở rộng),
/// thể loại, đánh giá, danh sách chương, nút Đọc ngay / Thêm vào tủ sách / Tải xuống.
class NovelDetailScreen extends StatefulWidget {
  final int novelId;

  const NovelDetailScreen({super.key, required this.novelId});

  @override
  State<NovelDetailScreen> createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends State<NovelDetailScreen> {
  Novel? _novel;
  bool _loading = true;
  String? _error;
  bool _expandedDesc = false;
  bool _viewRecorded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final np = context.read<NovelProvider>();
      final rp = context.read<ReaderProvider>();
      final novel = await np.getNovel(widget.novelId);
      if (novel == null) {
        setState(() {
          _error = AppStrings.novelNotFound;
          _loading = false;
        });
        return;
      }
      await rp.loadChapters(novel.id, force: true, novel: novel);
      if (!mounted) return;
      var loadedNovel = novel;
      if (!_viewRecorded) {
        _viewRecorded = true;
        try {
          final views = await np.recordNovelView(novel.id);
          if (views != null) loadedNovel = novel.copyWith(views: views);
        } catch (e) {
          // A statistics write must not prevent opening the novel detail page.
          debugPrint('Could not record novel view: $e');
        }
      }
      if (!mounted) return;
      setState(() {
        _novel = loadedNovel;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '${AppStrings.loadFailed}: $e';
        _loading = false;
      });
    }
  }

  void _openReader({int? chapterId, double offset = 0}) {
    final novel = _novel;
    if (novel == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReaderScreen(
          novel: novel,
          initialChapterId: chapterId,
          initialScrollOffset: offset,
        ),
      ),
    );
  }

  Future<void> _saveLibraryChange(Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể cập nhật tủ sách: $error')),
      );
    }
  }

  Future<void> _showLibrarySheet(String? currentCategory) async {
    final novel = _novel;
    if (novel == null) return;
    final lp = context.read<LibraryProvider>();
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            for (final cat in LibraryCategory.all)
              ListTile(
                leading: Icon(
                  currentCategory == cat
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                ),
                title: Text(Format.category(cat)),
                onTap: () {
                  Navigator.pop(ctx);
                  _saveLibraryChange(() => lp.setCategory(novel.id, cat));
                },
              ),
            if (currentCategory != null)
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(ctx).colorScheme.error,
                ),
                title: Text(
                  AppStrings.removeFromLibrary,
                  style: TextStyle(color: Theme.of(ctx).colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _saveLibraryChange(() => lp.remove(novel.id));
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _showDownloadOptions(List<Chapter> chapters) async {
    final novel = _novel;
    if (novel == null || novel.id < 0 || chapters.isEmpty) return;
    final rp = context.read<ReaderProvider>();
    final notDownloaded = chapters.where((c) => !c.isDownloaded).toList();
    final hasDownloaded = chapters.any((c) => c.isDownloaded);

    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.download_for_offline_outlined),
              title: Text(
                '${AppStrings.downloadNotDownloaded} (${notDownloaded.length})',
              ),
              enabled: notDownloaded.isNotEmpty,
              onTap: () {
                Navigator.pop(ctx);
                _runDownload(notDownloaded);
              },
            ),
            ListTile(
              leading: const Icon(Icons.checklist_rounded),
              title: const Text(AppStrings.selectChapters),
              enabled: notDownloaded.isNotEmpty,
              onTap: () {
                Navigator.pop(ctx);
                _showSelectChaptersDialog(notDownloaded);
              },
            ),
            if (hasDownloaded)
              ListTile(
                leading: Icon(
                  Icons.delete_sweep_outlined,
                  color: Theme.of(ctx).colorScheme.error,
                ),
                title: Text(
                  AppStrings.deleteNovelDownloads,
                  style: TextStyle(color: Theme.of(ctx).colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  rp.deleteDownloads(novelId: novel.id);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _showSelectChaptersDialog(List<Chapter> candidates) async {
    final selected = <int>{for (final c in candidates) c.id};
    final chosen = await showDialog<List<Chapter>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text(AppStrings.selectChapters),
          content: SizedBox(
            width: double.maxFinite,
            height: 320,
            child: ListView.builder(
              itemCount: candidates.length,
              itemBuilder: (_, i) {
                final c = candidates[i];
                final checked = selected.contains(c.id);
                return CheckboxListTile(
                  value: checked,
                  title: Text(
                    c.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onChanged: (v) => setDialogState(() {
                    v == true ? selected.add(c.id) : selected.remove(c.id);
                  }),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => setDialogState(() {
                if (selected.length == candidates.length) {
                  selected.clear();
                } else {
                  selected.addAll(candidates.map((e) => e.id));
                }
              }),
              child: const Text(AppStrings.selectAll),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: selected.isEmpty
                  ? null
                  : () => Navigator.pop(
                      ctx,
                      candidates.where((c) => selected.contains(c.id)).toList(),
                    ),
              child: Text('${AppStrings.download} (${selected.length})'),
            ),
          ],
        ),
      ),
    );
    if (chosen != null && chosen.isNotEmpty) {
      await _runDownload(chosen);
    }
  }

  Future<void> _runDownload(List<Chapter> list) async {
    final novel = _novel;
    if (novel == null) return;
    final rp = context.read<ReaderProvider>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final count = await rp.downloadChapters(novel.id, list, novel: novel);
      if (count > 0) {
        messenger.showSnackBar(
          SnackBar(content: Text('${AppStrings.downloadDone}: $count chương')),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(e is OfflineException ? AppStrings.needOnline : '$e'),
        ),
      );
    }
  }

  Future<void> _showAddChapterDialog() async {
    final novel = _novel;
    if (novel == null) return;
    final user = context.read<AuthProvider>().currentUser;
    final canAdd =
        novel.id < 0 ||
        user.isAdmin ||
        (!user.isGuest && !user.isBanned && user.id == novel.ownerId);
    if (!canAdd) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chỉ chủ truyện mới có thể thêm chương.')),
      );
      return;
    }
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.addChapter),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: AppStrings.chapterTitleLabel,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentCtrl,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: AppStrings.chapterContentLabel,
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
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
      final np = context.read<NovelProvider>();
      final messenger = ScaffoldMessenger.of(context);
      if (contentCtrl.text.trim().isEmpty) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập nội dung chương.')),
        );
      } else {
        try {
          await np.addChapterToNovel(
            novelId: novel.id,
            title: titleCtrl.text.trim().isEmpty
                ? 'Chương mới'
                : titleCtrl.text.trim(),
            content: contentCtrl.text,
          );
          await _load();
          if (mounted) {
            messenger.showSnackBar(
              const SnackBar(content: Text(AppStrings.chapterAddedSuccess)),
            );
          }
        } catch (e) {
          if (mounted) {
            messenger.showSnackBar(
              SnackBar(content: Text('Không lưu được chương: $e')),
            );
          }
        }
      }
    }
    titleCtrl.dispose();
    contentCtrl.dispose();
  }

  bool _canAddChapter(Novel novel, AppUser user) {
    if (novel.id < 0) return true;
    return user.isAdmin ||
        (!user.isGuest && !user.isBanned && user.id == novel.ownerId);
  }

  Future<void> _showRateDialog() async {
    final novel = _novel;
    if (novel == null) return;
    var stars = 5;
    final chosen = await showDialog<int>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text(AppStrings.rateNovel),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  iconSize: 34,
                  icon: Icon(
                    i <= stars ? Icons.star_rounded : Icons.star_border_rounded,
                    color: AppColors.rating,
                  ),
                  onPressed: () => setDialogState(() => stars = i),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, stars),
              child: const Text(AppStrings.confirm),
            ),
          ],
        ),
      ),
    );
    if (chosen != null && mounted) {
      final messenger = ScaffoldMessenger.of(context);
      late final double newRating;
      try {
        newRating = await context.read<NovelProvider>().rateNovel(
          novel.id,
          chosen.toDouble(),
        );
      } catch (_) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Không gửi được đánh giá. Hãy đăng nhập và thử lại.'),
          ),
        );
        return;
      }
      if (!mounted) return;
      setState(() => _novel = novel.copyWith(rating: newRating));
      messenger.showSnackBar(
        const SnackBar(content: Text(AppStrings.ratingUpdated)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<ReaderProvider>();
    final lp = context.watch<LibraryProvider>();
    final user = context.watch<AuthProvider>().currentUser;

    if (_loading) {
      return Scaffold(appBar: AppBar(), body: const LoadingView());
    }
    if (_error != null || _novel == null) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          message: _error ?? AppStrings.errorGeneric,
          onRetry: _load,
        ),
      );
    }

    final novel = _novel!;
    final chapters = rp.chaptersOf(novel.id) ?? const [];
    final chaptersError = rp.chaptersErrorOf(novel.id);
    final history = lp.historyFor(novel.id);
    final category = lp.categoryOf(novel.id);
    final task = rp.taskOf(novel.id);
    final downloadedCount = chapters.where((c) => c.isDownloaded).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(novel.title),
        actions: [
          if (_canAddChapter(novel, user))
            IconButton(
              tooltip: AppStrings.addChapter,
              icon: const Icon(Icons.note_add_outlined),
              onPressed: _showAddChapterDialog,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            _buildHeader(novel),
            _buildActions(novel, history, category, chapters, task),
            if (task != null && task.running)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.gap,
                  vertical: 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(value: task.progress),
                    const SizedBox(height: 4),
                    Text(
                      '${AppStrings.downloading} ${task.done}/${task.total} chương...',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            _buildDescription(novel),
            _buildGenres(novel),
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.gap),
              child: Row(
                children: [
                  Text(
                    '${AppStrings.chapterList} (${chapters.length})',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (downloadedCount > 0)
                    Text(
                      '${novel.id < 0 ? 'Đã lưu' : 'Đã tải'} $downloadedCount/${chapters.length}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            if (chaptersError != null && chapters.isEmpty)
              ErrorView(
                message: chaptersError,
                onRetry: () =>
                    rp.loadChapters(novel.id, force: true, novel: novel),
              )
            else if (chapters.isEmpty)
              const EmptyView(message: AppStrings.noChapters)
            else
              for (final ch in chapters)
                ChapterTile(
                  chapter: ch,
                  isCurrent: history?.lastChapterId == ch.id,
                  onTap: () => _openReader(
                    chapterId: ch.id,
                    offset: history?.lastChapterId == ch.id
                        ? history!.scrollOffset
                        : 0,
                  ),
                  onDownload: novel.id < 0 ? null : () => _runDownload([ch]),
                  onDeleteDownload: novel.id < 0
                      ? null
                      : () => rp.deleteDownload(ch),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Novel novel) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppTheme.gap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NovelCover(
            url: novel.coverUrl,
            title: novel.title,
            width: 112,
            height: 158,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  novel.title,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${AppStrings.author}: ${novel.author}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Chip(
                      label: Text(Format.type(novel.type)),
                      visualDensity: VisualDensity.compact,
                    ),
                    Chip(
                      label: Text(Format.status(novel.status)),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.rating,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      Format.rating(novel.rating),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _showRateDialog,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        child: Text(
                          '(${AppStrings.rateNovel})',
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(Format.views(novel.views)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Cập nhật: ${Format.date(novel.updatedAt)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(
    Novel novel,
    dynamic history,
    String? category,
    List<Chapter> chapters,
    DownloadTask? task,
  ) {
    final hasHistory = history != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.gap),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilledButton.icon(
            onPressed: chapters.isEmpty
                ? null
                : () => _openReader(
                    chapterId: history?.lastChapterId,
                    offset: history?.scrollOffset ?? 0,
                  ),
            icon: const Icon(Icons.menu_book_rounded),
            label: Text(
              hasHistory
                  ? '${AppStrings.continueRead} (Ch.${history.chapterIndex ?? 1})'
                  : AppStrings.readNow,
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => _showLibrarySheet(category),
            icon: Icon(
              category == null
                  ? Icons.bookmark_add_outlined
                  : Icons.bookmark_added_rounded,
            ),
            label: Text(
              category == null
                  ? AppStrings.addToLibrary
                  : Format.category(category),
            ),
          ),
          if (novel.id >= 0)
            OutlinedButton.icon(
              onPressed: (task?.running ?? false) || chapters.isEmpty
                  ? null
                  : () => _showDownloadOptions(chapters),
              icon: const Icon(Icons.download_outlined),
              label: const Text(AppStrings.download),
            ),
        ],
      ),
    );
  }

  Widget _buildDescription(Novel novel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppTheme.gap, 14, AppTheme.gap, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            novel.description,
            maxLines: _expandedDesc ? null : 3,
            overflow: _expandedDesc
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(height: 1.45),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => setState(() => _expandedDesc = !_expandedDesc),
              child: Text(
                _expandedDesc ? AppStrings.showLess : AppStrings.showMore,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenres(Novel novel) {
    if (novel.genres.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.gap),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          for (final g in novel.genres)
            GenreChip(
              genre: g,
              showIcon: true,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NovelListScreen(
                    title: g,
                    initialQuery: NovelQuery(genres: [g]),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
