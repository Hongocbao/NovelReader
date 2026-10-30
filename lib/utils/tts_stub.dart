/// Stub Text-to-Speech mặc định (dùng khi không khớp io hoặc js_interop).
Future<void> speakTextPlatform(
  String text, {
  double rate = 1.0,
  void Function()? onComplete,
}) async {
  onComplete?.call();
}

/// Dừng phát giọng đọc trên stub.
Future<void> stopSpeechPlatform() async {}
