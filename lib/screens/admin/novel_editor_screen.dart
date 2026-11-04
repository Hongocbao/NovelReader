import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/supabase_database.dart';
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
  bool _saving = false;
  String? _saveError;
  String? _submissionPayload;
  String? _requestId;
  late final String _generatedCoverUrl =
      'https://picsum.photos/seed/novelreader-${DateTime.now().microsecondsSinceEpoch}/300/450';

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
      r'^[ \t]*((?:Chương|Chuong|Hồi|Hoi|Phần|Phan|Quyển|Quyen|Chapter|Chap)\s+\d+[^\n]*)',
      multiLine: true,
      caseSensitive: false,
    );
    final matches = regex.allMatches(raw).toList();
    if (matches.isEmpty) {
      chapters.add((title: 'Chương 1: Mở đầu', content: raw.trim()));
    } else {
      final preface = raw.substring(0, matches.first.start).trim();
      if (preface.isNotEmpty) {
        chapters.add((title: 'Mở đầu', content: preface));
      }
      final seenTitles = <String>{};
      for (var i = 0; i < matches.length; i++) {
        final title = matches[i].group(1)!.trim();
        final start = matches[i].end;
        final end = (i + 1 < matches.length)
            ? matches[i + 1].start
            : raw.length;
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
    if (_saving || !_formKey.currentState!.validate()) return;
    if (_bulkErrors.isNotEmpty) {
      setState(() => _saveError = 'Vui lòng sửa lỗi: ${_bulkErrors.first}');
      return;
    }
    final actor = context.read<AuthProvider>().currentUser;
    final adminNovels = context.read<AdminNovelProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final genres = _selectedGenres.toList()..sort();
    final chapters = List<({String title, String content})>.unmodifiable(
      _previewBulkChapters,
    );
    final base =
        widget.novel ??
        Novel(
          id: 0,
          title: '',
          author: '',
          coverUrl: _generatedCoverUrl,
          description: '',
          status: _status,
          type: _type,
          genres: genres,
          totalChapters: 0,
          rating: 0,
          views: 0,
          updatedAt: DateTime.now(),
        );
    final novel = base.copyWith(
      title: _titleCtrl.text.trim(),
      author: _authorCtrl.text.trim(),
      coverUrl: _coverCtrl.text.trim().isEmpty
          ? base.coverUrl
          : _coverCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      status: _status,
      type: _type,
      genres: genres,
    );
    final payload = jsonEncode({
      'actor': actor.id,
      'novel': novel.toMap()..remove('updated_at'),
      'chapters': [
        for (final chapter in chapters)
          {'title': chapter.title, 'content': chapter.content},
      ],
    });
    if (_submissionPayload != payload) {
      _submissionPayload = payload;
      _requestId = SupabaseDatabase.newImportRequestId();
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _saving = true;
      _saveError = null;
    });
    try {
      await adminNovels.saveNovel(
        actor: actor,
        novel: novel,
        chapters: chapters,
        requestId: _requestId,
      );
      if (!mounted) return;
      final warning = adminNovels.saveWarning;
      Navigator.pop(context, true);
      if (warning != null) {
        messenger.showSnackBar(SnackBar(content: Text(warning)));
      }
    } catch (error) {
      if (mounted) {
        setState(() => _saveError = 'Không lưu được tác phẩm: $error');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.novel == null
                ? 'Thêm / Nhập Truyện mới'
                : 'Chỉnh sửa Truyện',
          ),
          actions: [
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.save),
              label: Text(_saving ? 'Đang lưu…' : 'Lưu tác phẩm'),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Column(
          children: [
            if (_saveError != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    _saveError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    TextFormField(
                      key: const ValueKey('novel-editor-title'),
                      controller: _titleCtrl,
                      enabled: !_saving,
                      decoration: const InputDecoration(
                        labelText: 'Tên truyện *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Nhập tên truyện'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const ValueKey('novel-editor-author'),
                      controller: _authorCtrl,
                      enabled: !_saving,
                      decoration: const InputDecoration(
                        labelText: 'Tác giả *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Nhập tên tác giả'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _coverCtrl,
                      enabled: !_saving,
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
                            isExpanded: true,
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
                            onChanged: _saving
                                ? null
                                : (v) => setState(
                                    () => _type = v ?? NovelType.novel,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
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
                            onChanged: _saving
                                ? null
                                : (v) => setState(
                                    () => _status = v ?? NovelStatus.ongoing,
                                  ),
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
                          onSelected: _saving
                              ? null
                              : (v) => setState(() {
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
                      enabled: !_saving,
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
                        key: const ValueKey('novel-editor-bulk'),
                        controller: _bulkCtrl,
                        enabled: !_saving,
                        maxLines: 7,
                        onChanged: _parseBulkPreview,
                        decoration: const InputDecoration(
                          hintText: 'Chương 1: Khởi đầu\nNội dung chương 1...\n\nChương 2: Biến cố\nNội dung chương 2...',
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
            ),
          ],
        ),
      ),
    );
  }
}
