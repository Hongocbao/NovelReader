import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts _tts = FlutterTts();
bool _initialized = false;

Future<void> _ensureInit(double rate) async {
  if (!_initialized) {
    _initialized = true;
    await _tts.setLanguage('vi-VN');
    await _tts.awaitSpeakCompletion(true);
  }
  await _tts.setSpeechRate((rate * 0.5).clamp(0.25, 1.0));
}

/// Phát giọng đọc tiếng Việt trên Android / iOS / Desktop bằng `flutter_tts`
/// và gọi [onComplete] thông qua completion handler chính xác khi đọc xong đoạn.
Future<void> speakTextPlatform(
  String text, {
  double rate = 1.0,
  void Function()? onComplete,
}) async {
  try {
    await _ensureInit(rate);
    _tts.setCompletionHandler(() {
      onComplete?.call();
    });
    _tts.setErrorHandler((_) {
      onComplete?.call();
    });
    await _tts.stop();
    await _tts.speak(text);
  } catch (_) {
    // Trong môi trường unit test không có MethodChannel thực của plugin
    onComplete?.call();
  }
}

/// Dừng phát giọng đọc trên thiết bị di động.
Future<void> stopSpeechPlatform() async {
  try {
    await _tts.stop();
  } catch (_) {}
}
