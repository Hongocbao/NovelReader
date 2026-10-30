import 'package:flutter/material.dart';

import 'constants.dart';

/// 4 kiểu nền đọc: Trắng / Sepia / Xám / Đen.
enum ReaderBackground {
  white('Trắng', AppColors.readerWhiteBg, AppColors.readerWhiteText),
  sepia('Sepia', AppColors.readerSepiaBg, AppColors.readerSepiaText),
  gray('Xám', AppColors.readerGrayBg, AppColors.readerGrayText),
  black('Đen', AppColors.readerBlackBg, AppColors.readerBlackText);

  const ReaderBackground(this.label, this.background, this.textColor);

  /// Tên hiển thị.
  final String label;

  /// Màu nền trang đọc.
  final Color background;

  /// Màu chữ trên nền tương ứng.
  final Color textColor;

  /// Nền tối hay sáng (để chọn màu thanh công cụ phù hợp).
  bool get isDark => this == ReaderBackground.black;

  /// Lấy nền theo chỉ số lưu trong SharedPreferences (an toàn khi lỗi).
  static ReaderBackground fromIndex(int? index) {
    if (index == null || index < 0 || index >= values.length) {
      return ReaderBackground.white;
    }
    return values[index];
  }
}

/// Cấu hình ThemeData sáng/tối cho toàn ứng dụng (Material 3).
class AppTheme {
  AppTheme._();

  /// Theme sáng.
  static ThemeData get light => _build(Brightness.light);

  /// Theme tối.
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: scheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }

  /// Khoảng cách chuẩn dùng chung.
  static const double gap = 16;
  static const double smallGap = 8;
  static const BorderRadius coverRadius = BorderRadius.all(Radius.circular(8));
}
