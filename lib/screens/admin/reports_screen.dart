import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/moderation_provider.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/loading_view.dart';

/// Màn hình Kiểm duyệt Bình luận, Báo cáo vi phạm & Bộ lọc từ cấm (Mục 6.5).
class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  final _wordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ModerationProvider>().loadAll();
    });
  }

  @override
  void dispose() {
    _wordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mod = context.watch<ModerationProvider>();
    final admin = context.watch<AuthProvider>().currentUser;

    if (mod.isLoading) return const LoadingView();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.report_problem_outlined),
                text: 'Hàng chờ Báo cáo vi phạm',
              ),
              Tab(
                icon: Icon(Icons.shield_outlined),
                text: 'Bộ lọc Từ cấm (Banned Words)',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                mod.reports.isEmpty
                    ? const EmptyView(
                        icon: Icons.verified_user_outlined,
                        message: 'Chưa có báo cáo vi phạm nào.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: mod.reports.length,
                        itemBuilder: (context, index) {
                          final r = mod.reports[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Loại: ${r.targetType.toUpperCase()} #${r.targetId} • Người báo: ${r.reporterName}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Chip(
                                        label: Text(r.status.toUpperCase()),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text('Lý do: ${r.reason}'),
                                  if (r.targetSnapshot.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Nội dung gốc: "${r.targetSnapshot}"',
                                      ),
                                    ),
                                  ],
                                  if (r.status == 'open') ...[
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () => mod.resolveReport(
                                            admin: admin,
                                            report: r,
                                            actionType: 'ignore',
                                            note: 'Không vi phạm',
                                          ),
                                          child: const Text('Bỏ qua'),
                                        ),
                                        FilledButton.tonal(
                                          onPressed: () => mod.resolveReport(
                                            admin: admin,
                                            report: r,
                                            actionType: 'hide_comment',
                                            note: 'Đã ẩn nội dung vi phạm',
                                          ),
                                          child: const Text('Ẩn bình luận'),
                                        ),
                                        FilledButton(
                                          onPressed: () => mod.resolveReport(
                                            admin: admin,
                                            report: r,
                                            actionType: 'warn',
                                            note: 'Cảnh cáo vi phạm tiêu chuẩn',
                                          ),
                                          child: const Text('Cảnh cáo người dùng'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Các từ trong danh sách sẽ tự động được thay bằng *** khi người dùng bình luận. Bình luận nhận ≥ 3 báo cáo độc lập cũng tự động bị ẩn.',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _wordCtrl,
                              decoration: const InputDecoration(
                                labelText:
                                    'Nhập từ cấm (ngăn cách nhiều từ bằng dấu phẩy)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed: () async {
                              if (_wordCtrl.text.trim().isEmpty) return;
                              final list = _wordCtrl.text.split(',');
                              await mod.addBannedWords(admin, list);
                              _wordCtrl.clear();
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Thêm từ cấm'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: mod.bannedWords
                            .map(
                              (w) => InputChip(
                                label: Text(w),
                                onDeleted: () => mod.removeBannedWord(admin, w),
                              ),
                            )
                            .toList(),
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
