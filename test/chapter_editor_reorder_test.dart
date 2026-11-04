import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/models/glossary_term.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/providers/admin_novel_provider.dart';
import 'package:novel_reader/providers/auth_provider.dart';
import 'package:novel_reader/screens/admin/chapter_editor_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'security_and_roles_test.dart'
    show FakeAuthRepository, FakeNovelRepository;

class _ChapterRepository extends FakeNovelRepository {
  List<Chapter> remote = [
    for (var i = 1; i <= 3; i++)
      Chapter(id: 900 + i, novelId: 9, chapterIndex: i, title: 'Mục $i'),
  ];
  Completer<void>? pending;
  bool failBeforeCommit = false;
  bool loseResponse = false;
  int saves = 0;
  int loads = 0;
  int glossaryLoads = 0;

  @override
  Future<List<Chapter>> getChapters(int novelId) async {
    loads++;
    return List.of(remote);
  }

  @override
  Future<List<GlossaryTerm>> getGlossaryTerms(int novelId) async {
    glossaryLoads++;
    return [
      GlossaryTerm(
        id: 1,
        novelId: novelId,
        term: 'Thuật ngữ trên máy chủ',
        meaning: 'Giải nghĩa đã đồng bộ',
      ),
    ];
  }

  @override
  Future<void> saveChaptersOrder(
    int novelId,
    List<Chapter> orderedChapters,
  ) async {
    saves++;
    final snapshot = List.of(orderedChapters);
    await pending?.future;
    if (failBeforeCommit) throw StateError('Chưa kết nối được máy chủ');
    remote = [
      for (var i = 0; i < snapshot.length; i++)
        snapshot[i].copyWith(chapterIndex: i + 1),
    ];
    if (loseResponse) throw StateError('Mất phản hồi sau khi lưu');
  }
}

void main() {
  late AuthProvider auth;
  late AdminNovelProvider admin;
  late _ChapterRepository repo;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    auth = AuthProvider(
      FakeAuthRepository(),
      await SharedPreferences.getInstance(),
    );
    expect(await auth.login('admin@novelreader.local', 'Admin@123'), isTrue);
    repo = _ChapterRepository();
    admin = AdminNovelProvider(null, repo);
  });
  tearDown(() {
    auth.dispose();
    admin.dispose();
  });

  Future<void> openEditor(WidgetTester tester) async {
    final book = Novel(
      id: 9,
      title: 'Truyện cần sắp xếp',
      author: 'Tác giả',
      coverUrl: '',
      description: '',
      status: 'ongoing',
      type: 'novel',
      genres: const [],
      totalChapters: 3,
      rating: 0,
      views: 0,
      updatedAt: DateTime(2026),
    );
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<AdminNovelProvider>.value(value: admin),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ChapterEditorScreen(novel: book),
                  ),
                ),
                child: const Text('Mở danh sách'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Mở danh sách'));
    await tester.pumpAndSettle();
  }

  void reorder(WidgetTester tester, int from, int to) => tester
      .widget<ReorderableListView>(find.byType(ReorderableListView))
      .onReorderItem!(from, to);
  List<String> visibleTitles(WidgetTester tester) => tester
      .widgetList<ListTile>(find.byType(ListTile))
      .map((tile) => (tile.title! as Text).data!)
      .toList();

  testWidgets(
    'A pending reorder blocks duplicate drags and Android back, then shows server indexes',
    (tester) async {
      repo.pending = Completer<void>();
      await openEditor(tester);
      reorder(tester, 0, 2);
      await tester.pump();
      reorder(tester, 0, 1);
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(repo.saves, 1);
      expect(find.byType(ChapterEditorScreen), findsOneWidget);
      expect(
        tester
            .widget<ReorderableListView>(find.byType(ReorderableListView))
            .buildDefaultDragHandles,
        isFalse,
      );
      repo.pending!.complete();
      await tester.pumpAndSettle();
      expect(visibleTitles(tester), ['Mục 2', 'Mục 3', 'Mục 1']);
      expect(repo.remote.map((c) => c.chapterIndex), [1, 2, 3]);
      expect(repo.loads, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'A rejected reorder restores the real server order and stays usable',
    (tester) async {
      repo.failBeforeCommit = true;
      await openEditor(tester);
      reorder(tester, 0, 2);
      await tester.pumpAndSettle();
      expect(visibleTitles(tester), ['Mục 1', 'Mục 2', 'Mục 3']);
      expect(
        find.textContaining('Chưa xác nhận được thứ tự mới'),
        findsOneWidget,
      );
      expect(repo.loads, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'A lost save response reloads the committed order instead of leaving an incorrect rollback',
    (tester) async {
      repo.loseResponse = true;
      await openEditor(tester);
      reorder(tester, 0, 2);
      await tester.pumpAndSettle();
      expect(visibleTitles(tester), ['Mục 2', 'Mục 3', 'Mục 1']);
      expect(repo.loads, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Mobile editor loads cloud glossary and can refresh a changed chapter list',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await openEditor(tester);
      expect(repo.glossaryLoads, 1);
      expect(tester.takeException(), isNull);
      repo.remote.add(
        const Chapter(id: 904, novelId: 9, chapterIndex: 4, title: 'Mục mới'),
      );
      await tester.tap(find.byTooltip('Tải lại danh sách'));
      await tester.pumpAndSettle();
      expect(find.text('Mục mới'), findsOneWidget);
      await tester.tap(find.text('Từ điển thuật ngữ'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Thuật ngữ trên máy chủ'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
