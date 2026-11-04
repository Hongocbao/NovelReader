import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/achievement.dart';
import '../models/announcement.dart';
import '../models/app_user.dart';
import '../models/audit_log.dart';
import '../models/chapter_summary.dart';
import '../models/glossary_term.dart';
import '../models/notification_item.dart';
import '../models/quest.dart';
import '../models/reading_session.dart';
import '../models/report.dart';
import '../utils/constants.dart';
import 'v2_seed_data.dart';

bool get _isSupabaseReady {
  try {
    Supabase.instance.client;
    return SupabaseConfig.anonKey != 'YOUR_SUPABASE_ANON_KEY' &&
        SupabaseConfig.anonKey.trim().isNotEmpty;
  } catch (_) {
    return false;
  }
}

/// Lớp quản lý các bảng dữ liệu mở rộng của NovelReader v2 (SQLite).
///
/// Chịu trách nhiệm:
/// - Nâng cấp schema từ v1 lên v2 (`migrateToV2`) mà không làm mất dữ liệu cũ.
/// - Tạo các bảng v2: `users`, `reading_session_logs`, `achievements`, `user_achievements`,
///   `quests`, `user_quests`, `reports`, `announcements`, `notifications`, `glossary_terms`,
///   `chapter_summaries`, `paragraph_reactions`, `time_capsules`, `novel_requests`,
///   `character_graphs`, `banned_words`, `audit_logs`, `app_config`.
class V2DatabaseStore {
  V2DatabaseStore._();

  /// Đảm bảo tất cả cột mở rộng và bảng v2 tồn tại, sau đó seed dữ liệu mặc định.
  static Future<void> ensureV2SchemaAndSeed(Database db) async {
    await migrateToV2(db);
    await V2SeedData.seedIfNeeded(db);
  }

