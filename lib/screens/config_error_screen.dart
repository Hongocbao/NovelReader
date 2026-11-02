import 'package:flutter/material.dart';

/// Màn hình thông báo lỗi khi thiếu cấu hình SUPABASE_URL hoặc SUPABASE_ANON_KEY.
class ConfigErrorScreen extends StatelessWidget {
  const ConfigErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              color: const Color(0xFF27293D),
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: Colors.amberAccent,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Thiếu Cấu Hình Supabase',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Ứng dụng yêu cầu biến môi trường SUPABASE_URL và SUPABASE_ANON_KEY để kết nối cơ sở dữ liệu đám mây.\n\nVui lòng khởi chạy ứng dụng với cờ --dart-define:',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const SelectableText(
                        'flutter run \\\n'
                        '  --dart-define=SUPABASE_URL=https://... \\\n'
                        '  --dart-define=SUPABASE_ANON_KEY=sb_publishable_...',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.lightGreenAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
