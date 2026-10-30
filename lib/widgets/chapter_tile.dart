import 'package:flutter/material.dart';

import '../models/chapter.dart';
import '../utils/constants.dart';

/// Một dòng trong danh sách chương.
class ChapterTile extends StatelessWidget {
  final Chapter chapter;
  final bool isCurrent;
  final VoidCallback onTap;
  final VoidCallback? onDownload;
  final VoidCallback? onDeleteDownload;

  const ChapterTile({
    super.key,
    required this.chapter,
    this.isCurrent = false,
    required this.onTap,
    this.onDownload,
    this.onDeleteDownload,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      selected: isCurrent,
      selectedTileColor: scheme.primaryContainer.withValues(alpha: 0.35),
      leading: CircleAvatar(
        radius: 16,
        backgroundColor:
            isCurrent ? scheme.primary : scheme.surfaceContainerHighest,
        foregroundColor: isCurrent ? scheme.onPrimary : scheme.onSurfaceVariant,
        child: Text(
          '${chapter.chapterIndex}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      title: Text(
        chapter.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (chapter.isDownloaded)
            Tooltip(
              message: AppStrings.downloaded,
              child: IconButton(
                icon: Icon(
                  Icons.download_done_rounded,
                  color: scheme.primary,
                  size: 20,
                ),
                onPressed: onDeleteDownload,
              ),
            )
          else if (onDownload != null)
            Tooltip(
              message: AppStrings.downloadChapter,
              child: IconButton(
                icon: const Icon(Icons.download_outlined, size: 20),
                onPressed: onDownload,
              ),
            ),
          const Icon(Icons.chevron_right, size: 18),
        ],
      ),
      onTap: onTap,
    );
  }
}
