# NovelReader v2.0 — Hệ Sinh Thái Đọc Truyện Chữ, Light Novel, Manga & Quản Trị Admin Toàn Diện (Flutter)

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Material 3](https://img.shields.io/badge/UI-Material_3-6750A4)
![SQLite](https://img.shields.io/badge/Database-SQLite_v6_&_WebAssembly-003B57?logo=sqlite&logoColor=white)
![Tests](https://img.shields.io/badge/Tests-flutter_test-2EA043)

**NovelReader v2.0** là ứng dụng đọc **Truyện chữ (Novel)**, **Light Novel** và **Truyện tranh (Manga / Webtoon / Manhwa)** đa nền tảng (**Android, Web, Windows Desktop**) tích hợp **Hệ thống Phân quyền Đa vai trò (Khách / Độc giả / Tác giả / Admin)**, **Khu Quản Trị Admin (Dashboard, Heatmap, Drop-off Analyzer, Kiểm duyệt, Audit Log)**, **Gamification (Nhiệm vụ, Streak Shield, Linh Thạch, 20 Huy hiệu)** và các tính năng sáng tạo (**Spoiler Shield, Recap, Từ điển thuật ngữ, RSVP Speed Reader, Ambient Mixer, Hộp thư thời gian, Tủ sách 3D, Reading Wrapped PNG, Sơ đồ nhân vật kéo thả**).

---

## 1. Tài Khoản Demo Khởi Tạo Sẵn (Giai Đoạn A — Local SQLite)

Ứng dụng hiện dùng **Supabase Auth và PostgreSQL** qua `SupabaseAuthRepository` và `SupabaseNovelRepository`. SQLite lưu truyện tự nhập, chương tải xuống và bộ nhớ đệm tiến độ đọc. Các tài khoản trong bảng dưới thuộc dữ liệu demo SQLite dùng cho kiểm thử; khi chạy bản Supabase, dùng tài khoản đã đăng ký trên dự án của bạn. Các file thiết lập database nằm trong thư mục `supabase/`.

| Vai trò | Email đăng nhập | Mật khẩu khởi tạo | Câu trả lời bí mật | Đặc quyền nổi bật |
| :--- | :--- | :--- | :--- | :--- |
| **👑 Admin** | `admin@novelreader.local` | `Admin@123` | `tien hiep` | Bắt buộc đổi mật khẩu ở lần đăng nhập đầu; vào `AdminShell` (Dashboard, Duyệt truyện, Khóa user, Audit Log, Bảo trì) + nút chuyển nhanh sang giao diện Độc giả. |
| **🪶 Author** | `author@novelreader.local` | `Author@123` | `fantasy` | Có cờ `is_author = true`; mở **Author Studio (Truyện của tôi)**, tự lưu nháp mỗi 5 giây, gửi duyệt tác phẩm, xem thống kê. |
| **🦊 User** | `user@novelreader.local` | `User@1234` | `isekai` | Độc giả thành viên: làm Nhiệm vụ ngày/tuần/sự kiện, nhận Linh Thạch, mở khóa khung Avatar, bình luận, báo cáo vi phạm. |
| **👤 Khách** | *(Bấm "Đọc ngay ở Chế độ Khách")* | — | — | Đọc truyện, tìm kiếm, nhập truyện cá nhân và lưu tiến độ trên thiết bị. |

---

## 2. Ma Trận Phân Quyền (Route Guard • Provider Guard • Supabase RLS)

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

# 2. Chạy toàn bộ Unit Test & Widget Test
flutter test --no-pub

# 3. Khởi chạy ứng dụng
flutter run
```

Để chạy Android, khởi động máy ảo Android hoặc kết nối điện thoại đã bật USB debugging, chạy `flutter devices`, sau đó dùng `flutter run -d <device-id>`. Có thể tạo APK debug bằng `flutter build apk --debug`.

Cấu hình client dùng `SUPABASE_URL` và `SUPABASE_PUBLISHABLE_KEY` qua `--dart-define`; ứng dụng cũng hỗ trợ tên `NEXT_PUBLIC_SUPABASE_URL` và `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`. Khóa secret chỉ dùng phía máy chủ.

Nhập truyện chữ bằng file TXT; nhập Manga trên web bằng ZIP/CBZ chứa ảnh hoặc các thư mục chương. Ảnh và chương được sắp theo số tự nhiên. Truyện tự nhập lưu trên thiết bị và được giữ lại khi xóa bộ nhớ tải xuống.

Tiến độ đọc được ghi SQLite trước khi đồng bộ Supabase, có bộ nhớ đệm riêng theo tài khoản và chế độ Khách. Khi mạng trở lại hoặc tải lại lịch sử, ứng dụng thử gửi các mốc còn chờ và so sánh thời điểm đọc với máy chủ. Bản sao lưu JSON phiên bản 7 chứa nội dung TXT, ảnh Manga và lịch sử trên thiết bị. Khi xuất sao lưu trên Android/Windows, ảnh liên kết thư mục và ảnh bìa cục bộ được nhúng vào file JSON, nên sau khi khôi phục không cần đường dẫn ảnh cũ. Nếu ảnh nguồn bị thiếu hoặc không đọc được, thao tác xuất sẽ báo lỗi. Khi khôi phục trên máy đã có truyện, ứng dụng đổi mã bị trùng, giữ liên kết chương/tiến độ/bookmark và nhận diện truyện giống nhau để tránh nhập lặp. Các bản sao lưu cũ vẫn được hỗ trợ theo dữ liệu có trong file.

Trong Cài đặt, chọn xuất bản sao lưu rồi **Lưu file JSON**; dùng **Khôi phục từ file JSON** trên máy đích. Vẫn có thể sao chép JSON với bản sao lưu nhỏ hoặc dán dữ liệu của bản cũ.

Tủ sách Khách lưu ngay trên thiết bị. Tủ sách thành viên có bản đệm riêng theo tài khoản để xem khi mất mạng; thay đổi danh mục hoặc xóa ở chế độ thành viên cần máy chủ xác nhận. Bản sao lưu mới chứa cả tủ sách đang lưu trên thiết bị.

Dấu trang Khách lưu vị trí và tên chương trên thiết bị; dấu trang thành viên có bộ đệm riêng theo tài khoản. Bản sao lưu phiên bản 6 bổ sung các dấu trang này; khi khôi phục vào tài khoản thành viên, ứng dụng đối chiếu dữ liệu máy chủ trước khi đồng bộ để tránh tạo trùng.

Khi bắt đầu đọc truyện trong mục Muốn đọc, ứng dụng lưu vị trí trước rồi chuyển danh mục sang Đang đọc ở nền. Mạng chậm/lỗi ở bước đổi danh mục không chặn các lần lưu vị trí tiếp theo; yêu cầu lỗi được thử lại sau khi tải lại dữ liệu hoặc kết nối lại.

Trích dẫn Khách và trích dẫn từ truyện tự nhập được lưu trên thiết bị, theo tài khoản đang dùng. Trích dẫn thành viên của truyện trên máy chủ có bản đệm để xem khi mất mạng. Bản sao lưu phiên bản 7 chỉ xuất trích dẫn của tài khoản được chọn; dữ liệu trích dẫn cũ chưa gắn tài khoản được giữ trong chế độ Khách.
