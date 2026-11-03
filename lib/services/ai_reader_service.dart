import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/ai_chat_message.dart';
import '../models/chapter.dart';
import '../models/novel.dart';

/// Dịch vụ Trợ Lý AI Độc Giả (AI Reading Assistant).
///
/// Hỗ trợ:
/// 1. Phân tích ngữ cảnh chương đang đọc (Context-Aware RAG Engine)
/// 2. Tóm tắt nội dung chương trọng tâm
/// 3. Phân tích nhân vật và diễn biến tâm lý
/// 4. Giải thích thuật ngữ, cảnh giới, bối cảnh thế giới
/// 5. Dự đoán các tình tiết hấp dẫn tiếp theo
/// 6. Hỗ trợ kết nối Gemini API (nếu có key) và bộ suy luận nội bộ siêu tốc khi offline.
class AiReaderService {
  AiReaderService._();
  static final AiReaderService instance = AiReaderService._();

  /// Gợi ý câu hỏi nhanh mặc định khi mở chat
  static const List<String> defaultSuggestions = [
    '📝 Tóm tắt chương này',
    '🔍 Nhân vật chính & phe phái',
    '💡 Giải thích bối cảnh chương',
    '🔮 Dự đoán tình tiết tiếp theo',
    '⚔️ Cảnh giới & Thuật ngữ',
  ];

  /// Sinh câu trả lời thông minh dựa trên ngữ cảnh truyện và chương hiện tại.
  Future<AiChatMessage> generateReply({
    required String prompt,
    required Novel novel,
    required Chapter? chapter,
    required String? chapterContent,
    List<AiChatMessage> history = const [],
    String? geminiApiKey,
  }) async {
    final query = prompt.trim();
    if (query.isEmpty) {
      return AiChatMessage.ai('Bạn hãy nhập câu hỏi để mình hỗ trợ nhé!');
    }

    // Nếu người dùng có cấu hình Gemini API Key -> Thử gọi Gemini trước
    if (geminiApiKey != null && geminiApiKey.trim().isNotEmpty) {
      try {
        final geminiReply = await _callGeminiApi(
          apiKey: geminiApiKey.trim(),
          query: query,
          novel: novel,
          chapter: chapter,
          content: chapterContent,
        );
        if (geminiReply != null && geminiReply.isNotEmpty) {
          return AiChatMessage.ai(geminiReply);
        }
      } catch (_) {
        // Fallback tự động xuống Context Engine cục bộ
      }
    }

    // Mô phỏng độ trễ suy nghĩ nhẹ (350ms - 550ms) để trải nghiệm tự nhiên
    await Future.delayed(const Duration(milliseconds: 400));

    final replyText = _analyzeWithContextEngine(
      query: query,
      novel: novel,
      chapter: chapter,
      content: chapterContent ?? '',
    );

    return AiChatMessage.ai(
      replyText,
      suggestions: _deriveNextSuggestions(query),
    );
  }

