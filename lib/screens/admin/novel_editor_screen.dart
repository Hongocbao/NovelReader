import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/app_database.dart';
import '../../models/novel.dart';
import '../../providers/admin_novel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';

/// Màn hình tạo mới / chỉnh sửa thông tin Truyện & Nhập hàng loạt nhiều chương (Mục 6.2).
class NovelEditorScreen extends StatefulWidget {
  final Novel? novel;

  const NovelEditorScreen({super.key, this.novel});

  @override
  State<NovelEditorScreen> createState() => _NovelEditorScreenState();
}

class _NovelEditorScreenState extends State<NovelEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _authorCtrl;
  late final TextEditingController _coverCtrl;
  late final TextEditingController _descCtrl;
  final _bulkCtrl = TextEditingController();

  late String _status;
  late String _type;
  late Set<String> _selectedGenres;
  List<({String title, String content})> _previewBulkChapters = [];
  List<String> _bulkErrors = [];

  @override
  void initState() {
    super.initState();
    final n = widget.novel;
    _titleCtrl = TextEditingController(text: n?.title ?? '');
    _authorCtrl = TextEditingController(text: n?.author ?? '');
    _coverCtrl = TextEditingController(text: n?.coverUrl ?? '');
    _descCtrl = TextEditingController(text: n?.description ?? '');
    _status = n?.status ?? NovelStatus.ongoing;
    _type = n?.type ?? NovelType.novel;
    _selectedGenres = Set<String>.from(n?.genres ?? [Genres.all.first]);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _coverCtrl.dispose();
    _descCtrl.dispose();
    _bulkCtrl.dispose();
    super.dispose();
  }

  void _parseBulkPreview(String raw) {
    final errors = <String>[];
    final chapters = <({String title, String content})>[];
    if (raw.trim().isEmpty) {
      setState(() {
        _previewBulkChapters = [];
        _bulkErrors = [];
      });
      return;
    }

    final regex = RegExp(
      r'^(Chương\s+\d+[^\n]*)',
      multiLine: true,
      caseSensitive: false,
    );
    final matches = regex.allMatches(raw).toList();
    if (matches.isEmpty) {
      chapters.add((title: 'Chương 1: Mở đầu', content: raw.trim()));
    } else {
      final seenTitles = <String>{};
      for (var i = 0; i < matches.length; i++) {
        final title = matches[i].group(1)!.trim();
        final start = matches[i].end;
        final end =
            (i + 1 < matches.length) ? matches[i + 1].start : raw.length;
        final body = raw.substring(start, end).trim();
        if (!seenTitles.add(title.toLowerCase())) {
          errors.add('Trùng tiêu đề: "$title"');
        }
        if (body.isEmpty) {
          errors.add('Chương trống nội dung: "$title"');
        }
        chapters.add((title: title, content: body));
      }
    }

    setState(() {
      _previewBulkChapters = chapters;
      _bulkErrors = errors;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_bulkErrors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng sửa lỗi: ${_bulkErrors.first}')),
      );
      return;
    }
    final actor = context.read<AuthProvider>().currentUser;
    final adminNovels = context.read<AdminNovelProvider>();

    if (widget.novel == null && _previewBulkChapters.isNotEmpty) {
      await AppDatabase.instance.insertCustomNovel(
        title: _titleCtrl.text.trim(),
        author: _authorCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        status: _status,
        type: _type,
        genres: _selectedGenres.toList(),
        chapters: _previewBulkChapters,
        coverUrl: _coverCtrl.text.trim(),
        moderationStatus: actor.isAdmin
            ? ModerationStatus.approved
            : ModerationStatus.pending,
        ownerId: actor.id,
      );
      await adminNovels.loadNovels(includeDeleted: true);
    } else {
      final base = widget.novel ??
          Novel(
            id: 0,
            title: _titleCtrl.text.trim(),
            author: _authorCtrl.text.trim(),
            coverUrl: _coverCtrl.text.trim().isEmpty
                ? 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/300/450'
                : _coverCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            status: _status,
            type: _type,
            genres: _selectedGenres.toList(),
            totalChapters: 0,
            rating: 0.0,
            views: 0,
            updatedAt: DateTime.now(),
          );
      await adminNovels.saveNovel(
        actor: actor,
        novel: base.copyWith(
          title: _titleCtrl.text.trim(),
          author: _authorCtrl.text.trim(),
          coverUrl: _coverCtrl.text.trim().isEmpty
              ? base.coverUrl
              : _coverCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          status: _status,
          type: _type,
          genres: _selectedGenres.toList(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.novel == null ? 'Thêm / Nhập Truyện mới' : 'Chỉnh sửa Truyện',
        ),
        actions: [
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Lưu tác phẩm'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Tên truyện *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nhập tên truyện' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _authorCtrl,
              decoration: const InputDecoration(
                labelText: 'Tác giả *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nhập tên tác giả' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _coverCtrl,
              decoration: const InputDecoration(
                labelText: 'URL ảnh bìa (để trống sẽ tự động sinh)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _type,
                    decoration: const InputDecoration(
                      labelText: 'Loại hình',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: NovelType.novel,
                        child: Text('Truyện chữ'),
                      ),
                      DropdownMenuItem(
                        value: NovelType.lightNovel,
                        child: Text('Light Novel'),
                      ),
                      DropdownMenuItem(
                        value: NovelType.comic,
                        child: Text('Truyện tranh / Manga'),
                      ),
                    ],
                    onChanged: (v) =>
                        setState(() => _type = v ?? NovelType.novel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: const InputDecoration(
                      labelText: 'Trạng thái',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: NovelStatus.ongoing,
                        child: Text('Đang ra'),
                      ),
                      DropdownMenuItem(
                        value: NovelStatus.completed,
                        child: Text('Hoàn thành'),
                      ),
                    ],
                    onChanged: (v) =>
                        setState(() => _status = v ?? NovelStatus.ongoing),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text('Thể loại (chọn ít nhất 1):'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Genres.all.map((g) {
                final sel = _selectedGenres.contains(g);
                return FilterChip(
                  label: Text(g),
                  selected: sel,
                  onSelected: (v) => setState(() {
                    if (v) {
                      _selectedGenres.add(g);
                    } else if (_selectedGenres.length > 1) {
                      _selectedGenres.remove(g);
                    }
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Mô tả / Giới thiệu cốt truyện',
                border: OutlineInputBorder(),
              ),
            ),
            if (widget.novel == null) ...[
              const SizedBox(height: 20),
              Text(
                'Nhập hàng loạt nhiều chương (tự động tách theo dòng "Chương 1: ...", "Chương 2: ..."):',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bulkCtrl,
                maxLines: 7,
                onChanged: _parseBulkPreview,
                decoration: const InputDecoration(
                  hintText:
                      'Chương 1: Khởi đầu\nNội dung chương 1...\n\nChương 2: Biến cố\nNội dung chương 2...',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_bulkErrors.isNotEmpty) ...[
                const SizedBox(height: 8),
                for (final err in _bulkErrors)
                  Text(
                    '⚠️ $err',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
              if (_previewBulkChapters.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Xem trước: Đã nhận diện ${_previewBulkChapters.length} chương',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
