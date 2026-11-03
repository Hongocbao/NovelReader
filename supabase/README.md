# HƯỚNG DẪN KẾT NỐI VÀ KHỞI TẠO CƠ SỞ DỮ LIỆU SUPABASE CHO NOVELREADER

Dự án Supabase của bạn:
- **Project ID**: `lkxqsngzsnbsazarqbgj`
- **Project URL**: `https://lkxqsngzsnbsazarqbgj.supabase.co`
- **Region**: EU West 1 (Ireland)
- **Direct Pooler**: `aws-0-eu-west-1.pooler.supabase.com:5432`

---

## BƯỚC 1: TẠO DATABASE TRÊN SUPABASE (CHỈ MẤT 1 PHÚT)

1. Truy cập vào **SQL Editor** trên Supabase Dashboard:
   👉 [https://supabase.com/dashboard/project/lkxqsngzsnbsazarqbgj/sql/new](https://supabase.com/dashboard/project/lkxqsngzsnbsazarqbgj/sql/new)

2. Với project mới, mở file **`supabase/01_schema.sql`** trong dự án:
   - Sao chép (Copy) toàn bộ nội dung file này.
   - Dán (Paste) vào ô soạn thảo SQL của Supabase.
   - Bấm nút **RUN** (hoặc `Ctrl + Enter`).
   - *Kết quả*: Tạo các bảng với tên tiếng Việt không dấu, khóa ngoại, chỉ mục và chính sách Row Level Security (RLS).

3. Chạy **`supabase/05_fix_novel_identity_and_owner.sql`**, **`supabase/06_align_auth_user_ids.sql`**, **`supabase/07_secure_shop_item_prices.sql`**, **`supabase/08_set_new_user_starting_balance.sql`**, **`supabase/09_atomic_reading_and_quest_progress.sql`**, **`supabase/10_atomic_novel_import.sql`**, **`supabase/11_align_signup_starting_balance.sql`** và **`supabase/12_finish_novel_quest_progress.sql`**. Migration 06 giữ dữ liệu cũ nếu email trong `nguoi_dung` khớp `ho_so`, còn dữ liệu không gắn được với tài khoản Auth sẽ bị xóa khỏi các bảng cá nhân để tránh gán nhầm. Migration 07 buộc server xác thực giá của từng vật phẩm; migration 08 đồng bộ mức thưởng đăng ký mới với giao diện; migration 09 ghi thống kê đọc an toàn khi nhiều thiết bị cùng cập nhật và chỉ tăng nhiệm vụ từ phiên đọc/bình luận hợp lệ; migration 10 tạo truyện và toàn bộ chương bằng một giao dịch, đồng thời kiểm tra quyền sở hữu, trạng thái duyệt, kích thước dữ liệu và khóa thử lại để tránh nhân đôi truyện khi mạng ngắt sau khi lưu; migration 11 đồng bộ chính sách tạo hồ sơ với mức thưởng 150 Linh Thạch; migration 12 tăng tiến độ nhiệm vụ khi độc giả đánh dấu đã đọc xong truyện.

> Nếu đang nâng cấp database cũ: chạy `04_rename_tables_to_vietnamese.sql` (nếu bảng còn tên tiếng Anh), rồi chạy `05` và `06`. Sau đó chạy lại `01_schema.sql` để thay policy RLS demo bằng policy theo chủ sở hữu, rồi chạy `07`, `08`, `09`, `10`, `11` và `12`. Với database cũ, hãy bảo đảm đã có hồ sơ `ho_so` cho email muốn giữ dữ liệu trước khi chạy `06`.

4. Mở file **`supabase/02_seed_initial.sql`**:
   - Sao chép toàn bộ nội dung.
   - Dán vào SQL Editor và bấm **RUN**.
   - *Kết quả*: Nạp hồ sơ demo cũ, 20 huy hiệu, 6 nhiệm vụ, thuật ngữ truyện và cấu hình. Tài khoản trong `nguoi_dung` không phải tài khoản đăng nhập Supabase Auth.

> Tạo tài khoản bằng màn hình đăng ký của app. Để cấp quyền admin cho tài khoản Auth, đăng ký/đăng nhập tài khoản trước rồi chạy trong SQL Editor: `UPDATE public.ho_so SET role = 'admin' WHERE lower(email) = lower('email-cua-ban');`. Không cấp quyền admin từ code client.

5. *(Tùy chọn)* Mở file **`supabase/03_seed_novels.sql`**:
   - Dán vào SQL Editor và bấm **RUN**.
   - *Kết quả*: Nạp toàn bộ 36 bộ truyện và các chương mẫu vào Database trên đám mây.


---

## BƯỚC 2: CÁCH KẾT NỐI VÀ SỬ DỤNG TRONG ỨNG DỤNG FLUTTER

### 1. Lấy Publishable/Anon key
- Vào Supabase Dashboard -> **Project Settings** -> **API**.
- Copy **publishable key** (hoặc legacy `anon` public key) và dùng trong ứng dụng Flutter.
- Không đưa `secret`/`service_role` key vào Flutter, web build, file `.env` được bundle, hoặc Git; các key này bỏ qua RLS.

### 2. Thêm thư viện vào `pubspec.yaml`
```yaml
dependencies:
  supabase_flutter: ^2.8.0
```
Chạy lệnh tải gói:
```bash
flutter pub get
```

### 3. Khởi tạo trong `lib/main.dart`
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lkxqsngzsnbsazarqbgj.supabase.co',
    anonKey: 'DÁN_ANON_KEY_CỦA_BẠN_VÀO_ĐÂY',
  );

  runApp(const NovelReaderApp());
}
```

### 4. Truy vấn dữ liệu từ Supabase trong code
```dart
final supabase = Supabase.instance.client;

// Ví dụ: Lấy danh sách truyện đã duyệt
final response = await supabase
    .from('truyen')
    .select()
    .eq('moderation_status', 'approved')
    .order('views', ascending: false);

// Ví dụ: Đăng bình luận mới
await supabase.from('binh_luan').insert({
  'novel_id': 1,
  'chapter_id': 10001,
  'user_id': supabase.auth.currentUser!.id,
  'user_name': 'Độc giả',
  'content': 'Truyện hay quá!',
  'stars': 5,
  'created_at': DateTime.now().millisecondsSinceEpoch,
});
```
