import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/novel.dart';
import '../../providers/library_provider.dart';
import '../../providers/novel_provider.dart';
import '../novel_detail_screen.dart';

/// Màn hình Tủ sách 3D (3D Bookshelf - Mục 5.4).
/// Hiển thị các bộ truyện như gáy sách xếp trên kệ gỗ, độ dày theo số chương, vuốt ngang để xoay góc nhìn 3D.
class Shelf3DScreen extends StatefulWidget {
  const Shelf3DScreen({super.key});

  @override
  State<Shelf3DScreen> createState() => _Shelf3DScreenState();
}

class _Shelf3DScreenState extends State<Shelf3DScreen> {
  double _rotationY = -0.18;

  static const List<Color> _spinePalette = [
    Color(0xFF283593),
    Color(0xFF00695C),
    Color(0xFF6A1B9A),
    Color(0xFFAD1457),
    Color(0xFF4E342E),
    Color(0xFF1565C0),
    Color(0xFF2E7D32),
    Color(0xFFD84315),
  ];

  @override
  Widget build(BuildContext context) {
    final lib = context.watch<LibraryProvider>();
    final novelProv = context.watch<NovelProvider>();
    final books = <Novel>[
      ...lib.items.map((e) => e.novel).whereType<Novel>(),
      ...novelProv.featured,
      ...novelProv.hot,
    ];
    final uniqueBooks = <int, Novel>{
      for (final b in books) b.id: b,
    }.values.take(12).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tủ sách 3D (Xoay cảm ứng)'),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            _rotationY =
                (_rotationY + details.delta.dx * 0.004).clamp(-0.55, 0.55);
          });
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'Vuốt ngang để xoay góc nhìn 3D • Chạm vào gáy sách để mở truyện',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0012)
                    ..rotateY(_rotationY)
                    ..rotateX(0.06),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4E342E),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 24,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            for (var i = 0; i < uniqueBooks.length; i++)
                              _BookSpine3D(
                                novel: uniqueBooks[i],
                                color:
                                    _spinePalette[i % _spinePalette.length],
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => NovelDetailScreen(
                                      novelId: uniqueBooks[i].id,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Thanh kệ gỗ 3D vẽ bằng CustomPaint
                        SizedBox(
                          height: 26,
                          width: double.infinity,
                          child: CustomPaint(painter: _WoodShelfPainter()),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Slider(
                  value: _rotationY,
                  min: -0.55,
                  max: 0.55,
                  label: 'Góc xoay 3D',
                  onChanged: (v) => setState(() => _rotationY = v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookSpine3D extends StatelessWidget {
  final Novel novel;
  final Color color;
  final VoidCallback onTap;

  const _BookSpine3D({
    required this.novel,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Độ dày gáy sách tỉ lệ với số chương
    final width = (34.0 + novel.totalChapters * 2.5).clamp(36.0, 58.0);
    return Tooltip(
      message: '${novel.title} (${novel.totalChapters} chương)',
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          height: 195,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                Color.lerp(color, Colors.black, 0.28)!,
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.45)),
          ),
          child: RotatedBox(
            quarterTurns: 3,
            child: Center(
              child: Text(
                novel.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WoodShelfPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final topPaint = Paint()..color = const Color(0xFF8D6E63);
    final frontPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.4),
      topPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.4, size.width, size.height * 0.6),
      frontPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