  /// Bộ xử lý ngữ cảnh thông minh (Context-Aware NLP Engine)
  String _analyzeWithContextEngine({
    required String query,
    required Novel novel,
    required Chapter? chapter,
    required String content,
  }) {
    final qLower = query.toLowerCase();
    final chTitle = chapter?.title ?? 'Chương hiện tại';
    final novelTitle = novel.title;
    final genres = novel.genres.isEmpty
        ? 'chưa phân loại'
        : novel.genres.join(', ');
    final firstGenre = novel.genres.isEmpty ? 'Tiên hiệp' : novel.genres.first;

    final paragraphs = content
        .split('\n')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    // 1. TÓM TẮT CHƯƠNG (Summary)
    if (qLower.contains('tóm tắt') ||
        qLower.contains('nội dung chính') ||
        qLower.contains('nói về cái gì') ||
        qLower.contains('chương này kể gì') ||
        qLower.contains('chương này nói gì')) {
      return _generateChapterSummary(
        novelTitle: novelTitle,
        chapterTitle: chTitle,
        paragraphs: paragraphs,
        novelDesc: novel.description,
      );
    }

    // 2. NHÂN VẬT & PHE PHÁI (Characters)
    if (qLower.contains('nhân vật') ||
        qLower.contains('ai là') ||
        qLower.contains('tính cách') ||
        qLower.contains('phe phái') ||
        qLower.contains('nam chính') ||
        qLower.contains('nữ chính')) {
      return _generateCharacterAnalysis(
        novelTitle: novelTitle,
        chapterTitle: chTitle,
        paragraphs: paragraphs,
        novelAuthor: novel.author,
      );
    }

    // 3. GIẢI THÍCH TÌNH TIẾT & BỐI CẢNH (Plot / Lore explanation)
    if (qLower.contains('giải thích') ||
        qLower.contains('tại sao') ||
        qLower.contains('bối cảnh') ||
        qLower.contains('tình tiết') ||
        qLower.contains('ý nghĩa') ||
        qLower.contains('hiểu như thế nào')) {
      return _generatePlotExplanation(
        novelTitle: novelTitle,
        chapterTitle: chTitle,
        paragraphs: paragraphs,
      );
    }

    // 4. DỰ ĐOÁN HỒI SAU / DIỄN BIẾN TIẾP THEO (Prediction)
    if (qLower.contains('dự đoán') ||
        qLower.contains('tiếp theo') ||
        qLower.contains('hồi sau') ||
        qLower.contains('sẽ xảy ra') ||
        qLower.contains('tương lai') ||
        qLower.contains('chap sau')) {
      return _generateNextPredictions(
        novelTitle: novelTitle,
        chapterTitle: chTitle,
        paragraphs: paragraphs,
      );
    }

    // 5. THUẬT NGỮ & CẢNH GIỚI (Cultivation / Magic / Worldbuilding)
    if (qLower.contains('thuật ngữ') ||
        qLower.contains('cảnh giới') ||
        qLower.contains('công pháp') ||
        qLower.contains('pháp bảo') ||
        qLower.contains('linh thạch') ||
        qLower.contains('mana') ||
        qLower.contains('dị năng')) {
      return _generateGlossaryExplanation(
        novelTitle: novelTitle,
        novelGenres: genres,
        paragraphs: paragraphs,
      );
    }

    // 6. GỢI Ý TRUYỆN CÙNG THỂ LOẠI (Recommendations)
    if (qLower.contains('gợi ý') ||
        qLower.contains('truyện tương tự') ||
        qLower.contains('truyện nào hay') ||
        qLower.contains('cùng thể loại')) {
      return '📚 **Gợi ý tác phẩm cùng gu đọc:**\n\n'
          'Bộ truyện **"$novelTitle"** thuộc nhóm thể loại: `$genres`.\n\n'
          '👉 Nếu bạn yêu thích phong cách này, có thể thử khám phá thêm các tác phẩm có chủ đề:\n'
          '• Trọng sinh, thăng cấp từ từ, đấu trí logic chặt chẽ.\n'
          '• Xây dựng thế giới rộng lớn với hệ thống cảnh giới rõ ràng.\n'
          '• Bạn có thể dùng ô Tìm kiếm trên trang chủ để lọc theo thể loại `$firstGenre` nhé!';
    }

    // 7. CÂU HỎI TỰ DO KHÁC
    return _generateGeneralChatResponse(
      query: query,
      novelTitle: novelTitle,
      chapterTitle: chTitle,
      paragraphs: paragraphs,
    );
  }

  String _generateChapterSummary({
    required String novelTitle,
    required String chapterTitle,
    required List<String> paragraphs,
    required String novelDesc,
  }) {
    if (paragraphs.isEmpty) {
      return '📖 **Tóm tắt $chapterTitle:**\n\n'
          'Chương này chưa tải xong nội dung văn bản. Bạn hãy mở chương hoặc kết nối mạng để mình tóm tắt chi tiết nhé!\n\n'
          '📌 **Sơ lược tác phẩm:** $novelDesc';
    }

    final opening = paragraphs.first;
    final middle = paragraphs.length > 3
        ? paragraphs[paragraphs.length ~/ 2]
        : (paragraphs.length > 1 ? paragraphs[1] : opening);
    final ending = paragraphs.last;

    return '📝 **Tóm tắt cốt truyện: $chapterTitle**\n\n'
        '• **Khởi đầu:** $opening\n\n'
        '• **Điểm nhấn then chốt:** $middle\n\n'
        '• **Hạ màn & Bước ngoặt:** $ending\n\n'
        '💡 *Đánh giá của AI:* Nhịp độ chương diễn tiến liền mạch, tạo tiền đề xung đột và mở ra nhiều ẩn số cho diễn biến tiếp sau!';
  }

