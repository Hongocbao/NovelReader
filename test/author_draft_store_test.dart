import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/services/author_draft_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('legacy draft migrates with the same content and retry key', () async {
    SharedPreferences.setMockInitialValues({
      'author_draft_title_a': 'Tên truyện',
      'author_draft_description_a': 'Giới thiệu',
      'author_draft_chapter_title_a': 'Chương 8',
      'author_draft_content_a': '  Nội dung\nchưa sửa  ',
      'author_draft_request_id_a': 'retry-original',
    });
    final prefs = await SharedPreferences.getInstance();
    final store = AuthorDraftStore(prefs);
    final draft = store.load('a');
    await store.save('a', draft);
    expect(store.load('a'), draft);
    expect(draft.content, '  Nội dung\nchưa sửa  ');
    expect(draft.requestId, 'retry-original');
    expect(
      jsonDecode(prefs.getString(AuthorDraftStore.keyFor('a'))!),
      draft.toMap(),
    );
  });

  test('title-only drafts and deliberate erasures persist', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = AuthorDraftStore(prefs);
    await store.save('a', const AuthorDraft(title: 'Chỉ có tên'));
    expect(store.load('a').title, 'Chỉ có tên');
    await store.save('a', const AuthorDraft(content: 'Bản cũ'));
    await store.save('a', const AuthorDraft());
    expect(AuthorDraftStore(prefs).load('a').isEmpty, isTrue);
  });

  test(
    'reopened stores serialize saves and cannot clear a newer draft',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final first = AuthorDraftStore(prefs);
      final reopened = AuthorDraftStore(prefs);
      const submitted = AuthorDraft(content: 'Đã gửi', requestId: 'original');
      await first.save('a', submitted);
      final writes = [
        for (var i = 0; i < 30; i++)
          reopened.save('a', AuthorDraft(content: 'Mới $i', requestId: 'r$i')),
      ];
      final cleared = first.clearIfMatches('a', submitted);
      await Future.wait(writes);
      expect(await cleared, isFalse);
      expect(first.load('a').content, 'Mới 29');
      expect(first.load('a').requestId, 'r29');
    },
  );

  test(
    'cleared draft tombstone prevents legacy content from returning',
    () async {
      SharedPreferences.setMockInitialValues({
        'author_draft_content_a': 'Bản cũ trong khóa cũ',
        'author_draft_request_id_a': 'legacy-request',
      });
      final prefs = await SharedPreferences.getInstance();
      final store = AuthorDraftStore(prefs);
      final draft = store.load('a');
      expect(await store.clearIfMatches('a', draft), isTrue);
      expect(AuthorDraftStore(prefs).load('a').isEmpty, isTrue);
      expect(prefs.getString('author_draft_content_a'), isNotNull);
    },
  );

  test('account draft saves and clears are independent', () async {
    SharedPreferences.setMockInitialValues({});
    final store = AuthorDraftStore(await SharedPreferences.getInstance());
    const a = AuthorDraft(content: 'Tác giả A', requestId: 'a-request');
    const b = AuthorDraft(content: 'Tác giả B', requestId: 'b-request');
    await Future.wait([store.save('a', a), store.save('b', b)]);
    await store.clearIfMatches('a', a);
    expect(store.load('b'), b);
    expect(store.load('').isEmpty, isTrue);
    await expectLater(store.save('', a), throwsArgumentError);
  });

  test(
    'unreadable new draft stays intact instead of resurrecting legacy data',
    () async {
      SharedPreferences.setMockInitialValues({
        AuthorDraftStore.keyFor('a'): '{broken-json',
        'author_draft_content_a': 'Stale legacy content',
      });
      final prefs = await SharedPreferences.getInstance();
      expect(() => AuthorDraftStore(prefs).load('a'), throwsFormatException);
      expect(prefs.getString(AuthorDraftStore.keyFor('a')), '{broken-json');
    },
  );
}
