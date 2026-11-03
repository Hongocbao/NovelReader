import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../database/v2_database_store.dart';
import '../models/novel.dart';
import '../models/reading_history.dart';
import '../models/report.dart';

/// Dữ liệu rớt chương (Drop-off) cho từng chương của một bộ truyện.
class ChapterDropoffPoint {
  final int chapterIndex;
  final String title;
  final int readersCount;
  final bool isSharpDrop;

  const ChapterDropoffPoint({
    required this.chapterIndex,
    required this.title,
    required this.readersCount,
    required this.isSharpDrop,
  });
}

/// Quản lý số liệu thống kê thực tế cho khu vực Admin Dashboard (Mục 6.1).
class AdminDashboardProvider extends ChangeNotifier {
  final AppDatabase _appDb;

  bool _isLoading = false;
  String? _error;
  int _rangeDays = 30;

  int totalUsers = 0;
  int dau = 0;
  int wau = 0;
  int totalNovels = 0;
  int viewsToday = 0;
  int openReportsCount = 0;
  int pendingNovelsCount = 0;

  /// Chuỗi dữ liệu biểu đồ đường (lượt đọc/từ đọc theo ngày).
  List<double> dailyReadsSeries = [];
  List<String> dailyLabels = [];

  /// Top 10 truyện có lượt xem cao nhất.
  List<Novel> topNovels = [];

  /// Tỉ lệ thể loại được đọc/có trong kho.
  Map<String, int> genreDistribution = {};

  /// Lưới Heatmap 7 ngày trong tuần (0=T2..6=CN) × 24 giờ.
  List<List<int>> hourlyHeatmap = List.generate(
    7,
    (_) => List.filled(24, 0),
  );

  /// Danh sách việc cần làm ngay.
  List<Novel> pendingNovels = [];
  List<ReportItem> openReports = [];

  AdminDashboardProvider(this._appDb);

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get rangeDays => _rangeDays;

  void setRangeDays(int days) {
    _rangeDays = days;
    loadDashboard();
  }

