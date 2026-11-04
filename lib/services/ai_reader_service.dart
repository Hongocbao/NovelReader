import '../models/ai_chat_message.dart';
import '../models/chapter.dart';
import '../models/novel.dart';
import '../utils/format.dart';
import 'gemini_chat_client.dart';

/// Dịch vụ Trợ Lý AI Độc Giả (AI Reading Assistant).
///
/// Hỗ trợ:
/// 1. Phân tích ngữ cảnh chương đang đọc (Context-Aware RAG Engine)
/// 2. Tóm tắt nội dung chương trọng tâm
/// 3. Phân tích nhân vật và diễn biến tâm lý
/// 4. Giải thích thuật ngữ, cảnh giới, bối cảnh thế giới
/// 5. Dự đoán các tình tiết hấp dẫn tiếp theo
/// 6. Hỗ trợ kết nối Gemini API (AI Studio & Vertex Express `AQ.`) và bộ suy luận NLP ngữ cảnh chuyên sâu.
class AiReaderService {
  AiReaderService({GeminiChatClient? client})
    : _gemini = client ?? GeminiChatClient();
  static final AiReaderService instance = AiReaderService();
  final GeminiChatClient _gemini;

  /// Bộ nhớ lịch sử hội thoại theo ID truyện (giữ nguyên khi đóng/mở bong bóng chat).
  final Map<String, List<AiChatMessage>> _historyByNovel = {};

  /// Lấy lịch sử chat đã lưu của một bộ truyện.
  List<AiChatMessage> getHistory(int novelId, {String owner = 'guest'}) =>
      List<AiChatMessage>.unmodifiable(
        _historyByNovel['$owner:$novelId'] ?? const [],
      );

  /// Lưu danh sách tin nhắn cho bộ truyện.
  void saveHistory(
    int novelId,
    List<AiChatMessage> messages, {
    String owner = 'guest',
  }) {
    _historyByNovel['$owner:$novelId'] = List<AiChatMessage>.from(messages);
  }

  /// Xóa lịch sử chat của một bộ truyện.
  void clearHistory(int novelId, {String owner = 'guest'}) {
    _historyByNovel.remove('$owner:$novelId');
  }

  /// Gợi ý câu hỏi nhanh mặc định khi mở chat
  static const List<String> defaultSuggestions = [
    '📝 Tóm tắt chương này',
    '🔍 Nhân vật chính & phe phái',
    '💡 Giải thích bối cảnh chương',
    '🔮 Dự đoán tình tiết tiếp theo',
    '📚 Truyện nào liên quan hay?',
  ];

  static const generalSuggestions = [
    'Giúp tôi lập kế hoạch học tập',
    'Giải thích một khái niệm đơn giản',
    'Gợi ý truyện Light Novel hay',
    'Giúp tôi viết và dịch nội dung',
  ];

  Future<AiChatMessage> generateReply({
    required String prompt,
    Novel? novel,
    Chapter? chapter,
    String? chapterContent,
    List<AiChatMessage> history = const [],
    String? geminiApiKey,
  }) async {
    final query = prompt.trim();
    if (query.isEmpty) {
      return AiChatMessage.ai(
        'Bạn hãy nhập câu hỏi để mình hỗ trợ nhé!',
        includeInContext: false,
      );
    }
    if (query.length > 16000) {
      return AiChatMessage.ai(
        'Câu hỏi quá dài. Bạn hãy chia thành các phần dưới 16.000 ký tự.',
        isError: true,
        includeInContext: false,
      );
    }
    if (geminiApiKey != null && geminiApiKey.trim().isNotEmpty) {
      try {
        final reply = await _gemini.reply(
          apiKey: geminiApiKey,
          query: query,
          novel: novel,
          chapter: chapter,
          content: chapterContent,
          history: List.of(history),
        );
        return AiChatMessage.ai(reply);
      } on AiChatException catch (error) {
        return AiChatMessage.ai(
          error.message,
          isError: true,
          includeInContext: false,
        );
      }
    }
    if (novel == null) {
      return AiChatMessage.ai(
        'Bạn hãy thêm khóa Gemini bằng biểu tượng chìa khóa để bắt đầu hỏi đáp AI.',
        isError: true,
        includeInContext: false,
      );
    }
    // Retain local reading tools when no key is configured, clearly labelled.
    return AiChatMessage.ai(
      'Chế độ phân tích cục bộ (chưa kết nối Gemini).\n\n${_analyzeWithContextEngine(query: query, novel: novel, chapter: chapter, content: chapterContent ?? '')}',
      suggestions: _deriveNextSuggestions(query),
      includeInContext: false,
    );
  }

