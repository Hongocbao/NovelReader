import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/app_database.dart';
import '../../models/novel.dart';
import '../../providers/admin_novel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quest_provider.dart';
import '../../utils/constants.dart';
import '../../utils/role_guard.dart';
import '../admin/chapter_editor_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (!RoleGuard.can(user, AppPermission.publishContent)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Truyện của tôi (Tác giả)')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Tài khoản của bạn chưa được bật quyền Tác giả (is_author = true). Hãy đăng nhập bằng tài khoản Author mẫu hoặc nhờ Admin cấp quyền.',
              textAlign: TextAlign.center,
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
          title: const Text('Author Studio • Truyện của tôi'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.edit_note),
                text: 'Trình soạn thảo & Tự lưu nháp',
              ),
              Tab(
                icon: Icon(Icons.analytics_outlined),
                text: 'Tác phẩm & Thống kê',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
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
                FilledButton.icon(
                  onPressed: _submitForModeration,
                  icon: const Icon(Icons.send),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Gửi duyệt xuất bản'),
                  ),
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
