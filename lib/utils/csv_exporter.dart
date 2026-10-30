/// Tiện ích xuất dữ liệu bảng ra định dạng CSV chuẩn (RFC 4180).
class CsvExporter {
  CsvExporter._();

  /// Chuyển danh sách bản ghi [rows] cùng tiêu đề cột [headers] thành chuỗi CSV.
  static String toCsv({
    required List<String> headers,
    required List<List<Object?>> rows,
  }) {
    final buffer = StringBuffer();
    buffer.writeln(headers.map(_escapeCell).join(','));
    for (final row in rows) {
      buffer.writeln(row.map(_escapeCell).join(','));
    }
    return buffer.toString();
  }

  static String _escapeCell(Object? value) {
    final text = (value ?? '').toString();
    if (text.contains(',') || text.contains('"') || text.contains('\n')) {
      final escaped = text.replaceAll('"', '""');
      return '"$escaped"';
    }
    return text;
  }
}
