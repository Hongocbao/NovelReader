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
import 'package:novel_reader/utils/active_reading_clock.dart';
import 'package:novel_reader/utils/app_route_observer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef _Write = ({
  String userId,
  int novelId,
  int chapterId,
  int words,
  int minutes,
});

class _Database extends AppDatabase {
  final writes = <_Write>[];
  bool failWrite = false;
  bool failRefresh = false;
  Completer<void>? gate;

  @override
  Future<void> recordReadingSession({
    required int words,
    required int minutes,
    DateTime? date,
    String userId = '',
    int novelId = 0,
    int chapterId = 0,
  }) async {
    await gate?.future;
    if (failWrite) throw StateError('Write failed before commit');
    writes.add((
      userId: userId,
      novelId: novelId,
      chapterId: chapterId,
      words: words,
      minutes: minutes,
    ));
  }

  @override
  Future<List<ReadingSessionStat>> getReadingSessions({String? userId}) async {
    if (failRefresh) throw StateError('Refresh failed');
    final scoped = writes.where((w) => w.userId == (userId ?? ''));
    return scoped.isEmpty
        ? []
        : [
            ReadingSessionStat(
              dateKey: '2026-11-04',
              wordsRead: scoped.fold(0, (sum, w) => sum + w.words),
              minutesRead: scoped.fold(0, (sum, w) => sum + w.minutes),
            ),
          ];
  }

  @override
  Future<List<LibraryItem>> getLibrary({String? userId}) async => [];
  @override
  Future<List<ReadingHistory>> getHistory({String? userId}) async => [];
  @override
  Future<List<QuoteItem>> getQuotes({String? userId}) async => [];
  @override
  Future<List<Bookmark>> getBookmarks(int novelId, {String? userId}) async =>
      [];
  @override
  Future<List<ChapterComment>> getComments(int chapterId) async => [];
}

class _Reader extends ReaderProvider {
  _Reader(super.db, this.book, this.chapter, this.text);
  final Novel book;
  Chapter chapter;
  String? text;
  bool loading = false;
  @override
  Novel get novel => book;
  @override
  Chapter get currentChapter => chapter;
  @override
  String? get content => text;
  @override
  bool get isLoadingContent => loading;
  @override
  List<Chapter> get currentChapters => [chapter];
  @override
  Future<void> openNovel(Novel novel, {int? chapterId, Object? owner}) async {}
  void change({
    required Chapter next,
    required String? content,
    bool busy = false,
  }) {
    chapter = next;
    text = content;
    loading = busy;
    notifyListeners();
  }
}

