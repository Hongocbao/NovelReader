import 'dart:convert';

import 'package:flutter/material.dart';

import '../../database/app_database.dart';
import '../../database/v2_database_store.dart';

/// Màn hình Sổ tay & Sơ đồ quan hệ nhân vật tự vẽ (Mục 5.5).
/// Cho phép kéo thả các nút nhân vật, nối bằng đường có nhãn (Sư đồ, Bạn bè, Kẻ thù, Người yêu) và lưu JSON theo truyện.
class CharacterGraphScreen extends StatefulWidget {
  final int novelId;
  final String novelTitle;

  const CharacterGraphScreen({
    super.key,
    this.novelId = 1,
    this.novelTitle = 'Sơ đồ Quan hệ Nhân vật',
  });

  @override
  State<CharacterGraphScreen> createState() => _CharacterGraphScreenState();
}

class _CharNode {
  String id;
  String name;
  String note;
  Offset pos;

  _CharNode({
    required this.id,
    required this.name,
    this.note = '',
    required this.pos,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'note': note,
        'dx': pos.dx,
        'dy': pos.dy,
      };

  factory _CharNode.fromJson(Map<String, dynamic> j) => _CharNode(
        id: j['id'] as String,
        name: j['name'] as String,
        note: (j['note'] as String?) ?? '',
        pos: Offset(
          (j['dx'] as num).toDouble(),
          (j['dy'] as num).toDouble(),
        ),
      );
}

class _CharEdge {
  String fromId;
  String toId;
  String label;

  _CharEdge({
    required this.fromId,
    required this.toId,
    required this.label,
  });

  Map<String, dynamic> toJson() => {
        'from': fromId,
        'to': toId,
        'label': label,
      };

  factory _CharEdge.fromJson(Map<String, dynamic> j) => _CharEdge(
        fromId: j['from'] as String,
        toId: j['to'] as String,
        label: j['label'] as String,
      );
}

class _CharacterGraphScreenState extends State<CharacterGraphScreen> {
  List<_CharNode> _nodes = [];
  List<_CharEdge> _edges = [];

  @override
  void initState() {
    super.initState();
    _loadGraph();
  }

