import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/quest_provider.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../downloads_screen.dart';
import '../history_screen.dart';
import '../settings_screen.dart';
import '../stats_screen.dart';
import 'author_studio_screen.dart';
import 'character_graph_screen.dart';
import 'mood_picker_sheet.dart';
import 'notifications_screen.dart';
import 'quests_and_achievements_screen.dart';
import 'shelf_3d_screen.dart';
import 'wrapped_screen.dart';

/// Màn hình Hồ sơ Cá nhân, Cửa hàng Linh Thạch, Bảng xếp hạng Cộng đồng & Trung tâm tiện ích v2 (Mục 5.1 - 5.5).
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _showOnLeaderboard = true;

  static const _shopItems = [
    (
      key: 'gold',
      title: 'Khung Avatar Hoàng Kim',
      desc: 'Viền vàng rực rỡ dành cho cao thủ đọc sách',
      cost: 80,
      icon: '👑',
    ),
    (
      key: 'jade',
      title: 'Khung Avatar Ngọc Bích Tiên Thiên',
      desc: 'Linh khí hộ thể phong cách Tu Tiên',
      cost: 120,
      icon: '🐉',
    ),
    (
      key: 'neon',
      title: 'Khung Avatar Cyberpunk Neon',
      desc: 'Hiệu ứng ánh sáng tương lai',
      cost: 150,
      icon: '⚡',
    ),
    (
      key: 'sepia_pro',
      title: 'Gói Nền Giấy Cổ Điển & Hiệu Ứng Lật Trang',
      desc: 'Trải nghiệm đọc sách giấy cao cấp',
      cost: 100,
      icon: '📜',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = context.read<AuthProvider>().currentUser.id;
      context.read<QuestProvider>().loadForUser(uid);
      context.read<NotificationProvider>().loadAll(uid);
    });
  }

  Future<void> _editProfileDialog() async {
    final auth = context.read<AuthProvider>();
    final nameCtrl = TextEditingController(text: auth.currentUser.displayName);
    String selectedAvatar = auth.currentUser.avatar;
    const avatars = ['📚', '🦊', '🐉', '👑', '🪶', '⚔️', '🧙', '🐱'];

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: const Text('Chỉnh sửa Hồ sơ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tên hiển thị',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Chọn bộ Avatar:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: avatars.map((av) {
                  return ChoiceChip(
                    label: Text(av, style: const TextStyle(fontSize: 20)),
                    selected: selectedAvatar == av,
                    onSelected: (_) =>
                        setModalState(() => selectedAvatar = av),
                  );
                }).toList(),
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
                await auth.updateProfile(
                  displayName: nameCtrl.text,
                  avatar: selectedAvatar,
                );
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final notif = context.watch<NotificationProvider>();
    final user = auth.currentUser;
    final cs = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hồ sơ & Thế giới Độc giả'),
          actions: [
            if (auth.isAdmin && auth.adminPreviewAsReader)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilledButton.icon(
                  onPressed: () => auth.toggleAdminPreviewMode(),
                  icon: const Icon(Icons.admin_panel_settings, size: 18),
                  label: const Text('Về Admin'),
                ),
              ),
            IconButton(
              tooltip: 'Thông báo',
              icon: Badge(
                isLabelVisible: notif.unreadCount > 0,
                label: Text('${notif.unreadCount}'),
                child: const Icon(Icons.notifications_outlined),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserNotificationsScreen(),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Cài đặt ứng dụng',
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_outline), text: 'Hồ sơ & Tiện ích'),
              Tab(
                icon: Icon(Icons.storefront_outlined),
                text: 'Cửa hàng Linh Thạch',
              ),
              Tab(
                icon: Icon(Icons.leaderboard_outlined),
                text: 'Bảng xếp hạng',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Hồ sơ & các tính năng sáng tạo
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 0,
                  color: cs.primaryContainer.withValues(alpha: 0.45),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 3,
                                  color: user.avatarFrame == 'gold'
                                      ? Colors.amber
                                      : (user.avatarFrame == 'jade'
                                            ? Colors.tealAccent
                                            : cs.primary),
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                child: Text(
                                  user.avatar,
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.displayName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    user.isGuest
                                        ? 'Chế độ Khách (Dữ liệu lưu cục bộ trên máy)'
                                        : '${user.email} • Vai trò: ${user.role.toUpperCase()}',
                                    style: TextStyle(
                                      color: cs.onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      Chip(
                                        visualDensity: VisualDensity.compact,
                                        label: Text('💎 ${user.linhThach} Linh Thạch'),
                                      ),
                                      Chip(
                                        visualDensity: VisualDensity.compact,
                                        label: Text('🔥 Streak ${user.streak} ngày'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (!user.isGuest)
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: _editProfileDialog,
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (user.isGuest)
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  ),
                                  icon: const Icon(Icons.login),
                                  label: const Text('Đăng nhập'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                    ),
                                  ),
                                  icon: const Icon(Icons.person_add_outlined),
                                  label: const Text('Đăng ký & Đồng bộ'),
                                ),
                              ),
                            ],
                          )
                        else
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => auth.logout(),
                              icon: const Icon(Icons.logout, size: 18),
                              label: const Text('Đăng xuất'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Nhóm tính năng Gamification & Khám phá v2
                _MenuTile(
                  icon: Icons.task_alt,
                  color: Colors.orange,
                  title: 'Nhiệm vụ Ngày / Tuần / Sự kiện & 20 Huy hiệu',
                  subtitle: 'Hoàn thành nhiệm vụ nhận Linh Thạch & Khiên Streak',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QuestsAndAchievementsScreen(),
                    ),
                  ),
                ),
                _MenuTile(
                  icon: Icons.auto_awesome,
                  color: Colors.deepPurple,
                  title: 'Reading Wrapped 2026 (Xuất ảnh PNG)',
                  subtitle: 'Nhìn lại tổng số từ, thể loại yêu thích & danh hiệu năm',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReadingWrappedScreen(),
                    ),
                  ),
                ),
                _MenuTile(
                  icon: Icons.view_in_ar,
                  color: Colors.brown,
                  title: 'Tủ sách 3D trên kệ gỗ',
                  subtitle: 'Xoay góc nhìn 3D, độ dày gáy sách theo số chương',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Shelf3DScreen()),
                  ),
                ),
                _MenuTile(
                  icon: Icons.mood,
                  color: Colors.teal,
                  title: 'Chọn truyện theo Tâm trạng & Gu đọc (Cosine)',
                  subtitle: 'Gợi ý thông minh không cần AI từ lịch sử đọc của bạn',
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const MoodPickerSheet(),
                  ),
                ),
                _MenuTile(
                  icon: Icons.hub_outlined,
                  color: Colors.indigo,
                  title: 'Sổ tay & Sơ đồ quan hệ Nhân vật (Kéo thả)',
                  subtitle: 'Tự vẽ mạng lưới Sư đồ, Đạo lữ, Kẻ thù theo truyện',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CharacterGraphScreen(),
                    ),
                  ),
                ),
                _MenuTile(
                  icon: Icons.edit_document,
                  color: Colors.pink,
                  title: 'Truyện của tôi (Author Studio)',
                  subtitle:
                      'Soạn chương tự lưu nháp 5 giây, gửi duyệt & thống kê lượt đọc',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AuthorStudioScreen(),
                    ),
                  ),
                ),
                const Divider(height: 24),
                _MenuTile(
                  icon: Icons.bar_chart,
                  color: Colors.blue,
                  title: 'Thống kê đọc sách 7 ngày & Streak',
                  subtitle: 'Biểu đồ số từ và số phút đọc hàng ngày',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StatsScreen()),
                  ),
                ),
                _MenuTile(
                  icon: Icons.history,
                  color: Colors.blueGrey,
                  title: 'Lịch sử đọc truyện',
                  subtitle: 'Tiếp tục đọc từ vị trí đã lưu',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  ),
                ),
                _MenuTile(
                  icon: Icons.download_done,
                  color: Colors.green,
                  title: 'Quản lý chương đã tải Offline',
                  subtitle: 'Đọc mượt mà không cần mạng',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DownloadsScreen()),
                  ),
                ),
              ],
            ),
            // Tab 2: Cửa hàng Linh Thạch
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    leading: const Text('💎', style: TextStyle(fontSize: 28)),
                    title: Text(
                      'Số dư hiện tại: ${user.linhThach} Linh Thạch',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Đọc truyện và làm nhiệm vụ mỗi ngày để nhận thêm Linh Thạch.',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                for (final item in _shopItems) ...[
                  Builder(
                    builder: (context) {
                      final owned = user.unlockedItems.contains(item.key);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: Text(
                            item.icon,
                            style: const TextStyle(fontSize: 28),
                          ),
                          title: Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(item.desc),
                          trailing: owned
                              ? OutlinedButton(
                                  onPressed: () => auth.updateProfile(
                                    avatarFrame: item.key,
                                  ),
                                  child: Text(
                                    user.avatarFrame == item.key
                                        ? 'Đang dùng'
                                        : 'Trang bị',
                                  ),
                                )
                              : FilledButton.tonal(
                                  onPressed: user.isGuest
                                      ? null
                                      : () async {
                                          final ok = await auth
                                              .purchaseShopItem(
                                                item.key,
                                                item.cost,
                                              );
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                ok
                                                    ? '🎉 Đã mở khóa ${item.title}!'
                                                    : 'Chưa đủ Linh Thạch.',
                                              ),
                                            ),
                                          );
                                        },
                                  child: Text('${item.cost} 💎'),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
            // Tab 3: Bảng xếp hạng cộng đồng
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SwitchListTile(
                  value: _showOnLeaderboard,
                  onChanged: (v) => setState(() => _showOnLeaderboard = v),
                  title: const Text('Hiển thị tên tôi trên Bảng xếp hạng tuần'),
                  subtitle: const Text(
                    'Chỉ hiển thị tên hiển thị & Linh Thạch, bảo mật email cá nhân.',
                  ),
                ),
                const Divider(),
                for (final entry in [
                  (
                    rank: 1,
                    name: 'Quản Trị Viên Tối Cao',
                    avatar: '👑',
                    score: '9.999 💎 • 48.200 từ',
                  ),
                  (
                    rank: 2,
                    name: 'Bút Mặc Tiên Sinh',
                    avatar: '🪶',
                    score: '450 💎 • 29.500 từ',
                  ),
                  if (_showOnLeaderboard)
                    (
                      rank: 3,
                      name: user.displayName,
                      avatar: user.avatar,
                      score: '${user.linhThach} 💎 • 18.450 từ',
                    ),
                  (
                    rank: 4,
                    name: 'Kiếm Khách Độc Hành',
                    avatar: '⚔️',
                    score: '180 💎 • 12.100 từ',
                  ),
                ])
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('#${entry.rank}')),
                      title: Text(
                        '${entry.avatar} ${entry.name}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(entry.score),
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

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
