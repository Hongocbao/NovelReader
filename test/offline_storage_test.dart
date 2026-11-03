import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/providers/reader_provider.dart';
import 'package:novel_reader/utils/constants.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  late String sampleJson;
  late AppDatabase db;
  late ReaderProvider reader;
  late Novel textNovel;
  late Novel manga;
  late Novel remoteNovel;
  late List<Chapter> textChapters;
  late List<Chapter> mangaChapters;
  late List<Chapter> remoteChapters;
  const text = 'Nội dung gốc của truyện TXT tự nhập.';
  const image =
      '[img]data:image/png;base64,'
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aUioAAAAASUVORK5CYII=[/img]';

  setUpAll(() async {
    sampleJson = await File('assets/data/sample_novels.json').readAsString();
  });

  setUp(() async {
    db = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
      sampleJsonLoader: () async => sampleJson,
    );
    reader = ReaderProvider(
      db,
      connectivityStream: const Stream.empty(),
      checkConnectivity: () async => true,
    );
    await reader.init();
    textNovel = await db.insertCustomNovel(
      title: 'TXT cá nhân',
      author: 'Độc giả',
      description: '',
      status: NovelStatus.ongoing,
      type: NovelType.novel,
      genres: const [],
      chapters: const [(title: 'Chương 1', content: text)],
    );
    manga = await db.insertCustomNovel(
      title: 'Manga cá nhân',
      author: 'Độc giả',
      description: '',
      status: NovelStatus.ongoing,
      type: NovelType.comic,
      genres: const [],
      chapters: const [(title: 'Chapter 1', content: image)],
    );
    textChapters = await reader.loadChapters(textNovel.id);
    mangaChapters = await reader.loadChapters(manga.id);
    remoteNovel = (await db.queryNovels(limit: 100))
        .firstWhere((n) => n.id > 0);
    remoteChapters = await reader.loadChapters(remoteNovel.id);
  });

  tearDown(() async {
    reader.dispose();
    await db.close();
  });

  test('Clear downloads removes remote cache and keeps imported TXT and Manga readable', () async {
    await reader.downloadChapters(remoteNovel.id, [
      remoteChapters.first,
    ], novel: remoteNovel);
    await reader.loadDownloads();
    expect(reader.downloaded.map((d) => d.chapter.novelId), [remoteNovel.id]);
    await reader.openNovel(manga);

    await reader.deleteDownloads();
    expect(reader.downloaded, isEmpty);
    expect(reader.currentChapter!.isDownloaded, isTrue);
    expect(reader.chaptersOf(textNovel.id)!.single.isDownloaded, isTrue);
    expect(reader.chaptersOf(manga.id)!.single.isDownloaded, isTrue);
    expect(reader.chaptersOf(remoteNovel.id)!.first.isDownloaded, isFalse);

    reader.forceOffline = true;
    await reader.openNovel(textNovel);
    expect(reader.content, text);
    expect(reader.contentError, isNull);
    await reader.openNovel(manga);
    expect(reader.content, image);
    expect(reader.contentError, isNull);
    await reader.openNovel(remoteNovel, chapterId: remoteChapters.first.id);
    expect(reader.contentError, AppStrings.chapterOfflineError);
  });

  test(
    'Single-chapter and per-novel cleanup cannot erase imported originals',
    () async {
      await db.deleteChapterContent(textChapters.single);
      expect(await db.deleteDownloads(novelId: textNovel.id), 0);
      await reader.deleteDownload(mangaChapters.single);
      await reader.deleteDownloads(novelId: manga.id);

      final savedText = await db.getChapter(
        textChapters.single.id,
        novelId: textNovel.id,
      );
      final savedManga = await db.getChapter(
        mangaChapters.single.id,
        novelId: manga.id,
      );
      expect(savedText!.content, text);
      expect(savedText.isDownloaded, isTrue);
      expect(savedManga!.content, image);
      expect(savedManga.isDownloaded, isTrue);
      expect(reader.chaptersOf(manga.id)!.single.isDownloaded, isTrue);
    },
  );

  test('Deleting one remote download leaves other downloaded chapters readable offline', () async {
    await reader.downloadChapters(
      remoteNovel.id,
      remoteChapters.take(2).toList(),
      novel: remoteNovel,
    );
    await reader.deleteDownload(remoteChapters.first);
    expect(reader.downloaded.map((d) => d.chapter.id), [remoteChapters[1].id]);

    reader.forceOffline = true;
    await reader.openNovel(remoteNovel, chapterId: remoteChapters[1].id);
    expect(reader.contentError, isNull);
    expect(reader.content, isNotEmpty);
    await reader.openChapter(remoteChapters.first);
    expect(reader.contentError, AppStrings.chapterOfflineError);
    await reader.openNovel(textNovel);
    expect(reader.content, text);
  });
}