  /// Bộ xử lý ngữ cảnh thông minh (Context-Aware NLP Engine)
  /// Hiểu cả tiếng Việt có dấu, không dấu và lỗi gõ phím phổ biến.
  String _analyzeWithContextEngine({
    required String query,
    required Novel novel,
    required Chapter? chapter,
    required String content,
  }) {
    final qLower = query.toLowerCase().trim();
    final qNorm = Format.normalize(qLower);
    final chTitle = chapter?.title ?? 'Chương hiện tại';
    final novelTitle = novel.title;
    final genres = novel.genres.isEmpty
        ? 'Tiểu thuyết đặc sắc'
        : novel.genres.join(', ');

    final paragraphs = content
        .split('\n')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty && !p.startsWith('[img]'))
        .toList();

    // 0. DỰ ĐOÁN TÌNH TIẾT TIẾP THEO (kiểm tra trước vì chứa từ "tình tiết" / "nhân vật")
    if (_matchesAny(qLower, qNorm, const [
      'dự đoán',
      'du doan',
      'tiếp theo',
      'tiep theo',
      'hồi sau',
      'hoi sau',
      'sẽ xảy ra',
      'se xay ra',
      'tương lai',
      'tuong lai',
      'chap sau',
      'chương sau',
      'chuong sau',
      'diễn biến tới',
      'kết cục',
      'ket cuc',
    ])) {
      return _generateNextPredictions(
        novelTitle: novelTitle,
        chapterTitle: chTitle,
        paragraphs: paragraphs,
      );
    }

    // 1. CHÀO HỎI / HỎI KHẢ NĂNG HỖ TRỢ CỦA AI ("bạn có thể cung cấp hỗ trợ gì", "bạn làm được gì", "xin chào"...)
    if (_matchesAny(qLower, qNorm, const [
      'cung cấp',
      'cung cap',
      'hỗ trợ',
      'ho tro',
      'hở trwoj',
      'ho trwoj',
      'giúp gì',
      'giup gi',
      'làm được gì',
      'lam duoc gi',
      'chức năng',
      'chuc nang',
      'bạn là ai',
      'ban la ai',
      'xin chào',
      'xin chao',
      'hello',
      'hi ai',
      'hướng dẫn',
      'huong dan',
    ])) {
      return _generateCapabilitiesResponse(
        novel: novel,
        chapterTitle: chTitle,
        paragraphs: paragraphs,
      );
    }

    // 2. TRUYỆN LIÊN QUAN / GỢI Ý TRUYỆN TƯƠNG TỰ ("có chuyện nào liên quan đến truyện này không", "có truyện nào như vầy không", "gợi ý", "cùng thể loại"...)
    if (_matchesAny(qLower, qNorm, const [
      'liên quan',
      'lien quan',
      'tương tự',
      'tuong tu',
      'như vầy',
      'nhu vay',
      'như vậy',
      'như thế này',
      'nhu the nay',
      'kiểu này',
      'kieu nay',
      'truyện nào như',
      'truyen nao nhu',
      'truyện giống',
      'truyen giong',
      'gợi ý',
      'goi y',
      'đề xuất',
      'de xuat',
      'đề cử',
      'de cu',
      'truyện nào hay',
      'truyen nao hay',
      'chuyện nào',
      'chuyen nao',
      'truyện khác',
      'truyen khac',
      'cùng thể loại',
      'cung the loai',
      'giống truyện này',
      'giong truyen nay',
    ])) {
      return _generateRelatedNovelsResponse(novel: novel);
    }

