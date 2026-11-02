import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../database/supabase_database.dart';
import '../models/novel.dart';
import '../providers/auth_provider.dart';
import '../providers/library_provider.dart';
import '../utils/constants.dart';

/// Modal nạp truyện tự động từ File TXT / Thư mục chương hoặc Thư mục Manga.
class SmartNovelImporterSheet extends StatefulWidget {
  final VoidCallback? onImportDone;

  const SmartNovelImporterSheet({super.key, this.onImportDone});

  @override
  State<SmartNovelImporterSheet> createState() => _SmartNovelImporterSheetState();
}

class _SmartNovelImporterSheetState extends State<SmartNovelImporterSheet> {
  int _tabIndex = 0; // 0: Truyện chữ, 1: Manga

  // Controllers cho Truyện chữ
  final _textTitleCtrl = TextEditingController();
  final _textAuthorCtrl = TextEditingController();
  final _textPathCtrl = TextEditingController();
  final _textPasteCtrl = TextEditingController();

  // Controllers cho Truyện tranh Manga
  final _mangaTitleCtrl = TextEditingController(text: 'Doc Chien De Vuong');
  final _mangaAuthorCtrl = TextEditingController(text: 'Dang Cap Manga');
  final _mangaPathCtrl = TextEditingController(text: r'e:\file down truyện\Độc Chiến Đế Vương');

  bool _isScanning = false;
  bool _submitToCommunity = false;
  String _scanResultText = '';
  List<({String title, String content})> _parsedChapters = [];

  @override
  void dispose() {
    _textTitleCtrl.dispose();
    _textAuthorCtrl.dispose();
    _textPathCtrl.dispose();
    _textPasteCtrl.dispose();
    _mangaTitleCtrl.dispose();
    _mangaAuthorCtrl.dispose();
    _mangaPathCtrl.dispose();
    super.dispose();
  }

  /// Tự động quét và phân tách chương cho Truyện Chữ
  Future<void> _scanTextNovel() async {
    setState(() {
      _isScanning = true;
      _scanResultText = 'Đang phân tích cấu trúc chương...';
      _parsedChapters = [];
    });

    try {
      final inputPath = _textPathCtrl.text.trim();
      final pasteText = _textPasteCtrl.text.trim();

      if (inputPath.isNotEmpty) {
        final dir = Directory(inputPath);
        final file = File(inputPath);

        if (await dir.exists()) {
          // Trường hợp 1: Thư mục chứa nhiều file Chuong_01.txt, Chuong_02.txt...
          final list = dir.listSync().whereType<File>().toList();
          list.sort((a, b) => a.path.compareTo(b.path));

          final chapters = <({String title, String content})>[];
          for (var i = 0; i < list.length; i++) {
            final content = await list[i].readAsString();
            final lines = content.split('\n');
            String title = lines.isNotEmpty ? lines[0].trim() : 'Chuong ${i + 1}';
            if (!title.toLowerCase().startsWith('chuong') && !title.toLowerCase().startsWith('chương')) {
              title = 'Chuong ${i + 1}: $title';
            }
            chapters.add((title: title, content: content));
          }

          if (_textTitleCtrl.text.trim().isEmpty) {
            _textTitleCtrl.text = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
          }

          setState(() {
            _parsedChapters = chapters;
            _scanResultText = '✅ Đã tìm thấy và tự động sắp xếp ${chapters.length} chương từ thư mục!';
          });
          return;
        } else if (await file.exists()) {
          // Trường hợp 2: File TXT gộp lớn chứa toàn bộ các chương
          final fullContent = await file.readAsString();
          _splitFullTextToChapters(fullContent);
          if (_textTitleCtrl.text.trim().isEmpty) {
            final baseName = file.uri.pathSegments.last.replaceAll('.txt', '');
            _textTitleCtrl.text = baseName;
          }
          return;
        }
      }

      if (pasteText.isNotEmpty) {
        // Trường hợp 3: Dán trực tiếp văn bản nhiều chương
        _splitFullTextToChapters(pasteText);
        return;
      }

      setState(() {
        _scanResultText = '⚠️ Vui lòng nhập đường dẫn thư mục/file .txt hợp lệ hoặc dán văn bản!';
      });
    } catch (e) {
      setState(() {
        _scanResultText = '❌ Lỗi đọc file: $e';
      });
    } finally {
      setState(() => _isScanning = false);
    }
  }

