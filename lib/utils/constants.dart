import 'package:flutter/material.dart';

/// Tên ứng dụng và các hằng số chung.
class AppInfo {
  AppInfo._();

  static const String appName = 'NovelReader';
  static const String dbName = 'novel_reader.db';
  static const int dbVersion = 9;
  static const String sampleDataAsset = 'assets/data/sample_novels.json';

  /// Số truyện mỗi trang khi phân trang (infinite scroll).
  static const int pageSize = 6;

  /// Thời gian debounce khi gõ tìm kiếm.
  static const Duration searchDebounce = Duration(milliseconds: 300);

  /// Số mục tối đa trong lịch sử tìm kiếm.
  static const int maxSearchHistory = 10;
}

/// Tên route điều hướng.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String detail = '/novel';
  static const String reader = '/reader';
  static const String genres = '/genres';
  static const String novelList = '/novels';
  static const String history = '/history';
  static const String downloads = '/downloads';
  static const String settings = '/settings';
}

/// Khóa SharedPreferences.
class PrefKeys {
  PrefKeys._();

  static const String themeMode = 'theme_mode';
  static const String fontSize = 'reader_font_size';
  static const String fontFamily = 'reader_font_family';
  static const String lineHeight = 'reader_line_height';
  static const String textAlign = 'reader_text_align';
  static const String background = 'reader_background';
  static const String brightness = 'reader_brightness';
  static const String keepScreenOn = 'reader_keep_screen_on';
  static const String pageMode = 'reader_page_mode';
  static const String showAiBubble = 'reader_show_ai_bubble';
  static const String geminiApiKey = 'reader_gemini_api_key';
  static const String forceOffline = 'force_offline';
  static const String searchHistory = 'search_history';
  static const String currentUserId = 'current_user_id';
  static const String hasSeenSplashGate = 'has_seen_splash_gate';
}

/// Cấu hình kết nối Supabase Cloud từ biến môi trường.
class SupabaseConfig {
  SupabaseConfig._();

  static const String projectRef = 'lkxqsngzsnbsazarqbgj';

  /// Nhận cả tên biến Flutter và tên NEXT_PUBLIC lấy từ hướng dẫn Supabase.
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: String.fromEnvironment(
      'NEXT_PUBLIC_SUPABASE_URL',
      defaultValue: 'https://lkxqsngzsnbsazarqbgj.supabase.co',
    ),
  );

  /// SUPABASE Flutter client dùng publishable key ở tham số anonKey.
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: String.fromEnvironment(
      'NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY',
      defaultValue: String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: 'sb_publishable_WLEErw5CiknkzNtlGpO4OQ_siS0xBLu',
      ),
    ),
  );

  /// Kiểm tra xem biến môi trường có bị thiếu hay không.
  static bool get isMissing => url.trim().isEmpty || anonKey.trim().isEmpty;
}

/// Giá trị trạng thái / loại truyện / danh mục tủ sách lưu trong DB.
class NovelStatus {
  NovelStatus._();
  static const String ongoing = 'ongoing';
  static const String completed = 'completed';
}

class NovelType {
  NovelType._();
  static const String novel = 'novel';
  static const String lightNovel = 'light_novel';
  static const String comic = 'comic';
}

class LibraryCategory {
  LibraryCategory._();
  static const String reading = 'reading';
  static const String want = 'want';
  static const String finished = 'finished';

  static const List<String> all = [reading, want, finished];
}

/// Danh sách thể loại và icon tương ứng.
class Genres {
  Genres._();

  static const List<String> all = [
    'Tiên hiệp',
    'Kiếm hiệp',
    'Huyền huyễn',
    'Kỳ ảo',
    'Fantasy',
    'Isekai',
    'Hệ thống',
    'Trọng sinh',
    'Xuyên không',
    'Đô thị',
    'Ngôn tình',
    'Cổ đại',
    'Cung đấu',
    'Gia đấu',
    'Điền văn',
    'Trinh thám',
    'Hình sự',
    'Kinh dị',
    'Linh dị',
    'Tâm lý',
    'Khoa huyễn',
    'Mạt thế',
    'Võng du',
    'Thể thao',
    'Học đường',
    'Thanh xuân',
    'Hài hước',
    'Hành động',
    'Phiêu lưu',
    'Lịch sử',
    'Quân sự',
    'Dã sử',
    'Văn học kinh điển',
    'Văn học Việt Nam',
    'Triết học',
    'Kỹ năng sống',
    'Kinh doanh',
    'Chữa lành',
    'Ẩm thực',
    'Thần thoại',
  ];

