/// Stub Text-to-Speech mặc định (dùng khi không khớp io hoặc js_interop).
Future<void> speakTextPlatform(
  String text, {
  double rate = 1.0,
  double pitch = 1.0,
  String preferredGender = 'any',
  String voiceId = 'Aoede',
  String stylePrompt = '',
  String apiKey = '',
  void Function()? onComplete,
  void Function()? onStarted,
  void Function(String)? onError,
}) async {
  onError?.call('Thiết bị này chưa hỗ trợ phát giọng đọc AI.');
}

/// Tải trước âm thanh đoạn tiếp theo vào bộ nhớ đệm.
Future<void> prefetchTextPlatform(
  String text, {
  String voiceId = 'Aoede',
  String stylePrompt = '',
  String apiKey = '',
}) async {}

/// Dừng phát giọng đọc trên stub.
Future<void> stopSpeechPlatform() async {}
