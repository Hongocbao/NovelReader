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
      'novels',
      'moderation_status',
      "TEXT NOT NULL DEFAULT 'approved'",
    );
    await _addColumnIfMissing(db, 'novels', 'rejection_reason', 'TEXT');
    await _addColumnIfMissing(
      db,
      'novels',
      'owner_id',
      'INTEGER NOT NULL DEFAULT 1',
    );
    await _addColumnIfMissing(
      db,
      'novels',
      'is_featured',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _addColumnIfMissing(
      db,
      'novels',
      'featured_order',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _addColumnIfMissing(db, 'novels', 'deleted_at', 'INTEGER');

    await _addColumnIfMissing(db, 'chapters', 'publish_at', 'INTEGER');

    await _addColumnIfMissing(
      db,
      'comments',
      'user_id',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _addColumnIfMissing(
      db,
      'comments',
      'chapter_index',
      'INTEGER NOT NULL DEFAULT 1',
    );
    await _addColumnIfMissing(
      db,
      'comments',
      'is_hidden',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _addColumnIfMissing(
      db,
      'comments',
      'likes',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _addColumnIfMissing(db, 'comments', 'parent_id', 'INTEGER');

    // 2. Tạo các bảng mới của phiên bản v2
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
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
      CREATE TABLE IF NOT EXISTS reading_session_logs (
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
      CREATE TABLE IF NOT EXISTS achievements (
        code TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        rule_json TEXT NOT NULL DEFAULT '{}'
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_achievements (
        user_id INTEGER NOT NULL,
        code TEXT NOT NULL,
        unlocked_at INTEGER NOT NULL,
        PRIMARY KEY (user_id, code)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS quests (
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
      CREATE TABLE IF NOT EXISTS user_quests (
        user_id INTEGER NOT NULL,
        quest_id INTEGER NOT NULL,
        progress INTEGER NOT NULL DEFAULT 0,
        claimed INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (user_id, quest_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS reports (
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
      CREATE TABLE IF NOT EXISTS announcements (
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
      CREATE TABLE IF NOT EXISTS notifications (
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
      CREATE TABLE IF NOT EXISTS glossary_terms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        novel_id INTEGER NOT NULL,
        term TEXT NOT NULL,
        meaning TEXT NOT NULL,
        first_chapter_index INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS chapter_summaries (
        chapter_id INTEGER PRIMARY KEY,
        novel_id INTEGER NOT NULL,
        chapter_index INTEGER NOT NULL DEFAULT 1,
        summary TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS paragraph_reactions (
        user_id INTEGER NOT NULL,
        chapter_id INTEGER NOT NULL,
        paragraph_index INTEGER NOT NULL,
        emoji TEXT NOT NULL,
        PRIMARY KEY (user_id, chapter_id, paragraph_index)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS time_capsules (
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
      CREATE TABLE IF NOT EXISTS novel_requests (
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
      CREATE TABLE IF NOT EXISTS character_graphs (
        novel_id INTEGER PRIMARY KEY,
        graph_json TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS banned_words (
        word TEXT PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS audit_logs (
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
      CREATE TABLE IF NOT EXISTS app_config (
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
        final res = await Supabase.instance.client.from('achievements').select();
        return (res as List).map((r) => Achievement.fromMap(r as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final rows = await db.query('achievements');
    return rows.map(Achievement.fromMap).toList();
  }

  static Future<List<UserAchievement>> getUserAchievements(
    Database db,
    String userId,
  ) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('user_achievements')
            .select()
            .eq('user_id', userId)
            .order('unlocked_at', ascending: false);
        return (res as List).map((r) => UserAchievement.fromMap(r as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final rows = await db.query(
      'user_achievements',
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
            .from('user_achievements')
            .select()
            .eq('user_id', userId)
            .eq('code', code)
            .maybeSingle();
        if (existing != null) return false;
        await client.from('user_achievements').insert({
          'user_id': userId,
          'code': code,
          'unlocked_at': DateTime.now().millisecondsSinceEpoch,
        });
        return true;
      } catch (_) {}
    }
    final existing = await db.query(
      'user_achievements',
      where: 'user_id = ? AND code = ?',
      whereArgs: [userId, code],
    );
    if (existing.isNotEmpty) return false;
    await db.insert('user_achievements', {
      'user_id': userId,
      'code': code,
      'unlocked_at': DateTime.now().millisecondsSinceEpoch,
    });
    return true;
  }

  static Future<List<Quest>> getActiveQuests(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('quests')
            .select()
            .eq('is_active', 1)
            .order('id', ascending: true);
        return (res as List).map((r) => Quest.fromMap(r as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final rows = await db.query(
      'quests',
      where: 'is_active = 1',
      orderBy: 'id ASC',
    );
    return rows.map(Quest.fromMap).toList();
  }

  static Future<List<Quest>> getAllQuests(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('quests')
            .select()
            .order('id', ascending: false);
        return (res as List).map((r) => Quest.fromMap(r as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final rows = await db.query('quests', orderBy: 'id DESC');
    return rows.map(Quest.fromMap).toList();
  }

  static Future<Map<int, UserQuest>> getUserQuests(
    Database db,
    String userId,
  ) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('user_quests')
            .select()
            .eq('user_id', userId);
        final list = (res as List).map((r) => UserQuest.fromMap(r as Map<String, dynamic>));
        return {for (final uq in list) uq.questId: uq};
      } catch (_) {}
    }
    final rows = await db.query(
      'user_quests',
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
  }) async {
    if (userId.isEmpty || delta <= 0) return;
    final quests = await getActiveQuests(db);
    for (final q in quests.where((e) => e.goalType == goalType)) {
      final rows = await db.query(
        'user_quests',
        where: 'user_id = ? AND quest_id = ?',
        whereArgs: [userId, q.id],
      );
      if (rows.isEmpty) {
        await db.insert('user_quests', {
          'user_id': userId,
          'quest_id': q.id,
          'progress': delta,
          'claimed': 0,
        });
      } else {
        final current = UserQuest.fromMap(rows.first);
        if (!current.claimed) {
          await db.update(
            'user_quests',
            {'progress': current.progress + delta},
            where: 'user_id = ? AND quest_id = ?',
            whereArgs: [userId, q.id],
          );
        }
      }
    }
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
      'glossary_terms',
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
      'chapter_summaries',
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
    final rows = await db.query(
      'paragraph_reactions',
      where: 'chapter_id = ?',
      whereArgs: [chapterId],
    );
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
    await db.insert(
      'paragraph_reactions',
      reaction.toMap(),
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
            .from('notifications')
            .select()
            .or('user_id.eq.$userId,user_id.eq.')
            .order('created_at', ascending: false);
        return (res as List).map((r) => NotificationItem.fromMap(r as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final rows = await db.query(
      'notifications',
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
    if (_isSupabaseReady) {
      try {
        await Supabase.instance.client.from('notifications').insert(item.toMap());
        return;
      } catch (_) {}
    }
    await db.insert('notifications', item.toMap());
  }

  static Future<List<Announcement>> getAnnouncements(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('announcements')
            .select()
            .order('pinned', ascending: false)
            .order('created_at', ascending: false);
        return (res as List).map((r) => Announcement.fromMap(r as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final rows = await db.query(
      'announcements',
      orderBy: 'pinned DESC, created_at DESC',
    );
    return rows.map(Announcement.fromMap).toList();
  }

  static Future<List<ReportItem>> getReports(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('reports')
            .select()
            .order('created_at', ascending: false);
        return (res as List).map((r) => ReportItem.fromMap(r as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final rows = await db.query('reports', orderBy: 'created_at DESC');
    return rows.map(ReportItem.fromMap).toList();
  }

  static Future<List<AuditLog>> getAuditLogs(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client
            .from('audit_logs')
            .select()
            .order('created_at', ascending: false);
        return (res as List).map((r) => AuditLog.fromMap(r as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final rows = await db.query('audit_logs', orderBy: 'created_at DESC');
    return rows.map(AuditLog.fromMap).toList();
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
        await Supabase.instance.client.from('audit_logs').insert(log.toMap());
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
    await db.insert('audit_logs', log.toMap());
  }

  static Future<Map<String, String>> getAppConfig(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client.from('app_config').select();
        return {
          for (final r in (res as List))
            (r['key'] as String? ?? ''): (r['value'] as String? ?? ''),
        };
      } catch (_) {}
    }
    final rows = await db.query('app_config');
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
        await Supabase.instance.client.from('app_config').upsert({'key': key, 'value': value});
        return;
      } catch (_) {}
    }
    await db.insert(
      'app_config',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<String>> getBannedWords(Database db) async {
    if (_isSupabaseReady) {
      try {
        final res = await Supabase.instance.client.from('banned_words').select().order('word', ascending: true);
        return (res as List).map((r) => (r['word'] as String?) ?? '').toList();
      } catch (_) {}
    }
    final rows = await db.query('banned_words', orderBy: 'word ASC');
    return rows.map((r) => (r['word'] as String?) ?? '').toList();
  }

  static Future<List<ReadingSession>> getSessionLogs(Database db) async {
    final rows = await db.query(
      'reading_session_logs',
      orderBy: 'started_at DESC',
      limit: 500,
    );
    return rows.map(ReadingSession.fromMap).toList();
  }
}