  static const Map<String, IconData> icons = {
    'Tiên hiệp': Icons.cloud_outlined,
    'Kiếm hiệp': Icons.colorize_outlined,
    'Huyền huyễn': Icons.auto_fix_high_outlined,
    'Kỳ ảo': Icons.blur_on_outlined,
    'Fantasy': Icons.auto_awesome_outlined,
    'Isekai': Icons.public,
    'Hệ thống': Icons.memory_outlined,
    'Trọng sinh': Icons.autorenew_outlined,
    'Xuyên không': Icons.explore_outlined,
    'Đô thị': Icons.location_city,
    'Ngôn tình': Icons.favorite_outline,
    'Cổ đại': Icons.account_balance_outlined,
    'Cung đấu': Icons.workspace_premium_outlined,
    'Gia đấu': Icons.family_restroom_outlined,
    'Điền văn': Icons.grass_outlined,
    'Trinh thám': Icons.search,
    'Hình sự': Icons.gavel_outlined,
    'Kinh dị': Icons.nights_stay_outlined,
    'Linh dị': Icons.visibility_outlined,
    'Tâm lý': Icons.psychology_outlined,
    'Khoa huyễn': Icons.rocket_launch_outlined,
    'Mạt thế': Icons.warning_amber_outlined,
    'Võng du': Icons.sports_esports_outlined,
    'Thể thao': Icons.emoji_events_outlined,
    'Học đường': Icons.school_outlined,
    'Thanh xuân': Icons.wb_sunny_outlined,
    'Hài hước': Icons.sentiment_very_satisfied_outlined,
    'Hành động': Icons.sports_martial_arts,
    'Phiêu lưu': Icons.hiking_outlined,
    'Lịch sử': Icons.history_edu_outlined,
    'Quân sự': Icons.shield_outlined,
    'Dã sử': Icons.castle_outlined,
    'Văn học kinh điển': Icons.menu_book_outlined,
    'Văn học Việt Nam': Icons.local_library_outlined,
    'Triết học': Icons.lightbulb_outline,
    'Kỹ năng sống': Icons.self_improvement_outlined,
    'Kinh doanh': Icons.trending_up_outlined,
    'Chữa lành': Icons.spa_outlined,
    'Ẩm thực': Icons.restaurant_outlined,
    'Thần thoại': Icons.bolt_outlined,
  };

  static IconData iconOf(String genre) => icons[genre] ?? Icons.menu_book;
}

/// Giới hạn và lựa chọn cho cài đặt đọc.
class ReaderLimits {
  ReaderLimits._();

  static const double minFontSize = 14;
  static const double maxFontSize = 28;
  static const double defaultFontSize = 18;
  static const double minLineHeight = 1.2;
  static const double maxLineHeight = 2.2;
  static const double defaultLineHeight = 1.6;
  static const double minBrightness = 0.3;
  static const double maxBrightness = 1.0;

  /// Font dùng font hệ thống (không cần đóng gói file font).
  /// Khóa = tên hiển thị, giá trị = fontFamily ('' là mặc định).
  static const Map<String, String> fonts = {
    'Mặc định': '',
    'Serif': 'serif',
    'Monospace': 'monospace',
    'Sans hẹp': 'sans-serif-condensed',
    'Viết tay': 'cursive',
  };
}

/// Bảng màu dùng chung (không hardcode rải rác trong widget).
class AppColors {
  AppColors._();

  static const Color seed = Color(0xFF3F51B5);
  static const Color rating = Color(0xFFFFB300);
  static const Color ongoing = Color(0xFF1E88E5);
  static const Color completed = Color(0xFF43A047);
  static const Color lightNovel = Color(0xFF8E24AA);
  static const Color comic = Color(0xFFFF6D00);
  static const Color offline = Color(0xFFE53935);
  static const Color bannerOverlay = Color(0xCC000000);
  static const Color onBanner = Colors.white;
  static const Color dimOverlay = Colors.black;

