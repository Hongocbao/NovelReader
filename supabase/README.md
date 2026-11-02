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

2. Mở file **`supabase/01_schema.sql`** trong dự án:
   - Sao chép (Copy) toàn bộ nội dung file này.
   - Dán (Paste) vào ô soạn thảo SQL của Supabase.
   - Bấm nút **RUN** (hoặc `Ctrl + Enter`).
   - *Kết quả*: Tạo thành công toàn bộ **26 bảng**, khóa ngoại quan hệ, các chỉ mục (indexes) và chính sách bảo mật Row Level Security (RLS).

3. Mở file **`supabase/02_seed_initial.sql`**:
   - Sao chép toàn bộ nội dung.
   - Dán vào SQL Editor và bấm **RUN**.
   - *Kết quả*: Khởi tạo 3 tài khoản mẫu (Admin, Tác giả, Độc giả), 20 huy hiệu thành tựu, 6 nhiệm vụ mẫu, thuật ngữ truyện và cấu hình hệ thống.

4. *(Tùy chọn)* Mở file **`supabase/03_seed_novels.sql`**:
   - Dán vào SQL Editor và bấm **RUN**.
   - *Kết quả*: Nạp toàn bộ 36 bộ truyện và các chương mẫu vào Database trên đám mây.

---

## BƯỚC 2: CÁCH KẾT NỐI VÀ SỬ DỤNG TRONG ỨNG DỤNG FLUTTER

### 1. Lấy Anon Public Key
- Vào Supabase Dashboard -> **Project Settings** -> **API**.
- Tại mục **Project API keys**, copy mã **`anon` `public`** (chuỗi ký tự dài bắt đầu bằng `eyJ...`).

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
    .from('novels')
    .select()
    .eq('moderation_status', 'approved')
    .order('views', ascending: false);

// Ví dụ: Đăng bình luận mới
await supabase.from('comments').insert({
  'novel_id': 1,
  'chapter_id': 10001,
  'user_id': 1,
  'user_name': 'Độc giả',
  'content': 'Truyện hay quá!',
  'stars': 5,
  'created_at': DateTime.now().millisecondsSinceEpoch,
});
```
