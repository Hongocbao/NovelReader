import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/bookmark.dart';
import '../models/chapter.dart';
import '../models/library_item.dart';
import '../models/novel.dart';
import '../models/reading_history.dart';
import '../utils/constants.dart';
import '../utils/format.dart';

/// Lớp truy cập SQLite của ứng dụng: tạo bảng, CRUD và nạp dữ liệu mẫu.
///
/// Ngoài ra lớp này đóng vai trò "nguồn dữ liệu online giả lập":
/// nội dung chương được đọc từ file JSON mẫu (như gọi API máy chủ).
/// Khi người dùng tải chương, nội dung được lưu vào bảng `chapters`
/// để đọc offline.
///
/// GHI CHÚ: Khi có backend thật (Firebase/Firestore, REST API...), chỉ cần
/// thay phần thân của [fetchChapterContent] và [_loadSampleData].
class AppDatabase {
  /// [factory]: cho phép truyền factory khác (ví dụ ffi khi chạy test).
  /// [path]: đường dẫn DB, mặc định nằm trong thư mục databases của máy.
  /// [sampleJsonLoader]: hàm đọc chuỗi JSON mẫu (mặc định đọc từ assets).
  AppDatabase({
    this.factory,
    this.path,
    Future<String> Function()? sampleJsonLoader,
  }) : _sampleJsonLoader = sampleJsonLoader ??
            (() => rootBundle.loadString(AppInfo.sampleDataAsset));

  /// Thể hiện dùng chung trong app.
  static final AppDatabase instance = AppDatabase();

