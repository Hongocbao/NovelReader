import 'dart:io';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/chapter.dart';
import '../../models/reader_settings.dart';
import '../../utils/constants.dart';

/// Biểu thức chính quy nhận diện ảnh minh họa Light Novel `[img]url[/img]`.
final RegExp readerInlineImgPattern = RegExp(r'^\[img\](.+)\[/img\]$');

/// Decode embedded pages defensively. A malformed base64 image must show the
/// reader's broken-image state instead of throwing during widget build.
Uint8List? decodeReaderImageDataUri(String dataUri) {
  final separator = dataUri.indexOf(',');
  if (separator < 0 ||
      !dataUri.substring(0, separator).toLowerCase().contains(';base64')) {
    return null;
  }
  try {
    return base64Decode(dataUri.substring(separator + 1));
  } on FormatException {
    return null;
  }
}

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

  /// Chế độ đọc truyện tranh: ảnh tràn viền, nối tiếp nhau như webtoon.
  final bool comicMode;

  const ReaderParagraphView({
    super.key,
    required this.chapter,
    required this.paragraph,
    required this.settings,
    this.isSpeaking = false,
    this.searchKeyword = '',
    required this.onLongPressQuote,
    required this.onTapImage,
    this.comicMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final match = readerInlineImgPattern.firstMatch(paragraph);
    if (match != null) {
      final url = match.group(1)!.trim();
      final isEmbedded = url.startsWith('data:image/');
      final isLocal = url.startsWith('file://') || !url.startsWith('http');
      Widget imageWidget;
      if (isEmbedded) {
        final bytes = decodeReaderImageDataUri(url);
        imageWidget = bytes == null
            ? const Icon(Icons.broken_image_outlined)
            : Image.memory(
                bytes,
                fit: comicMode ? BoxFit.fitWidth : BoxFit.contain,
                width: comicMode ? double.infinity : null,
                cacheWidth:
                    (MediaQuery.sizeOf(context).width *
                            MediaQuery.devicePixelRatioOf(context))
                        .round(),
                gaplessPlayback: true,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.broken_image_outlined),
              );
      } else if (isLocal && kIsWeb) {
        imageWidget = Container(
          height: 180,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          color: Colors.black12,
          child: Text(
            'Ảnh này nằm trên máy đã nhập truyện. Trên web, hãy nhập bằng ZIP để lưu ảnh cùng truyện.',
            textAlign: TextAlign.center,
            style: TextStyle(color: settings.background.textColor),
          ),
        );
      } else if (isLocal) {
        final filePath = url.startsWith('file:///')
            ? url.substring(8)
            : (url.startsWith('file://') ? url.substring(7) : url);
        imageWidget = Image.file(
          File(filePath),
          fit: comicMode ? BoxFit.fitWidth : BoxFit.contain,
          width: comicMode ? double.infinity : null,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => Container(
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.broken_image_outlined,
              color: settings.background.textColor,
            ),
          ),
        );
      } else {
        imageWidget = CachedNetworkImage(
          imageUrl: url,
          fit: comicMode ? BoxFit.fitWidth : BoxFit.cover,
          width: comicMode ? double.infinity : null,
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
        );
      }

      if (comicMode) {
        return Semantics(
          image: true,
          label:
              'Trang truyện tranh trong ${chapter.title}, nhấn giữ để phóng to',
          child: GestureDetector(
            onLongPress: () => onTapImage(url),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: imageWidget,
            ),
          ),
        );
      }

      return Semantics(
        image: true,
        button: true,
        label:
            'Ảnh minh họa Manga/Light Novel trong ${chapter.title}, chạm để phóng to',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: GestureDetector(
            onTap: () => onTapImage(url),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageWidget,
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
