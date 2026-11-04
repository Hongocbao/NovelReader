import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/bookmark.dart';
import '../models/chapter.dart';
import '../models/chapter_summary.dart';
import '../models/glossary_term.dart';
import '../models/library_item.dart';
import '../models/novel.dart';
import '../models/reading_history.dart';
import '../repositories/reading_history_remote.dart';
import '../repositories/library_remote.dart';
import '../repositories/bookmark_remote.dart';
import '../repositories/quote_remote.dart';
import '../repositories/reading_stats_remote.dart';
import '../repositories/reader_extras_source.dart';
import '../utils/constants.dart';
import '../utils/format.dart';
import '../utils/portable_backup_images.dart';
import 'supabase_database.dart';
import 'reading_history_cache.dart';
import 'v2_database_store.dart';
import 'custom_novel_backup.dart';
import 'library_cache.dart';
import 'bookmark_cache.dart';
import 'quote_store.dart';
import 'reading_stats_cache.dart';
import 'reader_extras_cache.dart';

/// Lớp truy cập SQLite của ứng dụng: tạo bảng, CRUD và nạp dữ liệu mẫu.
///
/// Ngoài ra lớp này đóng vai trò "nguồn dữ liệu online giả lập":
/// nội dung chương được đọc từ file JSON mẫu (như gọi API máy chủ).
/// Khi người dùng tải chương, nội dung được lưu vào bảng `chapters`
/// để đọc offline.
///
/// GHI CHÚ: Khi có backend thật (Firebase/Firestore, REST API...), chỉ cần
/// thay phần thân của [fetchChapterContent] và [_loadSampleData].
class AppDatabase implements ReaderExtrasSource {
  /// [factory]: cho phép truyền factory khác (ví dụ ffi khi chạy test).
  /// [path]: đường dẫn DB, mặc định nằm trong thư mục databases của máy.
  /// [sampleJsonLoader]: hàm đọc chuỗi JSON mẫu (mặc định đọc từ assets).
  AppDatabase({
    this.factory,
    this.path,
    ReadingHistoryRemote? historyRemote,
    LibraryRemote? libraryRemote,
    BookmarkRemote? bookmarkRemote,
    QuoteRemote? quoteRemote,
    ReadingStatsRemote? statsRemote,
    ReaderExtrasRemote? extrasRemote,
    Future<String> Function()? sampleJsonLoader,
  }) : _historyRemoteOverride = historyRemote,
       _libraryRemoteOverride = libraryRemote,
       _bookmarkRemoteOverride = bookmarkRemote,
       _quoteRemoteOverride = quoteRemote,
       _statsRemoteOverride = statsRemote,
       _extrasRemoteOverride = extrasRemote,
       _sampleJsonLoader =
           sampleJsonLoader ??
           (() => rootBundle.loadString(AppInfo.sampleDataAsset));

  /// Thể hiện dùng chung trong app.
  static final AppDatabase instance = AppDatabase();

  final DatabaseFactory? factory;
  final String? path;
  final Future<String> Function() _sampleJsonLoader;
  final ReadingHistoryRemote? _historyRemoteOverride;
  ReadingHistoryCache? _historyCache;
  final LibraryRemote? _libraryRemoteOverride;
  LibraryCache? _libraryCache;
  final BookmarkRemote? _bookmarkRemoteOverride;
  BookmarkCache? _bookmarkCache;
  final QuoteRemote? _quoteRemoteOverride;
  QuoteStore? _quotes;
  final ReadingStatsRemote? _statsRemoteOverride;
  final ReaderExtrasRemote? _extrasRemoteOverride;
  ReaderExtrasCache? _extrasCache;
  ReaderExtrasRemote? get _extrasRemote =>
      _extrasRemoteOverride ??
      (isSupabaseReady ? SupabaseDatabase.instance : null);

  @override
  Future<ReaderExtrasPage<GlossaryTerm>> getGlossaryForReader(
    int novelId,
    int chapterIndex, {
    int version = 0,
    bool offline = false,
  }) async {
    if (chapterIndex < 1) return ReaderExtrasPage([]);
    final remote = novelId > 0 ? _extrasRemote : null;
    final db = await database;
    if (remote == null) {
      return ReaderExtrasPage(
        await V2DatabaseStore.getGlossaryForNovel(
          db,
          novelId,
          maxChapterIndex: chapterIndex,
        ),
      );
    }
    final uid = remote.extrasUserId;
    List<GlossaryTerm> safe(Iterable<GlossaryTerm> terms) =>
        terms
            .where(
              (t) =>
                  t.novelId == novelId &&
                  t.firstChapterIndex >= 1 &&
                  t.firstChapterIndex <= chapterIndex,
            )
            .toList()
          ..sort((a, b) => a.firstChapterIndex.compareTo(b.firstChapterIndex));
    final page = await (_extrasCache ??= ReaderExtrasCache(db)).load(
      userId: uid,
      novelId: novelId,
      kind: 'glossary',
      chapterIndex: chapterIndex,
      version: version,
      offline: offline,
      isCurrentUser: () => remote.extrasUserId == uid,
      fetch: () async => [
        for (final t in safe(
          await remote.getReaderGlossary(novelId, chapterIndex),
        ))
          t.toMap(),
      ],
    );
    return ReaderExtrasPage(
      safe(page.items.map(GlossaryTerm.fromMap)),
      fromCache: page.fromCache,
    );
  }

  @override
  Future<ReaderExtrasPage<ChapterSummary>> getSummariesForReader(
    int novelId,
    int chapterIndex, {
    int version = 0,
    bool offline = false,
  }) async {
    if (chapterIndex < 1) return ReaderExtrasPage([]);
    final remote = novelId > 0 ? _extrasRemote : null;
    final db = await database;
    if (remote == null) {
      return ReaderExtrasPage(
        await V2DatabaseStore.getSummariesUpTo(db, novelId, chapterIndex),
      );
    }
    final uid = remote.extrasUserId;
    List<ChapterSummary> safe(Iterable<ChapterSummary> summaries) =>
        (summaries
                .where(
                  (s) =>
                      s.novelId == novelId &&
                      s.chapterIndex >= 1 &&
                      s.chapterIndex <= chapterIndex,
                )
                .toList()
              ..sort((a, b) => b.chapterIndex.compareTo(a.chapterIndex)))
            .take(3)
            .toList();
    final page = await (_extrasCache ??= ReaderExtrasCache(db)).load(
      userId: uid,
      novelId: novelId,
      kind: 'recap',
      chapterIndex: chapterIndex,
      version: version,
      offline: offline,
      isCurrentUser: () => remote.extrasUserId == uid,
      fetch: () async => [
        for (final s in safe(
          await remote.getReaderSummaries(novelId, chapterIndex),
        ))
          s.toMap(),
      ],
    );
    return ReaderExtrasPage(
      safe(page.items.map(ChapterSummary.fromMap)),
      fromCache: page.fromCache,
    );
  }

  ReadingStatsCache? _statsCache;
  ReadingStatsRemote? get _statsRemote =>
      _statsRemoteOverride ??
      (isSupabaseReady ? SupabaseDatabase.instance : null);
  Future<ReadingStatsCache> _statsStore() async {
    final db = await database;
    return _statsCache ??= ReadingStatsCache(db, _statsRemote);
  }

  QuoteRemote? get _quoteRemote =>
      _quoteRemoteOverride ??
      (isSupabaseReady ? SupabaseDatabase.instance : null);
  Future<QuoteStore> _quoteStore() async {
    final db = await database;
    return _quotes ??= QuoteStore(db, _quoteRemote);
  }

  BookmarkRemote? get _bookmarkRemote =>
      _bookmarkRemoteOverride ??
      (isSupabaseReady ? SupabaseDatabase.instance : null);

  Future<BookmarkCache> _bookmarkStore(BookmarkRemote remote) async {
    final db = await database;
    return _bookmarkCache ??= BookmarkCache(db, remote);
  }

  LibraryRemote? get _libraryRemote =>
      _libraryRemoteOverride ??
      (isSupabaseReady ? SupabaseDatabase.instance : null);

