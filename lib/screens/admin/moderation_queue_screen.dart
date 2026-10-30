import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_novel_provider.dart';
import '../../providers/auth_provider.dart';
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
            onPressed: () async {
              if (reasonCtrl.text.trim().isEmpty) return;
              await context.read<AdminNovelProvider>().rejectNovel(
                    admin: admin,
                    novelId: novelId,
                    reason: reasonCtrl.text.trim(),
                  );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Xác nhận Từ chối'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AdminNovelProvider>();
    final admin = context.watch<AuthProvider>().currentUser;

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _showRejectDialog(n.id, n.title),
                          icon: const Icon(Icons.close, color: Colors.red),
                          label: const Text('Từ chối kèm lý do'),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.icon(
                          onPressed: (_checkCopyright &&
                                  _checkSensitive &&
                                  _checkQuality)
                              ? () => prov.approveNovels(
                                    admin: admin,
                                    novelIds: [n.id],
                                  )
                              : null,
                          icon: const Icon(Icons.check),
                          label: const Text('Duyệt xuất bản'),
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
