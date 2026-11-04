import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/models/bookmark.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/models/library_item.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/models/reading_history.dart';
import 'package:novel_reader/providers/library_provider.dart';
import 'package:novel_reader/providers/reader_provider.dart';
import 'package:novel_reader/providers/settings_provider.dart';
import 'package:novel_reader/screens/reader_screen.dart';
import 'package:novel_reader/utils/app_route_observer.dart';
import 'package:novel_reader/utils/constants.dart';
import 'package:novel_reader/widgets/reader_toolbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Novel book(int id) => Novel(
  id: id,
  title: 'Truyện $id',
  author: 'Test',
  coverUrl: '',
  description: '',
  status: 'ongoing',
  type: 'novel',
  genres: const [],
  totalChapters: 2,
  rating: 0,
  views: 0,
  updatedAt: DateTime(2026),
);
Chapter chapter(int novel, int index) => Chapter(
  id: novel * 10 + index,
  novelId: novel,
  chapterIndex: index,
  title: 'Truyện $novel chương $index',
  isDownloaded: true,
  content: List.generate(
    50,
    (i) =>
        'Nội dung truyện $novel chương $index đoạn $i. Một đoạn văn đủ dài để kiểm tra vị trí đọc khi chuyển qua màn khác.',
  ).join('\n'),
);

class _Database extends AppDatabase {
  final histories = <int, ReadingHistory>{};
  Completer<void>? bookmarksGate;
  int chapterReads = 0;
  List<ChapterComment> comments = [];
  final contentReplies = <int, Completer<Chapter?>>{};
  @override
  Future<List<Chapter>> getChapters(int novelId, {Novel? novel}) async {
    chapterReads++;
    return [chapter(novelId, 1), chapter(novelId, 2)];
  }

  @override
  Future<List<Chapter>> getCachedChapters(int novelId) => getChapters(novelId);
  @override
  Future<Chapter?> getChapter(int id, {int? novelId}) async =>
      contentReplies[id]?.future ?? Future.value(chapter(novelId!, id % 10));
  @override
  Future<String> fetchChapterContent(int novelId, int chapterIndex) async =>
      throw StateError('Restoration must reuse loaded bytes');
  @override
  Future<List<Bookmark>> getBookmarks(int novelId, {String? userId}) async {
    if (novelId == 1) await bookmarksGate?.future;
    return [];
  }