  /// Tính toán toàn bộ KPI và biểu đồ từ dữ liệu thật trong SQLite.
  Future<void> loadDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final db = await _appDb.database;
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day)
          .millisecondsSinceEpoch;
      final sevenDaysAgo = now
          .subtract(const Duration(days: 7))
          .millisecondsSinceEpoch;
      final metrics = await V2DatabaseStore.getAdminDashboardMetrics(_rangeDays);

      final sessions = await _appDb.getReadingSessions();
      if (metrics != null) {
        totalUsers = (metrics['total_users'] as num?)?.toInt() ?? 0;
        dau = (metrics['dau'] as num?)?.toInt() ?? 0;
        wau = (metrics['wau'] as num?)?.toInt() ?? 0;
        totalNovels = (metrics['total_novels'] as num?)?.toInt() ?? 0;
        viewsToday = (metrics['views_today'] as num?)?.toInt() ?? 0;
      } else {
        totalUsers = Sqflite.firstIntValue(
              await db.rawQuery('SELECT COUNT(*) FROM nguoi_dung'),
            ) ??
            0;
        dau = Sqflite.firstIntValue(
              await db.rawQuery(
                'SELECT COUNT(*) FROM nguoi_dung WHERE last_active_at >= ?',
                [startOfDay],
              ),
            ) ??
            0;
        wau = Sqflite.firstIntValue(
              await db.rawQuery(
                'SELECT COUNT(*) FROM nguoi_dung WHERE last_active_at >= ?',
                [sevenDaysAgo],
              ),
            ) ??
            0;
        totalNovels = Sqflite.firstIntValue(
              await db.rawQuery(
                'SELECT COUNT(*) FROM truyen WHERE deleted_at IS NULL',
              ),
            ) ??
            0;
        final logs = await V2DatabaseStore.getSessionLogs(db);
        viewsToday = logs.where((log) => log.startedAt.millisecondsSinceEpoch >= startOfDay).length;
      }

      final allNovels = await _appDb.queryNovels(
        includeUnapproved: true,
        limit: 1000,
      );
      pendingNovels = allNovels
          .where((novel) => novel.moderationStatus == ModerationStatus.pending)
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      pendingNovelsCount = pendingNovels.length;

      openReports = (await V2DatabaseStore.getReports(db))
          .where((report) => report.status == 'open')
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      openReportsCount = openReports.length;

      final novelsByViews = await _appDb.queryNovels(
        sort: NovelSort.views,
        includeUnapproved: true,
        limit: 10,
      );
      topNovels = novelsByViews;

      // Phân bố thể loại
      genreDistribution = await _appDb.genreCounts(includeUnapproved: true);

      // Chuỗi biểu đồ đường theo kỳ chọn (7/30/90 ngày)
      final points = <double>[];
      final labels = <String>[];
      final cloudDaily = (metrics?['daily'] as List?)
              ?.cast<Map<String, dynamic>>()
              .fold<Map<String, ReadingSessionStat>>({}, (map, row) {
            final stat = ReadingSessionStat(
              dateKey: row['date_key'] as String,
              wordsRead: (row['words_read'] as num?)?.toInt() ?? 0,
              minutesRead: (row['minutes_read'] as num?)?.toInt() ?? 0,
            );
            map[stat.dateKey] = stat;
            return map;
          }) ??
          <String, ReadingSessionStat>{};
      final sessionMap = metrics == null
          ? {for (final s in sessions) s.dateKey: s}
          : cloudDaily;
      final count = _rangeDays.clamp(7, 90);
      for (var i = count - 1; i >= 0; i--) {
        final d = now.subtract(Duration(days: i));
        final key =
            '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        final stat = sessionMap[key];
        final value = stat != null
            ? (stat.minutesRead * 10 + stat.wordsRead / 50)
            : 0.0;
        points.add(value);
        labels.add('${d.day}/${d.month}');
      }
      dailyReadsSeries = points;
      dailyLabels = labels;

      // Heatmap 7 ngày × 24 giờ từ reading_session_logs
      final grid = List.generate(7, (_) => List.filled(24, 0));
      if (metrics != null) {
        for (final row in (metrics['heatmap'] as List? ?? const [])) {
          final item = row as Map<String, dynamic>;
          final weekday = (item['weekday'] as num?)?.toInt() ?? -1;
          final hour = (item['hour'] as num?)?.toInt() ?? -1;
          if (weekday >= 0 && weekday < 7 && hour >= 0 && hour < 24) {
            grid[weekday][hour] = (item['sessions'] as num?)?.toInt() ?? 0;
          }
        }
      } else {
        final logs = await V2DatabaseStore.getSessionLogs(db);
        for (final log in logs) {
          final weekdayIdx = (log.startedAt.weekday - 1).clamp(0, 6);
          final hourIdx = log.hourOfDay.clamp(0, 23);
          grid[weekdayIdx][hourIdx] += 1;
        }
      }
      hourlyHeatmap = grid;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Phân tích bản đồ rớt chương (Drop-off) cho một bộ truyện cụ thể.
  Future<List<ChapterDropoffPoint>> computeDropoffForNovel(int novelId) async {
    final chapters = await _appDb.getChapters(novelId);
    if (chapters.isEmpty) return [];

    final cloudRows = await V2DatabaseStore.getAdminNovelChapterReaders(
      novelId,
    );
    final counts = <int, int>{};
    if (cloudRows != null) {
      for (final row in cloudRows) {
        final chapterId = (row['chapter_id'] as num?)?.toInt();
        if (chapterId != null) {
          counts[chapterId] = (row['readers_count'] as num?)?.toInt() ?? 0;
        }
      }
    } else {
      final db = await _appDb.database;
      final sessions = (await V2DatabaseStore.getSessionLogs(db))
          .where((session) => session.novelId == novelId)
          .toList();
      final chapterReaders = <int, Set<String>>{};
      final chapterSessions = <int, int>{};
      for (final session in sessions) {
        chapterSessions.update(
          session.chapterId,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
        if (session.userId.isNotEmpty) {
          chapterReaders.putIfAbsent(session.chapterId, () => <String>{})
            .add(session.userId);
        }
      }
      for (final chapter in chapters) {
        // Guest/local sessions may not carry a user id; count those sessions.
        counts[chapter.id] = chapterReaders[chapter.id]?.length ??
            chapterSessions[chapter.id] ??
            0;
      }
    }
    if (counts.values.every((count) => count == 0)) return [];

    final result = <ChapterDropoffPoint>[];
    int? prev;
    for (var i = 0; i < chapters.length; i++) {
      final ch = chapters[i];
      final current = counts[ch.id] ?? 0;
      final dropRatio = prev != null && prev > 0
          ? (prev - current) / prev
          : 0.0;
      result.add(
        ChapterDropoffPoint(
          chapterIndex: ch.chapterIndex,
          title: ch.title,
          readersCount: current,
          isSharpDrop: dropRatio >= 0.30,
        ),
      );
      prev = current;
    }
    return result;
  }
}
