import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/app_database.dart';
import '../../database/v2_database_store.dart';
import '../../models/chapter.dart';
import '../../models/glossary_term.dart';
import '../../models/novel.dart';
import '../../providers/admin_novel_provider.dart';
import '../../providers/auth_provider.dart';

/// Màn hình Quản lý & Soạn thảo Chương, Tóm tắt chương (Recap) và Từ điển thuật ngữ (Mục 6.2).
/// Hỗ trợ kéo thả đổi thứ tự chương (ReorderableListView) và kiểm tra lỗi chương.
class ChapterEditorScreen extends StatefulWidget {
  final Novel novel;

  const ChapterEditorScreen({super.key, required this.novel});

  @override
  State<ChapterEditorScreen> createState() => _ChapterEditorScreenState();
}

class _ChapterEditorScreenState extends State<ChapterEditorScreen> {
  List<Chapter> _chapters = [];
  List<GlossaryTerm> _glossary = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final db = await AppDatabase.instance.database;
    final chs = await AppDatabase.instance.getChapters(widget.novel.id);
    final terms = await V2DatabaseStore.getGlossaryForNovel(
      db,
      widget.novel.id,
    );
    if (mounted) {
      setState(() {
        _chapters = chs;
        _glossary = terms;
        _loading = false;
      });
    }
  }

  Future<void> _openChapterDialog({Chapter? existing}) async {
    String initialContent = existing?.content ?? '';
    if (existing != null && initialContent.isEmpty) {
      try {
        final full = await AppDatabase.instance.getChapter(existing.id);
        initialContent = full?.content ??
            await AppDatabase.instance.fetchChapterContent(
              widget.novel.id,
              existing.chapterIndex,
            );
      } catch (_) {}
    }
    if (!mounted) return;

    final titleCtrl = TextEditingController(
      text: existing?.title ?? 'Chương ${_chapters.length + 1}: ',
    );
    final contentCtrl = TextEditingController(text: initialContent);
    final summaryCtrl = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final words = contentCtrl.text.trim().isEmpty
              ? 0
              : contentCtrl.text.trim().split(RegExp(r'\s+')).length;
          final hasBrokenImg = RegExp(r'\[img\]\s*\[/img\]')
              .hasMatch(contentCtrl.text);

          return AlertDialog(
            title: Text(
              existing == null ? 'Soạn chương mới' : 'Biên tập chương',
            ),
            content: SizedBox(
              width: 560,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Tiêu đề chương',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentCtrl,
                      maxLines: 8,
                      onChanged: (_) => setModalState(() {}),
                      decoration: const InputDecoration(
                        labelText:
                            'Nội dung chương (hỗ trợ chèn ảnh [img]https://...[/img])',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Số từ: $words từ'),
                        if (hasBrokenImg)
                          const Text(
                            '⚠️ Phát hiện thẻ [img] rỗng!',
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: summaryCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText:
                            'Tóm tắt chương (Previously on... Recap cho độc giả)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Hủy'),
              ),
              FilledButton(
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty ||
                      contentCtrl.text.trim().isEmpty) {
                    return;
                  }
                  final actor = context.read<AuthProvider>().currentUser;
                  final chapter = (existing ??
                          Chapter(
                            id: 0,
                            novelId: widget.novel.id,
                            chapterIndex: _chapters.length + 1,
                            title: titleCtrl.text.trim(),
                          ))
                      .copyWith(
                    title: titleCtrl.text.trim(),
                    content: contentCtrl.text.trim(),
                    isDownloaded: true,
                  );
                  await context
                      .read<AdminNovelProvider>()
                      .saveChapterWithSummary(
                        actor: actor,
                        chapter: chapter,
                        summary: summaryCtrl.text,
                      );
                  if (ctx.mounted) Navigator.pop(ctx);
                  await _loadData();
                },
                child: const Text('Lưu chương'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openGlossaryDialog() async {
    final termCtrl = TextEditingController();
    final meaningCtrl = TextEditingController();
    final chapIdxCtrl = TextEditingController(text: '1');

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thêm thuật ngữ từ điển (Glossary)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: termCtrl,
              decoration: const InputDecoration(
                labelText: 'Thuật ngữ (ví dụ: Trúc Cơ, Linh căn)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: meaningCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Giải nghĩa'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: chapIdxCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Xuất hiện từ chương số (chống spoil)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () async {
              if (termCtrl.text.trim().isEmpty ||
                  meaningCtrl.text.trim().isEmpty) {
                return;
              }
              final actor = context.read<AuthProvider>().currentUser;
              await context.read<AdminNovelProvider>().addGlossaryTerm(
                    actor,
                    GlossaryTerm(
                      novelId: widget.novel.id,
                      term: termCtrl.text.trim(),
                      meaning: meaningCtrl.text.trim(),
                      firstChapterIndex:
                          int.tryParse(chapIdxCtrl.text.trim()) ?? 1,
                    ),
                  );
              if (ctx.mounted) Navigator.pop(ctx);
              await _loadData();
            },
            child: const Text('Thêm thuật ngữ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actor = context.watch<AuthProvider>().currentUser;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chương & Thuật ngữ: ${widget.novel.title}'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.reorder),
                text: 'Danh sách chương (Kéo thả)',
              ),
              Tab(
                icon: Icon(Icons.menu_book_outlined),
                text: 'Từ điển thuật ngữ',
              ),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tổng cộng: ${_chapters.length} chương (nhấn giữ để kéo thả đổi thứ tự)',
                            ),
                            FilledButton.icon(
                              onPressed: () => _openChapterDialog(),
                              icon: const Icon(Icons.add),
                              label: const Text('Thêm chương mới'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ReorderableListView.builder(
                          itemCount: _chapters.length,
                          onReorderItem: (oldIndex, newIndex) async {
                            final item = _chapters.removeAt(oldIndex);
                            _chapters.insert(newIndex, item);
                            setState(() {});
                            await context
                                .read<AdminNovelProvider>()
                                .reorderChapters(
                                  actor,
                                  widget.novel.id,
                                  _chapters,
                                );
                            await _loadData();
                          },
                          itemBuilder: (context, index) {
                            final c = _chapters[index];
                            return ListTile(
                              key: ValueKey(c.id),
                              leading: CircleAvatar(
                                child: Text('${c.chapterIndex}'),
                              ),
                              title: Text(c.title),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () =>
                                    _openChapterDialog(existing: c),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Thuật ngữ sẽ được gạch chân chấm trong chương đọc (chỉ hiện khi chương đọc ≥ first_chapter_index).',
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: _openGlossaryDialog,
                              icon: const Icon(Icons.add),
                              label: const Text('Thêm thuật ngữ'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _glossary.length,
                          itemBuilder: (context, index) {
                            final g = _glossary[index];
                            return ListTile(
                              title: Text(
                                '${g.term} (Từ chương ${g.firstChapterIndex})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(g.meaning),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () async {
                                  if (g.id != null) {
                                    await context
                                        .read<AdminNovelProvider>()
                                        .deleteGlossaryTerm(actor, g.id!);
                                    await _loadData();
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
