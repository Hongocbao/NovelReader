import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/utils/constants.dart';
import 'package:novel_reader/widgets/add_chapter_dialog.dart';

Future<void> openDialog(
  WidgetTester tester,
  Future<void> Function(String, String, String) save,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (_) => AddChapterDialog(onSave: save),
            ),
            child: const Text('Thêm'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Thêm'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'Retry retains text and the same key after an unknown save result',
    (tester) async {
      final requests = <({String title, String content, String key})>[];
      await openDialog(tester, (title, content, key) async {
        requests.add((title: title, content: content, key: key));
        if (requests.length == 1) throw StateError('Mạng chập chờn');
      });
      await tester.enterText(find.byType(TextField).at(0), '  Ngày mới  ');
      await tester.enterText(
        find.byType(TextField).at(1),
        '  Nội dung đã viết  ',
      );
      await tester.tap(find.text(AppStrings.save));
      await tester.pumpAndSettle();
      expect(find.textContaining('Mạng chập chờn'), findsOneWidget);
      expect(find.text('  Nội dung đã viết  '), findsOneWidget);
      expect(find.byType(AddChapterDialog), findsOneWidget);

      await tester.tap(find.text(AppStrings.save));
      await tester.pumpAndSettle();
      expect(requests, hasLength(2));
      expect(requests[0].key, isNotEmpty);
      expect(requests[1], requests[0]);
      expect(requests[0].title, 'Ngày mới');
      expect(requests[0].content, 'Nội dung đã viết');
      expect(find.byType(AddChapterDialog), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Changing a failed submission generates a new key', (
    tester,
  ) async {
    final keys = <String>[];
    await openDialog(tester, (title, content, key) async {
      keys.add(key);
      throw StateError('Tạm thời mất mạng');
    });
    await tester.enterText(find.byType(TextField).at(1), 'Bản đầu');
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), 'Bản đã sửa');
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();
    expect(keys, hasLength(2));
    expect(keys[1], isNot(keys[0]));
    await tester.tap(find.text(AppStrings.cancel));
    await tester.pumpAndSettle();
  });

  testWidgets('Pending save blocks duplicate taps, editing, and Android back', (
    tester,
  ) async {
    final saved = Completer<void>();
    var calls = 0;
    await openDialog(tester, (_, _, _) {
      calls++;
      return saved.future;
    });
    await tester.enterText(find.byType(TextField).at(1), 'Chương mới');
    await tester.tap(find.text(AppStrings.save));
    await tester.pump();
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(
      tester
          .widget<TextButton>(
            find.widgetWithText(TextButton, AppStrings.cancel),
          )
          .onPressed,
      isNull,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).enabled,
      isFalse,
    );
    await tester.tap(find.text('Đang lưu…'));
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(AddChapterDialog), findsOneWidget);
    expect(calls, 1);
    saved.complete();
    await tester.pumpAndSettle();
    expect(find.byType(AddChapterDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Empty content stays editable on a mobile width without saving', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var calls = 0;
    await openDialog(tester, (_, _, _) async => calls++);
    await tester.enterText(find.byType(TextField).at(1), ' \n\t ');
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập nội dung chương.'), findsOneWidget);
    expect(find.byType(AddChapterDialog), findsOneWidget);
    expect(calls, 0);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text(AppStrings.cancel));
    await tester.pumpAndSettle();
  });

  testWidgets(
    'Retrying a failed recap write retains the chapter request key and recap',
    (tester) async {
      final requests =
          <({String title, String content, String summary, String key})>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showDialog<bool>(
                  context: context,
                  builder: (_) => AddChapterDialog(
                    initialTitle: 'Chương 2',
                    initialContent: 'Nội dung sẵn có',
                    onSaveWithSummary: (title, content, summary, key) async {
                      requests.add((
                        title: title,
                        content: content,
                        summary: summary,
                        key: key,
                      ));
                      if (requests.length == 1) {
                        throw StateError('Chưa lưu được tóm tắt');
                      }
                    },
                  ),
                ),
                child: const Text('Biên tập'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Biên tập'));
      await tester.pumpAndSettle();
      expect(find.text('Số từ: 4 từ'), findsOneWidget);
      await tester.enterText(find.byType(TextField).at(2), 'Tóm tắt lần đầu');
      await tester.tap(find.text(AppStrings.save));
      await tester.pumpAndSettle();
      expect(find.text('Tóm tắt lần đầu'), findsOneWidget);
      await tester.enterText(find.byType(TextField).at(2), 'Tóm tắt đã sửa');
      await tester.tap(find.text(AppStrings.save));
      await tester.pumpAndSettle();
      expect(requests[1].key, requests[0].key);
      expect(requests[1].summary, 'Tóm tắt đã sửa');
      expect(find.byType(AddChapterDialog), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
