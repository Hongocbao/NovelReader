import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class TtsFailure implements Exception {
  const TtsFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Keeps every character, splitting on natural boundaries without truncating.
List<String> splitTtsText(String text, {int limit = 550}) {
  if (limit < 2) throw ArgumentError.value(limit, 'limit');
  text = text.trim();
  final chunks = <String>[];
  var start = 0;
  while (start < text.length) {
    var end = (start + limit).clamp(0, text.length);
    if (end < text.length) {
      final boundaries = RegExp(r'[\s.!?;。]')
          .allMatches(text.substring(start, end));
      if (boundaries.isNotEmpty && boundaries.last.end >= limit ~/ 2) {
        end = start + boundaries.last.end;
      }
      // Never split a UTF-16 surrogate pair (e.g. emoji).
      if (end < text.length &&
          text.codeUnitAt(end) >= 0xDC00 &&
          text.codeUnitAt(end) <= 0xDFFF) {
        end--;
      }
    }
    chunks.add(text.substring(start, end));
    start = end;
  }
  return chunks;
}

typedef _AudioKey = ({String text, String voice, String style, String key});

class _Job {
  _Job(this.key);
  final _AudioKey key;
  final result = Completer<Uint8List>();
}

/// One shared request/cache path for samples and chapter playback, on all OSes.
class GeminiTtsService {
  GeminiTtsService({http.Client? client})
    : _client = client ?? http.Client(),
      _hasCustomClient = client != null;
  final http.Client _client;
  final bool _hasCustomClient;
  static const model = String.fromEnvironment(
    'GEMINI_TTS_MODEL',
    defaultValue: 'gemini-3.8-flash-lite-tts',
  );
  static const List<String> _liveModels = [
    'gemini-3.8-flash-lite-tts',
    'gemini-3.8-flash-tts',
    'gemini-3.1-flash-tts-preview',
    'gemini-2.5-flash-preview-tts',
  ];
  static const String _defaultApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
  );
  final Set<String> _dailyExhaustedModels = {};
  int _roundRobinIndex = 0;
  final _cache = <_AudioKey, Uint8List>{};
  final _jobs = <_AudioKey, _Job>{};
  final _queue = <_Job>[];
  int _cacheBytes = 0;
  bool _running = false;

  Future<Uint8List> synthesize(
    String text, {
    required String voiceId,
    required String stylePrompt,
    required String apiKey,
    bool priority = true,
  }) {
    if (apiKey.trim().isEmpty) {
      return Future.error(
        const TtsFailure('Chưa có khóa Gemini cho giọng đọc AI.'),
      );
    }
    final key = (
      text: text,
      voice: voiceId,
      style: stylePrompt,
      key: apiKey.trim(),
    );
    final cached = _cache.remove(key);
    if (cached != null) {
      _cache[key] = cached;
      return Future.value(cached);
    }
    var job = _jobs[key];
    if (job != null) {
      if (priority && _queue.remove(job)) _queue.insert(0, job);
      return job.result.future;
    }
    job = _Job(key);
    _jobs[key] = job;
    if (priority) {
      _queue.insert(0, job);
    } else {
      _queue.add(job);
    }
    unawaited(_drain());
    return job.result.future;
  }

  Future<void> prefetch(
    String text, {
    required String voiceId,
    required String stylePrompt,
    required String apiKey,
  }) async {
    final chunks = splitTtsText(text);
    if (chunks.isEmpty) return;
    try {
      await synthesize(
        text.length <= 550 ? text : chunks.first,
        voiceId: voiceId,
        stylePrompt: stylePrompt,
        apiKey: apiKey,
        priority: false,
      );
    } catch (_) {
      /* Actual playback reports failures; prefetch never advances. */
    }
  }

  Future<void> _drain() async {
    if (_running) return;
    _running = true;
    try {
      while (_queue.isNotEmpty) {
        final job = _queue.removeAt(0);
        try {
          final bytes = await _fetch(job.key);
          if (bytes.length <= 16 * 1024 * 1024) {
            while (_cache.isNotEmpty &&
                (_cache.length >= 24 ||
                    _cacheBytes + bytes.length > 16 * 1024 * 1024)) {
              _cacheBytes -= _cache.remove(_cache.keys.first)!.length;
            }
            _cache[job.key] = bytes;
            _cacheBytes += bytes.length;
          }
          job.result.complete(bytes);
        } catch (error, stack) {
          job.result.completeError(error, stack);
        } finally {
          _jobs.remove(job.key);
        }
      }
    } finally {
      _running = false;
    }
  }

  Future<Uint8List> _fetch(_AudioKey key) async {
    if (_hasCustomClient) {
      return _fetchSingleModel(key, modelName: model, apiKey: key.key);
    }

    final activeModels = _liveModels
        .where((m) => !_dailyExhaustedModels.contains(m))
        .toList();
    final modelsToTry = activeModels.isEmpty ? _liveModels : activeModels;
    final startIdx = _roundRobinIndex++ % modelsToTry.length;
    final orderedModels = <String>[
      ...modelsToTry.sublist(startIdx),
      ...modelsToTry.sublist(0, startIdx),
    ];

    final keysToTry = <String>[
      key.key,
      if (_defaultApiKey.isNotEmpty && key.key != _defaultApiKey)
        _defaultApiKey,
    ];

    TtsFailure? lastFailure;
    for (var pass = 0; pass < 2; pass++) {
      if (pass == 1) {
        await Future<void>.delayed(const Duration(milliseconds: 1600));
      }
      for (final apiKeyCandidate in keysToTry) {
        for (final modelCandidate in orderedModels) {
          if (pass == 1 && _dailyExhaustedModels.contains(modelCandidate)) {
            continue;
          }
          try {
            return await _fetchSingleModel(
              key,
              modelName: modelCandidate,
              apiKey: apiKeyCandidate,
            );
          } on TtsFailure catch (failure) {
            lastFailure = failure;
          }
        }
      }
    }
    throw lastFailure ??
        const TtsFailure(
          'Không tải được giọng AI. Kiểm tra mạng rồi thử lại.',
        );
  }

  Future<Uint8List> _fetchSingleModel(
    _AudioKey key, {
    required String modelName,
    required String apiKey,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.https(
              'generativelanguage.googleapis.com',
              '/v1beta/models/$modelName:generateContent',
            ),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'x-goog-api-key': apiKey,
            },
            body: jsonEncode({
              'contents': [
                {
                  'role': 'user',
                  'parts': [
                    {
                      'text':
                          '${key.style}\nRead exactly the following Vietnamese text with one consistent speaker. '
                          'Do not imitate other speakers or add commentary.\nTEXT:\n${key.text}',
                    },
                  ],
                },
              ],
              'generationConfig': {
                'responseModalities': ['AUDIO'],
                'speechConfig': {
                  'voiceConfig': {
                    'prebuiltVoiceConfig': {'voiceName': key.voice},
                  },
                },
              },
            }),
          )
          .timeout(const Duration(seconds: 25));
      if (response.statusCode == 429) {
        final bodyLower = response.body.toLowerCase();
        if (bodyLower.contains('perday') ||
            bodyLower.contains('per_day') ||
            bodyLower.contains('per day')) {
          _dailyExhaustedModels.add(modelName);
        }
        throw const TtsFailure(
          'Giọng AI đang hết lượt hoặc bị giới hạn. Vui lòng thử lại sau.',
        );
      }
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const TtsFailure(
          'Khóa Gemini chưa được phép dùng giọng AI. Kiểm tra mục “Khóa giọng AI”.',
        );
      }
      if (response.statusCode != 200) {
        throw const TtsFailure(
          'Chưa tải được giọng AI đã chọn. Vui lòng thử lại.',
        );
      }
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final candidates = data['candidates'] as List? ?? const [];
      if (candidates.isNotEmpty) {
        final parts =
            candidates.first['content']?['parts'] as List? ?? const [];
        for (final part in parts) {
          final inline = part['inlineData'];
          if (inline is! Map || inline['data'] is! String) continue;
          final bytes = base64Decode(inline['data'] as String);
          if (bytes.length >= 12 &&
              ascii.decode(bytes.sublist(0, 4), allowInvalid: true) == 'RIFF') {
            return _sanitizeRiffWav(bytes);
          }
          final mime = inline['mimeType']?.toString().toLowerCase() ?? '';
          if (mime.contains('l16') || mime.contains('pcm')) {
            final rate =
                int.tryParse(
                  RegExp(r'rate=(\d+)').firstMatch(mime)?.group(1) ?? '',
                ) ??
                24000;
            return pcmToWav(bytes, sampleRate: rate);
          }
        }
      }
      throw const TtsFailure(
        'Dịch vụ chưa trả về âm thanh hợp lệ cho giọng đã chọn.',
      );
    } on TtsFailure {
      rethrow;
    } catch (_) {
      throw const TtsFailure(
        'Không tải được giọng AI. Kiểm tra mạng rồi thử lại.',
      );
    }
  }

  /// Loại bỏ chunk metadata phụ (như C2PA ở cuối file WAV của Gemini 3.8) để
  /// trình phát âm thanh trên Web & Android phát mượt 100%, giữ nguyên file WAV chuẩn 44-byte.
  Uint8List _sanitizeRiffWav(Uint8List bytes) {
    if (bytes.length < 44) return bytes;
    final header = ByteData.sublistView(bytes);
    final dataTag = ascii.decode(bytes.sublist(36, 40), allowInvalid: true);
    if (dataTag == 'data') {
      final dataSize = header.getUint32(40, Endian.little);
      final expectedEnd = 44 + dataSize;
      if (expectedEnd == bytes.length) {
        return bytes;
      }
      if (dataSize > 0 && expectedEnd < bytes.length && dataSize.isEven) {
        final sampleRate = header.getUint32(24, Endian.little);
        return pcmToWav(
          Uint8List.sublistView(bytes, 44, expectedEnd),
          sampleRate: (sampleRate >= 8000 && sampleRate <= 96000)
              ? sampleRate
              : 24000,
        );
      }
    }
    return bytes;
  }
}

Uint8List pcmToWav(Uint8List pcm, {int sampleRate = 24000}) {
  if (pcm.isEmpty ||
      pcm.length.isOdd ||
      sampleRate < 8000 ||
      sampleRate > 96000) {
    throw const TtsFailure('Dữ liệu âm thanh AI không hợp lệ.');
  }
  final wav = Uint8List(44 + pcm.length);
  final data = ByteData.sublistView(wav);
  wav.setRange(0, 4, ascii.encode('RIFF'));
  data.setUint32(4, 36 + pcm.length, Endian.little);
  wav.setRange(8, 12, ascii.encode('WAVE'));
  wav.setRange(12, 16, ascii.encode('fmt '));
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little);
  data.setUint16(22, 1, Endian.little);
  data.setUint32(24, sampleRate, Endian.little);
  data.setUint32(28, sampleRate * 2, Endian.little);
  data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little);
  wav.setRange(36, 40, ascii.encode('data'));
  data.setUint32(40, pcm.length, Endian.little);
  wav.setRange(44, wav.length, pcm);
  return wav;
}
