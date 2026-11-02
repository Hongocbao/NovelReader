import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/supabase_database.dart';
import '../../models/chapter.dart';
import '../../models/novel.dart';
import '../../providers/admin_novel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/ai_moderation_service.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/loading_view.dart';

/// Màn hình Hàng chờ duyệt truyện/chương do Author gửi (Mục 6.3).
/// Có checklist kiểm duyệt (bản quyền, nội dung nhạy cảm, chất lượng) và nút Duyệt / Từ chối kèm lý do bắt buộc.
class AdminModerationQueueScreen extends StatefulWidget {
  const AdminModerationQueueScreen({super.key});

  @override
  State<AdminModerationQueueScreen> createState() =>
      _AdminModerationQueueScreenState();
}

class _AdminModerationQueueScreenState
    extends State<AdminModerationQueueScreen> {
  bool _checkCopyright = true;
  bool _checkSensitive = true;
  bool _checkQuality = true;
  final Set<int> _processingNovelIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = context.read<AdminNovelProvider>();
      if (prov.allNovels.isEmpty && !prov.isLoading) {
        prov.loadNovels();
      }
    });
  }

  Future<void> _showRejectDialog(int novelId, String title) async {
    final reasonCtrl = TextEditingController();
    final admin = context.read<AuthProvider>().currentUser;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Từ chối duyệt: $title'),
        content: TextField(
          controller: reasonCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Lý do từ chối bắt buộc (gửi thông báo cho tác giả)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (reasonCtrl.text.trim().isEmpty) return;
              final messenger = ScaffoldMessenger.of(context);
              if (ctx.mounted) Navigator.pop(ctx);
              setState(() => _processingNovelIds.add(novelId));
              try {
                await context.read<AdminNovelProvider>().rejectNovel(
                      admin: admin,
                      novelId: novelId,
                      reason: reasonCtrl.text.trim(),
                    );
                messenger.showSnackBar(
                  SnackBar(content: Text('Đã từ chối tác phẩm: $title')),
                );
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
                );
              } finally {
                if (mounted) {
                  setState(() => _processingNovelIds.remove(novelId));
                }
              }
            },
            child: const Text('Xác nhận Từ chối'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleApprove(Novel n) async {
    final messenger = ScaffoldMessenger.of(context);
    final prov = context.read<AdminNovelProvider>();
    final admin = context.read<AuthProvider>().currentUser;

    setState(() => _processingNovelIds.add(n.id));
    try {
      await prov.approveNovels(
        admin: admin,
        novelIds: [n.id],
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text('✅ Đã duyệt xuất bản thành công tác phẩm "${n.title}"!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Lỗi duyệt truyện: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _processingNovelIds.remove(n.id));
      }
    }
  }

  Future<void> _showAiModerationModal(Novel n) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('AI đang rà soát nội dung & quét từ khóa...'),
              ],
            ),
          ),
        ),
      ),
    );

    List<Chapter> chapters = [];
    try {
      chapters = await SupabaseDatabase.instance.getChapters(n.id);
    } catch (_) {}

    final report = await AiModerationService.scanNovel(
      novel: n,
      chapters: chapters,
    );

    if (!mounted) return;
    Navigator.pop(context); // Close loading dialog

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, scrollCtrl) => ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.psychology, color: Colors.blue, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Tiền Kiểm • Báo cáo thẩm định',
                        style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        n.title,
                        style: TextStyle(
                          color: Theme.of(ctx).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              color: report.safetyScore >= 85
                  ? Colors.green.withValues(alpha: 0.1)
                  : (report.safetyScore >= 60
                      ? Colors.orange.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1)),
              child: ListTile(
                leading: Text(
                  '${report.safetyScore}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: report.safetyScore >= 85
                        ? Colors.green
                        : (report.safetyScore >= 60 ? Colors.orange : Colors.red),
                  ),
                ),
                title: Text(
                  report.recommendationLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Điểm an toàn nội dung: ${report.safetyScore}/100'),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Tóm tắt cốt truyện tự động (AI Synopsis):',
              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(ctx).colorScheme.primary),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(report.aiSummary, style: const TextStyle(height: 1.4)),
            ),
            const SizedBox(height: 14),
            const Text(
              'Tiêu chuẩn đã đạt kiểm định:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            for (final p in report.passedCriteria) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(p, style: const TextStyle(fontSize: 13))),
                  ],
                ),
              ),
            ],
            if (report.warnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Cảnh báo cần lưu ý:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
              const SizedBox(height: 6),
              for (final w in report.warnings) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(w, style: const TextStyle(fontSize: 13, color: Colors.orange))),
                    ],
                  ),
                ),
              ],
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Đóng'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      final admin = context.read<AuthProvider>().currentUser;
                      final adminProv = context.read<AdminNovelProvider>();
                      final messenger = ScaffoldMessenger.of(context);
                      await adminProv.approveNovels(
                        admin: admin,
                        novelIds: [n.id],
                      );
                      messenger.showSnackBar(
                        SnackBar(content: Text('Đã duyệt xuất bản thành công: ${n.title}')),
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Duyệt xuất bản'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AdminNovelProvider>();

    if (prov.isLoading) return const LoadingView();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Checklist tiêu chuẩn kiểm duyệt xuất bản',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                CheckboxListTile(
                  value: _checkCopyright,
                  onChanged: (v) => setState(() => _checkCopyright = v ?? true),
                  title: const Text('1. Hợp lệ bản quyền / Tác phẩm tự sáng tác'),
                  dense: true,
                ),
                CheckboxListTile(
                  value: _checkSensitive,
                  onChanged: (v) => setState(() => _checkSensitive = v ?? true),
                  title: const Text(
                    '2. Không vi phạm từ cấm hoặc nội dung nhạy cảm',
                  ),
                  dense: true,
                ),
                CheckboxListTile(
                  value: _checkQuality,
                  onChanged: (v) => setState(() => _checkQuality = v ?? true),
                  title: const Text(
                    '3. Bố cục chương rõ ràng, trình bày đạt chuẩn',
                  ),
                  dense: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (prov.pendingNovels.isEmpty)
          const SizedBox(
            height: 280,
            child: EmptyView(
              icon: Icons.verified_outlined,
              message:
                  'Hàng chờ duyệt đang trống — mọi tác phẩm đã được xử lý!',
            ),
          )
        else
          for (final n in prov.pendingNovels)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tác giả: ${n.author} • Thể loại: ${n.genres.join(", ")} • ${n.totalChapters} chương',
                    ),
                    const SizedBox(height: 8),
                    Text(n.description),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.tonalIcon(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue.withValues(alpha: 0.15),
                            foregroundColor: Colors.blue.shade700,
                          ),
                          onPressed: () => _showAiModerationModal(n),
                          icon: const Icon(Icons.psychology, size: 18),
                          label: const Text('AI Rà Soát'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _showRejectDialog(n.id, n.title),
                          icon: const Icon(Icons.close, color: Colors.red),
                          label: const Text('Từ chối kèm lý do'),
                        ),
                        Builder(
                          builder: (context) {
                            final isProcessing = _processingNovelIds.contains(n.id);
                            return FilledButton.icon(
                              onPressed: isProcessing ||
                                      !(_checkCopyright &&
                                          _checkSensitive &&
                                          _checkQuality)
                                  ? null
                                  : () => _handleApprove(n),
                              icon: isProcessing
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.check),
                              label: Text(
                                isProcessing ? 'Đang duyệt...' : 'Duyệt xuất bản',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