  /// Nâng cấp schema từ phiên bản cũ lên v2 một cách an toàn (idempotent).
  static Future<void> migrateToV2(Database db) async {
    // 1. Bổ sung cột mới cho bảng novels, chapters, comments nếu chưa có
    await _addColumnIfMissing(
      db,
      'truyen',
      'moderation_status',
      "TEXT NOT NULL DEFAULT 'approved'",
    );
    await _addColumnIfMissing(db, 'truyen', 'rejection_reason', 'TEXT');
    await _addColumnIfMissing(
      db,
      'truyen',
      'owner_id',
      'INTEGER NOT NULL DEFAULT 1',
    );
    await _addColumnIfMissing(
      db,
      'truyen',
      'is_featured',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _addColumnIfMissing(
      db,
      'truyen',
      'featured_order',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _addColumnIfMissing(db, 'truyen', 'deleted_at', 'INTEGER');

    await _addColumnIfMissing(db, 'chuong', 'publish_at', 'INTEGER');

    await _addColumnIfMissing(
      db,
      'binh_luan',
      'user_id',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _addColumnIfMissing(
      db,
      'binh_luan',
      'chapter_index',
      'INTEGER NOT NULL DEFAULT 1',
    );
    await _addColumnIfMissing(
      db,
      'binh_luan',
      'is_hidden',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _addColumnIfMissing(
      db,
      'binh_luan',
      'likes',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _addColumnIfMissing(db, 'binh_luan', 'parent_id', 'INTEGER');

    // 2. Tạo các bảng mới của phiên bản v2
    await db.execute('''
      CREATE TABLE IF NOT EXISTS nguoi_dung (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        display_name TEXT NOT NULL,
        avatar TEXT NOT NULL DEFAULT '📚',
        avatar_frame TEXT NOT NULL DEFAULT 'default',
        role TEXT NOT NULL DEFAULT 'user',
        is_author INTEGER NOT NULL DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'active',
        ban_reason TEXT,
        ban_until INTEGER,
        linh_thach INTEGER NOT NULL DEFAULT 100,
        streak INTEGER NOT NULL DEFAULT 0,
        has_streak_shield INTEGER NOT NULL DEFAULT 0,
        pinned_achievements TEXT DEFAULT '',
        unlocked_items TEXT DEFAULT 'default',
        last_active_at INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS nhat_ky_phien_doc (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL DEFAULT 0,
        novel_id INTEGER NOT NULL DEFAULT 0,
        chapter_id INTEGER NOT NULL DEFAULT 0,
        started_at INTEGER NOT NULL,
        ended_at INTEGER NOT NULL,
        words_read INTEGER NOT NULL DEFAULT 0,
        hour_of_day INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS thanh_tuu (
        code TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        rule_json TEXT NOT NULL DEFAULT '{}'
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS thanh_tuu_nguoi_dung (
        user_id INTEGER NOT NULL,
        code TEXT NOT NULL,
        unlocked_at INTEGER NOT NULL,
        PRIMARY KEY (user_id, code)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS nhiem_vu (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        goal_type TEXT NOT NULL,
        goal_value INTEGER NOT NULL,
        reward INTEGER NOT NULL,
        starts_at INTEGER NOT NULL,
        ends_at INTEGER NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS nhiem_vu_nguoi_dung (
        user_id INTEGER NOT NULL,
        quest_id INTEGER NOT NULL,
        progress INTEGER NOT NULL DEFAULT 0,
        claimed INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (user_id, quest_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS bao_cao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reporter_id INTEGER NOT NULL,
        reporter_name TEXT NOT NULL DEFAULT 'Độc giả',
        target_type TEXT NOT NULL,
        target_id INTEGER NOT NULL,
        target_snapshot TEXT DEFAULT '',
        reason TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'open',
        handled_by INTEGER,
        resolution_note TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS thong_bao_chung (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        audience TEXT NOT NULL DEFAULT 'all',
        pinned INTEGER NOT NULL DEFAULT 0,
        created_by INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS thong_bao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        kind TEXT NOT NULL DEFAULT 'system',
        is_read INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS thuat_ngu (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        novel_id INTEGER NOT NULL,
        term TEXT NOT NULL,
        meaning TEXT NOT NULL,
        first_chapter_index INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS tom_tat_chuong (
        chapter_id INTEGER PRIMARY KEY,
        novel_id INTEGER NOT NULL,
        chapter_index INTEGER NOT NULL DEFAULT 1,
        summary TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS cam_xuc_doan (
        user_id INTEGER NOT NULL,
        chapter_id INTEGER NOT NULL,
        paragraph_index INTEGER NOT NULL,
        emoji TEXT NOT NULL,
        PRIMARY KEY (user_id, chapter_id, paragraph_index)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS hop_thoi_gian (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        novel_id INTEGER NOT NULL,
        chapter_id INTEGER NOT NULL,
        note TEXT NOT NULL,
        unlock_after_days INTEGER NOT NULL DEFAULT 30,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS yeu_cau_truyen (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        user_name TEXT NOT NULL,
        title TEXT NOT NULL,
        author_hint TEXT DEFAULT '',
        description TEXT DEFAULT '',
        votes INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS so_do_nhan_vat (
        novel_id INTEGER PRIMARY KEY,
        graph_json TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS tu_cam (
        word TEXT PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS nhat_ky_quan_tri (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        admin_id INTEGER NOT NULL,
        admin_name TEXT NOT NULL DEFAULT 'Admin',
        action TEXT NOT NULL,
        target TEXT NOT NULL,
        detail TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS cau_hinh_ung_dung (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _addColumnIfMissing(
    Database db,
    String table,
    String column,
    String definition,
  ) async {
    final info = await db.rawQuery('PRAGMA table_info($table)');
    final exists = info.any((r) => r['name'] == column);
    if (!exists) {
      await db.execute('ALTER TABLE $table ADD COLUMN $column $definition');
    }
  }

  // ---------------------------------------------------------------------------
  // Truy vấn & Thao tác v2
  // ---------------------------------------------------------------------------

  static Future<List<Achievement>> getAllAchievements(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client.from('thanh_tuu').select();
        return (res as List)
            .map((r) => Achievement.fromMap(r as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    final rows = await db.query('thanh_tuu');
    return rows.map(Achievement.fromMap).toList();
  }

  static Future<List<UserAchievement>> getUserAchievements(
    Database db,
    String userId,
  ) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('thanh_tuu_nguoi_dung')
            .select()
            .eq('user_id', userId)
            .order('unlocked_at', ascending: false);
        return (res as List)
            .map((r) => UserAchievement.fromMap(r as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    final rows = await db.query(
      'thanh_tuu_nguoi_dung',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'unlocked_at DESC',
    );
    return rows.map(UserAchievement.fromMap).toList();
  }

  static Future<bool> unlockAchievement(
    Database db,
    String userId,
    String code,
  ) async {
    if (_isSupabaseReady) {
      try {
        final client = Supabase.instance.client;
        final existing = await client
            .from('thanh_tuu_nguoi_dung')
            .select()
            .eq('user_id', userId)
            .eq('code', code)
            .maybeSingle();
        if (existing != null) return false;
        await client.from('thanh_tuu_nguoi_dung').insert({
          'user_id': userId,
          'code': code,
          'unlocked_at': DateTime.now().millisecondsSinceEpoch,
        });
        return true;
      } catch (_) {}
    }
    final existing = await db.query(
      'thanh_tuu_nguoi_dung',
      where: 'user_id = ? AND code = ?',
      whereArgs: [userId, code],
    );
    if (existing.isNotEmpty) return false;
    await db.insert('thanh_tuu_nguoi_dung', {
      'user_id': userId,
      'code': code,
      'unlocked_at': DateTime.now().millisecondsSinceEpoch,
    });
    return true;
  }

  static Future<List<Quest>> getActiveQuests(Database db) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('nhiem_vu')
            .select()
            .eq('is_active', 1)
            .lte('starts_at', now)
            .gte('ends_at', now)
            .order('id', ascending: true);
        return (res as List)
            .map((r) => Quest.fromMap(r as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    final rows = await db.query(
      'nhiem_vu',
      where: 'is_active = 1',
      orderBy: 'id ASC',
    );
    return rows
        .map(Quest.fromMap)
        .where(
          (quest) =>
              quest.startsAt.millisecondsSinceEpoch <= now &&
              quest.endsAt.millisecondsSinceEpoch >= now,
        )
        .toList();
  }

  static Future<List<Quest>> getAllQuests(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('nhiem_vu')
            .select()
            .order('id', ascending: false);
        return (res as List)
            .map((r) => Quest.fromMap(r as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    final rows = await db.query('nhiem_vu', orderBy: 'id DESC');
    return rows.map(Quest.fromMap).toList();
  }

  static Future<Map<int, UserQuest>> getUserQuests(
    Database db,
    String userId,
  ) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('nhiem_vu_nguoi_dung')
            .select()
            .eq('user_id', userId);
        final list = (res as List).map(
          (r) => UserQuest.fromMap(r as Map<String, dynamic>),
        );
        return {for (final uq in list) uq.questId: uq};
      } catch (_) {}
    }
    final rows = await db.query(
      'nhiem_vu_nguoi_dung',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    final list = rows.map(UserQuest.fromMap);
    return {for (final uq in list) uq.questId: uq};
  }

  static Future<void> incrementQuestProgress(
    Database db, {
    required String userId,
    required String goalType,
    required int delta,
    Set<int>? questIds,
  }) async {
    if (userId.isEmpty || delta <= 0) return;
    if (_isSupabaseReady) {
      // Cloud quest progress is updated by trusted database events: reading
      // session RPCs and the comment-insert trigger. Never expose a generic
      // client-controlled progress increment to authenticated users.
    }
    final quests = await getActiveQuests(db);
    await db.transaction((txn) async {
      for (final q in quests.where(
        (e) =>
            e.goalType == goalType &&
            e.startsAt.millisecondsSinceEpoch <=
                DateTime.now().millisecondsSinceEpoch &&
            e.endsAt.millisecondsSinceEpoch >=
                DateTime.now().millisecondsSinceEpoch &&
            (questIds == null || questIds.contains(e.id)),
      )) {
        final rows = await txn.query(
          'nhiem_vu_nguoi_dung',
          where: 'user_id = ? AND quest_id = ?',
          whereArgs: [userId, q.id],
        );
        final current = rows.isEmpty ? null : UserQuest.fromMap(rows.first);
        if (current?.claimed ?? false) continue;
        final newProgress = ((current?.progress ?? 0) + delta).clamp(
          0,
          q.goalValue,
        );
        final progressMap = {
          'user_id': userId,
          'quest_id': q.id,
          'progress': newProgress,
          'claimed': current?.claimed == true ? 1 : 0,
        };
        if (current == null) {
          await txn.insert('nhiem_vu_nguoi_dung', progressMap);
        } else {
          await txn.update(
            'nhiem_vu_nguoi_dung',
            {'progress': newProgress},
            where: 'user_id = ? AND quest_id = ?',
            whereArgs: [userId, q.id],
          );
        }
      }
    });
  }

  static Future<void> cacheQuestClaim(
    Database db, {
    required String userId,
    required int questId,
  }) async {
    await db.update(
      'nhiem_vu_nguoi_dung',
      {'claimed': 1},
      where: 'user_id = ? AND quest_id = ?',
      whereArgs: [userId, questId],
    );
  }

  static Future<List<GlossaryTerm>> getGlossaryForNovel(
    Database db,
    int novelId, {
    int? maxChapterIndex,
  }) async {
    final where = maxChapterIndex == null
        ? 'novel_id = ?'
        : 'novel_id = ? AND first_chapter_index <= ?';
    final args = maxChapterIndex == null
        ? [novelId]
        : [novelId, maxChapterIndex];
    final rows = await db.query(
      'thuat_ngu',
      where: where,
      whereArgs: args,
      orderBy: 'first_chapter_index ASC, id ASC',
    );
    return rows.map(GlossaryTerm.fromMap).toList();
  }

  static Future<List<ChapterSummary>> getSummariesUpTo(
    Database db,
    int novelId,
    int maxChapterIndex,
  ) async {
    final rows = await db.query(
      'tom_tat_chuong',
      where: 'novel_id = ? AND chapter_index <= ?',
      whereArgs: [novelId, maxChapterIndex],
      orderBy: 'chapter_index DESC',
      limit: 3,
    );
    return rows.map(ChapterSummary.fromMap).toList();
  }

  static Future<Map<int, Map<String, int>>> getParagraphReactions(
    Database db,
    int chapterId,
  ) async {
    List<Map<String, dynamic>> rows;
    if (_isSupabaseReady) {
      try {
        final response = await Supabase.instance.client
            .from('cam_xuc_doan')
            .select()
            .eq('chapter_id', chapterId);
        rows = (response as List).cast<Map<String, dynamic>>();
      } catch (_) {
        rows = await db.query(
          'cam_xuc_doan',
          where: 'chapter_id = ?',
          whereArgs: [chapterId],
        );
      }
    } else {
      rows = await db.query(
        'cam_xuc_doan',
        where: 'chapter_id = ?',
        whereArgs: [chapterId],
      );
    }
    final result = <int, Map<String, int>>{};
    for (final r in rows) {
      final pIdx = (r['paragraph_index'] as int?) ?? 0;
      final emoji = (r['emoji'] as String?) ?? '❤️';
      final bucket = result.putIfAbsent(pIdx, () => <String, int>{});
      bucket[emoji] = (bucket[emoji] ?? 0) + 1;
    }
    return result;
  }

  static Future<void> addParagraphReaction(
    Database db,
    ParagraphReaction reaction,
  ) async {
    if (_isSupabaseReady && reaction.userId.isNotEmpty) {
      try {
        await Supabase.instance.client
            .from('cam_xuc_doan')
            .upsert(
              reaction.toMap(),
              onConflict: 'user_id,chapter_id,paragraph_index',
            );
      } catch (_) {}
    }
    await db.insert(
      'cam_xuc_doan',
      reaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<TimeCapsuleNote>> getTimeCapsules(
    Database db, {
    required int chapterId,
    required String userId,
  }) async {
    if (_isSupabaseReady && userId.isNotEmpty) {
      try {
        final rows = await Supabase.instance.client
            .from('hop_thoi_gian')
            .select()
            .eq('user_id', userId)
            .eq('chapter_id', chapterId)
            .order('created_at', ascending: false);
        return (rows as List)
            .map((row) => TimeCapsuleNote.fromMap(row as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    final rows = await db.query(
      'hop_thoi_gian',
      where: 'user_id = ? AND chapter_id = ?',
      whereArgs: [userId, chapterId],
      orderBy: 'created_at DESC',
    );
    return rows.map(TimeCapsuleNote.fromMap).toList();
  }

  static Future<void> createTimeCapsule(
    Database db,
    TimeCapsuleNote note,
  ) async {
    if (_isSupabaseReady && note.userId.isNotEmpty) {
      try {
        final map = note.toMap()..remove('id');
        await Supabase.instance.client.from('hop_thoi_gian').insert(map);
        await db.insert('hop_thoi_gian', map);
        return;
      } catch (_) {}
    }
    await db.insert('hop_thoi_gian', note.toMap());
  }

  static Future<String?> getCharacterGraph(Database db, int novelId) async {
    if (_isSupabaseReady) {
      try {
        final row = await Supabase.instance.client
            .from('so_do_nhan_vat')
            .select('graph_json')
            .eq('novel_id', novelId)
            .maybeSingle();
        if (row != null) return row['graph_json'] as String?;
      } catch (_) {}
    }
    final rows = await db.query(
      'so_do_nhan_vat',
      columns: ['graph_json'],
      where: 'novel_id = ?',
      whereArgs: [novelId],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['graph_json'] as String?;
  }

  static Future<void> saveCharacterGraph(
    Database db, {
    required int novelId,
    required String graphJson,
  }) async {
    final map = {'novel_id': novelId, 'graph_json': graphJson};
    if (_isSupabaseReady) {
      try {
        await Supabase.instance.client
            .from('so_do_nhan_vat')
            .upsert(map, onConflict: 'novel_id');
      } catch (_) {}
    }
    await db.insert(
      'so_do_nhan_vat',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<NotificationItem>> getNotifications(
    Database db,
    String userId,
  ) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('thong_bao')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false);
        return (res as List)
            .map((r) => NotificationItem.fromMap(r as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    final rows = await db.query(
      'thong_bao',
      where: 'user_id = ? OR user_id = ?',
      whereArgs: [userId, ''],
      orderBy: 'created_at DESC',
    );
    return rows.map(NotificationItem.fromMap).toList();
  }

  static Future<void> createNotification(
    Database db,
    NotificationItem item,
  ) async {
    if (_isSupabaseReady && item.userId.isNotEmpty) {
      try {
        await Supabase.instance.client.from('thong_bao').insert(item.toMap());
        return;
      } catch (_) {}
    }
    await db.insert('thong_bao', item.toMap());
  }

  static Future<void> markNotificationRead(
    Database db, {
    required int notificationId,
    required String userId,
  }) async {
    if (_isSupabaseReady && userId.isNotEmpty) {
      try {
        await Supabase.instance.client
            .from('thong_bao')
            .update({'is_read': 1})
            .eq('id', notificationId)
            .eq('user_id', userId);
      } catch (_) {}
    }
    await db.update(
      'thong_bao',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  static Future<void> markAllNotificationsRead(
    Database db, {
    required String userId,
  }) async {
    if (_isSupabaseReady && userId.isNotEmpty) {
      try {
        await Supabase.instance.client
            .from('thong_bao')
            .update({'is_read': 1})
            .eq('user_id', userId);
      } catch (_) {}
    }
    await db.update(
      'thong_bao',
      {'is_read': 1},
      where: 'user_id = ? OR user_id = ?',
      whereArgs: [userId, ''],
    );
  }

  static Future<void> createAnnouncement(Database db, Announcement item) async {
    if (_isSupabaseReady) {
      try {
        await Supabase.instance.client
            .from('thong_bao_chung')
            .insert(item.toMap());
        return;
      } catch (_) {}
    }
    await db.insert('thong_bao_chung', item.toMap());
  }

  static Future<void> deleteAnnouncement(Database db, int id) async {
    if (_isSupabaseReady) {
      try {
        await Supabase.instance.client
            .from('thong_bao_chung')
            .delete()
            .eq('id', id);
      } catch (_) {}
    }
    await db.delete('thong_bao_chung', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Announcement>> getAnnouncements(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('thong_bao_chung')
            .select()
            .order('pinned', ascending: false)
            .order('created_at', ascending: false);
        return (res as List)
            .map((r) => Announcement.fromMap(r as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    final rows = await db.query(
      'thong_bao_chung',
      orderBy: 'pinned DESC, created_at DESC',
    );
    return rows.map(Announcement.fromMap).toList();
  }

  static Future<List<ReportItem>> getReports(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('bao_cao')
            .select()
            .order('created_at', ascending: false);
        return (res as List)
            .map((r) => ReportItem.fromMap(r as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    final rows = await db.query('bao_cao', orderBy: 'created_at DESC');
    return rows.map(ReportItem.fromMap).toList();
  }

  static Future<int> createReport(Database db, ReportItem report) async {
    if (_isSupabaseReady) {
      try {
        final row = await Supabase.instance.client
            .from('bao_cao')
            .insert(report.toMap()..remove('id'))
            .select('id')
            .single();
        return row['id'] as int;
      } catch (_) {}
    }
    return db.insert('bao_cao', report.toMap());
  }

  static Future<void> updateReport(Database db, ReportItem report) async {
    if (report.id == null) return;
    if (_isSupabaseReady) {
      try {
        await Supabase.instance.client
            .from('bao_cao')
            .update({
              'status': report.status,
              'handled_by': report.handledBy,
              'resolution_note': report.resolutionNote,
            })
            .eq('id', report.id!);
      } catch (_) {}
    }
    await db.update(
      'bao_cao',
      {
        'status': report.status,
        'handled_by': report.handledBy,
        'resolution_note': report.resolutionNote,
      },
      where: 'id = ?',
      whereArgs: [report.id],
    );
  }

  static Future<int> countReportsForTarget(
    Database db, {
    required String targetType,
    required int targetId,
  }) async {
    if (_isSupabaseReady) {
      try {
        final rows = await Supabase.instance.client
            .from('bao_cao')
            .select('id')
            .eq('target_type', targetType)
            .eq('target_id', targetId);
        return (rows as List).length;
      } catch (_) {}
    }
    return Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM bao_cao WHERE target_type = ? AND target_id = ?',
            [targetType, targetId],
          ),
        ) ??
        0;
  }

  static Future<void> hideComment(Database db, int commentId) async {
    if (_isSupabaseReady) {
      try {
        await Supabase.instance.client
            .from('binh_luan')
            .update({'is_hidden': 1})
            .eq('id', commentId);
      } catch (_) {}
    }
    await db.update(
      'binh_luan',
      {'is_hidden': 1},
      where: 'id = ?',
      whereArgs: [commentId],
    );
  }

  static Future<List<AuditLog>> getAuditLogs(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('nhat_ky_quan_tri')
            .select()
            .order('created_at', ascending: false);
        return (res as List)
            .map((r) => AuditLog.fromMap(r as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    final rows = await db.query('nhat_ky_quan_tri', orderBy: 'created_at DESC');
    return rows.map(AuditLog.fromMap).toList();
  }

  static Future<Map<String, dynamic>?> getAdminDashboardMetrics(
    int rangeDays,
  ) async {
    if (!_isSupabaseReady) return null;
    try {
      final result = await Supabase.instance.client.rpc(
        'admin_dashboard_metrics',
        params: {'p_days': rangeDays},
      );
      if (result is Map<String, dynamic>) return result;
      if (result is Map) return Map<String, dynamic>.from(result);
    } catch (_) {}
    return null;
  }

  static Future<List<Map<String, dynamic>>?> getAdminNovelChapterReaders(
    int novelId,
  ) async {
    if (!_isSupabaseReady) return null;
    try {
      final result = await Supabase.instance.client.rpc(
        'admin_novel_chapter_readers',
        params: {'p_novel_id': novelId},
      );
      if (result is! List) return null;
      return result
          .whereType<Map>()
          .map((row) => Map<String, dynamic>.from(row))
          .toList();
    } catch (_) {
      return null;
    }
  }

  static Future<void> writeAuditLog(
    Database db, {
    required AppUser admin,
    required String action,
    required String target,
    required String detail,
  }) async {
    if (_isSupabaseReady) {
      try {
        final log = AuditLog(
          adminId: admin.id,
          adminName: admin.displayName,
          action: action,
          target: target,
          detail: detail,
          createdAt: DateTime.now(),
        );
        await Supabase.instance.client
            .from('nhat_ky_quan_tri')
            .insert(log.toMap());
        return;
      } catch (_) {}
    }
    final log = AuditLog(
      adminId: admin.id,
      adminName: admin.displayName,
      action: action,
      target: target,
      detail: detail,
      createdAt: DateTime.now(),
    );
    await db.insert('nhat_ky_quan_tri', log.toMap());
  }

  static Future<Map<String, String>> getAppConfig(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('cau_hinh_ung_dung')
            .select();
        return {
          for (final r in (res as List))
            (r['key'] as String? ?? ''): (r['value'] as String? ?? ''),
        };
      } catch (_) {}
    }
    final rows = await db.query('cau_hinh_ung_dung');
    return {
      for (final r in rows)
        (r['key'] as String? ?? ''): (r['value'] as String? ?? ''),
    };
  }

  static Future<void> setConfigValue(
    Database db,
    String key,
    String value,
  ) async {
    if (_isSupabaseReady) {
      try {
        await Supabase.instance.client.from('cau_hinh_ung_dung').upsert({
          'key': key,
          'value': value,
        });
        return;
      } catch (_) {}
    }
    await db.insert('cau_hinh_ung_dung', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> addBannedWord(Database db, String word) async {
    if (_isSupabaseReady) {
      try {
        await Supabase.instance.client
            .from('tu_cam')
            .upsert({'word': word}, onConflict: 'word', ignoreDuplicates: true);
      } catch (_) {}
    }
    await db.insert('tu_cam', {
      'word': word,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<void> removeBannedWord(Database db, String word) async {
    if (_isSupabaseReady) {
      try {
        await Supabase.instance.client.from('tu_cam').delete().eq('word', word);
      } catch (_) {}
    }
    await db.delete('tu_cam', where: 'word = ?', whereArgs: [word]);
  }

  static Future<int> createQuest(Database db, Quest quest) async {
    final row = quest.toMap()..remove('id');
    if (_isSupabaseReady) {
      try {
        final inserted = await Supabase.instance.client
            .from('nhiem_vu')
            .insert(row)
            .select('id')
            .single();
        final id = inserted['id'] as int;
        await db.insert('nhiem_vu', {
          'id': id,
          ...row,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
        return id;
      } catch (_) {}
    }
    return db.insert('nhiem_vu', row);
  }

  static Future<List<NovelRequestItem>> getNovelRequests(Database db) async {
    if (_isSupabaseReady) {
      try {
        final rows = await Supabase.instance.client
            .from('yeu_cau_truyen')
            .select()
            .order('votes', ascending: false)
            .order('created_at', ascending: false);
        return (rows as List)
            .map((row) => NovelRequestItem.fromMap(row as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    final rows = await db.query(
      'yeu_cau_truyen',
      orderBy: 'votes DESC, created_at DESC',
    );
    return rows.map(NovelRequestItem.fromMap).toList();
  }

  static Future<void> _ensureLocalRequestVotes(Database db) => db.execute('''
    CREATE TABLE IF NOT EXISTS yeu_cau_binh_chon (
      request_id INTEGER NOT NULL,
      user_id TEXT NOT NULL,
      created_at INTEGER NOT NULL,
      PRIMARY KEY (request_id, user_id)
    )
  ''');

  static Future<int> submitNovelRequest(
    Database db,
    NovelRequestItem request,
  ) async {
    if (_isSupabaseReady) {
      try {
        final map = request.toMap()..remove('id');
        map['votes'] = 0;
        final row = await Supabase.instance.client
            .from('yeu_cau_truyen')
            .insert(map)
            .select('id')
            .single();
        final id = row['id'] as int;
        var firstVoteRecorded = false;
        try {
          await Supabase.instance.client.from('yeu_cau_binh_chon').insert({
            'request_id': id,
            'user_id': request.userId,
            'created_at': request.createdAt.millisecondsSinceEpoch,
          });
          firstVoteRecorded = true;
        } catch (_) {}
        await db.insert('yeu_cau_truyen', {
          'id': id,
          ...map,
          'votes': firstVoteRecorded ? 1 : 0,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
        await _ensureLocalRequestVotes(db);
        if (firstVoteRecorded) {
          await db.insert('yeu_cau_binh_chon', {
            'request_id': id,
            'user_id': request.userId,
            'created_at': request.createdAt.millisecondsSinceEpoch,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
        return id;
      } catch (_) {}
    }
    final id = await db.insert('yeu_cau_truyen', request.toMap());
    await _ensureLocalRequestVotes(db);
    await db.insert('yeu_cau_binh_chon', {
      'request_id': id,
      'user_id': request.userId,
      'created_at': request.createdAt.millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    return id;
  }

  static Future<bool> voteNovelRequest(
    Database db, {
    required int requestId,
    required String userId,
  }) async {
    if (_isSupabaseReady) {
      try {
        await Supabase.instance.client.from('yeu_cau_binh_chon').insert({
          'request_id': requestId,
          'user_id': userId,
          'created_at': DateTime.now().millisecondsSinceEpoch,
        });
        return true;
      } catch (_) {
        return false;
      }
    }
    await _ensureLocalRequestVotes(db);
    try {
      await db.insert('yeu_cau_binh_chon', {
        'request_id': requestId,
        'user_id': userId,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
      await db.rawUpdate(
        'UPDATE yeu_cau_truyen SET votes = votes + 1 WHERE id = ?',
        [requestId],
      );
      return true;
    } on DatabaseException {
      return false;
    }
  }

  static Future<List<String>> getBannedWords(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('tu_cam')
            .select()
            .order('word', ascending: true);
        return (res as List).map((r) => (r['word'] as String?) ?? '').toList();
      } catch (_) {}
    }
    final rows = await db.query('tu_cam', orderBy: 'word ASC');
    return rows.map((r) => (r['word'] as String?) ?? '').toList();
  }

  static Future<List<ReadingSession>> getSessionLogs(Database db) async {
    final rows = await db.query(
      'nhat_ky_phien_doc',
      orderBy: 'started_at DESC',
      limit: 500,
    );
    return rows.map(ReadingSession.fromMap).toList();
  }
}
