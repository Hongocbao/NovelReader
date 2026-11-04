import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../providers/settings_provider.dart';
import '../services/gemini_tts_service.dart';
import '../services/tts_playback.dart';

class _PlayerOutput implements TtsAudioOutput {
  AudioPlayer? _sharedPlayer;
  Completer<void>? _finished;
  int _playToken = 0;

  AudioPlayer _ensurePlayer() => _sharedPlayer ??= AudioPlayer();

  @override
  Future<void> play(
    Uint8List audio,
    double rate, {
    void Function()? onStarted,
  }) async {
    final token = ++_playToken;
    final prevFinished = _finished;
    if (prevFinished != null && !prevFinished.isCompleted) {
      prevFinished.complete();
    }
    final player = _ensurePlayer();
    final finished = Completer<void>();
    _finished = finished;
    final completeSub = player.onPlayerComplete.listen((_) {
      if (!finished.isCompleted) finished.complete();
    });
    final events = player.eventStream.listen(
      (event) {
        if (event.eventType == AudioEventType.complete &&
            !finished.isCompleted) {
          finished.complete();
        }
      },
      onError: (Object error, StackTrace stack) {
        if (!finished.isCompleted) finished.completeError(error, stack);
      },
    );
    try {
      // Attach an error listener immediately, even while the native source loads.
      final completion = finished.future;
      unawaited(completion.catchError((Object _) {}));
      try {
        await player.stop();
      } catch (_) {}
      if (token != _playToken) return;
      await player.play(BytesSource(audio, mimeType: 'audio/wav'));
      if (token != _playToken) {
        await player.stop();
        return;
      }
      try {
        await player.setPlaybackRate(rate);
      } catch (_) {}
      if (token == _playToken) onStarted?.call();
      await completion;
    } finally {
      if (identical(_finished, finished)) {
        _finished = null;
      }
      await completeSub.cancel();
      await events.cancel();
    }
  }

  @override
  Future<void> stop() async {
    _playToken++;
    final player = _sharedPlayer;
    final finished = _finished;
    _finished = null;
    if (finished != null && !finished.isCompleted) finished.complete();
    if (player != null) {
      try {
        await player.stop();
      } catch (_) {}
    }
  }
}

final _service = GeminiTtsService();
final _playback = TtsPlayback(_service, _PlayerOutput());
TtsPlayback? _testingPlayback;
TtsPlayback get _currentPlayback => _testingPlayback ?? _playback;

@visibleForTesting
void overrideTtsPlaybackForTesting(TtsPlayback? playback) {
  _testingPlayback = playback;
}

Future<void> speakTextPlatform(
  String text, {
  double rate = 1,
  double pitch = 1,
  String preferredGender = 'any',
  String voiceId = 'Aoede',
  String stylePrompt = '',
  String apiKey = '',
  void Function()? onComplete,
  void Function()? onStarted,
  void Function(String)? onError,
}) => _currentPlayback.speak(
  text,
  voiceId: voiceId,
  stylePrompt: stylePrompt,
  apiKey: apiKey.trim().isEmpty ? SettingsProvider.defaultGeminiApiKey : apiKey,
  rate: rate,
  onComplete: onComplete,
  onStarted: onStarted,
  onError: onError,
);

Future<void> prefetchTextPlatform(
  String text, {
  String voiceId = 'Aoede',
  String stylePrompt = '',
  String apiKey = '',
}) => _currentPlayback.service.prefetch(
  text,
  voiceId: voiceId,
  stylePrompt: stylePrompt,
  apiKey: apiKey.trim().isEmpty ? SettingsProvider.defaultGeminiApiKey : apiKey,
);

Future<void> stopSpeechPlatform() => _currentPlayback.stop();