  // 4 nền đọc
  static const Color readerWhiteBg = Color(0xFFFFFFFF);
  static const Color readerWhiteText = Color(0xFF212121);
  static const Color readerSepiaBg = Color(0xFFF4ECD8);
  static const Color readerSepiaText = Color(0xFF5B4636);
  static const Color readerGrayBg = Color(0xFFD9DCE0);
  static const Color readerGrayText = Color(0xFF2B2B2B);
  static const Color readerBlackBg = Color(0xFF121212);
  static const Color readerBlackText = Color(0xFFBDBDBD);
}

/// Toàn bộ chuỗi hiển thị (tiếng Việt).
class AppStrings {
  AppStrings._();

  // Điều hướng
  static const String navHome = 'Trang chủ';
  static const String navSearch = 'Tìm kiếm';
  static const String navLibrary = 'Tủ sách';
  static const String navProfile = 'Cá nhân';

  // Chung
  static const String retry = 'Thử lại';
  static const String cancel = 'Hủy';
  static const String delete = 'Xóa';
  static const String save = 'Lưu';
  static const String confirm = 'Xác nhận';
  static const String seeAll = 'Xem tất cả';
  static const String loading = 'Đang tải...';
  static const String errorGeneric = 'Đã có lỗi xảy ra';
  static const String loadFailed = 'Không tải được dữ liệu';
  static const String empty = 'Không có dữ liệu';
  static const String offlineBanner =
      'Bạn đang offline – chỉ đọc được chương đã tải';
  static const String noMore = 'Đã hiển thị hết';
  static const String unknown = 'Không rõ';

  // Trang chủ
  static const String featured = 'Đề cử';
  static const String continueReading = 'Tiếp tục đọc';
  static const String newlyUpdated = 'Mới cập nhật';
  static const String hot = 'Truyện hot';
  static const String completedNovels = 'Truyện hoàn thành';
  static const String genres = 'Thể loại';
  static const String allNovels = 'Tất cả truyện';

  // Tìm kiếm
  static const String searchHint = 'Tìm theo tên truyện hoặc tác giả';
  static const String searchHistory = 'Tìm kiếm gần đây';
  static const String clearHistory = 'Xóa lịch sử';
  static const String filters = 'Bộ lọc';
  static const String clearFilters = 'Bỏ lọc';
  static const String all = 'Tất cả';
  static const String noResult = 'Không tìm thấy truyện phù hợp';
  static const String statusLabel = 'Trạng thái';
  static const String typeLabel = 'Loại truyện';

  // Trạng thái / loại
  static const String statusOngoing = 'Đang ra';
  static const String statusCompleted = 'Hoàn thành';
  static const String typeNovel = 'Truyện chữ';
  static const String typeLightNovel = 'Light Novel';
  static const String typeComic = 'Truyện tranh';
  static const String comicsSection = 'Truyện tranh / Manga mới';

  // Chi tiết
  static const String readNow = 'Đọc ngay';
  static const String continueRead = 'Đọc tiếp';
  static const String addToLibrary = 'Thêm vào tủ sách';
  static const String inLibrary = 'Trong tủ sách';
  static const String download = 'Tải xuống';
  static const String downloadAll = 'Tải tất cả chương';
  static const String downloadNotDownloaded = 'Tải các chương chưa tải';
  static const String downloading = 'Đang tải';
  static const String chapterList = 'Danh sách chương';
  static const String showMore = 'Xem thêm';
  static const String showLess = 'Thu gọn';
  static const String author = 'Tác giả';
  static const String novelNotFound = 'Không tìm thấy truyện';
  static const String noChapters = 'Truyện chưa có chương nào';
  static const String selectChapters = 'Chọn chương để tải';
  static const String downloadSelected = 'Tải các chương đã chọn';
  static const String selectAll = 'Chọn tất cả';
  static const String downloadDone = 'Đã tải xong';
  static const String needOnline = 'Cần kết nối mạng để tải chương';

