import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/models/chapter_summary.dart';
import 'package:novel_reader/models/glossary_term.dart';
import 'package:novel_reader/repositories/reader_extras_source.dart';
import 'package:novel_reader/screens/user/advanced_reader_sheets.dart';

ChapterSummary recap(int book, int index, String text) => ChapterSummary(
  chapterId: book * 100 + index,
  novelId: book,
  chapterIndex: index,
  summary: text,
);
GlossaryTerm term(int book, int index, String text) => GlossaryTerm(
  novelId: book,
  term: text,
  meaning: 'Giải nghĩa',
  firstChapterIndex: index,
);

class _Source implements ReaderExtrasSource {
  final recaps =
      <
        ({
          int book,
          int index,
          int version,
          Completer<ReaderExtrasPage<ChapterSummary>> reply,
        })
      >[];
  final terms =
      <
        ({
          int book,
          int index,
          int version,
          Completer<ReaderExtrasPage<GlossaryTerm>> reply,
        })
      >[];
  @override
  Future<ReaderExtrasPage<ChapterSummary>> getSummariesForReader(
    int novelId,
    int chapterIndex, {
    int version = 0,
    bool offline = false,
  }) {
    final reply = Completer<ReaderExtrasPage<ChapterSummary>>();
    recaps.add((
      book: novelId,
      index: chapterIndex,
      version: version,
      reply: reply,
    ));
    return reply.future;
  }

  @override
  Future<ReaderExtrasPage<GlossaryTerm>> getGlossaryForReader(
    int novelId,
    int chapterIndex, {
    int version = 0,
    bool offline = false,
  }) {
    final reply = Completer<ReaderExtrasPage<GlossaryTerm>>();
    terms.add((
      book: novelId,
      index: chapterIndex,
      version: version,
      reply: reply,
    ));
    return reply.future;
  }
}

void main() {
  late _Source source;
  setUp(() => source = _Source());

  Future<void> showRecap(
    WidgetTester tester,
    int book,
    int index, {
    String user = 'A',
    int version = 0,
  }) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: RecapBannerCard(
          novelId: book,
          currentChapterIndex: index,
          source: source,
          userKey: user,
          version: version,
        ),
      ),
    ),
  );
  Future<void> showTerms(WidgetTester tester, int book, int index) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlossarySheet(
              novelId: book,
              currentChapterIndex: index,
              source: source,
            ),
          ),
        ),
      );

  testWidgets(
    'Recap ignores a late book response and clears later-chapter text immediately when going back',
    (tester) async {
      await showRecap(tester, 1, 5);
      await showRecap(tester, 2, 5);
      expect(source.recaps.map((q) => q.book), [1, 2]);
      source.recaps[0].reply.complete(
        ReaderExtrasPage([recap(1, 5, 'Sai truyện cũ')]),
      );
      await tester.pump();
      expect(find.textContaining('Sai truyện cũ'), findsNothing);
      source.recaps[1].reply.complete(
        ReaderExtrasPage([
          recap(2, 2, 'Đúng truyện đang đọc'),
          recap(2, 9, 'Chưa được đọc'),
          recap(1, 1, 'Khác truyện'),
        ]),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Đúng truyện đang đọc'), findsOneWidget);
      expect(find.textContaining('Chưa được đọc'), findsNothing);
      expect(find.textContaining('Khác truyện'), findsNothing);
      await showRecap(tester, 2, 1);
      expect(find.textContaining('Đúng truyện đang đọc'), findsNothing);
      source.recaps[2].reply.complete(
        ReaderExtrasPage([
          recap(2, 1, 'Chương đầu'),
          recap(2, 2, 'Chương sau'),
        ]),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Chương đầu'), findsOneWidget);
      expect(find.textContaining('Chương sau'), findsNothing);
    },
  );

  testWidgets(
    'A new account resets recap dismissal and uses the requested book version',
    (tester) async {
      await showRecap(tester, 1, 1, version: 10);
      source.recaps.single.reply.complete(
        ReaderExtrasPage([recap(1, 1, 'Bản của tài khoản A')]),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bỏ qua'));
      await tester.pump();
      expect(find.textContaining('Bản của tài khoản A'), findsNothing);
      await showRecap(tester, 1, 1, user: 'B', version: 20);
      expect(source.recaps.last.version, 20);
      expect(find.textContaining('Bản của tài khoản A'), findsNothing);
      source.recaps.last.reply.complete(
        ReaderExtrasPage([recap(1, 1, 'Bản của tài khoản B')], fromCache: true),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Bản của tài khoản B'), findsOneWidget);
      expect(find.text('Bản tóm tắt đã lưu trên thiết bị'), findsOneWidget);
    },
  );

  testWidgets(
    'Dictionary distinguishes loading, failure/retry, and a real empty response',
    (tester) async {
      await showTerms(tester, 1, 2);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      source.terms.single.reply.completeError(StateError('Mất mạng'));
      await tester.pumpAndSettle();
      expect(
        find.text('Chưa tải được từ điển. Kiểm tra kết nối rồi thử lại.'),
        findsOneWidget,
      );
      expect(
        find.text('Chưa có thuật ngữ nào xuất hiện ở chương này.'),
        findsNothing,
      );
      await tester.tap(find.text('Thử lại'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      source.terms.last.reply.complete(ReaderExtrasPage([]));
      await tester.pumpAndSettle();
      expect(
        find.text('Chưa có thuật ngữ nào xuất hiện ở chương này.'),
        findsOneWidget,
      );
      expect(find.text('Thử lại'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Dictionary drops old chapter responses and safely finishes after the sheet closes',
    (tester) async {
      await showTerms(tester, 1, 5);
      await showTerms(tester, 1, 1);
      source.terms[0].reply.complete(
        ReaderExtrasPage([term(1, 5, 'Phản hồi chương sau')]),
      );
      await tester.pump();
      expect(find.text('Phản hồi chương sau'), findsNothing);
      source.terms[1].reply.complete(
        ReaderExtrasPage([
          term(1, 1, 'Thuật ngữ chương đầu'),
          term(1, 2, 'Lộ nội dung tương lai'),
        ]),
      );
      await tester.pumpAndSettle();
      expect(find.text('Thuật ngữ chương đầu'), findsOneWidget);
      expect(find.text('Lộ nội dung tương lai'), findsNothing);
      await tester.tap(find.text('Làm mới'));
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
      source.terms.last.reply.complete(
        ReaderExtrasPage([term(1, 1, 'Đã đóng')]),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('A long cached dictionary fits a mobile sheet and can refresh', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 420,
              child: GlossarySheet(
                novelId: 1,
                currentChapterIndex: 1,
                source: source,
              ),
            ),
          ),
        ),
      ),
    );
    source.terms.single.reply.complete(
      ReaderExtrasPage([
        for (var i = 1; i <= 50; i++)
          term(1, 1, 'Thuật ngữ dài để kiểm tra trên điện thoại $i'),
      ], fromCache: true),
    );
    await tester.pumpAndSettle();
    expect(find.text('Bản đã lưu trên thiết bị'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Làm mới'));
    await tester.pump();
    source.terms.last.reply.complete(ReaderExtrasPage([]));
    await tester.pumpAndSettle();
    expect(
      find.text('Chưa có thuật ngữ nào xuất hiện ở chương này.'),
      findsOneWidget,
    );
    expect(find.text('Bản đã lưu trên thiết bị'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
