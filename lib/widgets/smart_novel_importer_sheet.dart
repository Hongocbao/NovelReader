import 'dart:convert';
import 'dart:io';
import 'dart:typed_data' show BytesBuilder;

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
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
  State<SmartNovelImporterSheet> createState() =>
      _SmartNovelImporterSheetState();
}

class _SmartNovelImporterSheetState extends State<SmartNovelImporterSheet> {
  int _tabIndex = 0; // 0: Truyện chữ, 1: Manga

  // Controllers cho Truyện chữ
  final _textTitleCtrl = TextEditingController();
  final _textAuthorCtrl = TextEditingController();
  final _textPasteCtrl = TextEditingController();
  List<PlatformFile> _selectedTextFiles = [];

  // Controllers cho Truyện tranh Manga
  final _mangaTitleCtrl = TextEditingController();
  final _mangaAuthorCtrl = TextEditingController();

  bool _isScanning = false;
  bool _submitToCommunity = false;

  /// Truyện nhập từ thư mục chỉ liên kết tới ảnh trên máy hiện tại,
  /// không thể gửi lên cộng đồng.
  bool _folderLinkedImport = false;
  String _scanResultText = '';
  List<({String title, String content})> _parsedChapters = [];
  String? _communitySubmissionId;
  int? _communitySubmissionFingerprint;

  String _requestIdForCommunitySubmission(String title, String author) {
    final fingerprint = Object.hashAll([
      title,
      author,
      for (final chapter in _parsedChapters)
        Object.hash(chapter.title, chapter.content),
    ]);
    if (_communitySubmissionId == null ||
        _communitySubmissionFingerprint != fingerprint) {
      _communitySubmissionId = SupabaseDatabase.newImportRequestId();
      _communitySubmissionFingerprint = fingerprint;
    }
    return _communitySubmissionId!;
  }

  @override
  void dispose() {
    _textTitleCtrl.dispose();
    _textAuthorCtrl.dispose();
    _textPasteCtrl.dispose();
    _mangaTitleCtrl.dispose();
    _mangaAuthorCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTextFiles() async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['txt'],
      );
      if (!mounted || files.isEmpty) return;

