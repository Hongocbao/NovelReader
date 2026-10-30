# NovelReader v2.0 — Hệ Sinh Thái Đọc Truyện Chữ, Light Novel, Manga & Quản Trị Admin Toàn Diện (Flutter)

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Material 3](https://img.shields.io/badge/UI-Material_3-6750A4)
![SQLite](https://img.shields.io/badge/Database-SQLite_v6_&_WebAssembly-003B57?logo=sqlite&logoColor=white)
![Tests](https://img.shields.io/badge/Tests-11%2F11_Passed-2EA043)

**NovelReader v2.0** là ứng dụng đọc **Truyện chữ (Novel)**, **Light Novel** và **Truyện tranh (Manga / Webtoon / Manhwa)** đa nền tảng (**Android, Web, Windows Desktop**) tích hợp **Hệ thống Phân quyền Đa vai trò (Khách / Độc giả / Tác giả / Admin)**, **Khu Quản Trị Admin (Dashboard, Heatmap, Drop-off Analyzer, Kiểm duyệt, Audit Log)**, **Gamification (Nhiệm vụ, Streak Shield, Linh Thạch, 20 Huy hiệu)** và các tính năng sáng tạo (**Spoiler Shield, Recap, Từ điển thuật ngữ, RSVP Speed Reader, Ambient Mixer, Hộp thư thời gian, Tủ sách 3D, Reading Wrapped PNG, Sơ đồ nhân vật kéo thả**).

---

## 1. Tài Khoản Demo Khởi Tạo Sẵn (Giai Đoạn A — Local SQLite)

> **Lưu ý Bảo mật:**Ở Giai đoạn A (Demo cục bộ không cần mạng), mật khẩu được băm một chiều bằng **SHA-256 kết hợp chuỗi muối (Salt) ngẫu nhiên** (`lib/utils/password_hasher.dart`), tuyệt đối không lưu mật khẩu thô. Khi triển khai môi trường thật (Giai đoạn B), ứng dụng chuyển sang `FirebaseAuthRepository` + `FirestoreNovelRepository` kèm quy tắc bảo mật tại `firestore.rules`.

| Vai trò | Email đăng nhập | Mật khẩu khởi tạo | Câu trả lời bí mật | Đặc quyền nổi bật |
| :--- | :--- | :--- | :--- | :--- |
| **👑 Admin** | `admin@novelreader.local` | `Admin@123` | `tien hiep` | Bắt buộc đổi mật khẩu ở lần đăng nhập đầu; vào `AdminShell` (Dashboard, Duyệt truyện, Khóa user, Audit Log, Bảo trì) + nút chuyển nhanh sang giao diện Độc giả. |
| **🪶 Author** | `author@novelreader.local` | `Author@123` | `fantasy` | Có cờ `is_author = true`; mở **Author Studio (Truyện của tôi)**, tự lưu nháp mỗi 5 giây, gửi duyệt tác phẩm, xem thống kê. |
| **🦊 User** | `user@novelreader.local` | `User@1234` | `isekai` | Độc giả thành viên: làm Nhiệm vụ ngày/tuần/sự kiện, nhận Linh Thạch, mở khóa khung Avatar, bình luận, báo cáo vi phạm. |
| **👤 Khách** | *(Bấm "Đọc ngay ở Chế độ Khách")* | — | — | Đọc truyện, tìm kiếm, tải offline, lưu tủ sách/lịch sử/bookmark cục bộ; khi đăng ký tài khoản mới sẽ tự động gộp toàn bộ dữ liệu trên máy. |

---

## 2. Ma Trận Phân Quyền 3 Lớp (Route Guard • Provider Guard • DB/Firestore Rules)

| Chức năng | Khách | User | Author (`is_author`) | Admin |
| :--- | :---: | :---: | :---: | :---: |
| Đọc truyện, tìm kiếm không dấu, tải offline | ✅ | ✅ | ✅ | ✅ |
| Tủ sách, lịch sử đọc, bookmark lưu cục bộ | ✅ | ✅ | ✅ | ✅ |
| Đồng bộ, bình luận, đánh giá, nhiệm vụ, huy hiệu | ❌ | ✅ | ✅ | ✅ |
| Đăng truyện & chương (Author chờ duyệt, Admin đăng thẳng) | ❌ | ❌ | ✅ (Chờ duyệt) | ✅ (Đăng thẳng) |
| Duyệt truyện, xử lý báo cáo, khóa tài khoản, từ cấm | ❌ | ❌ | ❌ | ✅ |
| Bảng thống kê hệ thống, cấu hình bảo trì, nhật ký Audit Log | ❌ | ❌ | ❌ | ✅ |

---

## 3. Tính Năng Mới Nổi Bật Ở Phiên Bản 2.0

### 🎮 Khu Người Dùng & Gamification (`lib/screens/user/`)
- **Nhiệm vụ, Streak & Linh Thạch (`QuestsAndAchievementsScreen`):**
  - Nhiệm vụ ngày (*Đọc 15 phút*, *Đọc 2 chương*, *Bình luận 1 chương*), nhiệm vụ tuần và sự kiện do Admin phát hành.
  - **Khiên bảo vệ Streak (Streak Shield):** Tiêu `20 Linh Thạch` để bảo toàn chuỗi ngày đọc liên tiếp.
  - **Cửa hàng Linh Thạch:** Đổi khung Avatar (*Hoàng Kim, Ngọc Bích Tiên Thiên, Cyberpunk Neon*) và gói nền đọc cổ điển.
  - **20 Huy hiệu Thành tựu:** *Cú Đêm, Mọt Sách Chính Hiệu, Độc Giả Chung Thủy, Thám Tử Lừng Danh, Lữ Khách Đa Vũ Trụ, Tốc Độ Ánh Sáng...* (ghim tối đa 3 huy hiệu lên hồ sơ).
- **Trải nghiệm Đọc Nâng Cao (`ReaderScreen` & `advanced_reader_sheets.dart`):**
  - **🛡️ Spoiler Shield (Khiên chống Spoil):** Bình luận thuộc chương lớn hơn chương độc giả đang đọc tự động được che mờ kèm nhãn *«Có thể spoil – Chạm để xem»*.
  - **📜 Previously on... (Recap):** Hiển thị tóm tắt các chương trước (`chapter_index <= currentChapterIndex`) kèm nút *Bỏ qua*.
  - **📖 Từ điển Thuật ngữ chống Spoil (`GlossarySheet`):** Chỉ hiển thị thuật ngữ có `first_chapter_index <= chương hiện tại`.
  - **⚡ Đọc nhanh RSVP (`RsvpSpeedReaderDialog`):** Hiển thị từng từ ở trung tâm màn hình (`200–800 từ/phút`), có Tạm dừng và Lùi 10 từ.
  - **🎧 Ambient Sound Mixer & Hẹn giờ ngủ TTS:** Trộn nhiều lớp âm thanh (*Mưa rơi, Quán cà phê, Lửa trại, Gió ngàn & Suối tiên*) tự gợi ý theo thể loại, kèm hẹn giờ tắt TTS (`15 / 30 / 60 phút`).
  - **⏳ Hộp thư thời gian (`TimeCapsuleNote`):** Gửi lời nhắn cho chính mình ở tương lai tại chương đang đọc (mở khóa sau 30/90 ngày).
  - **🔥 Đoạn văn được yêu thích nhất:** Tổng hợp cảm xúc đoạn văn (❤️, 😱, 😭) ở cuối mỗi chương.
- **Khám Phá Thông Minh & Chia Sẻ:**
  - **🎭 Chọn theo Tâm trạng (`MoodPickerSheet`) & Gợi ý chuẩn Gu (Cosine Similarity):** Tính độ tương đồng vector thể loại từ lịch sử đọc, hiển thị lý do *«Vì bạn hay đọc Tiên hiệp»*.
  - **🪵 Tủ sách 3D (`Shelf3DScreen`):** Vẽ bằng `CustomPainter` + `Matrix4` 3D Transform; độ dày gáy sách tỉ lệ với số chương, vuốt ngang để xoay góc nhìn kệ gỗ.
  - **🌌 Reading Wrapped 2026 (`ReadingWrappedScreen`):** Chuỗi thẻ tổng kết cuối năm vuốt ngang, tích hợp chụp kết xuất thẻ thành **ảnh PNG (`RepaintBoundary`)**.
  - **🕸️ Sơ đồ quan hệ nhân vật tự vẽ (`CharacterGraphScreen`):** Kéo thả các nút nhân vật, nối dây quan hệ (*Sư đồ, Đạo lữ, Kẻ thù*) và lưu JSON theo truyện.
  - **🪶 Author Studio (`AuthorStudioScreen`):** Dành cho tài khoản có `is_author = true`, tự động lưu bản nháp mỗi 5 giây, chèn ảnh `[img]url[/img]`, xem trước giao diện đọc và gửi duyệt.

### 🛡️ Khu Quản Trị Viên — Admin Center (`lib/screens/admin/`)
- **Admin Dashboard (`AdminDashboardScreen`):**
  - **6 Thẻ KPI:** Tổng người dùng, DAU/WAU, Tổng kho truyện, Lượt đọc hôm nay, Truyện chờ duyệt, Báo cáo vi phạm mở.
  - **Biểu đồ đường (`AdminLineChart`) & Biểu đồ cột (`AdminBarChart`):** Lượt đọc theo kỳ 7/14/30 ngày, Top 10 truyện, Phân bố thể loại.
  - **Heatmap giờ đọc (`AdminReadingHeatmap`):** Lưới `7 ngày × 24 giờ` chỉ ra khung giờ cao điểm để đăng chương mới.
  - **Bản đồ rớt chương (`Chapter Drop-off Analyzer`):** Phân tích số độc giả theo từng chương, tự động tô đỏ cảnh báo chương bị tụt mạnh độc giả (`≥ 30%`).
- **Quản lý Truyện, Chương & Hàng chờ duyệt (`AdminNovelsManageScreen`, `AdminModerationQueueScreen`):**
  - Tìm kiếm không dấu, thao tác hàng loạt (Duyệt, Gắn đề cử Banner, Xóa mềm vào thùng rác 30 ngày có hộp thoại bắt buộc gõ lại tên truyện, Khôi phục).
  - Checklist kiểm duyệt 3 tiêu chí (*Bản quyền, Nội dung nhạy cảm, Chất lượng trình bày*), Duyệt hoặc Từ chối kèm lý do bắt buộc (tự động gửi thông báo cho Author).
- **Quản lý Người dùng, Báo cáo, Sự kiện & Hệ thống:**
  - Khóa/mở khóa tài khoản (`1 ngày / 7 ngày / Vĩnh viễn` kèm lý do), cấp/thu hồi `is_author`, đổi role (chặn Admin tự khóa hoặc tự hạ quyền mình), xuất danh sách ra **CSV (`CsvExporter`)**.
  - Xử lý báo cáo vi phạm (*Bỏ qua / Ẩn bình luận / Cảnh cáo*), quản lý từ cấm (`banned_words` tự động thay bằng `***`), tự động ẩn bình luận khi có `≥ 3` báo cáo.
  - Bật/tắt **Chế độ bảo trì (`Maintenance Mode`)**, cờ tính năng (`Feature Flags`: TTS, Bình luận, Đăng ký mới) và **Nhật ký thao tác bất biến (`Audit Log`)**.

---

## 4. Hướng Dẫn Kiểm Thử & Chạy Ứng Dụng

```bash
# 1. Phân tích tĩnh mã nguồn (0 lỗi, 0 cảnh báo)
dart analyze lib test

# 2. Chạy toàn bộ 11 bài Unit Test & Widget Test (v1 + v2)
flutter test --no-pub

# 3. Khởi chạy ứng dụng
flutter run
```
