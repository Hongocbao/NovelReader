import 'dart:io';
import 'dart:typed_data';

Future<Uint8List> readBackupImage(String source, int maxBytes) async {
  final file = source.startsWith('file:')
      ? File.fromUri(Uri.parse(source))
      : File(source);
  final bytes = BytesBuilder(copy: false);
  await for (final chunk in file.openRead()) {
    if (bytes.length + chunk.length > maxBytes) {
      throw StateError('Ảnh vượt dung lượng sao lưu cho phép: $source');
    }
    bytes.add(chunk);
  }
  if (bytes.isEmpty) throw StateError('Ảnh không có dữ liệu: $source');
  return bytes.takeBytes();
}
