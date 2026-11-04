import 'dart:async';
import 'dart:convert';
import 'dart:typed_data' show BytesBuilder, Uint8List;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/supabase_database.dart';
import '../../models/chapter.dart';
import '../../models/novel.dart';
import '../../providers/admin_novel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/novel_provider.dart';
import '../../providers/quest_provider.dart';
import '../../services/ai_moderation_service.dart';
import '../../services/author_draft_store.dart';
import '../../utils/constants.dart';
import '../../utils/role_guard.dart';
import '../../widgets/add_chapter_dialog.dart';
import '../../widgets/reader/paragraph_view.dart';
import '../../widgets/smart_novel_importer_sheet.dart';
import '../admin/chapter_editor_screen.dart';
import '../auth/login_screen.dart';
import '../reader_screen.dart';

/// Màn hình Dành cho Tác giả («Truyện của tôi» - Mục 5.7).
/// Hỗ trợ tạo truyện, thiết kế trang bìa, chọn thể loại, công cụ AI hỗ trợ viết,
/// tự lưu nháp mỗi 5 giây, chèn ảnh vừa khung, AI Kiểm duyệt đăng công khai
/// và quản lý Thêm / Sửa / Xóa tác phẩm đầy đủ.
class AuthorStudioScreen extends StatefulWidget {
  const AuthorStudioScreen({super.key});

  @override
  State<AuthorStudioScreen> createState() => _AuthorStudioScreenState();
}