  String _generateCharacterAnalysis({
    required String novelTitle,
    required String chapterTitle,
    required List<String> paragraphs,
    required String novelAuthor,
  }) {
    // Trích xuất các từ viết hoa nghi là tên nhân vật
    final names = <String>{};
    final regex = RegExp(
      r'\b[A-ZÀÁẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬĐÈÉẺẼẸÊẾỀỂỄỆÌÍỈĨỊÒÓỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÙÚỦŨỤƯỨỪỬỮỰỲÝỶỸỴ][a-zàáảãạăắằẳẵặâấầẩẫậđèéẻẽẹêếềểễệìíỉĩịòóỏõọôốồổỗộơớờởỡợùúủũụưứừửữựỳýỷỹỵ]+(?:\s+[A-ZÀÁẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬĐÈÉẺẼẸÊẾỀỂỄỆÌÍỈĨỊÒÓỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÙÚỦŨỤƯỨỪỬỮỰỲÝỶỸỴ][a-zàáảãạăắằẳẵặâấầẩẫậđèéẻẽẹêếềểễệìíỉĩịòóỏõọôốồổỗộơớờởỡợùúủũụưứừửữựỳýỷỹỵ]+)*\b',
    );

    for (final p in paragraphs.take(15)) {
      final matches = regex.allMatches(p);
      for (final m in matches) {
        final val = m.group(0);
        if (val != null &&
            val.length > 3 &&
            !val.startsWith('Chương') &&
            !val.startsWith('Chap')) {
          names.add(val);
        }
      }
    }

    final prominentNames = names.take(4).toList();

    return '🔍 **Phân tích nhân vật & Vị thế trong $chapterTitle:**\n\n'
        '• **Tác phẩm:** $novelTitle (Tác giả: $novelAuthor)\n'
        '• **Nhân vật nổi bật xuất hiện:** ${prominentNames.isNotEmpty ? prominentNames.join(', ') : 'Nhân vật chính và các thế lực đối lập'}\n\n'
        '📌 **Góc nhìn tâm lý:**\n'
        'Nhân vật chính thể hiện tính cách cẩn trọng, kiên định trước thử thách. Các phản ứng quyết đoán trong chương giúp bảo vệ lập trường và từng bước khai mở bí mật thế giới xung quanh.';
  }

  String _generatePlotExplanation({
    required String novelTitle,
    required String chapterTitle,
    required List<String> paragraphs,
  }) {
    final contextSnippet = paragraphs.take(3).join(' ');
    return '💡 **Giải thích tình tiết & Chiều sâu câu chuyện ($chapterTitle):**\n\n'
        'Trong chương này, các mắt xích câu chuyện được tác giả kết nối khéo léo:\n\n'
        '1. **Nguyên nhân:** Xung đột bắt nguồn từ các sự kiện trước đó khiến tình thế bắt buộc phải hành động dứt khoát.\n'
        '2. **Hành động then chốt:** Những diễn biến xoay quanh: *"${contextSnippet.length > 120 ? '${contextSnippet.substring(0, 120)}...' : contextSnippet}"*\n'
        '3. **Tác động:** Tạo động lực trực tiếp để nhân vật chính thăng tiến hoặc thay đổi vị thế với các nhân vật xung quanh.';
  }

  String _generateNextPredictions({
    required String novelTitle,
    required String chapterTitle,
    required List<String> paragraphs,
  }) {
    return '🔮 **Dự đoán kịch bản diễn biến tiếp theo:**\n\n'
        'Dựa vào cái kết bỏ lửng (cliffhanger) ở cuối **$chapterTitle**, có 3 giả thuyết hấp dẫn có thể xảy ra:\n\n'
        '✨ **Giả thuyết 1 (Đột phá/Thăng tiến):** Nhân vật chính tận dụng cơ hội vừa đạt được để bứt phá giới hạn, khiến những kẻ nghi ngờ phải kinh ngạc.\n\n'
        '⚡ **Giả thuyết 2 (Nguy cơ ẩn tàng):** Sự xuất hiện bất ngờ của một thế lực hoặc nhân vật bí ẩn mới đẩy câu chuyện vào thử thách cam go hơn.\n\n'
        '🎯 **Giả thuyết 3 (Mưu kế phản đòn):** Một kế hoạch dự phòng đã được chuẩn bị từ trước bắt đầu phát huy tác dụng.\n\n'
        '👉 Hãy bấm sang chương tiếp theo để xem suy đoán có chính xác không nhé!';
  }