  /// Tự động bẻ/tách văn bản nhiều chương thành danh sách chương riêng biệt
  void _splitFullTextToChapters(String fullText) {
    final chapterRegex = RegExp(
      r'(?:^|\n\s*)(Chương\s*\d+[^:\n]*|Chapter\s*\d+[^:\n]*|Hồi\s*\d+[^:\n]*)',
      caseSensitive: false,
    );

    final matches = chapterRegex.allMatches(fullText).toList();
    if (matches.isEmpty) {
      setState(() {
        _parsedChapters = [(title: 'Chuong 1: Toan van', content: fullText)];
        _scanResultText = '✅ Đã nạp 1 chương hoàn chỉnh (${fullText.split(RegExp(r'\s+')).length} từ).';
      });
      return;
    }

    final chapters = <({String title, String content})>[];
    for (var i = 0; i < matches.length; i++) {
      final title = matches[i].group(1)!.trim();
      final start = matches[i].end;
      final end = (i + 1 < matches.length) ? matches[i + 1].start : fullText.length;
      final content = fullText.substring(start, end).trim();
      chapters.add((title: title, content: content));
    }

    setState(() {
      _parsedChapters = chapters;
      _scanResultText = '✅ Đã tự động bẻ tách thành công ${chapters.length} chương riêng biệt!';
    });
  }

