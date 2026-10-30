import 'package:intl/intl.dart';

import 'constants.dart';

/// Các hàm định dạng hiển thị: ngày, số chương, lượt đọc, dung lượng.
class Format {
  Format._();

  static final DateFormat _date = DateFormat('dd/MM/yyyy');
  static final DateFormat _dateTime = DateFormat('HH:mm dd/MM/yyyy');
  static final NumberFormat _decimal = NumberFormat('#,##0.#', 'en_US');

  /// Ngày dạng dd/MM/yyyy.
  static String date(DateTime d) => _date.format(d.toLocal());

  /// Ngày giờ dạng HH:mm dd/MM/yyyy.
  static String dateTime(DateTime d) => _dateTime.format(d.toLocal());

  /// Thời gian tương đối: "vừa xong", "5 phút trước", "3 ngày trước"...
  static String relative(DateTime d, {DateTime? now}) {
    final diff = (now ?? DateTime.now()).difference(d);
    if (diff.isNegative || diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inHours < 1) return '${diff.inMinutes} phút trước';
    if (diff.inDays < 1) return '${diff.inHours} giờ trước';
    if (diff.inDays < 30) return '${diff.inDays} ngày trước';
    return date(d);
  }

  /// Số chương: "8 chương".
  static String chapterCount(int n) => '$n chương';

  /// Tiến độ đọc: "Chương 3/10".
  static String progress(int current, int total) => 'Chương $current/$total';

  /// Lượt đọc rút gọn: 950, 1,2K, 3,4Tr.
  static String views(int n) {
    if (n >= 1000000) {
      return '${_vi(_decimal.format(n / 1000000))}Tr';
    }
    if (n >= 1000) return '${_vi(_decimal.format(n / 1000))}K';
    return '$n';
  }

  /// Dung lượng: B, KB, MB.
  static String bytes(int b) {
    if (b < 1024) return '$b B';
    if (b < 1024 * 1024) return '${_vi(_decimal.format(b / 1024))} KB';
    return '${_vi(_decimal.format(b / (1024 * 1024)))} MB';
  }

  /// Điểm đánh giá: 4.7 -> "4,7".
  static String rating(double r) => r.toStringAsFixed(1).replaceAll('.', ',');

  /// Phần trăm: 0.42 -> "42%".
  static String percent(double v) => '${(v.clamp(0, 1) * 100).round()}%';

  /// Tên trạng thái truyện.
  static String status(String s) => s == NovelStatus.completed
      ? AppStrings.statusCompleted
      : AppStrings.statusOngoing;

  /// Tên loại truyện.
  static String type(String t) {
    if (t == NovelType.comic) return AppStrings.typeComic;
    if (t == NovelType.lightNovel) return AppStrings.typeLightNovel;
    return AppStrings.typeNovel;
  }

  /// Tên danh mục tủ sách.
  static String category(String c) {
    switch (c) {
      case LibraryCategory.want:
        return AppStrings.libraryWant;
      case LibraryCategory.finished:
        return AppStrings.libraryFinished;
      default:
        return AppStrings.libraryReading;
    }
  }

  // Đổi dấu thập phân sang kiểu Việt Nam (dấu phẩy).
  static String _vi(String s) => s.replaceAll('.', ',');

  static const String _withMarks =
      'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ';
  static const String _withoutMarks =
      'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';

  /// Chuẩn hóa chuỗi để tìm kiếm: chữ thường, bỏ dấu tiếng Việt.
  /// Ví dụ: "Kiếm Đạo" -> "kiem dao".
  static String normalize(String input) {
    final lower = input.toLowerCase().trim();
    final buf = StringBuffer();
    for (final rune in lower.runes) {
      final ch = String.fromCharCode(rune);
      final i = _withMarks.indexOf(ch);
      buf.write(i >= 0 ? _withoutMarks[i] : ch);
    }
    return buf.toString();
  }
}
