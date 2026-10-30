import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chapter.dart';
import '../../models/reader_settings.dart';
import '../../providers/library_provider.dart';
import '../../utils/constants.dart';
import '../../utils/format.dart';

/// Khu vực bình luận ở cuối mỗi chương truyện.
class ReaderCommentSection extends StatelessWidget {
  final int novelId;
  final Chapter chapter;
  final ReaderSettings settings;

  const ReaderCommentSection({
    super.key,
    required this.novelId,
    required this.chapter,
    required this.settings,
  });

  Future<void> _showAddCommentDialog(BuildContext context) async {
    final ctrl = TextEditingController();
    var stars = 5;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(chapter.title, maxLines: 1),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 1; i <= 5; i++)
                    IconButton(
                      tooltip: '$i sao',
                      icon: Icon(
                        i <= stars
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: AppColors.rating,
                      ),
                      onPressed: () => setDialogState(() => stars = i),
                    ),
                ],
              ),
              TextField(
                controller: ctrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: AppStrings.commentHint,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(AppStrings.sendComment),
            ),
          ],
        ),
      ),
    );
    if (ok == true && ctrl.text.trim().isNotEmpty && context.mounted) {
      await context.read<LibraryProvider>().addComment(
            novelId: novelId,
            chapterId: chapter.id,
            content: ctrl.text,
            stars: stars,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final comments = context.watch<LibraryProvider>().commentsOf(chapter.id);
    final textColor = settings.background.textColor;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.forum_outlined, size: 18, color: textColor),
              const SizedBox(width: 8),
              Text(
                '${AppStrings.chapterComments} (${comments.length})',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showAddCommentDialog(context),
                icon: const Icon(Icons.add_comment_outlined, size: 16),
                label: const Text('Viết bình luận'),
              ),
            ],
          ),
          if (comments.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                AppStrings.noComments,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
            )
          else
            for (final c in comments)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      child: Text(
                        c.userName.characters.first.toUpperCase(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                c.userName,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 6),
                              for (var s = 0; s < c.stars; s++)
                                const Icon(
                                  Icons.star_rounded,
                                  size: 13,
                                  color: AppColors.rating,
                                ),
                              const Spacer(),
                              Text(
                                Format.relative(c.createdAt),
                                style: TextStyle(
                                  color: textColor.withValues(alpha: 0.6),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            c.content,
                            style: TextStyle(color: textColor, fontSize: 13.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
