import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/role_guard.dart';
import 'audit_and_settings_screen.dart';
import 'banners_events_screen.dart';
import 'dashboard_screen.dart';
import 'moderation_queue_screen.dart';
import 'novels_manage_screen.dart';
import 'reports_screen.dart';
import 'users_manage_screen.dart';

/// Khung điều hướng Khu Quản Trị (AdminShell - Mục 3 & Mục 6):
/// - Có lớp bảo vệ Route Guard: chặn tuyệt đối nếu không phải Admin.
/// - Tự động dùng `NavigationRail` trên màn hình rộng (Web/Tablet/Desktop) và `Drawer` trên điện thoại.
/// - Có nút «Chuyển sang giao diện độc giả» để Admin tự kiểm tra trải nghiệm đọc.
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  static const _destinations = [
    (icon: Icons.dashboard_outlined, label: 'Dashboard'),
    (icon: Icons.library_books_outlined, label: 'Truyện & Chương'),
    (icon: Icons.fact_check_outlined, label: 'Hàng chờ duyệt'),
    (icon: Icons.people_outline, label: 'Người dùng'),
    (icon: Icons.flag_outlined, label: 'Báo cáo & Từ cấm'),
    (icon: Icons.campaign_outlined, label: 'Banner & Sự kiện'),
    (icon: Icons.security_outlined, label: 'Hệ thống & Audit'),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Lớp bảo vệ Route Guard số 1: Chặn truy cập trực tiếp nếu không có quyền manageSystem
    if (!RoleGuard.can(auth.currentUser, AppPermission.manageSystem)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Từ chối truy cập (403)')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Khu vực này chỉ dành cho Quản trị viên (Admin). Tài khoản hiện tại không được phép truy cập.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final pages = <Widget>[
      AdminDashboardScreen(
        onNavigateTab: (idx) => setState(() => _selectedIndex = idx),
      ),
      const AdminNovelsManageScreen(),
      const AdminModerationQueueScreen(),
      const AdminUsersManageScreen(),
      const AdminReportsScreen(),
      const AdminBannersEventsScreen(),
      const AdminAuditAndSettingsScreen(),
    ];

    final isWide = MediaQuery.sizeOf(context).width >= 760;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Center • ${_destinations[_selectedIndex].label}',
        ),
        actions: [
          FilledButton.tonalIcon(
            onPressed: () => auth.toggleAdminPreviewMode(),
            icon: const Icon(Icons.menu_book_outlined, size: 18),
            label: const Text('Chuyển sang giao diện độc giả'),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Đăng xuất',
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: isWide
          ? null
          : Drawer(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(auth.currentUser.displayName),
                    accountEmail: Text(auth.currentUser.email),
                    currentAccountPicture: CircleAvatar(
                      child: Text(
                        auth.currentUser.avatar,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  for (var i = 0; i < _destinations.length; i++)
                    ListTile(
                      selected: _selectedIndex == i,
                      leading: Icon(_destinations[i].icon),
                      title: Text(_destinations[i].label),
                      onTap: () {
                        setState(() => _selectedIndex = i);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ),
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              extended: MediaQuery.sizeOf(context).width >= 1100,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (idx) =>
                  setState(() => _selectedIndex = idx),
              destinations: _destinations
                  .map(
                    (d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      label: Text(d.label),
                    ),
                  )
                  .toList(),
            ),
          if (isWide) const VerticalDivider(width: 1),
          Expanded(child: pages[_selectedIndex]),
        ],
      ),
    );
  }
}