    // 3. TÓM TẮT CHƯƠNG (Summary)
    if (_matchesAny(qLower, qNorm, const [
      'tóm tắt',
      'tom tat',
      'nội dung chính',
      'noi dung chinh',
      'nói về cái gì',
      'noi ve cai gi',
      'chương này kể gì',
      'chuong nay ke gi',
      'chương này nói gì',
      'chuong nay noi gi',
      'review chương',
    ])) {
      return _generateChapterSummary(
        novelTitle: novelTitle,
        chapterTitle: chTitle,
        paragraphs: paragraphs,
        novelDesc: novel.description,
      );
    }

    // 4. NHÂN VẬT & PHE PHÁI (Characters)
    if (_matchesAny(qLower, qNorm, const [
      'nhân vật',
      'nhan vat',
      'ai là',
      'ai la',
      'tính cách',
      'tinh cach',
      'phe phái',
      'phe phai',
      'nam chính',
      'nam chinh',
      'nữ chính',
      'nu chinh',
      'nhân vật chính',
      'nhan vat chinh',
    ])) {
      return _generateCharacterAnalysis(
        novelTitle: novelTitle,
        chapterTitle: chTitle,
        paragraphs: paragraphs,
        novelAuthor: novel.author,
      );
    }

    // 5. THÔNG TIN TÁC PHẨM / TÁC GIẢ / ĐÁNH GIÁ ("tác giả là ai", "truyện này hay không", "bao nhiêu chương")
    if (_matchesAny(qLower, qNorm, const [
      'tác giả',
      'tac gia',
      'bao nhiêu chương',
      'bao nhieu chuong',
      'mấy chương',
      'may chuong',
      'hoàn thành chưa',
      'hoan thanh chua',
      'hay không',
      'hay khong',
      'đánh giá',
      'danh gia',
      'thể loại gì',
      'the loai gi',
      'giới thiệu truyện',
      'gioi thieu truyen',
    ])) {
      return _generateNovelOverviewResponse(
        novel: novel,
        chapterTitle: chTitle,
      );
    }

    // 6. GIẢI THÍCH TÌNH TIẾT & BỐI CẢNH (Plot / Lore explanation)
    if (_matchesAny(qLower, qNorm, const [
      'giải thích',
      'giai thich',
      'tại sao',
      'tai sao',
      'vì sao',
      'vi sao',
      'bối cảnh',
      'boi canh',
      'tình tiết',
      'tinh tiet',
      'ý nghĩa',
      'y nghia',
      'hiểu như thế nào',
      'hieu nhu the nao',
    ])) {
      return _generatePlotExplanation(
        novelTitle: novelTitle,
        chapterTitle: chTitle,
        paragraphs: paragraphs,
      );
    }

    // 7. THUẬT NGỮ & CẢNH GIỚI (Cultivation / Magic / Worldbuilding)
    if (_matchesAny(qLower, qNorm, const [
      'thuật ngữ',
      'thuat ngu',
      'cảnh giới',
      'canh gioi',
      'công pháp',
      'cong phap',
      'pháp bảo',
      'phap bao',
      'linh thạch',
      'linh thach',
      'mana',
      'dị năng',
      'di nang',
      'hệ thống tu luyện',
    ])) {
      return _generateGlossaryExplanation(
        novelTitle: novelTitle,
        novelGenres: genres,
        genreList: novel.genres,
        paragraphs: paragraphs,
      );
    }

