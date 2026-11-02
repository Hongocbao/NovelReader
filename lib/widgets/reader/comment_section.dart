import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/bookmark.dart';
import '../../models/chapter.dart';
import '../../models/reader_settings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/library_provider.dart';
import '../../providers/moderation_provider.dart';
import '../../providers/quest_provider.dart';
import '../../utils/constants.dart';
import '../../utils/format.dart';
import '../../utils/profanity_filter.dart';

/// Khu vực bình luận ở cuối mỗi chương truyện.
/// Tích hợp **Spoiler Shield (Khiên chống Spoil - Mục 5.3)**, Bộ lọc từ cấm (`***`) và Báo cáo vi phạm.
class ReaderCommentSection extends StatefulWidget {
  final int novelId;
  final Chapter chapter;
  final ReaderSettings settings;

  const ReaderCommentSection({
    super.key,
    required this.novelId,
    required this.chapter,
    required this.settings,
  });

  @override
  State<ReaderCommentSection> createState() => _ReaderCommentSectionState();
}

class _ReaderCommentSectionState extends State<ReaderCommentSection> {
  final Set<int> _revealedSpoilers = {};

  Future<void> _showAddCommentDialog(BuildContext context) async {
    final auth = Provider.of<AuthProvider?>(context, listen: false);
    final mod = Provider.of<ModerationProvider?>(context, listen: false);
    final quest = Provider.of<QuestProvider?>(context, listen: false);

    if (auth != null && auth.isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng đăng nhập tài khoản (User/Author/Admin) để bình luận & nhận thưởng nhiệm vụ!',
          ),
        ),
      );
      return;
    }

    final ctrl = TextEditingController();
    var stars = 5;
    var commentChapterIdx = widget.chapter.chapterIndex;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(widget.chapter.title, maxLines: 1),
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
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: commentChapterIdx > widget.chapter.chapterIndex,
                onChanged: (v) => setDialogState(() {
                  commentChapterIdx = (v == true)
                      ? widget.chapter.chapterIndex + 2
                      : widget.chapter.chapterIndex;
                }),
                title: const Text(
                  'Đánh dấu bình luận có tiết lộ tình tiết chương sau (Spoiler Shield)',
                  style: TextStyle(fontSize: 12),
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
      final banned = mod?.bannedWords ?? const <String>[];
      final cleanText = ProfanityFilter.sanitize(ctrl.text, banned);
      final user = auth?.currentUser;
      await context.read<LibraryProvider>().addComment(
            novelId: widget.novelId,
            chapterId: widget.chapter.id,
            content: cleanText,
            stars: stars,
            userId: user?.id ?? '',
            userName: user?.displayName ?? 'Độc giả',
            chapterIndex: commentChapterIdx,
          );
      if (user != null && quest != null) {
        await quest.recordProgress(user: user, goalType: 'comment', delta: 1);
      }
    }
  }

  Future<void> _reportComment(ChapterComment c) async {
    final auth = Provider.of<AuthProvider?>(context, listen: false);
    final mod = Provider.of<ModerationProvider?>(context, listen: false);
    if (auth == null || mod == null || auth.isGuest || c.id == null) return;
    await mod.submitReport(
      reporter: auth.currentUser,
      targetType: 'comment',
      targetId: c.id!,
      targetSnapshot: c.content,
      reason: 'Ngôn từ không phù hợp / Spoil không gắn nhãn',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🚩 Đã gửi báo cáo bình luận cho Quản trị viên xử lý.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allComments = context
        .watch<LibraryProvider>()
        .commentsOf(widget.chapter.id)
        .where((c) => !c.isHidden)
        .toList();
    final textColor = widget.settings.background.textColor;

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
                '${AppStrings.chapterComments} (${allComments.length})',
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
          if (allComments.isEmpty)
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
            for (final c in allComments)
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
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                tooltip: 'Báo cáo vi phạm',
                                icon: Icon(
                                  Icons.flag_outlined,
                                  size: 15,
                                  color: textColor.withValues(alpha: 0.55),
                                ),
                                onPressed: () => _reportComment(c),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          // Spoiler Shield (Mục 5.3): Nếu bình luận thuộc chương > chương đang đọc
                          if (c.isSpoilerFor(widget.chapter.chapterIndex) &&
                              !_revealedSpoilers.contains(c.id ?? -1))
                            InkWell(
                              onTap: () {
                                if (c.id != null) {
                                  setState(() => _revealedSpoilers.add(c.id!));
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.amber.withValues(alpha: 0.6),
                                  ),
                                ),
                                child: Text(
                                  '🛡️ Có thể spoil (Chương ${c.chapterIndex}) – Chạm để xem',
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            )
                          else
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