  @override
  Future<List<ChapterComment>> getComments(int chapterId) async => comments;
  @override
  Future<List<LibraryItem>> getLibrary({String? userId}) async => [];
  @override
  Future<List<QuoteItem>> getQuotes({String? userId}) async => [];
  @override
  Future<List<ReadingSessionStat>> getReadingSessions({String? userId}) async =>
      [];
  @override
  Future<List<ReadingHistory>> getHistory({String? userId}) async =>
      histories.values.toList();
  @override
  Future<void> saveHistory(ReadingHistory history, {String? userId}) async {
    if (histories[history.novelId]?.lastReadAt.isAfter(history.lastReadAt) ==
        true) {
      return;
    }
    histories[history.novelId] = history;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _Database db;
  late ReaderProvider reader;
  late LibraryProvider library;
  late SettingsProvider settings;
  late GlobalKey<NavigatorState> navigation;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = _Database();
    reader = ReaderProvider(db);
    library = LibraryProvider(db);
    settings = SettingsProvider(await SharedPreferences.getInstance());
    await settings.updateReader(settings.reader.copyWith(showAiBubble: false));
    await library.load();
    navigation = GlobalKey<NavigatorState>();
  });
  tearDown(() {
    reader.dispose();
    library.dispose();
    settings.dispose();
  });

  Future<void> open(
    WidgetTester tester, {
    bool horizontal = false,
    double width = 420,
  }) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await settings.setHorizontalPageMode(horizontal);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ReaderProvider>.value(value: reader),
          ChangeNotifierProvider<LibraryProvider>.value(value: library),
          ChangeNotifierProvider<SettingsProvider>.value(value: settings),
        ],
        child: MaterialApp(
          navigatorKey: navigation,
          navigatorObservers: [appRouteObserver],
          home: ReaderScreen(
            novel: book(1),
            initialChapterId: 11,
            initialScrollOffset: .35,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final horizontal in [false, true]) {
    for (final sameBook in [false, true]) {
      testWidgets(
        '${horizontal ? "Paged" : "Scroll"} reader restores its own chapter and position after ${sameBook ? "another chapter of the same book" : "a different book"}',
        (tester) async {
          await open(tester, horizontal: horizontal);
          final initialOwner = reader.readerOwner;
          double position() {
            if (horizontal) {
              return tester
                  .widget<PageView>(find.byType(PageView).first)
                  .controller!
                  .page!;
            }
            final scroll = tester
                .state<ScrollableState>(find.byType(Scrollable).first)
                .position;
            return scroll.pixels / scroll.maxScrollExtent;
          }

          final before = position();
          expect(before, greaterThan(0));
          final secondBook = sameBook ? 1 : 2;
          final secondId = sameBook ? 12 : 21;
          unawaited(
            navigation.currentState!.push(
              MaterialPageRoute<void>(
                builder: (_) => ReaderScreen(
                  novel: book(secondBook),
                  initialChapterId: secondId,
                  initialScrollOffset: .7,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(reader.currentChapter!.id, secondId);
          expect(identical(reader.readerOwner, initialOwner), isFalse);
          final readsBeforeReturn = db.chapterReads;
          reader.forceOffline = true;
          navigation.currentState!.pop();
          await tester.pumpAndSettle();
          expect(reader.novel!.id, 1);
          expect(reader.currentChapter!.id, 11);
          expect(identical(reader.readerOwner, initialOwner), isTrue);
          expect(reader.content, chapter(1, 1).content);
          expect(
            db.chapterReads,
            readsBeforeReturn,
            reason:
                'Return should reuse the loaded chapter without a new fetch.',
          );
          expect(position(), closeTo(before, .001));
          expect(library.historyFor(1)!.lastChapterId, 11);
          await tester.pump(const Duration(seconds: 1));
          expect(
            library.historyFor(1)!.lastChapterId,
            11,
            reason: 'Disposing the popped reader must not overwrite the resumed reader.',
          );
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
        },
      );
    }
  }

  testWidgets(
    'Leaving during a pending chapter switch preserves the position of the last visible chapter',
    (tester) async {
      await open(tester);
      final scroll = tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position;
      final before = scroll.pixels / scroll.maxScrollExtent;
      final reply = db.contentReplies[12] = Completer<Chapter?>();
      await tester.tap(
        find.descendant(
          of: find.byType(ReaderBottomBar),
          matching: find.text(AppStrings.nextChapter),
        ),
      );
      await tester.pump();
      expect(reader.isLoadingContent, isTrue);
      unawaited(
        navigation.currentState!.push(
          MaterialPageRoute<void>(
            builder: (_) => ReaderScreen(novel: book(2), initialChapterId: 21),
          ),
        ),
      );
      await tester.pumpAndSettle();
      navigation.currentState!.pop();
      await tester.pumpAndSettle();
      expect(reader.currentChapter!.id, 11);
      final resumed = tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position;
      expect(resumed.pixels / resumed.maxScrollExtent, closeTo(before, .001));
      reply.complete(chapter(1, 2));
      await tester.pumpAndSettle();
      expect(reader.currentChapter!.id, 11);
      expect(library.historyFor(1)!.scrollOffset, closeTo(before, .001));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'Closing the table of contents does not restore the old chapter over a selected new chapter',
    (tester) async {
      await open(tester);
      await tester.tap(find.text(AppStrings.tableOfContents));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Truyện 1 chương 2').last);
      await tester.pumpAndSettle();
      expect(reader.currentChapter!.id, 12);
      expect(library.historyFor(1)!.lastChapterId, 12);
      expect(reader.content, chapter(1, 2).content);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'Late bookmarks cannot reopen the covered reader over a newly opened book',
    (tester) async {
      db.bookmarksGate = Completer<void>();
      await open(tester);
      expect(reader.currentChapter!.id, 11);
      unawaited(
        navigation.currentState!.push(
          MaterialPageRoute<void>(
            builder: (_) => ReaderScreen(novel: book(2), initialChapterId: 21),
          ),
        ),
      );
      await tester.pumpAndSettle();
      db.bookmarksGate!.complete();
      await tester.pumpAndSettle();
      expect(reader.currentChapter!.id, 21);
      expect(reader.novel!.id, 2);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'Reader controls and long/empty comment names fit a 360px phone',
    (tester) async {
      db.comments = [
        for (final name in [
          'Tên độc giả rất dài để kiểm tra bố cục điện thoại',
          '',
        ])
          ChapterComment(
            novelId: 1,
            chapterId: 11,
            userName: name,
            content: 'Nội dung bình luận',
            createdAt: DateTime(2026),
          ),
      ];
      await open(tester, width: 360);
      final scroll = tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position;
      scroll.jumpTo(scroll.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(find.text('Nội dung bình luận'), findsNWidgets(2));
      expect(find.text('Độc giả'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  test(
    'Restoring a snapshot ignores a pending different-book content response',
    () async {
      await reader.openNovel(book(1), chapterId: 11);
      final saved = reader.captureReader()!;
      final old = reader.openNovel(book(2), chapterId: 21);
      final owner = Object();
      reader.restoreReader(saved, owner: owner);
      await old;
      expect(reader.currentChapter!.id, 11);
      expect(reader.content, chapter(1, 1).content);
      expect(identical(reader.readerOwner, owner), isTrue);
    },
  );
}
