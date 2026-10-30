import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// Giao diện hiển thị khi đang tải dữ liệu.
class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({super.key, this.message = AppStrings.loading});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
