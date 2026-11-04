import 'dart:convert';

import 'backup_image_reader.dart';

/// Mỗi lần xuất có bộ đếm riêng; không sửa nội dung trong database gốc.
class PortableBackupImages {
  PortableBackupImages({
    this.maxImageBytes = 20 * 1024 * 1024,
    this.maxTotalBytes = 200 * 1024 * 1024,
  });
  final int maxImageBytes;
  final int maxTotalBytes;
  int _total = 0;
  final _images = <String, ({String uri, int size})>{};

  Future<String> image(String source) async {
    final path = source.trim();
    if (path.isEmpty ||
        path.startsWith('data:') ||
        path.startsWith('https://') ||
        path.startsWith('http://')) {
      return source;
    }
    if (path.startsWith('blob:') || path.startsWith('content:')) {
      throw StateError('Ảnh chưa có nội dung để sao lưu: $path');
    }
    var saved = _images[path];
    if (saved == null) {
      final bytes = await readBackupImage(path, maxImageBytes);
      final extension = path.split('.').last.toLowerCase();
      final mime = switch (extension) {
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'webp' => 'image/webp',
        'gif' => 'image/gif',
        'bmp' => 'image/bmp',
        'avif' => 'image/avif',
        _ => throw StateError('Định dạng ảnh không được hỗ trợ: $path'),
      };
      saved = (
        uri: 'data:$mime;base64,${base64Encode(bytes)}',
        size: bytes.length,
      );
      _images[path] = saved;
    }
    _total += saved.size;
    if (_total > maxTotalBytes) {
      throw StateError(
        'Tổng ảnh liên kết vượt 200 MB. Hãy chia nhỏ thư viện trước khi sao lưu.',
      );
    }
    return saved.uri;
  }

  Future<String> content(String text) async {
    final result = StringBuffer();
    var cursor = 0;
    for (final match in RegExp(
      r'\[img\]([^\r\n]*?)\[/img\]',
    ).allMatches(text)) {
      result.write(text.substring(cursor, match.start));
      result.write('[img]${await image(match.group(1)!)}[/img]');
      cursor = match.end;
    }
    result.write(text.substring(cursor));
    return result.toString();
  }
}