  Future<LibraryCache> _libraryStore(LibraryRemote remote) async {
    final db = await database;
    return _libraryCache ??= LibraryCache(db, remote);
  }

  ReadingHistoryRemote? get _historyRemote =>
      _historyRemoteOverride ??
      (isSupabaseReady ? SupabaseDatabase.instance : null);

  String _historyUserId(String? userId) {
    if (userId != null) return userId;
    if (!isSupabaseReady) return '';
    return Supabase.instance.client.auth.currentUser?.id ?? '';
  }

  Future<ReadingHistoryCache> _historyStore(ReadingHistoryRemote remote) async {
    final db = await database;
    return _historyCache ??= ReadingHistoryCache(db, remote);
  }

  Database? _db;
  Future<Database>? _opening;

  /// Bộ nhớ đệm dữ liệu mẫu: novelId -> (chapterIndex -> content).
  Map<int, Map<int, String>>? _remoteContent;

  /// Lấy (hoặc mở) kết nối DB. Lần đầu sẽ tạo bảng và nạp dữ liệu mẫu.
  Future<Database> get database async {
    if (_db != null) return _db!;
    try {
      _opening ??= _open();
      _db = await _opening!;
      return _db!;
    } catch (_) {
      // Cho phép bấm "Thử lại" nếu lần mở đầu gặp lỗi tạm thời.
      _opening = null;
      rethrow;
    }
  }