  /// Tự động quét Manga từ thư mục ảnh
  Future<void> _scanMangaDirectory() async {
    setState(() {
      _isScanning = true;
      _scanResultText = 'Đang quét cấu trúc thư mục Manga...';
      _parsedChapters = [];
    });

    try {
      final inputPath = _mangaPathCtrl.text.trim();
      final dir = Directory(inputPath);

      if (!await dir.exists()) {
        setState(() {
          _scanResultText = '⚠️ Thư mục không tồn tại: $inputPath';
        });
        return;
      }

      final subDirs = dir.listSync().whereType<Directory>().toList();
      subDirs.sort((a, b) => a.path.compareTo(b.path));

      if (subDirs.isEmpty) {
        setState(() {
          _scanResultText = '⚠️ Không tìm thấy thư mục Chapter con nào trong: $inputPath';
        });
        return;
      }

      final chapters = <({String title, String content})>[];
      int totalImages = 0;

      for (var i = 0; i < subDirs.length; i++) {
        final chapterDir = subDirs[i];
        final folderName = chapterDir.uri.pathSegments.where((s) => s.isNotEmpty).last;

        final imageFiles = chapterDir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.jpg') || f.path.endsWith('.png') || f.path.endsWith('.webp'))
            .toList();

        imageFiles.sort((a, b) => a.path.compareTo(b.path));
        totalImages += imageFiles.length;

        final imgTags = imageFiles.map((f) {
          final normPath = f.path.replaceAll(r'\', '/');
          return '[img]file:///$normPath[/img]';
        }).join('\n\n');

        chapters.add((
          title: '$folderName (${imageFiles.length} trang)',
          content: imgTags,
        ));
      }

      setState(() {
        _parsedChapters = chapters;
        _scanResultText = '✅ Đã phát hiện ${chapters.length} Chapter Manga (Tổng cộng $totalImages trang ảnh sắc nét)!';
      });
    } catch (e) {
      setState(() {
        _scanResultText = '❌ Lỗi quét Manga: $e';
      });
    } finally {
      setState(() => _isScanning = false);
    }
  }

  /// Thực hiện lưu truyện lên Database (cả cục bộ lẫn Supabase nếu gửi duyệt)
  Future<void> _saveAndImport() async {
    if (_parsedChapters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng quét hoặc nạp nội dung chương trước khi lưu!')),
      );
      return;
    }

    final isManga = _tabIndex == 1;
    final title = (isManga ? _mangaTitleCtrl.text : _textTitleCtrl.text).trim();
    final author = (isManga ? _mangaAuthorCtrl.text : _textAuthorCtrl.text).trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập Tên truyện!')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final lib = context.read<LibraryProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);

    setState(() => _isScanning = true);

    try {
      final user = auth.currentUser;
      final type = isManga ? NovelType.comic : NovelType.novel;
      final genres = isManga ? ['Action', 'Manga', 'Fantasy'] : ['Tien hiep', 'He thong', 'Huyen huyen'];

      Novel createdNovel;

      if (_submitToCommunity) {
        // Gửi lên Supabase Cloud để Admin duyệt
        createdNovel = await SupabaseDatabase.instance.insertCustomNovel(
          title: title,
          author: author.isNotEmpty ? author : user.displayName,
          description: isManga
              ? 'Tac pham truyen tranh Manga duoc nap boi doc gia ${user.displayName}.'
              : 'Tac pham truyen chu duoc nap boi doc gia ${user.displayName}.',
          status: NovelStatus.ongoing,
          type: type,
          genres: genres,
          chapterTitles: _parsedChapters.map((c) => c.title).toList(),
          chapterContents: _parsedChapters.map((c) => c.content).toList(),
          moderationStatus: ModerationStatus.pending,
          ownerId: user.id,
        );
      } else {
        // Lưu cục bộ vào SQLite để đọc riêng không cần ai duyệt
        createdNovel = await AppDatabase.instance.insertCustomNovel(
          title: title,
          author: author.isNotEmpty ? author : user.displayName,
          description: isManga
              ? 'Tac pham truyen tranh Manga nap cuc bo.'
              : 'Tac pham truyen chu nap cuc bo.',
          status: NovelStatus.ongoing,
          type: type,
          genres: genres,
          chapters: _parsedChapters,
          moderationStatus: ModerationStatus.approved,
          ownerId: user.id,
        );
      }

      // Thêm vào Tủ sách cá nhân
      await lib.setCategory(createdNovel.id, LibraryCategory.reading);

      nav.pop();
      widget.onImportDone?.call();

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            _submitToCommunity
                ? '📨 Đã nạp thành công ${_parsedChapters.length} chương và gửi vào Hàng chờ duyệt của Admin!'
                : '🎉 Đã nạp thành công ${_parsedChapters.length} chương vào Tủ sách! Bạn có thể đọc ngay lập tức.',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Lỗi nạp truyện: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, scrollCtrl) => ListView(
        controller: scrollCtrl,
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_stories, color: cs.primary, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bộ Nạp Truyện Thông Minh (Auto Importer)',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Text(
                      'Tự động bẻ tách chương từ file TXT hoặc quét Manga từ thư mục ảnh',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(
                value: 0,
                icon: Icon(Icons.menu_book),
                label: Text('Truyện Chữ (TXT/Folder)'),
              ),
              ButtonSegment(
                value: 1,
                icon: Icon(Icons.photo_library_outlined),
                label: Text('Truyện Tranh (Manga)'),
              ),
            ],
            selected: {_tabIndex},
            onSelectionChanged: (val) {
              setState(() {
                _tabIndex = val.first;
                _parsedChapters = [];
                _scanResultText = '';
              });
            },
          ),
          const SizedBox(height: 16),

