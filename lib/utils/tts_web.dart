import 'dart:js_interop';
import 'package:web/web.dart' as web;

/// Phát giọng đọc tiếng Việt bằng Web Speech API của trình duyệt,
/// kích hoạt [onComplete] ngay khi trình duyệt đọc xong câu (`onend`).
Future<void> speakTextPlatform(
  String text, {
  double rate = 1.0,
  void Function()? onComplete,
}) async {
  try {
    final synth = web.window.speechSynthesis;
    synth.cancel();
    final utter = web.SpeechSynthesisUtterance(text)
      ..lang = 'vi-VN'
      ..rate = rate;
    if (onComplete != null) {
      utter.onend = ((web.Event _) {
        onComplete();
      }).toJS;
      utter.onerror = ((web.Event _) {
        onComplete();
      }).toJS;
    }
    synth.speak(utter);
  } catch (_) {
    onComplete?.call();
  }
}

/// Dừng phát giọng nói trên trình duyệt.
Future<void> stopSpeechPlatform() async {
  try {
    web.window.speechSynthesis.cancel();
  } catch (_) {}
}
