import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:novel_reader/database/supabase_database.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/repositories/supabase_novel_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

http.Response jsonReply(Object value, [int status = 200]) => http.Response(
  jsonEncode(value),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

void main() {
  final requests = <http.Request>[];
  late SupabaseClient client;
  late SupabaseDatabase db;
  late Future<http.Response> Function(http.Request) reply;
  final chapter = {
    'id': 96001,
    'novel_id': 9,
    'chapter_index': 12003,
    'title': 'Chương 12003: Tiếp tục',
    'content': 'Nội dung',
    'is_downloaded': 0,
  };

  setUp(() {
    requests.clear();
    reply = (_) async => jsonReply(chapter);
    client = SupabaseClient(
      'https://novelreader-test.invalid',
      'test-publishable-key',
      httpClient: MockClient((request) async {
        requests.add(request);
        final response = await reply(request);
        return http.Response.bytes(
          response.bodyBytes,
          response.statusCode,
          headers: response.headers,
          request: request,
        );
      }),
    );
    db = SupabaseDatabase.withClient(client);
  });
  tearDown(() async => client.dispose());

  test(
    'Cloud append uses one atomic RPC and the server chapter ID/index',
    () async {
      final result = await db.appendChapter(
        novelId: 9,
        title: '  Tiếp tục  ',
        content: '  Nội dung  ',
        requestId: 'request-1',
      );
      expect(result.id, 96001);
      expect(result.chapterIndex, 12003);
      expect(result.isDownloaded, isFalse);
      expect(requests, hasLength(1));
      expect(requests.single.method, 'POST');
      expect(requests.single.url.path, '/rest/v1/rpc/append_novel_chapter');
      expect(jsonDecode(requests.single.body), {
        'p_novel_id': 9,
        'p_title': 'Tiếp tục',
        'p_content': 'Nội dung',
        'p_request_id': 'request-1',
      });
    },
  );

  test(
    'A failed request can retry with the same key without a legacy write',
    () async {
      reply = (_) async => throw http.ClientException('Connection interrupted');
      Future<void> submit() async => db.appendChapter(
        novelId: 9,
        title: 'Tiếp tục',
        content: 'Nội dung',
        requestId: 'retry-1',
      );
      await expectLater(submit(), throwsA(isA<http.ClientException>()));
      reply = (_) async => jsonReply(chapter);
      await submit();
      expect(requests, hasLength(2));
      expect(requests[0].body, requests[1].body);
      expect(
        requests.every((r) => r.url.path.endsWith('/rpc/append_novel_chapter')),
        isTrue,
      );
    },
  );

  test('An old database gives an actionable error and does not fall back to partial writes', () async {
    reply = (_) async => jsonReply({
      'code': 'PGRST202',
      'message': 'Function not found',
      'details': null,
      'hint': null,
    }, 404);
    await expectLater(
      db.appendChapter(
        novelId: 9,
        title: '',
        content: 'Nội dung',
        requestId: 'upgrade',
      ),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('cập nhật cơ sở dữ liệu'),
        ),
      ),
    );
    expect(requests, hasLength(1));
  });

  test(
    'Empty content, bad book IDs and keys are rejected before network IO',
    () async {
      for (final input in [
        (book: 9, content: ' \n ', key: 'empty'),
        (book: -1, content: 'Nội dung', key: 'local'),
        (book: 9, content: 'Nội dung', key: ''),
        (book: 9, content: 'Nội dung', key: 'x' * 129),
      ]) {
        await expectLater(
          db.appendChapter(
            novelId: input.book,
            title: '',
            content: input.content,
            requestId: input.key,
          ),
          throwsArgumentError,
        );
      }
      expect(requests, isEmpty);
    },
  );

  test(
    'Invalid RPC output cannot report a chapter saved to another book',
    () async {
      reply = (_) async => jsonReply({...chapter, 'novel_id': 8});
      await expectLater(
        db.appendChapter(
          novelId: 9,
          title: '',
          content: 'Nội dung',
          requestId: 'wrong-book',
        ),
        throwsStateError,
      );
      reply = (_) async => jsonReply([]);
      await expectLater(
        db.appendChapter(
          novelId: 9,
          title: '',
          content: 'Nội dung',
          requestId: 'bad-output',
        ),
        throwsStateError,
      );
    },
  );

  test('Admin creation also uses the atomic append RPC', () async {
    final repo = SupabaseNovelRepository(client: client);
    final saved = await repo.saveChapter(
      const Chapter(
        id: 0,
        novelId: 9,
        chapterIndex: 1,
        title: 'Tiếp tục',
        content: 'Nội dung',
      ),
      requestId: 'admin-request',
    );
    expect(saved.id, 96001);
    expect(saved.chapterIndex, 12003);
    expect(requests, hasLength(1));
    expect(requests.single.url.path, '/rest/v1/rpc/append_novel_chapter');
    expect(jsonDecode(requests.single.body)['p_request_id'], 'admin-request');
  });

  test('Editing uses the existing chapter and does not overwrite a reordered index or total', () async {
    final repo = SupabaseNovelRepository(client: client);
    final saved = await repo.saveChapter(
      const Chapter(
        id: 96001,
        novelId: 9,
        chapterIndex: 1,
        title: 'Tiếp tục',
        content: 'Nội dung',
        isDownloaded: true,
      ),
    );
    expect(saved.chapterIndex, 12003);
    expect(saved.isDownloaded, isFalse);
    expect(requests, hasLength(1));
    final request = requests.single;
    expect(request.method, 'PATCH');
    expect(request.url.path, '/rest/v1/chuong');
    expect(request.url.queryParameters['id'], 'eq.96001');
    expect(request.url.queryParameters['novel_id'], 'eq.9');
    expect(jsonDecode(request.body), {
      'title': 'Tiếp tục',
      'content': 'Nội dung',
      'publish_at': null,
    });
  });

  test('A removed chapter is not recreated by a stale editor', () async {
    reply = (_) async => jsonReply({
      'code': 'PGRST116',
      'message': 'No rows',
      'details': null,
      'hint': null,
    }, 406);
    await expectLater(
      SupabaseNovelRepository(client: client).saveChapter(
        const Chapter(
          id: 96001,
          novelId: 9,
          chapterIndex: 1,
          title: 'X',
          content: 'Y',
        ),
      ),
      throwsA(isA<PostgrestException>()),
    );
    expect(requests, hasLength(1));
    expect(requests.single.method, 'PATCH');
  });

  test('Reordering sends desired and original orders in one RPC', () async {
    reply = (_) async => jsonReply(true);
    final parts = [
      for (var i = 1; i <= 3; i++)
        Chapter(
          id: 900 + i,
          novelId: 9,
          chapterIndex: i * 10,
          title: 'Chương $i',
        ),
    ];
    await SupabaseNovelRepository(client: client)
        .saveChaptersOrder(9, [parts[2], parts[0], parts[1]]);
    expect(requests, hasLength(1));
    expect(requests.single.url.path, '/rest/v1/rpc/reorder_novel_chapters');
    expect(jsonDecode(requests.single.body), {
      'p_novel_id': 9,
      'p_chapter_ids': [903, 901, 902],
      'p_expected_ids': [901, 902, 903],
    });
  });

  test('Malformed reorder lists fail before sending partial writes', () async {
    final first = Chapter.fromMap(chapter);
    final other = first.copyWith(id: 96002, novelId: 8, chapterIndex: 2);
    final sameIndex = first.copyWith(id: 96003);
    final repo = SupabaseNovelRepository(client: client);
    for (final parts in [
      [first, first],
      [first, other],
      [first, sameIndex],
    ]) {
      await expectLater(repo.saveChaptersOrder(9, parts), throwsArgumentError);
    }
    expect(requests, isEmpty);
  });

  test('Unsupported or unconfirmed reorder never falls back to per-chapter updates', () async {
    final repo = SupabaseNovelRepository(client: client);
    reply = (_) async => jsonReply({
      'code': 'PGRST202',
      'message': 'Missing RPC',
      'details': null,
      'hint': null,
    }, 404);
    await expectLater(
      repo.saveChaptersOrder(9, [Chapter.fromMap(chapter)]),
      throwsStateError,
    );
    reply = (_) async => jsonReply(false);
    await expectLater(
      repo.saveChaptersOrder(9, [Chapter.fromMap(chapter)]),
      throwsStateError,
    );
    expect(requests, hasLength(2));
    expect(
      requests.every((r) => r.url.path.endsWith('/rpc/reorder_novel_chapters')),
      isTrue,
    );
  });

  test(
    'Admin chapter loading pages past 1000 rows without fetching all content',
    () async {
      reply = (_) async => jsonReply([
        for (
          var i = requests.length == 1 ? 1 : 1001;
          i <= (requests.length == 1 ? 1000 : 1001);
          i++
        )
          {...chapter, 'id': 96000 + i, 'chapter_index': 1002 - i},
      ]);
      final parts = await SupabaseNovelRepository(client: client)
          .getChapters(9);
      expect(parts, hasLength(1001));
      expect(parts.first.id, 97001);
      expect(parts.last.chapterIndex, 1001);
      expect(requests, hasLength(2));
      expect(requests[1].url.queryParameters['offset'], '1000');
      expect(
        requests.every((r) => r.url.queryParameters['order'] == 'id.asc.nullslast'),
        isTrue,
      );
      expect(
        requests.every(
          (r) => !r.url.queryParameters['select']!
              .split(',')
              .map((s) => s.trim())
              .contains('content'),
        ),
        isTrue,
      );
    },
  );
}
