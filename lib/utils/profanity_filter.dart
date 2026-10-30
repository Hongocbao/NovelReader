/// Bộ lọc từ ngữ vi phạm trong bình luận và nội dung đăng tải.
class ProfanityFilter {
  ProfanityFilter._();

  /// Kiểm tra chuỗi [text] có chứa từ nằm trong danh sách [bannedWords] hay không.
  static bool containsProfanity(String text, Iterable<String> bannedWords) {
    final lower = text.toLowerCase();
    for (final raw in bannedWords) {
      final word = raw.trim().toLowerCase();
      if (word.isEmpty) continue;
      if (lower.contains(word)) return true;
    }
    return false;
  }

  /// Thay thế mọi từ cấm xuất hiện trong [text] bằng chuỗi `***`.
  static String sanitize(String text, Iterable<String> bannedWords) {
    var result = text;
    for (final raw in bannedWords) {
      final word = raw.trim();
      if (word.isEmpty) continue;
      final reg = RegExp(RegExp.escape(word), caseSensitive: false);
      result = result.replaceAll(reg, '***');
    }
    return result;
  }
}
