import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/repositories/supabase_novel_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Novel draftNovel() => Novel(
  id: 0,
  title: 'Truyện mới',
  author: 'Tác giả',
  coverUrl: 'cover',
  description: 'Giới thiệu',
  status: 'ongoing',
  type: 'novel',
  genres: const ['Fantasy'],
  totalChapters: 0,
  rating: 0,
  views: 0,
  updatedAt: DateTime(2026),
  ownerId: 'admin-id',
);

void main() {
  late SupabaseClient client;
  late SupabaseNovelRepository repo;
  final requests = <http.Request>[];
  late Object response;
  late int status;

  setUp(() {
    requests.clear();
    status = 200;
    response = draftNovel().copyWith(id: 501, totalChapters: 2).toMap();
    client = SupabaseClient(
      'https://novelreader-test.invalid',
      'test-publishable-key',
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode(response),
          status,
          headers: {'content-type': 'application/json; charset=utf-8'},
          request: request,
        );
      }),
    );
    repo = SupabaseNovelRepository(client: client);
  });
  tearDown(() async => client.dispose());

  test('A new admin novel and all chapters use the existing atomic cloud import RPC', () async {
    final saved = await repo.saveNovel(
      draftNovel(),
      requestId: 'bulk-1',
      chapters: const [
        (title: 'Chương 1', content: 'Nội dung một'),
        (title: 'Chương 2', content: 'Nội dung hai'),
      ],
    );
    expect(saved.id, 501);
    expect(saved.totalChapters, 2);
    expect(requests, hasLength(1));
    expect(requests.single.method, 'POST');
    expect(requests.single.url.path, '/rest/v1/rpc/create_novel_with_chapters');
    final payload = jsonDecode(requests.single.body) as Map;
    expect(payload['p_request_id'], 'bulk-1');
    expect(payload['p_novel']['owner_id'], 'admin-id');
    expect(payload['p_novel']['total_chapters'], 2);
    expect(payload['p_chapters'], [
      {'title': 'Chương 1', 'content': 'Nội dung một'},
      {'title': 'Chương 2', 'content': 'Nội dung hai'},
    ]);
  });

  test(
    'A book without initial chapters uses the same retry-safe create RPC',
    () async {
      response = draftNovel().copyWith(id: 502).toMap();
      final saved = await repo.saveNovel(draftNovel(), requestId: 'empty-book');
      expect(saved.id, 502);
      expect(saved.totalChapters, 0);
      expect(jsonDecode(requests.single.body)['p_chapters'], isEmpty);
      expect(
        requests.single.url.path,
        '/rest/v1/rpc/create_novel_with_chapters',
      );
    },
  );

  test('Editing metadata retains server chapter count, views, rating, ownership and moderation', () async {
    final old = draftNovel().copyWith(id: 501, totalChapters: 1, views: 1);
    response = old
        .copyWith(
          totalChapters: 4,
          views: 900,
          rating: 4.5,
          moderationStatus: ModerationStatus.pending,
          isFeatured: true,
        )
        .toMap();
    final saved = await repo.saveNovel(old.copyWith(title: 'Tên mới'));
    expect(saved.totalChapters, 4);
    expect(saved.views, 900);
    expect(saved.rating, 4.5);
    expect(saved.moderationStatus, ModerationStatus.pending);
    expect(saved.isFeatured, isTrue);
    expect(requests, hasLength(1));
    expect(requests.single.method, 'PATCH');
    expect(requests.single.url.queryParameters['deleted_at'], 'is.null');
    final body = jsonDecode(requests.single.body) as Map;
    expect(body['title'], 'Tên mới');
    expect(
      body.keys,
      unorderedEquals([
        'title',
        'author',
        'cover_url',
        'description',
        'status',
        'type',
        'genres',
        'updated_at',
        'search_text',
      ]),
    );
  });

  test('A stale editor cannot recreate a missing or deleted book', () async {
    status = 406;
    response = {
      'code': 'PGRST116',
      'message': 'No rows',
      'details': null,
      'hint': null,
    };
    await expectLater(
      repo.saveNovel(draftNovel().copyWith(id: 501)),
      throwsA(isA<PostgrestException>()),
    );
    expect(requests, hasLength(1));
    expect(requests.single.method, 'PATCH');
  });

  test('Missing create key and bulk input on an existing book fail before network IO', () async {
    await expectLater(repo.saveNovel(draftNovel()), throwsArgumentError);
    await expectLater(
      repo.saveNovel(
        draftNovel().copyWith(id: 501),
        chapters: const [
          (title: 'Chương khác', content: 'Không nhập vào tác phẩm đang sửa'),
        ],
      ),
      throwsArgumentError,
    );
    expect(requests, isEmpty);
  });
}
