import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reader_provider.dart';
import '../utils/constants.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'search_screen.dart';
import 'user/profile_screen.dart';

/// Khung chính của ứng dụng: thanh điều hướng 4 tab
/// (Trang chủ, Tìm kiếm, Tủ sách, Cá nhân) + thanh thông báo offline.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final isOnline = context.select<ReaderProvider, bool>((p) => p.isOnline);
    final pages = <Widget>[
      HomeScreen(onJumpToTab: (i) => setState(() => _index = i)),
      const SearchScreen(),
      const LibraryScreen(),
      const _ProfileTab(),
    ];

    return Scaffold(
      body: Column(
        children: [
          if (!isOnline)
            Material(
              color: AppColors.offline,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.cloud_off,
                          size: 16, color: AppColors.onBanner),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          AppStrings.offlineBanner,
                          style: TextStyle(
                            color: AppColors.onBanner,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: IndexedStack(
              index: _index,
              children: pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: AppStrings.navHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: AppStrings.navSearch,
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmarks_outlined),
            selectedIcon: Icon(Icons.bookmarks_rounded),
            label: AppStrings.navLibrary,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: AppStrings.navProfile,
          ),
        ],
      ),
    );
  }
}

/// Tab "Cá nhân": hiển thị màn Hồ sơ cá nhân, Nhiệm vụ, Cửa hàng Linh Thạch & lối tắt sang Cài đặt.
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return const UserProfileScreen();
  }
}
