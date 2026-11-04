import 'dart:typed_data';

Future<Uint8List> readBackupImage(String source, int maxBytes) async {
  throw StateError(
    'Không thể đọc ảnh liên kết trên trình duyệt: $source. Hãy sao lưu trên máy đang giữ thư mục ảnh.',
  );
}
