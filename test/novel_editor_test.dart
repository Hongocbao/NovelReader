import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/models/app_user.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/providers/admin_novel_provider.dart';
import 'package:novel_reader/providers/auth_provider.dart';
import 'package:novel_reader/screens/admin/novel_editor_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'security_and_roles_test.dart'
    show FakeAuthRepository, FakeNovelRepository;

typedef _Attempt = ({
  Novel novel,
  String? key,
  List<({String title, String content})> chapters,
});

class _SavingRepository extends FakeNovelRepository {
  final attempts = <_Attempt>[];
  final savedByKey = <String, Novel>{};
  Completer<void>? pending;
  bool failAfterCommit = false;
  bool failAudit = false;

  @override
  Future<Novel> saveNovel(
    Novel novel, {
    String? requestId,
    List<({String title, String content})> chapters = const [],
  }) async {
    attempts.add((
      novel: novel,
      key: requestId,
      chapters: List.unmodifiable(chapters),
    ));
    await pending?.future;
    final result = savedByKey.putIfAbsent(
      requestId!,
      () => novel.copyWith(
        id: savedByKey.length + 100,
        totalChapters: chapters.length,
      ),
    );
    if (failAfterCommit) {
      failAfterCommit = false;
      throw StateError('Mạng ngắt sau khi máy chủ lưu');
    }
    return result;
  }

  @override
  Future<void> writeAuditLog({
    required AppUser admin,
    required String action,
    required String target,
    required String detail,
  }) async {
    if (failAudit) throw StateError('Nhật ký chưa phản hồi');
  }
}

