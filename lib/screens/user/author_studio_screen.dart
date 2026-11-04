import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/supabase_database.dart';
import '../../models/chapter.dart';
import '../../models/novel.dart';
import '../../providers/admin_novel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quest_provider.dart';
import '../../services/ai_moderation_service.dart';
import '../../services/author_draft_store.dart';
import '../../utils/constants.dart';
import '../../utils/role_guard.dart';
import '../../widgets/smart_novel_importer_sheet.dart';
import '../admin/chapter_editor_screen.dart';
import '../auth/login_screen.dart';

/// Màn hình Dành cho Tác giả («Truyện của tôi» - Mục 5.7).
/// Hỗ trợ tạo truyện, soạn chương với bộ tự lưu nháp mỗi 5 giây, chèn ảnh `[img]url[/img]`, gửi duyệt và xem thống kê lượt đọc.
class AuthorStudioScreen extends StatefulWidget {
  const AuthorStudioScreen({super.key});

  @override
  State<AuthorStudioScreen> createState() => _AuthorStudioScreenState();
}

class _AuthorStudioScreenState extends State<AuthorStudioScreen>
    with WidgetsBindingObserver {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _draftChapterTitleCtrl = TextEditingController(
    text: 'Chương 1: Khởi đầu mới',
  );
  final _draftContentCtrl = TextEditingController();

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
          () => _booksError = 'Chưa tải được tác phẩm. Bản nháp trên thiết bị vẫn sử dụng được.',
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
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _draftChapterTitleCtrl.dispose();
    _draftContentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitForModeration() async {
    if (_editorBusy) return;
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    final owner = _draftOwner;
    final generation = _ownerGeneration;
    final revision = _editRevision;
    final submitted = _snapshot();
    final provider = context.read<AdminNovelProvider>();
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
      await provider.saveNovel(
        actor: user,
        novel: Novel(
          id: 0,
          title: submitted.title.trim(),
          author: user.displayName,
          coverUrl: '',
          description: submitted.description.trim(),
          status: NovelStatus.ongoing,
          type: NovelType.novel,
          genres: const ['Tiên hiệp', 'Fantasy'],
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
      if (_editRevision == revision) {
        setState(() {
          _applyDraft(nextDraft);
          _draftDirty = false;
          _lastSavedLabel = nextDraft.isEmpty
              ? 'Đã gửi tác phẩm'
              : 'Đã giữ bản nháp mới';
        });
      }
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
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            cleanupFailed
                ? 'Tác phẩm đã gửi thành công, nhưng chưa dọn được bản nháp đã lưu.'
                : user.isAdmin
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
      coverUrl: '',
      description: _descCtrl.text.trim(),
      status: NovelStatus.ongoing,
      type: NovelType.novel,
      genres: const ['Tien hiep', 'Fantasy'],
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
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Đã hiểu & Tiếp tục soạn thảo'),
              ),
            ),
          ],
        ),
      ),
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bút Mặc Tiên Sinh • Truyện của tôi'),
          actions: [
            IconButton(
              tooltip: 'Nạp truyện từ File TXT / Thư mục Manga',
              icon: const Icon(Icons.file_upload_outlined),
              onPressed: _submitting
                  ? null
                  : () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => SmartNovelImporterSheet(
                        onImportDone: _refreshMyNovels,
                      ),
                    ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.edit_note), text: 'Soạn thảo & Tự lưu nháp'),
              Tab(
                icon: Icon(Icons.analytics_outlined),
                text: 'Tác phẩm của tôi',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
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
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.upload_file_rounded,
                            size: 28,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nạp truyện tự động (File TXT / Folder Manga)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Chọn file .txt để tự điền thông tin và tách chương.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
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
                                    onImportDone: _refreshMyNovels,
                                  ),
                                ),
                          icon: const Icon(Icons.drive_folder_upload, size: 18),
                          label: const Text('Nạp file'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.save_outlined, size: 16),
                      label: Text(_lastSavedLabel),
                    ),
                    Text(
                      '$words từ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const ValueKey('author-draft-title'),
                  controller: _titleCtrl,
                  enabled: !_editorBusy,
                  onChanged: (_) => _invalidateSubmissionRequest(),
                  decoration: const InputDecoration(
                    labelText: 'Tên tác phẩm mới',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const ValueKey('author-draft-description'),
                  controller: _descCtrl,
                  enabled: !_editorBusy,
                  maxLines: 2,
                  onChanged: (_) => _invalidateSubmissionRequest(),
                  decoration: const InputDecoration(
                    labelText: 'Tóm tắt / Giới thiệu truyện',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const ValueKey('author-draft-chapter-title'),
                  controller: _draftChapterTitleCtrl,
                  enabled: !_editorBusy,
                  onChanged: (_) => _invalidateSubmissionRequest(),
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề chương đầu',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _editorBusy
                          ? null
                          : () {
                              _invalidateSubmissionRequest();
                              _draftContentCtrl.text =
                                  '${_draftContentCtrl.text}\n[img]https://picsum.photos/seed/ln/600/400[/img]\n';
                              setState(() {});
                            },
                      icon: const Icon(Icons.image_outlined, size: 18),
                      label: const Text('Chèn thẻ [img]'),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Xem trước giao diện đọc'),
                      selected: _previewMode,
                      onSelected: _editorBusy
                          ? null
                          : (v) => setState(() => _previewMode = v),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_previewMode)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4ECD8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _draftContentCtrl.text.isEmpty
                          ? 'Chưa có nội dung để xem trước.'
                          : _draftContentCtrl.text,
                      style: const TextStyle(
                        color: Color(0xFF5B4636),
                        fontSize: 17,
                        height: 1.6,
                      ),
                    ),
                  )
                else
                  TextField(
                    key: const ValueKey('author-draft-content'),
                    controller: _draftContentCtrl,
                    enabled: !_editorBusy,
                    maxLines: 9,
                    onChanged: (_) {
                      _invalidateSubmissionRequest();
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      hintText: 'Soạn nội dung chương tại đây (hệ thống tự lưu nháp mỗi 5 giây)...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          foregroundColor: Colors.blue.shade700,
                        ),
                        onPressed: _editorBusy ? null : _checkWithAi,
                        icon: const Icon(Icons.psychology),
                        label: const Text('AI Tiền Kiểm'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: _editorBusy ? null : _submitForModeration,
                        icon: const Icon(Icons.send),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            _submitting ? 'Đang gửi…' : 'Gửi duyệt xuất bản',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_booksLoading) const LinearProgressIndicator(),
                if (_booksError != null) Text(_booksError!),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _submitting ? null : _refreshMyNovels,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tải lại tác phẩm'),
                  ),
                ),
                Text(
                  'Tác phẩm của ${user.displayName} (${_myNovels.length} bộ):',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                for (final n in _myNovels)
                  Card(
                    child: ListTile(
                      title: Text(
                        n.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Trạng thái: ${n.moderationStatus.toUpperCase()} • ${n.totalChapters} chương • 👁️ ${n.views} lượt đọc'
                        '${n.rejectionReason != null ? "\n⚠️ Lý do Admin từ chối: ${n.rejectionReason}" : ""}',
                      ),
                      isThreeLine: n.rejectionReason != null,
                      trailing: IconButton(
                        tooltip: 'Soạn thêm chương',
                        icon: const Icon(Icons.playlist_add),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChapterEditorScreen(novel: n),
                          ),
                        ),
                      ),
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
