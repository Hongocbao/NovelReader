import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// Giao diện hiển thị khi danh sách rỗng.
class EmptyView extends StatelessWidget {
  final String message;
  final IconData icon;
  final Widget? action;

  const EmptyView({
    super.key,
    this.message = AppStrings.empty,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: scheme.outline),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            if (action != null) ...[
              const SizedBox(height: 16),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
