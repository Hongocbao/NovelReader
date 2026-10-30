import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/chapter.dart';
import '../../models/reader_settings.dart';
import '../../utils/constants.dart';

/// Biểu thức chính quy nhận diện ảnh minh họa Light Novel `[img]url[/img]`.
final RegExp readerInlineImgPattern = RegExp(r'^\[img\](.+)\[/img\]$');

/// Hiển thị một đoạn văn hoặc ảnh minh họa trong chương truyện:
/// - Tự co giãn theo `MediaQuery.textScalerOf(context)` (hỗ trợ cỡ chữ hệ thống).
/// - Tô sáng khung khi đang được đọc bằng TTS (`isSpeaking`).
/// - Tô vàng từ khóa tìm kiếm trong chương (`searchKeyword`).
/// - Gắn `Semantics` cho ảnh minh họa và sự kiện nhấn giữ tạo trích dẫn.
class ReaderParagraphView extends StatelessWidget {
  final Chapter chapter;
  final String paragraph;
  final ReaderSettings settings;
  final bool isSpeaking;
  final String searchKeyword;
  final VoidCallback onLongPressQuote;
  final ValueChanged<String> onTapImage;

  const ReaderParagraphView({
    super.key,
    required this.chapter,
    required this.paragraph,
    required this.settings,
    this.isSpeaking = false,
    this.searchKeyword = '',
    required this.onLongPressQuote,
    required this.onTapImage,
  });

  @override
  Widget build(BuildContext context) {
    final match = readerInlineImgPattern.firstMatch(paragraph);
    if (match != null) {
      final url = match.group(1)!.trim();
      return Semantics(
        image: true,
        button: true,
        label: 'Ảnh minh họa Light Novel trong ${chapter.title}, chạm để phóng to',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: GestureDetector(
            onTap: () => onTapImage(url),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  height: 200,
                  alignment: Alignment.center,
                  color: Colors.black12,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (_, _, _) => Container(
                  height: 160,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        color: settings.background.textColor,
                        semanticLabel: 'Không tải được ảnh minh họa',
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Minh họa Light Novel (cần mạng để tải ảnh)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: settings.background.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      onLongPressHint: AppStrings.saveQuote,
      child: GestureDetector(
        onLongPress: onLongPressQuote,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.only(bottom: 14),
          padding: isSpeaking
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8)
              : EdgeInsets.zero,
          decoration: isSpeaking
              ? BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: scheme.primary, width: 1.5),
                )
              : null,
          child: _buildHighlightedText(context),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(BuildContext context) {
    final kw = searchKeyword.trim();
    final baseStyle = settings.textStyle;
    final scaler = MediaQuery.textScalerOf(context);

    if (kw.isEmpty) {
      return Text(
        paragraph,
        textAlign: settings.textAlign,
        textScaler: scaler,
        style: baseStyle,
      );
    }
    final lowerP = paragraph.toLowerCase();
    final lowerKw = kw.toLowerCase();
    if (!lowerP.contains(lowerKw)) {
      return Text(
        paragraph,
        textAlign: settings.textAlign,
        textScaler: scaler,
        style: baseStyle,
      );
    }
    final spans = <TextSpan>[];
    var start = 0;
    while (true) {
      final idx = lowerP.indexOf(lowerKw, start);
      if (idx < 0) {
        spans.add(TextSpan(text: paragraph.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: paragraph.substring(start, idx)));
      }
      spans.add(
        TextSpan(
          text: paragraph.substring(idx, idx + kw.length),
          style: baseStyle.copyWith(
            backgroundColor: AppColors.rating.withValues(alpha: 0.55),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      start = idx + kw.length;
    }
    return RichText(
      textAlign: settings.textAlign,
      textScaler: scaler,
      text: TextSpan(style: baseStyle, children: spans),
    );
  }
}
