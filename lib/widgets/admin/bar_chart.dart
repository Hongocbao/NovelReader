import 'dart:math';

import 'package:flutter/material.dart';

/// Mục dữ liệu cho biểu đồ cột (Bar Chart).
class BarChartEntry {
  final String label;
  final double value;
  final bool isDanger;

  const BarChartEntry({
    required this.label,
    required this.value,
    this.isDanger = false,
  });
}

/// Biểu đồ cột hiển thị Top truyện hoặc Bản đồ rớt chương (Drop-off Map).
class AdminBarChart extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<BarChartEntry> entries;

  const AdminBarChart({
    super.key,
    required this.title,
    this.subtitle,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final maxVal = entries.isEmpty
        ? 1.0
        : max(entries.map((e) => e.value).reduce(max), 1.0);

    return Card(
      elevation: 0,
      color: cs.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 12),
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Chưa có dữ liệu để hiển thị.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
            for (final item in entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: item.isDanger
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: item.isDanger ? cs.error : cs.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.isDanger
                              ? '${item.value.round()} (⚠️ Tụt mạnh)'
                              : '${item.value.round()}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: item.isDanger
                                    ? cs.error
                                    : cs.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (item.value / maxVal).clamp(0.03, 1.0),
                        minHeight: 9,
                        color: item.isDanger ? cs.error : cs.primary,
                        backgroundColor: cs.surfaceContainerHighest,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
