import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// Thanh công cụ trên và dưới trong màn hình đọc truyện (ẩn/hiện khi chạm giữa màn hình).
class ReaderTopBar extends StatelessWidget {
  final String novelTitle;
  final String chapterTitle;
  final bool isDownloaded;
  final bool isListening;
  final VoidCallback onBack;
  final VoidCallback onToggleListen;
  final VoidCallback onSearchInChapter;
  final VoidCallback onOpenXray;
  final VoidCallback onAddBookmark;
  final VoidCallback onShowBookmarks;
  final VoidCallback? onDownload;

  const ReaderTopBar({
    super.key,
    required this.novelTitle,
    required this.chapterTitle,
    required this.isDownloaded,
    this.isListening = false,
    required this.onBack,
    required this.onToggleListen,
    required this.onSearchInChapter,
    required this.onOpenXray,
    required this.onAddBookmark,
    required this.onShowBookmarks,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface.withValues(alpha: 0.96),
      elevation: 2,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Quay lại (Esc)',
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      novelTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    Text(
                      chapterTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isListening
                    ? AppStrings.stopListen
                    : AppStrings.listenChapter,
                icon: Icon(
                  isListening
                      ? Icons.record_voice_over_rounded
                      : Icons.headphones_outlined,
                  color: isListening ? scheme.primary : null,
                ),
                onPressed: onToggleListen,
              ),
              IconButton(
                tooltip: AppStrings.searchInChapter,
                icon: const Icon(Icons.find_in_page_outlined),
                onPressed: onSearchInChapter,
              ),
              IconButton(
                tooltip: AppStrings.xrayTitle,
                icon: const Icon(Icons.hub_outlined),
                onPressed: onOpenXray,
              ),
              if (isDownloaded)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Tooltip(
                    message: AppStrings.downloaded,
                    child: Icon(Icons.download_done_rounded, size: 20),
                  ),
                )
              else if (onDownload != null)
                IconButton(
                  tooltip: AppStrings.downloadChapter,
                  icon: const Icon(Icons.download_outlined),
                  onPressed: onDownload,
                ),
              IconButton(
                tooltip: AppStrings.addBookmark,
                icon: const Icon(Icons.bookmark_add_outlined),
                onPressed: onAddBookmark,
              ),
              IconButton(
                tooltip: AppStrings.bookmarks,
                icon: const Icon(Icons.bookmarks_outlined),
                onPressed: onShowBookmarks,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thanh điều khiển dưới của màn hình đọc: chương trước/sau, mục lục, cài đặt đọc.
class ReaderBottomBar extends StatelessWidget {
  final bool hasPrev;
  final bool hasNext;
  final bool isAutoScrolling;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback onToggleAutoScroll;
  final VoidCallback onOpenToc;
  final VoidCallback onOpenSettings;

  const ReaderBottomBar({
    super.key,
    required this.hasPrev,
    required this.hasNext,
    this.isAutoScrolling = false,
    required this.onPrev,
    required this.onNext,
    required this.onToggleAutoScroll,
    required this.onOpenToc,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface.withValues(alpha: 0.96),
      elevation: 4,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BarItem(
                icon: Icons.skip_previous_rounded,
                label: AppStrings.prevChapter,
                onTap: hasPrev ? onPrev : null,
              ),
              _BarItem(
                icon: Icons.format_list_bulleted_rounded,
                label: AppStrings.tableOfContents,
                onTap: onOpenToc,
              ),
              _BarItem(
                icon: isAutoScrolling
                    ? Icons.pause_circle_filled_rounded
                    : Icons.slow_motion_video_rounded,
                label: AppStrings.autoScroll,
                onTap: onToggleAutoScroll,
              ),
              _BarItem(
                icon: Icons.text_fields_rounded,
                label: AppStrings.readerSettings,
                onTap: onOpenSettings,
              ),
              _BarItem(
                icon: Icons.skip_next_rounded,
                label: AppStrings.nextChapter,
                onTap: hasNext ? onNext : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _BarItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;
    final color = enabled ? scheme.onSurface : scheme.outline;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: label,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(fontSize: 11, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
