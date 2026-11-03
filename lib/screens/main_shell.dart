import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
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
    final profileNeedsRefresh = context.select<AuthProvider, bool>(
      (p) => p.profileNeedsRefresh,
    );
    if (isOnline && profileNeedsRefresh) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.read<AuthProvider>().refreshCurrentUser();
      });
    }
    final pages = <Widget>[
      HomeScreen(onJumpToTab: (i) => setState(() => _index = i)),
      const SearchScreen(),
      const LibraryScreen(),
      const _ProfileTab(),
    ];

    return Scaffold(
      body: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: isOnline
                ? const SizedBox(width: double.infinity, height: 0)
                : Material(
                    color: AppColors.offline,
                    child: SafeArea(
                      bottom: false,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 820),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.cloud_off_rounded,
                                  size: 17,
                                  color: AppColors.onBanner,
                                ),
                                const SizedBox(width: 10),
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
                                Icon(
                                  Icons.sync_rounded,
                                  size: 16,
                                  color: AppColors.onBanner.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: IndexedStack(index: _index, children: pages),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant
                  .withValues(alpha: 0.45),
            ),
          ),
        ),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: NavigationBar(
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
          ),
        ),
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
