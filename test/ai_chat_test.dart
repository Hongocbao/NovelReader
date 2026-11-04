import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:novel_reader/models/ai_chat_message.dart';
import 'package:novel_reader/services/ai_reader_service.dart';
import 'package:novel_reader/services/gemini_chat_client.dart';
import 'package:novel_reader/widgets/reader/ai_chat_bubble.dart';
import 'package:novel_reader/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

http.Response answer(String text) => http.Response.bytes(
  utf8.encode(
    jsonEncode({
      'candidates': [
        {
          'content': {
            'parts': [
              {'text': text},
            ],
          },
          'finishReason': 'STOP',
        },
      ],
    }),
  ),
  200,
);

AiReaderService serviceFor(
  Future<http.Response> Function(http.Request) handler,
) => AiReaderService(client: GeminiChatClient(client: MockClient(handler)));

void main() {
  test('AQ key goes directly to Vertex; free questions have no invented book context', () async {
    var calls = 0;
    final service = serviceFor((request) async {
      calls++;
      expect(request.url.host, 'aiplatform.googleapis.com');
      expect(request.url.queryParameters['key'], 'AQ.test-only');
      final body = jsonDecode(request.body) as Map;
      final instruction =
          body['systemInstruction']['parts'][0]['text'] as String;
      expect(instruction, contains('câu hỏi tự do'));
      expect(instruction, isNot(contains('ten_truyen')));
      expect(body['contents'], hasLength(1));
      expect(body['contents'][0]['parts'][0]['text'], 'Giải thích phép cộng');
      return answer('Phép cộng giúp tính tổng.');
    });
    final reply = await service.generateReply(
      prompt: 'Giải thích phép cộng',
      geminiApiKey: 'AQ.test-only',
    );
    expect(reply.content, 'Phép cộng giúp tính tổng.');
    expect(reply.isError, isFalse);
    expect(calls, 1);
  });

  test('AI Studio uses its API; history excludes welcome/errors and current prompt occurs once', () async {
    final service = serviceFor((request) async {
      expect(request.url.host, 'generativelanguage.googleapis.com');
      expect(request.headers['x-goog-api-key'], 'AIza-test');
      final contents = jsonDecode(request.body)['contents'] as List;
      expect(contents.map((c) => c['role']).toList(), [
        'user',
        'model',
        'user',
      ]);
      final serialized = jsonEncode(contents);
      expect(serialized, isNot(contains('welcome')));
      expect(serialized, isNot(contains('quota-error')));
      expect('câu hỏi sau'.allMatches(serialized), hasLength(1));
      return answer('Đây là câu trả lời tiếp theo.');
    });
    await service.generateReply(
      prompt: 'câu hỏi sau',
      geminiApiKey: 'AIza-test',
      history: [
        AiChatMessage.ai('welcome', includeInContext: false),
        AiChatMessage.user('câu hỏi đầu'),
        AiChatMessage.ai('trả lời đầu'),
        AiChatMessage.ai('quota-error', isError: true),
        AiChatMessage.user('câu hỏi sau'),
      ],
    );
  });

  test('reads all text parts, excluding model thoughts', () async {
    final client = GeminiChatClient(
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'candidates': [
              {
                'content': {
                  'parts': [
                    {'text': 'internal', 'thought': true},
                    {'text': 'Đoạn một'},
                    {'text': 'Đoạn hai'},
                  ],
                },
              },
            ],
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      ),
    );
    expect(
      await client.reply(apiKey: 'fake', query: 'test'),
      'Đoạn một\nĐoạn hai',
    );
  });

  test('quota and disabled API produce explicit retryable errors, no canned answer', () async {
    for (final status in [429, 403]) {
      final service = serviceFor(
        (_) async => http.Response(
          status == 403
              ? 'aiplatform.googleapis.com has not been used or disabled'
              : '{}',
          status,
        ),
      );
      final reply = await service.generateReply(
        prompt: '2+3?',
        geminiApiKey: 'AQ.test',
      );
      expect(reply.isError, isTrue);
      expect(reply.includeInContext, isFalse);
      expect(
        reply.content,
        contains(status == 429 ? 'hạn mức' : 'chưa bật Vertex AI API'),
      );
      expect(reply.content, isNot(contains('AQ.test')));
    }
  });

  test('network failure and empty response show a clear error', () async {
    for (final handler in <Future<http.Response> Function(http.Request)>[
      (_) async => throw http.ClientException('private URL/key'),
      (_) async => http.Response('{"candidates":[]}', 200),
    ]) {
      final reply = await serviceFor(handler)
          .generateReply(prompt: 'Xin chào', geminiApiKey: 'secret');
      expect(reply.isError, isTrue);
      expect(reply.content, isNot(contains('private')));
      expect(reply.content, isNot(contains('secret')));
    }
  });

  test('general chat without key requests configuration and history is scoped to account', () async {
    final service = AiReaderService();
    expect((await service.generateReply(prompt: 'Xin chào')).isError, isTrue);
    service.saveHistory(0, [AiChatMessage.user('riêng tư')], owner: 'a');
    expect(service.getHistory(0, owner: 'b'), isEmpty);
    expect(service.getHistory(1, owner: 'a'), isEmpty);
    service.clearHistory(0, owner: 'b');
    expect(service.getHistory(0, owner: 'a'), hasLength(1));
  });

  Future<void> openChat(WidgetTester tester, AiReaderService service) async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsProvider(await SharedPreferences.getInstance());
    await settings.setGeminiApiKey('AQ.fake');
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: settings,
        child: MaterialApp(
          home: Scaffold(
            body: Stack(children: [AiChatBubble(service: service)]),
          ),
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.smart_toy_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  Future<void> send(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.tap(find.byTooltip('Gửi câu hỏi'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets(
    'mobile free chat retries once, remembers answers when reopened, and copies text',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var calls = 0;
      final service = serviceFor(
        (_) async =>
            ++calls == 1 ? http.Response('{}', 429) : answer('Kết quả là 5.'),
      );
      await openChat(tester, service);
      expect(find.text('Trợ lý AI NovelReader'), findsOneWidget);
      await send(tester, '2 + 3 bằng mấy?');
      expect(find.text('Thử lại'), findsOneWidget);
      await tester.ensureVisible(find.text('Thử lại'));
      await tester.tap(find.text('Thử lại'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(calls, 2);
      expect(service.getHistory(0).where((m) => m.isUser), hasLength(1));
      expect(find.text('Kết quả là 5.'), findsOneWidget);
      expect(find.text('Sao chép'), findsOneWidget);
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
            if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String;
            }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await tester.ensureVisible(find.text('Sao chép'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.text('Sao chép'));
      await tester.pump();
      expect(copied, 'Kết quả là 5.');
      ScaffoldMessenger.of(tester.element(find.byType(AiChatBubble)))
          .hideCurrentSnackBar();
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Đóng'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.smart_toy_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Kết quả là 5.'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('reset discards late replies and duplicate send is ignored', (
    tester,
  ) async {
    final pending = Completer<http.Response>();
    var calls = 0;
    final service = serviceFor((_) {
      calls++;
      return pending.future;
    });
    await openChat(tester, service);
    await send(tester, 'Câu hỏi cũ');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    expect(calls, 1);
    await tester.tap(find.byTooltip('Làm mới cuộc trò chuyện'));
    await tester.pump();
    pending.complete(answer('Phản hồi cũ phải bị bỏ qua'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      service.getHistory(0).any((m) => m.content.contains('Phản hồi cũ')),
      isFalse,
    );
    expect(find.text('AI đang trả lời…'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'bubble stays in its parent bounds on resize and keyboard keeps input visible',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      await openChat(tester, serviceFor((_) async => answer('Chào bạn')));
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pump();
      expect(
        tester.getBottomLeft(find.byType(TextField)).dy,
        lessThanOrEqualTo(500),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 180,
              height: 100,
              child: Stack(children: [AiChatBubble()]),
            ),
          ),
        ),
      );
      await tester.pump();
      final rect = tester.getRect(find.byIcon(Icons.smart_toy_rounded));
      expect(rect.right, lessThanOrEqualTo(180));
      expect(rect.bottom, lessThanOrEqualTo(100));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
