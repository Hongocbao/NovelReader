import 'package:sqflite/sqflite.dart';

import '../models/achievement.dart';
import '../models/app_user.dart';
import '../models/chapter_summary.dart';
import '../models/glossary_term.dart';
import '../models/quest.dart';
import '../utils/password_hasher.dart';

/// Dữ liệu khởi tạo (Seed) cho NovelReader v2:
/// Tài khoản Admin/Author/User mẫu, 20 Huy hiệu, Nhiệm vụ, Thuật ngữ, Tóm tắt chương & Cấu hình.
class V2SeedData {
  V2SeedData._();

  /// Danh sách 20 huy hiệu thành tựu theo đặc tả mục 5.2.
  static const List<Achievement> defaultAchievements = [
    Achievement(
      code: 'khoi_dau',
      name: 'Khởi Đầu Hành Trình',
      description: 'Hoàn thành chương truyện đầu tiên.',
      icon: '🌱',
      ruleJson: '{"type":"chapters","count":1}',
    ),
    Achievement(
      code: 'cu_dem',
      name: 'Cú Đêm',
      description: 'Đọc truyện sau 0 giờ đêm đủ 5 lần.',
      icon: '🦉',
      ruleJson: '{"type":"night_reads","count":5}',
    ),
    Achievement(
      code: 'mot_sach',
      name: 'Mọt Sách Chính Hiệu',
      description: 'Đọc tổng cộng 100 chương truyện.',
      icon: '📚',
      ruleJson: '{"type":"chapters","count":100}',
    ),
    Achievement(
      code: 'chung_thuy',
      name: 'Độc Giả Chung Thủy',
      description: 'Hoàn thành một bộ truyện dài từ 5 chương trở lên.',
      icon: '💎',
      ruleJson: '{"type":"finish_long_novel","count":1}',
    ),
    Achievement(
      code: 'tham_tu',
      name: 'Thám Tử Lừng Danh',
      description: 'Đọc hết 3 bộ truyện thuộc thể loại Trinh thám.',
      icon: '🕵️',
      ruleJson: '{"type":"genre","genre":"Trinh thám","count":3}',
    ),
    Achievement(
      code: 'lu_khach',
      name: 'Lữ Khách Đa Vũ Trụ',
      description: 'Khám phá đủ 6 thể loại truyện khác nhau.',
      icon: '🧭',
      ruleJson: '{"type":"distinct_genres","count":6}',
    ),
    Achievement(
      code: 'kien_tri_7',
      name: 'Chuỗi Lửa 7 Ngày',
      description: 'Duy trì chuỗi đọc liên tiếp (Streak) 7 ngày.',
      icon: '🔥',
      ruleJson: '{"type":"streak","count":7}',
    ),
    Achievement(
      code: 'kien_tri_30',
      name: 'Bậc Thầy Kỷ Luật',
      description: 'Duy trì chuỗi đọc liên tiếp (Streak) 30 ngày.',
      icon: '👑',
      ruleJson: '{"type":"streak","count":30}',
    ),
    Achievement(
      code: 'nha_phe_binh',
      name: 'Nhà Phê Bình Sắc Sảo',
      description: 'Đăng 5 bình luận chia sẻ cảm nghĩ dưới chương truyện.',
      icon: '✍️',
      ruleJson: '{"type":"comments","count":5}',
    ),
    Achievement(
      code: 'suu_tam_trich_dan',
      name: 'Người Lưu Giữ Ký Ức',
      description: 'Lưu 5 thẻ trích dẫn (Quote Card) tâm đắc.',
      icon: '🔖',
      ruleJson: '{"type":"quotes","count":5}',
    ),
    Achievement(
      code: 'toc_do_anh_sang',
      name: 'Tốc Độ Ánh Sáng',
      description: 'Trải nghiệm chế độ đọc nhanh RSVP từ 300 từ/phút.',
      icon: '⚡',
      ruleJson: '{"type":"rsvp","count":1}',
    ),
    Achievement(
      code: 'thin_hinh_am_thanh',
      name: 'Thính Giả Đêm Khuya',
      description: 'Sử dụng TTS hoặc Ambient Mixer khi đọc truyện.',
      icon: '🎧',
      ruleJson: '{"type":"audio","count":1}',
    ),
    Achievement(
      code: 'kham_pha_xray',
      name: 'Nhà Khảo Cổ X-Ray',
      description: 'Ghim nhân vật yêu thích vào Sổ tay nhân vật.',
      icon: '🔍',
      ruleJson: '{"type":"xray_pin","count":1}',
    ),
    Achievement(
      code: 'cay_but_tre',
      name: 'Cây Bút Trẻ',
      description: 'Sáng tác và gửi duyệt tác phẩm đầu tay.',
      icon: '🪶',
      ruleJson: '{"type":"author_submit","count":1}',
    ),
    Achievement(
      code: 'dai_gia_linh_thach',
      name: 'Phú Gia Linh Thạch',
      description: 'Tích lũy đạt mốc 500 Linh Thạch.',
      icon: '💠',
      ruleJson: '{"type":"linh_thach","count":500}',
    ),
    Achievement(
      code: 'nguoi_gac_dem',
      name: 'Người Gác Đền Tri Thức',
      description: 'Đọc tổng cộng hơn 10.000 từ.',
      icon: '🏛️',
      ruleJson: '{"type":"words","count":10000}',
    ),
    Achievement(
      code: 'doc_gia_toan_nang',
      name: 'Độc Giả Toàn Năng',
      description: 'Đọc cả 3 loại: Truyện chữ, Light Novel và Truyện tranh.',
      icon: '🌟',
      ruleJson: '{"type":"all_types","count":3}',
    ),
    Achievement(
      code: 'nguoi_gui_thoi_gian',
      name: 'Lữ Khách Thời Gian',
      description: 'Gửi một bức thư vào Hộp thư thời gian (Time Capsule).',
      icon: '⏳',
      ruleJson: '{"type":"time_capsule","count":1}',
    ),
    Achievement(
      code: 'truyen_tranh_fan',
      name: 'Tín Đồ Manga & Webtoon',
      description: 'Đọc 5 chương truyện tranh.',
      icon: '🎨',
      ruleJson: '{"type":"comic_chapters","count":5}',
    ),
    Achievement(
      code: 'light_novel_fan',
      name: 'Hiệp Sĩ Light Novel',
      description: 'Đọc 5 chương Light Novel có minh họa.',
      icon: '⚔️',
      ruleJson: '{"type":"ln_chapters","count":5}',
    ),
  ];