  // Tủ sách
  static const String libraryReading = 'Đang đọc';
  static const String libraryWant = 'Muốn đọc';
  static const String libraryFinished = 'Đã đọc';
  static const String sortByName = 'Sắp xếp theo tên';
  static const String sortByTime = 'Sắp xếp theo thời gian';
  static const String emptyLibrary = 'Chưa có truyện nào trong mục này';
  static const String removeFromLibrary = 'Xóa khỏi tủ sách';
  static const String moveTo = 'Chuyển sang';
  static const String notStarted = 'Chưa đọc';

  // Lịch sử
  static const String history = 'Lịch sử đọc';
  static const String clearAll = 'Xóa tất cả';
  static const String emptyHistory = 'Chưa có lịch sử đọc';
  static const String confirmClearHistory = 'Xóa toàn bộ lịch sử đọc?';

  // Tải xuống
  static const String downloads = 'Tải xuống';
  static const String emptyDownloads =
      'Chưa có chương nào được tải.\nTruyện tự nhập được lưu trong Tủ sách.';
  static const String confirmDeleteDownloads = 'Xóa tất cả chương đã tải?';
  static const String totalSize = 'Tổng dung lượng';
  static const String deleteNovelDownloads = 'Xóa các chương đã tải của truyện';

  // Đọc truyện
  static const String tableOfContents = 'Mục lục';
  static const String prevChapter = 'Chương trước';
  static const String nextChapter = 'Chương sau';
  static const String readerSettings = 'Cài đặt đọc';
  static const String bookmark = 'Đánh dấu';
  static const String bookmarks = 'Đánh dấu trang';
  static const String addBookmark = 'Thêm đánh dấu';
  static const String bookmarkNoteHint = 'Ghi chú (không bắt buộc)';
  static const String bookmarkAdded = 'Đã thêm đánh dấu';
  static const String noBookmarks = 'Chưa có đánh dấu nào';
  static const String lastChapter = 'Bạn đã đọc đến chương cuối';
  static const String firstChapter = 'Đây là chương đầu tiên';
  static const String chapterOfflineError =
      'Chương này chưa được tải và bạn đang offline.';
  static const String downloaded = 'Đã tải';
  static const String downloadChapter = 'Tải chương này';
  static const String finishedNovel = 'Đánh dấu đã đọc xong';

  // Cài đặt đọc
  static const String fontSize = 'Cỡ chữ';
  static const String font = 'Phông chữ';
  static const String lineHeight = 'Giãn dòng';
  static const String textAlign = 'Căn lề';
  static const String alignLeft = 'Trái';
  static const String alignJustify = 'Đều hai bên';
  static const String background = 'Màu nền';
  static const String brightness = 'Độ sáng';
  static const String keepScreenOn = 'Giữ màn hình sáng khi đọc';
  static const String previewText =
      'Đây là đoạn văn mẫu để xem trước cài đặt đọc của bạn.';

  // Cài đặt
  static const String settings = 'Cài đặt';
  static const String appearance = 'Giao diện';
  static const String themeSystem = 'Theo hệ thống';
  static const String themeLight = 'Sáng';
  static const String themeDark = 'Tối';
  static const String defaultReaderSettings = 'Cài đặt đọc mặc định';
  static const String dataAndStorage = 'Dữ liệu & bộ nhớ';
  static const String clearImageCache = 'Xóa cache ảnh';
  static const String clearImageCacheDone = 'Đã xóa cache ảnh';
  static const String clearSearchHistory = 'Xóa lịch sử tìm kiếm';
  static const String clearSearchHistoryDone = 'Đã xóa lịch sử tìm kiếm';
  static const String forceOffline = 'Chế độ offline (giả lập)';
  static const String forceOfflineDesc =
      'Ngắt kết nối giả lập để thử đọc chương đã tải';
  static const String about = 'Giới thiệu';
  static const String aboutDesc =
      'Ứng dụng đọc truyện demo. Dữ liệu là nội dung mẫu tự viết.';
  static const String statsLibrary = 'Tủ sách';
  static const String statsHistory = 'Đã đọc';
  static const String statsDownloads = 'Chương đã tải';
  static const String guestName = 'Độc giả';
  static const String guestDesc = 'Đăng nhập & đồng bộ: sẽ hỗ trợ sau';

