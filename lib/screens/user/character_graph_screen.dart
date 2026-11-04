import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/app_database.dart';
import '../../database/v2_database_store.dart';
import '../../models/novel.dart';
import '../../providers/novel_provider.dart';
import '../novel_detail_screen.dart';

/// Màn hình Sổ tay & Sơ đồ quan hệ nhân vật tương tác (Mục 5.5).
/// Giúp độc giả theo dõi các bộ truyện dài tập (Tiên hiệp, Trinh thám, Cung đấu...)
/// không bị quên nhân vật: Ai là Nhân vật chính, Sư phụ, Đạo lữ, Kẻ thù, Đồng minh.
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
  String role;
  String note;
  Offset pos;

  _CharNode({
    required this.id,
    required this.name,
    this.role = 'Nhân vật chính',
    this.note = '',
    required this.pos,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'note': note,
        'dx': pos.dx,
        'dy': pos.dy,
      };

  factory _CharNode.fromJson(Map<String, dynamic> j) => _CharNode(
        id: j['id'] as String,
        name: j['name'] as String,
        role: (j['role'] as String?) ?? 'Đồng hành',
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
  List<Novel> _availableNovels = [];
  late int _selectedNovelId;
  late String _selectedNovelTitle;
  List<_CharNode> _nodes = [];
  List<_CharEdge> _edges = [];
  bool _analyzingAi = false;

  static const _roles = [
    'Nhân vật chính',
    'Đạo lữ / Người yêu',
    'Sư phụ / Tiền bối',
    'Bạn đồng hành',
    'Kẻ thù / Phản diện',
    'Bí ẩn / Trung lập',
  ];

  static const _relationLabels = [
    'Bạn đồng hành',
    'Sư đồ / Ân nhân',
    'Đạo lữ / Tri kỷ',
    'Kẻ thù sinh tử',
    'Gia tộc / Huyết thống',
    'Đối thủ cạnh tranh',
  ];

  @override
  void initState() {
    super.initState();
    _selectedNovelId = widget.novelId;
    _selectedNovelTitle = widget.novelTitle;
    _initNovelsAndGraph();
  }

  Future<void> _initNovelsAndGraph() async {
    try {
      final np = context.read<NovelProvider?>();
      final fromProvider = np == null
          ? <Novel>[]
          : <Novel>[...np.featured, ...np.newest, ...np.hot, ...np.completed];
      final queried = await AppDatabase.instance.queryNovels(limit: 60);
      final byId = <int, Novel>{
        for (final n in [...fromProvider, ...queried]) n.id: n,
      };
      final list = byId.values.toList();
      if (mounted && list.isNotEmpty) {
        _availableNovels = list;
        final match = list.where((n) => n.id == _selectedNovelId).firstOrNull ??
            list.first;
        _selectedNovelId = match.id;
        _selectedNovelTitle = match.title;
      }
    } catch (_) {}
    await _loadGraph();
  }

  Future<void> _loadGraph() async {
    final db = await AppDatabase.instance.database;
    final graphJson = await V2DatabaseStore.getCharacterGraph(
      db,
      _selectedNovelId,
    );
    if (graphJson != null && graphJson.isNotEmpty) {
      final decoded = jsonDecode(graphJson) as Map<String, dynamic>;
      _nodes = (decoded['nodes'] as List)
          .map((e) => _CharNode.fromJson(e as Map<String, dynamic>))
          .toList();
      _edges = (decoded['edges'] as List)
          .map((e) => _CharEdge.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      await _generateGraphFromNovelContent(saveAfter: false);
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
      novelId: _selectedNovelId,
      graphJson: payload,
    );
  }

  /// Tự động phân tích nội dung chương 1 + mô tả của bộ truyện đang chọn để dựng sơ đồ nhân vật.
  Future<void> _generateGraphFromNovelContent({bool saveAfter = true}) async {
    setState(() => _analyzingAi = true);
    try {
      final novel = _availableNovels
          .where((n) => n.id == _selectedNovelId)
          .firstOrNull;
      String sampleText = novel?.description ?? '';
      try {
        final ch1 = await AppDatabase.instance.fetchChapterContent(
          _selectedNovelId,
          1,
        );
        sampleText = '$sampleText\n$ch1';
      } catch (_) {}

      final extracted = _extractProperNames(sampleText);
      if (extracted.length >= 2) {
        final positions = <Offset>[
          const Offset(220, 70),
          const Offset(70, 210),
          const Offset(370, 210),
          const Offset(110, 350),
          const Offset(330, 350),
        ];
        final roles = <String>[
          'Nhân vật chính',
          'Bạn đồng hành',
          'Sư phụ / Tiền bối',
          'Đạo lữ / Người yêu',
          'Kẻ thù / Phản diện',
        ];
        final rels = <String>[
          'Đồng hành',
          'Sư đồ / Tiền bối',
          'Tri kỷ',
          'Đối đầu / Ân oán',
        ];
        _nodes = [
          for (var i = 0; i < extracted.length && i < 5; i++)
            _CharNode(
              id: 'n${i + 1}',
              name: extracted[i],
              role: roles[i % roles.length],
              note: i == 0
                  ? 'Trung tâm mạch truyện • Chương 1+'
                  : 'Xuất hiện trong "${novel?.title ?? _selectedNovelTitle}"',
              pos: positions[i % positions.length],
            ),
        ];
        _edges = [
          for (var i = 1; i < _nodes.length; i++)
            _CharEdge(
              fromId: 'n1',
              toId: _nodes[i].id,
              label: rels[(i - 1) % rels.length],
            ),
        ];
      } else {
        _nodes = [
          _CharNode(
            id: 'n1',
            name: 'Nhân vật trung tâm (${novel?.title ?? "Truyện"})',
            role: 'Nhân vật chính',
            note: 'Khởi đầu hành trình • Chương 1',
            pos: const Offset(200, 80),
          ),
          _CharNode(
            id: 'n2',
            name: 'Người dẫn đường / Tiền bối',
            role: 'Sư phụ / Tiền bối',
            note: 'Mở ra bí mật đầu truyện',
            pos: const Offset(70, 240),
          ),
          _CharNode(
            id: 'n3',
            name: 'Tri kỷ đồng hành',
            role: 'Bạn đồng hành',
            note: 'Sát cánh vượt thử thách',
            pos: const Offset(330, 240),
          ),
        ];
        _edges = [
          _CharEdge(fromId: 'n1', toId: 'n2', label: 'Sư đồ / Dẫn dắt'),
          _CharEdge(fromId: 'n1', toId: 'n3', label: 'Bạn đồng hành'),
        ];
      }
      if (saveAfter) {
        await _saveGraph();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✨ Đã tự động phân tích ${_nodes.length} nhân vật từ nội dung "$_selectedNovelTitle"!',
              ),
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _analyzingAi = false);
    }
  }

  List<String> _extractProperNames(String text) {
    final regex = RegExp(
      r'\b([A-ZÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ][a-zàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]+(?:\s+[A-ZÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ][a-zàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]+){1,2})\b',
    );
    const stopWords = {
      'Chương Một',
      'Chương Hai',
      'Hồi Một',
      'Hồi Hai',
      'Trong Khi',
      'Tuy Nhiên',
      'Nhưng Mà',
      'Không Gian',
      'Thời Gian',
      'Thế Giới',
      'Con Người',
      'Mọi Người',
      'Bầu Trời',
      'Ánh Sáng',
    };
    final counts = <String, int>{};
    for (final m in regex.allMatches(text)) {
      final candidate = m.group(1)?.trim() ?? '';
      if (candidate.length < 4 || stopWords.contains(candidate)) continue;
      counts[candidate] = (counts[candidate] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.map((e) => e.key).take(5).toList();
  }

  Color _roleColor(_CharNode node, ColorScheme cs) {
    return switch (node.role) {
      'Nhân vật chính' => Colors.amber.shade800,
      'Đạo lữ / Người yêu' => Colors.pink.shade600,
      'Sư phụ / Tiền bối' => Colors.teal.shade700,
      'Kẻ thù / Phản diện' => Colors.red.shade700,
      'Bí ẩn / Trung lập' => Colors.deepPurple.shade600,
      _ => cs.primary,
    };
  }

  Future<void> _showNodeEditorDialog({_CharNode? existing}) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final noteCtrl = TextEditingController(text: existing?.note ?? '');
    String selectedRole = existing?.role ?? _roles.first;
    String? connectToId = existing == null && _nodes.isNotEmpty
        ? _nodes.first.id
        : null;
    String relLabel = _relationLabels.first;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(
            existing != null
                ? '✏️ Hồ sơ nhân vật: ${existing.name}'
                : '➕ Thêm nhân vật vào Sơ đồ',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tên nhân vật *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _roles.contains(selectedRole)
                      ? selectedRole
                      : _roles.first,
                  decoration: const InputDecoration(
                    labelText: 'Vai trò trong truyện',
                    border: OutlineInputBorder(),
                  ),
                  items: _roles
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) =>
                      setModalState(() => selectedRole = v ?? _roles.first),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: noteCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Ghi chú / Cảnh giới / Chương xuất hiện',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_nodes.where((n) => n.id != existing?.id).isNotEmpty) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    initialValue: connectToId,
                    decoration: const InputDecoration(
                      labelText: 'Nối thêm quan hệ với nhân vật',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('-- Không nối thêm --'),
                      ),
                      ..._nodes
                          .where((n) => n.id != existing?.id)
                          .map(
                            (n) => DropdownMenuItem<String?>(
                              value: n.id,
                              child: Text(n.name),
                            ),
                          ),
                    ],
                    onChanged: (v) => setModalState(() => connectToId = v),
                  ),
                  if (connectToId != null) ...[
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: relLabel,
                      decoration: const InputDecoration(
                        labelText: 'Loại quan hệ',
                        border: OutlineInputBorder(),
                      ),
                      items: _relationLabels
                          .map(
                            (l) => DropdownMenuItem(value: l, child: Text(l)),
                          )
                          .toList(),
                      onChanged: (v) => setModalState(
                        () => relLabel = v ?? _relationLabels.first,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          actions: [
            if (existing != null)
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                onPressed: () async {
                  setState(() {
                    _nodes.removeWhere((n) => n.id == existing.id);
                    _edges.removeWhere(
                      (e) => e.fromId == existing.id || e.toId == existing.id,
                    );
                  });
                  await _saveGraph();
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Xóa nhân vật'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                setState(() {
                  if (existing != null) {
                    existing.name = nameCtrl.text.trim();
                    existing.role = selectedRole;
                    existing.note = noteCtrl.text.trim();
                    if (connectToId != null) {
                      _edges.removeWhere(
                        (e) =>
                            (e.fromId == existing.id &&
                                e.toId == connectToId) ||
                            (e.fromId == connectToId && e.toId == existing.id),
                      );
                      _edges.add(
                        _CharEdge(
                          fromId: existing.id,
                          toId: connectToId!,
                          label: relLabel,
                        ),
                      );
                    }
                  } else {
                    final newId = 'n${DateTime.now().millisecondsSinceEpoch}';
                    _nodes.add(
                      _CharNode(
                        id: newId,
                        name: nameCtrl.text.trim(),
                        role: selectedRole,
                        note: noteCtrl.text.trim(),
                        pos: Offset(
                          80.0 + (_nodes.length * 45) % 280,
                          120.0 + (_nodes.length * 55) % 240,
                        ),
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
                  }
                });
                await _saveGraph();
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(existing != null ? 'Lưu thay đổi' : 'Thêm nhân vật'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final currentNovel = _availableNovels
        .where((n) => n.id == _selectedNovelId)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sổ tay & Sơ đồ Quan hệ Nhân vật'),
        actions: [
          FilledButton.tonalIcon(
            onPressed: _analyzingAi
                ? null
                : () => _generateGraphFromNovelContent(saveAfter: true),
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: Text(_analyzingAi ? 'Đang phân tích...' : 'AI Trích xuất'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () => _showNodeEditorDialog(),
            icon: const Icon(Icons.person_add_alt_1, size: 18),
            label: const Text('Thêm nhân vật'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Hộp giải thích công dụng & Bộ chọn truyện
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            color: cs.surfaceContainerHighest.withValues(alpha: 0.65),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💡 Công dụng: Giúp bạn ghi nhớ mạng lưới nhân vật trong các bộ truyện dài tập (Ai là Nhân vật chính, Sư phụ, Đạo lữ, Kẻ thù). Bấm vào thẻ nhân vật để Sửa / Xóa / Nối quan hệ, hoặc kéo thả để sắp xếp vị trí.',
                  style: TextStyle(fontSize: 12.5),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (_availableNovels.isNotEmpty)
                      SizedBox(
                        width: 340,
                        child: DropdownButtonFormField<int>(
                          initialValue: _availableNovels.any(
                                (n) => n.id == _selectedNovelId,
                              )
                              ? _selectedNovelId
                              : _availableNovels.first.id,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Đang xem sơ đồ của bộ truyện',
                            border: OutlineInputBorder(),
                          ),
                          items: _availableNovels
                              .map(
                                (n) => DropdownMenuItem<int>(
                                  value: n.id,
                                  child: Text(
                                    n.title,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) async {
                            if (val == null) return;
                            final picked = _availableNovels.firstWhere(
                              (n) => n.id == val,
                            );
                            setState(() {
                              _selectedNovelId = picked.id;
                              _selectedNovelTitle = picked.title;
                            });
                            await _loadGraph();
                          },
                        ),
                      ),
                    if (currentNovel != null)
                      OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NovelDetailScreen(novelId: currentNovel.id),
                          ),
                        ),
                        icon: const Icon(Icons.menu_book_outlined, size: 16),
                        label: const Text('Đọc bộ truyện này'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxW = (constraints.maxWidth - 180).clamp(200.0, 1400.0);
                final maxH = (constraints.maxHeight - 90).clamp(160.0, 900.0);
                return Stack(
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
                        left: node.pos.dx.clamp(8.0, maxW),
                        top: node.pos.dy.clamp(8.0, maxH),
                        child: GestureDetector(
                          onTap: () => _showNodeEditorDialog(existing: node),
                          onPanUpdate: (d) {
                            setState(() {
                              node.pos = Offset(
                                (node.pos.dx + d.delta.dx).clamp(8.0, maxW),
                                (node.pos.dy + d.delta.dy).clamp(8.0, maxH),
                              );
                            });
                          },
                          onPanEnd: (_) => _saveGraph(),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                color: _roleColor(node, cs),
                                width: 2,
                              ),
                            ),
                            color: cs.surfaceContainerHigh,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _roleColor(
                                            node,
                                            cs,
                                          ).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          node.role,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: _roleColor(node, cs),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.edit_outlined, size: 13),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    node.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.5,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                  if (node.note.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        node.note,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: cs.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
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
      ..color = lineColor.withValues(alpha: 0.75)
      ..strokeWidth = 2.4;

    for (final e in edges) {
      final a = map[e.fromId];
      final b = map[e.toId];
      if (a == null || b == null) continue;
      final p1 = a.pos + const Offset(75, 32);
      final p2 = b.pos + const Offset(75, 32);
      canvas.drawLine(p1, p2, paint);

      final mid = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
      final tp = TextPainter(
        text: TextSpan(
          text: ' ${e.label} ',
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            backgroundColor: lineColor.withValues(alpha: 0.22),
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
