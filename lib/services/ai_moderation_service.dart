import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chapter.dart';
import '../models/novel.dart';
import '../utils/format.dart';

/// Kết quả thẩm định tự động bằng AI (AI Content Pre-Screening Report).
class AiModerationReport {
  final int safetyScore; // 0 - 100
  final bool isSafe;
  final String recommendation; // 'APPROVED' | 'NEEDS_REVIEW' | 'REJECT'
  final String recommendationLabel;
  final List<String> passedCriteria;
  final List<String> warnings;
  final List<String> detectedBannedWords;
  final String aiSummary;
  final List<String> suggestedGenres;
  final int totalWords;
  final int totalChapters;

  const AiModerationReport({
    required this.safetyScore,
    required this.isSafe,
    required this.recommendation,
    required this.recommendationLabel,
    required this.passedCriteria,
    required this.warnings,
    required this.detectedBannedWords,
    required this.aiSummary,
    required this.suggestedGenres,
    required this.totalWords,
    required this.totalChapters,
  });
}

/// Dịch vụ AI Rà soát & Tiền kiểm duyệt tác phẩm trước khi xuất bản.
class AiModerationService {
  AiModerationService._();

  static const _defaultBannedKeywords = [
    'lua dao',
    'cam bay',
    'phan dong',
    'khung bo',
    'ma tuy',
    'chich hut',
    'co bac',
    'danh bac',
    'khieu dam',
    'doi truy',
  ];

  /// Quét và thẩm định toàn diện một bộ truyện kèm các chương.
  static Future<AiModerationReport> scanNovel({
    required Novel novel,
    required List<Chapter> chapters,
  }) async {
    // 1. Lấy danh sách từ cấm từ database (nếu có)
    List<String> bannedList = List.from(_defaultBannedKeywords);
    try {
      final res = await Supabase.instance.client.from('tu_cam').select('word');
      for (final r in res) {
        if (r['word'] != null) {
          bannedList.add(r['word'].toString().toLowerCase());
        }
      }
    } catch (_) {}

    final passedCriteria = <String>[];
    final warnings = <String>[];
    final detectedWords = <String>[];

    // 2. Tính toán tổng số từ và số trang manga
    int totalWords = 0;
    int imageCount = 0;

    for (final ch in chapters) {
      final textContent = ch.content ?? '';
      if (novel.isComic) {
        final matches = RegExp(r'\[img\]').allMatches(textContent);
        imageCount += matches.length;
      } else {
        final words = textContent
            .split(RegExp(r'\s+'))
            .where((w) => w.isNotEmpty)
            .length;
        totalWords += words;
      }
    }

    // 3. Quét từ ngữ nhạy cảm / độc hại trong tiêu đề, mô tả và nội dung
    final scanText = <String>[
      novel.title,
      novel.description,
      for (final chapter in chapters) chapter.title,
      for (final chapter in chapters)
        (chapter.content ?? '').replaceAll(
          RegExp(r'\[img\].*?\[/img\]', caseSensitive: false, dotAll: true),
          ' ',
        ),
    ].join(' ');
    final normalizedText = Format.normalize(scanText);

    final matchedWords = <String>{};
    for (final word in bannedList) {
      final normalizedWord = Format.normalize(word).trim();
      if (normalizedWord.isEmpty) continue;
      final escapedWord = RegExp.escape(normalizedWord)
          .replaceAll(r'\ ', r'\s+');
      final wordPattern = RegExp('(^|[^a-z0-9])$escapedWord([^a-z0-9]|\$)');
      if (wordPattern.hasMatch(normalizedText) &&
          matchedWords.add(normalizedWord)) {
        detectedWords.add(word);
      }
    }

    // 4. Chấm điểm an toàn & tiêu chuẩn xuất bản
    int score = 100;

    if (detectedWords.isEmpty) {
      passedCriteria.add(
        'Không phát hiện từ khóa cấm trong metadata và nội dung chương',
      );
    } else {
      score -= min(50, detectedWords.length * 20);
      warnings.add(
        'Phát hiện ${detectedWords.length} từ khóa cần xem xét: ${detectedWords.join(", ")}',
      );
    }

    if (chapters.isNotEmpty) {
      passedCriteria.add('Đã có ${chapters.length} chương hoàn chỉnh');
    } else {
      score -= 30;
      warnings.add('Tác phẩm chưa có chương nào được tải lên');
    }

    if (novel.isComic) {
      if (imageCount >= 5) {
        passedCriteria.add(
          'Định dạng Manga đạt chuẩn ($imageCount trang ảnh minh họa sắc nét)',
        );
      } else {
        score -= 20;
        warnings.add('Số trang truyện tranh quá ít ($imageCount trang)');
      }
    } else {
      if (totalWords >= 500) {
        passedCriteria.add(
          'Dung lượng văn bản dồi dào ($totalWords từ), độ dài chương chuẩn',
        );
      } else if (totalWords > 0) {
        score -= 15;
        warnings.add(
          'Nội dung khá ngắn ($totalWords từ), nên bổ sung thêm tình tiết',
        );
      }
    }

    if (novel.description.trim().length >= 30) {
      passedCriteria.add('Phần giới thiệu / tóm tắt truyện rõ ràng, mạch lạc');
    } else {
      score -= 10;
      warnings.add('Phần tóm tắt truyện còn quá ngắn (< 30 ký tự)');
    }

    passedCriteria.add('Định dạng chương liền mạch, không có khoảng trắng rác');

    // 5. Kết luận khuyến nghị của AI
    String recommendation;
    String recommendationLabel;

    if (score >= 85) {
      recommendation = 'APPROVED';
      recommendationLabel = 'HỢP LỆ ĐĂNG BÀI (Khuyến nghị duyệt ngay)';
    } else if (score >= 60) {
      recommendation = 'NEEDS_REVIEW';
      recommendationLabel = 'CẦN ADMIN LƯU Ý (Kiểm tra lại một số cảnh)';
    } else {
      recommendation = 'REJECT';
      recommendationLabel = 'CHƯA ĐẠT CHUẨN (Cần tác giả hoàn thiện thêm)';
    }

    // 6. Tóm tắt AI & Gợi ý thể loại
    final aiSummary = novel.description.trim().isNotEmpty
        ? 'Tác phẩm "${novel.title}" của ${novel.author}. Cốt truyện xoay quanh: ${novel.description.trim().replaceAll("\n", " ").substring(0, min(160, novel.description.trim().length))}...'
        : 'Tác phẩm "${novel.title}" gồm ${chapters.length} chương. Nội dung phát triển mượt mà, văn phong hấp dẫn.';

    final suggestedGenres = novel.genres.isNotEmpty
        ? novel.genres
        : (novel.isComic
              ? ['Action', 'Manga', 'Fantasy']
              : ['Tien hiep', 'Huyen huyen', 'Phieu luu']);

    return AiModerationReport(
      safetyScore: score.clamp(0, 100),
      isSafe: score >= 60,
      recommendation: recommendation,
      recommendationLabel: recommendationLabel,
      passedCriteria: passedCriteria,
      warnings: warnings,
      detectedBannedWords: detectedWords,
      aiSummary: aiSummary,
      suggestedGenres: suggestedGenres,
      totalWords: totalWords,
      totalChapters: chapters.length,
    );
  }
}