  // Tự thêm truyện / chương & nhập văn bản
  static const String createOrImportNovel = 'Thêm / Nhập truyện mới';
  static const String createOrImportDesc =
      'Tự sáng tác hoặc dán văn bản nhiều chương (tự động tách Chương 1, 2...)';
  static const String addChapter = 'Thêm chương mới';
  static const String novelTitleLabel = 'Tên truyện';
  static const String novelAuthorLabel = 'Tác giả';
  static const String novelCoverUrlLabel = 'URL ảnh bìa (để trống sẽ tự tạo)';
  static const String novelDescLabel = 'Mô tả nội dung';
  static const String rawChaptersLabel =
      'Nội dung (có thể dán nhiều chương, bắt đầu dòng bằng "Chương 1: ...")';
  static const String chapterTitleLabel = 'Tiêu đề chương';
  static const String chapterContentLabel = 'Nội dung chương';
  static const String novelCreatedSuccess = 'Đã thêm truyện mới vào thư viện!';
  static const String chapterAddedSuccess = 'Đã thêm chương mới!';

  // Tính năng sáng tạo: Tự cuộn, Trích dẫn, Bình luận & Đánh giá, Danh hiệu
  static const String autoScroll = 'Tự cuộn';
  static const String autoScrollSpeed = 'Tốc độ tự cuộn';
  static const String quoteSaved = 'Đã lưu vào bộ sưu tập Trích dẫn!';
  static const String quotesCollection = 'Bộ sưu tập Trích dẫn';
  static const String emptyQuotes =
      'Nhấn giữ vào một đoạn văn bất kỳ khi đọc truyện để lưu trích dẫn tâm đắc';
  static const String saveQuote = 'Lưu trích dẫn này';
  static const String copyQuote = 'Sao chép đoạn văn';
  static const String copiedToClipboard = 'Đã sao chép vào bộ nhớ tạm';
  static const String rateNovel = 'Đánh giá truyện';
  static const String ratingUpdated = 'Cảm ơn bạn đã đánh giá truyện!';
  static const String chapterComments = 'Bình luận chương';
  static const String commentHint = 'Chia sẻ cảm nghĩ của bạn về chương này...';
  static const String sendComment = 'Gửi';
  static const String noComments =
      'Chưa có bình luận nào. Hãy là người đầu tiên chia sẻ cảm nghĩ!';

  // Combo 5 tính năng mới: Nghe truyện, Tìm trong chương, X-Ray, Gacha, Phím tắt
  static const String listenChapter = 'Nghe đọc';
  static const String stopListen = 'Dừng đọc';
  static const String searchInChapter = 'Tìm trong chương';
  static const String searchInChapterHint = 'Nhập từ cần tìm trong chương...';
  static const String xrayTitle = 'Hồ sơ X-Ray (Nhân vật & Bối cảnh)';
  static const String randomGacha = 'Hôm nay đọc gì?';
  static const String randomGachaSub = 'Rút thẻ gợi ý truyện ngẫu nhiên';
  static const String rerollGacha = 'Rút thẻ khác';
  static const String keyboardShortcutsHint =
      'Phím tắt: [←/→] Chương trước/sau • [Space] Tự cuộn • [Esc] Quay lại';

  // Phiên bản 2: Lật trang ngang, Thống kê đọc, Sao lưu/Khôi phục JSON
  static const String readingMode = 'Kiểu đọc';
  static const String modeVerticalScroll = 'Cuộn dọc';
  static const String modeHorizontalPage = 'Lật trang ngang';
  static const String statsScreenTitle = 'Thống kê đọc sách';
  static const String statsScreenSubtitle =
      'Biểu đồ 7 ngày, chuỗi ngày đọc liên tiếp (Streak) & tổng số từ';
  static const String backupAndRestore = 'Sao lưu & Khôi phục (JSON)';
  static const String exportBackup = 'Xuất dữ liệu sao lưu (JSON)';
  static const String importBackup = 'Khôi phục từ chuỗi JSON';
  static const String backupCopied = 'Đã sao chép JSON sao lưu vào bộ nhớ tạm!';
  static const String restoreSuccess = 'Đã khôi phục dữ liệu thành công!';
  static const String restoreInvalid = 'Dữ liệu JSON không hợp lệ!';
}
