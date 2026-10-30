import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/novel_provider.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/genre_chip.dart';
import 'genre_screen.dart';

/// Màn hình Tìm kiếm: ô tìm theo tên/tác giả (debounce 300ms),
/// lọc nhiều điều kiện (thể loại, trạng thái, loại truyện),
/// lưu lịch sử tìm kiếm, phân trang kết quả.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    final pager = context.read<NovelProvider>().searchPager;
    pager.addListener(_onPagerChanged);
    if (!pager.loadedOnce && !pager.isLoading) {
      pager.refresh();
    }
    _scrollCtrl.addListener(_onScroll);
  }

  void _onPagerChanged() {
    if (mounted) setState(() {});
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final pos = _scrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      context.read<NovelProvider>().searchPager.loadMore();
    }
  }

  @override
  void dispose() {
    context.read<NovelProvider>().searchPager.removeListener(_onPagerChanged);
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final np = context.watch<NovelProvider>();
    final query = np.searchQuery;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: AppStrings.searchHint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _ctrl.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _ctrl.clear();
                      np.submitKeyword('');
                      setState(() {});
                    },
                  ),
          ),
          onChanged: (v) {
            setState(() {});
            np.onKeywordChanged(v);
          },
          onSubmitted: np.submitKeyword,
        ),
        actions: [
          Badge(
            isLabelVisible: query.hasFilters,
            child: IconButton(
              tooltip: AppStrings.filters,
              icon: Icon(_showFilters
                  ? Icons.filter_alt_rounded
                  : Icons.filter_alt_outlined),
              onPressed: () => setState(() => _showFilters = !_showFilters),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (np.searchHistory.isNotEmpty && _ctrl.text.isEmpty)
            _buildHistory(np),
          if (_showFilters || query.hasFilters) _buildFilters(np, query),
          Expanded(
            child: PaginatedNovelList(
              pager: np.searchPager,
              scrollController: _scrollCtrl,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory(NovelProvider np) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppTheme.gap, 8, AppTheme.gap, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppStrings.searchHistory,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              TextButton(
                onPressed: np.clearSearchHistory,
                child: const Text(AppStrings.clearHistory),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final kw in np.searchHistory)
                InputChip(
                  label: Text(kw),
                  onPressed: () {
                    _ctrl.text = kw;
                    np.submitKeyword(kw);
                    setState(() {});
                  },
                  onDeleted: () => np.removeSearchHistory(kw),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(NovelProvider np, NovelQuery query) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: scheme.surfaceContainerLow,
      padding: const EdgeInsets.fromLTRB(AppTheme.gap, 8, AppTheme.gap, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Loại truyện + Trạng thái
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChipItem(
                  label: AppStrings.all,
                  selected: query.type == null,
                  onTap: () => np.setTypeFilter(null),
                ),
                _FilterChipItem(
                  label: AppStrings.typeNovel,
                  selected: query.type == NovelType.novel,
                  onTap: () => np.setTypeFilter(NovelType.novel),
                ),
                _FilterChipItem(
                  label: AppStrings.typeLightNovel,
                  selected: query.type == NovelType.lightNovel,
                  onTap: () => np.setTypeFilter(NovelType.lightNovel),
                ),
                _FilterChipItem(
                  label: AppStrings.typeComic,
                  selected: query.type == NovelType.comic,
                  onTap: () => np.setTypeFilter(NovelType.comic),
                ),
                const SizedBox(width: 12),
                _FilterChipItem(
                  label: AppStrings.statusOngoing,
                  selected: query.status == NovelStatus.ongoing,
                  onTap: () => np.setStatusFilter(
                    query.status == NovelStatus.ongoing
                        ? null
                        : NovelStatus.ongoing,
                  ),
                ),
                _FilterChipItem(
                  label: AppStrings.statusCompleted,
                  selected: query.status == NovelStatus.completed,
                  onTap: () => np.setStatusFilter(
                    query.status == NovelStatus.completed
                        ? null
                        : NovelStatus.completed,
                  ),
                ),
                if (query.hasFilters)
                  TextButton(
                    onPressed: np.clearFilters,
                    child: const Text(AppStrings.clearFilters),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Thể loại
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: Genres.all.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                final g = Genres.all[i];
                return GenreChip(
                  genre: g,
                  selected: query.genres.contains(g),
                  onTap: () => np.toggleGenre(g),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