void main() {
  late AuthProvider auth;
  late AdminNovelProvider provider;
  late _SavingRepository repo;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    auth = AuthProvider(
      FakeAuthRepository(),
      await SharedPreferences.getInstance(),
    );
    expect(await auth.login('admin@novelreader.local', 'Admin@123'), isTrue);
    repo = _SavingRepository();
    provider = AdminNovelProvider(null, repo);
  });
  tearDown(() {
    auth.dispose();
    provider.dispose();
  });

  Future<void> openEditor(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<AdminNovelProvider>.value(value: provider),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<bool>(
                    builder: (_) => const NovelEditorScreen(),
                  ),
                ),
                child: const Text('Mở quản trị'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Mở quản trị'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('novel-editor-title')),
      'Truyện quản trị',
    );
    await tester.enterText(
      find.byKey(const ValueKey('novel-editor-author')),
      'Tác giả mới',
    );
  }

  Future<void> enterBulk(WidgetTester tester, String text) async {
    final field = find.byKey(const ValueKey('novel-editor-bulk'));
    await tester.scrollUntilVisible(
      field,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(field, text);
    await tester.pump();
  }

  testWidgets(
    'Bulk creation reaches the cloud repository and preserves preface/numbered chapter contents',
    (tester) async {
      await openEditor(tester);
      await enterBulk(
        tester,
        'Lời dẫn nhập\r\n\r\n  Chương 1: Bắt đầu\r\nNội dung một\r\n\r\nHồi 2: Tiếp theo\r\nNội dung hai',
      );
      await tester.tap(find.text('Lưu tác phẩm'));
      await tester.pumpAndSettle();
      expect(repo.attempts, hasLength(1));
      final saved = repo.attempts.single;
      expect(saved.key, isNotEmpty);
      expect(saved.novel.ownerId, auth.currentUser.id);
      expect(saved.novel.moderationStatus, ModerationStatus.approved);
      expect(saved.chapters, [
        (title: 'Mở đầu', content: 'Lời dẫn nhập'),
        (title: 'Chương 1: Bắt đầu', content: 'Nội dung một'),
        (title: 'Hồi 2: Tiếp theo', content: 'Nội dung hai'),
      ]);
      expect(find.byType(NovelEditorScreen), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'An unknown save result keeps the form and retries the same submission including auto cover',
    (tester) async {
      repo.failAfterCommit = true;
      await openEditor(tester);
      await enterBulk(tester, 'Chương 1\nNội dung đã viết');
      await tester.tap(find.text('Lưu tác phẩm'));
      await tester.pumpAndSettle();
      expect(find.byType(NovelEditorScreen), findsOneWidget);
      expect(
        find.textContaining('Mạng ngắt sau khi máy chủ lưu'),
        findsOneWidget,
      );
      expect(find.text('Chương 1\nNội dung đã viết'), findsOneWidget);
      await tester.tap(find.text('Lưu tác phẩm'));
      await tester.pumpAndSettle();
      expect(repo.attempts, hasLength(2));
      expect(repo.attempts[1].key, repo.attempts[0].key);
      expect(repo.attempts[1].novel.coverUrl, repo.attempts[0].novel.coverUrl);
      expect(repo.savedByKey, hasLength(1));
      expect(find.byType(NovelEditorScreen), findsNothing);
    },
  );

  testWidgets('Changing a failed payload starts a new submission', (
    tester,
  ) async {
    repo.failAfterCommit = true;
    await openEditor(tester);
    await tester.tap(find.text('Lưu tác phẩm'));
    await tester.pumpAndSettle();
    final title = find.byKey(const ValueKey('novel-editor-title'));
    await tester.scrollUntilVisible(
      title,
      -250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(title, 'Truyện đã sửa');
    await tester.tap(find.text('Lưu tác phẩm'));
    await tester.pumpAndSettle();
    expect(repo.attempts[1].key, isNot(repo.attempts[0].key));
    expect(repo.attempts[1].novel.title, 'Truyện đã sửa');
  });

  testWidgets(
    'A pending save blocks duplicate clicks, edits and Android back',
    (tester) async {
      repo.pending = Completer<void>();
      await openEditor(tester);
      await tester.tap(find.text('Lưu tác phẩm'));
      await tester.pump();
      expect(find.text('Đang lưu…'), findsOneWidget);
      expect(
        tester.widget<TextFormField>(find.byType(TextFormField).first).enabled,
        isFalse,
      );
      await tester.tap(find.text('Đang lưu…'));
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.byType(NovelEditorScreen), findsOneWidget);
      expect(repo.attempts, hasLength(1));
      repo.pending!.complete();
      await tester.pumpAndSettle();
      expect(find.byType(NovelEditorScreen), findsNothing);
    },
  );

  testWidgets(
    'An audit failure reports that the work was saved and does not ask to resubmit',
    (tester) async {
      repo.failAudit = true;
      await openEditor(tester);
      await tester.tap(find.text('Lưu tác phẩm'));
      await tester.pumpAndSettle();
      expect(repo.savedByKey, hasLength(1));
      expect(find.byType(NovelEditorScreen), findsNothing);
      expect(
        find.text('Tác phẩm đã lưu, nhưng chưa ghi được nhật ký quản trị.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('Empty chapter bodies are rejected without losing the draft', (
    tester,
  ) async {
    await openEditor(tester);
    await enterBulk(tester, 'Chương 1\nNội dung một\nChương 2\n');
    await tester.tap(find.text('Lưu tác phẩm'));
    await tester.pumpAndSettle();
    expect(repo.attempts, isEmpty);
    expect(find.textContaining('Vui lòng sửa lỗi:'), findsOneWidget);
    expect(find.byType(NovelEditorScreen), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
  });

  testWidgets(
    'The mobile editor fits the Manga selector and shows save errors above the scrolled form',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      repo.failAfterCommit = true;
      await openEditor(tester);
      await tester.scrollUntilVisible(
        find.text('Truyện chữ'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Truyện chữ'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Truyện tranh / Manga').last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await enterBulk(
        tester,
        'Chapter 1\n[img]https://example.invalid/page.jpg[/img]',
      );
      await tester.tap(find.text('Lưu tác phẩm'));
      await tester.pumpAndSettle();
      expect(repo.attempts.single.novel.type, 'comic');
      final error = find.textContaining('Mạng ngắt sau khi máy chủ lưu');
      expect(error, findsOneWidget);
      expect(tester.getTopLeft(error).dy, lessThan(200));
      expect(tester.takeException(), isNull);
      await tester.pageBack();
      await tester.pumpAndSettle();
    },
  );
}
