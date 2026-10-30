import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_novel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/moderation_provider.dart';
import '../../providers/notification_provider.dart';

/// Màn hình Quản lý Banner đề cử, Sự kiện & Nhiệm vụ, Thông báo hệ thống và Yêu cầu truyện (Mục 6.6).
class AdminBannersEventsScreen extends StatefulWidget {
  const AdminBannersEventsScreen({super.key});

  @override
  State<AdminBannersEventsScreen> createState() =>
      _AdminBannersEventsScreenState();
}

class _AdminBannersEventsScreenState extends State<AdminBannersEventsScreen> {
  final _questTitleCtrl = TextEditingController();
  final _questRewardCtrl = TextEditingController(text: '100');
  final _questGoalCtrl = TextEditingController(text: '3');
  String _questGoalType = 'read_chapters';

  final _annTitleCtrl = TextEditingController();
  final _annBodyCtrl = TextEditingController();
  String _annAudience = 'all';
  bool _annPinned = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = context.read<AuthProvider>().currentUser.id;
      context.read<AdminNovelProvider>().loadNovels();
      context.read<ModerationProvider>().loadAll();
      context.read<NotificationProvider>().loadAll(uid);
    });
  }

  @override
  void dispose() {
    _questTitleCtrl.dispose();
    _questRewardCtrl.dispose();
    _questGoalCtrl.dispose();
    _annTitleCtrl.dispose();
    _annBodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AuthProvider>().currentUser;
    final novelProv = context.watch<AdminNovelProvider>();
    final modProv = context.watch<ModerationProvider>();
    final notifProv = context.watch<NotificationProvider>();

    final featuredNovels =
        novelProv.allNovels.where((n) => n.isFeatured && !n.isDeleted).toList();

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.view_carousel), text: 'Banner Đề cử'),
              Tab(
                icon: Icon(Icons.emoji_events_outlined),
                text: 'Sự kiện & Nhiệm vụ',
              ),
              Tab(
                icon: Icon(Icons.campaign_outlined),
                text: 'Thông báo Hệ thống',
              ),
              Tab(
                icon: Icon(Icons.how_to_vote_outlined),
                text: 'Yêu cầu Truyện (Vote)',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Tab 1: Banner đề cử
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Các tác phẩm đang hiển thị trên Banner Đề cử trang chủ (${featuredNovels.length} truyện):',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    for (final n in featuredNovels)
                      Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          title: Text(n.title),
                          subtitle: Text(n.author),
                          trailing: TextButton(
                            onPressed: () => novelProv.setFeaturedStatus(
                              admin: admin,
                              novelIds: [n.id],
                              featured: false,
                            ),
                            child: const Text('Gỡ khỏi Banner'),
                          ),
                        ),
                      ),
                  ],
                ),
                // Tab 2: Sự kiện & Nhiệm vụ
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Tạo Nhiệm vụ Sự kiện mới',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _questTitleCtrl,
                              decoration: const InputDecoration(
                                labelText:
                                    'Tên sự kiện (VD: Tuần lễ Trinh thám: Đọc 3 chương)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _questGoalType,
                                    decoration: const InputDecoration(
                                      labelText: 'Loại mục tiêu',
                                      border: OutlineInputBorder(),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'read_chapters',
                                        child: Text('Số chương đọc'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'read_minutes',
                                        child: Text('Số phút đọc'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'comment',
                                        child: Text('Số bình luận'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'finish_novel',
                                        child: Text('Hoàn thành truyện'),
                                      ),
                                    ],
                                    onChanged: (v) => setState(
                                      () =>
                                          _questGoalType = v ?? 'read_chapters',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _questGoalCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Mục tiêu cần đạt',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _questRewardCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Thưởng Linh Thạch',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: () async {
                                if (_questTitleCtrl.text.trim().isEmpty) return;
                                await modProv.createEventQuest(
                                  admin: admin,
                                  title: _questTitleCtrl.text.trim(),
                                  goalType: _questGoalType,
                                  goalValue:
                                      int.tryParse(_questGoalCtrl.text) ?? 3,
                                  reward:
                                      int.tryParse(_questRewardCtrl.text) ??
                                          100,
                                );
                                _questTitleCtrl.clear();
                              },
                              icon: const Icon(Icons.add_task),
                              label: const Text('Phát hành Nhiệm vụ Sự kiện'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final q in modProv.allQuests)
                      Card(
                        child: ListTile(
                          leading: Chip(label: Text(q.type.toUpperCase())),
                          title: Text(q.title),
                          subtitle: Text(
                            'Mục tiêu: ${q.goalValue} (${q.goalType}) • Thưởng: 💎 ${q.reward} Linh Thạch',
                          ),
                        ),
                      ),
                  ],
                ),
                // Tab 3: Thông báo hệ thống
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _annTitleCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Tiêu đề thông báo hệ thống',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _annBodyCtrl,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Nội dung thông báo',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                DropdownButton<String>(
                                  value: _annAudience,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'all',
                                      child: Text('Tất cả người dùng'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'authors',
                                      child: Text('Chỉ Tác giả (Authors)'),
                                    ),
                                  ],
                                  onChanged: (v) => setState(
                                    () => _annAudience = v ?? 'all',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                FilterChip(
                                  label: const Text('Ghim đầu bảng'),
                                  selected: _annPinned,
                                  onSelected: (v) =>
                                      setState(() => _annPinned = v),
                                ),
                                const Spacer(),
                                FilledButton.icon(
                                  onPressed: () async {
                                    if (_annTitleCtrl.text.trim().isEmpty ||
                                        _annBodyCtrl.text.trim().isEmpty) {
                                      return;
                                    }
                                    await notifProv.publishAnnouncement(
                                      admin: admin,
                                      title: _annTitleCtrl.text.trim(),
                                      body: _annBodyCtrl.text.trim(),
                                      audience: _annAudience,
                                      pinned: _annPinned,
                                    );
                                    _annTitleCtrl.clear();
                                    _annBodyCtrl.clear();
                                  },
                                  icon: const Icon(Icons.send),
                                  label: const Text('Phát thông báo'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final a in notifProv.announcements)
                      Card(
                        child: ListTile(
                          leading: Icon(
                            a.pinned ? Icons.push_pin : Icons.campaign,
                          ),
                          title: Text(a.title),
                          subtitle: Text('${a.body}\nĐối tượng: ${a.audience}'),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () =>
                                notifProv.deleteAnnouncement(admin, a.id!),
                          ),
                        ),
                      ),
                  ],
                ),
                // Tab 4: Danh sách yêu cầu truyện
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifProv.requests.length,
                  itemBuilder: (context, index) {
                    final req = notifProv.requests[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${req.votes}')),
                        title: Text(
                          req.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Tác giả gợi ý: ${req.authorHint} • Đề xuất bởi: ${req.userName}\n${req.description}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
