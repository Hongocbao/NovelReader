import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/providers/admin_novel_provider.dart';
import 'package:novel_reader/providers/auth_provider.dart';
import 'package:novel_reader/screens/user/author_studio_screen.dart';
import 'package:novel_reader/services/author_draft_store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'security_and_roles_test.dart'
    show FakeAuthRepository, FakeNovelRepository;

class _StudioRepository extends FakeNovelRepository {
  final pendingLists = <String, Completer<List<Novel>>>{};
  final saved = <String, Novel>{};
  final calls =
      <
        ({
          Novel novel,
          String key,
          AuthorDraft stored,
          List<({String title, String content})> chapters,
        })
      >[];
  Completer<void>? sendGate;
  bool failAfterFirstCommit = false;
  AuthorDraftStore? draftStore;

  @override
  Future<List<Novel>> getNovelsByOwner(String ownerId) async {
    final pending = pendingLists[ownerId];
    if (pending != null) return pending.future;
    return saved.values.where((n) => n.ownerId == ownerId).toList();
  }

  @override
  Future<Novel> saveNovel(
    Novel novel, {
    String? requestId,
    List<({String title, String content})> chapters = const [],
  }) async {
    final key = requestId!;
    calls.add((
      novel: novel,
      key: key,
      chapters: chapters,
      stored: draftStore!.load(novel.ownerId),
    ));
    await sendGate?.future;
    final existed = saved.containsKey(key);
    final result = saved.putIfAbsent(
      key,
      () => novel.copyWith(id: 100 + saved.length),
    );
    if (failAfterFirstCommit && !existed) {
      throw StateError('Lost response after server committed');
    }
    return result;
  }
}

