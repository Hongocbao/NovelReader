import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../models/chapter.dart';
import '../providers/reader_provider.dart';
import '../utils/constants.dart';
import '../utils/format.dart';
import '../utils/theme.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/novel_card.dart';
import 'novel_detail_screen.dart';
import 'reader_screen.dart';

/// Màn hình Tải xuống: hiển thị các chương đã tải gom theo từng truyện,
/// tổng dung lượng, cho phép xóa từng chương / từng truyện / toàn bộ.
class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReaderProvider>().loadDownloads();
    });
  }

  Future<void> _confirmDeleteAll() async {
    final rp = context.read<ReaderProvider>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.clearAll),
        content: const Text(AppStrings.confirmDeleteDownloads),
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
      await rp.deleteDownloads();
    }
  }

  Future<void> _openDownloadedChapter(DownloadedChapter downloaded) async {
    try {
      final novel = await AppDatabase.instance.getNovel(
        downloaded.chapter.novelId,
      );
      if (!mounted) return;
      if (novel == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không tìm thấy thông tin truyện đã tải.'),
          ),
        );
        return;
      }
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ReaderScreen(
            novel: novel,
            initialChapterId: downloaded.chapter.id,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể mở chương đã tải: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<ReaderProvider>();
    final list = rp.downloaded;

    // Gom theo novelId
    final grouped = <int, List<DownloadedChapter>>{};
    for (final d in list) {
      grouped.putIfAbsent(d.chapter.novelId, () => []).add(d);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.downloads),
        actions: [
          if (list.isNotEmpty)
            IconButton(
              tooltip: AppStrings.clearAll,
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: _confirmDeleteAll,
            ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (rp.downloadsLoading && !rp.downloadsLoaded) {
            return const LoadingView();
          }
          if (rp.downloadsError != null && !rp.downloadsLoaded) {
            return ErrorView(
              message: rp.downloadsError!,
              onRetry: rp.loadDownloads,
            );
          }
          if (list.isEmpty) {
            return const EmptyView(
              message: AppStrings.emptyDownloads,
              icon: Icons.download_for_offline_outlined,
            );
          }
          return RefreshIndicator(
            onRefresh: rp.loadDownloads,
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.gap),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        const Icon(Icons.storage_rounded),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${AppStrings.totalSize}: ${Format.bytes(rp.downloadedBytes)} (${rp.downloadedCount} chương)',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                for (final entry in grouped.entries)
                  _buildNovelGroup(rp, entry.key, entry.value),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNovelGroup(
    ReaderProvider rp,
    int novelId,
    List<DownloadedChapter> items,
  ) {
    final first = items.first;
    final totalBytes = items.fold<int>(0, (s, e) => s + e.sizeInBytes);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: ExpansionTile(
          leading: NovelCover(
            url: first.coverUrl,
            title: first.novelTitle,
            width: 42,
            height: 58,
          ),
          title: Text(
            first.novelTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${items.length} chương • ${Format.bytes(totalBytes)}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: AppStrings.deleteNovelDownloads,
                icon: const Icon(Icons.delete_outline),
                onPressed: () => rp.deleteDownloads(novelId: novelId),
              ),
              IconButton(
                icon: const Icon(Icons.open_in_new, size: 20),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => NovelDetailScreen(novelId: novelId),
                  ),
                ),
              ),
            ],
          ),
          children: [
            for (final d in items)
              ListTile(
                dense: true,
                onTap: () => _openDownloadedChapter(d),
                title: Text(
                  d.chapter.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(Format.bytes(d.sizeInBytes)),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => rp.deleteDownload(d.chapter),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
