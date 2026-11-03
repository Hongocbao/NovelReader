import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/library_item.dart';
import '../providers/library_provider.dart';
import '../utils/constants.dart';
import '../utils/format.dart';
import '../utils/theme.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/novel_card.dart';
import '../widgets/smart_novel_importer_sheet.dart';
import 'history_screen.dart';
import 'novel_detail_screen.dart';

/// Màn hình Tủ sách: 3 tab Đang đọc / Muốn đọc / Đã đọc;
/// hỗ trợ sắp xếp theo tên hoặc thời gian, chuyển danh mục, xóa,
/// hiển thị tiến độ (Chương X/tổng).
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lp = context.read<LibraryProvider>();
      if (!lp.isLoaded && !lp.isLoading) {
        lp.load();
      }
    });
  }

  void _showItemMenu(LibraryItem item) {
    final lp = context.read<LibraryProvider>();
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            for (final cat in LibraryCategory.all)
              if (cat != item.category)
                ListTile(
                  leading: const Icon(Icons.drive_file_move_outlined),
                  title: Text('${AppStrings.moveTo}: ${Format.category(cat)}'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _saveLibraryChange(() => lp.setCategory(item.novelId, cat));
                  },
                ),
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
                _saveLibraryChange(() => lp.remove(item.novelId));
              },
            ),
            const SizedBox(height: 8),
          ],
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

  Future<void> _showImportLocalDialog() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SmartNovelImporterSheet(
        onImportDone: () => context.read<LibraryProvider>().load(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LibraryProvider>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.navLibrary),
          actions: [
            IconButton(
              tooltip: 'Nạp truyện riêng tư từ file/máy',
              icon: const Icon(Icons.note_add_outlined),
              onPressed: _showImportLocalDialog,
            ),
            IconButton(
              tooltip: AppStrings.history,
              icon: const Icon(Icons.history_rounded),
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const HistoryScreen())),
            ),
            PopupMenuButton<LibrarySort>(
              initialValue: lp.sort,
              icon: const Icon(Icons.sort_rounded),
              onSelected: lp.setSort,
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: LibrarySort.time,
                  child: Text(AppStrings.sortByTime),
                ),
                PopupMenuItem(
                  value: LibrarySort.name,
                  child: Text(AppStrings.sortByName),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: AppStrings.libraryReading),
              Tab(text: AppStrings.libraryWant),
              Tab(text: AppStrings.libraryFinished),
            ],
          ),
        ),
        body: Builder(
          builder: (_) {
            if (lp.isLoading && !lp.isLoaded) {
              return const LoadingView();
            }
            if (lp.error != null && !lp.isLoaded) {
              return ErrorView(message: lp.error!, onRetry: lp.load);
            }
            return TabBarView(
              children: [
                for (final cat in LibraryCategory.all)
                  _buildCategoryList(lp, cat),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryList(LibraryProvider lp, String category) {
    final list = lp.itemsOf(category);
    if (list.isEmpty) {
      return const EmptyView(
        message: AppStrings.emptyLibrary,
        icon: Icons.collections_bookmark_outlined,
      );
    }
    return RefreshIndicator(
      onRefresh: lp.load,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppTheme.gap),
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final item = list[i];
          final novel = item.novel;
          if (novel == null) return const SizedBox.shrink();
          final progressText = item.lastChapterIndex == null
              ? AppStrings.notStarted
              : 'Đã đọc: ${Format.progress(item.lastChapterIndex!, novel.totalChapters)}';
          return NovelCard(
            novel: novel,
            horizontal: true,
            subtitleOverride: progressText,
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showItemMenu(item),
            ),
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