  Future<Database> _open() async {
    final dbFactory = factory ?? databaseFactory;
    final dbPath =
        path ??
        (kIsWeb
            ? AppInfo.dbName
            : p.join(await dbFactory.getDatabasesPath(), AppInfo.dbName));
    final db = await dbFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: AppInfo.dbVersion,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: _onCreate,
        onUpgrade: (db, oldVersion, newVersion) async {
          await _migrateLegacyTableNames(db);
          await V2DatabaseStore.migrateToV2(db);
          await _ensureExtraTables(db, inMigration: true);
          // Bổ sung truyện mới từ sample_novels.json mà không làm mất lịch sử/tủ sách cũ.
          await _syncSampleNovels(db);
        },
      ),
    );
    await _ensureExtraTables(db);
    await V2DatabaseStore.ensureV2SchemaAndSeed(db);
    await _seedIfNeeded(db);
    return db;
  }

  /// Đổi tên các bảng SQLite cũ sang tiếng Việt không dấu, giữ nguyên dữ liệu.
  Future<void> _migrateLegacyTableNames(Database db) async {
    const names = <String, String>{
      'novels': 'truyen',
      'chapters': 'chuong',
      'library': 'tu_sach',
      'reading_history': 'lich_su_doc',
      'bookmarks': 'dau_trang',
      'quotes': 'trich_dan',
      'comments': 'binh_luan',
      'reading_sessions': 'phien_doc',
      'users': 'nguoi_dung',
      'reading_session_logs': 'nhat_ky_phien_doc',
      'achievements': 'thanh_tuu',
      'user_achievements': 'thanh_tuu_nguoi_dung',
      'quests': 'nhiem_vu',
      'user_quests': 'nhiem_vu_nguoi_dung',
      'reports': 'bao_cao',
      'announcements': 'thong_bao_chung',
      'notifications': 'thong_bao',
      'glossary_terms': 'thuat_ngu',
      'chapter_summaries': 'tom_tat_chuong',
      'paragraph_reactions': 'cam_xuc_doan',
      'time_capsules': 'hop_thoi_gian',
      'novel_requests': 'yeu_cau_truyen',
      'character_graphs': 'so_do_nhan_vat',
      'banned_words': 'tu_cam',
      'audit_logs': 'nhat_ky_quan_tri',
      'app_config': 'cau_hinh_ung_dung',
    };
    final existing = (await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table'",
    )).map((row) => row['name'] as String).toSet();

    for (final entry in names.entries) {
      if (existing.contains(entry.key) && !existing.contains(entry.value)) {
        await db.execute('ALTER TABLE ${entry.key} RENAME TO ${entry.value}');
        existing
          ..remove(entry.key)
          ..add(entry.value);
      }
    }
  }

  /// Tạo các bảng và chỉ mục.
  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    batch.execute('''
      CREATE TABLE truyen (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        cover_url TEXT,
        description TEXT,
        status TEXT NOT NULL,
        type TEXT NOT NULL,
        genres TEXT,
        total_chapters INTEGER NOT NULL DEFAULT 0,
        rating REAL NOT NULL DEFAULT 0,
        views INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER NOT NULL,
        search_text TEXT
      )
    ''');
    batch.execute('''
      CREATE TABLE chuong (
        id INTEGER PRIMARY KEY,
        novel_id INTEGER NOT NULL REFERENCES truyen(id) ON DELETE CASCADE,
        chapter_index INTEGER NOT NULL,
        title TEXT NOT NULL,
        content TEXT,
        is_downloaded INTEGER NOT NULL DEFAULT 0,
        publish_at INTEGER,
        UNIQUE(novel_id, chapter_index)
      )
    ''');
    batch.execute('''
      CREATE TABLE tu_sach (
        novel_id INTEGER PRIMARY KEY REFERENCES truyen(id) ON DELETE CASCADE,
        category TEXT NOT NULL,
        added_at INTEGER NOT NULL
      )
    ''');
    batch.execute('''
      CREATE TABLE lich_su_doc (
        novel_id INTEGER PRIMARY KEY REFERENCES truyen(id) ON DELETE CASCADE,
        last_chapter_id INTEGER NOT NULL,
        scroll_offset REAL NOT NULL DEFAULT 0,
        last_read_at INTEGER NOT NULL
      )
    ''');
    batch.execute('''
      CREATE TABLE dau_trang (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        novel_id INTEGER NOT NULL REFERENCES truyen(id) ON DELETE CASCADE,
        chapter_id INTEGER NOT NULL REFERENCES chuong(id) ON DELETE CASCADE,
        scroll_offset REAL NOT NULL DEFAULT 0,
        note TEXT,
        created_at INTEGER NOT NULL
      )
    ''');
    batch.execute(
      'CREATE INDEX idx_chapters_novel ON chuong(novel_id, chapter_index)',
    );
    batch.execute('CREATE INDEX idx_bookmarks_novel ON dau_trang(novel_id)');
    await batch.commit(noResult: true);
    await _ensureExtraTables(db, inMigration: true);
  }

  /// Tạo các bảng mở rộng (trích dẫn yêu thích & bình luận chương).
  Future<void> _ensureExtraTables(
    Database db, {
    bool inMigration = false,
  }) async {
    await ReadingHistoryCache.ensureSchema(db);
    await LibraryCache.ensureSchema(db);
    await BookmarkCache.ensureSchema(db);
    await ReaderExtrasCache.ensureSchema(db);
    await db.execute('''
      CREATE TABLE IF NOT EXISTS trich_dan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        novel_id INTEGER NOT NULL,
        novel_title TEXT NOT NULL,
        author TEXT NOT NULL,
        chapter_title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    await QuoteStore.ensureSchema(db);
    await db.execute('''
      CREATE TABLE IF NOT EXISTS binh_luan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        novel_id INTEGER NOT NULL,
        chapter_id INTEGER NOT NULL,
        user_name TEXT NOT NULL,
        content TEXT NOT NULL,
        stars INTEGER NOT NULL DEFAULT 5,
        created_at INTEGER NOT NULL
      )
    ''');
    await ReadingStatsCache.ensureSchema(db, inMigration: inMigration);
    await db.execute('''
      CREATE TABLE IF NOT EXISTS chuong_tai_xuong_cloud (
        novel_id INTEGER NOT NULL,
        id INTEGER NOT NULL,
        chapter_index INTEGER NOT NULL,
        title TEXT NOT NULL,
        content TEXT,
        is_downloaded INTEGER NOT NULL DEFAULT 0,
        publish_at INTEGER,
        novel_title TEXT NOT NULL DEFAULT '',
        cover_url TEXT NOT NULL DEFAULT '',
        novel_author TEXT NOT NULL DEFAULT '',
        novel_description TEXT NOT NULL DEFAULT '',
        novel_status TEXT NOT NULL DEFAULT 'ongoing',
        novel_type TEXT NOT NULL DEFAULT 'novel',
        novel_genres TEXT NOT NULL DEFAULT '',
        novel_total_chapters INTEGER NOT NULL DEFAULT 0,
        novel_rating REAL NOT NULL DEFAULT 0,
        novel_views INTEGER NOT NULL DEFAULT 0,
        novel_updated_at INTEGER NOT NULL DEFAULT 0,
        downloaded_at INTEGER,
        PRIMARY KEY (novel_id, id)
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_chuong_cloud_novel
      ON chuong_tai_xuong_cloud(novel_id, chapter_index)
    ''');
    await db.execute('''
      INSERT OR IGNORE INTO chuong_tai_xuong_cloud (
        novel_id, id, chapter_index, title, content, is_downloaded, publish_at,
        novel_title, cover_url, downloaded_at
      )
      SELECT c.novel_id, c.id, c.chapter_index, c.title, c.content, 1,
             c.publish_at, n.title, COALESCE(n.cover_url, ''),
             strftime('%s','now') * 1000
      FROM chuong c JOIN truyen n ON n.id = c.novel_id
      WHERE c.novel_id >= 0 AND c.is_downloaded = 1 AND c.content IS NOT NULL
    ''');
  }

  // ---------------------------------------------------------------------------
  // Dữ liệu mẫu
  // ---------------------------------------------------------------------------

  /// Đọc và phân tích file JSON mẫu.
  Future<List<Map<String, dynamic>>> _loadSampleData() async {
    final raw = await _sampleJsonLoader();
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return (decoded['novels'] as List).cast<Map<String, dynamic>>();
  }

  /// Nạp dữ liệu mẫu vào SQLite nếu bảng novels đang trống (lần chạy đầu).
  Future<void> _seedIfNeeded(Database db) async {
    final count =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM truyen'),
        ) ??
        0;
    if (count > 0) return;
    await _syncSampleNovels(db);
  }

  /// Đồng bộ toàn bộ truyện trong `sample_novels.json` vào SQLite
  /// (dùng cho cả lần khởi tạo đầu tiên lẫn khi nâng cấp phiên bản dữ liệu mẫu).
  Future<void> _syncSampleNovels(Database db) async {
    final novels = await _loadSampleData();
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final n in novels) {
        final novelId = n['id'] as int;
        final chapters = (n['chapters'] as List).cast<Map<String, dynamic>>();
        final novel = Novel(
          id: novelId,
          title: n['title'] as String,
          author: n['author'] as String,
          coverUrl: (n['cover_url'] as String?) ?? '',
          description: (n['description'] as String?) ?? '',
          status: n['status'] as String,
          type: n['type'] as String,
          genres: (n['genres'] as List).cast<String>(),
          totalChapters: chapters.length,
          rating: (n['rating'] as num).toDouble(),
          views: (n['views'] as int?) ?? 0,
          updatedAt: DateTime.parse(n['updated_at'] as String),
        );
        batch.insert('truyen', {
          ...novel.toMap(),
          'search_text': Format.normalize('${novel.title} ${novel.author}'),
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
        for (final c in chapters) {
          final index = c['index'] as int;
          batch.insert(
            'chuong',
            Chapter(
              id: novelId * 10000 + index,
              novelId: novelId,
              chapterIndex: index,
              title: c['title'] as String,
            ).toMap(),
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      }
      await batch.commit(noResult: true);
    });
  }

  /// Kiểm tra xem Supabase đã được khởi tạo với anonKey hợp lệ chưa.
  bool get isSupabaseReady {
    try {
      Supabase.instance.client;
      return SupabaseConfig.anonKey != 'YOUR_SUPABASE_ANON_KEY' &&
          SupabaseConfig.anonKey.trim().isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Lấy nội dung chương từ Supabase hoặc dữ liệu mẫu khi chưa cấu hình Supabase.
  /// Ném [StateError] nếu không tìm thấy chương.
  Future<String> fetchChapterContent(int novelId, int chapterIndex) async {
    if (novelId < 0) {
      final db = await database;
      final rows = await db.query(
        'chuong',
        columns: ['content'],
        where: 'novel_id = ? AND chapter_index = ?',
        whereArgs: [novelId, chapterIndex],
        limit: 1,
      );
      if (rows.isEmpty || rows.first['content'] == null) {
        throw StateError('Không tìm thấy nội dung chương truyện cục bộ.');
      }
      return rows.first['content'] as String;
    }
    if (isSupabaseReady) {
      return SupabaseDatabase.instance.fetchChapterContent(
        novelId,
        chapterIndex,
      );
    }
    if (_remoteContent == null) {
      final novels = await _loadSampleData();
      _remoteContent = {
        for (final n in novels)
          n['id'] as int: {
            for (final c
                in (n['chapters'] as List).cast<Map<String, dynamic>>())
              c['index'] as int: c['content'] as String,
          },
      };
    }
    final content = _remoteContent![novelId]?[chapterIndex];
    if (content == null) {
      throw StateError('Không tìm thấy nội dung chương');
    }
    return content;
  }

  // ---------------------------------------------------------------------------
  // Truyện
  // ---------------------------------------------------------------------------

  /// Truy vấn truyện với điều kiện lọc + phân trang.
  /// - [keyword]: tìm theo tên/tác giả, không phân biệt dấu.
  /// - [genres]: truyện phải thuộc TẤT CẢ thể loại được chọn.
  Future<List<Novel>> queryNovels({
    String keyword = '',
    List<String> genres = const [],
    String? status,
    String? type,
    NovelSort sort = NovelSort.updated,
    int limit = AppInfo.pageSize,
    int offset = 0,
    bool includeUnapproved = false,
  }) async {
    if (isSupabaseReady) {
      return SupabaseDatabase.instance.queryNovels(
        keyword: keyword,
        genres: genres,
        status: status,
        type: type,
        sort: sort,
        limit: limit,
        offset: offset,
        includeUnapproved: includeUnapproved,
      );
    }
    final db = await database;
    final where = <String>['deleted_at IS NULL'];
    final args = <Object?>[];
    if (!includeUnapproved) {
      where.add("moderation_status = 'approved'");
    }
    final kw = Format.normalize(keyword);
    if (kw.isNotEmpty) {
      where.add('search_text LIKE ?');
      args.add('%$kw%');
    }
    for (final g in genres) {
      where.add("(',' || genres || ',') LIKE ?");
      args.add('%,$g,%');
    }
    if (status != null) {
      where.add('status = ?');
      args.add(status);
    }
    if (type != null) {
      where.add('type = ?');
      args.add(type);
    }
    final orderBy = switch (sort) {
      NovelSort.updated => 'updated_at DESC',
      NovelSort.views => 'views DESC',
      NovelSort.rating => 'rating DESC',
      NovelSort.title => 'title COLLATE NOCASE ASC',
    };
    final rows = await db.query(
      'truyen',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: '$orderBy, id ASC',
      limit: limit,
      offset: offset,
    );
    return rows.map(Novel.fromMap).toList();
  }

  /// Lấy 1 truyện theo id.
  Future<Novel?> getNovel(int id) async {
    if (id < 0) {
      final db = await database;
      final rows = await db.query('truyen', where: 'id = ?', whereArgs: [id]);
      return rows.isEmpty ? null : Novel.fromMap(rows.first);
    }
    if (isSupabaseReady) {
      try {
        return await SupabaseDatabase.instance.getNovel(id);
      } catch (e) {
        debugPrint('Supabase getNovel error: $e');
        final cachedNovel = await getCachedNovel(id);
        if (cachedNovel != null) return cachedNovel;
        rethrow;
      }
    }
    final cachedNovel = await getCachedNovel(id);
    if (cachedNovel != null) return cachedNovel;
    final db = await database;
    final rows = await db.query('truyen', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Novel.fromMap(rows.first);
  }

  /// Trả metadata đã lưu cùng các chương cloud để mở Tải xuống khi offline.
  Future<Novel?> getCachedNovel(int novelId) async {
    final db = await database;
    final rows = await db.query(
      'chuong_tai_xuong_cloud',
      where: 'novel_id = ?',
      whereArgs: [novelId],
      orderBy: 'chapter_index ASC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    return Novel(
      id: novelId,
      title: (row['novel_title'] as String?) ?? '',
      author: (row['novel_author'] as String?) ?? '',
      coverUrl: (row['cover_url'] as String?) ?? '',
      description: (row['novel_description'] as String?) ?? '',
      status: (row['novel_status'] as String?) ?? NovelStatus.ongoing,
      type: (row['novel_type'] as String?) ?? NovelType.novel,
      genres: ((row['novel_genres'] as String?) ?? '')
          .split(',')
          .where((genre) => genre.isNotEmpty)
          .toList(),
      totalChapters: (row['novel_total_chapters'] as int?) ?? 0,
      rating: ((row['novel_rating'] as num?) ?? 0).toDouble(),
      views: (row['novel_views'] as int?) ?? 0,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (row['novel_updated_at'] as int?) ?? 0,
      ),
    );
  }

  /// Ghi nhận một lượt mở trang truyện, trả về tổng lượt xem mới.
  Future<int?> recordNovelView(int novelId) async {
    if (novelId >= 0 && isSupabaseReady) {
      try {
        return await SupabaseDatabase.instance.recordNovelView(novelId);
      } catch (e) {
        debugPrint('Supabase recordNovelView error: $e');
        return null;
      }
    }
    if (kIsWeb && novelId >= 0) return null;

    final db = await database;
    final changed = await db.rawUpdate(
      'UPDATE truyen SET views = views + 1 WHERE id = ?',
      [novelId],
    );
    if (changed == 0) return null;
    final rows = await db.query(
      'truyen',
      columns: ['views'],
      where: 'id = ?',
      whereArgs: [novelId],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['views'] as int?;
  }

  /// Đếm số truyện theo thể loại, bỏ truyện đã xóa và chờ duyệt mặc định.
  Future<Map<String, int>> genreCounts({bool includeUnapproved = false}) async {
    if (isSupabaseReady) {
      return SupabaseDatabase.instance.genreCounts(
        includeUnapproved: includeUnapproved,
      );
    }
    final db = await database;
    final rows = await db.query(
      'truyen',
      columns: ['genres'],
      where: includeUnapproved
          ? 'deleted_at IS NULL'
          : "deleted_at IS NULL AND moderation_status = 'approved'",
    );
    final result = <String, int>{};
    for (final r in rows) {
      for (final g in ((r['genres'] as String?) ?? '').split(',')) {
        final name = g.trim();
        if (name.isEmpty) continue;
        result[name] = (result[name] ?? 0) + 1;
      }
    }
    return result;
  }

  /// Tạo truyện mới (do người dùng tự viết hoặc dán văn bản nhiều chương).
  /// Các chương được lưu sẵn nội dung (`is_downloaded = 1`) để đọc offline ngay.
  Future<Novel> insertCustomNovel({
    required String title,
    required String author,
    required String description,
    required String status,
    required String type,
    required List<String> genres,
    required List<({String title, String content})> chapters,
    String? coverUrl,
    String moderationStatus = ModerationStatus.approved,
    String ownerId = '',
  }) async {
    final parts = [
      for (final chapter in chapters)
        (title: chapter.title.trim(), content: chapter.content.trim()),
    ];
    final copiedGenres = List<String>.unmodifiable(genres);
    final db = await database;
    // ID âm dành riêng cho truyện chỉ lưu trên máy, tránh va chạm với ID cloud.
    return db.transaction((txn) async {
      final minLocalId = Sqflite.firstIntValue(
        await txn.rawQuery('SELECT MIN(id) FROM truyen WHERE id < 0'),
      );
      final newId = (minLocalId ?? 0) - 1;
      final now = DateTime.now();
      final novel = Novel(
        id: newId,
        title: title.trim(),
        author: author.trim(),
        coverUrl: (coverUrl != null && coverUrl.trim().isNotEmpty)
            ? coverUrl.trim()
            : 'https://picsum.photos/seed/custom-novel-$newId/300/450',
        description: description.trim(),
        status: status,
        type: type,
        genres: copiedGenres,
        totalChapters: parts.length,
        rating: 0.0,
        views: 0,
        updatedAt: now,
        moderationStatus: moderationStatus,
        ownerId: ownerId,
      );

      await txn.insert('truyen', {
        ...novel.toMap(),
        'search_text': Format.normalize('${novel.title} ${novel.author}'),
      });
      var nextChapterId =
          (Sqflite.firstIntValue(
                await txn.rawQuery('SELECT MIN(id) FROM chuong WHERE id < 0'),
              ) ??
              0) -
          1;
      for (var i = 0; i < parts.length; i++) {
        final idx = i + 1;
        final ch = parts[i];
        await txn.insert(
          'chuong',
          Chapter(
            id: nextChapterId--,
            novelId: newId,
            chapterIndex: idx,
            title: ch.title,
            content: ch.content,
            isDownloaded: true,
          ).toMap(),
        );
      }
      return novel;
    });
  }

  /// Thêm 1 chương mới vào bộ truyện đã có.
  Future<Chapter> appendChapter({
    required int novelId,
    required String title,
    required String content,
    String? requestId,
  }) async {
    final normalizedTitle = title.trim();
    final normalizedContent = content.trim();
    if (normalizedContent.isEmpty) {
      throw ArgumentError.value(
        content,
        'content',
        'Nội dung chương không được để trống.',
      );
    }

    // Cloud novels use positive IDs. Persist their chapters through Supabase;
    // writing them to SQLite made the detail screen report success even though
    // the chapter disappeared as soon as the cloud list was refreshed.
    if (novelId > 0) {
      return SupabaseDatabase.instance.appendChapter(
        novelId: novelId,
        title: normalizedTitle,
        content: normalizedContent,
        requestId: requestId ?? SupabaseDatabase.newImportRequestId(),
      );
    }

    final db = await database;
    return db.transaction((txn) async {
      final books = await txn.query(
        'truyen',
        columns: ['id'],
        where: 'id = ?',
        whereArgs: [novelId],
        limit: 1,
      );
      if (books.isEmpty) {
        throw StateError('Không tìm thấy truyện để thêm chương.');
      }
      final maxIdx =
          Sqflite.firstIntValue(
            await txn.rawQuery(
              'SELECT MAX(chapter_index) FROM chuong WHERE novel_id = ?',
              [novelId],
            ),
          ) ??
          0;
      final nextIdx = maxIdx + 1;
      final count =
          Sqflite.firstIntValue(
            await txn.rawQuery(
              'SELECT COUNT(*) FROM chuong WHERE novel_id = ?',
              [novelId],
            ),
          ) ??
          0;
      final chapterTitle = normalizedTitle.isEmpty
          ? 'Chương $nextIdx: Mới'
          : normalizedTitle.startsWith('Chương')
          ? normalizedTitle
          : 'Chương $nextIdx: $normalizedTitle';
      final chapter = Chapter(
        id:
            (Sqflite.firstIntValue(
                  await txn.rawQuery('SELECT MIN(id) FROM chuong WHERE id < 0'),
                ) ??
                0) -
            1,
        novelId: novelId,
        chapterIndex: nextIdx,
        title: chapterTitle,
        content: normalizedContent,
        isDownloaded: true,
      );
      await txn.insert('chuong', chapter.toMap());
      await txn.update(
        'truyen',
        {
          'total_chapters': count + 1,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [novelId],
      );
      return chapter;
    });
  }

  // ---------------------------------------------------------------------------
  // Chương
  // ---------------------------------------------------------------------------

  /// Danh sách chương của truyện (không kèm nội dung cho nhẹ).
  Future<List<Chapter>> getChapters(int novelId, {Novel? novel}) async {
    if (novelId < 0) {
      final db = await database;
      final rows = await db.query(
        'chuong',
        columns: ['id', 'novel_id', 'chapter_index', 'title', 'is_downloaded'],
        where: 'novel_id = ?',
        whereArgs: [novelId],
        orderBy: 'chapter_index ASC',
      );
      return rows.map(Chapter.fromMap).toList();
    }
    if (isSupabaseReady) {
      try {
        final chapters = await SupabaseDatabase.instance.getChapters(novelId);
        await _cacheCloudChapterMetadata(novelId, chapters, novel: novel);
        return await _mergeCloudDownloadStatus(novelId, chapters);
      } catch (e) {
        debugPrint('Supabase getChapters error: $e');
        final cached = await _getCachedCloudChapters(novelId);
        if (cached.isNotEmpty) return cached;
        rethrow;
      }
    }
    final db = await database;
    final rows = await db.query(
      'chuong',
      columns: ['id', 'novel_id', 'chapter_index', 'title', 'is_downloaded'],
      where: 'novel_id = ?',
      whereArgs: [novelId],
      orderBy: 'chapter_index ASC',
    );
    return _mergeCloudDownloadStatus(
      novelId,
      rows.map(Chapter.fromMap).toList(),
    );
  }

  /// Lấy 1 chương (kèm nội dung nếu đã tải).
  Future<Chapter?> getChapter(int id, {int? novelId}) async {
    final db = await database;
    if (novelId != null && novelId >= 0) {
      final cachedRows = await db.query(
        'chuong_tai_xuong_cloud',
        where: 'novel_id = ? AND id = ? AND is_downloaded = 1 AND content IS NOT NULL',
        whereArgs: [novelId, id],
        limit: 1,
      );
      if (cachedRows.isNotEmpty) return Chapter.fromMap(cachedRows.first);
    }
    final rows = await db.query('chuong', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Chapter.fromMap(rows.first);
  }

  /// Lưu nội dung chương để đọc offline (is_downloaded = 1).
  Future<void> saveChapterContent(
    Chapter chapter,
    String content, {
    Novel? novel,
  }) async {
    final db = await database;
    if (chapter.novelId >= 0) {
      final cachedNovel = novel ?? (await getNovel(chapter.novelId));
      await db.insert('chuong_tai_xuong_cloud', {
        ...chapter.toMap(),
        'content': content,
        'is_downloaded': 1,
        'novel_title': cachedNovel?.title ?? '',
        'cover_url': cachedNovel?.coverUrl ?? '',
        'novel_author': cachedNovel?.author ?? '',
        'novel_description': cachedNovel?.description ?? '',
        'novel_status': cachedNovel?.status ?? NovelStatus.ongoing,
        'novel_type': cachedNovel?.type ?? NovelType.novel,
        'novel_genres': cachedNovel?.genres.join(',') ?? '',
        'novel_total_chapters': cachedNovel?.totalChapters ?? 0,
        'novel_rating': cachedNovel?.rating ?? 0.0,
        'novel_views': cachedNovel?.views ?? 0,
        'novel_updated_at': cachedNovel?.updatedAt.millisecondsSinceEpoch ?? 0,
        'downloaded_at': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      return;
    }
    await db.update(
      'chuong',
      {'content': content, 'is_downloaded': 1},
      where: 'id = ?',
      whereArgs: [chapter.id],
    );
  }

  /// Xóa bản tải của chương cloud; chương cục bộ là bản gốc cần giữ lại.
  Future<void> deleteChapterContent(Chapter chapter) async {
    if (chapter.novelId < 0) return;
    final db = await database;
    await db.update(
      'chuong_tai_xuong_cloud',
      {'content': null, 'is_downloaded': 0, 'downloaded_at': null},
      where: 'novel_id = ? AND id = ?',
      whereArgs: [chapter.novelId, chapter.id],
    );
  }

  /// Xóa nội dung đã tải của cả truyện, hoặc toàn bộ nếu [novelId] = null.
  Future<int> deleteDownloads({int? novelId}) async {
    if (novelId != null && novelId < 0) return 0;
    final db = await database;
    return db.update(
      'chuong_tai_xuong_cloud',
      {'content': null, 'is_downloaded': 0, 'downloaded_at': null},
      where: novelId == null
          ? 'is_downloaded = 1'
          : 'is_downloaded = 1 AND novel_id = ?',
      whereArgs: novelId == null ? null : [novelId],
    );
  }

  /// Các bản tải có thể dọn; truyện tự nhập là bản gốc trong Tủ sách.
  Future<List<DownloadedChapter>> getDownloadedChapters() async {
    final db = await database;
    final cloudRows = await db.rawQuery('''
      SELECT id, novel_id, chapter_index, title, is_downloaded,
             novel_title, cover_url,
             LENGTH(CAST(content AS BLOB)) AS size
      FROM chuong_tai_xuong_cloud
      WHERE is_downloaded = 1 AND content IS NOT NULL
      ORDER BY novel_title COLLATE NOCASE, chapter_index
    ''');
    final combined = cloudRows.map(DownloadedChapter.fromMap).toList();
    combined.sort((a, b) {
      final novelOrder = a.novelTitle.toLowerCase().compareTo(
        b.novelTitle.toLowerCase(),
      );
      return novelOrder != 0
          ? novelOrder
          : a.chapter.chapterIndex.compareTo(b.chapter.chapterIndex);
    });
    return combined;
  }

  /// Số chương đã tải.
  Future<int> countDownloaded() async {
    return (await getDownloadedChapters()).length;
  }

  Future<void> _cacheCloudChapterMetadata(
    int novelId,
    List<Chapter> chapters, {
    Novel? novel,
  }) async {
    if (chapters.isEmpty) return;
    final db = await database;
    final batch = db.batch();
    for (final chapter in chapters) {
      batch.insert('chuong_tai_xuong_cloud', {
        ...chapter.toMap(),
        'content': null,
        'is_downloaded': 0,
        'downloaded_at': null,
        'novel_title': novel?.title ?? '',
        'cover_url': novel?.coverUrl ?? '',
        'novel_author': novel?.author ?? '',
        'novel_description': novel?.description ?? '',
        'novel_status': novel?.status ?? NovelStatus.ongoing,
        'novel_type': novel?.type ?? NovelType.novel,
        'novel_genres': novel?.genres.join(',') ?? '',
        'novel_total_chapters': novel?.totalChapters ?? 0,
        'novel_rating': novel?.rating ?? 0.0,
        'novel_views': novel?.views ?? 0,
        'novel_updated_at': novel?.updatedAt.millisecondsSinceEpoch ?? 0,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      batch.update(
        'chuong_tai_xuong_cloud',
        {
          'chapter_index': chapter.chapterIndex,
          'title': chapter.title,
          if (novel != null) 'novel_title': novel.title,
          if (novel != null) 'cover_url': novel.coverUrl,
          if (novel != null) 'novel_author': novel.author,
          if (novel != null) 'novel_description': novel.description,
          if (novel != null) 'novel_status': novel.status,
          if (novel != null) 'novel_type': novel.type,
          if (novel != null) 'novel_genres': novel.genres.join(','),
          if (novel != null) 'novel_total_chapters': novel.totalChapters,
          if (novel != null) 'novel_rating': novel.rating,
          if (novel != null) 'novel_views': novel.views,
          if (novel != null)
            'novel_updated_at': novel.updatedAt.millisecondsSinceEpoch,
        },
        where: 'novel_id = ? AND id = ?',
        whereArgs: [novelId, chapter.id],
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Chapter>> _mergeCloudDownloadStatus(
    int novelId,
    List<Chapter> chapters,
  ) async {
    final db = await database;
    final rows = await db.query(
      'chuong_tai_xuong_cloud',
      columns: ['id', 'is_downloaded'],
      where: 'novel_id = ? AND is_downloaded = 1 AND content IS NOT NULL',
      whereArgs: [novelId],
    );
    final downloadedIds = rows.map((row) => row['id'] as int).toSet();
    return [
      for (final chapter in chapters)
        chapter.copyWith(isDownloaded: downloadedIds.contains(chapter.id)),
    ];
  }

  Future<List<Chapter>> _getCachedCloudChapters(int novelId) async {
    final db = await database;
    final rows = await db.query(
      'chuong_tai_xuong_cloud',
      where: 'novel_id = ?',
      whereArgs: [novelId],
      orderBy: 'chapter_index ASC',
    );
    return rows.map(Chapter.fromMap).toList();
  }

  /// Danh sách chapter metadata đã cache để vào trình đọc khi offline.
  Future<List<Chapter>> getCachedChapters(int novelId) =>
      _getCachedCloudChapters(novelId);

  // ---------------------------------------------------------------------------
  // Tủ sách
  // ---------------------------------------------------------------------------

  static const String _librarySelect = '''
    SELECT l.novel_id, l.category, l.added_at, n.*,
           c.chapter_index AS last_chapter_index, h.last_read_at
    FROM tu_sach l
    JOIN truyen n ON n.id = l.novel_id
    LEFT JOIN lich_su_doc h ON h.novel_id = l.novel_id
    LEFT JOIN chuong c ON c.id = h.last_chapter_id
  ''';

  /// Toàn bộ tủ sách (kèm thông tin truyện + tiến độ).
  Future<List<LibraryItem>> getLibrary({String? userId}) async {
    final uid = _historyUserId(userId);
    final remote = _libraryRemote;
    final db = await database;
    final localRows = await db.rawQuery(
      '$_librarySelect WHERE l.novel_id < 0 ORDER BY l.added_at DESC',
    );
    final localItems = localRows.map(LibraryItem.fromMap).toList();
    if (remote != null) {
      final items = await (await _libraryStore(remote)).load(uid);
      return [...items, ...localItems]
        ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
    }
    final rows = await db.rawQuery('$_librarySelect ORDER BY l.added_at DESC');
    return rows.map(LibraryItem.fromMap).toList();
  }

  /// Thêm hoặc cập nhật danh mục của truyện trong tủ sách.
  Future<void> upsertLibrary(LibraryItem item, {String? userId}) async {
    final uid = _historyUserId(userId);
    final remote = _libraryRemote;
    if (item.novelId < 0) {
      final db = await database;
      await db.insert(
        'tu_sach',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return;
    }
    if (remote != null) {
      final novel = item.novel ?? await getNovel(item.novelId);
      if (novel == null) throw StateError('Không tìm thấy thông tin truyện.');
      await (await _libraryStore(remote))
          .save(item.copyWith(novel: novel), uid);
      return;
    }
    final db = await database;
    await db.insert(
      'tu_sach',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Xóa truyện khỏi tủ sách.
  Future<void> removeFromLibrary(int novelId, {String? userId}) async {
    final uid = _historyUserId(userId);
    final remote = _libraryRemote;
    if (novelId < 0) {
      final db = await database;
      await db.delete('tu_sach', where: 'novel_id = ?', whereArgs: [novelId]);
      return;
    }
    if (remote != null) {
      await (await _libraryStore(remote)).remove(novelId, uid);
      return;
    }
    final db = await database;
    await db.delete('tu_sach', where: 'novel_id = ?', whereArgs: [novelId]);
  }

  // ---------------------------------------------------------------------------
  // Lịch sử đọc
  // ---------------------------------------------------------------------------

  static const String _historySelect = '''
    SELECT h.*, n.*, c.chapter_index, c.title AS chapter_title
    FROM lich_su_doc h
    JOIN truyen n ON n.id = h.novel_id
    LEFT JOIN chuong c ON c.id = h.last_chapter_id
  ''';

  /// Lịch sử đọc, mới nhất trước.
  Future<List<ReadingHistory>> getHistory({String? userId}) async {
    final uid = _historyUserId(userId);
    final remote = _historyRemote;
    final db = await database;
    final localRows = await db.rawQuery(
      '$_historySelect WHERE h.novel_id < 0 ORDER BY h.last_read_at DESC',
    );
    final localHistory = localRows.map(ReadingHistory.fromMap).toList();
    if (remote != null) {
      final cloudHistory = await (await _historyStore(remote)).load(uid);
      return [...cloudHistory, ...localHistory]
        ..sort((a, b) => b.lastReadAt.compareTo(a.lastReadAt));
    }
    final rows = await db.rawQuery(
      '$_historySelect ORDER BY h.last_read_at DESC',
    );
    return rows.map(ReadingHistory.fromMap).toList();
  }

  /// Lịch sử đọc của 1 truyện.
  Future<ReadingHistory?> getHistoryFor(int novelId, {String? userId}) async {
    final uid = _historyUserId(userId);
    final remote = _historyRemote;
    if (novelId >= 0 && remote != null) {
      final rows = await (await _historyStore(remote))
          .load(uid, novelId: novelId);
      return rows.firstOrNull;
    }
    final db = await database;
    final rows = await db.rawQuery('$_historySelect WHERE h.novel_id = ?', [
      novelId,
    ]);
    return rows.isEmpty ? null : ReadingHistory.fromMap(rows.first);
  }

  /// Ghi (hoặc ghi đè) lịch sử đọc.
  Future<void> saveHistory(ReadingHistory history, {String? userId}) async {
    final uid = _historyUserId(userId);
    final remote = _historyRemote;
    if (history.novelId >= 0 && remote != null) {
      await (await _historyStore(remote)).save(history, uid);
      return;
    }
    final db = await database;
    await _saveLocalHistory(db, history);
  }

  Future<void> _saveLocalHistory(
    DatabaseExecutor db,
    ReadingHistory history, {
    bool keepExistingOnTie = false,
  }) async {
    final timestamp = history.lastReadAt.millisecondsSinceEpoch;
    await db.rawInsert(
      '''
      INSERT OR REPLACE INTO lich_su_doc (novel_id, last_chapter_id, scroll_offset, last_read_at)
      SELECT ?, ?, ?, ? WHERE NOT EXISTS (
        SELECT 1 FROM lich_su_doc WHERE novel_id = ? AND last_read_at ${keepExistingOnTie ? '>=' : '>'} ?
      )
    ''',
      [
        history.novelId,
        history.lastChapterId,
        history.scrollOffset,
        timestamp,
        history.novelId,
        timestamp,
      ],
    );
  }

  /// Xóa lịch sử của 1 truyện.
  Future<void> deleteHistory(int novelId, {String? userId}) async {
    final uid = _historyUserId(userId);
    final remote = _historyRemote;
    if (novelId >= 0 && remote != null) {
      await (await _historyStore(remote)).remove(novelId, uid);
    }
    final db = await database;
    await db.delete('lich_su_doc', where: 'novel_id = ?', whereArgs: [novelId]);
  }

  /// Xóa toàn bộ lịch sử.
  Future<void> clearHistory({String? userId}) async {
    final uid = _historyUserId(userId);
    final remote = _historyRemote;
    if (remote != null) {
      await (await _historyStore(remote)).clear(uid);
    }
    final db = await database;
    await db.delete('lich_su_doc');
  }

  // ---------------------------------------------------------------------------
  // Bookmark
  // ---------------------------------------------------------------------------

  /// Danh sách bookmark của truyện (kèm số/tên chương).
  Future<List<Bookmark>> getBookmarks(int novelId, {String? userId}) async {
    final uid = _historyUserId(userId);
    final remote = _bookmarkRemote;
    if (novelId >= 0 && remote != null) {
      return (await _bookmarkStore(remote)).load(novelId, uid);
    }
    final db = await database;
    final rows = await db.rawQuery(
      '''
      SELECT b.*, c.chapter_index, c.title AS chapter_title
      FROM dau_trang b JOIN chuong c ON c.id = b.chapter_id
      WHERE b.novel_id = ?
      ORDER BY c.chapter_index, b.scroll_offset
    ''',
      [novelId],
    );
    return rows.map(Bookmark.fromMap).toList();
  }

  /// Thêm bookmark, trả về id mới.
  Future<int> addBookmark(Bookmark bookmark, {String? userId}) async {
    final uid = _historyUserId(userId);
    final remote = _bookmarkRemote;
    if (bookmark.novelId < 0) {
      final db = await database;
      final minId = Sqflite.firstIntValue(
        await db.rawQuery('SELECT MIN(id) FROM dau_trang WHERE id < 0'),
      );
      final localId = (minId ?? 0) - 1;
      return db.insert('dau_trang', {...bookmark.toMap(), 'id': localId});
    }
    if (remote != null) {
      return (await _bookmarkStore(remote)).add(bookmark, uid);
    }
    final db = await database;
    return db.insert('dau_trang', bookmark.toMap());
  }

  /// Xóa bookmark.
  Future<void> deleteBookmark(int id, {String? userId}) async {
    final uid = _historyUserId(userId);
    final remote = _bookmarkRemote;
    if (id < 0) {
      final db = await database;
      await db.delete('dau_trang', where: 'id = ?', whereArgs: [id]);
      return;
    }
    if (remote != null) {
      await (await _bookmarkStore(remote)).remove(id, uid);
      return;
    }
    final db = await database;
    await db.delete('dau_trang', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------------
  // Trích dẫn (Quotes) & Bình luận / Đánh giá
  // ---------------------------------------------------------------------------

  /// Danh sách trích dẫn đã lưu (mới nhất trước).
  Future<List<QuoteItem>> getQuotes({String? userId}) async {
    final uid = _historyUserId(userId);
    return (await _quoteStore()).load(uid);
  }

  /// Lưu trích dẫn mới.
  Future<int> addQuote(QuoteItem quote, {String? userId}) async {
    final uid = _historyUserId(userId);
    return (await _quoteStore()).add(quote, uid);
  }

  /// Xóa một trích dẫn.
  Future<void> deleteQuote(int id, {String? userId}) async {
    final uid = _historyUserId(userId);
    await (await _quoteStore()).remove(id, uid);
  }

  /// Lấy danh sách bình luận của một chương.
  Future<List<ChapterComment>> getComments(int chapterId) async {
    if (isSupabaseReady) {
      try {
        return await SupabaseDatabase.instance.getComments(chapterId);
      } catch (e) {
        debugPrint('Supabase getComments error: $e');
        final rows = await (await database).query(
          'binh_luan',
          where: 'chapter_id = ?',
          whereArgs: [chapterId],
          orderBy: 'created_at DESC',
        );
        if (rows.isNotEmpty) {
          return rows.map(ChapterComment.fromMap).toList();
        }
        rethrow;
      }
    }
    if (kIsWeb) return [];
    final db = await database;
    final rows = await db.query(
      'binh_luan',
      where: 'chapter_id = ?',
      whereArgs: [chapterId],
      orderBy: 'created_at DESC',
    );
    return rows.map(ChapterComment.fromMap).toList();
  }

  /// Thêm bình luận cho chương và cập nhật điểm đánh giá trung bình của truyện.
  Future<void> addComment(ChapterComment comment) async {
    if (isSupabaseReady) {
      try {
        await SupabaseDatabase.instance.addComment(comment);
        return;
      } catch (e) {
        debugPrint('Supabase addComment error: $e');
        if (kIsWeb) rethrow;
      }
    }
    if (kIsWeb) throw StateError('Supabase is not configured.');
    final db = await database;
    await db.insert('binh_luan', comment.toMap());
  }

  /// Xóa bình luận.
  Future<void> deleteComment(int id) async {
    if (isSupabaseReady) {
      try {
        await SupabaseDatabase.instance.deleteComment(id);
        return;
      } catch (e) {
        debugPrint('Supabase deleteComment error: $e');
        if (kIsWeb) rethrow;
      }
    }
    if (kIsWeb) throw StateError('Supabase is not configured.');
    final db = await database;
    await db.delete('binh_luan', where: 'id = ?', whereArgs: [id]);
  }

  /// Cập nhật điểm đánh giá (1..5 sao) cho bộ truyện.
  Future<double> updateNovelRating(int novelId, double userStars) async {
    if (isSupabaseReady) {
      try {
        return await SupabaseDatabase.instance.updateNovelRating(
          novelId,
          userStars,
        );
      } catch (e) {
        debugPrint('Supabase updateNovelRating error: $e');
        if (kIsWeb) rethrow;
      }
    }
    if (kIsWeb) throw StateError('Supabase is not configured.');
    final db = await database;
    final current = await getNovel(novelId);
    if (current == null) return userStars;
    // Tính trung bình có trọng số với điểm hiện tại
    final newRating = double.parse(
      ((current.rating * 4 + userStars) / 5).clamp(1.0, 5.0).toStringAsFixed(1),
    );
    await db.update(
      'truyen',
      {'rating': newRating},
      where: 'id = ?',
      whereArgs: [novelId],
    );
    return newRating;
  }

  // ---------------------------------------------------------------------------
  // Thống kê phiên đọc (reading_sessions) & Sao lưu / Khôi phục JSON
  // ---------------------------------------------------------------------------

  static String _dateKeyOf(DateTime d) {
    final local = d.toLocal();
    final m = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}-$m-$day';
  }

  /// Cộng dồn số từ và số phút đọc cho ngày hôm nay (hoặc [date]),
  /// đồng thời ghi nhận log theo khung giờ và tiến độ nhiệm vụ.
  Future<void> recordReadingSession({
    required int words,
    required int minutes,
    DateTime? date,
    String userId = '',
    int novelId = 0,
    int chapterId = 0,
  }) async {
    if (words <= 0 && minutes <= 0) return;
    final stats = await _statsStore();
    final server = _statsRemote;
    final now = date ?? DateTime.now();
    var recordedInCloud = false;
    if (userId.isNotEmpty && server != null && novelId >= 0) {
      try {
        recordedInCloud = await server.recordReadingSession(
          wordsRead: words,
          minutesRead: minutes,
          userId: userId,
          novelId: novelId,
          chapterId: chapterId,
        );
      } catch (e) {
        debugPrint('Supabase recordReadingSession error: $e');
      }
    }
    final db = await database;
    final key = _dateKeyOf(now);
    final activeChapterQuests =
        userId.isNotEmpty && novelId > 0 && chapterId > 0
        ? (await V2DatabaseStore.getActiveQuests(db))
              .where((quest) => quest.goalType == 'read_chapters')
              .toList()
        : null;
    final newlyReadQuestIds = <int>[];
    // Không giữ khóa SQLite khi đang gọi máy chủ. Các tổng ngày, log và
    // kiểm tra chương đã đọc được cập nhật cùng một giao dịch cục bộ.
    await db.transaction((txn) async {
      await ReadingStatsCache.increment(
        txn,
        'phien_doc',
        userId,
        key,
        words,
        minutes,
      );

      // Keep a separate, mergeable aggregate for device-only and offline
      // sessions. The main local aggregate also contains cloud-synced sessions
      // and must not be blindly added to cloud totals.
      if (!recordedInCloud) {
        await ReadingStatsCache.increment(
          txn,
          'phien_doc_cuc_bo',
          userId,
          key,
          words,
          minutes,
        );
      }

      if (activeChapterQuests != null) {
        for (final quest in activeChapterQuests) {
          final seenInQuestWindow = await txn.query(
            'nhat_ky_phien_doc',
            columns: ['id'],
            where: 'user_id = ? AND novel_id = ? AND chapter_id = ? AND ended_at >= ? AND ended_at <= ?',
            whereArgs: [
              userId,
              novelId,
              chapterId,
              quest.startsAt.millisecondsSinceEpoch,
              quest.endsAt.millisecondsSinceEpoch,
            ],
            limit: 1,
          );
          if (seenInQuestWindow.isEmpty) newlyReadQuestIds.add(quest.id);
        }
      }

      await txn.insert('nhat_ky_phien_doc', {
        'user_id': userId,
        'novel_id': novelId,
        'chapter_id': chapterId,
        'started_at': now
            .subtract(Duration(minutes: minutes.clamp(1, 120)))
            .millisecondsSinceEpoch,
        'ended_at': now.millisecondsSinceEpoch,
        'words_read': words,
        'hour_of_day': now.hour,
      });
      stats.changed(userId);
    });

    if (userId.isNotEmpty) {
      if (minutes > 0) {
        await V2DatabaseStore.incrementQuestProgress(
          db,
          userId: userId,
          goalType: 'read_minutes',
          delta: minutes.clamp(1, 120),
        );
      }
      if (newlyReadQuestIds.isNotEmpty) {
        await V2DatabaseStore.incrementQuestProgress(
          db,
          userId: userId,
          goalType: 'read_chapters',
          delta: 1,
          questIds: newlyReadQuestIds.toSet(),
        );
      }
    }
  }

  /// Lấy toàn bộ lịch sử phiên đọc theo ngày (tăng dần theo ngày).
  Future<List<ReadingSessionStat>> getReadingSessions({String? userId}) async {
    final uid = _historyUserId(userId);
    return (await _statsStore()).load(uid);
  }

  /// Tổng trên thiết bị dành riêng cho Dashboard Admin khi không có RPC.
  Future<List<ReadingSessionStat>> getDeviceReadingSessions() async {
    final rows = await (await database).rawQuery(
      'SELECT date_key, SUM(words_read) AS words_read, SUM(minutes_read) AS minutes_read FROM phien_doc GROUP BY date_key ORDER BY date_key',
    );
    return rows.map(ReadingSessionStat.fromMap).toList();
  }

  /// Xuất toàn bộ dữ liệu cá nhân (tủ sách, lịch sử, bookmark, quotes, reading_sessions) ra JSON.
  Future<String> exportUserBackupJson({String? userId}) async {
    final uid = _historyUserId(userId);
    final db = await database;
    final snapshot = await db.transaction((db) async {
      final libraryRows = await db.query('tu_sach');
      final historyRows = await db.query('lich_su_doc');
      final bookmarkRows = await db.query('dau_trang');
      final quoteRows = await db.query(
        'trich_dan',
        where: 'user_id = ?',
        whereArgs: [uid],
      );
      final sessionRows = await db.query(
        'phien_doc',
        where: 'user_id = ?',
        whereArgs: [uid],
      );
      final localSessionRows = await db.query(
        'phien_doc_cuc_bo',
        where: 'user_id = ?',
        whereArgs: [uid],
      );
      final cachedHistoryRows = await db.query(
        ReadingHistoryCache.table,
        where: 'user_id = ?',
        whereArgs: [uid],
      );

      return <String, Object?>{
        'backup_version': 8,
        'cached_bookmarks': [
          for (final row in await db.query(
            BookmarkCache.table,
            where: 'user_id = ?',
            whereArgs: [uid],
          ))
            Map<String, Object?>.from(row)
              ..remove('local_id')
              ..remove('remote_id')
              ..remove('user_id')
              ..remove('pending'),
        ],
        'cached_library': [
          for (final row in await db.query(
            LibraryCache.table,
            where: 'user_id = ?',
            whereArgs: [uid],
          ))
            Map<String, Object?>.from(row)..remove('user_id'),
        ],
        'custom_novels': await db.query(
          'truyen',
          where: 'id < 0',
          orderBy: 'id',
        ),
        'custom_chapters': await db.query(
          'chuong',
          where: 'novel_id < 0',
          orderBy: 'novel_id, chapter_index',
        ),
        'exported_at': DateTime.now().toIso8601String(),
        'library': libraryRows,
        'reading_history': historyRows,
        'bookmarks': bookmarkRows,
        'quotes': [
          for (final row in quoteRows)
            QuoteItem.fromMap(row).toMap()..remove('id'),
        ],
        'reading_sessions': [
          for (final row in sessionRows)
            ReadingSessionStat.fromMap(row).toMap(),
        ],
        'local_reading_sessions': [
          for (final row in localSessionRows)
            ReadingSessionStat.fromMap(row).toMap(),
        ],
        'cached_reading_history': [
          for (final row in cachedHistoryRows)
            Map<String, Object?>.from(row)..remove('user_id'),
        ],
      };
    });
    // Đọc file sau khi đóng transaction để việc lưu tiến độ vẫn hoạt động
    // trong lúc sao lưu một bộ Manga có nhiều trang.
    final images = PortableBackupImages();
    snapshot['custom_novels'] = [
      for (final row in snapshot['custom_novels'] as List<Map<String, Object?>>)
        {
          ...row,
          'cover_url': await images.image((row['cover_url'] as String?) ?? ''),
        },
    ];
    snapshot['custom_chapters'] = [
      for (final row
          in snapshot['custom_chapters'] as List<Map<String, Object?>>)
        {
          ...row,
          'content': await images.content((row['content'] as String?) ?? ''),
        },
    ];
    return const JsonEncoder.withIndent('  ').convert(snapshot);
  }

  /// Khôi phục dữ liệu cá nhân từ chuỗi JSON đã sao lưu.
  Future<void> importUserBackupJson(String jsonString, {String? userId}) async {
    final uid = _historyUserId(userId);
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(AppStrings.restoreInvalid);
    }
    final db = await database;
    final stats = await _statsStore();
    await db.transaction((txn) async {
      final imported = await CustomNovelBackup.restore(txn, decoded);
      const backupTables = <String, String>{
        'library': 'tu_sach',
        'reading_history': 'lich_su_doc',
        'bookmarks': 'dau_trang',
      };
      for (final entry in backupTables.entries) {
        final list = decoded[entry.key];
        if (list is! List) continue;
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            final row = imported.remap(item);
            if (entry.key == 'reading_history') {
              await _saveLocalHistory(
                txn,
                ReadingHistory.fromMap(row),
                keepExistingOnTie: true,
              );
              continue;
            }
            // ID bookmark tự tăng thuộc máy nguồn, không thay thế mục
            // không liên quan đang dùng cùng ID trên máy đích.
            if (entry.key == 'bookmarks') {
              row.remove('id');
              final keys = row.keys.toList();
              final existing = await txn.query(
                entry.value,
                columns: ['id'],
                where: keys.map((k) => '$k IS ?').join(' AND '),
                whereArgs: keys.map((k) => row[k]).toList(),
                limit: 1,
              );
              if (existing.isNotEmpty) continue;
              if (entry.key == 'bookmarks' && (row['novel_id'] as int) < 0) {
                row['id'] =
                    (Sqflite.firstIntValue(
                          await txn.rawQuery(
                            'SELECT MIN(id) FROM dau_trang WHERE id < 0',
                          ),
                        ) ??
                        0) -
                    1;
              }
            }
            await txn.insert(
              entry.value,
              row,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        }
      }
      await ReadingStatsCache.restore(txn, decoded, uid);
      stats.changed(uid);
      final cachedHistory = decoded['cached_reading_history'];
      final quoteRows = decoded['quotes'];
      if (quoteRows is List) {
        await QuoteStore.restore(txn, [
          for (final row in quoteRows.whereType<Map<String, dynamic>>())
            imported.remap(row),
        ], uid);
      }
      final cachedBookmarks = decoded['cached_bookmarks'];
      if (cachedBookmarks is List) {
        await BookmarkCache.restore(txn, cachedBookmarks, uid);
      }
      final cachedLibrary = decoded['cached_library'];
      if (cachedLibrary is List) {
        for (final item in cachedLibrary.whereType<Map<String, dynamic>>()) {
          await txn.insert(LibraryCache.table, {
            ...item,
            'user_id': uid,
            'pending': 1,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      if (cachedHistory is List) {
        await ReadingHistoryCache.restore(txn, cachedHistory, uid);
      }
    });
  }

  /// Đóng kết nối (dùng trong test).
  Future<void> close() async {
    await _historyCache?.waitForPendingSync();
    await _db?.close();
    _db = null;
    _opening = null;
    _historyCache = null;
    _libraryCache = null;
    _bookmarkCache = null;
    _quotes = null;
    _statsCache = null;
    _extrasCache = null;
  }
}
