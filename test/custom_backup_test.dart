import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/models/bookmark.dart';
import 'package:novel_reader/models/library_item.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/models/reading_history.dart';
import 'package:novel_reader/providers/reader_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  late AppDatabase source;
  late AppDatabase target;
  late Directory folder;
  late String sample;
  const manga =
      '[img]data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aUioAAAAASUVORK5CYII=[/img]';

  setUpAll(() async {
    sample = await File('assets/data/sample_novels.json').readAsString();
  });
  setUp(() async {
    final root = await Directory('build/backup_tests').create(recursive: true);
    folder = await root.createTemp('case_');
    source = AppDatabase(
      factory: databaseFactoryFfi,
      path: '${folder.path}/source.db',
      sampleJsonLoader: () async => sample,
    );
    target = AppDatabase(
      factory: databaseFactoryFfi,
      path: '${folder.path}/target.db',
      sampleJsonLoader: () async => sample,
    );
  });
  tearDown(() async {
    await source.close();
    await target.close();
    final root = Directory('build/backup_tests').absolute.path;
    if (!folder.absolute.path.startsWith('$root${Platform.pathSeparator}')) {
      throw StateError('Unexpected test folder');
    }
    await folder.delete(recursive: true);
  });

  Future<Novel> add(
    AppDatabase db,
    String title,
    String content, {
    String type = 'novel',
  }) async {
    final novel = await db.insertCustomNovel(
      title: title,
      author: 'Tác giả',
      description: 'Giới thiệu',
      status: 'ongoing',
      type: type,
      genres: const ['Fantasy'],
      chapters: [(title: 'Chương 1', content: content)],
    );
    final chapter = (await db.getChapters(novel.id)).single;
    await db.upsertLibrary(
      LibraryItem(
        novelId: novel.id,
        category: 'reading',
        addedAt: DateTime(2026),
      ),
    );
    await db.saveHistory(
      ReadingHistory(
        novelId: novel.id,
        lastChapterId: chapter.id,
        scrollOffset: .6,
        lastReadAt: DateTime(2026),
      ),
    );
    await db.addBookmark(
      Bookmark(
        novelId: novel.id,
        chapterId: chapter.id,
        scrollOffset: .5,
        note: title,
        createdAt: DateTime(2026),
      ),
    );
    return novel;
  }

  test(
    'A fresh device restores complete TXT and Manga with reading progress',
    () async {
      await add(source, 'Truyện chữ', 'Nội dung gốc');
      await add(source, 'Truyện tranh', manga, type: 'comic');
      await target.importUserBackupJson(await source.exportUserBackupJson());
      final books = await target.getLibrary();
      expect(books.length, 2);
      final reader = ReaderProvider(
        target,
        connectivityStream: const Stream.empty(),
        checkConnectivity: () async => false,
      );
      await reader.init();
      try {
        for (final book in books) {
          final novel = book.novel!;
          await reader.openNovel(novel);
          expect(reader.contentError, isNull);
          expect(reader.content, novel.isComic ? manga : 'Nội dung gốc');
          final history = (await target.getHistoryFor(novel.id))!;
          expect(history.scrollOffset, .6);
          expect(history.lastChapterId, reader.currentChapter!.id);
          expect(
            (await target.getBookmarks(novel.id)).single.chapterId,
            reader.currentChapter!.id,
          );
          expect((await target.getBookmarks(novel.id)).single.id, lessThan(0));
        }
      } finally {
        reader.dispose();
      }
    },
  );

  test('Colliding device IDs are remapped without overwriting existing stories/bookmarks', () async {
    final original = await add(
      target,
      'Đang có trên máy',
      'Giữ nguyên nội dung',
    );
    await add(source, 'Trong file sao lưu', 'Nội dung khôi phục');
    final backup = await source.exportUserBackupJson();
    await target.importUserBackupJson(backup);
    final books = await target.getLibrary();
    expect(books.length, 2);
    final restored = books.singleWhere(
      (b) => b.novel!.title == 'Trong file sao lưu',
    );
    expect(restored.novelId, isNot(original.id));
    expect(
      (await target.getChapter(
        (await target.getChapters(original.id)).single.id,
        novelId: original.id,
      ))!.content,
      'Giữ nguyên nội dung',
    );
    expect(
      (await target.getBookmarks(original.id)).single.note,
      original.title,
    );
    final restoredChapter = (await target.getChapters(restored.novelId)).single;
    expect(
      (await target.getChapter(
        restoredChapter.id,
        novelId: restored.novelId,
      ))!.content,
      'Nội dung khôi phục',
    );
    expect(
      (await target.getHistoryFor(restored.novelId))!.lastChapterId,
      restoredChapter.id,
    );
    expect(
      (await target.getBookmarks(restored.novelId)).single.chapterId,
      restoredChapter.id,
    );

    await target.importUserBackupJson(backup);
    expect((await target.getLibrary()).length, 2);
    expect((await target.getBookmarks(restored.novelId)).length, 1);
    expect((await target.getBookmarks(original.id)).length, 1);
    final added = await add(target, 'Thêm sau khôi phục', 'Nội dung mới');
    final appended = await target.appendChapter(
      novelId: restored.novelId,
      title: 'Chương 2',
      content: 'Nội dung chương tiếp',
    );
    expect((await target.getLibrary()).length, 3);
    expect((await target.getChapters(added.id)).single.id, isNot(appended.id));
    expect(
      (await target.getChapter(
        appended.id,
        novelId: restored.novelId,
      ))!.content,
      'Nội dung chương tiếp',
    );
  });

  test('An invalid archive rolls back restored stories and leaves destination unchanged', () async {
    final original = await add(target, 'Bản gốc', 'Không đổi');
    await add(source, 'Sao lưu', 'Nội dung');
    final data =
        jsonDecode(await source.exportUserBackupJson()) as Map<String, dynamic>;
    (data['custom_chapters'] as List).add({
      ...((data['custom_chapters'] as List).single as Map),
      'id': -123456,
      'novel_id': -999,
    });
    await expectLater(
      target.importUserBackupJson(jsonEncode(data)),
      throwsFormatException,
    );
    expect((await target.getLibrary()).single.novelId, original.id);
    expect(
      (await target.getChapter(
        (await target.getChapters(original.id)).single.id,
        novelId: original.id,
      ))!.content,
      'Không đổi',
    );
    final sqlite = await target.database;
    expect((await sqlite.query('truyen', where: 'id < 0')).length, 1);
  });

  test(
    'Version 2 backup remains readable without the new content fields',
    () async {
      final novel = (await source.queryNovels(limit: 1)).single;
      await source.upsertLibrary(
        LibraryItem(
          novelId: novel.id,
          category: 'reading',
          addedAt: DateTime(2026),
        ),
      );
      final data = jsonDecode(
        await source.exportUserBackupJson(),
      ) as Map<String, dynamic>;
      data.remove('custom_novels');
      data.remove('custom_chapters');
      data.remove('cached_reading_history');
      data['backup_version'] = 2;
      await target.importUserBackupJson(jsonEncode(data));
      expect((await target.getLibrary()).single.novelId, novel.id);
    },
  );
}
