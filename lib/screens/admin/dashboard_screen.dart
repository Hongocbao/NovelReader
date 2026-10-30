import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/novel.dart';
import '../../providers/admin_dashboard_provider.dart';
import '../../widgets/admin/bar_chart.dart';
import '../../widgets/admin/heatmap.dart';
import '../../widgets/admin/kpi_card.dart';
import '../../widgets/admin/line_chart.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';

/// Màn hình Bảng điều khiển Quản trị (Admin Dashboard - Mục 6.1).
class AdminDashboardScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const AdminDashboardScreen({super.key, this.onNavigateTab});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedNovelIdForDropoff = 1;
  List<ChapterDropoffPoint> _dropoffPoints = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dash = context.read<AdminDashboardProvider>();
      await dash.loadDashboard();
      if (dash.topNovels.isNotEmpty) {
        _selectedNovelIdForDropoff = dash.topNovels.first.id;
      }
      await _loadDropoff();
    });
  }

  Future<void> _loadDropoff() async {
    final dash = context.read<AdminDashboardProvider>();
    final pts = await dash.computeDropoffForNovel(_selectedNovelIdForDropoff);
    if (mounted) {
      setState(() => _dropoffPoints = pts);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dash = context.watch<AdminDashboardProvider>();
    final cs = Theme.of(context).colorScheme;

    if (dash.isLoading && dash.topNovels.isEmpty) {
      return const LoadingView();
    }
    if (dash.error != null) {
      return ErrorView(
        message: dash.error!,
        onRetry: () => dash.loadDashboard(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => dash.loadDashboard(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng quan hệ thống',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 7, label: Text('7 ngày')),
                  ButtonSegment(value: 14, label: Text('14 ngày')),
                  ButtonSegment(value: 30, label: Text('30 ngày')),
                ],
                selected: {dash.rangeDays},
                onSelectionChanged: (s) => dash.setRangeDays(s.first),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 900
                  ? 3
                  : (constraints.maxWidth > 560 ? 2 : 1);
              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.15,
                children: [
                  KpiCard(
                    title: 'Tổng người dùng',
                    value: '${dash.totalUsers}',
                    deltaLabel: 'DAU: ${dash.dau} • WAU: ${dash.wau}',
                    icon: Icons.people_alt_outlined,
                    onTap: () => widget.onNavigateTab?.call(3),
                  ),
                  KpiCard(
                    title: 'Tổng kho truyện',
                    value: '${dash.totalNovels}',
                    deltaLabel: '+3 tác phẩm tuần này',
                    icon: Icons.library_books_outlined,
                    accentColor: Colors.indigo,
                    onTap: () => widget.onNavigateTab?.call(1),
                  ),
                  KpiCard(
                    title: 'Lượt đọc hôm nay',
                    value: '${dash.viewsToday}',
                    deltaLabel: '+18% so với hôm qua',
                    icon: Icons.auto_stories_outlined,
                    accentColor: Colors.teal,
                  ),
                  KpiCard(
                    title: 'Truyện chờ duyệt',
                    value: '${dash.pendingNovelsCount}',
                    deltaLabel: dash.pendingNovelsCount > 0
                        ? 'Cần duyệt ngay'
                        : 'Đã xử lý hết',
                    isPositive: dash.pendingNovelsCount == 0,
                    icon: Icons.fact_check_outlined,
                    accentColor: Colors.orange,
                    onTap: () => widget.onNavigateTab?.call(2),
                  ),
                  KpiCard(
                    title: 'Báo cáo vi phạm mở',
                    value: '${dash.openReportsCount}',
                    deltaLabel: dash.openReportsCount > 0
                        ? 'Cần kiểm duyệt'
                        : 'An toàn (0 tồn đọng)',
                    isPositive: dash.openReportsCount == 0,
                    icon: Icons.flag_outlined,
                    accentColor: cs.error,
                    onTap: () => widget.onNavigateTab?.call(4),
                  ),
                  KpiCard(
                    title: 'Tỉ lệ giữ chân 7 ngày',
                    value: '84.5%',
                    deltaLabel: '+4.2% nhờ Nhiệm vụ Linh Thạch',
                    icon: Icons.insights,
                    accentColor: Colors.purple,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          // Khối Việc cần làm ngay
          Card(
            elevation: 0,
            color: cs.secondaryContainer.withValues(alpha: 0.45),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bolt, color: cs.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Việc cần làm ngay',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (dash.pendingNovels.isEmpty && dash.openReports.isEmpty)
                    const Text(
                      '🎉 Tuyệt vời! Không có truyện chờ duyệt hay báo cáo vi phạm nào tồn đọng.',
                    )
                  else ...[
                    for (final n in dash.pendingNovels.take(3))
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.pending_actions),
                        title: Text('Chờ duyệt truyện: ${n.title}'),
                        subtitle: Text('Tác giả: ${n.author}'),
                        trailing: TextButton(
                          onPressed: () => widget.onNavigateTab?.call(2),
                          child: const Text('Duyệt ngay'),
                        ),
                      ),
                    for (final r in dash.openReports.take(3))
                      ListTile(
                        dense: true,
                        leading: Icon(Icons.report_problem, color: cs.error),
                        title: Text('Báo cáo ${r.targetType}: ${r.reason}'),
                        subtitle: Text(r.targetSnapshot),
                        trailing: TextButton(
                          onPressed: () => widget.onNavigateTab?.call(4),
                          child: const Text('Xử lý'),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AdminLineChart(
            title:
                'Biểu đồ lượt đọc & hoạt động theo ${dash.rangeDays} ngày gần nhất',
            values: dash.dailyReadsSeries,
            labels: dash.dailyLabels,
          ),
          const SizedBox(height: 16),
          AdminReadingHeatmap(grid: dash.hourlyHeatmap),
          const SizedBox(height: 16),
          AdminBarChart(
            title: 'Top 10 tác phẩm có lượt đọc cao nhất',
            entries: dash.topNovels
                .map(
                  (Novel n) => BarChartEntry(
                    label: '${n.title} (${n.author})',
                    value: n.views.toDouble(),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          // Bản đồ rớt chương (Drop-off Map)
          Card(
            elevation: 0,
            color: cs.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Bản đồ rớt chương (Chapter Drop-off Analyzer)',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (dash.topNovels.isNotEmpty)
                        DropdownButton<int>(
                          value: dash.topNovels.any(
                            (n) => n.id == _selectedNovelIdForDropoff,
                          )
                              ? _selectedNovelIdForDropoff
                              : dash.topNovels.first.id,
                          items: dash.topNovels
                              .map(
                                (n) => DropdownMenuItem<int>(
                                  value: n.id,
                                  child: SizedBox(
                                    width: 180,
                                    child: Text(
                                      n.title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => _selectedNovelIdForDropoff = v);
                            _loadDropoff();
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AdminBarChart(
                    title: 'Số độc giả theo từng chương',
                    subtitle:
                        'Chương tụt ≥ 30% độc giả được tô đỏ kèm gợi ý biên tập lại nội dung.',
                    entries: _dropoffPoints
                        .map(
                          (p) => BarChartEntry(
                            label: 'Chương ${p.chapterIndex}: ${p.title}',
                            value: p.readersCount.toDouble(),
                            isDanger: p.isSharpDrop,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AdminBarChart(
            title: 'Phân bố tác phẩm theo Thể loại',
            entries: dash.genreDistribution.entries
                .map(
                  (e) => BarChartEntry(
                    label: e.key,
                    value: e.value.toDouble(),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