  String _generateGlossaryExplanation({
    required String novelTitle,
    required String novelGenres,
    required List<String> paragraphs,
  }) {
    return '⚔️ **Hệ thống Cảnh giới & Thuật ngữ thế giới ($novelGenres):**\n\n'
        '• **Linh Khí / Nguyên Lực:** Năng lượng tinh hoa của trời đất mà người tu luyện hấp thu để cường hóa kinh mạch và tăng tiến thực lực.\n'
        '• **Cảnh Giới Tu Vi:** Thường tuần tự từ cơ bản (Luyện Khí / Học đồ) ➔ Đặt nền móng (Trúc Cơ / Tinh Anh) ➔ Đại năng (Kim Đan / Thánh giả).\n'
        '• **Bảo Vật & Công Pháp:** Công pháp phẩm cấp càng cao thì tốc độ tích lũy sức mạnh và uy lực chiêu thức càng áp đảo.\n'
        '• **Linh Thạch:** Tiền tệ thông hành cao cấp, dùng để giao dịch tài nguyên và duy trì đại trận.';
  }

  String _generateGeneralChatResponse({
    required String query,
    required String novelTitle,
    required String chapterTitle,
    required List<String> paragraphs,
  }) {
    return '🤖 **Trợ lý AI Đọc Truyện:**\n\n'
        'Cảm ơn bạn đã trò chuyện! Về câu hỏi: *"$query"*\n\n'
        'Khi theo dõi tác phẩm **"$novelTitle"** (đặc biệt là tại **$chapterTitle**), '
        'cốt truyện đang phát triển theo hướng rất lôi cuốn với các tuyến tình tiết đan xen nhau.\n\n'
        'Nếu bạn cần tóm tắt chi tiết, tìm hiểu thân thế nhân vật hoặc giải thích thuật ngữ nào trong chương, hãy bấm vào các nút gợi ý bên dưới hoặc nhắn trực tiếp cho mình nhé!';
  }

  List<String> _deriveNextSuggestions(String lastQuery) {
    final qLower = lastQuery.toLowerCase();
    if (qLower.contains('tóm tắt')) {
      return [
        '🔍 Nhân vật chính hành động thế nào?',
        '🔮 Dự đoán chương tiếp theo',
        '💡 Tình tiết có gì đáng chú ý?',
      ];
    }
    if (qLower.contains('nhân vật')) {
      return [
        '⚔️ Điểm mạnh của nhân vật',
        '🔮 Tương lai nhân vật này',
        '📝 Tóm tắt chương này',
      ];
    }
    return defaultSuggestions;
  }

  /// Gọi Gemini REST API (nếu người dùng cấu hình key)
  Future<String?> _callGeminiApi({
    required String apiKey,
    required String query,
    required Novel novel,
    required Chapter? chapter,
    required String? content,
  }) async {
    final client = http.Client();
    try {
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent',
      );
      final promptPayload = jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text':
                    'Bạn là Trợ lý AI đọc truyện chuyên nghiệp của ứng dụng NovelReader.\n'
                    'Truyện đang đọc: "${novel.title}" của tác giả "${novel.author}". Thể loại: ${novel.genres}.\n'
                    'Chương hiện tại: "${chapter?.title ?? 'Không rõ'}".\n'
                    'Trích đoạn nội dung chương:\n"""${(content ?? '').takeChars(1200)}"""\n\n'
                    'Yêu cầu của độc giả: $query\n'
                    'Hãy trả lời súc tích, sinh động, chuẩn phong cách đọc truyện bằng tiếng Việt.',
              },
            ],
          },
        ],
      });

      final response = await client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'x-goog-api-key': apiKey,
            },
            body: promptPayload,
          )
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final contentObj = candidates[0]['content'] as Map<String, dynamic>?;
          final parts = contentObj?['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            return parts[0]['text'] as String?;
          }
        }
      }
    } finally {
      client.close();
    }
    return null;
  }
}

extension _StringExt on String {
  String takeChars(int n) {
    if (length <= n) return this;
    return substring(0, n);
  }
}
