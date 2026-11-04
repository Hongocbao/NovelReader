import 'dart:async';
import 'dart:typed_data';

import 'gemini_tts_service.dart';

abstract interface class TtsAudioOutput {
  Future<void> play(Uint8List audio, double rate, {void Function()? onStarted});
  Future<void> stop();
}

class TtsPlayback {
  TtsPlayback(this.service, this.output);
  final GeminiTtsService service;
  final TtsAudioOutput output;
  int _generation = 0;

  Future<void> stop() async {
    _generation++;
    await _stopOutput();
  }

  Future<void> _stopOutput() async {
    try {
      await output.stop();
    } catch (_) {
      /* Cancel UI/session regardless. */
    }
  }

  Future<void> speak(
    String text, {
    required String voiceId,
    required String stylePrompt,
    required String apiKey,
    double rate = 1,
    void Function()? onStarted,
    void Function()? onComplete,
    void Function(String)? onError,
  }) async {
    final generation = ++_generation;
    bool current() => generation == _generation;
    try {
      await _stopOutput();
      if (!current()) return;
      final chunks = splitTtsText(text);
      for (var index = 0; index < chunks.length; index++) {
        final audio = await service.synthesize(
          chunks[index],
          voiceId: voiceId,
          stylePrompt: stylePrompt,
          apiKey: apiKey,
        );
        if (!current()) return;
        if (index + 1 < chunks.length) {
          unawaited(
            service.prefetch(
              chunks[index + 1],
              voiceId: voiceId,
              stylePrompt: stylePrompt,
              apiKey: apiKey,
            ),
          );
        }
        await output.play(
          audio,
          rate.clamp(0.5, 2.0),
          onStarted: () {
            if (current() && index == 0) onStarted?.call();
          },
        );
        if (!current()) return;
      }
      if (current()) onComplete?.call();
    } catch (error) {
      if (current()) {
        await _stopOutput();
        if (!current()) return;
        onError?.call(
          error is TtsFailure
              ? error.message
              : 'Không phát được giọng AI. Hãy bấm đọc lại.',
        );
      }
    }
  }
}