class _Library extends LibraryProvider {
  _Library(super.db);
  @override
  Future<void> saveProgress(
    Novel novel,
    Chapter chapter,
    double offset, {
    DateTime? readAt,
    String? userId,
  }) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Active clock excludes hidden intervals and drains each interval once',
    () {
      var elapsed = Duration.zero;
      final clock = ActiveReadingClock(elapsed: () => elapsed);
      elapsed += const Duration(minutes: 10);
      expect(clock.take(), Duration.zero);
      clock.setActive(true);
      elapsed += const Duration(seconds: 25);
      clock.setActive(false);
      elapsed += const Duration(hours: 2);
      expect(clock.take(), const Duration(seconds: 25));
      expect(clock.take(), Duration.zero);
      clock.setActive(true);
      elapsed += const Duration(seconds: 35);
      expect(clock.take(), const Duration(seconds: 35));
      expect(clock.take(), Duration.zero);
    },
  );

  group('Active reading totals', () {
    late _Database db;
    late LibraryProvider library;
    final content = List.filled(1000, 'từ').join(' ');
    setUp(() {
      db = _Database();
      library = LibraryProvider(db);
    });
    tearDown(() => library.dispose());
    Future<void> read(
      int seconds, {
      int novel = 1,
      int chapter = 10,
      String? text,
      String user = '',
      DateTime? date,
    }) => library.recordActiveReading(
      novelId: novel,
      chapterId: chapter,
      content: text ?? content,
      activeDuration: Duration(seconds: seconds),
      userId: user,
      date: date,
    );

    test(
      'No automatic minute; fractions accumulate across chapters and novels',
      () async {
        await read(25);
        await read(34, novel: 2, chapter: 20);
        expect(db.writes, isEmpty);
        await read(1, novel: 2, chapter: 20);
        expect(db.writes.single.minutes, 1);
        expect(
          db.writes.single.words,
          219,
        ); // Per-chapter rounding, not full chapter credit.
        await read(59);
        expect(db.writes.length, 1);
        await read(1);
        expect(library.totalMinutesRead, 2);
      },
    );

    test(
      'Words are capped by actual text; image tags and rereads add no words',
      () async {
        await read(60, text: 'Một [img]data:image/png;base64,AAAA[/img] hai');
        await read(60, text: 'Một [img]data:image/png;base64,AAAA[/img] hai');
        expect(db.writes.map((w) => w.words), [2, 0]);
        expect(library.totalMinutesRead, 2);
        await read(
          60,
          novel: -1,
          chapter: -10,
          text: '[img]data:image/png;base64,AAAA[/img]',
        );
        expect(db.writes.last.words, 0);
        expect(db.writes.last.minutes, 1);
      },
    );

    test(
      'A failed write retains time and words for the next reading interval',
      () async {
        db.failWrite = true;
        await expectLater(read(60), throwsStateError);
        db.failWrite = false;
        await read(1);
        expect(db.writes.single.minutes, 1);
        expect(db.writes.single.words, 223);
        await read(59);
        expect(library.totalMinutesRead, 2);
        expect(library.totalWordsRead, 440);
      },
    );

    test(
      'Refresh failure after commit must not credit the minute again',
      () async {
        db.failRefresh = true;
        await read(60);
        db.failRefresh = false;
        await read(60);
        expect(db.writes.map((w) => w.minutes), [1, 1]);
        expect(library.totalMinutesRead, 2);
      },
    );

    test(
      'Concurrent intervals retain totals while writes are waiting',
      () async {
        db.gate = Completer<void>();
        final first = read(45);
        final second = read(45);
        final third = read(30);
        db.gate!.complete();
        await Future.wait([first, second, third]);
        expect(library.totalMinutesRead, 2);
        expect(library.totalWordsRead, 440);
      },
    );

    test(
      'Account switch discards old fractions and ignores late old completions',
      () async {
        library.bindUser('A');
        await library.load();
        await read(30, user: 'A');
        db.gate = Completer<void>();
        final old = read(30, user: 'A');
        library.bindUser('B');
        await library.load();
        await read(30, user: 'B');
        await read(90, user: 'A'); // Stale reader callback is ignored.
        db.gate!.complete();
        await old;
        expect(library.totalMinutesRead, 0);
        await read(30, user: 'B');
        expect(library.totalMinutesRead, 1);
        expect(db.writes.map((w) => w.userId), ['A', 'B']);
      },
    );

    test('Sub-minute time does not carry into another day', () async {
      await read(50, date: DateTime(2026, 11, 4, 23, 59));
      await read(50, date: DateTime(2026, 11, 5, 0, 1));
      expect(db.writes, isEmpty);
      await read(10, date: DateTime(2026, 11, 5, 0, 2));
      expect(db.writes.single.minutes, 1);
    });
  });

  for (final comic in [false, true]) {
    testWidgets(
      '${comic ? "Manga" : "Text"} reader pauses time behind routes, dialogs, background and chapter loading',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final settings = SettingsProvider(
          await SharedPreferences.getInstance(),
        );
        final db = _Database();
        final library = _Library(db);
        final book = Novel(
          id: 1,
          title: 'Test',
          author: 'Test',
          coverUrl: '',
          description: '',
          status: 'ongoing',
          type: comic ? 'comic' : 'novel',
          genres: const [],
          totalChapters: 2,
          rating: 0,
          views: 0,
          updatedAt: DateTime(2026),
        );
        const first = Chapter(
          id: 10,
          novelId: 1,
          chapterIndex: 1,
          title: 'Chương 1',
        );
        const second = Chapter(
          id: 20,
          novelId: 1,
          chapterIndex: 2,
          title: 'Chương 2',
        );
        const imagePage =
            '[img]data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aUioAAAAASUVORK5CYII=[/img]';
        final reader = _Reader(
          db,
          book,
          first,
          comic ? imagePage : 'Nội dung để đọc',
        );
        var elapsed = Duration.zero;
        final nav = GlobalKey<NavigatorState>();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<SettingsProvider>.value(value: settings),
              ChangeNotifierProvider<ReaderProvider>.value(value: reader),
              ChangeNotifierProvider<LibraryProvider>.value(value: library),
            ],
            child: MaterialApp(
              navigatorKey: nav,
              navigatorObservers: [appRouteObserver],
              home: ReaderScreen(
                novel: book,
                initialChapterId: first.id,
                activityClock: ActiveReadingClock(elapsed: () => elapsed),
              ),
            ),
          ),
        );
        await tester.pump();

        Future<void> advance(int seconds) async {
          elapsed += Duration(seconds: seconds);
          await tester.pump(const Duration(seconds: 5));
          await tester.pump();
        }

        await advance(30);
        expect(db.writes, isEmpty);
        unawaited(
          nav.currentState!.push(
            MaterialPageRoute<void>(
              builder: (_) => const Scaffold(body: Text('Other route')),
            ),
          ),
        );
        await tester.pump();
        await advance(600);
        expect(db.writes, isEmpty);
        nav.currentState!.pop();
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        await advance(30);
        expect(library.totalMinutesRead, 1);

        unawaited(
          showDialog<void>(
            context: nav.currentContext!,
            builder: (_) => const AlertDialog(title: Text('Paused')),
          ),
        );
        await tester.pump();
        await advance(300);
        expect(library.totalMinutesRead, 1);
        nav.currentState!.pop();
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await advance(600);
        expect(library.totalMinutesRead, 1);
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await advance(30);
        reader.change(next: second, content: null, busy: true);
        await tester.pump();
        await advance(600);
        expect(library.totalMinutesRead, 1);
        reader.change(next: second, content: comic ? imagePage : 'Chương hai');
        await tester.pump();
        await advance(30);
        expect(library.totalMinutesRead, 2);
        if (comic) expect(library.totalWordsRead, 0);
        reader.change(
          next: second.copyWith(novelId: 99),
          content: 'Another novel',
        );
        await tester.pump();
        await advance(600);
        expect(
          library.totalMinutesRead,
          2,
          reason: 'Stale content from another novel must not be timed.',
        );
        reader.change(next: first, content: ' \n ');
        await tester.pump();
        await advance(120);
        expect(
          library.totalMinutesRead,
          2,
          reason: 'An empty reading screen must not add minutes.',
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        reader.dispose();
        library.dispose();
        settings.dispose();
      },
    );
  }
}
