# NovelReader — Ứng Dụng Đọc Truyện Chữ, Light Novel & Truyện Tranh Đa Nền Tảng (Flutter)

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Material 3](https://img.shields.io/badge/UI-Material_3-6750A4)
![SQLite](https://img.shields.io/badge/Database-SQLite_&_WebAssembly-003B57?logo=sqlite&logoColor=white)
![Tests](https://img.shields.io/badge/Tests-8%2F8_Passed-2EA043)

**NovelReader** là ứng dụng đọc **Truyện chữ (Novel)**, **Light Novel** và **Truyện tranh (Manga / Webtoon / Manhwa)** đa nền tảng (**Android, Web, Windows Desktop**) được phát triển bằng **Flutter 3.x & Dart 3.x (Material 3)**. Ứng dụng hỗ trợ đọc offline, nghe đọc bằng giọng nói tiếng Việt (Text-to-Speech), tự động cuộn rảnh tay, phân tích nhân vật X-Ray, thống kê thói quen đọc và sao lưu/khôi phục dữ liệu JSON.

---

## Mục Lục

1. [Điểm Nổi Bật & Tính Năng Cốt Lõi](#1-điểm-nổi-bật--tính-năng-cốt-lõi)
2. [Hệ Sinh Thái Tính Năng Sáng Tạo (Phiên Bản 2)](#2-hệ-sinh-thái-tính-năng-sáng-tạo-phiên-bản-2)
3. [Kiến Trúc Phần Mềm & Cơ Sở Dữ Liệu](#3-kiến-trúc-phần-mềm--cơ-sở-dữ-liệu)
4. [Kho Dữ Liệu Mẫu (36 Tác Phẩm — ~1,45 MB)](#4-kho-dữ-liệu-mẫu-36-tác-phẩm--145-mb)
5. [Cấu Trúc Thư Mục](#5-cấu-trúc-thư-mục)
6. [Hướng Dẫn Cài Đặt, Kiểm Thử & Chạy Ứng Dụng](#6-hướng-dẫn-cài-đặt-kiểm-thử--chạy-ứng-dụng)

---

## 1. Điểm Nổi Bật & Tính Năng Cốt Lõi

### 🏠 Trang chủ (`HomeScreen`)
- **Banner đề cử (Carousel):** Trình chiếu các tác phẩm nổi bật kèm nhãn phân loại và chỉ báo trang động.
- **Tiếp tục đọc (Continue Reading):** Hiển thị thanh tiến độ phần trăm và nhảy thẳng tới đúng chương + đúng vị trí cuộn đang đọc dở.
- **Khám phá đa danh mục:** Kệ riêng cho *Truyện tranh / Manga mới*, *Truyện mới cập nhật*, *Truyện hot (lượt đọc cao)*, *Truyện hoàn thành* và dải chip *Thể loại*.

### 🔎 Tìm kiếm & Bộ lọc thời gian thực (`SearchScreen`, `GenreScreen`)
- **Tìm kiếm không phân biệt dấu tiếng Việt:** Chuẩn hóa chuỗi (`Format.normalize`) cho phép gõ `kiem dao` hoặc `truong kiem` vẫn tìm ra chính xác *Kiếm Đạo Vấn Thiên*, tích hợp **debounce 300ms**.
- **Bộ lọc đa điều kiện kết hợp:** Lọc đồng thời theo loại hình (*Truyện chữ / Light Novel / Truyện tranh*), trạng thái (*Đang ra / Hoàn thành*), nhiều thể loại cùng lúc và 4 tiêu chí sắp xếp.
- **Phân trang vô hạn (Infinite Scroll) & Pull-to-Refresh:** Tải thêm dữ liệu mượt mà khi cuộn gần cuối danh sách.

### 📖 Trình đọc đa chế độ (`ReaderScreen`)
- **2 chế độ đọc linh hoạt:**
  - **Cuộn dọc truyền thống (`SingleChildScrollView`):** Phù hợp đọc truyện chữ dài và Webtoon.
  - **Lật trang ngang (`PageView` — `ReaderHorizontalPager`):** Tự động phân trang, phù hợp trải nghiệm đọc sách giấy và Manga.
- **Cá nhân hóa giao diện đọc (`ReaderSettingsSheet`):**
  - Tùy chỉnh cỡ chữ (`14` – `28`), 5 phông chữ, độ giãn dòng (`1.2` – `2.2`), căn lề (*Trái / Đều hai bên*).
  - **4 chủ đề màu nền chuẩn bảo vệ mắt:** *Trắng (White)*, *Vàng cổ điển (Sepia)*, *Xám dịu (Gray)*, *Đen ban đêm (Dark)*.
  - Điều chỉnh độ sáng ngay trong ứng dụng và giữ sáng màn hình (`wakelock_plus`).
- **Lưu vị trí đọc theo tỉ lệ (`0.0 .. 1.0`):** Không bị lệch đoạn đang đọc khi thay đổi cỡ chữ hoặc xoay ngang/dọc màn hình.
- **Trình xem ảnh minh họa & trang truyện tranh:** Hỗ trợ zoom đa điểm (`InteractiveViewer` 0.8x – 4.0x).

### 📚 Tủ sách, Lịch sử & Đọc Offline (`LibraryScreen`, `DownloadsScreen`)
- **Tủ sách 3 phân mục:** *Đang đọc / Muốn đọc / Đã đọc*; tự động chuyển từ *Muốn đọc* sang *Đang đọc* khi mở chương và gợi ý đánh dấu *Đã đọc* ở chương cuối.
- **Tải chương Offline:** Tải 1 chương, chọn nhiều chương hoặc tải toàn bộ chương chưa tải kèm thanh tiến trình (`LinearProgressIndicator`).
- **Quản lý dung lượng & Chế độ Offline giả lập:** Thống kê dung lượng lưu trữ (B / KB / MB) theo từng truyện; tích hợp công tắc **Chế độ offline (giả lập)** trong mục Cài đặt để kiểm thử kịch bản mất mạng ngay lập tức.

---

## 2. Hệ Sinh Thái Tính Năng Sáng Tạo (Phiên Bản 2)

| Tính năng | Mô tả chi tiết |
| :--- | :--- |
| **🎧 Nghe đọc truyện (TTS) đồng bộ từng đoạn** | Sử dụng `flutter_tts` trên Android/iOS/Desktop và Web Speech API trên trình duyệt. Tự động chuyển đoạn qua **completion callback thực tế** và cuộn tới đúng đoạn văn đang phát bằng `Scrollable.ensureVisible` + `GlobalKey`. |
| **⚡ Tự động cuộn rảnh tay (Auto-Scroll)** | Trang truyện tự trôi mượt mà với thanh điều chỉnh tốc độ từ `0.5x` đến `4.0x`; chạm nhẹ vào màn hình để tạm dừng tức thì. |
| **🧬 Hồ sơ X-Ray (Nhân vật & Bối cảnh)** | Tự động quét nội dung chương hiện tại để thống kê các nhân vật/địa danh xuất hiện nhiều nhất kèm tần suất; chạm vào tên nhân vật để **tô vàng (highlight)** mọi vị trí xuất hiện trong chương. |
| **✨ Thẻ Trích Dẫn Nghệ Thuật (Quote Card)** | Nhấn giữ (*long-press*) vào đoạn văn bất kỳ khi đang đọc để tạo thẻ trích dẫn gradient kèm tên truyện, tác giả, chương; hỗ trợ sao chép nhanh hoặc lưu vào **Bộ sưu tập Trích dẫn**. |
| **📊 Thống kê đọc sách 7 ngày & Streak 🔥** | Màn hình `StatsScreen` và bảng `reading_sessions` ghi nhận tổng số từ đã đọc, tổng số phút đọc, chuỗi ngày đọc liên tiếp (*Streak*) và biểu đồ cột 7 ngày gần nhất. |
| **☁️ Sao lưu & Khôi phục JSON** | Xuất toàn bộ dữ liệu cá nhân (tủ sách, lịch sử, vị trí đọc, bookmark, trích dẫn, thống kê) ra chuẩn JSON và khôi phục sang thiết bị mới không cần máy chủ. |
| **✍️ Tự sáng tác & Nhập văn bản nhiều chương** | Dán văn bản dài có các tiêu đề `Chương 1: ...`, `Chương 2: ...`, ứng dụng sẽ **tự động tách thành từng chương riêng biệt** và lưu offline vào SQLite. Hỗ trợ viết thêm chương mới cho bất kỳ bộ truyện nào. |
| **🎲 Vòng quay Gacha & 🏅 Danh hiệu Độc giả** | Rút thẻ gợi ý truyện ngẫu nhiên (*"Hôm nay đọc gì?"*) trên Trang chủ; tự động thăng cấp danh hiệu từ *Độc Giả Tân Thủ → Mọt Sách Chính Hiệu → Đại Học Sĩ → Kiếm Tiên Độc Thư*. |
| **♿ Khả năng tiếp cận & ⌨️ Phím tắt** | Tích hợp `Semantics`/`semanticLabel` cho trình đọc màn hình, tôn trọng `textScaler` hệ thống; hỗ trợ phím tắt `[←]/[→]` chuyển chương, `[Space]` tự cuộn, `[Esc]` quay lại. |

---

## 3. Kiến Trúc Phần Mềm & Cơ Sở Dữ Liệu

Ứng dụng được thiết kế theo kiến trúc phân lớp rõ ràng với **Provider (`ChangeNotifier`)** và **SQLite (`sqflite`)**:

| Bảng SQLite | Vai trò & Cột chính |
| :--- | :--- |
| `novels` | Lưu thông tin truyện (`id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text`) |
| `chapters` | Lưu danh sách chương và nội dung tải offline (`id, novel_id, chapter_index, title, content, is_downloaded`) |
| `library` | Lưu truyện trong tủ sách theo 3 danh mục (`novel_id, category, added_at`) |
| `reading_history` | Lưu chương đọc gần nhất và tỉ lệ cuộn `0.0..1.0` (`novel_id, last_chapter_id, scroll_offset, last_read_at`) |
| `bookmarks` | Lưu đánh dấu vị trí trong chương kèm ghi chú (`id, novel_id, chapter_id, scroll_offset, note, created_at`) |
| `quotes` | Lưu bộ sưu tập trích dẫn tâm đắc (`id, novel_id, novel_title, author, chapter_title, content, created_at`) |
| `comments` | Lưu bình luận & đánh giá sao theo chương (`id, novel_id, chapter_id, user_name, content, stars, created_at`) |
| `reading_sessions` | Lưu thống kê số từ & số phút đọc theo từng ngày (`date_key, words_read, minutes_read`) |

---

## 4. Kho Dữ Liệu Mẫu (36 Tác Phẩm — ~1,45 MB)

Tệp `assets/data/sample_novels.json` được tự động đồng bộ vào SQLite ở lần khởi chạy đầu tiên (hoặc khi nâng cấp phiên bản DB), bao gồm **36 bộ truyện** chia đều cho 3 loại hình:
1. **12 Truyện chữ (`novel`):** Kết hợp các tác phẩm văn học kinh điển thuộc phạm vi công cộng (*Truyện Kiều — Nguyễn Du*, *Tuyển tập Nam Cao: Lão Hạc & Chí Phèo*, *Hồ sơ Thám tử 221B — Arthur Conan Doyle*) và các tiểu thuyết Tiên hiệp, Đô thị, Trinh thám tự biên soạn (mỗi chương 35–42 đoạn văn dài).
2. **12 Light Novel (`light_novel`):** Các tác phẩm Isekai, Học đường, Fantasy có xen kẽ tranh minh họa inline trong chương.
3. **12 Truyện tranh / Manga / Webtoon (`comic`):** Mỗi chương gồm 10 trang tranh khổ dọc (`720x1020`) kèm lời dẫn/thoại, hỗ trợ cả cuộn dọc Webtoon lẫn lật trang ngang Manga.

---

## 5. Cấu Trúc Thư Mục

```text
lib/
├── main.dart                      // Khởi tạo SQLite (Android/Web/Desktop), MultiProvider, Theme
├── database/
│   └── app_database.dart          // Tạo bảng, CRUD, đồng bộ dữ liệu mẫu, Backup/Restore JSON
├── models/
│   ├── novel.dart                 // Novel + NovelSort
│   ├── chapter.dart               // Chapter + DownloadedChapter
│   ├── library_item.dart          // LibraryItem
│   ├── reading_history.dart       // ReadingHistory + ReadingSessionStat
│   ├── bookmark.dart              // Bookmark + QuoteItem + ChapterComment
│   └── reader_settings.dart       // ReaderSettings (cỡ chữ, font, giãn dòng, nền, kiểu lật trang)
├── providers/
│   ├── novel_provider.dart        // Trang chủ, tìm kiếm debounce, lọc, phân trang, tạo truyện
│   ├── library_provider.dart      // Tủ sách, lịch sử, bookmark, trích dẫn, bình luận, streak
│   ├── reader_provider.dart       // Đọc chương, theo dõi mạng, tải xuống offline
│   └── settings_provider.dart     // Theme sáng/tối + cài đặt đọc (SharedPreferences)
├── screens/
│   ├── main_shell.dart            // NavigationBar 4 tab + banner cảnh báo offline
│   ├── home_screen.dart           // Trang chủ + Gacha "Hôm nay đọc gì?"
│   ├── search_screen.dart         // Tìm kiếm + lọc đa điều kiện + lịch sử từ khóa
│   ├── genre_screen.dart          // Lưới thể loại + danh sách truyện phân trang
│   ├── novel_detail_screen.dart   // Chi tiết truyện + tải chương + thêm chương + chấm sao
│   ├── reader_screen.dart         // Màn đọc chính (cuộn dọc + lật trang ngang + TTS + Auto-scroll)
│   ├── library_screen.dart        // Tủ sách 3 tab (Đang đọc / Muốn đọc / Đã đọc)
│   ├── history_screen.dart        // Lịch sử đọc
│   ├── downloads_screen.dart      // Quản lý chương đã tải & dung lượng
│   ├── stats_screen.dart          // Biểu đồ thống kê đọc sách 7 ngày & Streak
│   └── settings_screen.dart       // Cá nhân, Danh hiệu, Sao lưu/Khôi phục JSON, Nhập truyện
├── utils/
│   ├── constants.dart             // Hằng số, màu sắc, khóa SharedPreferences, chuỗi tiếng Việt
│   ├── format.dart                // Định dạng ngày, lượt đọc, dung lượng, bỏ dấu tiếng Việt
│   ├── theme.dart                 // ThemeData Material 3 sáng/tối + 4 nền đọc
│   ├── tts_helper.dart            // Conditional export cho Text-to-Speech (Web & Mobile)
│   ├── tts_mobile.dart            // TTS cho Android/iOS/Desktop bằng flutter_tts
│   ├── tts_stub.dart              // Stub TTS mặc định
│   └── tts_web.dart               // Web Speech API tiếng Việt cho trình duyệt
└── widgets/
    ├── novel_card.dart            // Thẻ truyện dọc/ngang + nhãn LN/MANGA + Semantics
    ├── chapter_tile.dart          // Dòng chương + trạng thái tải offline
    ├── genre_chip.dart            // Chip thể loại
    ├── reader_toolbar.dart        // Thanh công cụ trên & dưới trong màn đọc
    ├── reader_settings_sheet.dart // Bảng tùy chỉnh giao diện đọc
    ├── empty_view.dart            // Trạng thái rỗng
    ├── error_view.dart            // Trạng thái lỗi (có nút Thử lại)
    ├── loading_view.dart          // Trạng thái đang tải
    └── reader/
        ├── paragraph_view.dart        // Hiển thị đoạn văn / ảnh + highlight TTS & từ khóa
        ├── xray_and_quote_sheets.dart // Bảng X-Ray nhân vật, Quote Card & ReaderHorizontalPager
        └── comment_section.dart       // Khu vực bình luận cuối chương
assets/
└── data/sample_novels.json        // 36 tác phẩm mẫu: Truyện chữ, Light Novel & Truyện tranh (~1,45 MB)
test/
└── widget_test.dart               // 8 bài Unit Test & Widget Test tự động
```

---

## 6. Hướng Dẫn Cài Đặt, Kiểm Thử & Chạy Ứng Dụng

```bash
# 1. Cài đặt các gói phụ thuộc
flutter pub get

# 2. (Nếu chạy trên trình duyệt Web) Khởi tạo binary SQLite WebAssembly
dart run sqflite_common_ffi_web:setup

# 3. Kiểm tra phân tích tĩnh mã nguồn (0 lỗi, 0 cảnh báo)
dart analyze lib test

# 4. Chạy toàn bộ Unit Test & Widget Test (8/8 passed)
flutter test

# 5. Chạy ứng dụng (Android Emulator / Chrome Web / Windows Desktop)
flutter run
```
