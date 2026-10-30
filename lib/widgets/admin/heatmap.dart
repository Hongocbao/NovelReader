import 'dart:math';

import 'package:flutter/material.dart';

/// Biểu đồ Heatmap 7 ngày × 24 giờ cho biết khung giờ đọc cao điểm (Mục 6.1).
class AdminReadingHeatmap extends StatelessWidget {
  /// Lưới 7 dòng (T2..CN) × 24 cột (0..23h).
  final List<List<int>> grid;

  const AdminReadingHeatmap({super.key, required this.grid});

  static const List<String> _dayLabels = [
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
    'CN',
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    var maxCell = 1;
    for (final row in grid) {
      for (final v in row) {
        maxCell = max(maxCell, v);
      }
    }

    return Card(
      elevation: 0,
      color: cs.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Heatmap khung giờ đọc cao điểm (7 ngày × 24 giờ)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Màu càng đậm càng nhiều độc giả đang đọc — gợi ý khung giờ vàng để đăng chương mới (20h - 23h).',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 32),
                      for (var h = 0; h < 24; h++)
                        SizedBox(
                          width: 22,
                          child: Text(
                            '$h',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  for (var d = 0; d < min(grid.length, 7); d++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            child: Text(
                              _dayLabels[d],
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          for (var h = 0; h < 24; h++)
                            Tooltip(
                              message:
                                  '${_dayLabels[d]} - ${h}h: ${grid[d][h]} phiên đọc',
                              child: Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: cs.primary.withValues(
                                    alpha: (0.08 +
                                            0.88 * (grid[d][h] / maxCell))
                                        .clamp(0.08, 0.96),
                                  ),
                                ),
                              ),
                            ),
                        ],
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