  final DatabaseFactory? factory;
  final String? path;
  final Future<String> Function() _sampleJsonLoader;

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
    final dbPath = path ??
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
          await _ensureExtraTables(db);
          // Bổ sung truyện mới từ sample_novels.json mà không làm mất lịch sử/tủ sách cũ.
          await _syncSampleNovels(db);
        },
      ),
    );
    await _ensureExtraTables(db);
    await _seedIfNeeded(db);
    return db;
  }

  /// Tạo các bảng và chỉ mục.
  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    batch.execute('''
      CREATE TABLE novels (
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
      CREATE TABLE chapters (
        id INTEGER PRIMARY KEY,
        novel_id INTEGER NOT NULL REFERENCES novels(id) ON DELETE CASCADE,
        chapter_index INTEGER NOT NULL,
        title TEXT NOT NULL,
        content TEXT,
        is_downloaded INTEGER NOT NULL DEFAULT 0,
        UNIQUE(novel_id, chapter_index)
      )
    ''');
    batch.execute('''
      CREATE TABLE library (
        novel_id INTEGER PRIMARY KEY REFERENCES novels(id) ON DELETE CASCADE,
        category TEXT NOT NULL,
        added_at INTEGER NOT NULL
      )
    ''');
    batch.execute('''
      CREATE TABLE reading_history (
        novel_id INTEGER PRIMARY KEY REFERENCES novels(id) ON DELETE CASCADE,
        last_chapter_id INTEGER NOT NULL,
        scroll_offset REAL NOT NULL DEFAULT 0,
        last_read_at INTEGER NOT NULL
      )
    ''');
    batch.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        novel_id INTEGER NOT NULL REFERENCES novels(id) ON DELETE CASCADE,
        chapter_id INTEGER NOT NULL REFERENCES chapters(id) ON DELETE CASCADE,
        scroll_offset REAL NOT NULL DEFAULT 0,
        note TEXT,
        created_at INTEGER NOT NULL
      )
    ''');
    batch.execute(
        'CREATE INDEX idx_chapters_novel ON chapters(novel_id, chapter_index)');
    batch.execute('CREATE INDEX idx_bookmarks_novel ON bookmarks(novel_id)');
    await batch.commit(noResult: true);
    await _ensureExtraTables(db);
  }

  /// Tạo các bảng mở rộng (trích dẫn yêu thích & bình luận chương).
  Future<void> _ensureExtraTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS quotes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        novel_id INTEGER NOT NULL,
        novel_title TEXT NOT NULL,
        author TEXT NOT NULL,
        chapter_title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        novel_id INTEGER NOT NULL,
        chapter_id INTEGER NOT NULL,
        user_name TEXT NOT NULL,
        content TEXT NOT NULL,
        stars INTEGER NOT NULL DEFAULT 5,
        created_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS reading_sessions (
        date_key TEXT PRIMARY KEY,
        words_read INTEGER NOT NULL DEFAULT 0,
        minutes_read INTEGER NOT NULL DEFAULT 0
      )
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
    final count = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM novels')) ??
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
        batch.insert(
          'novels',
          {
            ...novel.toMap(),
            'search_text': Format.normalize('${novel.title} ${novel.author}'),
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        for (final c in chapters) {
          final index = c['index'] as int;
          batch.insert(
            'chapters',
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

  /// "Gọi máy chủ" lấy nội dung chương (giả lập bằng JSON mẫu).
  /// Ném [StateError] nếu không tìm thấy chương.
  Future<String> fetchChapterContent(int novelId, int chapterIndex) async {
    if (_remoteContent == null) {
      final novels = await _loadSampleData();
      _remoteContent = {
        for (final n in novels)
          n['id'] as int: {
            for (final c in (n['chapters'] as List).cast<Map<String, dynamic>>())
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
  }) async {
    final db = await database;
    final where = <String>[];
    final args = <Object?>[];
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
      'novels',
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
    final db = await database;
    final rows = await db.query('novels', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Novel.fromMap(rows.first);
  }

  /// Đếm số truyện theo từng thể loại.
  Future<Map<String, int>> genreCounts() async {
    final db = await database;
    final rows = await db.query('novels', columns: ['genres']);
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
  }) async {
    final db = await database;
    final maxId = Sqflite.firstIntValue(
            await db.rawQuery('SELECT MAX(id) FROM novels')) ??
        100;
    final newId = maxId + 1;
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
      genres: genres,
      totalChapters: chapters.length,
      rating: 5.0,
      views: 1,
      updatedAt: now,
    );

    await db.transaction((txn) async {
      await txn.insert('novels', {
        ...novel.toMap(),
        'search_text': Format.normalize('${novel.title} ${novel.author}'),
      });
      for (var i = 0; i < chapters.length; i++) {
        final idx = i + 1;
        final ch = chapters[i];
        await txn.insert(
          'chapters',
          Chapter(
            id: newId * 10000 + idx,
            novelId: newId,
            chapterIndex: idx,
            title: ch.title.trim(),
            content: ch.content.trim(),
            isDownloaded: true,
          ).toMap(),
        );
      }
    });
    return novel;
  }

  /// Thêm 1 chương mới vào bộ truyện đã có.
  Future<Chapter> appendChapter({
    required int novelId,
    required String title,
    required String content,
  }) async {
    final db = await database;
    final maxIdx = Sqflite.firstIntValue(await db.rawQuery(
            'SELECT MAX(chapter_index) FROM chapters WHERE novel_id = ?',
            [novelId])) ??
        0;
    final nextIdx = maxIdx + 1;
    final chapter = Chapter(
      id: novelId * 10000 + nextIdx,
      novelId: novelId,
      chapterIndex: nextIdx,
      title: title.trim().startsWith('Chương')
          ? title.trim()
          : 'Chương $nextIdx: ${title.trim()}',
      content: content.trim(),
      isDownloaded: true,
    );
    await db.transaction((txn) async {
      await txn.insert('chapters', chapter.toMap());
      await txn.update(
        'novels',
        {
          'total_chapters': nextIdx,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [novelId],
      );
    });
    return chapter;
  }

  // ---------------------------------------------------------------------------
  // Chương
  // ---------------------------------------------------------------------------

  /// Danh sách chương của truyện (không kèm nội dung cho nhẹ).
  Future<List<Chapter>> getChapters(int novelId) async {
    final db = await database;
    final rows = await db.query(
      'chapters',
      columns: ['id', 'novel_id', 'chapter_index', 'title', 'is_downloaded'],
      where: 'novel_id = ?',
      whereArgs: [novelId],
      orderBy: 'chapter_index ASC',
    );
    return rows.map(Chapter.fromMap).toList();
  }

  /// Lấy 1 chương (kèm nội dung nếu đã tải).
  Future<Chapter?> getChapter(int id) async {
    final db = await database;
    final rows = await db.query('chapters', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Chapter.fromMap(rows.first);
  }

  /// Lưu nội dung chương để đọc offline (is_downloaded = 1).
  Future<void> saveChapterContent(int chapterId, String content) async {
    final db = await database;
    await db.update(
      'chapters',
      {'content': content, 'is_downloaded': 1},
      where: 'id = ?',
      whereArgs: [chapterId],
    );
  }

  /// Xóa nội dung đã tải của 1 chương.
  Future<void> deleteChapterContent(int chapterId) async {
    final db = await database;
    await db.update(
      'chapters',
      {'content': null, 'is_downloaded': 0},
      where: 'id = ?',
      whereArgs: [chapterId],
    );
  }

  /// Xóa nội dung đã tải của cả truyện, hoặc toàn bộ nếu [novelId] = null.
  Future<int> deleteDownloads({int? novelId}) async {
    final db = await database;
    return db.update(
      'chapters',
      {'content': null, 'is_downloaded': 0},
      where: novelId == null ? 'is_downloaded = 1' : 'is_downloaded = 1 AND novel_id = ?',
      whereArgs: novelId == null ? null : [novelId],
    );
  }

  /// Danh sách chương đã tải kèm tên truyện và dung lượng.
  Future<List<DownloadedChapter>> getDownloadedChapters() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT c.id, c.novel_id, c.chapter_index, c.title, c.is_downloaded,
             n.title AS novel_title, n.cover_url,
             LENGTH(CAST(c.content AS BLOB)) AS size
      FROM chapters c JOIN novels n ON n.id = c.novel_id
      WHERE c.is_downloaded = 1
      ORDER BY n.title COLLATE NOCASE, c.chapter_index
    ''');
    return rows.map(DownloadedChapter.fromMap).toList();
  }

  /// Số chương đã tải.
  Future<int> countDownloaded() async {
    final db = await database;
    return Sqflite.firstIntValue(await db.rawQuery(
            'SELECT COUNT(*) FROM chapters WHERE is_downloaded = 1')) ??
        0;
  }

  // ---------------------------------------------------------------------------
  // Tủ sách
  // ---------------------------------------------------------------------------

  static const String _librarySelect = '''
    SELECT l.novel_id, l.category, l.added_at, n.*,
           c.chapter_index AS last_chapter_index, h.last_read_at
    FROM library l
    JOIN novels n ON n.id = l.novel_id
    LEFT JOIN reading_history h ON h.novel_id = l.novel_id
    LEFT JOIN chapters c ON c.id = h.last_chapter_id
  ''';

  /// Toàn bộ tủ sách (kèm thông tin truyện + tiến độ).
  Future<List<LibraryItem>> getLibrary() async {
    final db = await database;
    final rows = await db.rawQuery('$_librarySelect ORDER BY l.added_at DESC');
    return rows.map(LibraryItem.fromMap).toList();
  }

  /// Thêm hoặc cập nhật danh mục của truyện trong tủ sách.
  Future<void> upsertLibrary(LibraryItem item) async {
    final db = await database;
    await db.insert('library', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Xóa truyện khỏi tủ sách.
  Future<void> removeFromLibrary(int novelId) async {
    final db = await database;
    await db.delete('library', where: 'novel_id = ?', whereArgs: [novelId]);
  }

  // ---------------------------------------------------------------------------
  // Lịch sử đọc
  // ---------------------------------------------------------------------------

  static const String _historySelect = '''
    SELECT h.*, n.*, c.chapter_index, c.title AS chapter_title
    FROM reading_history h
    JOIN novels n ON n.id = h.novel_id
    LEFT JOIN chapters c ON c.id = h.last_chapter_id
  ''';

  /// Lịch sử đọc, mới nhất trước.
  Future<List<ReadingHistory>> getHistory() async {
    final db = await database;
    final rows =
        await db.rawQuery('$_historySelect ORDER BY h.last_read_at DESC');
    return rows.map(ReadingHistory.fromMap).toList();
  }

  /// Lịch sử đọc của 1 truyện.
  Future<ReadingHistory?> getHistoryFor(int novelId) async {
    final db = await database;
    final rows = await db
        .rawQuery('$_historySelect WHERE h.novel_id = ?', [novelId]);
    return rows.isEmpty ? null : ReadingHistory.fromMap(rows.first);
  }

  /// Ghi (hoặc ghi đè) lịch sử đọc.
  Future<void> saveHistory(ReadingHistory history) async {
    final db = await database;
    await db.insert('reading_history', history.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Xóa lịch sử của 1 truyện.
  Future<void> deleteHistory(int novelId) async {
    final db = await database;
    await db.delete('reading_history',
        where: 'novel_id = ?', whereArgs: [novelId]);
  }

  /// Xóa toàn bộ lịch sử.
  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('reading_history');
  }

  // ---------------------------------------------------------------------------
  // Bookmark
  // ---------------------------------------------------------------------------

  /// Danh sách bookmark của truyện (kèm số/tên chương).
  Future<List<Bookmark>> getBookmarks(int novelId) async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT b.*, c.chapter_index, c.title AS chapter_title
      FROM bookmarks b JOIN chapters c ON c.id = b.chapter_id
      WHERE b.novel_id = ?
      ORDER BY c.chapter_index, b.scroll_offset
    ''', [novelId]);
    return rows.map(Bookmark.fromMap).toList();
  }

  /// Thêm bookmark, trả về id mới.
  Future<int> addBookmark(Bookmark bookmark) async {
    final db = await database;
    return db.insert('bookmarks', bookmark.toMap());
  }

  /// Xóa bookmark.
  Future<void> deleteBookmark(int id) async {
    final db = await database;
    await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------------
  // Trích dẫn (Quotes) & Bình luận / Đánh giá
  // ---------------------------------------------------------------------------

  /// Danh sách trích dẫn đã lưu (mới nhất trước).
  Future<List<QuoteItem>> getQuotes() async {
    final db = await database;
    final rows = await db.query('quotes', orderBy: 'created_at DESC');
    return rows.map(QuoteItem.fromMap).toList();
  }

  /// Lưu trích dẫn mới.
  Future<int> addQuote(QuoteItem quote) async {
    final db = await database;
    return db.insert('quotes', quote.toMap());
  }

  /// Xóa một trích dẫn.
  Future<void> deleteQuote(int id) async {
    final db = await database;
    await db.delete('quotes', where: 'id = ?', whereArgs: [id]);
  }

  /// Lấy danh sách bình luận của một chương.
  Future<List<ChapterComment>> getComments(int chapterId) async {
    final db = await database;
    final rows = await db.query(
      'comments',
      where: 'chapter_id = ?',
      whereArgs: [chapterId],
      orderBy: 'created_at DESC',
    );
    return rows.map(ChapterComment.fromMap).toList();
  }

  /// Thêm bình luận cho chương và cập nhật điểm đánh giá trung bình của truyện.
  Future<void> addComment(ChapterComment comment) async {
    final db = await database;
    await db.insert('comments', comment.toMap());
  }

  /// Xóa bình luận.
  Future<void> deleteComment(int id) async {
    final db = await database;
    await db.delete('comments', where: 'id = ?', whereArgs: [id]);
  }

  /// Cập nhật điểm đánh giá (1..5 sao) cho bộ truyện.
  Future<double> updateNovelRating(int novelId, double userStars) async {
    final db = await database;
    final current = await getNovel(novelId);
    if (current == null) return userStars;
    // Tính trung bình có trọng số với điểm hiện tại
    final newRating = double.parse(
      ((current.rating * 4 + userStars) / 5).clamp(1.0, 5.0).toStringAsFixed(1),
    );
    await db.update(
      'novels',
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

  /// Cộng dồn số từ và số phút đọc cho ngày hôm nay (hoặc [date]).
  Future<void> recordReadingSession({
    required int words,
    required int minutes,
    DateTime? date,
  }) async {
    if (words <= 0 && minutes <= 0) return;
    final db = await database;
    final key = _dateKeyOf(date ?? DateTime.now());
    final existing = await db.query(
      'reading_sessions',
      where: 'date_key = ?',
      whereArgs: [key],
    );
    if (existing.isEmpty) {
      await db.insert('reading_sessions', {
        'date_key': key,
        'words_read': words,
        'minutes_read': minutes,
      });
    } else {
      final prevWords = (existing.first['words_read'] as int?) ?? 0;
      final prevMinutes = (existing.first['minutes_read'] as int?) ?? 0;
      await db.update(
        'reading_sessions',
        {
          'words_read': prevWords + words,
          'minutes_read': prevMinutes + minutes,
        },
        where: 'date_key = ?',
        whereArgs: [key],
      );
    }
  }

  /// Lấy toàn bộ lịch sử phiên đọc theo ngày (tăng dần theo ngày).
  Future<List<ReadingSessionStat>> getReadingSessions() async {
    final db = await database;
    final rows = await db.query('reading_sessions', orderBy: 'date_key ASC');
    return rows.map(ReadingSessionStat.fromMap).toList();
  }

  /// Xuất toàn bộ dữ liệu cá nhân (tủ sách, lịch sử, bookmark, quotes, reading_sessions) ra JSON.
  Future<String> exportUserBackupJson() async {
    final db = await database;
    final libraryRows = await db.query('library');
    final historyRows = await db.query('reading_history');
    final bookmarkRows = await db.query('bookmarks');
    final quoteRows = await db.query('quotes');
    final sessionRows = await db.query('reading_sessions');

    return const JsonEncoder.withIndent('  ').convert({
      'backup_version': 1,
      'exported_at': DateTime.now().toIso8601String(),
      'library': libraryRows,
      'reading_history': historyRows,
      'bookmarks': bookmarkRows,
      'quotes': quoteRows,
      'reading_sessions': sessionRows,
    });
  }

  /// Khôi phục dữ liệu cá nhân từ chuỗi JSON đã sao lưu.
  Future<void> importUserBackupJson(String jsonString) async {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(AppStrings.restoreInvalid);
    }
    final db = await database;
    await db.transaction((txn) async {
      for (final table in const [
        'library',
        'reading_history',
        'bookmarks',
        'quotes',
        'reading_sessions',
      ]) {
        final list = decoded[table];
        if (list is! List) continue;
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            await txn.insert(
              table,
              item,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        }
      }
    });
  }

  /// Đóng kết nối (dùng trong test).
  Future<void> close() async {
    await _db?.close();
    _db = null;
    _opening = null;
  }
}
