import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/moderation_provider.dart';

/// Màn hình Đăng ký tài khoản mới (gộp toàn bộ dữ liệu Khách hiện có vào tài khoản mới).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      email: _emailCtrl.text.trim(),
      displayName: _nameCtrl.text.trim(),
      password: _passCtrl.text,
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            auth.profileNeedsRefresh
                ? 'Tài khoản đã đăng nhập. Hồ sơ sẽ được đồng bộ khi kết nối ổn định.'
                : '🎉 Đăng ký thành công! Tủ sách & lịch sử đọc trên máy đã được đồng bộ, tặng 150 Linh Thạch!',
          ),
        ),
      );
      if (Navigator.canPop(context)) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final mod = context.watch<ModerationProvider>();
    final cs = Theme.of(context).colorScheme;

    if (!mod.isRegistrationEnabled) {
      return Scaffold(
        appBar: AppBar(title: const Text('Đăng ký tài khoản')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Hệ thống tạm thời đóng đăng ký tài khoản mới theo cấu hình của Quản trị viên.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký tài khoản')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Tạo tài khoản Độc giả',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tủ sách, lịch sử đọc và bookmark hiện tại trên máy sẽ tự động gộp vào tài khoản mới.',
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tên hiển thị',
                      prefixIcon: Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().length < 2)
                        ? 'Tên hiển thị tối thiểu 2 ký tự'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'vidu: docgia123@gmail.com',
                      helperText:
                          'Tên Gmail tối thiểu 6 ký tự theo chuẩn Google',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Vui lòng nhập địa chỉ email';
                      }
                      final trimmed = v.trim();
                      if (!trimmed.contains('@') || !trimmed.contains('.')) {
                        return 'Vui lòng nhập định dạng email hợp lệ';
                      }
                      final parts = trimmed.split('@');
                      if (parts.length == 2 &&
                          parts[1].toLowerCase() == 'gmail.com') {
                        if (parts[0].length < 6 || parts[0].length > 30) {
                          return 'Tên tài khoản Gmail phải từ 6 đến 30 ký tự (ví dụ: baobao123@gmail.com)';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu (tối thiểu 8 ký tự)',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 8)
                        ? 'Mật khẩu phải từ 8 ký tự trở lên'
                        : null,
                  ),
                  if (auth.error != null) ...[
                    const SizedBox(height: 12),
                    Text(auth.error!, style: TextStyle(color: cs.error)),
                  ],
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: auth.isLoading ? null : _submit,
                    icon: const Icon(Icons.person_add),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Đăng ký & Nhận 150 Linh Thạch'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
