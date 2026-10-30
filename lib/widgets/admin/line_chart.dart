import 'dart:math';

import 'package:flutter/material.dart';

/// Biểu đồ đường (Line Chart) tự vẽ bằng CustomPainter hiển thị lượt đọc & người dùng theo ngày.
class AdminLineChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final String title;
  final Color? lineColor;

  const AdminLineChart({
    super.key,
    required this.values,
    required this.labels,
    required this.title,
    this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = lineColor ?? cs.primary;

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
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              width: double.infinity,
              child: values.isEmpty
                  ? const Center(child: Text('Chưa có dữ liệu'))
                  : CustomPaint(
                      painter: _LineChartPainter(
                        values: values,
                        lineColor: color,
                        gridColor: cs.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
            ),
            if (labels.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(labels.first, style: Theme.of(context).textTheme.bodySmall),
                  if (labels.length > 2)
                    Text(
                      labels[labels.length ~/ 2],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  Text(labels.last, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;
  final Color gridColor;

  _LineChartPainter({
    required this.values,
    required this.lineColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    for (var i = 0; i <= 3; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (values.isEmpty) return;
    final maxV = max(values.reduce(max), 1.0);
    final minV = min(values.reduce(min), 0.0);
    final span = max(maxV - minV, 1.0);

    final path = Path();
    final fillPath = Path();
    final stepX = values.length > 1 ? size.width / (values.length - 1) : 0.0;

    for (var i = 0; i < values.length; i++) {
      final x = i * stepX;
      final normalized = (values[i] - minV) / span;
      final y = size.height - (normalized * (size.height - 20)) - 10;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withValues(alpha: 0.32),
          lineColor.withValues(alpha: 0.02),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final strokePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.lineColor != lineColor;
}
