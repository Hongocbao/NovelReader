import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../providers/admin_user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/admin/data_table_x.dart';
import '../../widgets/loading_view.dart';

/// Màn hình Quản lý Người dùng của Admin (Mục 6.4).
/// Hỗ trợ tìm kiếm, lọc theo role/trạng thái, xuất CSV, khóa tài khoản (1 ngày / 7 ngày / vĩnh viễn), cấp quyền Author/Admin.
class AdminUsersManageScreen extends StatefulWidget {
  const AdminUsersManageScreen({super.key});

  @override
  State<AdminUsersManageScreen> createState() => _AdminUsersManageScreenState();
}

class _AdminUsersManageScreenState extends State<AdminUsersManageScreen> {
  final _searchCtrl = TextEditingController();
  String _roleFilter = 'all';
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminUserProvider>().loadUsers();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _showBanDialog(AppUser target) async {
    final reasonCtrl = TextEditingController(text: 'Vi phạm nội quy bình luận');
    int? days = 7;
    final admin = context.read<AuthProvider>().currentUser;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text('Khóa tài khoản: ${target.displayName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int?>(
                initialValue: days,
                decoration: const InputDecoration(
                  labelText: 'Thời hạn khóa',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1 ngày')),
                  DropdownMenuItem(value: 7, child: Text('7 ngày')),
                  DropdownMenuItem(value: null, child: Text('Vĩnh viễn')),
                ],
                onChanged: (v) => setModalState(() => days = v),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonCtrl,
                decoration: const InputDecoration(
                  labelText: 'Lý do khóa tài khoản',
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
            FilledButton(
              onPressed: () async {
                try {
                  await context.read<AdminUserProvider>().banUser(
                        admin: admin,
                        target: target,
                        reason: reasonCtrl.text,
                        durationDays: days,
                      );
                  if (ctx.mounted) Navigator.pop(ctx);
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              child: const Text('Xác nhận Khóa'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showResetPasswordDialog(AppUser target) async {
    final admin = context.read<AuthProvider>().currentUser;
    final prov = context.read<AdminUserProvider>();
    final newPass = await showDialog<String>(
      context: context,
      builder: (_) => _ResetPasswordDialog(target: target),
    );
    if (newPass == null || !mounted) return;
    try {
      await prov.resetTemporaryPassword(
        admin: admin,
        target: target,
        tempPassword: newPass,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã cập nhật mật khẩu mới cho ${target.email} thành công!',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AdminUserProvider>();
    final admin = context.watch<AuthProvider>().currentUser;

    if (prov.isLoading) return const LoadingView();

    final kw = _searchCtrl.text.trim().toLowerCase();
    final filtered = prov.users.where((u) {
      if (_roleFilter != 'all' && u.role != _roleFilter) return false;
      if (_statusFilter != 'all' && u.status != _statusFilter) return false;
      if (kw.isNotEmpty) {
        return u.email.toLowerCase().contains(kw) ||
            u.displayName.toLowerCase().contains(kw);
      }
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 260,
              child: TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Tìm email hoặc tên hiển thị...',
                  prefixIcon: Icon(Icons.search),
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            DropdownButton<String>(
              value: _roleFilter,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('Mọi vai trò')),
                DropdownMenuItem(value: 'user', child: Text('Độc giả (user)')),
                DropdownMenuItem(value: 'author', child: Text('Tác giả (author)')),
                DropdownMenuItem(value: 'admin', child: Text('Quản trị (admin)')),
              ],
              onChanged: (v) => setState(() => _roleFilter = v ?? 'all'),
            ),
            DropdownButton<String>(
              value: _statusFilter,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('Mọi trạng thái')),
                DropdownMenuItem(value: 'active', child: Text('Hoạt động')),
                DropdownMenuItem(value: 'banned', child: Text('Đang khóa')),
              ],
              onChanged: (v) => setState(() => _statusFilter = v ?? 'all'),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                final csv = prov.exportUsersCsv();
                await Clipboard.setData(ClipboardData(text: csv));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Đã xuất & sao chép bảng CSV người dùng vào bộ nhớ tạm!',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.download_outlined),
              label: const Text('Xuất CSV'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DataTableX(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Tài khoản')),
            DataColumn(label: Text('Vai trò')),
            DataColumn(label: Text('Tác giả')),
            DataColumn(label: Text('Linh Thạch')),
            DataColumn(label: Text('Trạng thái')),
            DataColumn(label: Text('Thao tác')),
          ],
          rows: filtered.map((u) {
            return DataRow(
              cells: [
                DataCell(Text('#${u.id}')),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${u.avatar} ${u.displayName}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(u.email, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                DataCell(
                  DropdownButton<String>(
                    value: const ['user', 'author', 'admin'].contains(u.role)
                        ? u.role
                        : 'user',
                    items: const [
                      DropdownMenuItem(value: 'user', child: Text('user')),
                      DropdownMenuItem(value: 'author', child: Text('author')),
                      DropdownMenuItem(value: 'admin', child: Text('admin')),
                    ],
                    onChanged: u.id == admin.id
                        ? null
                        : (newRole) async {
                            if (newRole == null) return;
                            try {
                              await prov.changeUserRole(
                                admin: admin,
                                target: u,
                                newRole: newRole,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Đã cập nhật vai trò thành công: $newRole')),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          },
                  ),
                ),
                DataCell(
                  Switch(
                    value: u.isAuthor,
                    onChanged: (v) async {
                      try {
                        await prov.toggleAuthorRole(
                          admin: admin,
                          target: u,
                          isAuthor: v,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                v
                                    ? 'Đã cấp quyền Tác giả cho ${u.displayName}'
                                    : 'Đã thu hồi quyền Tác giả của ${u.displayName}',
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      }
                    },
                  ),
                ),
                DataCell(Text('💎 ${u.linhThach}')),
                DataCell(
                  Chip(
                    label: Text(u.isBanned ? 'Bị khóa' : 'Hoạt động'),
                    backgroundColor: u.isBanned
                        ? Colors.red.withValues(alpha: 0.15)
                        : Colors.green.withValues(alpha: 0.15),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!u.isBanned)
                        IconButton(
                          tooltip: 'Khóa tài khoản',
                          icon: const Icon(Icons.block, color: Colors.red),
                          onPressed:
                              u.id == admin.id ? null : () => _showBanDialog(u),
                        )
                      else
                        TextButton(
                          onPressed: () async {
                            try {
                              await prov.unbanUser(admin: admin, target: u);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Đã mở khóa tài khoản ${u.displayName}'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          },
                          child: const Text('Mở khóa'),
                        ),
                      IconButton(
                        tooltip: 'Đổi / Đặt lại mật khẩu',
                        icon: const Icon(Icons.key_outlined),
                        onPressed: () => _showResetPasswordDialog(u),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ResetPasswordDialog extends StatefulWidget {
  final AppUser target;

  const _ResetPasswordDialog({required this.target});

  @override
  State<_ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<_ResetPasswordDialog> {
  final _passCtrl = TextEditingController(text: 'Temp@1234');

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Đổi mật khẩu: ${widget.target.displayName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tài khoản: ${widget.target.email}',
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passCtrl,
            decoration: const InputDecoration(
              labelText: 'Mật khẩu mới (tối thiểu 6 ký tự)',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (v) {
              if (v.trim().length >= 6) {
                Navigator.pop(context, v.trim());
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () {
            final v = _passCtrl.text.trim();
            if (v.length < 6) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mật khẩu phải có ít nhất 6 ký tự.'),
                ),
              );
              return;
            }
            Navigator.pop(context, v);
          },
          child: const Text('Lưu mật khẩu'),
        ),
      ],
    );
  }
}
