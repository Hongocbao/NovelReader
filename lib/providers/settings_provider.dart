import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/reader_settings.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

/// Quản lý theme sáng/tối và cài đặt đọc; mọi thay đổi được lưu ngay
/// vào SharedPreferences nên vẫn còn sau khi khởi động lại app.
class SettingsProvider extends ChangeNotifier {
  /// [prefs] được khởi tạo sẵn trong main() nên đọc cài đặt đồng bộ.
  SettingsProvider(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;

  ThemeMode _themeMode = ThemeMode.system;
  ReaderSettings _reader = const ReaderSettings();
  bool _forceOffline = false;

  ThemeMode get themeMode => _themeMode;
  ReaderSettings get reader => _reader;

  /// Bật chế độ offline giả lập (để thử đọc chương đã tải).
  bool get forceOffline => _forceOffline;

  /// Đọc toàn bộ cài đặt đã lưu.
  void _load() {
    final themeIndex = _prefs.getInt(PrefKeys.themeMode) ?? 0;
    _themeMode = ThemeMode.values[themeIndex.clamp(0, ThemeMode.values.length - 1)];
    _reader = ReaderSettings.fromMap({
      'font_size': _prefs.getDouble(PrefKeys.fontSize),
      'font_family': _prefs.getString(PrefKeys.fontFamily),
      'line_height': _prefs.getDouble(PrefKeys.lineHeight),
      'justify': _prefs.getBool(PrefKeys.textAlign),
      'background': _prefs.getInt(PrefKeys.background),
      'brightness': _prefs.getDouble(PrefKeys.brightness),
      'keep_screen_on': _prefs.getBool(PrefKeys.keepScreenOn),
      'horizontal_page_mode': _prefs.getBool(PrefKeys.pageMode),
      'show_ai_bubble': _prefs.getBool(PrefKeys.showAiBubble),
    });
    _forceOffline = _prefs.getBool(PrefKeys.forceOffline) ?? false;
  }

  /// Đổi chế độ giao diện sáng/tối/theo hệ thống.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
    await _prefs.setInt(PrefKeys.themeMode, mode.index);
  }

  /// Cập nhật cài đặt đọc (có hiệu lực ngay) và lưu lại.
  Future<void> updateReader(ReaderSettings settings) async {
    if (settings == _reader) return;
    _reader = settings;
    notifyListeners();
    await Future.wait([
      _prefs.setDouble(PrefKeys.fontSize, settings.fontSize),
      _prefs.setString(PrefKeys.fontFamily, settings.fontFamily),
      _prefs.setDouble(PrefKeys.lineHeight, settings.lineHeight),
      _prefs.setBool(PrefKeys.textAlign, settings.justify),
      _prefs.setInt(PrefKeys.background, settings.background.index),
      _prefs.setDouble(PrefKeys.brightness, settings.brightness),
      _prefs.setBool(PrefKeys.keepScreenOn, settings.keepScreenOn),
      _prefs.setBool(PrefKeys.pageMode, settings.horizontalPageMode),
      _prefs.setBool(PrefKeys.showAiBubble, settings.showAiBubble),
    ]);
  }

  // Các hàm tiện ích cho từng thuộc tính
  Future<void> setFontSize(double v) => updateReader(_reader.copyWith(
      fontSize: v
          .clamp(ReaderLimits.minFontSize, ReaderLimits.maxFontSize)
          .roundToDouble()));
  Future<void> setFontFamily(String v) =>
      updateReader(_reader.copyWith(fontFamily: v));
  Future<void> setLineHeight(double v) => updateReader(_reader.copyWith(
      lineHeight: double.parse(v
          .clamp(ReaderLimits.minLineHeight, ReaderLimits.maxLineHeight)
          .toStringAsFixed(1))));
  Future<void> setJustify(bool v) => updateReader(_reader.copyWith(justify: v));
  Future<void> setBackground(ReaderBackground v) =>
      updateReader(_reader.copyWith(background: v));
  Future<void> setBrightness(double v) => updateReader(_reader.copyWith(
      brightness:
          v.clamp(ReaderLimits.minBrightness, ReaderLimits.maxBrightness)));
  Future<void> setKeepScreenOn(bool v) =>
      updateReader(_reader.copyWith(keepScreenOn: v));
  Future<void> setHorizontalPageMode(bool v) =>
      updateReader(_reader.copyWith(horizontalPageMode: v));
  Future<void> setShowAiBubble(bool v) =>
      updateReader(_reader.copyWith(showAiBubble: v));

  /// Khôi phục cài đặt đọc mặc định.
  Future<void> resetReader() => updateReader(const ReaderSettings());

  /// Bật/tắt chế độ offline giả lập.
  Future<void> setForceOffline(bool value) async {
    if (value == _forceOffline) return;
    _forceOffline = value;
    notifyListeners();
    await _prefs.setBool(PrefKeys.forceOffline, value);
  }
}