          if (_tabIndex == 0) ...[
            // Giao diện nạp Truyện Chữ
            TextField(
              controller: _textTitleCtrl,
              decoration: const InputDecoration(
                labelText: 'Tên truyện chữ',
                hintText: 'Ví dụ: Moi Ngay Tinh Bao',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textAuthorCtrl,
              decoration: const InputDecoration(
                labelText: 'Tác giả',
                hintText: 'Ví dụ: Lieu Thanh',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textPathCtrl,
              decoration: InputDecoration(
                labelText: 'Đường dẫn File .txt hoặc Thư mục chương trên máy',
                hintText: r'Ví dụ: e:\file down truyện\Mỗi Ngày Tình Báo...\Cac_Chuong',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: _scanTextNovel,
                  tooltip: 'Quét nội dung',
                ),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('Điền nhanh: Mỗi Ngày Tình Báo (20 chương)'),
                  onPressed: () {
                    setState(() {
                      _textTitleCtrl.text = 'Moi Ngay Tinh Bao - Tu Ran Nuoc Den Kinh Ha Long Vuong';
                      _textAuthorCtrl.text = 'Lieu Thanh';
                      _textPathCtrl.text = r'e:\file down truyện\Mỗi Ngày Tình Báo - Từ Rắn Nước Đến Kính Hà Long Vương\Cac_Chuong';
                    });
                    _scanTextNovel();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Hoặc dán văn bản chứa nhiều chương tại đây:'),
            const SizedBox(height: 6),
            TextField(
              controller: _textPasteCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Dán toàn văn truyện vào đây (Hệ thống tự động phát hiện "Chương 1", "Chương 2"... để bẻ tách)...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: _isScanning ? null : _scanTextNovel,
              icon: _isScanning
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.auto_awesome),
              label: const Text('Phân tích & Tự động tách chương'),
            ),
          ] else ...[
            // Giao diện nạp Truyện Tranh (Manga)
            TextField(
              controller: _mangaTitleCtrl,
              decoration: const InputDecoration(
                labelText: 'Tên truyện Manga',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _mangaAuthorCtrl,
              decoration: const InputDecoration(
                labelText: 'Tác giả Manga',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _mangaPathCtrl,
              decoration: InputDecoration(
                labelText: 'Đường dẫn thư mục truyện Manga',
                hintText: r'Ví dụ: e:\file down truyện\Độc Chiến Đế Vương',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: _scanMangaDirectory,
                  tooltip: 'Quét thư mục Manga',
                ),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('Điền nhanh: Độc Chiến Đế Vương (10 Chapter)'),
                  onPressed: () {
                    setState(() {
                      _mangaTitleCtrl.text = 'Doc Chien De Vuong';
                      _mangaAuthorCtrl.text = 'Dang Cap Manga';
                      _mangaPathCtrl.text = r'e:\file down truyện\Độc Chiến Đế Vương';
                    });
                    _scanMangaDirectory();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: _isScanning ? null : _scanMangaDirectory,
              icon: _isScanning
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.auto_awesome),
              label: const Text('Quét toàn bộ Chapter & Trang ảnh Manga'),
            ),
          ],

          if (_scanResultText.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _parsedChapters.isNotEmpty
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _scanResultText,
                style: TextStyle(
                  color: _parsedChapters.isNotEmpty ? Colors.green.shade800 : Colors.orange.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],

          if (_parsedChapters.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Danh sách chương đã chuẩn bị nạp (${_parsedChapters.length} chương):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Container(
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: _parsedChapters.length,
                itemBuilder: (ctx, idx) => ListTile(
                  dense: true,
                  leading: Text('#${idx + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  title: Text(_parsedChapters[idx].title),
                  subtitle: Text(
                    _tabIndex == 1
                        ? 'Truyện tranh ảnh'
                        : '${_parsedChapters[idx].content.split(RegExp(r'\s+')).length} từ',
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),
          Card(
            child: SwitchListTile(
              value: _submitToCommunity,
              title: const Text('Gửi duyệt lên cộng đồng (Xuất bản)'),
              subtitle: Text(
                _submitToCommunity
                    ? 'Tác phẩm sẽ chuyển vào Hàng chờ duyệt của Admin để xuất bản công khai.'
                    : 'Tác phẩm chỉ lưu vào Tủ sách cá nhân trên máy của bạn để đọc riêng (Không cần duyệt).',
              ),
              onChanged: (v) => setState(() => _submitToCommunity = v),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: (_parsedChapters.isEmpty || _isScanning) ? null : _saveAndImport,
            icon: _isScanning
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.check_circle_outline),
            label: Text(
              _submitToCommunity
                  ? 'Gửi duyệt ${_parsedChapters.length} chương lên Admin'
                  : 'Nạp ${_parsedChapters.length} chương vào Tủ sách để đọc ngay',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
