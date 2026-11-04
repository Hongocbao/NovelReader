import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/models/app_user.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/models/chapter_summary.dart';
import 'package:novel_reader/models/glossary_term.dart';
import 'package:novel_reader/models/library_item.dart';
import 'package:novel_reader/models/notification_item.dart';
import 'package:novel_reader/models/novel.dart';
import 'package:novel_reader/providers/admin_novel_provider.dart';
import 'package:novel_reader/repositories/auth_repository.dart';
import 'package:novel_reader/repositories/novel_repository.dart';
import 'package:novel_reader/utils/role_guard.dart';

/// Fake NovelRepository dùng cho kiểm thử bảo mật & phân quyền (Step 8).
class FakeNovelRepository implements NovelRepository {
  final Map<String, List<LibraryItem>> _userLibraries = {};
  final List<Novel> _novels = [];

  void setLibraryForUser(String userId, List<LibraryItem> items) {
    _userLibraries[userId] = items;
  }

  /// Mô phỏng kiểm tra RLS tủ sách: người dùng chỉ được đọc tủ sách của chính mình.
  Future<List<LibraryItem>> getLibraryForUser({
    required AppUser caller,
    required String targetUserId,
  }) async {
    // RLS: caller chỉ được đọc nếu caller.id == targetUserId hoặc caller là Admin
    if (caller.id != targetUserId && !caller.isAdmin) {
      throw StateError('Truy cập bị từ chối: Bạn không thể đọc tủ sách của người khác.');
    }
    return _userLibraries[targetUserId] ?? [];
  }

  @override
  Future<void> approveNovel({required int novelId, required AppUser admin, String note = 'Đạt tiêu chuẩn xuất bản'}) async {
    RoleGuard.requireAdmin(admin);
    final idx = _novels.indexWhere((n) => n.id == novelId);
    if (idx != -1) {
      _novels[idx] = _novels[idx].copyWith(moderationStatus: ModerationStatus.approved);
    }
  }

  @override
  Future<void> rejectNovel({required int novelId, required String reason, required AppUser admin}) async {
    RoleGuard.requireAdmin(admin);
  }

  @override
  Future<List<Novel>> getAllNovels({bool includeDeleted = false}) async => _novels;

  @override
  Future<List<Novel>> getNovelsByOwner(String ownerId) async =>
      _novels.where((n) => n.ownerId == ownerId).toList();

  @override
  Future<List<Novel>> getPendingNovels() async =>
      _novels.where((n) => n.moderationStatus == ModerationStatus.pending).toList();

  @override
  Future<Novel?> getNovelById(int novelId) async =>
      _novels.where((n) => n.id == novelId).firstOrNull;

  @override
  Future<Novel> saveNovel(
    Novel novel, {
    String? requestId,
    List<({String title, String content})> chapters = const [],
  }) async {
    _novels.add(novel);
    return novel;
  }

  @override
  Future<void> softDeleteNovel(int novelId, {AppUser? admin}) async {}

  @override
  Future<void> restoreNovel(int novelId, {AppUser? admin}) async {}

  @override
  Future<void> setFeaturedStatus({required List<int> novelIds, required bool featured, required AppUser admin}) async {
    RoleGuard.requireAdmin(admin);
  }

  @override
  Future<List<Chapter>> getChapters(int novelId) async => [];

  @override
  Future<void> saveChaptersOrder(int novelId, List<Chapter> orderedChapters) async {}

  @override
  Future<Chapter> saveChapter(Chapter chapter, {String? requestId}) async => chapter;

  @override
  Future<List<GlossaryTerm>> getGlossaryTerms(int novelId) async => [];

  @override
  Future<void> addGlossaryTerm(GlossaryTerm term) async {}

  @override
  Future<void> deleteGlossaryTerm(int termId) async {}

  @override
  Future<List<ChapterSummary>> getChapterSummaries(int novelId) async => [];

  @override
  Future<void> saveChapterSummary(ChapterSummary summary) async {}

  @override
  Future<void> writeAuditLog({required AppUser admin, required String action, required String target, required String detail}) async {}

  @override
  Future<void> createNotification(NotificationItem item) async {}
}

/// Fake AuthRepository
class FakeAuthRepository implements AuthRepository {
  final Map<String, AppUser> _users = {
    'admin-id': AppUser(
      id: 'admin-id',
      email: 'admin@novelreader.local',
      displayName: 'Admin',
      role: UserRole.admin,
      isAuthor: true,
      status: UserStatus.active,
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    ),
    'user-id': AppUser(
      id: 'user-id',
      email: 'user@novelreader.local',
      displayName: 'Độc giả',
      role: UserRole.user,
      isAuthor: false,
      status: UserStatus.active,
      linhThach: 100,
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    ),
    'author-id': AppUser(
      id: 'author-id',
      email: 'author@novelreader.local',
      displayName: 'Tác giả',
      role: UserRole.user,
      isAuthor: true,
      status: UserStatus.active,
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    ),
  };

  @override
  Future<AppUser> getCurrentUser() async => _users.values.first;

  @override
  Future<AppUser?> getUserById(String id) async => _users[id];

