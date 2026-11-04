import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../database/app_database.dart';
import '../../models/chapter.dart';
import '../../models/glossary_term.dart';
import '../../models/novel.dart';
import '../../providers/admin_novel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/add_chapter_dialog.dart';
import '../novel_detail_screen.dart';
import '../reader_screen.dart';

/// Màn hình Quản lý & Soạn thảo Chương, Tóm tắt chương (Recap) và Từ điển thuật ngữ (Mục 6.2).
/// Hỗ trợ Xem/Đọc thử, Thêm mới, Sửa nội dung, Xóa chương, Kéo thả đổi thứ tự chương và Quản lý thuật ngữ.
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

  Future<String> _resolveChapterContent(Chapter chapter) async {
    if (chapter.content != null && chapter.content!.trim().isNotEmpty) {
      return chapter.content!;
    }
    try {
      final content = await AppDatabase.instance.fetchChapterContent(
        widget.novel.id,
        chapter.chapterIndex,
      );
      if (content.trim().isNotEmpty) return content;
    } catch (_) {}
    try {
      final row = await Supabase.instance.client
          .from('chuong')
          .select('content')
          .eq('id', chapter.id)
          .maybeSingle();
      final text = row?['content'] as String?;
      if (text != null && text.trim().isNotEmpty) return text;
    } catch (_) {}
    try {
      final local = await AppDatabase.instance.getChapter(
        chapter.id,
        novelId: widget.novel.id,
      );
      if (local?.content != null) return local!.content!;
    } catch (_) {}
    return '';
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
      await _loadData();
    } finally {
      if (mounted) setState(() => _reordering = false);
    }
  }

  Future<void> _previewChapterDialog(Chapter chapter) async {
    final content = await _resolveChapterContent(chapter);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.menu_book_rounded, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                chapter.title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: SelectableText(
              content.trim().isEmpty
                  ? '(Chương này chưa có nội dung — hãy bấm "Sửa chương" để biên tập.)'
                  : content,
              style: const TextStyle(fontSize: 14.5, height: 1.6),
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReaderScreen(
                    novel: widget.novel,
                    initialChapterId: chapter.id,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.chrome_reader_mode_outlined, size: 18),
            label: const Text('Mở trong Trình đọc'),
          ),
          FilledButton.tonalIcon(
            onPressed: () {
              Navigator.pop(ctx);
              _openChapterDialog(existing: chapter);
            },
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Sửa chương này'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Future<void> _openChapterDialog({Chapter? existing}) async {
    final auth = context.read<AuthProvider>();
    final actor = auth.currentUser;
    final provider = context.read<AdminNovelProvider>();
    String initialContent = existing?.content ?? '';
    if (existing != null && initialContent.isEmpty) {
      initialContent = await _resolveChapterContent(existing);
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
                        chapterIndex: _chapters.length + 1,
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
    if (saved == true && mounted) {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            existing != null
                ? '✅ Đã cập nhật chương "${existing.title}"!'
                : '✅ Đã thêm chương mới thành công!',
          ),
        ),
      );
    }
  }

  Future<void> _confirmDeleteChapter(Chapter chapter) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🗑️ Xác nhận xóa chương'),
        content: Text(
          'Bạn có chắc chắn muốn xóa "${chapter.title}" (Chương ${chapter.chapterIndex}) khỏi tác phẩm "${widget.novel.title}" không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xóa chương'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final actor = context.read<AuthProvider>().currentUser;
    final provider = context.read<AdminNovelProvider>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      await provider.deleteChapter(actor, widget.novel.id, chapter.id);
      await _loadData();
      messenger.showSnackBar(
        SnackBar(content: Text('🗑️ Đã xóa chương "${chapter.title}".')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Không xóa được chương: $e')),
      );
    }
  }

  Future<void> _openGlossaryDialog({GlossaryTerm? existing}) async {
    final termCtrl = TextEditingController(text: existing?.term ?? '');
    final meaningCtrl = TextEditingController(text: existing?.meaning ?? '');
    final chapIdxCtrl = TextEditingController(
      text: '${existing?.firstChapterIndex ?? 1}',
    );

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          existing != null
              ? '✏️ Chỉnh sửa thuật ngữ (Glossary)'
              : '➕ Thêm thuật ngữ từ điển (Glossary)',
        ),
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
              final provider = context.read<AdminNovelProvider>();
              final item = GlossaryTerm(
                id: existing?.id,
                novelId: widget.novel.id,
                term: termCtrl.text.trim(),
                meaning: meaningCtrl.text.trim(),
                firstChapterIndex: int.tryParse(chapIdxCtrl.text.trim()) ?? 1,
              );
              if (existing != null) {
                await provider.updateGlossaryTerm(actor, item);
              } else {
                await provider.addGlossaryTerm(actor, item);
              }
              if (ctx.mounted) Navigator.pop(ctx);
              await _loadData();
            },
            child: Text(existing != null ? 'Lưu thay đổi' : 'Thêm thuật ngữ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actor = context.watch<AuthProvider>().currentUser;
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !_reordering,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Chương & Thuật ngữ: ${widget.novel.title}'),
            actions: [
              TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NovelDetailScreen(
                      novelId: widget.novel.id,
                    ),
                  ),
                ),
                icon: const Icon(Icons.menu_book_outlined, size: 18),
                label: const Text('Xem tác phẩm'),
              ),
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          color: cs.surfaceContainerHighest.withValues(
                            alpha: 0.6,
                          ),
                          child: const Text(
                            '💡 Trang này dùng để Quản lý toàn bộ Chương của tác phẩm: Xem trước/Đọc thử nội dung, Thêm chương mới, Sửa nội dung chương, Xóa chương hoặc Nhấn giữ kéo thả để đổi thứ tự chương.',
                            style: TextStyle(fontSize: 12.5),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Tổng cộng: ${_chapters.length} chương',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              FilledButton.icon(
                                onPressed: _reordering
                                    ? null
                                    : () => _openChapterDialog(),
                                icon: const Icon(Icons.add),
                                label: const Text('Thêm chương mới'),
                              ),
                              if (_chapters.isNotEmpty)
                                OutlinedButton.icon(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ReaderScreen(
                                        novel: widget.novel,
                                        initialChapterId: _chapters.first.id,
                                      ),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.play_lesson_outlined,
                                    size: 18,
                                  ),
                                  label: const Text('Đọc từ Chương 1'),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _chapters.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Chưa có chương nào. Hãy bấm "+ Thêm chương mới" để bắt đầu!',
                                  ),
                                )
                              : ReorderableListView.builder(
                                  itemCount: _chapters.length,
                                  onReorderItem: _reorderChapters,
                                  buildDefaultDragHandles: !_reordering,
                                  itemBuilder: (context, index) {
                                    final c = _chapters[index];
                                    return Card(
                                      key: ValueKey(c.id),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      child: ListTile(
                                        onTap: () => _previewChapterDialog(c),
                                        leading: CircleAvatar(
                                          child: Text(
                                            '${_reordering ? index + 1 : c.chapterIndex}',
                                          ),
                                        ),
                                        title: Text(
                                          c.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: const Text(
                                          'Bấm vào để Xem trước / Đọc thử • Nhấn giữ để kéo thả thứ tự',
                                          style: TextStyle(fontSize: 11.5),
                                        ),
                                        trailing: Wrap(
                                          spacing: 6,
                                          children: [
                                            OutlinedButton.icon(
                                              style: OutlinedButton.styleFrom(
                                                visualDensity:
                                                    VisualDensity.compact,
                                              ),
                                              onPressed: _reordering
                                                  ? null
                                                  : () =>
                                                        _previewChapterDialog(
                                                          c,
                                                        ),
                                              icon: const Icon(
                                                Icons.visibility_outlined,
                                                size: 16,
                                              ),
                                              label: const Text(
                                                'Xem',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                            FilledButton.tonalIcon(
                                              style: FilledButton.styleFrom(
                                                visualDensity:
                                                    VisualDensity.compact,
                                              ),
                                              onPressed: _reordering
                                                  ? null
                                                  : () => _openChapterDialog(
                                                        existing: c,
                                                      ),
                                              icon: const Icon(
                                                Icons.edit_outlined,
                                                size: 16,
                                              ),
                                              label: const Text(
                                                'Sửa',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                            IconButton(
                                              tooltip: 'Xóa chương này',
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.redAccent,
                                              ),
                                              onPressed: _reordering
                                                  ? null
                                                  : () => _confirmDeleteChapter(
                                                        c,
                                                      ),
                                            ),
                                          ],
                                        ),
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
                                  '💡 Từ điển Thuật ngữ giúp độc giả bấm vào các danh từ riêng/cảnh giới trong chương đọc để xem giải nghĩa ngay mà không sợ bị lộ cốt truyện (chống spoil).',
                                ),
                              ),
                              const SizedBox(width: 12),
                              FilledButton.icon(
                                onPressed: () => _openGlossaryDialog(),
                                icon: const Icon(Icons.add),
                                label: const Text('Thêm thuật ngữ'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _glossary.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Chưa có thuật ngữ nào cho tác phẩm này.',
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _glossary.length,
                                  itemBuilder: (context, index) {
                                    final g = _glossary[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          '${g.term} (Từ chương ${g.firstChapterIndex})',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(g.meaning),
                                        trailing: Wrap(
                                          spacing: 4,
                                          children: [
                                            IconButton(
                                              tooltip: 'Sửa thuật ngữ',
                                              icon: const Icon(
                                                Icons.edit_outlined,
                                              ),
                                              onPressed: () =>
                                                  _openGlossaryDialog(
                                                    existing: g,
                                                  ),
                                            ),
                                            IconButton(
                                              tooltip: 'Xóa thuật ngữ',
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.redAccent,
                                              ),
                                              onPressed: () async {
                                                if (g.id != null) {
                                                  await context
                                                      .read<
                                                        AdminNovelProvider
                                                      >()
                                                      .deleteGlossaryTerm(
                                                        actor,
                                                        g.id!,
                                                      );
                                                  await _loadData();
                                                }
                                              },
                                            ),
                                          ],
                                        ),
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
