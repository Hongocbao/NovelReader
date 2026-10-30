import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/library_provider.dart';
import '../utils/constants.dart';
import '../utils/format.dart';
import '../utils/theme.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/novel_card.dart';
import 'novel_detail_screen.dart';
import 'reader_screen.dart';

/// Màn hình Lịch sử đọc: hiển thị truyện đã đọc gần đây kèm chương & vị trí,
/// cho phép xóa từng mục hoặc xóa tất cả.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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

  Future<void> _confirmClearAll() async {
    final lp = context.read<LibraryProvider>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.clearAll),
        content: const Text(AppStrings.confirmClearHistory),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await lp.clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LibraryProvider>();
    final list = lp.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.history),
        actions: [
          if (list.isNotEmpty)
            IconButton(
              tooltip: AppStrings.clearAll,
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: _confirmClearAll,
            ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (lp.isLoading && !lp.isLoaded) {
            return const LoadingView();
          }
          if (lp.error != null && !lp.isLoaded) {
            return ErrorView(message: lp.error!, onRetry: lp.load);
          }
          if (list.isEmpty) {
            return const EmptyView(
              message: AppStrings.emptyHistory,
              icon: Icons.history_toggle_off,
            );
          }
          return RefreshIndicator(
            onRefresh: lp.load,
            child: ListView.separated(
              padding: const EdgeInsets.all(AppTheme.gap),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final h = list[i];
                final novel = h.novel;
                if (novel == null) return const SizedBox.shrink();
                final chText = h.chapterTitle ??
                    'Chương ${h.chapterIndex ?? 1}/${novel.totalChapters}';
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: NovelCover(
                      url: novel.coverUrl,
                      title: novel.title,
                      width: 52,
                      height: 74,
                    ),
                    title: Text(
                      novel.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '$chText • ${Format.percent(h.scrollOffset)}\n${Format.relative(h.lastReadAt)}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: AppStrings.continueRead,
                          icon: const Icon(Icons.play_circle_outline),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ReaderScreen(
                                novel: novel,
                                initialChapterId: h.lastChapterId,
                                initialScrollOffset: h.scrollOffset,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: AppStrings.delete,
                          icon: const Icon(Icons.close),
                          onPressed: () => lp.deleteHistory(novel.id),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NovelDetailScreen(novelId: novel.id),
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