void main() {
  late SharedPreferences prefs;
  late AuthorDraftStore store;
  late AuthProvider auth;
  late _StudioRepository repository;
  late AdminNovelProvider novels;
  const draft = AuthorDraft(
    title: 'Truyện của A',
    description: 'Giới thiệu',
    chapterTitle: '',
    content: '  Nội dung chưa xuất bản  ',
    requestId: 'original-request',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      AuthorDraftStore.keyFor('author-id'): jsonEncode(draft.toMap()),
    });
    prefs = await SharedPreferences.getInstance();
    store = AuthorDraftStore(prefs);
    auth = AuthProvider(FakeAuthRepository(), prefs);
    await auth.login('author@novelreader.local', 'Author@123');
    repository = _StudioRepository()..draftStore = store;
    novels = AdminNovelProvider(null, repository);
  });

  tearDown(() {
    auth.dispose();
    novels.dispose();
  });

  Future<void> showStudio(WidgetTester tester, {bool mobile = false}) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = mobile
        ? const Size(360, 1000)
        : const Size(900, 1400);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: auth),
          ChangeNotifierProvider.value(value: novels),
        ],
        child: const MaterialApp(home: AuthorStudioScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
  }

  TextField field(WidgetTester tester, String name) =>
      tester.widget<TextField>(find.byKey(ValueKey('author-draft-$name')));

  Future<void> submit(WidgetTester tester) async {
    final button = find.widgetWithText(FilledButton, 'Gửi duyệt xuất bản');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
  }

  testWidgets('local draft restores before a slow or offline cloud list', (
    tester,
  ) async {
    final list = Completer<List<Novel>>();
    repository.pendingLists['author-id'] = list;
    await showStudio(tester, mobile: true);
    expect(field(tester, 'title').controller!.text, draft.title);
    expect(field(tester, 'title').enabled, isTrue);
    list.completeError(StateError('offline'));
    await tester.pump();
    await tester.tap(find.text('Tác phẩm của tôi'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Bản nháp trên thiết bị vẫn sử dụng được'),
      findsOneWidget,
    );
    repository.pendingLists.clear();
    await tester.tap(find.text('Tải lại tác phẩm'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Bản nháp trên thiết bị vẫn sử dụng được'),
      findsNothing,
    );
    await tester.tap(find.text('Soạn thảo & Tự lưu nháp'));
    await tester.pumpAndSettle();
    expect(field(tester, 'title').controller!.text, draft.title);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('leaving immediately saves edits including an erased body', (
    tester,
  ) async {
    await showStudio(tester);
    await tester.enterText(
      find.byKey(const ValueKey('author-draft-title')),
      'Chỉ giữ tên mới',
    );
    await tester.enterText(
      find.byKey(const ValueKey('author-draft-content')),
      '',
    );
    // Exit before the 400 ms debounce and 5 second periodic save.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(store.load('author-id').title, 'Chỉ giữ tên mới');
    expect(store.load('author-id').content, isEmpty);
    expect(store.load('author-id').requestId, isNot(draft.requestId));
    await showStudio(tester);
    expect(field(tester, 'content').controller!.text, isEmpty);
    expect(field(tester, 'title').controller!.text, 'Chỉ giữ tên mới');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'pending submit locks duplicates and preserves a newer saved draft',
    (tester) async {
      repository.sendGate = Completer<void>();
      await showStudio(tester);
      final send = tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Gửi duyệt xuất bản'),
          )
          .onPressed!;
      send();
      send();
      await tester.pump();
      await tester.pump();
      expect(repository.calls, hasLength(1));
      await tester.pump(const Duration(milliseconds: 30));
      expect(field(tester, 'title').enabled, isFalse);
      expect(repository.calls.single.key, draft.requestId);
      // Content and retry key were persisted before the cloud request began.
      expect(repository.calls.single.stored.requestId, draft.requestId);
      expect(repository.calls.single.stored.content, draft.content);
      expect(
        repository.calls.single.chapters.single.title,
        AuthorDraft.defaultChapterTitle,
      );
      const newer = AuthorDraft(
        title: 'Bản mới từ cửa sổ khác',
        content: 'Đang viết tiếp',
        requestId: 'newer-request',
      );
      await AuthorDraftStore(prefs).save('author-id', newer);
      repository.sendGate!.complete();
      await tester.pumpAndSettle();
      expect(repository.saved, hasLength(1));
      expect(store.load('author-id'), newer);
      expect(field(tester, 'content').controller!.text, newer.content);
      expect(field(tester, 'title').enabled, isTrue);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('backgrounding saves the latest text before the debounce', (
    tester,
  ) async {
    await showStudio(tester);
    await tester.enterText(
      find.byKey(const ValueKey('author-draft-content')),
      'Vừa viết trên điện thoại',
    );
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(store.load('author-id').content, 'Vừa viết trên điện thoại');
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('lost response retries the same request without a second book', (
    tester,
  ) async {
    repository.failAfterFirstCommit = true;
    await prefs.setString('author_draft_content_author-id', 'Legacy body');
    await showStudio(tester);
    await submit(tester);
    await tester.pumpAndSettle();
    expect(find.textContaining('Bản nháp vẫn được giữ'), findsOneWidget);
    expect(field(tester, 'content').controller!.text, draft.content);
    expect(store.load('author-id').requestId, draft.requestId);
    await submit(tester);
    await tester.pumpAndSettle();
    expect(repository.calls.map((c) => c.key), [
      draft.requestId,
      draft.requestId,
    ]);
    expect(repository.saved, hasLength(1));
    expect(store.load('author-id').isEmpty, isTrue);
    await tester.pumpWidget(const SizedBox());
    await showStudio(tester);
    expect(field(tester, 'content').controller!.text, isEmpty);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'late list and submission cannot replace the next account draft',
    (tester) async {
      final list = Completer<List<Novel>>();
      repository.pendingLists['author-id'] = list;
      repository.sendGate = Completer<void>();
      const b = AuthorDraft(
        title: 'Bản của B',
        content: 'B đang viết',
        requestId: 'b-request',
      );
      await store.save('admin-id', b);
      await showStudio(tester);
      await submit(tester);
      await auth.login('admin@novelreader.local', 'Admin@123');
      await tester.pump();
      await tester.pump();
      expect(field(tester, 'title').controller!.text, b.title);
      expect(field(tester, 'title').enabled, isTrue);
      list.complete([]);
      repository.sendGate!.complete();
      await tester.pumpAndSettle();
      expect(field(tester, 'title').controller!.text, b.title);
      expect(store.load('admin-id'), b);
      expect(store.load('author-id').isEmpty, isTrue);
      expect(find.text('Đã gửi tác phẩm vào hàng chờ duyệt.'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'completing cloud work after closing does not touch controllers',
    (tester) async {
      final list = Completer<List<Novel>>();
      repository.pendingLists['author-id'] = list;
      repository.sendGate = Completer<void>();
      await showStudio(tester);
      await submit(tester);
      await tester.pumpWidget(const SizedBox());
      list.complete([]);
      repository.sendGate!.complete();
      await tester.pump();
      await tester.pump();
      expect(store.load('author-id').isEmpty, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}
