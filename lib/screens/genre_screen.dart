import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/novel.dart';
import '../providers/novel_provider.dart';
import '../utils/constants.dart';
import '../utils/format.dart';
import '../utils/theme.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/novel_card.dart';
import 'novel_detail_screen.dart';

/// Màn hình Thể loại: lưới tất cả thể loại kèm số lượng truyện;
/// bấm vào một thể loại sẽ mở danh sách truyện có phân trang.
class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NovelProvider>().loadGenres();
    });
  }

  @override
  Widget build(BuildContext context) {
    final np = context.watch<NovelProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.genres)),
      body: Builder(
        builder: (_) {
          if (np.genresLoading && np.genreCounts.isEmpty) {
            return const LoadingView();
          }
          if (np.genresError != null && np.genreCounts.isEmpty) {
            return ErrorView(
              message: np.genresError!,
              onRetry: np.loadGenres,
            );
          }
          return RefreshIndicator(
            onRefresh: np.loadGenres,
            child: GridView.builder(
              padding: const EdgeInsets.all(AppTheme.gap),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisExtent: 92,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: Genres.all.length,
              itemBuilder: (_, i) {
                final g = Genres.all[i];
                final count = np.genreCounts[g] ?? 0;
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NovelListScreen(
                          title: g,
                          initialQuery: NovelQuery(genres: [g]),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: scheme.primaryContainer,
                            foregroundColor: scheme.onPrimaryContainer,
                            child: Icon(Genres.iconOf(g)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  g,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$count truyện',
                                  style: TextStyle(
                                    fontSize: 12,
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Màn hình danh sách truyện dùng chung (cho một thể loại hoặc "Xem tất cả"),
/// hỗ trợ infinite scroll, pull-to-refresh và đổi thứ tự sắp xếp.
class NovelListScreen extends StatefulWidget {
  final String title;
  final NovelQuery initialQuery;

  const NovelListScreen({
    super.key,
    required this.title,
    required this.initialQuery,
  });

  @override
  State<NovelListScreen> createState() => _NovelListScreenState();
}

class _NovelListScreenState extends State<NovelListScreen> {
  late final NovelPager _pager;
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _pager = context.read<NovelProvider>().createPager(widget.initialQuery)
      ..addListener(_onChanged)
      ..refresh();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final pos = _scrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _pager.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _pager
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sort = _pager.query.sort;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton<NovelSort>(
            initialValue: sort,
            icon: const Icon(Icons.sort_rounded),
            onSelected: (s) => _pager.setQuery(_pager.query.copyWith(sort: s)),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: NovelSort.updated,
                child: Text(AppStrings.newlyUpdated),
              ),
              PopupMenuItem(
                value: NovelSort.views,
                child: Text(AppStrings.hot),
              ),
              PopupMenuItem(
                value: NovelSort.rating,
                child: Text('Đánh giá cao'),
              ),
              PopupMenuItem(
                value: NovelSort.title,
                child: Text('Tên A-Z'),
              ),
            ],
          ),
        ],
      ),
      body: PaginatedNovelList(
        pager: _pager,
        scrollController: _scrollCtrl,
      ),
    );
  }
}

/// Danh sách truyện có phân trang (dùng cho cả Tìm kiếm và NovelListScreen).
class PaginatedNovelList extends StatelessWidget {
  final NovelPager pager;
  final ScrollController scrollController;

  const PaginatedNovelList({
    super.key,
    required this.pager,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (pager.isLoading && pager.items.isEmpty) {
      return const LoadingView();
    }
    if (pager.error != null && pager.items.isEmpty) {
      return ErrorView(message: pager.error!, onRetry: pager.refresh);
    }
    if (pager.items.isEmpty) {
      return const EmptyView(
        message: AppStrings.noResult,
        icon: Icons.search_off_rounded,
      );
    }
    return RefreshIndicator(
      onRefresh: pager.refresh,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.all(AppTheme.gap),
        itemCount: pager.items.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          if (i == pager.items.length) {
            if (pager.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (!pager.hasMore) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    '${AppStrings.noMore} (${Format.views(pager.items.length)} truyện)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }
          final novel = pager.items[i];
          return NovelCard(
            novel: novel,
            horizontal: true,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NovelDetailScreen(novelId: novel.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
