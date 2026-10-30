import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/loading_view.dart';

/// Màn hình Trung tâm Thông báo & Cộng đồng Yêu cầu truyện mới (Mục 5.6).
class UserNotificationsScreen extends StatefulWidget {
  const UserNotificationsScreen({super.key});

  @override
  State<UserNotificationsScreen> createState() =>
      _UserNotificationsScreenState();
}

class _UserNotificationsScreenState extends State<UserNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = context.read<AuthProvider>().currentUser.id;
      context.read<NotificationProvider>().loadAll(uid);
    });
  }

  Future<void> _showRequestDialog() async {
    final titleCtrl = TextEditingController();
    final authorCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final user = context.read<AuthProvider>().currentUser;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đề xuất truyện bạn muốn đọc'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Tên truyện *'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: authorCtrl,
              decoration: const InputDecoration(
                labelText: 'Tác giả (nếu biết)',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Ghi chú / Lý do'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) return;
              await context.read<NotificationProvider>().submitNovelRequest(
                    user: user,
                    title: titleCtrl.text,
                    authorHint: authorCtrl.text,
                    description: descCtrl.text,
                  );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Gửi đề xuất'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<NotificationProvider>();
    final user = context.watch<AuthProvider>().currentUser;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thông báo & Cộng đồng'),
          actions: [
            TextButton.icon(
              onPressed: () => prov.markAllAsRead(user.id),
              icon: const Icon(Icons.done_all, size: 18),
              label: const Text('Đọc tất cả'),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.notifications_outlined),
                text: 'Hộp thư của bạn',
              ),
              Tab(icon: Icon(Icons.campaign_outlined), text: 'Bảng tin Hệ thống'),
              Tab(
                icon: Icon(Icons.how_to_vote_outlined),
                text: 'Yêu cầu Truyện',
              ),
            ],
          ),
        ),
        body: prov.isLoading
            ? const LoadingView()
            : TabBarView(
                children: [
                  prov.notifications.isEmpty
                      ? const EmptyView(
                          icon: Icons.notifications_none,
                          message: 'Bạn chưa có thông báo nào.',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: prov.notifications.length,
                          itemBuilder: (context, index) {
                            final n = prov.notifications[index];
                            return Card(
                              child: ListTile(
                                leading: Icon(
                                  n.isRead
                                      ? Icons.mark_email_read_outlined
                                      : Icons.mark_email_unread,
                                  color: n.isRead
                                      ? null
                                      : Theme.of(context).colorScheme.primary,
                                ),
                                title: Text(
                                  n.title,
                                  style: TextStyle(
                                    fontWeight: n.isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(n.body),
                                onTap: () {
                                  if (n.id != null && !n.isRead) {
                                    prov.markAsRead(n.id!, user.id);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: prov.announcements.length,
                    itemBuilder: (context, index) {
                      final a = prov.announcements[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            a.pinned ? Icons.push_pin : Icons.campaign,
                          ),
                          title: Text(
                            a.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(a.body),
                        ),
                      );
                    },
                  ),
                  Column(
                    children: [
                      if (!user.isGuest)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: FilledButton.icon(
                            onPressed: _showRequestDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Đề xuất truyện muốn đọc'),
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: prov.requests.length,
                          itemBuilder: (context, index) {
                            final r = prov.requests[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  r.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Tác giả: ${r.authorHint.isEmpty ? "Chưa rõ" : r.authorHint} • Bởi: ${r.userName}\n${r.description}',
                                ),
                                isThreeLine: true,
                                trailing: FilledButton.tonalIcon(
                                  onPressed: () {
                                    if (r.id != null) {
                                      prov.voteNovelRequest(r.id!, user.id);
                                    }
                                  },
                                  icon: const Icon(Icons.thumb_up_alt_outlined),
                                  label: Text('${r.votes}'),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
