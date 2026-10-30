import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/database/v2_database_store.dart';
import 'package:novel_reader/models/app_user.dart';
import 'package:novel_reader/models/bookmark.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/providers/admin_dashboard_provider.dart';
import 'package:novel_reader/providers/admin_novel_provider.dart';
import 'package:novel_reader/providers/admin_user_provider.dart';
import 'package:novel_reader/providers/auth_provider.dart';
import 'package:novel_reader/providers/library_provider.dart';
import 'package:novel_reader/providers/moderation_provider.dart';
import 'package:novel_reader/providers/novel_provider.dart';
import 'package:novel_reader/providers/quest_provider.dart';
import 'package:novel_reader/providers/reader_provider.dart';
import 'package:novel_reader/providers/settings_provider.dart';
import 'package:novel_reader/repositories/auth_repository.dart';
import 'package:novel_reader/repositories/novel_repository.dart';
import 'package:novel_reader/screens/admin/admin_shell.dart';
import 'package:novel_reader/screens/admin/moderation_queue_screen.dart';
import 'package:novel_reader/screens/reader_screen.dart';
import 'package:novel_reader/utils/constants.dart';
import 'package:novel_reader/utils/role_guard.dart';
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

  test(
      'v2 AuthProvider, RoleGuard & AdminUserProvider: đăng nhập sai, khóa tài khoản kèm lý do, chặn tự khóa Admin',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = await createTestDb();
    addTearDown(db.close);

    final authRepo = LocalAuthRepository(db);
    final auth = AuthProvider(authRepo, prefs);
    final adminUsers = AdminUserProvider(db, authRepo);
    await adminUsers.loadUsers();

    // 1. Đăng nhập sai mật khẩu -> trả về false và có thông báo lỗi
    final wrongOk = await auth.login('user@novelreader.local', 'WrongPass');
    expect(wrongOk, isFalse);
    expect(auth.error, contains('không chính xác'));

    // 2. Đăng nhập bằng Admin mặc định
    final adminOk = await auth.login('admin@novelreader.local', 'Admin@123');
    expect(adminOk, isTrue);
    expect(auth.isAdmin, isTrue);
    final adminUser = auth.currentUser;

    // 3. Admin không thể tự khóa chính mình
    expect(
      () => adminUsers.banUser(
        admin: adminUser,
        target: adminUser,
        reason: 'Tự khóa',
      ),
      throwsStateError,
    );

    // 4. Admin khóa tài khoản user@novelreader.local kèm lý do -> user không đăng nhập được và thấy lý do
    final normalUser = adminUsers.users.firstWhere(
      (u) => u.email == 'user@novelreader.local',
    );
    await adminUsers.banUser(
      admin: adminUser,
      target: normalUser,
      reason: 'Spam quảng cáo trái phép',
      durationDays: 7,
    );

    final bannedLogin = await auth.login('user@novelreader.local', 'User@1234');
    expect(bannedLogin, isFalse);
    expect(auth.error, contains('Spam quảng cáo trái phép'));

    // 5. Kiểm tra ma trận RoleGuard
    expect(
      RoleGuard.can(AppUser.guest(), AppPermission.interactAndGamify),
      isFalse,
    );
    expect(RoleGuard.can(normalUser, AppPermission.manageSystem), isFalse);
    expect(RoleGuard.can(adminUser, AppPermission.manageSystem), isTrue);
  });

  test(
      'v2 QuestProvider, Spoiler Shield, Glossary & Recap chống lộ nội dung chương sau',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = await createTestDb();
    addTearDown(db.close);

    final authRepo = LocalAuthRepository(db);
    final auth = AuthProvider(authRepo, prefs);
    await auth.login('user@novelreader.local', 'User@1234');
    final initialStones = auth.currentUser.linhThach;

    final questProv = QuestProvider(db);
    await questProv.loadForUser(auth.currentUser.id);
    expect(questProv.quests, isNotEmpty);

    // Tăng tiến độ nhiệm vụ đọc chương và nhận thưởng Linh Thạch
    final readChapterQuest = questProv.quests.firstWhere(
      (q) => q.goalType == 'read_chapters',
    );
    await questProv.recordProgress(
      user: auth.currentUser,
      goalType: 'read_chapters',
      delta: readChapterQuest.goalValue,
    );
    final reward = await questProv.claimQuestReward(
      auth: auth,
      quest: readChapterQuest,
    );
    expect(reward, readChapterQuest.reward);
    expect(auth.currentUser.linhThach, initialStones + reward);

    // Kiểm tra Spoiler Shield, Glossary và Recap không bao giờ vượt quá chương hiện tại
    final spoilerComment = ChapterComment(
      novelId: 1,
      chapterId: 10001,
      content: 'Tiết lộ kết cục chương 5',
      chapterIndex: 5,
      createdAt: DateTime.now(),
    );
    expect(spoilerComment.isSpoilerFor(1), isTrue);
    expect(spoilerComment.isSpoilerFor(5), isFalse);

    final rawDb = await db.database;
    final termsCh1 = await V2DatabaseStore.getGlossaryForNovel(
      rawDb,
      1,
      maxChapterIndex: 1,
    );
    expect(termsCh1.every((t) => t.firstChapterIndex <= 1), isTrue);

    final summariesCh1 = await V2DatabaseStore.getSummariesUpTo(rawDb, 1, 1);
    expect(summariesCh1.every((s) => s.chapterIndex <= 1), isTrue);
  });

  testWidgets(
      'v2 Widget test: Route Guard chặn User vào AdminShell + Luồng duyệt truyện và ghi Audit Log + Dashboard khớp dữ liệu thật',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    late SharedPreferences prefs;
    late AppDatabase db;
    late AuthProvider auth;
    late AdminNovelProvider adminNovels;
    late AdminDashboardProvider dash;
    late ModerationProvider mod;

    await tester.runAsync(() async {
      prefs = await SharedPreferences.getInstance();
      db = await createTestDb();
      final authRepo = LocalAuthRepository(db);
      final novelRepo = LocalNovelRepository(db);
      auth = AuthProvider(authRepo, prefs);
      adminNovels = AdminNovelProvider(db, novelRepo);
      dash = AdminDashboardProvider(db);
      mod = ModerationProvider(db);

      // Đăng nhập bằng tài khoản user thường -> kiểm tra AdminShell chặn truy cập (403)
      await auth.login('user@novelreader.local', 'User@1234');
    });
    addTearDown(() async {
      await db.close();
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: auth),
          ChangeNotifierProvider.value(value: adminNovels),
          ChangeNotifierProvider.value(value: dash),
          ChangeNotifierProvider.value(value: mod),
        ],
        child: const MaterialApp(home: AdminShell()),
      ),
    );
    await tester.pump();
    expect(find.textContaining('Từ chối truy cập (403)'), findsOneWidget);

    // Author tạo truyện chờ duyệt -> Admin duyệt trên AdminModerationQueueScreen -> Audit Log ghi lại
    await tester.runAsync(() async {
      await db.insertCustomNovel(
        title: 'Tác Phẩm Chờ Duyệt Test',
        author: 'Bút Mặc Tiên Sinh',
        description: 'Truyện gửi duyệt',
        status: NovelStatus.ongoing,
        type: NovelType.novel,
        genres: const ['Tiên hiệp'],
        chapters: const [(title: 'Chương 1', content: 'Nội dung chương 1')],
        moderationStatus: ModerationStatus.pending,
        ownerId: 2,
      );
      await auth.login('admin@novelreader.local', 'Admin@123');
      await adminNovels.loadNovels();
      await dash.loadDashboard();
    });

    expect(dash.pendingNovelsCount, 1);
    expect(dash.totalUsers, greaterThanOrEqualTo(3));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: auth),
          ChangeNotifierProvider.value(value: adminNovels),
          ChangeNotifierProvider.value(value: dash),
          ChangeNotifierProvider.value(value: mod),
        ],
        child: const MaterialApp(
          home: Scaffold(body: AdminModerationQueueScreen()),
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    expect(find.text('Tác Phẩm Chờ Duyệt Test'), findsOneWidget);

    // Bấm nút "Duyệt xuất bản"
    await tester.runAsync(() async {
      final pending = adminNovels.pendingNovels.single;
      await adminNovels.approveNovels(
        admin: auth.currentUser,
        novelIds: [pending.id],
      );
      await mod.loadAll();
    });
    await tester.pump();

    expect(adminNovels.pendingNovels, isEmpty);
    expect(
      mod.auditLogs.any((l) => l.action == 'APPROVE_NOVEL'),
      isTrue,
    );
  });
}