class _AuthorStudioScreenState extends State<AuthorStudioScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _draftChapterTitleCtrl = TextEditingController(
    text: 'Chương 1: Khởi đầu mới',
  );
  final _draftContentCtrl = TextEditingController();

  String _coverUrl = '';
  String _selectedType = NovelType.novel;
  String _selectedStatus = NovelStatus.ongoing;
  List<String> _selectedGenres = ['Tiên hiệp', 'Fantasy'];

  static const List<({String label, String url})> _presetCovers = [
    (
      label: 'Tiên hiệp Kiếm đạo',
      url: 'https://picsum.photos/seed/cover-tien-hiep-kiem/300/450',
    ),
    (
      label: 'Ngôn tình Thanh xuân',
      url: 'https://picsum.photos/seed/cover-ngon-tinh-mua-ha/300/450',
    ),
    (
      label: 'Huyền huyễn Long tộc',
      url: 'https://picsum.photos/seed/cover-huyen-huyen-long/300/450',
    ),
    (
      label: 'Trinh thám Phố cổ',
      url: 'https://picsum.photos/seed/cover-trinh-tham-pho/300/450',
    ),
    (
      label: 'Khoa huyễn Ngân hà',
      url: 'https://picsum.photos/seed/cover-khoa-huyen-sao/300/450',
    ),
    (
      label: 'Cổ đại Cung đấu',
      url: 'https://picsum.photos/seed/cover-co-dai-hoang-cung/300/450',
    ),
    (
      label: 'Linh dị Đêm sương',
      url: 'https://picsum.photos/seed/cover-linh-di-suong-mu/300/450',
    ),
    (
      label: 'Chữa lành Tiệm trà',
      url: 'https://picsum.photos/seed/cover-chua-lanh-tiem-tra/300/450',
    ),
  ];

  static const List<String> _quickGenres = [
    'Tiên hiệp',
    'Kiếm hiệp',
    'Huyền huyễn',
    'Ngôn tình',
    'Đô thị',
    'Hệ thống',
    'Trọng sinh',
    'Xuyên không',
    'Fantasy',
    'Isekai',
    'Trinh thám',
    'Kinh dị',
    'Học đường',
    'Cổ đại',
    'Điền văn',
    'Chữa lành',
  ];

  List<Novel> _myNovels = [];
  Timer? _autoSaveTimer;
  Timer? _draftDebounce;
  String _lastSavedLabel = 'Đang tải bản nháp';
  bool _previewMode = false;
  String? _submissionRequestId;
  String _draftOwner = '';
  int _ownerGeneration = 0;
  int _editRevision = 0;
  int _booksRequest = 0;
  bool _draftReady = false;
  bool _draftDirty = false;
  bool _changingDraft = false;
  bool _submitting = false;
  bool _booksLoading = false;
  String? _booksError;
  AuthProvider? _auth;
  late final Future<AuthorDraftStore> _store = SharedPreferences.getInstance()
      .then(AuthorDraftStore.new);
  ({String title, String description, String chapterTitle, String content})?
  _lastFields;

  bool get _editorBusy => !_draftReady || _submitting;
  ({String title, String description, String chapterTitle, String content})
  get _fields => (
    title: _titleCtrl.text,
    description: _descCtrl.text,
    chapterTitle: _draftChapterTitleCtrl.text,
    content: _draftContentCtrl.text,
  );
  bool _stillOwner(String owner, int generation) =>
      mounted &&
      _draftOwner == owner &&
      _ownerGeneration == generation &&
      _auth?.currentUser.id == owner &&
      _auth?.isGuest == false;

  AuthorDraft _snapshot() {
    _submissionRequestId ??= SupabaseDatabase.newImportRequestId();
    return AuthorDraft(
      title: _titleCtrl.text,
      description: _descCtrl.text,
      chapterTitle: _draftChapterTitleCtrl.text,
      content: _draftContentCtrl.text,
      requestId: _submissionRequestId!,
    );
  }

  void _applyDraft(AuthorDraft draft) {
    _changingDraft = true;
    _titleCtrl.text = draft.title;
    _descCtrl.text = draft.description;
    _draftChapterTitleCtrl.text = draft.chapterTitle.isEmpty
        ? AuthorDraft.defaultChapterTitle
        : draft.chapterTitle;
    _draftContentCtrl.text = draft.content;
    _submissionRequestId = draft.requestId.isEmpty ? null : draft.requestId;
    _lastFields = _fields;
    _changingDraft = false;
  }

  void _onDraftChanged() {
    if (_changingDraft ||
        !_draftReady ||
        _draftOwner.isEmpty ||
        _lastFields == _fields) {
      return;
    }
    _lastFields = _fields;
    _editRevision++;
    _draftDirty = true;
    _submissionRequestId = SupabaseDatabase.newImportRequestId();
    _draftDebounce?.cancel();
    if (mounted) setState(() => _lastSavedLabel = 'Chưa lưu thay đổi');
    _draftDebounce = Timer(
      const Duration(milliseconds: 400),
      _saveDraftSilently,
    );
  }

  void _invalidateSubmissionRequest() => _onDraftChanged();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    for (final controller in [
      _titleCtrl,
      _descCtrl,
      _draftChapterTitleCtrl,
      _draftContentCtrl,
    ]) {
      controller.addListener(_onDraftChanged);
    }
    _autoSaveTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _saveDraftSilently(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.watch<AuthProvider>();
    _auth = auth;
    final owner = auth.isGuest ? '' : auth.currentUser.id;
    if (_draftOwner == owner && _ownerGeneration != 0) return;
    unawaited(_saveDraftSilently());
    _draftDebounce?.cancel();
    _draftOwner = owner;
    final generation = ++_ownerGeneration;
    _editRevision = 0;
    _draftReady = false;
    _draftDirty = false;
    _submitting = false;
    _previewMode = false;
    _myNovels = [];
    _booksError = null;
    _lastSavedLabel = 'Đang tải bản nháp';
    _applyDraft(const AuthorDraft());
    if (owner.isEmpty) return;
    unawaited(_restoreDraft(owner, generation));
    unawaited(_refreshMyNovels());
  }

  Future<void> _restoreDraft(String owner, int generation) async {
    try {
      final store = await _store;
      final draft = store.load(owner);
      if (!_stillOwner(owner, generation)) return;
      setState(() {
        _applyDraft(draft);
        _lastSavedLabel = draft.isEmpty
            ? 'Chưa có bản nháp'
            : 'Đã khôi phục bản nháp';
      });
    } catch (_) {
      if (_stillOwner(owner, generation)) {
        setState(() => _lastSavedLabel = 'Chưa đọc được bản nháp cũ');
      }
    } finally {
      if (_stillOwner(owner, generation)) setState(() => _draftReady = true);
    }
  }

  Future<void> _refreshMyNovels() async {
    final owner = _draftOwner;
    final generation = _ownerGeneration;
    if (owner.isEmpty || !mounted) return;
    final provider = context.read<AdminNovelProvider>();
    final request = ++_booksRequest;
    setState(() {
      _booksLoading = true;
      _booksError = null;
    });
    try {
      final list = await provider.getAuthorNovels(owner);
      if (_stillOwner(owner, generation) && request == _booksRequest) {
        setState(() => _myNovels = list);
      }
    } catch (_) {
      if (_stillOwner(owner, generation) && request == _booksRequest) {
        setState(
          () => _booksError =
              'Chưa tải được tác phẩm. Bản nháp trên thiết bị vẫn sử dụng được.',
        );
      }
    } finally {
      if (_stillOwner(owner, generation) && request == _booksRequest) {
        setState(() => _booksLoading = false);
      }
    }
  }

  Future<void> _saveDraftSilently() async {
    if (!_draftReady || !_draftDirty || _draftOwner.isEmpty || _submitting) {
      return;
    }
    final owner = _draftOwner;
    final generation = _ownerGeneration;
    final revision = _editRevision;
    final snapshot = _snapshot();
    try {
      await (await _store).save(owner, snapshot);
      if (_stillOwner(owner, generation) && _editRevision == revision) {
        final now = TimeOfDay.now();
        setState(() {
          _draftDirty = false;
          _lastSavedLabel =
              'Đã lưu nháp lúc ${now.hour}:${now.minute.toString().padLeft(2, "0")}';
        });
      }
    } catch (_) {
      if (_stillOwner(owner, generation)) {
        setState(() => _lastSavedLabel = 'Chưa lưu được bản nháp');
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      unawaited(_saveDraftSilently());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoSaveTimer?.cancel();
    _draftDebounce?.cancel();
    unawaited(_saveDraftSilently());
    _tabController.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _draftChapterTitleCtrl.dispose();
    _draftContentCtrl.dispose();
    super.dispose();
  }

  Future<String?> _readPickedImageAsDataUri(String dialogTitle) async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'],
      dialogTitle: dialogTitle,
    );
    if (!mounted || files.isEmpty) return null;
    final file = files.first;
    final builder = BytesBuilder(copy: false);
    await for (final chunk in file.readAsByteStream()) {
      if (builder.length + chunk.length > 10 * 1024 * 1024) {
        throw StateError('Ảnh ${file.name} vượt giới hạn 10 MB.');
      }
      builder.add(chunk);
    }
    final Uint8List bytes = builder.takeBytes();
    if (bytes.isEmpty) return null;
    final ext = file.name.split('.').last.toLowerCase();
    final mime = switch (ext) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      'bmp' => 'image/bmp',
      _ => 'image/png',
    };
    return 'data:$mime;base64,${base64Encode(bytes)}';
  }

  Future<void> _pickCoverFromDevice() async {
    if (_editorBusy) return;
    try {
      final dataUri = await _readPickedImageAsDataUri(
        'Chọn ảnh bìa truyện từ máy tính / thiết bị',
      );
      if (dataUri == null || !mounted) return;
      setState(() => _coverUrl = dataUri);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã cập nhật trang bìa từ máy tính!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải ảnh bìa: $e')),
      );
    }
  }

  Future<void> _showCoverStudioSheet() async {
    if (_editorBusy) return;
    final urlCtrl = TextEditingController(
      text: _coverUrl.startsWith('http') ? _coverUrl : '',
    );
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.viewInsetsOf(ctx).bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.palette_outlined, color: Colors.amber),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Xưởng Thiết Kế Trang Bìa (Cover Studio)',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () {
                        final seed = _titleCtrl.text.trim().isEmpty
                            ? 'novel-${DateTime.now().millisecondsSinceEpoch}'
                            : Uri.encodeComponent(_titleCtrl.text.trim());
                        Navigator.pop(
                          ctx,
                          'https://picsum.photos/seed/$seed/300/450',
                        );
                      },
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      label: const Text('Tạo bìa tự động theo Tên truyện'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _pickCoverFromDevice();
                      },
                      icon: const Icon(Icons.upload_file, size: 18),
                      label: const Text('Tải ảnh bìa từ máy'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Hoặc chọn mẫu bìa nghệ thuật theo chủ đề:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final preset in _presetCovers)
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => Navigator.pop(ctx, preset.url),
                        child: Container(
                          width: 115,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _coverUrl == preset.url
                                  ? Theme.of(ctx).colorScheme.primary
                                  : Colors.white24,
                              width: _coverUrl == preset.url ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  preset.url,
                                  width: 100,
                                  height: 135,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    width: 100,
                                    height: 135,
                                    color: Colors.black26,
                                    child: const Icon(Icons.book),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                preset.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: urlCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Hoặc dán đường dẫn URL ảnh bìa',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, urlCtrl.text.trim()),
                      child: const Text('Áp dụng'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    urlCtrl.dispose();
    if (selected != null && mounted) {
      setState(() => _coverUrl = selected);
    }
  }

  Future<void> _showAllGenresDialog() async {
    if (_editorBusy) return;
    final temp = List<String>.from(_selectedGenres);
    final result = await showDialog<List<String>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Chọn thể loại (${temp.length}/5)'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final g in Genres.all)
                    FilterChip(
                      label: Text(g),
                      selected: temp.contains(g),
                      onSelected: (v) {
                        setDialogState(() {
                          if (v) {
                            if (temp.length < 5) temp.add(g);
                          } else if (temp.length > 1) {
                            temp.remove(g);
                          }
                        });
                      },
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
              onPressed: () => Navigator.pop(ctx, temp),
              child: const Text('Xong'),
            ),
          ],
        ),
      ),
    );
    if (result != null && result.isNotEmpty && mounted) {
      setState(() => _selectedGenres = result);
    }
  }

  void _aiContinueWriting() {
    if (_editorBusy) return;
    final title = _titleCtrl.text.trim().isEmpty
        ? 'tác phẩm'
        : _titleCtrl.text.trim();
    final chTitle = _draftChapterTitleCtrl.text.trim().isEmpty
        ? 'Chương 1'
        : _draftChapterTitleCtrl.text.trim();
    final mainGenre = _selectedGenres.isNotEmpty
        ? _selectedGenres.first
        : 'Tiên hiệp';

    final templates = <String>[
      'Giữa bầu không khí tĩnh lặng của "$title", một luồng gió lạnh bất ngờ thổi qua làm xao động những tán cây phía xa. Trong bối cảnh $chTitle thuộc dòng truyện $mainGenre, nhân vật chính khẽ thu lại ánh mắt trầm ngâm, nhận ra manh mối quan trọng vừa lộ diện.',
      '— "Chuyện này tuyệt đối không phải sự trùng hợp ngẫu nhiên!"\nLời vừa dứt, cả căn phòng chìm vào khoảng lặng sâu thẳm. Từng bước chân vang lên trên nền đá cổ như báo hiệu thử thách thực sự của $chTitle giờ mới chính thức bắt đầu.',
      'Ánh hoàng hôn dần buông xuống nhuộm đỏ cả chân trời. Nhớ lại mục tiêu ban đầu khi bước vào hành trình "$title", trong lòng bỗng dâng lên một quyết tâm mãnh liệt không gì có thể lay chuyển.',
    ];
    final currentLen = _draftContentCtrl.text.trim().length;
    final snippet = templates[currentLen % templates.length];

    _invalidateSubmissionRequest();
    final prefix = _draftContentCtrl.text.trim().isEmpty
        ? ''
        : '${_draftContentCtrl.text.trimRight()}\n\n';
    _draftContentCtrl.text = '$prefix$snippet';
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✨ AI đã gợi ý và viết tiếp đoạn văn mới vào chương!'),
      ),
    );
  }

  void _formatAndPolishDraft() {
    if (_editorBusy) return;
    final raw = _draftContentCtrl.text.trim();
    if (raw.isEmpty) return;
    final cleanedLines = raw
        .split('\n')
        .map((line) => line.trim().replaceAll(RegExp(r'[ \t]+'), ' '))
        .where((line) => line.isNotEmpty)
        .map((line) {
          if (line.startsWith('[img]') || line.startsWith('—')) return line;
          final first = line[0].toUpperCase();
          final rest = line.substring(1);
          final full = '$first$rest';
          if (!RegExp(r'[.!?…"”\]—]$').hasMatch(full)) {
            return '$full.';
          }
          return full;
        })
        .toList();
    _invalidateSubmissionRequest();
    _draftContentCtrl.text = cleanedLines.join('\n\n');
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🪄 Đã chuẩn hóa đoạn văn, khoảng trắng và dấu câu!'),
      ),
    );
  }

  void _insertTextSnippet(String snippet) {
    if (_editorBusy) return;
    _invalidateSubmissionRequest();
    final prefix = _draftContentCtrl.text.trim().isEmpty
        ? ''
        : '${_draftContentCtrl.text.trimRight()}\n\n';
    _draftContentCtrl.text = '$prefix$snippet\n';
    setState(() {});
  }

  Future<void> _pickAndInsertImageFromDevice() async {
    if (_editorBusy) return;
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'],
        dialogTitle: 'Chọn ảnh minh họa từ máy tính / thiết bị',
      );
      if (!mounted || files.isEmpty) return;

      final tags = <String>[];
      for (final file in files) {
        final builder = BytesBuilder(copy: false);
        await for (final chunk in file.readAsByteStream()) {
          if (builder.length + chunk.length > 10 * 1024 * 1024) {
            throw StateError('Ảnh ${file.name} vượt giới hạn 10 MB.');
          }
          builder.add(chunk);
        }
        final Uint8List bytes = builder.takeBytes();
        if (bytes.isEmpty) continue;
        final ext = file.name.split('.').last.toLowerCase();
        final mime = switch (ext) {
          'jpg' || 'jpeg' => 'image/jpeg',
          'png' => 'image/png',
          'webp' => 'image/webp',
          'gif' => 'image/gif',
          'bmp' => 'image/bmp',
          _ => 'image/png',
        };
        tags.add('[img]data:$mime;base64,${base64Encode(bytes)}[/img]');
      }

      if (tags.isEmpty || !mounted) return;
      _invalidateSubmissionRequest();
      final prefix = _draftContentCtrl.text.trim().isEmpty
          ? ''
          : '${_draftContentCtrl.text.trimRight()}\n\n';
      _draftContentCtrl.text = '$prefix${tags.join('\n\n')}\n';
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã tải và chèn ${tags.length} ảnh vào nội dung chương!',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải ảnh: $e')),
      );
    }
  }

  Future<void> _submitForModeration({bool autoApproveWithAi = false}) async {
    if (_editorBusy) return;
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    final owner = _draftOwner;
    final generation = _ownerGeneration;
    final revision = _editRevision;
    final submitted = _snapshot();
    final provider = context.read<AdminNovelProvider>();
    final novelProv = context.read<NovelProvider?>();
    final quests = context.read<QuestProvider?>();
    final messenger = ScaffoldMessenger.of(context);
    if (submitted.title.trim().isEmpty || submitted.content.trim().isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập Tên truyện và Nội dung chương đầu!'),
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    _draftDebounce?.cancel();
    try {
      RoleGuard.requireAuthorOrAdmin(user);
      final store = await _store;
      await store.save(owner, submitted);
      if (!_stillOwner(owner, generation)) return;
      final saved = await provider.saveNovel(
        actor: user,
        novel: Novel(
          id: 0,
          title: submitted.title.trim(),
          author: user.displayName,
          coverUrl: _coverUrl,
          description: submitted.description.trim(),
          status: _selectedStatus,
          type: _selectedType,
          genres: _selectedGenres.isEmpty
              ? const ['Tiên hiệp', 'Fantasy']
              : List<String>.unmodifiable(_selectedGenres),
          totalChapters: 1,
          rating: 0,
          views: 0,
          updatedAt: DateTime.now(),
        ),
        chapters: [
          (
            title: submitted.chapterTitle.trim().isEmpty
                ? AuthorDraft.defaultChapterTitle
                : submitted.chapterTitle.trim(),
            content: submitted.content.trim(),
          ),
        ],
        requestId: submitted.requestId,
      );

      var finalNovel = saved;
      if (autoApproveWithAi &&
          saved.moderationStatus != ModerationStatus.approved) {
        await provider.publishNovelByAiOrAdmin(
          actor: user,
          novel: saved,
          note: 'AI Kiểm duyệt tự động phê duyệt & Đăng công khai',
        );
        finalNovel = saved.copyWith(
          moderationStatus: ModerationStatus.approved,
        );
      }

      var nextDraft = const AuthorDraft();
      var cleanupFailed = false;
      try {
        if (!await store.clearIfMatches(owner, submitted)) {
          nextDraft = store.load(owner);
        }
      } catch (_) {
        cleanupFailed = true;
      }
      if (!_stillOwner(owner, generation)) return;
      setState(() {
        _myNovels = [
          finalNovel,
          ..._myNovels.where((n) => n.id != finalNovel.id),
        ];
        if (_editRevision == revision) {
          _applyDraft(nextDraft);
          _draftDirty = false;
          _lastSavedLabel = nextDraft.isEmpty
              ? 'Đã gửi tác phẩm'
              : 'Đã giữ bản nháp mới';
        }
      });
      if (quests != null) {
        unawaited(
          quests
              .unlockBadge(owner, 'cay_but_tre')
              .then<void>((_) {})
              .catchError((Object error) {
                debugPrint('Chưa ghi được huy hiệu tác giả: $error');
              }),
        );
      }
      unawaited(_refreshMyNovels());
      if (novelProv != null) {
        unawaited(novelProv.loadHome());
      }
      if (nextDraft.isEmpty && mounted) {
        _tabController.animateTo(1);
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            cleanupFailed
                ? 'Tác phẩm đã gửi thành công, nhưng chưa dọn được bản nháp đã lưu.'
                : (user.isAdmin || autoApproveWithAi)
                ? 'Đã xuất bản lên trang chủ!'
                : 'Đã gửi tác phẩm vào hàng chờ duyệt.',
          ),
        ),
      );
    } catch (error) {
      if (_stillOwner(owner, generation)) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'Chưa gửi được tác phẩm: $error. Bản nháp vẫn được giữ để thử lại.',
            ),
            duration: const Duration(seconds: 6),
          ),
        );
      }
    } finally {
      if (_stillOwner(owner, generation)) {
        setState(() => _submitting = false);
        if (_draftDirty) unawaited(_saveDraftSilently());
      }
    }
  }

  Future<void> _publishNovelPubliclyWithAi(Novel novel) async {
    final user = context.read<AuthProvider>().currentUser;
    final provider = context.read<AdminNovelProvider>();
    final novelProv = context.read<NovelProvider?>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final chapters = await provider.getChaptersForNovel(novel.id);
      final report = await AiModerationService.scanNovel(
        novel: novel,
        chapters: chapters,
      );
      if (report.safetyScore < 50) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              '⚠️ AI Kiểm duyệt phát hiện nội dung cần chỉnh sửa (Điểm an toàn: ${report.safetyScore}/100).',
            ),
          ),
        );
        return;
      }
      await provider.publishNovelByAiOrAdmin(
        actor: user,
        novel: novel,
        note:
            'AI Kiểm duyệt tự động phê duyệt (${report.safetyScore}/100 điểm) & Đăng công khai',
      );
      if (!mounted) return;
      setState(() {
        _myNovels = [
          for (final item in _myNovels)
            if (item.id == novel.id)
              item.copyWith(
                moderationStatus: ModerationStatus.approved,
                rejectionReason: '',
              )
            else
              item,
        ];
      });
      if (novelProv != null) {
        unawaited(novelProv.loadHome());
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '✅ AI Kiểm duyệt đạt ${report.safetyScore}/100 điểm! Đã đăng công khai "${novel.title}" lên Trang chủ.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Không thể đăng công khai: $e')),
      );
    }
  }

  Future<void> _showQuickAddChapterForNovel(Novel novel) async {
    final user = context.read<AuthProvider>().currentUser;
    final provider = context.read<AdminNovelProvider>();
    final novelProv = context.read<NovelProvider?>();
    final messenger = ScaffoldMessenger.of(context);
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => AddChapterDialog(
        initialTitle: 'Chương ${novel.totalChapters + 1}: ',
        onSaveWithSummary: (title, content, summary, requestId) async {
          await provider.saveChapterWithSummary(
            actor: user,
            chapter: Chapter(
              id: 0,
              novelId: novel.id,
              chapterIndex: novel.totalChapters + 1,
              title: title.isEmpty
                  ? 'Chương ${novel.totalChapters + 1}'
                  : title,
              content: content,
            ),
            summary: summary,
            requestId: requestId,
          );
        },
      ),
    );
    if (saved != true || !mounted) return;
    await _refreshMyNovels();
    if (novelProv != null) unawaited(novelProv.loadHome());
    messenger.showSnackBar(
      SnackBar(
        content: Text('Đã thêm chương mới vào "${novel.title}"!'),
      ),
    );
  }

  Future<void> _showEditNovelDialog(Novel novel) async {
    final titleCtrl = TextEditingController(text: novel.title);
    final authorCtrl = TextEditingController(text: novel.author);
    final descCtrl = TextEditingController(text: novel.description);
    var editCover = novel.coverUrl;
    var editStatus = novel.status;
    var editType = novel.type;
    final editGenres = List<String>.from(
      novel.genres.isEmpty ? const ['Tiên hiệp'] : novel.genres,
    );

    final updated = await showDialog<Novel>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('✏️ Chỉnh sửa thông tin tác phẩm'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCoverThumbnail(editCover, width: 72, height: 104),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () async {
                                final uri = await _readPickedImageAsDataUri(
                                  'Chọn ảnh bìa mới từ máy',
                                );
                                if (uri != null) {
                                  setDialogState(() => editCover = uri);
                                }
                              },
                              icon: const Icon(Icons.upload_file, size: 16),
                              label: const Text('Đổi ảnh bìa từ máy'),
                            ),
                            const SizedBox(height: 6),
                            TextButton.icon(
                              onPressed: () {
                                final seed =
                                    DateTime.now().millisecondsSinceEpoch;
                                setDialogState(
                                  () => editCover =
                                      'https://picsum.photos/seed/$seed/300/450',
                                );
                              },
                              icon: const Icon(Icons.auto_awesome, size: 16),
                              label: const Text('Tạo bìa ngẫu nhiên mới'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tên tác phẩm',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: authorCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tác giả / Bút danh',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Tóm tắt / Giới thiệu',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: editStatus,
                          decoration: const InputDecoration(
                            labelText: 'Tình trạng',
                            border: OutlineInputBorder(),
                            isDense: true,
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
                          onChanged: (v) {
                            if (v != null) setDialogState(() => editStatus = v);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: editType == NovelType.lightNovel
                              ? NovelType.lightNovel
                              : NovelType.novel,
                          decoration: const InputDecoration(
                            labelText: 'Loại truyện',
                            border: OutlineInputBorder(),
                            isDense: true,
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
                          ],
                          onChanged: (v) {
                            if (v != null) setDialogState(() => editType = v);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Thể loại:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final g in _quickGenres)
                        FilterChip(
                          label: Text(g, style: const TextStyle(fontSize: 12)),
                          selected: editGenres.contains(g),
                          onSelected: (v) {
                            setDialogState(() {
                              if (v) {
                                if (editGenres.length < 5) editGenres.add(g);
                              } else if (editGenres.length > 1) {
                                editGenres.remove(g);
                              }
                            });
                          },
                        ),
                    ],
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
            FilledButton.icon(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                Navigator.pop(
                  ctx,
                  novel.copyWith(
                    title: titleCtrl.text.trim(),
                    author: authorCtrl.text.trim().isEmpty
                        ? novel.author
                        : authorCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    coverUrl: editCover,
                    status: editStatus,
                    type: editType,
                    genres: List<String>.unmodifiable(editGenres),
                  ),
                );
              },
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );

    titleCtrl.dispose();
    authorCtrl.dispose();
    descCtrl.dispose();

    if (updated == null || !mounted) return;
    final user = context.read<AuthProvider>().currentUser;
    final provider = context.read<AdminNovelProvider>();
    final novelProv = context.read<NovelProvider?>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final saved = await provider.saveNovel(actor: user, novel: updated);
      if (!mounted) return;
      setState(() {
        _myNovels = [
          for (final item in _myNovels)
            if (item.id == saved.id) saved else item,
        ];
      });
      if (novelProv != null) unawaited(novelProv.loadHome());
      messenger.showSnackBar(
        SnackBar(content: Text('Đã cập nhật tác phẩm "${saved.title}"!')),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Không thể lưu chỉnh sửa: $e')),
      );
    }
  }

  Future<void> _confirmDeleteNovel(Novel novel) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🗑️ Xác nhận xóa tác phẩm'),
        content: Text(
          'Bạn có chắc chắn muốn xóa tác phẩm "${novel.title}" khỏi danh sách không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xóa tác phẩm'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    final user = context.read<AuthProvider>().currentUser;
    final provider = context.read<AdminNovelProvider>();
    final novelProv = context.read<NovelProvider?>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      await provider.deleteNovelByOwnerOrAdmin(actor: user, novel: novel);
      if (!mounted) return;
      setState(() {
        _myNovels = _myNovels.where((item) => item.id != novel.id).toList();
      });
      if (novelProv != null) unawaited(novelProv.loadHome());
      messenger.showSnackBar(
        SnackBar(content: Text('Đã xóa tác phẩm "${novel.title}".')),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Không thể xóa tác phẩm: $e')),
      );
    }
  }

  Future<void> _checkWithAi() async {
    if (_editorBusy) return;
    final owner = _draftOwner;
    final generation = _ownerGeneration;
    if (_titleCtrl.text.trim().isEmpty ||
        _draftContentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng nhập Tên truyện và Nội dung chương trước khi kiểm tra AI!',
          ),
        ),
      );
      return;
    }

    final dummyNovel = Novel(
      id: 0,
      title: _titleCtrl.text.trim(),
      author: context.read<AuthProvider>().currentUser.displayName,
      coverUrl: _coverUrl,
      description: _descCtrl.text.trim(),
      status: _selectedStatus,
      type: _selectedType,
      genres: _selectedGenres,
      totalChapters: 1,
      rating: 5.0,
      views: 0,
      updatedAt: DateTime.now(),
      moderationStatus: ModerationStatus.pending,
    );

    final dummyChapter = Chapter(
      id: 0,
      novelId: 0,
      chapterIndex: 1,
      title: _draftChapterTitleCtrl.text.trim(),
      content: _draftContentCtrl.text.trim(),
      isDownloaded: true,
    );

    final report = await AiModerationService.scanNovel(
      novel: dummyNovel,
      chapters: [dummyChapter],
    );

    if (!mounted || !_stillOwner(owner, generation)) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.psychology, color: Colors.blue, size: 28),
                SizedBox(width: 10),
                Text(
                  'AI Tiền Kiểm • Đánh giá sơ bộ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              color: report.safetyScore >= 85
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              child: ListTile(
                leading: Text(
                  '${report.safetyScore}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: report.safetyScore >= 85
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
                title: Text(
                  report.recommendationLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Điểm an toàn nội dung: ${report.safetyScore}/100',
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (final p in report.passedCriteria)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(p, style: const TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ),
            if (report.warnings.isNotEmpty) ...[
              const SizedBox(height: 8),
              for (final w in report.warnings)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        color: Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          w,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Tiếp tục soạn thảo'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _submitForModeration(autoApproveWithAi: true);
                    },
                    icon: const Icon(Icons.public, size: 18),
                    label: const Text('AI Duyệt & Đăng ngay'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverThumbnail(
    String coverUrl, {
    double width = 76,
    double height = 110,
  }) {
    final scheme = Theme.of(context).colorScheme;
    Widget inner;
    if (coverUrl.startsWith('data:image/')) {
      final bytes = decodeReaderImageDataUri(coverUrl);
      inner = bytes != null
          ? Image.memory(bytes, width: width, height: height, fit: BoxFit.cover)
          : const Icon(Icons.menu_book, size: 32);
    } else if (coverUrl.startsWith('http')) {
      inner = Image.network(
        coverUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Icon(Icons.menu_book, size: 32),
      );
    } else {
      inner = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_stories_outlined, size: 28, color: scheme.primary),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              _titleCtrl.text.trim().isEmpty
                  ? 'Bìa truyện'
                  : _titleCtrl.text.trim(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    }
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: inner,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (user.isGuest) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Bút Mặc Tiên Sinh • Sáng tác truyện'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.history_edu,
                    size: 64,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Không gian Bút Mặc Tiên Sinh',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Mọi độc giả đều có thể tự do sáng tác truyện, tự động lưu bản thảo mỗi 5 giây và gửi tác phẩm để Quản trị viên duyệt xuất bản.\n\nVui lòng đăng nhập để bắt đầu viết truyện!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  icon: const Icon(Icons.login),
                  label: const Text('Đăng nhập ngay'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final words = _draftContentCtrl.text.trim().isEmpty
        ? 0
        : _draftContentCtrl.text.trim().split(RegExp(r'\s+')).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bút Mặc Tiên Sinh • Truyện của tôi'),
        actions: [
          IconButton(
            tooltip: 'Nạp truyện từ File TXT',
            icon: const Icon(Icons.file_upload_outlined),
            onPressed: _submitting
                ? null
                : () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => SmartNovelImporterSheet(
                      onImportDone: () {
                        _refreshMyNovels();
                        if (mounted) _tabController.animateTo(1);
                      },
                    ),
                  ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.edit_note), text: 'Soạn thảo & Tự lưu nháp'),
            Tab(
              icon: Icon(Icons.analytics_outlined),
              text: 'Tác phẩm của tôi',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _KeepAliveTab(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer
                        .withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.upload_file_rounded,
                              size: 24,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Nạp truyện tự động (File TXT)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                  ),
                                ),
                                Text(
                                  'Chọn file .txt để tự điền thông tin và tách chương.',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton.tonalIcon(
                            onPressed: _submitting
                                ? null
                                : () => showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (_) => SmartNovelImporterSheet(
                                      onImportDone: () {
                                        _refreshMyNovels();
                                        if (mounted) _tabController.animateTo(1);
                                      },
                                    ),
                                  ),
                            icon: const Icon(
                              Icons.drive_folder_upload,
                              size: 18,
                            ),
                            label: const Text('Nạp file'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.save_outlined, size: 16),
                        label: Text(_lastSavedLabel),
                      ),
                      Text(
                        '$words từ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Khung Thiết Kế Trang Bìa + Tên tác phẩm & Giới thiệu
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _showCoverStudioSheet,
                        child: _buildCoverThumbnail(
                          _coverUrl,
                          width: 92,
                          height: 132,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              key: const ValueKey('author-draft-title'),
                              controller: _titleCtrl,
                              enabled: !_editorBusy,
                              onChanged: (_) => _invalidateSubmissionRequest(),
                              decoration: const InputDecoration(
                                isDense: true,
                                labelText: 'Tên tác phẩm mới',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              key: const ValueKey('author-draft-description'),
                              controller: _descCtrl,
                              enabled: !_editorBusy,
                              maxLines: 2,
                              onChanged: (_) => _invalidateSubmissionRequest(),
                              decoration: const InputDecoration(
                                isDense: true,
                                labelText: 'Tóm tắt / Giới thiệu truyện',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Thanh công cụ Trang Bìa, Định dạng & Thể loại
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: _editorBusy ? null : _pickCoverFromDevice,
                        icon: const Icon(Icons.upload_file_outlined, size: 16),
                        label: const Text(
                          'Tải ảnh bìa từ máy',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: _editorBusy ? null : _showCoverStudioSheet,
                        icon: const Icon(Icons.auto_awesome_outlined, size: 16),
                        label: const Text(
                          'Tạo trang bìa AI / Mẫu bìa',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      ChoiceChip(
                        visualDensity: VisualDensity.compact,
                        label: const Text(
                          'Truyện chữ',
                          style: TextStyle(fontSize: 11.5),
                        ),
                        selected: _selectedType == NovelType.novel,
                        onSelected: _editorBusy
                            ? null
                            : (_) => setState(
                                () => _selectedType = NovelType.novel,
                              ),
                      ),
                      ChoiceChip(
                        visualDensity: VisualDensity.compact,
                        label: const Text(
                          'Light Novel',
                          style: TextStyle(fontSize: 11.5),
                        ),
                        selected: _selectedType == NovelType.lightNovel,
                        onSelected: _editorBusy
                            ? null
                            : (_) => setState(
                                () => _selectedType = NovelType.lightNovel,
                              ),
                      ),
                      ChoiceChip(
                        visualDensity: VisualDensity.compact,
                        label: const Text(
                          'Đang ra',
                          style: TextStyle(fontSize: 11.5),
                        ),
                        selected: _selectedStatus == NovelStatus.ongoing,
                        onSelected: _editorBusy
                            ? null
                            : (_) => setState(
                                () => _selectedStatus = NovelStatus.ongoing,
                              ),
                      ),
                      ChoiceChip(
                        visualDensity: VisualDensity.compact,
                        label: const Text(
                          'Hoàn thành',
                          style: TextStyle(fontSize: 11.5),
                        ),
                        selected: _selectedStatus == NovelStatus.completed,
                        onSelected: _editorBusy
                            ? null
                            : (_) => setState(
                                () => _selectedStatus = NovelStatus.completed,
                              ),
                      ),
                      ActionChip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.category_outlined, size: 15),
                        label: Text(
                          'Thể loại (${_selectedGenres.join(", ")}) • Chọn 40 thể loại',
                          style: const TextStyle(fontSize: 11.5),
                        ),
                        onPressed: _editorBusy ? null : _showAllGenresDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    key: const ValueKey('author-draft-chapter-title'),
                    controller: _draftChapterTitleCtrl,
                    enabled: !_editorBusy,
                    onChanged: (_) => _invalidateSubmissionRequest(),
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Tiêu đề chương đầu',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: _editorBusy
                            ? null
                            : _pickAndInsertImageFromDevice,
                        icon: const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 16,
                        ),
                        label: const Text(
                          'Tải ảnh từ máy lên',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: _editorBusy ? null : _aiContinueWriting,
                        icon: const Icon(Icons.auto_awesome_outlined, size: 16),
                        label: const Text(
                          'AI Viết tiếp',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: _editorBusy ? null : _formatAndPolishDraft,
                        icon: const Icon(
                          Icons.auto_fix_high_outlined,
                          size: 16,
                        ),
                        label: const Text(
                          'Chuẩn hóa văn bản',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      ActionChip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(
                          Icons.chat_bubble_outline,
                          size: 15,
                        ),
                        label: const Text(
                          'Chèn hội thoại',
                          style: TextStyle(fontSize: 11.5),
                        ),
                        onPressed: _editorBusy
                            ? null
                            : () => _insertTextSnippet('— "..."'),
                      ),
                      ActionChip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.horizontal_rule, size: 15),
                        label: const Text(
                          'Phân cảnh (* * *)',
                          style: TextStyle(fontSize: 11.5),
                        ),
                        onPressed: _editorBusy
                            ? null
                            : () => _insertTextSnippet('* * *'),
                      ),
                      FilterChip(
                        visualDensity: VisualDensity.compact,
                        label: const Text(
                          'Xem trước giao diện đọc',
                          style: TextStyle(fontSize: 11.5),
                        ),
                        selected: _previewMode,
                        onSelected: _editorBusy
                            ? null
                            : (v) => setState(() => _previewMode = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_previewMode)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4ECD8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _buildPreviewContent(),
                    )
                  else
                    TextField(
                      key: const ValueKey('author-draft-content'),
                      controller: _draftContentCtrl,
                      enabled: !_editorBusy,
                      maxLines: 6,
                      onChanged: (_) {
                        _invalidateSubmissionRequest();
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        hintText:
                            'Soạn nội dung chương tại đây (hệ thống tự lưu nháp mỗi 5 giây)...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          foregroundColor: Colors.blue.shade700,
                        ),
                        onPressed: _editorBusy ? null : _checkWithAi,
                        icon: const Icon(Icons.psychology),
                        label: const Text('AI Tiền Kiểm'),
                      ),
                      FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                        onPressed: _editorBusy
                            ? null
                            : () =>
                                  _submitForModeration(autoApproveWithAi: true),
                        icon: const Icon(Icons.public),
                        label: const Text('AI Duyệt & Đăng công khai'),
                      ),
                      FilledButton.icon(
                        onPressed: _editorBusy
                            ? null
                            : () => _submitForModeration(),
                        icon: const Icon(Icons.send),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            _submitting ? 'Đang gửi…' : 'Gửi duyệt xuất bản',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _KeepAliveTab(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_booksLoading) const LinearProgressIndicator(),
                if (_booksError != null) Text(_booksError!),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Text(
                      'Tác phẩm của ${user.displayName} (${_myNovels.length} bộ):',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: _submitting
                          ? null
                          : () {
                              _tabController.animateTo(0);
                            },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Thêm tác phẩm mới'),
                    ),
                    TextButton.icon(
                      onPressed: _submitting ? null : _refreshMyNovels,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tải lại tác phẩm'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_myNovels.isEmpty && !_booksLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Bạn chưa có tác phẩm nào. Hãy tạo truyện ở tab "Soạn thảo & Tự lưu nháp" nhé!',
                      ),
                    ),
                  ),
                for (final n in _myNovels)
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReaderScreen(novel: n),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildCoverThumbnail(
                                  n.coverUrl,
                                  width: 56,
                                  height: 80,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              n.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          _buildModerationBadge(
                                            n.moderationStatus,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Trạng thái: ${n.moderationStatus.toUpperCase()} • ${n.totalChapters} chương • 👁️ ${n.views} lượt đọc',
                                        style: const TextStyle(fontSize: 12.5),
                                      ),
                                      if (n.genres.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'Thể loại: ${n.genres.join(", ")}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                      if (n.rejectionReason != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          '⚠️ Lý do Admin từ chối: ${n.rejectionReason}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (n.moderationStatus !=
                                  ModerationStatus.approved)
                                FilledButton.tonalIcon(
                                  onPressed: () =>
                                      _publishNovelPubliclyWithAi(n),
                                  icon: const Icon(Icons.public, size: 16),
                                  label: const Text(
                                    'AI Duyệt & Đăng công khai',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )
                              else
                                Chip(
                                  visualDensity: VisualDensity.compact,
                                  avatar: const Icon(
                                    Icons.verified,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    'Đã đăng công khai',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              OutlinedButton.icon(
                                onPressed: () =>
                                    _showQuickAddChapterForNovel(n),
                                icon: const Icon(Icons.playlist_add, size: 16),
                                label: const Text(
                                  'Thêm chương',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _showEditNovelDialog(n),
                                icon: const Icon(Icons.edit_outlined, size: 16),
                                label: const Text(
                                  'Sửa truyện',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ChapterEditorScreen(novel: n),
                                    ),
                                  );
                                  if (mounted) _refreshMyNovels();
                                },
                                icon: const Icon(
                                  Icons.format_list_numbered,
                                  size: 16,
                                ),
                                label: const Text(
                                  'Quản lý chương',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.redAccent,
                                ),
                                onPressed: () => _confirmDeleteNovel(n),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 16,
                                ),
                                label: const Text(
                                  'Xóa',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildModerationBadge(String status) {
    final (label, color) = switch (status) {
      ModerationStatus.approved => ('CÔNG KHAI', Colors.green),
      ModerationStatus.rejected => ('TỪ CHỐI', Colors.red),
      _ => ('CHỜ DUYỆT', Colors.orange),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPreviewContent() {
    final raw = _draftContentCtrl.text.trim();
    if (raw.isEmpty) {
      return const Text(
        'Chưa có nội dung để xem trước.',
        style: TextStyle(
          color: Color(0xFF5B4636),
          fontSize: 17,
          height: 1.6,
        ),
      );
    }
    final lines = raw
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final line in lines)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildPreviewLine(line),
          ),
      ],
    );
  }

  Widget _buildPreviewLine(String line) {
    final m = readerInlineImgPattern.firstMatch(line);
    if (m != null) {
      final src = m.group(1)?.trim() ?? '';
      if (src.startsWith('data:image/')) {
        final bytes = decodeReaderImageDataUri(src);
        if (bytes != null) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 320,
                maxHeight: 240,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(bytes, fit: BoxFit.contain),
              ),
            ),
          );
        }
      } else if (src.startsWith('http')) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 320,
              maxHeight: 240,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(src, fit: BoxFit.contain),
            ),
          ),
        );
      }
    }
    return Text(
      line,
      style: const TextStyle(
        color: Color(0xFF5B4636),
        fontSize: 17,
        height: 1.6,
      ),
    );
  }
}

class _KeepAliveTab extends StatefulWidget {
  final Widget child;
  const _KeepAliveTab({required this.child});

  @override
  State<_KeepAliveTab> createState() => _KeepAliveTabState();
}

class _KeepAliveTabState extends State<_KeepAliveTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
