import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/novel.dart';
import '../utils/constants.dart';
import '../utils/format.dart';
import '../utils/theme.dart';

/// Ảnh bìa truyện có cache và giao diện fallback khi mất mạng/lỗi ảnh.
class NovelCover extends StatelessWidget {
  final String url;
  final String title;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const NovelCover({
    super.key,
    required this.url,
    required this.title,
    this.width,
    this.height,
    this.borderRadius = AppTheme.coverRadius,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget fallback() => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [scheme.primaryContainer, scheme.secondaryContainer],
            ),
          ),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.menu_book_rounded,
                  color: scheme.onPrimaryContainer, size: 28),
              const SizedBox(height: 4),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: scheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        );

    if (url.isEmpty) return fallback();
    return Semantics(
      image: true,
      label: 'Ảnh bìa truyện $title',
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholder: (_, _) => Container(
            width: width,
            height: height,
            color: scheme.surfaceContainerHighest,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (_, _, _) => fallback(),
        ),
      ),
    );
  }
}

/// Thẻ hiển thị truyện ở dạng dọc (dùng cho danh sách ngang) hoặc ngang (danh sách dọc).
class NovelCard extends StatelessWidget {
  final Novel novel;
  final VoidCallback onTap;
  final bool horizontal;
  final Widget? trailing;
  final String? subtitleOverride;

  const NovelCard({
    super.key,
    required this.novel,
    required this.onTap,
    this.horizontal = false,
    this.trailing,
    this.subtitleOverride,
  });

  @override
  Widget build(BuildContext context) {
    return horizontal ? _buildHorizontal(context) : _buildVertical(context);
  }

  Widget _buildVertical(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: AppTheme.coverRadius,
      onTap: onTap,
      child: SizedBox(
        width: 132,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                NovelCover(
                  url: novel.coverUrl,
                  title: novel.title,
                  width: 132,
                  height: 178,
                ),
                if (novel.isLightNovel || novel.isComic)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: novel.isComic
                            ? AppColors.comic
                            : AppColors.lightNovel,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        novel.isComic ? 'MANGA' : 'LN',
                        style: const TextStyle(
                          color: AppColors.onBanner,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.bannerOverlay,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 12, color: AppColors.rating),
                        const SizedBox(width: 2),
                        Text(
                          Format.rating(novel.rating),
                          style: const TextStyle(
                            color: AppColors.onBanner,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              novel.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitleOverride ?? novel.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NovelCover(
                url: novel.coverUrl,
                title: novel.title,
                width: 76,
                height: 106,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      novel.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      novel.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _Badge(
                          label: Format.type(novel.type),
                          color: novel.isComic
                              ? AppColors.comic
                              : (novel.isLightNovel
                                  ? AppColors.lightNovel
                                  : scheme.primary),
                        ),
                        _Badge(
                          label: Format.status(novel.status),
                          color: novel.isCompleted
                              ? AppColors.completed
                              : AppColors.ongoing,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 15, color: AppColors.rating),
                            const SizedBox(width: 2),
                            Text(
                              Format.rating(novel.rating),
                              style: textTheme.labelSmall,
                            ),
                          ],
                        ),
                        Text(
                          '• ${Format.chapterCount(novel.totalChapters)} • ${Format.views(novel.views)} lượt đọc',
                          style: textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (subtitleOverride != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitleOverride!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelMedium?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else if (novel.genres.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        novel.genres.join(' • '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