      final sortedFiles = [...files]
        ..sort(
          (a, b) => _naturalFileKey(a.name).compareTo(_naturalFileKey(b.name)),
        );
      const maxTextFileBytes = 32 * 1024 * 1024;
      const maxTotalTextBytes = 128 * 1024 * 1024;
      var totalBytes = 0;
      for (final file in sortedFiles) {
        final fileBytes = file.lengthSync();
        if (fileBytes != null && fileBytes > maxTextFileBytes) {
          throw StateError('File ${file.name} vượt giới hạn 32 MB.');
        }
        totalBytes += fileBytes ?? 0;
      }
      if (totalBytes > maxTotalTextBytes) {
        throw StateError('Tổng dung lượng các file TXT vượt giới hạn 128 MB.');
      }
      setState(() {
        _selectedTextFiles = sortedFiles;
        _scanResultText = '';
        _parsedChapters = [];
      });
      await _scanTextNovel();
    } catch (e) {
      if (!mounted) return;
      setState(() => _scanResultText = '❌ Không thể mở file TXT: $e');
    }
  }

  String _naturalFileKey(String name) => name.toLowerCase().replaceAllMapped(
    RegExp(r'\d+'),
    (match) => match.group(0)!.padLeft(12, '0'),
  );

  /// Đọc qua luồng byte của FilePicker trên cả web lẫn native. Giới hạn được
  /// kiểm tra trong lúc đọc, kể cả khi picker không biết trước dung lượng.
  Future<Uint8List> _readPickedBytes(
    PlatformFile file, {
    required int maxBytes,
    required String kind,
  }) async {
    final expectedLength = file.lengthSync();
    if (expectedLength != null && expectedLength > maxBytes) {
      throw StateError('${file.name} vượt giới hạn dung lượng $kind.');
    }
    final builder = BytesBuilder(copy: false);
    await for (final chunk in file.readAsByteStream()) {
      if (builder.length + chunk.length > maxBytes) {
        throw StateError('${file.name} vượt giới hạn dung lượng $kind.');
      }
      builder.add(chunk);
    }
    final bytes = builder.takeBytes();
    if (expectedLength != null && bytes.length != expectedLength) {
      throw StateError('Không đọc đủ dữ liệu của ${file.name}.');
    }
    return bytes;
  }

  String _decodeText(List<int> bytes) {
    if (bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xFE) {
      return String.fromCharCodes([
        for (var i = 2; i + 1 < bytes.length; i += 2)
          bytes[i] | (bytes[i + 1] << 8),
      ]);
    }
    if (bytes.length >= 2 && bytes[0] == 0xFE && bytes[1] == 0xFF) {
      return String.fromCharCodes([
        for (var i = 2; i + 1 < bytes.length; i += 2)
          (bytes[i] << 8) | bytes[i + 1],
      ]);
    }
    final utf8Bytes =
        bytes.length >= 3 &&
            bytes[0] == 0xEF &&
            bytes[1] == 0xBB &&
            bytes[2] == 0xBF
        ? bytes.sublist(3)
        : bytes;
    return utf8
        .decode(utf8Bytes, allowMalformed: true)
        .replaceAll('\uFEFF', '');
  }

  ({String? title, String? author, String body}) _extractMetadata(String text) {
    String? title;
    String? author;
    final body = <String>[];
    final titleLine = RegExp(
      r'^(?:tên truyện|ten truyen|tên tác phẩm|ten tac pham|title|novel)\s*[:：]\s*(.+)$',
      caseSensitive: false,
    );
    final authorLine = RegExp(
      r'^(?:tác giả|tac gia|author|writer)\s*[:：]\s*(.+)$',
      caseSensitive: false,
    );

    for (final line in text.split(RegExp(r'\r?\n'))) {
      final trimmed = line.trim();
      final titleMatch = titleLine.firstMatch(trimmed);
      final authorMatch = authorLine.firstMatch(trimmed);
      if (titleMatch != null) {
        title ??= titleMatch.group(1)?.trim();
      } else if (authorMatch != null) {
        author ??= authorMatch.group(1)?.trim();
      } else {
        body.add(line);
      }
    }
    return (title: title, author: author, body: body.join('\n').trim());
  }

  String _titleFromFileName(String name) {
    var title = name.replaceFirst(RegExp(r'\.txt$', caseSensitive: false), '');
    title = title.replaceFirst(
      RegExp(
        r'\s*[-_ ]+(?:chương|chuong|chapter|ch)\s*\d+.*$',
        caseSensitive: false,
      ),
      '',
    );
    return title.replaceAll(RegExp(r'[_]+'), ' ').trim();
  }

  /// Đọc file đã chọn bằng bytes nên không phụ thuộc đường dẫn cục bộ của trình duyệt.
  Future<void> _scanTextNovel() async {
    setState(() {
      _isScanning = true;
      _scanResultText = 'Đang phân tích cấu trúc chương...';
      _parsedChapters = [];
    });

    try {
      final pasteText = _textPasteCtrl.text.trim();

      if (_selectedTextFiles.isNotEmpty) {
        if (_selectedTextFiles.length == 1) {
          final file = _selectedTextFiles.single;
          final bytes = await _readPickedBytes(
            file,
            maxBytes: 32 * 1024 * 1024,
            kind: '32 MB',
          );
          if (!mounted) return;
          final metadata = _extractMetadata(_decodeText(bytes));
          if (_textTitleCtrl.text.trim().isEmpty) {
            _textTitleCtrl.text = metadata.title?.isNotEmpty == true
                ? metadata.title!
                : _titleFromFileName(file.name);
          }
          if (_textAuthorCtrl.text.trim().isEmpty &&
              metadata.author?.isNotEmpty == true) {
            _textAuthorCtrl.text = metadata.author!;
          }
          _splitFullTextToChapters(metadata.body);
          return;
        }

        final chapters = <({String title, String content})>[];
        String? detectedTitle;
        String? detectedAuthor;
        var totalBytes = 0;
        for (final file in _selectedTextFiles) {
          final bytes = await _readPickedBytes(
            file,
            maxBytes: 32 * 1024 * 1024,
            kind: '32 MB',
          );
          if (!mounted) return;
          totalBytes += bytes.length;
          if (totalBytes > 128 * 1024 * 1024) {
            throw StateError(
              'Tổng dung lượng các file TXT vượt giới hạn 128 MB.',
            );
          }
          final metadata = _extractMetadata(_decodeText(bytes));
          detectedTitle ??= metadata.title;
          detectedAuthor ??= metadata.author;
          final content = metadata.body;
          if (content.isEmpty) continue;
          final firstLine = content
              .split(RegExp(r'\r?\n'))
              .firstWhere((line) => line.trim().isNotEmpty, orElse: () => '');
          final title =
              RegExp(
                r'^(?:chương|chuong|chapter|hồi)\s*\d+',
                caseSensitive: false,
              ).hasMatch(firstLine.trim())
              ? firstLine.trim()
              : _titleFromFileName(file.name).isNotEmpty
              ? _titleFromFileName(file.name)
              : 'Chương ${chapters.length + 1}';
          chapters.add((title: title, content: content));
        }
        if (_textTitleCtrl.text.trim().isEmpty) {
          _textTitleCtrl.text =
              detectedTitle ??
              _titleFromFileName(_selectedTextFiles.first.name);
        }
        if (_textAuthorCtrl.text.trim().isEmpty &&
            detectedAuthor?.isNotEmpty == true) {
          _textAuthorCtrl.text = detectedAuthor!;
        }
        setState(() {
          _parsedChapters = chapters;
          _scanResultText = chapters.isEmpty
              ? '⚠️ Không tìm thấy nội dung trong các file TXT đã chọn.'
              : '✅ Đã sắp xếp ${chapters.length} file thành chương theo thứ tự tên/số.';
        });
        return;
      }

      if (pasteText.isNotEmpty) {
        // Trường hợp 3: Dán trực tiếp văn bản nhiều chương
        _splitFullTextToChapters(pasteText);
        return;
      }

      setState(() {
        _scanResultText =
            '⚠️ Chọn file .txt hoặc dán nội dung truyện để bắt đầu.';
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _scanResultText = '❌ Lỗi đọc file: $e';
        });
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  /// Tự động bẻ/tách văn bản nhiều chương thành danh sách chương riêng biệt
  void _splitFullTextToChapters(String fullText) {
    final normalizedText = fullText.replaceAll('\r\n', '\n').trim();
    if (normalizedText.isEmpty) {
      setState(() {
        _parsedChapters = [];
        _scanResultText =
            '⚠️ File TXT đang trống hoặc không đọc được nội dung.';
      });
      return;
    }
    final chapterRegex = RegExp(
      r'^[ \t]*((?:chương|chuong|chapter|hồi)\s*\d+[^\r\n]*)',
      caseSensitive: false,
      multiLine: true,
    );

    final matches = chapterRegex.allMatches(normalizedText).toList();
    if (matches.isEmpty) {
      setState(() {
        _parsedChapters = [(title: 'Toàn văn', content: normalizedText)];
        _scanResultText =
            '✅ Không thấy tiêu đề chương; đã đưa toàn bộ file vào 1 chương (${normalizedText.split(RegExp(r'\s+')).length} từ).';
      });
      return;
    }

    final chapters = <({String title, String content})>[];
    final preface = normalizedText.substring(0, matches.first.start).trim();
    if (preface.isNotEmpty) {
      chapters.add((title: 'Mở đầu', content: preface));
    }
    for (var i = 0; i < matches.length; i++) {
      final title = matches[i].group(1)!.trim();
      final start = matches[i].end;
      final end = (i + 1 < matches.length)
          ? matches[i + 1].start
          : normalizedText.length;
      final content = normalizedText.substring(start, end).trim();
      chapters.add((title: title, content: content));
    }

    setState(() {
      _parsedChapters = chapters;
      _scanResultText =
          '✅ Đã tự động bẻ tách thành công ${chapters.length} chương riêng biệt!';
    });
  }

  static const Set<String> _comicImageExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
    '.gif',
    '.bmp',
    '.avif',
  };

  /// Liệt kê ảnh trong thư mục (đệ quy) và sắp xếp tự nhiên theo tên/số.
  Future<List<File>> _listComicImages(Directory dir) async {
    final files = <File>[];
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File &&
          _comicImageExtensions.contains(
            p.extension(entity.path).toLowerCase(),
          )) {
        files.add(entity);
      }
    }
    files.sort(
      (a, b) => _naturalFileKey(a.path).compareTo(_naturalFileKey(b.path)),
    );
    return files;
  }

  /// Nhập trực tiếp từ thư mục truyện tranh đã tải về máy (không cần nén ZIP).
  /// Mỗi thư mục con chứa ảnh trở thành một chương; ảnh được liên kết theo
  /// đường dẫn cục bộ nên không nhân đôi dung lượng lưu trữ.
  Future<void> _pickMangaFolder() async {
    if (kIsWeb) {
      setState(
        () => _scanResultText = 'Trình duyệt không cấp đường dẫn thư mục trên máy. Hãy nén truyện thành ZIP rồi chọn ZIP.',
      );
      return;
    }
    try {
      final rootPath = await FilePicker.getDirectoryPath(
        dialogTitle: 'Chọn thư mục truyện tranh',
      );
      if (!mounted || rootPath == null || rootPath.trim().isEmpty) return;

      setState(() {
        _isScanning = true;
        _scanResultText = 'Đang quét ảnh trong thư mục...';
        _parsedChapters = [];
      });

      final root = Directory(rootPath);
      if (!await root.exists()) {
        setState(() => _scanResultText = '⚠️ Thư mục không tồn tại: $rootPath');
        return;
      }

      final images = await _listComicImages(root);
      if (images.isEmpty) {
        setState(
          () => _scanResultText = '⚠️ Không tìm thấy ảnh JPG, PNG, WEBP, GIF, BMP trong thư mục này.',
        );
        return;
      }

      final grouped = <String, List<File>>{};
      for (final file in images) {
        grouped.putIfAbsent(p.dirname(file.path), () => []).add(file);
      }
      final folders = grouped.keys.toList()
        ..sort((a, b) => _naturalFileKey(a).compareTo(_naturalFileKey(b)));

      final chapters = <({String title, String content})>[];
      for (final folder in folders) {
        final relative = p.relative(folder, from: root.path);
        final folderTitle = relative == '.' || relative.isEmpty
            ? 'Chương 1'
            : relative.replaceAll('\\', '/');
        final pages = grouped[folder]!;
        final content = pages
            .map((f) => '[img]${f.path.replaceAll('\\', '/')}[/img]')
            .join('\n\n');
        chapters.add((
          title: '$folderTitle (${pages.length} trang)',
          content: content,
        ));
      }

      if (_mangaTitleCtrl.text.trim().isEmpty) {
        _mangaTitleCtrl.text = p.basename(root.path);
      }

      setState(() {
        _folderLinkedImport = true;
        _parsedChapters = chapters;
        _scanResultText =
            '✅ Đã nhận ${chapters.length} chương, ${images.length} trang ảnh. '
            'Mỗi thư mục con là một chương; đọc ở chế độ cuộn dọc liên tục. '
            'Ảnh liên kết từ thư mục gốc nên không tốn thêm dung lượng.';
      });
    } catch (e) {
      if (mounted) {
        setState(() => _scanResultText = '❌ Không quét được thư mục: $e');
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  /// Đọc một hoặc nhiều ZIP do người dùng chọn; mỗi thư mục chứa ảnh
  /// (hoặc mỗi ZIP nếu ảnh nằm ở gốc) sẽ thành một chương.
  Future<void> _pickMangaArchive() async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['zip', 'cbz'],
        dialogTitle: 'Chọn một hoặc nhiều ZIP/CBZ truyện tranh',
      );
      if (!mounted || files.isEmpty) return;
      final orderedFiles = [...files]
        ..sort(
          (a, b) => _naturalFileKey(a.name).compareTo(_naturalFileKey(b.name)),
        );
      setState(() {
        _isScanning = true;
        _scanResultText = 'Đang đọc ZIP và sắp xếp trang Manga...';
        _parsedChapters = [];
        _folderLinkedImport = false;
      });

      final chapters = <({String title, String content})>[];
      final usedTitles = <String>{};
      var totalImages = 0;
      var totalImageBytes = 0;
      var processedImages = 0;
      final maxImageBytes = kIsWeb ? 48 * 1024 * 1024 : 160 * 1024 * 1024;
      final maxArchiveBytes = kIsWeb ? 64 * 1024 * 1024 : 200 * 1024 * 1024;
      const maxImagePages = 2000;
      const maxArchiveEntries = 10000;

      for (var fileIndex = 0; fileIndex < orderedFiles.length; fileIndex++) {
        final file = orderedFiles[fileIndex];
        if (!mounted) return;
        setState(() {
          _scanResultText =
              'Đang đọc ZIP ${fileIndex + 1}/${orderedFiles.length}: ${file.name}';
        });
        // Let Flutter paint the progress state before the synchronous ZIP
        // decoder starts working on this archive.
        await Future<void>.delayed(Duration.zero);
        // Decode only the archive directory first. ArchiveFile content stays
        // lazy until readBytes(), allowing us to reject oversized page sets
        // before decompressing image payloads into memory.
        final archiveBytes = await _readPickedBytes(
          file,
          maxBytes: maxArchiveBytes,
          kind: '${maxArchiveBytes ~/ (1024 * 1024)} MB',
        );
        final archive = ZipDecoder().decodeStream(
          InputMemoryStream(archiveBytes),
          throwOnError: true,
        );
        if (archive.files.length > maxArchiveEntries) {
          throw StateError(
            'ZIP ${file.name} chứa quá nhiều mục (${archive.files.length}).',
          );
        }
        final imageEntries =
            archive.files.where((entry) {
              final path = entry.name.replaceAll('\\', '/');
              final lower = path.toLowerCase();
              final pathParts = lower.split('/');
              return entry.isFile &&
                  !entry.isSymbolicLink &&
                  entry.size > 0 &&
                  !pathParts.any(
                    (part) => part == '__macosx' || part.startsWith('.'),
                  ) &&
                  RegExp(r'\.(jpe?g|png|webp|gif|bmp|avif)$').hasMatch(lower);
            }).toList()..sort(
              (a, b) =>
                  _naturalFileKey(a.name).compareTo(_naturalFileKey(b.name)),
            );
        if (imageEntries.isEmpty) continue;
        if (totalImages + imageEntries.length > maxImagePages) {
          throw StateError(
            'Tổng số ảnh vượt giới hạn $maxImagePages trang mỗi lần nạp. Hãy chia truyện thành các ZIP nhỏ hơn.',
          );
        }
        for (final entry in imageEntries) {
          totalImageBytes += entry.size;
          if (totalImageBytes > maxImageBytes) {
            final limitMb = maxImageBytes ~/ (1024 * 1024);
            throw StateError(
              'Tổng dung lượng ảnh giải nén vượt $limitMb MB. Hãy chia truyện thành nhiều lần nạp.',
            );
          }
        }
        totalImages += imageEntries.length;

        final grouped = <String, List<ArchiveFile>>{};
        for (final entry in imageEntries) {
          final path = entry.name.replaceAll('\\', '/');
          final slash = path.lastIndexOf('/');
          final folder = slash < 0 ? '' : path.substring(0, slash);
          grouped.putIfAbsent(folder, () => []).add(entry);
        }
        final folders = grouped.keys.toList()
          ..sort((a, b) => _naturalFileKey(a).compareTo(_naturalFileKey(b)));
        final archiveBaseName = file.name.replaceFirst(
          RegExp(r'\.(?:zip|cbz)$', caseSensitive: false),
          '',
        );

        for (final folder in folders) {
          final entries = grouped[folder]!;
          final rawTitle = folder.isEmpty
              ? archiveBaseName
              : folder.split('/').last;
          var title = rawTitle.trim().isEmpty
              ? archiveBaseName
              : rawTitle.trim();
          var uniqueTitle = title;
          var duplicate = 2;
          while (!usedTitles.add(uniqueTitle.toLowerCase())) {
            uniqueTitle = '$title (${duplicate++})';
          }
          final tags = <String>[];
          for (final entry in entries) {
            final bytes = entry.readBytes();
            if (bytes == null || bytes.length != entry.size) {
              throw StateError('Ảnh ${entry.name} trong ZIP bị thiếu dữ liệu.');
            }
            final expectedCrc = entry.crc32;
            if (expectedCrc != null && getCrc32(bytes) != expectedCrc) {
              throw StateError('Ảnh ${entry.name} trong ZIP bị lỗi CRC.');
            }
            final ext = entry.name.split('.').last.toLowerCase();
            final mime = switch (ext) {
              'jpg' || 'jpeg' => 'image/jpeg',
              'png' => 'image/png',
              'webp' => 'image/webp',
              'gif' => 'image/gif',
              'bmp' => 'image/bmp',
              'avif' => 'image/avif',
              _ => 'application/octet-stream',
            };
            tags.add('[img]data:$mime;base64,${base64Encode(bytes)}[/img]');
            processedImages++;
            if (processedImages % 16 == 0) {
              if (mounted) {
                setState(() {
                  _scanResultText =
                      'Đang xử lý trang Manga $processedImages/$totalImages...';
                });
              }
              await Future<void>.delayed(Duration.zero);
              if (!mounted) return;
            }
          }
          final content = tags.join('\n\n');
          chapters.add((title: uniqueTitle, content: content));
        }
      }

      if (chapters.isEmpty) {
        setState(
          () => _scanResultText =
              '⚠️ ZIP/CBZ không có ảnh JPG, PNG, WEBP, GIF, BMP hoặc AVIF.',
        );
        return;
      }
      if (_mangaTitleCtrl.text.trim().isEmpty) {
        final firstBaseName = orderedFiles.first.name.replaceFirst(
          RegExp(r'\.(?:zip|cbz)$', caseSensitive: false),
          '',
        );
        final withoutChapter = firstBaseName
            .replaceFirst(
              RegExp(
                r'\s*[-_ ]+(?:chapter|chương|chuong|ch)\s*\d+.*$',
                caseSensitive: false,
              ),
              '',
            )
            .trim();
        _mangaTitleCtrl.text = withoutChapter.isEmpty
            ? firstBaseName
            : withoutChapter;
      }
      setState(() {
        _parsedChapters = chapters;
        _scanResultText =
            '✅ Đã nhận ${chapters.length} chương, $totalImages trang ảnh từ '
            '${orderedFiles.length} file ZIP. Mỗi thư mục ảnh là một chương; '
            'chương được sắp theo tên/số.';
      });
    } catch (e) {
      if (mounted) {
        setState(() => _scanResultText = '❌ Không đọc được ZIP Manga: $e');
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  /// Thực hiện lưu truyện lên Database (cả cục bộ lẫn Supabase nếu gửi duyệt)
  Future<void> _saveAndImport() async {
    if (_parsedChapters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng quét hoặc nạp nội dung chương trước khi lưu!',
          ),
        ),
      );
      return;
    }

    final isManga = _tabIndex == 1;
    final title = (isManga ? _mangaTitleCtrl.text : _textTitleCtrl.text).trim();
    final author = (isManga ? _mangaAuthorCtrl.text : _textAuthorCtrl.text)
        .trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập Tên truyện!')),
      );
      return;
    }

    final user = context.read<AuthProvider>().currentUser;
    if (_submitToCommunity && (user.isGuest || user.isBanned)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Đăng nhập bằng tài khoản đang hoạt động để gửi truyện lên cộng đồng.',
          ),
        ),
      );
      return;
    }

    if (_submitToCommunity && _folderLinkedImport) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Truyện nhập từ thư mục chỉ đọc được trên máy này. '
            'Hãy dùng ZIP nếu muốn gửi duyệt lên cộng đồng.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final containsEmbeddedImages =
        isManga &&
        _parsedChapters.any(
          (chapter) => chapter.content.contains('[img]data:image/'),
        );
    if (_submitToCommunity && containsEmbeddedImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ảnh trong ZIP đang được nhúng để lưu cục bộ. Muốn gửi duyệt, cần tải ảnh lên Supabase Storage trước.',
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    final lib = context.read<LibraryProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final communityRequestId = _submitToCommunity
        ? _requestIdForCommunitySubmission(title, author)
        : null;

    setState(() => _isScanning = true);

    try {
      final type = isManga ? NovelType.comic : NovelType.novel;
      final genres = isManga
          ? ['Hành động', 'Kỳ ảo', 'Phiêu lưu']
          : ['Tiên hiệp', 'Hệ thống', 'Huyền huyễn'];

      Novel createdNovel;

      if (_submitToCommunity) {
        // Gửi lên Supabase Cloud để Admin duyệt
        createdNovel = await SupabaseDatabase.instance.insertCustomNovel(
          title: title,
          author: author.isNotEmpty ? author : user.displayName,
          description: isManga
              ? 'Tác phẩm được nạp bởi độc giả ${user.displayName}.'
              : 'Tác phẩm truyện chữ được nạp bởi độc giả ${user.displayName}.',
          status: NovelStatus.ongoing,
          type: type,
          genres: genres,
          chapterTitles: _parsedChapters.map((c) => c.title).toList(),
          chapterContents: _parsedChapters.map((c) => c.content).toList(),
          requestId: communityRequestId!,
          moderationStatus: ModerationStatus.pending,
          ownerId: user.id,
        );
      } else {
        // Lưu cục bộ vào SQLite để đọc riêng không cần ai duyệt
        createdNovel = await AppDatabase.instance.insertCustomNovel(
          title: title,
          author: author.isNotEmpty ? author : user.displayName,
          description: isManga
              ? 'Tác phẩm nạp cục bộ trên thiết bị.'
              : 'Tác phẩm truyện chữ nạp cục bộ trên thiết bị.',
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

      if (!mounted) return;
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
        SnackBar(
          content: Text('Lỗi nạp truyện: $e'),
          backgroundColor: Colors.red,
        ),
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
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _tabIndex == 0
                          ? 'Chọn TXT để tự điền thông tin và tách chương.'
                          : 'Chọn thư mục hoặc ZIP chứa ảnh để tự tạo chương Manga.',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
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
                label: Text('Truyện Chữ (TXT)'),
              ),
              ButtonSegment(
                value: 1,
                icon: Icon(Icons.photo_library_outlined),
                label: Text('Truyện Tranh (Manga)'),
              ),
            ],
            selected: {_tabIndex},
            onSelectionChanged: _isScanning
                ? null
                : (val) {
                    setState(() {
                      _tabIndex = val.first;
                      _parsedChapters = [];
                      _scanResultText = '';
                      _folderLinkedImport = false;
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
            FilledButton.tonalIcon(
              onPressed: _isScanning ? null : _pickTextFiles,
              icon: const Icon(Icons.upload_file),
              label: Text(
                _selectedTextFiles.isEmpty
                    ? 'Chọn file .txt (có thể chọn nhiều chương)'
                    : 'Chọn lại file TXT (${_selectedTextFiles.length} file)',
              ),
            ),
            const SizedBox(height: 6),
            if (_selectedTextFiles.isNotEmpty)
              Text(
                _selectedTextFiles.map((file) => file.name).join('\n'),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 10),
            const Text('Hoặc dán văn bản truyện tại đây:'),
            const SizedBox(height: 6),
            TextField(
              controller: _textPasteCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Hệ thống sẽ tự phát hiện các dòng Chương 1, Chương 2... và tách chương.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: _isScanning ? null : _scanTextNovel,
              icon: _isScanning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
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
            if (!kIsWeb) ...[
              FilledButton.tonalIcon(
                onPressed: _isScanning ? null : _pickMangaFolder,
                icon: _isScanning
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.folder_open),
                label: const Text('Chọn thư mục truyện tranh trên máy'),
              ),
              const SizedBox(height: 6),
              const Text(
                'Trỏ tới thư mục đã tải, ví dụ: Độc Chiến Đế Vương/Chapter 01/001.jpg. Mỗi thư mục con là một chương; ảnh được liên kết tại chỗ và đọc ngay bằng chế độ cuộn dọc liên tục.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
            ],
            FilledButton.tonalIcon(
              onPressed: _isScanning ? null : _pickMangaArchive,
              icon: _isScanning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.folder_zip_outlined),
              label: const Text(
                'Chọn ZIP/CBZ truyện tranh (chọn được nhiều file)',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Nén thư mục thành ZIP/CBZ: ảnh được lưu cùng truyện để đọc trên thiết bị khác và có thể gửi duyệt lên cộng đồng.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
                  color: _parsedChapters.isNotEmpty
                      ? Colors.green.shade800
                      : Colors.orange.shade900,
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
                  leading: Text(
                    '#${idx + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
              onChanged: _isScanning
                  ? null
                  : (v) => setState(() => _submitToCommunity = v),
            ),
          ),
          if (_submitToCommunity && _tabIndex == 1)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Lưu ý: truyện tranh nhập từ máy nên TẮT mục này để lưu vào Tủ sách và đọc ngay. '
                'Gửi duyệt chỉ phù hợp khi ảnh đã được tải lên máy chủ.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: (_parsedChapters.isEmpty || _isScanning)
                ? null
                : _saveAndImport,
            icon: _isScanning
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
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