    // 8. CÂU HỎI TỰ DO: Tìm kiếm ngữ nghĩa trực tiếp trên nội dung chương hiện tại (RAG)
    return _generateContextualAnswerFromChapter(
      query: query,
      novel: novel,
      chapterTitle: chTitle,
      paragraphs: paragraphs,
    );
  }

  bool _matchesAny(String qLower, String qNorm, List<String> keywords) {
    for (final kw in keywords) {
      if (qLower.contains(kw) || qNorm.contains(Format.normalize(kw))) {
        return true;
      }
    }
    return false;
  }

  String _generateCapabilitiesResponse({
    required Novel novel,
    required String chapterTitle,
    required List<String> paragraphs,
  }) {
    final names = _extractProperNouns(paragraphs, limit: 3);
    final namesHint = names.isNotEmpty ? ' (như **${names.join(', ')}**)' : '';
    return '🤖 **Mình có thể hỗ trợ bạn ngay trong lúc đọc "${novel.title}":**\n\n'
        '1. 📝 **Tóm tắt nhanh $chapterTitle:** Nắm bắt toàn bộ mở đầu, cao trào và kết chương chỉ trong 10 giây.\n'
        '2. 🔍 **Phân tích nhân vật & mối quan hệ:** Giải thích tâm lý, động cơ của các nhân vật xuất hiện trong chương$namesHint.\n'
        '3. 💡 **Giải mã tình tiết & thuật ngữ:** Làm rõ bối cảnh, ẩn ý của tác giả **${novel.author}** hoặc hệ thống cảnh giới/kỹ năng.\n'
        '4. 🔮 **Dự đoán diễn biến tiếp theo:** Đưa ra 3 giả thuyết hợp lý nhất cho chương kế tiếp.\n'
        '5. 📚 **Đề xuất truyện liên quan:** Gợi ý các bộ truyện cùng thể loại **${novel.genres.isEmpty ? "đặc sắc" : novel.genres.join(", ")}** cực hợp gu.\n\n'
        '👉 Bạn có thể bấm chọn một nút gợi ý bên dưới hoặc hỏi trực tiếp bất kỳ chi tiết nào trong chương nhé!';
  }

  String _generateRelatedNovelsResponse({required Novel novel}) {
    final genreSet = novel.genres.map((g) => Format.normalize(g)).toSet();
    final genresLabel = novel.genres.isEmpty
        ? 'Đa thể loại'
        : novel.genres.join(', ');

    final recommendations =
        <({String title, String author, String genres, String reason})>[
          if (genreSet.any(
            (g) =>
                g.contains('tien hiep') ||
                g.contains('kiem hiep') ||
                g.contains('huyen huyen') ||
                g.contains('co dai'),
          )) ...[
            (
              title: 'Kiếm Đạo Vấn Thiên',
              author: 'Lâm Phong Vũ',
              genres: 'Tiên hiệp, Kiếm hiệp, Hành động',
              reason: 'Cùng mô-típ thiếu niên kiên cường từ tầng lớp thấp vươn lên đỉnh cao tu đạo.',
            ),
            (
              title: 'Vạn Cổ Thần Đế Truyền Kỳ',
              author: 'Thiênằm Huyền Mặc',
              genres: 'Huyền huyễn, Trọng sinh, Kỳ ảo',
              reason: 'Hệ thống cảnh giới đồ sộ, mưu kế chồng chất và những trận đại chiến mãn nhãn.',
            ),
            (
              title: 'Thiên Cơ Các Mật Lục',
              author: 'Mặc Vũ Giang Hồ',
              genres: 'Kiếm hiệp, Trinh thám, Cổ đại',
              reason: 'Đan xen giữa ân oán giang hồ và những bí mật triều đình sâu sắc.',
            ),
          ],
          if (genreSet.any(
            (g) =>
                g.contains('van hoc') ||
                g.contains('co dien') ||
                g.contains('lich su') ||
                g.contains('tam ly') ||
                g.contains('ngon tinh'),
          )) ...[
            (
              title: 'Truyện Kiều (Đoạn Trường Tân Thanh)',
              author: 'Nguyễn Du',
              genres: 'Văn học kinh điển, Cổ đại, Tâm lý',
              reason: 'Tuyệt tác văn học kinh điển khắc họa sâu sắc số phận con người và chữ Tài - chữ Mệnh.',
            ),
            (
              title: 'Bóng Trăng Trên Thành Cổ',
              author: 'Hoàng Lan Chi',
              genres: 'Lịch sử, Cổ đại, Ngôn tình',
              reason: 'Bối cảnh hoài cổ giàu chất thơ, ngôn từ trau chuốt và chiều sâu nội tâm nhân vật.',
            ),
            (
              title: 'Khúc Nhạc Chiều Thu Hà Nội',
              author: 'Minh Nhật',
              genres: 'Tâm lý, Chữa lành, Đời thường',
              reason: 'Nhịp kể lắng đọng, giàu cảm xúc nhân văn và dư vị sâu lắng sau mỗi chương.',
            ),
          ],
          (
            title: 'Học Viện Tinh Vân: Kỷ Nguyên Thức Tỉnh',
            author: 'Trần Gia Huy',
            genres: 'Khoa huyễn, Hệ thống, Học đường',
            reason: 'Nhịp truyện nhanh, nhân vật chính thông minh, quyết đoán và giàu kịch tính.',
          ),
          (
            title: 'Quán Trà Đêm Giữa Lòng Thành Phố',
            author: 'An Nhiên',
            genres: 'Linh dị, Trinh thám, Chữa lành',
            reason: 'Mỗi chương là một câu chuyện cuốn hút với nút thắt bất ngờ ở cuối.',
          ),
        ];

    final filtered = recommendations
        .where(
          (r) => Format.normalize(r.title) != Format.normalize(novel.title),
        )
        .take(4)
        .toList();

    final buf = StringBuffer(
      '📚 **Các tác phẩm liên quan & cùng gu với "${novel.title}" ($genresLabel):**\n\n',
    );
    for (var i = 0; i < filtered.length; i++) {
      final item = filtered[i];
      buf.writeln(
        '${i + 1}. **${item.title}** *(Tác giả: ${item.author} • ${item.genres})*\n'
        '   • *Điểm tương đồng:* ${item.reason}\n',
      );
    }
    buf.write(
      '💡 **Mẹo nhỏ:** Bạn có thể mở tab **Tìm kiếm** hoặc bấm vào thẻ thể loại **${novel.genres.isNotEmpty ? novel.genres.first : "Tiên hiệp"}** ở Trang chủ để đọc ngay các bộ truyện này nhé!',
    );
    return buf.toString();
  }

  String _generateNovelOverviewResponse({
    required Novel novel,
    required String chapterTitle,
  }) {
    final statusText = novel.status == 'completed'
        ? 'Đã hoàn thành'
        : 'Đang ra định kỳ';
    final genresText = novel.genres.isEmpty
        ? 'Chưa phân loại'
        : novel.genres.join(', ');
    return '📖 **Thông tin & Đánh giá bộ truyện "${novel.title}":**\n\n'
        '• **Tác giả:** ${novel.author}\n'
        '• **Thể loại:** $genresText\n'
        '• **Trạng thái:** $statusText (${novel.totalChapters} chương)\n'
        '• **Đánh giá độc giả:** ⭐ ${novel.rating.toStringAsFixed(1)}/5.0 (${novel.views} lượt đọc)\n'
        '• **Chương đang đọc:** $chapterTitle\n\n'
        '📌 **Tóm lược & Cảm nhận:**\n'
        '${novel.description.isNotEmpty ? novel.description : "Tác phẩm sở hữu cốt truyện chặt chẽ, xây dựng nhân vật có chiều sâu và nhịp truyện lôi cuốn qua từng chương."}';
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

    final opening = paragraphs.first.replaceFirst(RegExp(r'^【[^】]*】\s*'), '');
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
    final prominentNames = _extractProperNouns(paragraphs, limit: 4);

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
        '2. **Hành động then chốt:** Những diễn biến xoay quanh: *"${contextSnippet.length > 140 ? '${contextSnippet.substring(0, 140)}...' : contextSnippet}"*\n'
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
    required List<String> genreList,
    required List<String> paragraphs,
  }) {
    final g = genreList.map((e) => Format.normalize(e)).join(',');
    final isCultivation =
        g.contains('tien hiep') ||
        g.contains('huyen huyen') ||
        g.contains('kiem hiep') ||
        g.contains('vo hiep');
    final isMagic =
        g.contains('fantasy') ||
        g.contains('isekai') ||
        g.contains('ky ao') ||
        g.contains('ma phap');

    final buf = StringBuffer(
      '⚔️ **Thuật ngữ & bối cảnh thế giới ($novelGenres):**\n\n',
    );
    if (isCultivation) {
      buf
        ..writeln(
          '• **Linh khí:** Năng lượng của trời đất mà tu sĩ hấp thu để rèn luyện kinh mạch.',
        )
        ..writeln(
          '• **Cảnh giới:** Thường theo thứ tự Luyện Khí ➔ Trúc Cơ ➔ Kim Đan ➔ Nguyên Anh...',
        )
        ..writeln(
          '• **Công pháp / Pháp bảo:** Phẩm cấp càng cao thì tốc độ tu luyện và uy lực càng mạnh.',
        )
        ..writeln(
          '• **Linh thạch:** Tiền tệ của giới tu tiên, dùng để giao dịch tài nguyên.',
        );
    } else if (isMagic) {
      buf
        ..writeln(
          '• **Mana / Ma lực:** Nguồn năng lượng dùng để thi triển phép thuật.',
        )
        ..writeln(
          '• **Ma pháp trận:** Vòng tròn cổ ngữ dẫn dòng mana để kích hoạt phép cấp cao.',
        )
        ..writeln(
          '• **Kỹ năng / Hệ thống:** Năng lực đặc biệt, thường được nâng cấp qua chiến đấu.',
        );
    } else {
      buf.writeln(
        'Thể loại này xây dựng bối cảnh đời thực/lịch sử/xã hội đặc trưng. '
        'Dưới đây là các danh từ riêng & khái niệm trọng tâm xuất hiện trong chương:',
      );
    }

    final terms = _extractProperNouns(paragraphs, limit: 6);
    if (terms.isNotEmpty) {
      buf.writeln(
        '\n📌 **Xuất hiện nổi bật trong chương:** ${terms.join(', ')}',
      );
    }
    return buf.toString().trim();
  }

  /// Tìm kiếm các đoạn văn khớp nhất với câu hỏi của độc giả để trả lời sát thực tế chương truyện.
  String _generateContextualAnswerFromChapter({
    required String query,
    required Novel novel,
    required String chapterTitle,
    required List<String> paragraphs,
  }) {
    final cleanParagraphs = paragraphs
        .map((p) => p.replaceFirst(RegExp(r'^【[^】]*】\s*'), '').trim())
        .where((p) => p.length > 20 && !p.startsWith('— Hết chương'))
        .toList();

    if (cleanParagraphs.isEmpty) {
      return '🤖 **Phân tích theo yêu cầu của bạn:** *"$query"*\n\n'
          'Bộ truyện **"${novel.title}"** của tác giả **${novel.author}** thuộc thể loại **${novel.genres.join(", ")}**.\n'
          'Nội dung chính xoay quanh: ${novel.description}\n\n'
          'Bạn có thể hỏi mình về nhân vật, cốt truyện hoặc gợi ý truyện tương tự nhé!';
    }

    final stopWords = <String>{
      'la',
      'cua',
      'va',
      'nhung',
      'trong',
      'cho',
      'voi',
      'duoc',
      'khong',
      'nay',
      'do',
      'mot',
      'cac',
      'nhu',
      'the',
      'nao',
      'gi',
      'ai',
      'dau',
      'khi',
      'tai',
      'sao',
      'co',
      've',
      'den',
      'truyen',
      'chuyen',
      'chuong',
      'ban',
      'toi',
      'minh',
      'hoi',
      'hay',
      'nhe',
    };

    final queryTokens = Format.normalize(query)
        .split(RegExp(r'[^a-z0-9]+'))
        .where((w) => w.length >= 2 && !stopWords.contains(w))
        .toSet();

    final scored = <({String text, int score, int index})>[];
    for (var i = 0; i < cleanParagraphs.length; i++) {
      final p = cleanParagraphs[i];
      final pNorm = Format.normalize(p);
      var score = 0;
      for (final token in queryTokens) {
        if (pNorm.contains(token)) {
          score += 3;
        }
      }
      // Ưu tiên đoạn có hội thoại hoặc tên riêng
      if (p.contains('“') || p.contains('"')) score += 1;
      scored.add((text: p, score: score, index: i));
    }

    scored.sort((a, b) {
      final cmp = b.score.compareTo(a.score);
      if (cmp != 0) return cmp;
      return a.index.compareTo(b.index);
    });

    final topMatches = scored.take(2).toList();
    final names = _extractProperNouns(cleanParagraphs, limit: 3);

    final buf = StringBuffer();
    buf.writeln('🤖 **Giải đáp về: "$query"** *(tại $chapterTitle)*\n');

    if (topMatches.first.score > 0) {
      buf.writeln(
        'Dựa trực tiếp vào nội dung chương đang đọc, chi tiết liên quan nhất được nhắc đến như sau:\n',
      );
      for (final m in topMatches.where((e) => e.score > 0)) {
        buf.writeln('• *"${m.text}"*\n');
      }
    } else {
      buf.writeln(
        'Trong **$chapterTitle** của bộ **${novel.title}**, mạch truyện đang tập trung vào diễn biến chính:\n',
      );
      buf.writeln('• *"${cleanParagraphs.first}"*\n');
      if (cleanParagraphs.length > 2) {
        buf.writeln('• *"${cleanParagraphs[cleanParagraphs.length ~/ 2]}"*\n');
      }
    }

    if (names.isNotEmpty) {
      buf.writeln(
        '📌 **Nhân vật / Địa danh trọng tâm trong cảnh này:** ${names.join(', ')}.',
      );
    }
    buf.write(
      '💡 **Góc nhìn thêm:** Chi tiết này giúp khắc họa rõ hơn bầu không khí của tác phẩm **${novel.title}** và chuẩn bị cho bước ngoặt ở phần tiếp theo.',
    );
    return buf.toString();
  }

  /// Các từ thường đứng đầu câu (viết hoa) nhưng KHÔNG phải tên riêng.
  static const Set<String> _commonCapitalized = {
    'Một',
    'Hai',
    'Ba',
    'Trong',
    'Trên',
    'Dưới',
    'Khi',
    'Nhưng',
    'Rồi',
    'Sau',
    'Trước',
    'Không',
    'Có',
    'Cậu',
    'Hắn',
    'Nàng',
    'Người',
    'Mọi',
    'Những',
    'Các',
    'Đôi',
    'Từ',
    'Bầu',
    'Mặt',
    'Cuộc',
    'Buổi',
    'Nhìn',
    'Nhớ',
    'Tiếng',
    'Câu',
    'Chương',
    'Chap',
    'Trang',
    'Hết',
    'Đó',
    'Đây',
    'Này',
    'Ta',
    'Ngươi',
    'Phàm',
    'Bên',
    'Giữa',
    'Ánh',
    'Lưỡi',
    'Gió',
  };

  /// Trích tên riêng (cụm 2–3 từ viết hoa liên tiếp), xếp theo tần suất.
  List<String> _extractProperNouns(List<String> paragraphs, {int limit = 4}) {
    final regex = RegExp(
      r'(?<![\p{L}])\p{Lu}\p{Ll}+(?:\s+\p{Lu}\p{Ll}+){1,2}(?![\p{L}])',
      unicode: true,
    );
    final counts = <String, int>{};
    for (final p in paragraphs) {
      for (final m in regex.allMatches(p)) {
        var words = m.group(0)!.split(RegExp(r'\s+'));
        while (words.isNotEmpty && _commonCapitalized.contains(words.first)) {
          words = words.sublist(1);
        }
        if (words.length < 2) continue;
        final name = words.join(' ');
        counts[name] = (counts[name] ?? 0) + 1;
      }
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).map((e) => e.key).toList();
  }

  List<String> _deriveNextSuggestions(String lastQuery) {
    final qLower = lastQuery.toLowerCase();
    if (qLower.contains('tóm tắt')) {
      return [
        '🔍 Nhân vật chính hành động thế nào?',
        '🔮 Dự đoán chương tiếp theo',
        '📚 Truyện nào liên quan hay?',
      ];
    }
    if (qLower.contains('nhân vật')) {
      return [
        '⚔️ Điểm mạnh của nhân vật',
        '🔮 Tương lai nhân vật này',
        '📝 Tóm tắt chương này',
      ];
    }
    if (qLower.contains('liên quan') || qLower.contains('gợi ý')) {
      return [
        '📝 Tóm tắt chương này',
        '💡 Giải thích bối cảnh chương',
        '🔮 Dự đoán tình tiết tiếp theo',
      ];
    }
    return defaultSuggestions;
  }
}
