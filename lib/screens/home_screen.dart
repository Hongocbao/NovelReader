import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/novel.dart';
import '../models/reading_history.dart';
import '../providers/library_provider.dart';
import '../providers/novel_provider.dart';
import '../utils/constants.dart';
import '../utils/format.dart';
import '../utils/theme.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/genre_chip.dart';
import '../widgets/loading_view.dart';
import '../widgets/novel_card.dart';
import 'genre_screen.dart';
import 'history_screen.dart';
import 'novel_detail_screen.dart';
import 'reader_screen.dart';

/// Màn hình Trang chủ: banner đề cử, Tiếp tục đọc, thể loại,
/// truyện mới cập nhật, truyện hot, truyện hoàn thành.
class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onJumpToTab;

  const HomeScreen({super.key, this.onJumpToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerCtrl = PageController(viewportFraction: 0.92);
  int _bannerIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final np = context.read<NovelProvider>();
      if (!np.homeLoaded && !np.homeLoading) {
        np.loadHome();
      }
      final lp = context.read<LibraryProvider>();
      if (!lp.isLoaded && !lp.isLoading) {
        lp.load();
      }
    });
  }

  @override
  void dispose() {
    _bannerCtrl.dispose();
    super.dispose();
  }

  void _openDetail(Novel novel) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NovelDetailScreen(novelId: novel.id)),
    );
  }

  void _openList(String title, NovelQuery query) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NovelListScreen(title: title, initialQuery: query),
      ),
    );
  }

  /// Vòng quay / Rút thẻ Gacha gợi ý ngẫu nhiên một bộ truyện thú vị.
  void _showRandomGachaDialog(NovelProvider np) {
    final pool = <Novel>{
      ...np.featured,
      ...np.newest,
      ...np.hot,
      ...np.completed,
    }.toList();
    if (pool.isEmpty) return;
    final rng = Random();
    var picked = pool[rng.nextInt(pool.length)];

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final scheme = Theme.of(ctx).colorScheme;
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: scheme.primary),
                const SizedBox(width: 8),
                const Expanded(child: Text(AppStrings.randomGacha)),
              ],
            ),
            content: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NovelCover(
                    url: picked.coverUrl,
                    title: picked.title,
                    width: 110,
                    height: 156,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    picked.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${picked.author} • ${Format.type(picked.type)} • ★ ${Format.rating(picked.rating)}',
                    style: Theme.of(ctx).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    alignment: WrapAlignment.center,
                    children: [
                      for (final g in picked.genres)
                        Chip(
                          label: Text(g),
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    picked.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () => setDialogState(() {
                  picked = pool[rng.nextInt(pool.length)];
                }),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(AppStrings.rerollGacha),
              ),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _openDetail(picked);
                },
                icon: const Icon(Icons.menu_book_rounded),
                label: const Text(AppStrings.readNow),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final np = context.watch<NovelProvider>();
    final history = context.select<LibraryProvider, List<ReadingHistory>>(
      (p) => p.history,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.auto_stories_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text(
              AppInfo.appName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: AppStrings.randomGacha,
            icon: const Icon(Icons.casino_outlined),
            onPressed: () => _showRandomGachaDialog(np),
          ),
          IconButton(
            tooltip: AppStrings.navSearch,
            icon: const Icon(Icons.search_rounded),
            onPressed: () => widget.onJumpToTab?.call(1),
          ),
          IconButton(
            tooltip: AppStrings.genres,
            icon: const Icon(Icons.grid_view_rounded),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const GenreScreen())),
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (np.homeLoading && !np.homeLoaded) {
            return const LoadingView();
          }
          if (np.homeError != null && !np.homeLoaded) {
            return ErrorView(message: np.homeError!, onRetry: np.loadHome);
          }
          if (np.featured.isEmpty && np.newest.isEmpty) {
            return EmptyView(
              action: FilledButton(
                onPressed: np.loadHome,
                child: const Text(AppStrings.retry),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                np.loadHome(),
                context.read<LibraryProvider>().load(),
              ]);
            },
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                if (np.featured.isNotEmpty) _buildBanner(np.featured),
                if (history.isNotEmpty) _buildContinueReading(history),
                _buildGenresRow(),
                _buildHorizontalSection(
                  title: AppStrings.newlyUpdated,
                  novels: np.newest,
                  onSeeAll: () => _openList(
                    AppStrings.newlyUpdated,
                    const NovelQuery(sort: NovelSort.updated),
                  ),
                ),
                _buildHorizontalSection(
                  title: AppStrings.hot,
                  novels: np.hot,
                  subtitleOf: (n) => '${Format.views(n.views)} lượt đọc',
                  onSeeAll: () => _openList(
                    AppStrings.hot,
                    const NovelQuery(sort: NovelSort.views),
                  ),
                ),
                _buildHorizontalSection(
                  title: AppStrings.completedNovels,
                  novels: np.completed,
                  onSeeAll: () => _openList(
                    AppStrings.completedNovels,
                    const NovelQuery(
                      status: NovelStatus.completed,
                      sort: NovelSort.rating,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBanner(List<Novel> items) {
    final scheme = Theme.of(context).colorScheme;
    final compact = MediaQuery.sizeOf(context).width < 380;
    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: compact ? 160 : 176,
          child: PageView.builder(
            controller: _bannerCtrl,
            itemCount: items.length,
            onPageChanged: (i) => setState(() => _bannerIndex = i),
            itemBuilder: (_, i) {
              final n = items[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _openDetail(n),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          scheme.primaryContainer,
                          scheme.tertiaryContainer,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(compact ? 11 : 14),
                    child: Row(
                      children: [
                        NovelCover(
                          url: n.coverUrl,
                          title: n.title,
                          width: compact ? 78 : 96,
                          height: compact ? 122 : 144,
                        ),
                        SizedBox(width: compact ? 10 : 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: scheme.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${AppStrings.featured} • ${Format.type(n.type)}',
                                  style: TextStyle(
                                    color: scheme.onPrimary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                n.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                n.author,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                n.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < items.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _bannerIndex ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _bannerIndex
                      ? scheme.primary
                      : scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildContinueReading(List<ReadingHistory> list) {
    final scheme = Theme.of(context).colorScheme;
    final items = list.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: AppStrings.continueReading,
          onSeeAll: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const HistoryScreen())),
        ),
        SizedBox(
          height: 108,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.gap),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final h = items[i];
              final novel = h.novel;
              if (novel == null) return const SizedBox.shrink();
              final chIdx = h.chapterIndex ?? 1;
              final progress = novel.totalChapters == 0
                  ? 0.0
                  : (chIdx / novel.totalChapters).clamp(0.0, 1.0);
              return SizedBox(
                width: 268,
                child: Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReaderScreen(
                          novel: novel,
                          initialChapterId: h.lastChapterId,
                          initialScrollOffset: h.scrollOffset,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          NovelCover(
                            url: novel.coverUrl,
                            title: novel.title,
                            width: 60,
                            height: 86,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  novel.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  h.chapterTitle ??
                                      Format.progress(
                                        chIdx,
                                        novel.totalChapters,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 5,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${Format.progress(chIdx, novel.totalChapters)} • ${Format.relative(h.lastReadAt)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenresRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: AppStrings.genres,
          onSeeAll: () =>
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const GenreScreen())),
        ),
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.gap),
            scrollDirection: Axis.horizontal,
            itemCount: Genres.all.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final g = Genres.all[i];
              return GenreChip(
                genre: g,
                showIcon: true,
                onTap: () => _openList(g, NovelQuery(genres: [g])),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalSection({
    required String title,
    required List<Novel> novels,
    required VoidCallback onSeeAll,
    String Function(Novel)? subtitleOf,
  }) {
    if (novels.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title, onSeeAll: onSeeAll),
        SizedBox(
          height: 238,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.gap),
            scrollDirection: Axis.horizontal,
            itemCount: novels.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final n = novels[i];
              return NovelCard(
                novel: n,
                subtitleOverride: subtitleOf?.call(n),
                onTap: () => _openDetail(n),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppTheme.gap, 14, 8, 6),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text(AppStrings.seeAll),
            ),
        ],
      ),
    );
  }
}
