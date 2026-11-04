import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/library_provider.dart';

/// Màn hình Reading Wrapped — Tổng kết hành trình đọc sách năm của bạn (Mục 5.5).
/// Hỗ trợ vuốt ngang qua các thẻ tổng kết và chụp xuất thành ảnh PNG (RepaintBoundary).
class ReadingWrappedScreen extends StatefulWidget {
  const ReadingWrappedScreen({super.key});

  @override
  State<ReadingWrappedScreen> createState() => _ReadingWrappedScreenState();
}

class _ReadingWrappedScreenState extends State<ReadingWrappedScreen> {
  final PageController _pageCtrl = PageController(viewportFraction: 0.88);
  final GlobalKey _repaintKey = GlobalKey();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final library = context.read<LibraryProvider>();
      if (!library.isLoaded && !library.isLoading) library.load();
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _exportCurrentCardAsPng() async {
    try {
      final boundary =
          _repaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 2.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();
      if (!mounted || bytes == null) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('📸 Đã kết xuất ảnh PNG Reading Wrapped!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(bytes, height: 280),
              ),
              const SizedBox(height: 8),
              Text(
                'Dung lượng ảnh: ${(bytes.lengthInBytes / 1024).toStringAsFixed(1)} KB',
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Không thể xuất ảnh: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final lib = context.watch<LibraryProvider>();
    final year = DateTime.now().year;
    final sessions = lib.sessions.where(
      (s) => DateTime.tryParse(s.dateKey)?.year == year,
    );
    final totalWords = sessions.fold<int>(0, (sum, s) => sum + s.wordsRead);
    final totalMinutes = sessions.fold<int>(0, (sum, s) => sum + s.minutesRead);
    final topNovel = lib.history.isNotEmpty
        ? (lib.history.first.novel?.title ?? 'Truyện đã đọc gần đây')
        : 'Chưa có truyện đã đọc';
    final favGenre =
        lib.history.isNotEmpty &&
            (lib.history.first.novel?.genres.isNotEmpty ?? false)
        ? lib.history.first.novel!.genres.first
        : 'Chưa có dữ liệu thể loại';

    final cards = [
      (
        emoji: '🌌',
        title: 'Tổng kết Hành trình Đọc $year',
        highlight: '$totalWords từ đã đọc',
        subtitle:
            '$totalMinutes phút đọc được ghi nhận trong năm cùng ${user.displayName}.',
        colors: [const Color(0xFF311B92), const Color(0xFF512DA8)],
      ),
      (
        emoji: '🏆',
        title: 'Truyện đọc gần đây',
        highlight: topNovel,
        subtitle: 'Tác phẩm trong lần đọc gần nhất được lưu ở lịch sử.',
        colors: [const Color(0xFF004D40), const Color(0xFF00796B)],
      ),
      (
        emoji: '🧭',
        title: 'Chân dung Gu đọc sách',
        highlight: favGenre,
        subtitle: 'Thể loại của tác phẩm bạn đọc gần đây nhất.',
        colors: [const Color(0xFF880E4F), const Color(0xFFC2185B)],
      ),
      (
        emoji: '👑',
        title: 'Danh hiệu hiện tại',
        highlight: lib.readerRankTitle,
        subtitle:
            'Chuỗi Streak: ${lib.currentStreak} ngày liên tiếp • ${auth.balanceNeedsRefresh ? 'Đang đồng bộ số dư' : 'Tích lũy ${user.linhThach} Linh Thạch'}.',
        colors: [const Color(0xFFE65100), const Color(0xFFF57C00)],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Reading Wrapped $year'),
        actions: [
          FilledButton.tonalIcon(
            onPressed: _exportCurrentCardAsPng,
            icon: const Icon(Icons.camera_alt_outlined, size: 18),
            label: const Text('Xuất ảnh PNG'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: RepaintBoundary(
              key: _repaintKey,
              child: PageView.builder(
                controller: _pageCtrl,
                itemCount: cards.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, index) {
                  final c = cards[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 16,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: c.colors,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(c.emoji, style: const TextStyle(fontSize: 64)),
                          const SizedBox(height: 20),
                          Text(
                            c.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            c.highlight,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            c.subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 28),
                          const Text(
                            'NovelReader v2.0 • Reading Wrapped',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Thẻ ${_currentIndex + 1} / ${cards.length} (Vuốt ngang để xem tiếp)',
            ),
          ),
        ],
      ),
    );
  }
}
