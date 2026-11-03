-- =============================================================================
-- DỮ LIỆU KHỞI TẠO (SEED DATA) NOVELREADER CHO SUPABASE
-- =============================================================================

-- 1. TÀI KHOẢN MẪU (Admin, Author, Reader)
INSERT INTO public.nguoi_dung (id, email, password_hash, salt, display_name, avatar, avatar_frame, role, is_author, status, linh_thach, streak, has_streak_shield, pinned_achievements, unlocked_items, secret_question, secret_answer_hash, must_change_password, last_active_at, created_at)
VALUES
(1, 'admin@novelreader.local', '42c2a0d1656bc6936ee22ecbca81313426e6423971c69c6fcfa0a066b26ecf17', 'nr_salt_admin', 'Quản Trị Viên Tối Cao', '👑', 'gold', 'admin', 1, 'active', 9999, 15, 1, 'mot_sach,kien_tri_30,doc_gia_toan_nang', 'default,gold,jade,neon,sepia_pro', 'Thể loại truyện yêu thích của bạn là gì?', '', 1, 1793630000000, 1788440000000),
(2, 'author@novelreader.local', 'bfca33cce7a08fb92795cf643f80c65aa1b16259fba75490fe4bcbcfa5d070b4', 'nr_salt_author', 'Bút Mặc Tiên Sinh', '🪶', 'jade', 'user', 1, 'active', 450, 7, 0, 'cay_but_tre,khoi_dau', 'default,jade', 'Thể loại truyện yêu thích của bạn là gì?', '', 0, 1793630000000, 1791040000000),
(3, 'user@novelreader.local', '4c84a51ebaf569503ea29e7978297b69c73d577002ca658510cf2e252654d3d8', 'nr_salt_user', 'Bảo Ngọc Độc Giả', '🦊', 'default', 'user', 0, 'active', 220, 5, 0, 'khoi_dau,lu_khach', 'default', 'Thể loại truyện yêu thích của bạn là gì?', '', 0, 1793630000000, 1792420000000)
ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email;
SELECT setval('public.nguoi_dung_id_seq', (SELECT MAX(id) FROM public.nguoi_dung));


-- 2. 20 HUY HIỆU THÀNH TỰU MẶC ĐỊNH
INSERT INTO public.thanh_tuu (code, name, description, icon, rule_json) VALUES
('khoi_dau', 'Khởi Đầu Hành Trình', 'Hoàn thành chương truyện đầu tiên.', '🌱', '{"type":"chapters","count":1}'),
('cu_dem', 'Cú Đêm', 'Đọc truyện sau 0 giờ đêm đủ 5 lần.', '🦉', '{"type":"night_reads","count":5}'),
('mot_sach', 'Mọt Sách Chính Hiệu', 'Đọc tổng cộng 100 chương truyện.', '📚', '{"type":"chapters","count":100}'),
('chung_thuy', 'Độc Giả Chung Thủy', 'Hoàn thành một bộ truyện dài từ 5 chương trở lên.', '💎', '{"type":"finish_long_novel","count":1}'),
('tham_tu', 'Thám Tử Lừng Danh', 'Đọc hết 3 bộ truyện thuộc thể loại Trinh thám.', '🕵️', '{"type":"genre","genre":"Trinh thám","count":3}'),
('lu_khach', 'Lữ Khách Đa Vũ Trụ', 'Khám phá đủ 6 thể loại truyện khác nhau.', '🧭', '{"type":"distinct_genres","count":6}'),
('kien_tri_7', 'Chuỗi Lửa 7 Ngày', 'Duy trì chuỗi đọc liên tiếp (Streak) 7 ngày.', '🔥', '{"type":"streak","count":7}'),
('kien_tri_30', 'Bậc Thầy Kỷ Luật', 'Duy trì chuỗi đọc liên tiếp (Streak) 30 ngày.', '👑', '{"type":"streak","count":30}'),
('nha_phe_binh', 'Nhà Phê Bình Sắc Sảo', 'Đăng 5 bình luận chia sẻ cảm nghĩ dưới chương truyện.', '✍️', '{"type":"comments","count":5}'),
('suu_tam_trich_dan', 'Người Lưu Giữ Ký Ức', 'Lưu 5 thẻ trích dẫn (Quote Card) tâm đắc.', '🔖', '{"type":"quotes","count":5}'),
('toc_do_anh_sang', 'Tốc Độ Ánh Sáng', 'Trải nghiệm chế độ đọc nhanh RSVP từ 300 từ/phút.', '⚡', '{"type":"rsvp","count":1}'),
('thin_hinh_am_thanh', 'Thính Giả Đêm Khuya', 'Sử dụng TTS hoặc Ambient Mixer khi đọc truyện.', '🎧', '{"type":"audio","count":1}'),
('kham_pha_xray', 'Nhà Khảo Cổ X-Ray', 'Ghim nhân vật yêu thích vào Sổ tay nhân vật.', '🔍', '{"type":"xray_pin","count":1}'),
('cay_but_tre', 'Cây Bút Trẻ', 'Sáng tác và gửi duyệt tác phẩm đầu tay.', '🪶', '{"type":"author_submit","count":1}'),
('dai_gia_linh_thach', 'Phú Gia Linh Thạch', 'Tích lũy đạt mốc 500 Linh Thạch.', '💠', '{"type":"linh_thach","count":500}'),
('nguoi_gac_dem', 'Người Gác Đền Tri Thức', 'Đọc tổng cộng hơn 10.000 từ.', '🏛️', '{"type":"words","count":10000}'),
('doc_gia_toan_nang', 'Độc Giả Toàn Năng', 'Đọc cả 3 loại: Truyện chữ, Light Novel và Truyện tranh.', '🌟', '{"type":"all_types","count":3}'),
('nguoi_gui_thoi_gian', 'Lữ Khách Thời Gian', 'Gửi một bức thư vào Hộp thư thời gian (Time Capsule).', '⏳', '{"type":"time_capsule","count":1}'),
('truyen_tranh_fan', 'Tín Đồ Manga & Webtoon', 'Đọc 5 chương truyện tranh.', '🎨', '{"type":"comic_chapters","count":5}'),
('light_novel_fan', 'Hiệp Sĩ Light Novel', 'Đọc 5 chương Light Novel có minh họa.', '⚔️', '{"type":"ln_chapters","count":5}')
ON CONFLICT (code) DO NOTHING;

