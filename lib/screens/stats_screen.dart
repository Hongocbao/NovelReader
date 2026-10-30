import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reading_history.dart';
import '../providers/library_provider.dart';
import '../utils/constants.dart';
import '../utils/format.dart';
import '../utils/theme.dart';

/// Màn hình Thống kê đọc sách (`StatsScreen`):
/// hiển thị tổng số từ đã đọc, số phút đọc, chuỗi ngày đọc liên tiếp (Streak 🔥)
/// và biểu đồ cột 7 ngày gần nhất từ bảng `reading_sessions`.
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lp = context.read<LibraryProvider>();
      if (!lp.isLoaded && !lp.isLoading) {
        lp.load();
      }
    });
  }

  static String _keyOf(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LibraryProvider>();
    final scheme = Theme.of(context).colorScheme;
    final sessionsMap = <String, ReadingSessionStat>{
      for (final s in lp.sessions) s.dateKey: s,
    };

    final now = DateTime.now();
    final last7Days = <({String label, ReadingSessionStat stat})>[];
    var maxWords = 100;
    for (var i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final key = _keyOf(d);
      final stat = sessionsMap[key] ??
          ReadingSessionStat(dateKey: key, wordsRead: 0, minutesRead: 0);
      if (stat.wordsRead > maxWords) maxWords = stat.wordsRead;
      last7Days.add((label: '${d.day}/${d.month}', stat: stat));
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.statsScreenTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.gap),
        children: [
          // Thẻ tổng quan Streak & Danh hiệu
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: scheme.tertiaryContainer,
                        foregroundColor: scheme.onTertiaryContainer,
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chuỗi đọc liên tiếp: ${lp.currentStreak} ngày',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Danh hiệu hiện tại: ★ ${lp.readerRankTitle}',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MetricTile(
                        icon: Icons.abc_rounded,
                        label: 'Tổng số từ',
                        value: Format.views(lp.totalWordsRead),
                      ),
                      _MetricTile(
                        icon: Icons.timer_outlined,
                        label: 'Phút đã đọc',
                        value: '${lp.totalMinutesRead} phút',
                      ),
                      _MetricTile(
                        icon: Icons.menu_book_rounded,
                        label: 'Truyện đã đọc',
                        value: '${lp.history.length}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Biểu đồ 7 ngày gần nhất
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Biểu đồ số từ đã đọc (7 ngày qua)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 180,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final day in last7Days)
                          Expanded(
                            child: Semantics(
                              label:
                                  'Ngày ${day.label}: ${day.stat.wordsRead} từ, ${day.stat.minutesRead} phút',
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    day.stat.wordsRead == 0
                                        ? '0'
                                        : Format.views(day.stat.wordsRead),
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  const SizedBox(height: 6),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: (110 *
                                            (day.stat.wordsRead / maxWords))
                                        .clamp(8.0, 110.0),
                                    width: 24,
                                    decoration: BoxDecoration(
                                      color: day.stat.wordsRead > 0
                                          ? scheme.primary
                                          : scheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    day.label,
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, color: scheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