  Future<void> _loadGraph() async {
    final db = await AppDatabase.instance.database;
    final graphJson = await V2DatabaseStore.getCharacterGraph(db, widget.novelId);
    if (graphJson != null && graphJson.isNotEmpty) {
      final decoded =
          jsonDecode(graphJson) as Map<String, dynamic>;
      _nodes = (decoded['nodes'] as List)
          .map((e) => _CharNode.fromJson(e as Map<String, dynamic>))
          .toList();
      _edges = (decoded['edges'] as List)
          .map((e) => _CharEdge.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      _nodes = [
        _CharNode(
          id: 'n1',
          name: 'Hàn Lập (Nhân vật chính)',
          note: 'Xuất hiện: Chương 1, 2, 3',
          pos: const Offset(140, 120),
        ),
        _CharNode(
          id: 'n2',
          name: 'Mặc Đại Phu',
          note: 'Sư phụ khai tâm • Chương 1',
          pos: const Offset(60, 280),
        ),
        _CharNode(
          id: 'n3',
          name: 'Nam Cung Uyển',
          note: 'Đạo lữ • Chương 2, 3',
          pos: const Offset(240, 280),
        ),
      ];
      _edges = [
        _CharEdge(fromId: 'n1', toId: 'n2', label: 'Sư đồ / Ân oán'),
        _CharEdge(fromId: 'n1', toId: 'n3', label: 'Đạo lữ'),
      ];
    }
    if (mounted) setState(() {});
  }

  Future<void> _saveGraph() async {
    final db = await AppDatabase.instance.database;
    final payload = jsonEncode({
      'nodes': _nodes.map((e) => e.toJson()).toList(),
      'edges': _edges.map((e) => e.toJson()).toList(),
    });
    await V2DatabaseStore.saveCharacterGraph(
      db,
      novelId: widget.novelId,
      graphJson: payload,
    );
  }

  Future<void> _addNodeDialog() async {
    final nameCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    String? connectToId = _nodes.isNotEmpty ? _nodes.first.id : null;
    String relLabel = 'Bạn đồng hành';

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: const Text('Thêm nhân vật vào Sơ đồ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Tên nhân vật *'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú / Chương xuất hiện',
                ),
              ),
              if (_nodes.isNotEmpty) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: connectToId,
                  decoration: const InputDecoration(
                    labelText: 'Nối quan hệ với',
                  ),
                  items: _nodes
                      .map(
                        (n) => DropdownMenuItem(
                          value: n.id,
                          child: Text(n.name),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setModalState(() => connectToId = v),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: relLabel,
                  decoration: const InputDecoration(labelText: 'Nhãn quan hệ'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Bạn đồng hành',
                      child: Text('Bạn đồng hành'),
                    ),
                    DropdownMenuItem(value: 'Sư đồ', child: Text('Sư đồ')),
                    DropdownMenuItem(value: 'Kẻ thù', child: Text('Kẻ thù')),
                    DropdownMenuItem(value: 'Đạo lữ', child: Text('Đạo lữ')),
                  ],
                  onChanged: (v) =>
                      setModalState(() => relLabel = v ?? 'Bạn đồng hành'),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                final newId = 'n${DateTime.now().millisecondsSinceEpoch}';
                setState(() {
                  _nodes.add(
                    _CharNode(
                      id: newId,
                      name: nameCtrl.text.trim(),
                      note: noteCtrl.text.trim(),
                      pos: const Offset(160, 180),
                    ),
                  );
                  if (connectToId != null) {
                    _edges.add(
                      _CharEdge(
                        fromId: connectToId!,
                        toId: newId,
                        label: relLabel,
                      ),
                    );
                  }
                });
                await _saveGraph();
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.novelTitle),
        actions: [
          FilledButton.tonalIcon(
            onPressed: _addNodeDialog,
            icon: const Icon(Icons.person_add_alt_1, size: 18),
            label: const Text('Thêm nhân vật'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: cs.surfaceContainerHighest,
            child: const Text(
              '💡 Kéo thả các thẻ nhân vật để sắp xếp sơ đồ quan hệ — vị trí được tự động lưu JSON theo truyện.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _GraphEdgePainter(
                      nodes: _nodes,
                      edges: _edges,
                      lineColor: cs.primary,
                      textColor: cs.onSurface,
                    ),
                  ),
                ),
                for (final node in _nodes)
                  Positioned(
                    left: node.pos.dx,
                    top: node.pos.dy,
                    child: GestureDetector(
                      onPanUpdate: (d) {
                        setState(() {
                          node.pos = Offset(
                            (node.pos.dx + d.delta.dx).clamp(8.0, 500.0),
                            (node.pos.dy + d.delta.dy).clamp(8.0, 520.0),
                          );
                        });
                      },
                      onPanEnd: (_) => _saveGraph(),
                      child: Card(
                        elevation: 3,
                        color: cs.primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                node.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: cs.onPrimaryContainer,
                                ),
                              ),
                              if (node.note.isNotEmpty)
                                Text(
                                  node.note,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: cs.onPrimaryContainer
                                        .withValues(alpha: 0.8),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GraphEdgePainter extends CustomPainter {
  final List<_CharNode> nodes;
  final List<_CharEdge> edges;
  final Color lineColor;
  final Color textColor;

  _GraphEdgePainter({
    required this.nodes,
    required this.edges,
    required this.lineColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final map = {for (final n in nodes) n.id: n};
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.2;

    for (final e in edges) {
      final a = map[e.fromId];
      final b = map[e.toId];
      if (a == null || b == null) continue;
      final p1 = a.pos + const Offset(65, 25);
      final p2 = b.pos + const Offset(65, 25);
      canvas.drawLine(p1, p2, paint);

      final mid = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
      final tp = TextPainter(
        text: TextSpan(
          text: ' ${e.label} ',
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            backgroundColor: lineColor.withValues(alpha: 0.18),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, mid - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
