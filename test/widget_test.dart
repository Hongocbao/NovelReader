import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/providers/library_provider.dart';
import 'package:novel_reader/providers/novel_provider.dart';
import 'package:novel_reader/providers/reader_provider.dart';
import 'package:novel_reader/providers/settings_provider.dart';
import 'package:novel_reader/screens/reader_screen.dart';
import 'package:novel_reader/utils/constants.dart';
import 'package:novel_reader/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  late String sampleJson;

  setUpAll(() async {
    sampleJson = await File('assets/data/sample_novels.json').readAsString();
  });

  Future<AppDatabase> createTestDb() async {
    return AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
      sampleJsonLoader: () async => sampleJson,
    );
  }

  test('Nạp dữ liệu mẫu lần đầu: đủ ít nhất 10 truyện (5 truyện chữ, 5 LN)',
      () async {
    final db = await createTestDb();
    addTearDown(db.close);

    final all = await db.queryNovels(limit: 50);
    expect(all.length, greaterThanOrEqualTo(10));
    expect(all.where((n) => !n.isLightNovel).length, greaterThanOrEqualTo(5));
    expect(all.where((n) => n.isLightNovel).length, greaterThanOrEqualTo(5));

    final chapters = await db.getChapters(all.first.id);
    expect(chapters.length, inInclusiveRange(5, 10));
    expect(chapters.every((c) => !c.isDownloaded), isTrue);
  });

  test('Tìm kiếm không dấu và lọc theo thể loại / trạng thái / loại truyện',
      () async {
    final db = await createTestDb();
    addTearDown(db.close);

    final byKeyword = await db.queryNovels(keyword: 'kiem dao');
    expect(byKeyword.any((n) => n.title.contains('Kiếm Đạo')), isTrue);

    final isekaiLn = await db.queryNovels(
      genres: const ['Isekai'],
      type: NovelType.lightNovel,
    );
    expect(isekaiLn, isNotEmpty);
    expect(
      isekaiLn.every((n) => n.isLightNovel && n.genres.contains('Isekai')),
      isTrue,
    );
  });

  test('Lưu tiến độ đọc, tủ sách và bookmark thông qua LibraryProvider',
      () async {
    final db = await createTestDb();
    addTearDown(db.close);

    final lp = LibraryProvider(db);
    await lp.load();

    final novel = (await db.queryNovels(limit: 1)).first;
    final chapters = await db.getChapters(novel.id);

    // Thêm vào "Muốn đọc", khi đọc chương sẽ tự chuyển sang "Đang đọc"
    await lp.setCategory(novel.id, LibraryCategory.want);
    expect(lp.categoryOf(novel.id), LibraryCategory.want);

    await lp.saveProgress(novel, chapters[1], 0.42);
    expect(lp.categoryOf(novel.id), LibraryCategory.reading);

    final history = lp.historyFor(novel.id);
    expect(history, isNotNull);
    expect(history!.lastChapterId, chapters[1].id);
    expect(history.scrollOffset, closeTo(0.42, 0.001));

    // Bookmark
    await lp.addBookmark(chapters[1], 0.5, note: 'Đoạn hay');
    final bookmarks = lp.bookmarksOf(novel.id);
    expect(bookmarks, isNotNull);
    expect(bookmarks!.single.note, 'Đoạn hay');
  });

  test('Tải chương và đọc offline khi mất mạng qua ReaderProvider', () async {
    final db = await createTestDb();
    addTearDown(db.close);

    final rp = ReaderProvider(
      db,
      connectivityStream: const Stream.empty(),
      checkConnectivity: () async => true,
    );
    addTearDown(rp.dispose);
    await rp.init();

    final novel = (await db.queryNovels(limit: 1)).first;
    final chapters = await rp.loadChapters(novel.id);

    // Tải chương 1 khi đang online
    final downloaded = await rp.downloadChapters(novel.id, [chapters.first]);
    expect(downloaded, 1);

    // Chuyển sang offline
    rp.forceOffline = true;
    expect(rp.isOnline, isFalse);

    // Chương 1 đã tải -> vẫn đọc được khi offline
    await rp.openNovel(novel, chapterId: chapters.first.id);
    expect(rp.contentError, isNull);
    expect(rp.content, isNotEmpty);

    // Chương 2 chưa tải -> báo lỗi offline rõ ràng
    await rp.openChapter(chapters[1]);
    expect(rp.contentError, AppStrings.chapterOfflineError);
  });

  test('SettingsProvider lưu và khôi phục cài đặt đọc + dark mode', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final sp1 = SettingsProvider(prefs);
    await sp1.setThemeMode(ThemeMode.dark);
    await sp1.setFontSize(22);
    await sp1.setBackground(ReaderBackground.sepia);

    // Khởi tạo lại từ cùng SharedPreferences (giả lập mở lại app)
    final sp2 = SettingsProvider(prefs);
    expect(sp2.themeMode, ThemeMode.dark);
    expect(sp2.reader.fontSize, 22);
    expect(sp2.reader.background, ReaderBackground.sepia);
  });

  test('NovelProvider tìm kiếm, lưu và xóa lịch sử tìm kiếm', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = await createTestDb();
    addTearDown(db.close);

    final np = NovelProvider(db, prefs);
    addTearDown(np.dispose);

    await np.loadHome();
    expect(np.featured, isNotEmpty);

    await np.submitKeyword('Thợ Rèn');
    expect(np.searchHistory, contains('Thợ Rèn'));
    expect(np.searchPager.items.single.title, contains('Thợ Rèn'));

    await np.clearSearchHistory();
    expect(np.searchHistory, isEmpty);

    // Tự động tách văn bản nhiều chương và thêm truyện mới
    final created = await np.createCustomNovel(
      title: 'Truyện Tự Sáng Tác',
      author: 'Tác Giả Trẻ',
      description: 'Mô tả thử nghiệm',
      status: NovelStatus.ongoing,
      type: NovelType.novel,
      genres: const ['Fantasy'],
      rawChaptersText:
          'Chương 1: Khởi đầu\nNội dung 1\n\nChương 2: Tiếp theo\nNội dung 2',
    );
    expect(created.totalChapters, 2);
    await np.addChapterToNovel(
      novelId: created.id,
      title: 'Chương 3: Cao trào',
      content: 'Nội dung 3',
    );
    final updated = await np.getNovel(created.id);
    expect(updated?.totalChapters, 3);
  });

  test('Sao lưu & Khôi phục JSON (tủ sách, lịch sử, trích dẫn, thống kê đọc)',
      () async {
    final db1 = await createTestDb();
    addTearDown(db1.close);
    final lp1 = LibraryProvider(db1);
    await lp1.load();

    final novel = (await db1.queryNovels(limit: 1)).first;
    final chapters = await db1.getChapters(novel.id);
    await lp1.setCategory(novel.id, LibraryCategory.reading);
    await lp1.saveProgress(novel, chapters.first, 0.55);
    await lp1.saveQuote(
      novel: novel,
      chapter: chapters.first,
      content: 'Một câu trích dẫn đáng nhớ.',
    );
    await lp1.recordChapterReadSession(
      chapters.first.id,
      'Một hai ba bốn năm sáu bảy tám chín mười',
    );

    final backupJson = await lp1.exportBackupJson();
    expect(backupJson, contains('Một câu trích dẫn đáng nhớ.'));

    // Khôi phục sang một DB hoàn toàn mới (giả lập đổi máy)
    final db2 = await createTestDb();
    addTearDown(db2.close);
    final lp2 = LibraryProvider(db2);
    await lp2.importBackupJson(backupJson);

    expect(lp2.categoryOf(novel.id), LibraryCategory.reading);
    expect(lp2.historyFor(novel.id)?.scrollOffset, closeTo(0.55, 0.001));
    expect(lp2.quotes.single.content, 'Một câu trích dẫn đáng nhớ.');
    expect(lp2.totalWordsRead, greaterThan(0));
  });

  testWidgets(
      'Widget test ReaderScreen: mở chương, cuộn lưu vị trí, thoát và mở lại đúng vị trí + chế độ lật trang ngang',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    late SharedPreferences prefs;
    late AppDatabase db;
    late SettingsProvider sp;
    late LibraryProvider lp;
    late ReaderProvider rp;
    late dynamic novel;
    late List<dynamic> chapters;

    await tester.runAsync(() async {
      prefs = await SharedPreferences.getInstance();
      db = await createTestDb();
      novel = (await db.queryNovels(limit: 1)).first;
      chapters = await db.getChapters(novel.id);
      final sampleText = List.generate(
        30,
        (i) =>
            'Đoạn văn kiểm thử số ${i + 1} của chương đầu tiên với nội dung đủ dài.',
      ).join('\n');
      await db.saveChapterContent(chapters.first.id, sampleText);

      sp = SettingsProvider(prefs);
      lp = LibraryProvider(db);
      await lp.load();
      rp = ReaderProvider(
        db,
        connectivityStream: const Stream.empty(),
        checkConnectivity: () async => true,
      );
      await rp.init();
      await rp.loadChapters(novel.id, force: true);
      await rp.openNovel(novel, chapterId: chapters.first.id);
    });
    addTearDown(() async {
      rp.dispose();
      await db.close();
    });

    Widget buildReader({double initialOffset = 0}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: sp),
          ChangeNotifierProvider.value(value: lp),
          ChangeNotifierProvider.value(value: rp),
        ],
        child: MaterialApp(
          home: ReaderScreen(
            novel: novel,
            initialChapterId: chapters.first.id,
            initialScrollOffset: initialOffset,
          ),
        ),
      );
    }

    // 1. Mở màn đọc và kiểm tra hiển thị nội dung chương
    await tester.pumpWidget(buildReader());
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    expect(find.textContaining('Đoạn văn kiểm thử số 1'), findsWidgets);

    // 2. Cuộn xuống -> lưu vị trí cuộn vào LibraryProvider khi đóng màn hình đọc
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -300),
    );
    await tester.pump();
    // Đóng màn hình đọc (trigger dispose -> _persistNow lưu vị trí cuộn hiện tại)
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });

    final savedHistory = lp.historyFor(novel.id);
    expect(savedHistory, isNotNull);
    expect(savedHistory!.scrollOffset, greaterThan(0));

    // 3. Bật chế độ Lật trang ngang (PageView) và mở lại ở đúng vị trí đã lưu
    await tester.runAsync(() async {
      await sp.setHorizontalPageMode(true);
    });
    await tester.pumpWidget(
      buildReader(initialOffset: savedHistory.scrollOffset),
    );
    await tester.pump();
    expect(find.byType(PageView), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
  });
}
