import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/models/ai_chat_message.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/providers/settings_provider.dart';
import 'package:novel_reader/services/ai_reader_service.dart';
import 'package:novel_reader/widgets/reader/ai_chat_bubble.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final novel = Novel(
    id: 1,
    title: 'Kiếm Đạo Vấn Thiên',
    author: 'Lâm Phong Vũ',
    coverUrl: '',
    description: 'Mô tả',
    status: 'ongoing',
    type: 'novel',
    genres: const ['Tiên hiệp'],
    totalChapters: 10,
    rating: 4.5,
    views: 1,
    updatedAt: DateTime(2026),
  );
  const chapter = Chapter(
    id: 10001,
    novelId: 1,
    chapterIndex: 1,
    title: 'Chương 1: Đệ tử tạp dịch',
  );
  const content = '【Chương 1 — Đệ tử tạp dịch】 Lục Trần quét sân ở Thanh Vân Tông.\n'
      'Trong đêm mưa, Lục Trần nhặt được thanh kiếm gãy.\n'
      'Đại Trưởng Lão của Thanh Vân Tông nhìn cậu đầy nghi hoặc.\n'
      'Một ngày mới bắt đầu.';

  Future<String> ask(String q) async => (await AiReaderService.instance
          .generateReply(
              prompt: q, novel: novel, chapter: chapter, chapterContent: content))
      .content;

  test('"Dự đoán tình tiết tiếp theo" trả về dự đoán, không phải giải thích',
      () async {
    expect(await ask('🔮 Dự đoán tình tiết tiếp theo'), contains('Dự đoán'));
    expect(await ask('🔮 Tương lai nhân vật này'), contains('Dự đoán'));
  });

  test('trích đúng tên riêng có dấu, bỏ từ đầu câu', () async {
    final r = await ask('Nhân vật chính là ai');
    expect(r, contains('Lục Trần'));
    expect(r, contains('Thanh Vân Tông'));
    expect(r, contains('Đại Trưởng Lão'));
    expect(r, isNot(contains('Một ngày')));
  });

  test('tóm tắt bỏ phần tiêu đề 【...】', () async {
    final r = await ask('Tóm tắt chương này');
    expect(r, isNot(contains('【')));
    expect(r, contains('Lục Trần quét sân'));
  });

  test('lưu và xóa lịch sử chat theo từng bộ truyện', () {
    final service = AiReaderService.instance;
    service.clearHistory(1);
    expect(service.getHistory(1), isEmpty);

    service.saveHistory(1, [AiChatMessage.user('Xin chào')]);
    expect(service.getHistory(1).single.content, 'Xin chào');
    expect(service.getHistory(2), isEmpty);

    service.clearHistory(1);
    expect(service.getHistory(1), isEmpty);
  });

  testWidgets(
      'mở bong bóng chat AI và lưu Gemini API Key không gây lỗi _dependents.isEmpty',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final settingsProv = SettingsProvider(prefs);

    await tester.pumpWidget(
      ChangeNotifierProvider<SettingsProvider>.value(
        value: settingsProv,
        child: MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                AiChatBubble(
                  novel: novel,
                  chapter: chapter,
                  chapterContent: content,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    // Bấm vào bong bóng chat AI để mở sheet
    await tester.tap(find.byIcon(Icons.smart_toy_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Trợ Lý AI Độc Giả'), findsOneWidget);

    // Mở hộp thoại cấu hình Gemini API Key
    await tester.tap(find.byIcon(Icons.vpn_key_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Cấu hình Gemini API Key'), findsOneWidget);

    // Nhập key và bấm Lưu Key
    await tester.enterText(
      find.widgetWithText(TextField, 'Gemini API Key'),
      'test-gemini-key-123',
    );
    await tester.tap(find.text('Lưu Key'));
    // Pump qua toàn bộ hiệu ứng đóng dialog
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(settingsProv.geminiApiKey, 'test-gemini-key-123');
    expect(tester.takeException(), isNull);
  });
}
