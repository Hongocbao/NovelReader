import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/theme.dart';

/// Cài đặt giao diện đọc: cỡ chữ, font, giãn dòng, căn lề, nền, độ sáng.
class ReaderSettings {
  final double fontSize;

  /// fontFamily hệ thống ('' = mặc định).
  final String fontFamily;
  final double lineHeight;

  /// true = căn đều hai bên, false = căn trái.
  final bool justify;
  final ReaderBackground background;

  /// Độ sáng trong app 0.3..1.0 (phủ lớp tối lên trang đọc).
  final double brightness;
  final bool keepScreenOn;

  /// true = lật trang ngang (PageView), false = cuộn dọc truyền thống.
  final bool horizontalPageMode;

  const ReaderSettings({
    this.fontSize = ReaderLimits.defaultFontSize,
    this.fontFamily = '',
    this.lineHeight = ReaderLimits.defaultLineHeight,
    this.justify = true,
    this.background = ReaderBackground.white,
    this.brightness = 1.0,
    this.keepScreenOn = true,
    this.horizontalPageMode = false,
  });

  TextAlign get textAlign => justify ? TextAlign.justify : TextAlign.left;

  /// Style chữ dùng cho nội dung chương.
  TextStyle get textStyle => TextStyle(
        fontSize: fontSize,
        height: lineHeight,
        color: background.textColor,
        fontFamily: fontFamily.isEmpty ? null : fontFamily,
      );

  Map<String, Object?> toMap() => {
        'font_size': fontSize,
        'font_family': fontFamily,
        'line_height': lineHeight,
        'justify': justify,
        'background': background.index,
        'brightness': brightness,
        'keep_screen_on': keepScreenOn,
        'horizontal_page_mode': horizontalPageMode,
      };

  /// Đọc từ Map, giá trị lỗi/ngoài giới hạn sẽ được đưa về hợp lệ.
  factory ReaderSettings.fromMap(Map<String, Object?> map) {
    const d = ReaderSettings();
    return ReaderSettings(
      fontSize: ((map['font_size'] as num?)?.toDouble() ?? d.fontSize)
          .clamp(ReaderLimits.minFontSize, ReaderLimits.maxFontSize)
          .toDouble(),
      fontFamily: (map['font_family'] as String?) ?? d.fontFamily,
      lineHeight: ((map['line_height'] as num?)?.toDouble() ?? d.lineHeight)
          .clamp(ReaderLimits.minLineHeight, ReaderLimits.maxLineHeight)
          .toDouble(),
      justify: (map['justify'] as bool?) ?? d.justify,
      background: ReaderBackground.fromIndex(map['background'] as int?),
      brightness: ((map['brightness'] as num?)?.toDouble() ?? d.brightness)
          .clamp(ReaderLimits.minBrightness, ReaderLimits.maxBrightness)
          .toDouble(),
      keepScreenOn: (map['keep_screen_on'] as bool?) ?? d.keepScreenOn,
      horizontalPageMode:
          (map['horizontal_page_mode'] as bool?) ?? d.horizontalPageMode,
    );
  }

  ReaderSettings copyWith({
    double? fontSize,
    String? fontFamily,
    double? lineHeight,
    bool? justify,
    ReaderBackground? background,
    double? brightness,
    bool? keepScreenOn,
    bool? horizontalPageMode,
  }) {
    return ReaderSettings(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      lineHeight: lineHeight ?? this.lineHeight,
      justify: justify ?? this.justify,
      background: background ?? this.background,
      brightness: brightness ?? this.brightness,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      horizontalPageMode: horizontalPageMode ?? this.horizontalPageMode,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ReaderSettings &&
      other.fontSize == fontSize &&
      other.fontFamily == fontFamily &&
      other.lineHeight == lineHeight &&
      other.justify == justify &&
      other.background == background &&
      other.brightness == brightness &&
      other.keepScreenOn == keepScreenOn &&
      other.horizontalPageMode == horizontalPageMode;

  @override
  int get hashCode => Object.hash(
        fontSize,
        fontFamily,
        lineHeight,
        justify,
        background,
        brightness,
        keepScreenOn,
        horizontalPageMode,
      );
}
