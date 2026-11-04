import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/app_database.dart';
import '../../models/chapter.dart';
import '../../models/glossary_term.dart';
import '../../models/novel.dart';
import '../../providers/admin_novel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/add_chapter_dialog.dart';

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
  bool _reordering = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final provider = context.read<AdminNovelProvider>();
      final (chs, terms) = await (
        provider.getChaptersForNovel(widget.novel.id),
        provider.getGlossaryForNovel(widget.novel.id),
      ).wait;
      if (mounted) {
        setState(() {
          _chapters = chs;
          _glossary = terms;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không tải được danh sách chương: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _reorderChapters(int oldIndex, int newIndex) async {
    if (_loading || _reordering || oldIndex == newIndex) return;
    final provider = context.read<AdminNovelProvider>();
    final actor = context.read<AuthProvider>().currentUser;
    final previous = List<Chapter>.of(_chapters);
    final ordered = List<Chapter>.of(previous);
    ordered.insert(newIndex, ordered.removeAt(oldIndex));
    setState(() {
      _reordering = true;
      _chapters = ordered;
    });
    try {
      await provider.reorderChapters(actor, widget.novel.id, ordered);
      if (mounted) {
        setState(
          () => _chapters = [
            for (var i = 0; i < ordered.length; i++)
              ordered[i].copyWith(chapterIndex: i + 1),
          ],
        );
        await _loadData();
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _chapters = previous);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chưa xác nhận được thứ tự mới: $error')),
      );
      // The request may have committed before its response was lost.
      await _loadData();
    } finally {
      if (mounted) setState(() => _reordering = false);
    }
  }

  Future<void> _openChapterDialog({Chapter? existing}) async {
    final auth = context.read<AuthProvider>();
    final actor = auth.currentUser;
    final provider = context.read<AdminNovelProvider>();
    String initialContent = existing?.content ?? '';
    if (existing != null && initialContent.isEmpty) {
      try {
        final full = await AppDatabase.instance.getChapter(existing.id);
        if (full?.content == null) {
          throw StateError('Chưa tải được nội dung chương. Hãy thử lại.');
        }
        initialContent = full!.content!;
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Không mở được chương: $error')),
          );
        }
        return;
      }
    }
    if (!mounted) return;
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddChapterDialog(
        initialTitle: existing?.title ?? '',
        initialContent: initialContent,
        editing: existing != null,
        onSaveWithSummary: (title, content, summary, requestId) async {
          if (auth.currentUser.id != actor.id) {
            throw StateError(
              'Tài khoản đã thay đổi. Hãy mở lại cửa sổ biên tập.',
            );
          }
          final chapter =
              (existing ??
                      Chapter(
                        id: 0,
                        novelId: widget.novel.id,
                        chapterIndex: 0,
                        title: title,
                      ))
                  .copyWith(title: title, content: content);
          await provider.saveChapterWithSummary(
            actor: auth.currentUser,
            chapter: chapter,
            summary: summary,
            requestId: requestId,
          );
        },
      ),
    );
    if (saved == true && mounted) await _loadData();
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
                  firstChapterIndex: int.tryParse(chapIdxCtrl.text.trim()) ?? 1,
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

    return PopScope(
      canPop: !_reordering,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Chương & Thuật ngữ: ${widget.novel.title}'),
            actions: [
              IconButton(
                tooltip: 'Tải lại danh sách',
                onPressed: _loading || _reordering ? null : _loadData,
                icon: const Icon(Icons.refresh),
              ),
            ],
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
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Tổng cộng: ${_chapters.length} chương (nhấn giữ để kéo thả đổi thứ tự)',
                              ),
                              FilledButton.icon(
                                onPressed: _reordering
                                    ? null
                                    : () => _openChapterDialog(),
                                icon: const Icon(Icons.add),
                                label: const Text('Thêm chương mới'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ReorderableListView.builder(
                            itemCount: _chapters.length,
                            onReorderItem: _reorderChapters,
                            buildDefaultDragHandles: !_reordering,
                            itemBuilder: (context, index) {
                              final c = _chapters[index];
                              return ListTile(
                                key: ValueKey(c.id),
                                leading: CircleAvatar(
                                  child: Text(
                                    '${_reordering ? index + 1 : c.chapterIndex}',
                                  ),
                                ),
                                title: Text(c.title),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: _reordering
                                      ? null
                                      : () => _openChapterDialog(existing: c),
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
      ),
    );
  }
}