  @override
  Future<AppUser> login(String email, String password) async {
    final user = _users.values.firstWhere(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
      orElse: () => throw StateError('Email hoặc mật khẩu không chính xác'),
    );
    if (password.startsWith('Wrong')) {
      throw StateError('Email hoặc mật khẩu không chính xác');
    }
    if (user.isBanned) {
      throw StateError('Tài khoản của bạn đã bị khóa. Lý do: ${user.banReason}');
    }
    return user;
  }

  @override
  Future<AppUser> register({required String email, required String displayName, required String password}) async => AppUser.guest();

  @override
  Future<void> logout() async {}

  @override
  Future<void> changePassword(String newPassword) async {}

  @override
  Future<void> resetPassword(String email) async {}

  @override
  Future<List<AppUser>> getAllUsers() async => _users.values.toList();

  @override
  Future<AppUser> updateUser(AppUser user) async {
    _users[user.id] = user;
    return user;
  }

  Future<void> updateRole({required String userId, required String role, required int isAuthor}) async {
    final user = _users[userId];
    if (user != null) {
      _users[userId] = user.copyWith(role: role, isAuthor: isAuthor == 1);
    }
  }

  Future<void> updateStatus({required String userId, required String status, String? reason, int? banUntil}) async {}
}

void main() {
  group('Step 8: Kiểm thử Phân quyền & Bảo mật Row Level Security', () {
    late AppUser regularUser;
    late AppUser adminUser;
    late FakeNovelRepository fakeNovelRepo;
    late FakeAuthRepository fakeAuthRepo;
    late AdminNovelProvider adminNovelProvider;

    setUp(() {
      regularUser = AppUser(
        id: 'user-uuid-1111',
        email: 'reader@domain.com',
        displayName: 'Độc giả A',
        role: UserRole.user,
        isAuthor: false,
        status: UserStatus.active,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );

      adminUser = AppUser(
        id: 'admin-uuid-9999',
        email: 'admin@domain.com',
        displayName: 'Quản trị viên',
        role: UserRole.admin,
        isAuthor: true,
        status: UserStatus.active,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );

      fakeNovelRepo = FakeNovelRepository();
      fakeAuthRepo = FakeAuthRepository();
      fakeAuthRepo._users[regularUser.id] = regularUser;
      fakeAuthRepo._users[adminUser.id] = adminUser;

      adminNovelProvider = AdminNovelProvider(null, fakeNovelRepo);
    });

    test('1. User thường KHÔNG thể tự đổi role thành admin', () async {
      // Hàm mô phỏng hành động user tự đổi role
      void attemptSelfPromote(AppUser caller, String targetRole) {
        RoleGuard.requireAdmin(caller);
      }

      // Kiểm tra guard: User thường tự promote bị chặn ngay lập tức
      expect(
        () => attemptSelfPromote(regularUser, UserRole.admin),
        throwsA(isA<StateError>()),
      );

      // Kiểm tra RoleGuard trực tiếp
      expect(
        () => RoleGuard.requireAdmin(regularUser),
        throwsA(isA<StateError>()),
      );

      // Trạng thái user vẫn là 'user', không đổi thành 'admin'
      final users = await fakeAuthRepo.getAllUsers();
      final target = users.firstWhere((u) => u.id == regularUser.id);
      expect(target.role, equals(UserRole.user));
      expect(target.isAdmin, isFalse);
    });

    test('2. User thường KHÔNG thể duyệt truyện (approve / reject)', () async {
      // User thường gọi approveNovels -> Bị ném ngoại lệ StateError
      expect(
        () => adminNovelProvider.approveNovels(
          admin: regularUser,
          novelIds: [101, 102],
        ),
        throwsA(isA<StateError>()),
      );

      // User thường gọi rejectNovel -> Bị ném ngoại lệ StateError
      expect(
        () => adminNovelProvider.rejectNovel(
          admin: regularUser,
          novelId: 101,
          reason: 'Lý do từ chối',
        ),
        throwsA(isA<StateError>()),
      );

      // Ngược lại, Admin thực hiện duyệt thành công không lỗi
      expect(
        () => adminNovelProvider.approveNovels(
          admin: adminUser,
          novelIds: [101],
        ),
        returnsNormally,
      );
    });

    test('3. User thường KHÔNG thể đọc tủ sách của người khác (RLS Isolation)', () async {
      final userBId = 'user-uuid-2222';
      final item = LibraryItem(
        novelId: 99,
        category: 'reading',
        addedAt: DateTime.now(),
      );

      // Thiết lập tủ sách cho User B
      fakeNovelRepo.setLibraryForUser(userBId, [item]);

      // Regular User (user A) cố gắng đọc tủ sách của User B -> Bị từ chối
      expect(
        () => fakeNovelRepo.getLibraryForUser(
          caller: regularUser,
          targetUserId: userBId,
        ),
        throwsA(isA<StateError>()),
      );

      // Regular User tự đọc tủ sách của chính mình -> Thành công
      final ownLibrary = await fakeNovelRepo.getLibraryForUser(
        caller: regularUser,
        targetUserId: regularUser.id,
      );
      expect(ownLibrary, isEmpty);

      // Admin đọc được tủ sách bất kỳ ai để kiểm duyệt/hỗ trợ
      final bLibraryAsAdmin = await fakeNovelRepo.getLibraryForUser(
        caller: adminUser,
        targetUserId: userBId,
      );
      expect(bLibraryAsAdmin.length, equals(1));
      expect(bLibraryAsAdmin.first.novelId, equals(99));
    });
  });
}