  /// Khởi tạo dữ liệu mẫu v2 nếu bảng `users` đang trống.
  static Future<void> seedIfNeeded(Database db) async {
    final userCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM users'),
        ) ??
        0;
    if (userCount == 0) {
      await _seedUsers(db);
    }

    final achCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM achievements'),
        ) ??
        0;
    if (achCount == 0) {
      for (final a in defaultAchievements) {
        await db.insert(
          'achievements',
          a.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }

    final questCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM quests'),
        ) ??
        0;
    if (questCount == 0) {
      await _seedQuests(db);
    }

    final glossaryCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM glossary_terms'),
        ) ??
        0;
    if (glossaryCount == 0) {
      await _seedGlossaryAndSummaries(db);
    }

    final configCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM app_config'),
        ) ??
        0;
    if (configCount == 0) {
      await _seedConfigAndModeration(db);
    }
  }

  static Future<void> _seedUsers(Database db) async {
    final now = DateTime.now();

    // 1. Tài khoản Admin mặc định: admin@novelreader.local (mật khẩu khởi tạo: Admin@123)
    final adminSalt = PasswordHasher.generateSalt();
    final adminAnswerHash = PasswordHasher.hashPassword('tien hiep', adminSalt);
    final admin = AppUser(
      id: 1,
      email: 'admin@novelreader.local',
      passwordHash: PasswordHasher.hashPassword('Admin@123', adminSalt),
      salt: adminSalt,
      displayName: 'Quản Trị Viên Tối Cao',
      avatar: '👑',
      avatarFrame: 'gold',
      role: UserRole.admin,
      isAuthor: true,
      linhThach: 9999,
      streak: 15,
      hasStreakShield: true,
      pinnedAchievements: const ['mot_sach', 'kien_tri_30', 'doc_gia_toan_nang'],
      unlockedItems: const ['default', 'gold', 'jade', 'neon', 'sepia_pro'],
      secretQuestion: 'Thể loại truyện yêu thích của bạn là gì?',
      secretAnswerHash: adminAnswerHash,
      mustChangePassword: true,
      lastActiveAt: now,
      createdAt: now.subtract(const Duration(days: 60)),
    );

    // 2. Tài khoản Tác giả mẫu: author@novelreader.local (mật khẩu: Author@123)
    final authorSalt = PasswordHasher.generateSalt();
    final author = AppUser(
      id: 2,
      email: 'author@novelreader.local',
      passwordHash: PasswordHasher.hashPassword('Author@123', authorSalt),
      salt: authorSalt,
      displayName: 'Bút Mặc Tiên Sinh',
      avatar: '🪶',
      avatarFrame: 'jade',
      role: UserRole.user,
      isAuthor: true,
      linhThach: 450,
      streak: 7,
      pinnedAchievements: const ['cay_but_tre', 'khoi_dau'],
      unlockedItems: const ['default', 'jade'],
      secretQuestion: 'Thể loại truyện yêu thích của bạn là gì?',
      secretAnswerHash: PasswordHasher.hashPassword('fantasy', authorSalt),
      mustChangePassword: false,
      lastActiveAt: now,
      createdAt: now.subtract(const Duration(days: 30)),
    );

    // 3. Tài khoản Độc giả mẫu: user@novelreader.local (mật khẩu: User@1234)
    final userSalt = PasswordHasher.generateSalt();
    final reader = AppUser(
      id: 3,
      email: 'user@novelreader.local',
      passwordHash: PasswordHasher.hashPassword('User@1234', userSalt),
      salt: userSalt,
      displayName: 'Bảo Ngọc Độc Giả',
      avatar: '🦊',
      avatarFrame: 'default',
      role: UserRole.user,
      isAuthor: false,
      linhThach: 220,
      streak: 5,
      pinnedAchievements: const ['khoi_dau', 'lu_khach'],
      unlockedItems: const ['default'],
      secretQuestion: 'Thể loại truyện yêu thích của bạn là gì?',
      secretAnswerHash: PasswordHasher.hashPassword('isekai', userSalt),
      mustChangePassword: false,
      lastActiveAt: now,
      createdAt: now.subtract(const Duration(days: 14)),
    );

    await db.insert('users', admin.toMap());
    await db.insert('users', author.toMap());
    await db.insert('users', reader.toMap());

    // Mở khóa sẵn một số huy hiệu mẫu
    for (final code in ['khoi_dau', 'lu_khach']) {
      await db.insert('user_achievements', {
        'user_id': 3,
        'code': code,
        'unlocked_at': now.millisecondsSinceEpoch,
      });
    }
  }

  static Future<void> _seedQuests(Database db) async {
    final now = DateTime.now();
    final endYear = now.add(const Duration(days: 365));
    final quests = [
      Quest(
        id: 1,
        type: 'daily',
        title: 'Đọc truyện 15 phút mỗi ngày',
        goalType: 'read_minutes',
        goalValue: 15,
        reward: 25,
        startsAt: now.subtract(const Duration(days: 1)),
        endsAt: endYear,
      ),
      Quest(
        id: 2,
        type: 'daily',
        title: 'Hoàn thành 2 chương truyện bất kỳ',
        goalType: 'read_chapters',
        goalValue: 2,
        reward: 30,
        startsAt: now.subtract(const Duration(days: 1)),
        endsAt: endYear,
      ),
      Quest(
        id: 3,
        type: 'daily',
        title: 'Chia sẻ 1 bình luận cảm nhận chương',
        goalType: 'comment',
        goalValue: 1,
        reward: 20,
        startsAt: now.subtract(const Duration(days: 1)),
        endsAt: endYear,
      ),
      Quest(
        id: 4,
        type: 'weekly',
        title: 'Đọc đủ 60 phút trong tuần',
        goalType: 'read_minutes',
        goalValue: 60,
        reward: 100,
        startsAt: now.subtract(const Duration(days: 3)),
        endsAt: endYear,
      ),
      Quest(
        id: 5,
        type: 'weekly',
        title: 'Hoàn thành trọn vẹn 1 bộ truyện',
        goalType: 'finish_novel',
        goalValue: 1,
        reward: 150,
        startsAt: now.subtract(const Duration(days: 3)),
        endsAt: endYear,
      ),
      Quest(
        id: 6,
        type: 'event',
        title: 'Sự kiện Tuần Lễ Trinh Thám & Kỳ Ảo: Đọc 3 chương',
        goalType: 'read_chapters',
        goalValue: 3,
        reward: 120,
        startsAt: now.subtract(const Duration(days: 2)),
        endsAt: now.add(const Duration(days: 30)),
      ),
    ];
    for (final q in quests) {
      await db.insert('quests', q.toMap());
    }
  }

  static Future<void> _seedGlossaryAndSummaries(Database db) async {
    final terms = [
      const GlossaryTerm(
        novelId: 1,
        term: 'Linh khí',
        meaning:
            'Năng lượng tinh thuần của trời đất mà tu sĩ hấp thu để rèn luyện kinh mạch và đột phá cảnh giới.',
        firstChapterIndex: 1,
      ),
      const GlossaryTerm(
        novelId: 1,
        term: 'Trúc Cơ',
        meaning:
            'Cảnh giới thứ hai trên con đường tu tiên, đặt nền móng vững chắc cho đạo cơ trước khi kết Kim Đan.',
        firstChapterIndex: 1,
      ),
      const GlossaryTerm(
        novelId: 1,
        term: 'Kim Đan',
        meaning:
            'Cảnh giới đại năng khi linh lực ngưng tụ thành viên đan vàng rực trong đan điền, thọ nguyên tăng vọt.',
        firstChapterIndex: 2,
      ),
      const GlossaryTerm(
        novelId: 2,
        term: 'Ma pháp trận',
        meaning:
            'Vòng tròn cổ ngữ khắc họa dòng chảy mana để triệu hồi hoặc kích hoạt phép thuật cấp cao.',
        firstChapterIndex: 1,
      ),
      const GlossaryTerm(
        novelId: 3,
        term: 'Hồ sơ mật',
        meaning:
            'Tập tài liệu điều tra chưa từng công bố của thanh tra về chuỗi án mạng liên hoàn.',
        firstChapterIndex: 1,
      ),
    ];
    for (final t in terms) {
      await db.insert('glossary_terms', t.toMap());
    }

    final summaries = [
      const ChapterSummary(
        chapterId: 10001,
        novelId: 1,
        chapterIndex: 1,
        summary:
            'Nhân vật chính tình cờ phát hiện cổ vật ẩn chứa truyền thừa tu tiên giữa đêm mưa bão.',
      ),
      const ChapterSummary(
        chapterId: 10002,
        novelId: 1,
        chapterIndex: 2,
        summary:
            'Bước đầu cảm ứng linh khí, vượt qua khảo nghiệm nhập môn và đối mặt kẻ thù đầu tiên.',
      ),
      const ChapterSummary(
        chapterId: 20001,
        novelId: 2,
        chapterIndex: 1,
        summary:
            'Chuyển sinh sang thế giới kiếm và ma thuật, thức tỉnh kỹ năng thẩm định hiếm có.',
      ),
    ];
    for (final s in summaries) {
      await db.insert(
        'chapter_summaries',
        s.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<void> _seedConfigAndModeration(Database db) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final configs = {
      'maintenance_mode': 'false',
      'maintenance_message':
          'Hệ thống đang bảo trì nâng cấp máy chủ định kỳ. Vui lòng quay lại sau ít phút!',
      'feature_tts': 'true',
      'feature_comments': 'true',
      'feature_registration': 'true',
      'max_offline_chapters': '200',
    };
    for (final entry in configs.entries) {
      await db.insert(
        'app_config',
        {'key': entry.key, 'value': entry.value},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    for (final word in ['lừa đảo', 'spam_link', 'cá độ', 'chửi_thề_xấu']) {
      await db.insert(
        'banned_words',
        {'word': word},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    await db.insert('announcements', {
      'title': '🎉 Chào mừng đến với NovelReader v2.0!',
      'body':
          'Phiên bản 2.0 ra mắt hệ thống Nhiệm vụ Linh Thạch, Khiên chống Spoil, Tủ sách 3D, Reading Wrapped và Khu Quản Trị Admin toàn diện.',
      'audience': 'all',
      'pinned': 1,
      'created_by': 1,
      'created_at': now,
    });

    await db.insert('notifications', {
      'user_id': 3,
      'title': '🎁 Quà tân thủ NovelReader v2',
      'body':
          'Bạn đã nhận được 220 Linh Thạch khởi đầu! Hãy ghé Cửa hàng Linh Thạch hoặc hoàn thành Nhiệm vụ ngày nhé.',
      'kind': 'quest_reward',
      'is_read': 0,
      'created_at': now,
    });

    await db.insert('novel_requests', {
      'user_id': 3,
      'user_name': 'Bảo Ngọc Độc Giả',
      'title': 'Phàm Nhân Tu Tiên - Ngoại Truyện',
      'author_hint': 'Vọng Ngữ',
      'description': 'Mong Admin và các dịch giả sớm cập nhật bộ ngoại truyện này!',
      'votes': 12,
      'created_at': now,
    });

    // Đánh dấu 4 truyện đầu là Featured Banner
    for (var i = 1; i <= 4; i++) {
      await db.update(
        'novels',
        {'is_featured': 1, 'featured_order': i},
        where: 'id = ?',
        whereArgs: [i],
      );
    }
  }
}
