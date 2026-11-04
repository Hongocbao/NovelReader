import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:novel_reader/services/gemini_tts_service.dart';
import 'package:novel_reader/services/tts_playback.dart';
import 'package:novel_reader/providers/settings_provider.dart';
import 'package:novel_reader/widgets/reader/tts_api_key_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

http.Response audioReply(
  http.Request request, {
  int marker = 1,
  int status = 200,
}) => http.Response(
  jsonEncode({
    'candidates': [
      {
        'content': {
          'parts': [
            {'text': 'metadata'},
            {
              'inlineData': {
                'mimeType': 'audio/L16;rate=24000',
                'data': base64Encode([marker, 0, marker, 0]),
              },
            },
          ],
        },
      },
    ],
  }),
  status,
  request: request,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

String requestedVoice(http.Request request) =>
    jsonDecode(
          request.body,
        )['generationConfig']['speechConfig']['voiceConfig']['prebuiltVoiceConfig']['voiceName']
        as String;
String requestedText(http.Request request) =>
    (jsonDecode(request.body)['contents'][0]['parts'][0]['text'] as String)
        .split('\nTEXT:\n')
        .last;

class _Output implements TtsAudioOutput {
  final markers = <int>[];
  final rates = <double>[];
  bool hold = false;
  Completer<void>? playing;
  @override
  Future<void> play(
    Uint8List bytes,
    double rate, {
    void Function()? onStarted,
  }) async {
    markers.add(bytes[44]);
    rates.add(rate);
    final done = Completer<void>();
    playing = done;
    onStarted?.call();
    if (hold) await done.future;
  }

  @override
  Future<void> stop() async {
    final done = playing;
    playing = null;
    if (done != null && !done.isCompleted) done.complete();
  }
}

void main() {
  Future<void> drain() => Future<void>.delayed(Duration.zero);

  testWidgets('voice key dialog saves a new key and rejects an empty value', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsProvider(await SharedPreferences.getInstance());
    addTearDown(settings.dispose);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: settings,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => const TtsApiKeyDialog(),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final field = find.byKey(const ValueKey('tts-api-key'));
    expect(tester.widget<TextField>(field).obscureText, isTrue);
    await tester.enterText(field, '');
    await tester.tap(find.text('Lưu khóa'));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập khóa Gemini.'), findsOneWidget);
    await tester.enterText(field, 'fake-key-for-local-test');
    await tester.tap(find.text('Lưu khóa'));
    await tester.pumpAndSettle();
    expect(settings.geminiApiKey, 'fake-key-for-local-test');
    expect(find.byType(TtsApiKeyDialog), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  test('splits long Vietnamese text without losing text or breaking emoji', () {
    final text = List.generate(
      150,
      (i) => 'Đoạn $i có tiếng Việt và 📖. ',
    ).join();
    final chunks = splitTtsText(text);
    expect(chunks.length, greaterThan(3));
    expect(chunks.join(), text.trim());
    expect(chunks.every((c) => c.length <= 550), isTrue);
    for (final chunk in chunks) {
      expect(utf8.decode(utf8.encode(chunk)), chunk);
    }
    expect(splitTtsText('x' * 2000).join(), 'x' * 2000);
  });

  test(
    'all eight selections send their exact voice to the same audio API',
    () async {
      final requests = <http.Request>[];
      final service = GeminiTtsService(
        client: MockClient((r) async {
          requests.add(r);
          return audioReply(r);
        }),
      );
      for (final voice in [
        'Aoede',
        'Charon',
        'Orus',
        'Fenrir',
        'Puck',
        'Leda',
        'Zephyr',
        'Kore',
      ]) {
        final wav = await service.synthesize(
          'Xin chào.',
          voiceId: voice,
          stylePrompt: 'Gentle Vietnamese',
          apiKey: 'fake-key',
        );
        expect(ascii.decode(wav.sublist(0, 4)), 'RIFF');
        expect(requestedVoice(requests.last), voice);
        expect(requests.last.headers['x-goog-api-key'], 'fake-key');
        expect(requests.last.url.queryParameters.containsKey('key'), isFalse);
      }
      expect(requests, hasLength(8));
    },
  );

  test(
    'prefetch and playback deduplicate only matching voice, style and key',
    () async {
      final requests = <http.Request>[];
      final gate = Completer<http.Response>();
      final service = GeminiTtsService(
        client: MockClient((r) {
          requests.add(r);
          return requests.length == 1
              ? gate.future
              : Future.value(audioReply(r));
        }),
      );
      final preload = service.prefetch(
        'Same text',
        voiceId: 'Kore',
        stylePrompt: 'warm',
        apiKey: 'a',
      );
      final playing = service.synthesize(
        'Same text',
        voiceId: 'Kore',
        stylePrompt: 'warm',
        apiKey: 'a',
      );
      await drain();
      expect(requests, hasLength(1));
      gate.complete(audioReply(requests.single));
      await preload;
      await playing;
      await service.synthesize(
        'Same text',
        voiceId: 'Kore',
        stylePrompt: 'warm',
        apiKey: 'a',
      );
      expect(requests, hasLength(1));
      await service.synthesize(
        'Same text',
        voiceId: 'Kore',
        stylePrompt: 'solemn',
        apiKey: 'a',
      );
      await service.synthesize(
        'Same text',
        voiceId: 'Kore',
        stylePrompt: 'warm',
        apiKey: 'b',
      );
      await service.synthesize(
        'Same text',
        voiceId: 'Aoede',
        stylePrompt: 'warm',
        apiKey: 'a',
      );
      expect(requests, hasLength(4));
    },
  );

  test('actual read is prioritized before queued prefetch without concurrent quota calls', () async {
    final requests = <http.Request>[];
    final gate = Completer<http.Response>();
    final service = GeminiTtsService(
      client: MockClient((r) {
        requests.add(r);
        return requests.length == 1 ? gate.future : Future.value(audioReply(r));
      }),
    );
    final a = service.prefetch(
      'first',
      voiceId: 'Aoede',
      stylePrompt: '',
      apiKey: 'key',
    );
    final b = service.prefetch(
      'unused next',
      voiceId: 'Aoede',
      stylePrompt: '',
      apiKey: 'key',
    );
    final c = service.synthesize(
      'read now',
      voiceId: 'Kore',
      stylePrompt: '',
      apiKey: 'key',
    );
    await drain();
    expect(requests, hasLength(1));
    gate.complete(audioReply(requests.first));
    await Future.wait([a, b, c]);
    expect(requests.map(requestedText), ['first', 'read now', 'unused next']);
  });

  test(
    'API failures stop rather than advancing paragraphs or changing engines',
    () async {
      final output = _Output();
      var failed = true;
      final service = GeminiTtsService(
        client: MockClient(
          (r) async => audioReply(r, status: failed ? 429 : 200),
        ),
      );
      final playback = TtsPlayback(service, output);
      var completed = 0;
      String? error;
      await playback.speak(
        'Chapter',
        voiceId: 'Kore',
        stylePrompt: 'warm',
        apiKey: 'key',
        onComplete: () => completed++,
        onError: (e) => error = e,
      );
      expect(error, contains('giới hạn'));
      expect(completed, 0);
      expect(output.markers, isEmpty);
      failed = false;
      await playback.speak(
        'Chapter',
        voiceId: 'Kore',
        stylePrompt: 'warm',
        apiKey: 'key',
        onComplete: () => completed++,
      );
      expect(output.markers, hasLength(1));
      expect(completed, 1);
    },
  );

  test(
    'long paragraph reads every chunk with one voice and completes once',
    () async {
      final requests = <http.Request>[];
      final service = GeminiTtsService(
        client: MockClient((r) async {
          requests.add(r);
          return audioReply(r);
        }),
      );
      final output = _Output();
      final playback = TtsPlayback(service, output);
      final text = List.generate(90, (i) => 'Nội dung thứ $i. ').join().trim();
      var completed = 0, started = 0;
      await playback.speak(
        text,
        voiceId: 'Fenrir',
        stylePrompt: 'mysterious',
        apiKey: 'key',
        rate: 1.1,
        onStarted: () => started++,
        onComplete: () => completed++,
      );
      expect(requests.map(requestedText).join(), text);
      expect(requests.map(requestedVoice).toSet(), {'Fenrir'});
      expect(output.markers.length, splitTtsText(text).length);
      expect(output.rates.toSet(), {1.1});
      expect(completed, 1);
      expect(started, 1);
    },
  );

  test('late demo fetch cannot replace the selected chapter voice', () async {
    final requests = <http.Request>[];
    final gate = Completer<http.Response>();
    final service = GeminiTtsService(
      client: MockClient((r) {
        requests.add(r);
        return requests.length == 1
            ? gate.future
            : Future.value(audioReply(r, marker: 2));
      }),
    );
    final output = _Output();
    final playback = TtsPlayback(service, output);
    var oldComplete = 0;
    final demo = playback.speak(
      'demo',
      voiceId: 'Aoede',
      stylePrompt: 'warm',
      apiKey: 'key',
      onComplete: () => oldComplete++,
    );
    await drain();
    final chapter = playback.speak(
      'chapter',
      voiceId: 'Kore',
      stylePrompt: 'firm',
      apiKey: 'key',
    );
    await drain();
    gate.complete(audioReply(requests.first));
    await Future.wait([demo, chapter]);
    expect(output.markers, [2]);
    expect(requestedVoice(requests.last), 'Kore');
    expect(oldComplete, 0);
  });

  test('stop and changing voice invalidate old completion callbacks', () async {
    final output = _Output()..hold = true;
    final playback = TtsPlayback(
      GeminiTtsService(client: MockClient((r) async => audioReply(r))),
      output,
    );
    var completed = 0;
    final old = playback.speak(
      'old',
      voiceId: 'Aoede',
      stylePrompt: '',
      apiKey: 'key',
      onComplete: () => completed++,
    );
    await drain();
    await playback.stop();
    await old;
    expect(completed, 0);
    final next = playback.speak(
      'next',
      voiceId: 'Kore',
      stylePrompt: '',
      apiKey: 'key',
      onComplete: () => completed++,
    );
    await drain();
    output.playing!.complete();
    await next;
    expect(completed, 1);
  });

  test('PCM wrapping and WAV passthrough use a valid sample rate', () async {
    final wav = pcmToWav(Uint8List.fromList([1, 0, 2, 0]), sampleRate: 22050);
    final header = ByteData.sublistView(wav);
    expect(header.getUint32(24, Endian.little), 22050);
    expect(header.getUint32(40, Endian.little), 4);
    final service = GeminiTtsService(
      client: MockClient(
        (r) async => http.Response(
          jsonEncode({
            'candidates': [
              {
                'content': {
                  'parts': [
                    {
                      'inlineData': {
                        'mimeType': 'audio/wav',
                        'data': base64Encode(wav),
                      },
                    },
                  ],
                },
              },
            ],
          }),
          200,
          request: r,
          headers: {'content-type': 'application/json'},
        ),
      ),
    );
    expect(
      await service.synthesize(
        'sample',
        voiceId: 'Kore',
        stylePrompt: '',
        apiKey: 'key',
      ),
      wav,
    );
    expect(() => pcmToWav(Uint8List(3)), throwsA(isA<TtsFailure>()));
  });
}
