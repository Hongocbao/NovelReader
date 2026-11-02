import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/app_database.dart';
import '../../database/supabase_database.dart';
import '../../models/chapter.dart';
import '../../models/novel.dart';
import '../../providers/admin_novel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quest_provider.dart';
import '../../services/ai_moderation_service.dart';
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

class _AuthorStudioScreenState extends State<AuthorStudioScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _draftChapterTitleCtrl = TextEditingController(
    text: 'Chương 1: Khởi đầu mới',
  );
  final _draftContentCtrl = TextEditingController();

  List<Novel> _myNovels = [];
  Timer? _autoSaveTimer;
  String _lastSavedLabel = 'Chưa lưu nháp';
  bool _previewMode = false;

  @override
  void initState() {
    super.initState();
    _loadMyNovelsAndDraft();
    // Tự động lưu bản nháp mỗi 5 giây theo đặc tả Mục 5.7
    _autoSaveTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _saveDraftSilently(),
    );
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _draftChapterTitleCtrl.dispose();
    _draftContentCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadMyNovelsAndDraft() async {
    final user = context.read<AuthProvider>().currentUser;
    final list = await context.read<AdminNovelProvider>().getAuthorNovels(
          user.id,
        );
    final prefs = await SharedPreferences.getInstance();
    final savedDraft = prefs.getString('author_draft_content_${user.id}') ?? '';
    if (savedDraft.isNotEmpty && _draftContentCtrl.text.isEmpty) {
      _draftContentCtrl.text = savedDraft;
    }
    if (mounted) {
      setState(() => _myNovels = list);
    }
  }

  Future<void> _saveDraftSilently() async {
    if (_draftContentCtrl.text.trim().isEmpty) return;
    final user = context.read<AuthProvider>().currentUser;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'author_draft_content_${user.id}',
      _draftContentCtrl.text,
    );
    if (mounted) {
      final now = TimeOfDay.now();
      setState(() {
        _lastSavedLabel =
            'Đã tự lưu nháp lúc ${now.hour}:${now.minute.toString().padLeft(2, "0")}';
      });
    }
  }

  Future<void> _submitForModeration() async {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    RoleGuard.requireAuthorOrAdmin(user);

    if (_titleCtrl.text.trim().isEmpty ||
        _draftContentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập Tên truyện và Nội dung chương đầu!'),
        ),
      );
      return;
    }

    try {
      await SupabaseDatabase.instance.insertCustomNovel(
        title: _titleCtrl.text.trim(),
        author: user.displayName,
        description: _descCtrl.text.trim(),
        status: NovelStatus.ongoing,
        type: NovelType.novel,
        genres: const ['Tiên hiệp', 'Fantasy'],
        chapterTitles: [_draftChapterTitleCtrl.text.trim()],
        chapterContents: [_draftContentCtrl.text.trim()],
        moderationStatus: user.isAdmin
            ? ModerationStatus.approved
            : ModerationStatus.pending,
        ownerId: user.id,
      );
    } catch (_) {
      // Fallback lưu cục bộ nếu offline
      await AppDatabase.instance.insertCustomNovel(
        title: _titleCtrl.text.trim(),
        author: user.displayName,
        description: _descCtrl.text.trim(),
        status: NovelStatus.ongoing,
        type: NovelType.novel,
        genres: const ['Tiên hiệp', 'Fantasy'],
        chapters: [
          (
            title: _draftChapterTitleCtrl.text.trim(),
            content: _draftContentCtrl.text.trim(),
          ),
        ],
        moderationStatus: user.isAdmin
            ? ModerationStatus.approved
            : ModerationStatus.pending,
        ownerId: user.id,
      );
    }

    if (!mounted) return;
    await context.read<QuestProvider>().unlockBadge(user.id, 'cay_but_tre');
    _titleCtrl.clear();
    _descCtrl.clear();
    _draftContentCtrl.clear();
    await _loadMyNovelsAndDraft();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          user.isAdmin
              ? '✅ Đã xuất bản thẳng lên trang chủ!'
              : '📨 Đã gửi tác phẩm vào Hàng chờ duyệt của Admin!',
        ),
      ),
    );
  }

  Future<void> _checkWithAi() async {
    if (_titleCtrl.text.trim().isEmpty || _draftContentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập Tên truyện và Nội dung chương trước khi kiểm tra AI!'),
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

    if (!mounted) return;

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
                    color: report.safetyScore >= 85 ? Colors.green : Colors.orange,
                  ),
                ),
                title: Text(
                  report.recommendationLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Điểm an toàn nội dung: ${report.safetyScore}/100'),
              ),
            ),
            const SizedBox(height: 12),
            for (final p in report.passedCriteria)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(p, style: const TextStyle(fontSize: 13))),
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
                      const Icon(Icons.warning_amber, color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          w,
                          style: const TextStyle(fontSize: 13, color: Colors.orange),
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
        appBar: AppBar(title: const Text('Bút Mặc Tiên Sinh • Sáng tác truyện')),
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
                  child: const Icon(Icons.history_edu, size: 64, color: Colors.amber),
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
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => SmartNovelImporterSheet(
                  onImportDone: _loadMyNovelsAndDraft,
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.edit_note),
                text: 'Soạn thảo & Tự lưu nháp',
              ),
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
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
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
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Tự động tách chương từ file .txt hoặc quét folder ảnh truyện tranh manga.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.tonalIcon(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => SmartNovelImporterSheet(
                              onImportDone: _loadMyNovelsAndDraft,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tên tác phẩm mới',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Tóm tắt / Giới thiệu truyện',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _draftChapterTitleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề chương đầu',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
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
                      onSelected: (v) => setState(() => _previewMode = v),
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
                    controller: _draftContentCtrl,
                    maxLines: 9,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText:
                          'Soạn nội dung chương tại đây (hệ thống tự lưu nháp mỗi 5 giây)...',
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
                        onPressed: _checkWithAi,
                        icon: const Icon(Icons.psychology),
                        label: const Text('AI Tiền Kiểm'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: _submitForModeration,
                        icon: const Icon(Icons.send),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Gửi duyệt xuất bản'),
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
