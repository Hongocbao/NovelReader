import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/loading_view.dart';

/// Màn hình Trung tâm Thông báo, Tin nhắn Cộng đồng & Yêu cầu truyện mới (Mục 5.6).
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

  Future<void> _showSendNotificationDialog() async {
    final user = context.read<AuthProvider>().currentUser;
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    final customRecipientCtrl = TextEditingController();
    String selectedTarget = 'all';

    const recipients = [
      (
        id: 'all',
        uid: '',
        label: '📢 Toàn bộ Cộng đồng Độc giả (Ai cũng nhận được)',
      ),
      (
        id: 'author',
        uid: '6a10a5a0-606a-40a0-a83b-5453dd4a45ad',
        label: '🪶 Bút Mặc Tiên Sinh (Tác giả)',
      ),
      (
        id: 'admin',
        uid: '24c6c9e9-cbef-4146-99aa-304da2bf0f15',
        label: '👑 Quản Trị Viên (Admin)',
      ),
      (
        id: 'reader',
        uid: '73eb192b-a554-4110-a4de-b2d2850bcc31',
        label: '⚔️ Bảo Ngọc Độc Giả',
      ),
      (
        id: 'custom',
        uid: '',
        label: '👤 Nhập ID người nhận cụ thể',
      ),
    ];

    final sent = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: const Text('✉️ Gửi Thông báo / Tin nhắn Cộng đồng'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedTarget,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Người nhận thông báo',
                      border: OutlineInputBorder(),
                    ),
                    items: recipients
                        .map(
                          (r) => DropdownMenuItem<String>(
                            value: r.id,
                            child: Text(
                              r.label,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setModalState(() => selectedTarget = v ?? 'all'),
                  ),
                  if (selectedTarget == 'custom') ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: customRecipientCtrl,
                      decoration: const InputDecoration(
                        labelText: 'ID tài khoản người nhận',
                        hintText: 'Ví dụ: 73eb192b-a554-4110-a4de-b2d2850bcc31',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tiêu đề thông báo *',
                      hintText: 'Ví dụ: Giao lưu đạo hữu / Góp ý tác phẩm',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: bodyCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Nội dung tin nhắn *',
                      hintText:
                          'Nhập nội dung muốn gửi (người nhận sẽ thấy ngay trong Hộp thư)...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Hủy'),
            ),
            FilledButton.icon(
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty ||
                    bodyCtrl.text.trim().isEmpty) {
                  return;
                }
                final picked = recipients.firstWhere(
                  (r) => r.id == selectedTarget,
                );
                final targetUid = selectedTarget == 'custom'
                    ? customRecipientCtrl.text.trim()
                    : picked.uid;
                final targetLabel = selectedTarget == 'custom'
                    ? 'ID #${customRecipientCtrl.text.trim()}'
                    : picked.label;
                await context
                    .read<NotificationProvider>()
                    .sendCommunityNotification(
                      sender: user,
                      recipientUserId: targetUid,
                      recipientLabel: targetLabel,
                      title: titleCtrl.text,
                      body: bodyCtrl.text,
                    );
                if (ctx.mounted) Navigator.pop(ctx, true);
              },
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Gửi ngay'),
            ),
          ],
        ),
      ),
    );

    if (sent == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '✅ Đã gửi thông báo thành công! Người nhận đã nhận được trong Hộp thư và biên nhận đã lưu.',
          ),
        ),
      );
    }
  }

  Future<void> _showRequestDialog() async {
    final titleCtrl = TextEditingController();
    final authorCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final user = context.read<AuthProvider>().currentUser;

    final submittedTitle = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('📚 Đề xuất truyện bạn muốn đọc'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Tên truyện *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: authorCtrl,
              decoration: const InputDecoration(
                labelText: 'Tác giả (nếu biết)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Ghi chú / Lý do yêu thích',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton.icon(
            onPressed: () async {
              final title = titleCtrl.text.trim();
              if (title.isEmpty) return;
              await context.read<NotificationProvider>().submitNovelRequest(
                user: user,
                title: title,
                authorHint: authorCtrl.text,
                description: descCtrl.text,
              );
              if (ctx.mounted) Navigator.pop(ctx, title);
            },
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Gửi đề xuất'),
          ),
        ],
      ),
    );

    if (submittedTitle != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Đã gửi đề xuất truyện "$submittedTitle"! Cộng đồng và Admin đã nhận được thông báo.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<NotificationProvider>();
    final user = context.watch<AuthProvider>().currentUser;
    final cs = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thông báo & Cộng đồng'),
          actions: [
            IconButton(
              tooltip: 'Làm mới hộp thư',
              onPressed: () => prov.loadAll(user.id),
              icon: const Icon(Icons.refresh),
            ),
            TextButton.icon(
              onPressed: () => prov.markAllAsRead(user.id),
              icon: const Icon(Icons.done_all, size: 18),
              label: const Text('Đọc tất cả'),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const Icon(Icons.notifications_outlined),
                text: 'Hộp thư của bạn (${prov.notifications.length})',
              ),
              Tab(
                icon: const Icon(Icons.campaign_outlined),
                text: 'Bảng tin Hệ thống (${prov.announcements.length})',
              ),
              Tab(
                icon: const Icon(Icons.how_to_vote_outlined),
                text: 'Yêu cầu Truyện (${prov.requests.length})',
              ),
            ],
          ),
        ),
        body: prov.isLoading
            ? const LoadingView()
            : TabBarView(
                children: [
                  // Tab 1: Hộp thư của bạn + Gửi thông báo cho người khác
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        color: cs.surfaceContainerHighest.withValues(
                          alpha: 0.55,
                        ),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              '📬 Nhận thông báo thời gian thực & Gửi tin nhắn trực tiếp cho Độc giả / Tác giả / Admin',
                              style: TextStyle(fontSize: 12.5),
                            ),
                            if (!user.isGuest)
                              FilledButton.icon(
                                onPressed: _showSendNotificationDialog,
                                icon: const Icon(Icons.outgoing_mail, size: 18),
                                label: const Text(
                                  'Gửi thông báo / Tin nhắn mới',
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: prov.notifications.isEmpty
                            ? const EmptyView(
                                icon: Icons.notifications_none,
                                message: 'Bạn chưa có thông báo nào.',
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: prov.notifications.length,
                                itemBuilder: (context, index) {
                                  final n = prov.notifications[index];
                                  final isReceipt = n.kind == 'sent_receipt';
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: isReceipt
                                            ? Colors.green.withValues(
                                                alpha: 0.15,
                                              )
                                            : (n.isRead
                                                  ? cs.surfaceContainerHighest
                                                  : cs.primaryContainer),
                                        child: Icon(
                                          isReceipt
                                              ? Icons.mark_chat_read_rounded
                                              : (n.isRead
                                                    ? Icons
                                                          .mark_email_read_outlined
                                                    : Icons.mark_email_unread),
                                          color: isReceipt
                                              ? Colors.green
                                              : (n.isRead ? null : cs.primary),
                                        ),
                                      ),
                                      title: Text(
                                        n.title,
                                        style: TextStyle(
                                          fontWeight: n.isRead
                                              ? FontWeight.w600
                                              : FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(n.body),
                                      ),
                                      trailing: Chip(
                                        visualDensity: VisualDensity.compact,
                                        label: Text(
                                          isReceipt
                                              ? 'Đã chuyển tới người nhận'
                                              : (n.isRead ? 'Đã xem' : 'Mới'),
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ),
                                      onTap: () {
                                        if (n.id != null && !n.isRead) {
                                          prov.markAsRead(n.id!, user.id);
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                  // Tab 2: Bảng tin Hệ thống
                  prov.announcements.isEmpty
                      ? const EmptyView(
                          icon: Icons.campaign_outlined,
                          message: 'Chưa có thông báo hệ thống nào.',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: prov.announcements.length,
                          itemBuilder: (context, index) {
                            final a = prov.announcements[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: Icon(
                                  a.pinned ? Icons.push_pin : Icons.campaign,
                                  color: a.pinned ? Colors.amber : cs.primary,
                                ),
                                title: Text(
                                  a.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(a.body),
                              ),
                            );
                          },
                        ),
                  // Tab 3: Yêu cầu Truyện
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        color: cs.surfaceContainerHighest.withValues(
                          alpha: 0.55,
                        ),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              '💡 Đề xuất truyện mới để các Tác giả & Admin dịch/sáng tác. Mọi người đều thấy và bình chọn được!',
                              style: TextStyle(fontSize: 12.5),
                            ),
                            if (!user.isGuest)
                              FilledButton.icon(
                                onPressed: _showRequestDialog,
                                icon: const Icon(Icons.add),
                                label: const Text('Đề xuất truyện muốn đọc'),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: prov.requests.isEmpty
                            ? const EmptyView(
                                icon: Icons.how_to_vote_outlined,
                                message:
                                    'Chưa có đề xuất nào. Hãy bấm "+ Đề xuất truyện muốn đọc"!',
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: prov.requests.length,
                                itemBuilder: (context, index) {
                                  final r = prov.requests[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: Text('#${index + 1}'),
                                      ),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              r.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withValues(
                                                alpha: 0.15,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              '✅ Đã gửi công khai',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        'Tác giả gợi ý: ${r.authorHint.isEmpty ? "Chưa rõ" : r.authorHint} • Người gửi: ${r.userName}\n${r.description.isEmpty ? "Mong sớm có truyện này trên hệ thống!" : r.description}',
                                      ),
                                      isThreeLine: true,
                                      trailing: FilledButton.tonalIcon(
                                        onPressed: () async {
                                          if (r.id != null) {
                                            await prov.voteNovelRequest(
                                              r.id!,
                                              user.id,
                                            );
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '👍 Đã bình chọn cho đề xuất "${r.title}"!',
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.thumb_up_alt_outlined,
                                        ),
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
