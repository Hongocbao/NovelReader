import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/moderation_provider.dart';
import '../admin/admin_shell.dart';
import '../main_shell.dart';
import 'login_screen.dart';
import 'register_screen.dart';

/// Cổng điều hướng đầu tiên (SplashGate) theo đặc tả Mục 3 & Mục 7:
/// - Kiểm tra phiên đăng nhập hoặc cho phép chọn Khách / Đăng nhập / Đăng ký.
/// - Kiểm tra bắt buộc đổi mật khẩu ở lần đăng nhập đầu của Admin.
/// - Kiểm tra chế độ bảo trì (Maintenance Mode): chỉ Admin mới vào được khi đang bảo trì.
/// - Tự động điều hướng vào [AdminShell] (nếu là Admin) hoặc [MainShell] (nếu là User/Khách).
class SplashGate extends StatelessWidget {
  const SplashGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final mod = context.watch<ModerationProvider>();

    if (auth.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Nếu chưa từng chọn chế độ (Khách / Đăng nhập / Đăng ký), hiển thị màn hình chào mừng
    if (!auth.hasEnteredApp) {
      return const _WelcomeGateView();
    }

    // Nếu hệ thống đang bật chế độ bảo trì và người dùng không phải Admin -> hiển thị màn hình bảo trì
    if (mod.isMaintenanceMode && !auth.isAdmin) {
      return _MaintenanceView(message: mod.maintenanceMessage);
    }

    // Phân luồng theo vai trò: Admin vào AdminShell (trừ khi bật chế độ xem thử Độc giả)
    if (auth.shouldShowAdminShell) {
      return const AdminShell();
    }

    return const MainShell();
  }
}

class _WelcomeGateView extends StatelessWidget {
  const _WelcomeGateView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cs.primaryContainer.withValues(alpha: 0.7),
              cs.surface,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.auto_stories, size: 64, color: cs.primary),
                      const SizedBox(height: 16),
                      Text(
                        'NovelReader v2.0',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Đọc Truyện Chữ, Light Novel & Manga/Webtoon.\nSưu tầm Linh Thạch, Huy hiệu, Tủ sách 3D & Khu Quản Trị.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 28),
                      FilledButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.login),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Đăng nhập (User / Author / Admin)'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.person_add_outlined),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Đăng ký tài khoản mới'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () =>
                            context.read<AuthProvider>().continueAsGuest(),
                        icon: const Icon(Icons.explore_outlined),
                        label: const Text('Đọc ngay ở Chế độ Khách (Offline)'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MaintenanceView extends StatelessWidget {
  final String message;

  const _MaintenanceView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.construction,
                  size: 72,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                Text(
                  'Hệ thống đang bảo trì',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  icon: const Icon(Icons.admin_panel_settings_outlined),
                  label: const Text('Đăng nhập Quản trị viên (Admin)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