-- 3. NHIỆM VỤ MẪU
INSERT INTO public.nhiem_vu (id, type, title, goal_type, goal_value, reward, starts_at, ends_at, is_active)
VALUES
(1, 'daily', 'Đọc truyện 15 phút mỗi ngày', 'read_minutes', 15, 25, 1793600000000, 1825000000000, 1),
(2, 'daily', 'Hoàn thành 2 chương truyện bất kỳ', 'read_chapters', 2, 30, 1793600000000, 1825000000000, 1),
(3, 'daily', 'Chia sẻ 1 bình luận cảm nhận chương', 'comment', 1, 20, 1793600000000, 1825000000000, 1),
(4, 'weekly', 'Đọc đủ 60 phút trong tuần', 'read_minutes', 60, 100, 1793600000000, 1825000000000, 1),
(5, 'weekly', 'Hoàn thành trọn vẹn 1 bộ truyện', 'finish_novel', 1, 150, 1793600000000, 1825000000000, 1),
(6, 'event', 'Sự kiện Tuần Lễ Trinh Thám & Kỳ Ảo: Đọc 3 chương', 'read_chapters', 3, 120, 1793600000000, 1800000000000, 1)
ON CONFLICT (id) DO NOTHING;
SELECT setval('public.nhiem_vu_id_seq', (SELECT MAX(id) FROM public.nhiem_vu));

-- 4. CẤU HÌNH HỆ THỐNG VÀ TỪ KHÓA BỊ CẤM
INSERT INTO public.cau_hinh_ung_dung (key, value) VALUES
('maintenance_mode', 'false'),
('maintenance_message', 'Hệ thống đang bảo trì nâng cấp máy chủ định kỳ. Vui lòng quay lại sau ít phút!'),
('feature_tts', 'true'),
('feature_comments', 'true'),
('feature_registration', 'true'),
('max_offline_chapters', '200')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

INSERT INTO public.tu_cam (word) VALUES
('lừa đảo'),
('spam_link'),
('cá độ'),
('chửi_thề_xấu')
ON CONFLICT (word) DO NOTHING;

-- 5. THUẬT NGỮ VÀ TÓM TẮT CHƯƠNG MẪU
INSERT INTO public.thuat_ngu (id, novel_id, term, meaning, first_chapter_index) VALUES
(1, 1, 'Linh khí', 'Năng lượng tinh thuần của trời đất mà tu sĩ hấp thu để rèn luyện kinh mạch và đột phá cảnh giới.', 1),
(2, 1, 'Trúc Cơ', 'Cảnh giới thứ hai trên con đường tu tiên, đặt nền móng vững chắc cho đạo cơ trước khi kết Kim Đan.', 1),
(3, 1, 'Kim Đan', 'Cảnh giới đại năng khi linh lực ngưng tụ thành viên đan vàng rực trong đan điền, thọ nguyên tăng vọt.', 2),
(4, 2, 'Ma pháp trận', 'Vòng tròn cổ ngữ khắc họa dòng chảy mana để triệu hồi hoặc kích hoạt phép thuật cấp cao.', 1),
(5, 3, 'Hồ sơ mật', 'Tập tài liệu điều tra chưa từng công bố của thanh tra về chuỗi án mạng liên hoàn.', 1)
ON CONFLICT (id) DO NOTHING;
SELECT setval('public.thuat_ngu_id_seq', (SELECT MAX(id) FROM public.thuat_ngu));

INSERT INTO public.tom_tat_chuong (chapter_id, novel_id, chapter_index, summary) VALUES
(10001, 1, 1, 'Nhân vật chính tình cờ phát hiện cổ vật ẩn chứa truyền thừa tu tiên giữa đêm mưa bão.'),
(10002, 1, 2, 'Bước đầu cảm ứng linh khí, vượt qua khảo nghiệm nhập môn và đối mặt kẻ thù đầu tiên.'),
(20001, 2, 1, 'Chuyển sinh sang thế giới kiếm và ma thuật, thức tỉnh kỹ năng thẩm định hiếm có.')
ON CONFLICT (chapter_id) DO NOTHING;
