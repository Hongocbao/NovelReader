import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../database/app_database.dart';
import '../../providers/auth_provider.dart';
import '../../providers/moderation_provider.dart';
import '../../widgets/loading_view.dart';

/// Màn hình Cài đặt Hệ thống (Chế độ bảo trì, Feature Flags, Sao lưu JSON) & Nhật ký thao tác Audit Log (Mục 6.7).
class AdminAuditAndSettingsScreen extends StatefulWidget {
  const AdminAuditAndSettingsScreen({super.key});

  @override
  State<AdminAuditAndSettingsScreen> createState() =>
      _AdminAuditAndSettingsScreenState();
}

class _AdminAuditAndSettingsScreenState
    extends State<AdminAuditAndSettingsScreen> {
  final _filterCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ModerationProvider>().loadAll();
    });
  }

  @override
  void dispose() {
    _filterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mod = context.watch<ModerationProvider>();
    final admin = context.watch<AuthProvider>().currentUser;

    if (mod.isLoading) return const LoadingView();

    final kw = _filterCtrl.text.trim().toLowerCase();
    final logs = mod.auditLogs.where((l) {
      if (kw.isEmpty) return true;
      return l.action.toLowerCase().contains(kw) ||
          l.adminName.toLowerCase().contains(kw) ||
          l.target.toLowerCase().contains(kw);
    }).toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.settings_applications_outlined),
                text: 'Cấu hình Hệ thống & Feature Flags',
              ),
              Tab(
                icon: Icon(Icons.history_edu_outlined),
                text: 'Nhật ký Quản trị (Audit Log - Bất biến)',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SwitchListTile(
                      title: const Text(
                        'Chế độ bảo trì hệ thống (Maintenance Mode)',
                      ),
                      subtitle: const Text(
                        'Khi bật, độc giả sẽ thấy màn hình thông báo bảo trì; chỉ Admin vẫn truy cập được.',
                      ),
                      value: mod.isMaintenanceMode,
                      onChanged: (v) => mod.updateConfig(
                        admin: admin,
                        key: 'maintenance_mode',
                        value: v.toString(),
                      ),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Cờ tính năng: Đọc thành tiếng (TTS)'),
                      value: mod.isTtsEnabled,
                      onChanged: (v) => mod.updateConfig(
                        admin: admin,
                        key: 'feature_tts',
                        value: v.toString(),
                      ),
                    ),
                    SwitchListTile(
                      title: const Text(
                        'Cờ tính năng: Bình luận & Thảo luận chương',
                      ),
                      value: mod.isCommentsEnabled,
                      onChanged: (v) => mod.updateConfig(
                        admin: admin,
                        key: 'feature_comments',
                        value: v.toString(),
                      ),
                    ),
                    SwitchListTile(
                      title: const Text('Cờ tính năng: Cho phép Đăng ký mới'),
                      value: mod.isRegistrationEnabled,
                      onChanged: (v) => mod.updateConfig(
                        admin: admin,
                        key: 'feature_registration',
                        value: v.toString(),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.backup_outlined),
                      title: const Text(
                        'Sao lưu toàn bộ dữ liệu hệ thống ra JSON',
                      ),
                      subtitle: const Text(
                        'Sao chép chuỗi JSON sao lưu vào bộ nhớ tạm',
                      ),
                      trailing: FilledButton.tonal(
                        onPressed: () async {
                          final jsonStr = await AppDatabase.instance
                              .exportUserBackupJson();
                          await Clipboard.setData(ClipboardData(text: jsonStr));
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Đã sao chép bản sao lưu JSON vào bộ nhớ tạm!',
                              ),
                            ),
                          );
                        },
                        child: const Text('Xuất JSON'),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _filterCtrl,
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                hintText:
                                    'Lọc theo tên Admin, hành động hoặc đối tượng...',
                                prefixIcon: Icon(Icons.search),
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Chip(
                            avatar: Icon(Icons.lock_outline, size: 16),
                            label: Text('Chỉ ghi thêm — Cấm sửa/xóa'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: logs.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final l = logs[index];
                          return ListTile(
                            leading: const Icon(Icons.verified_user_outlined),
                            title: Text(
                              '[${l.action}] → ${l.target}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Thực hiện bởi: ${l.adminName} (#${l.adminId}) • ${l.createdAt.toLocal()}\nChi tiết: ${l.detail}',
                            ),
                            isThreeLine: true,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
