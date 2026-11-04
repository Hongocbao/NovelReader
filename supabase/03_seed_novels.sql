-- =============================================================================
-- SEED 40 TÁC PHẨM TRUYỆN CHỮ CÓ DẤU & 40 THỂ LOẠI (400 CHƯƠNG)
-- =============================================================================

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (1, 'Kiếm Đạo Vấn Thiên', 'Lâm Phong Vũ', 'https://picsum.photos/seed/novelreader-v3-1/300/450', 'Lục Trần vốn chỉ là một đệ tử tạp dịch bị coi thường của Thanh Vân Tông. Một đêm mưa gió, cậu tình cờ nhặt được thanh kiếm gãy chứa đựng tàn hồn của một kiếm tiên thượng cổ. Từ đó, con đường hỏi kiếm trời xanh chính thức mở ra.', 'ongoing', 'novel', 'Tiên hiệp,Hành động,Kiếm hiệp', 10, 4.8, 1250000, 1793800000000, 'kiem dao van thien lam phong vu', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(10001, 1, 1, 'Chương 1: Đệ tử tạp dịch', '【Chương 1: Đệ tử tạp dịch】 Câu chuyện của tác phẩm "Kiếm Đạo Vấn Thiên" (tác giả: Lâm Phong Vũ, thể loại: Tiên hiệp, Hành động, Kiếm hiệp) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Lục Trần vốn chỉ là một đệ tử tạp dịch bị coi thường của Thanh Vân Tông. Một đêm mưa gió, cậu tình cờ nhặt được thanh kiếm gãy chứa đựng tàn hồn của một kiếm tiên thượng cổ. Từ đó, con đường hỏi kiếm trời xanh chính thức mở ra.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: đệ tử tạp dịch, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Đạo Vấn Thiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Đệ tử tạp dịch tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Đệ tử tạp dịch —'),
(10002, 1, 2, 'Chương 2: Thanh kiếm gãy trong đêm mưa', '【Chương 2: Thanh kiếm gãy trong đêm mưa】 Câu chuyện của tác phẩm "Kiếm Đạo Vấn Thiên" (tác giả: Lâm Phong Vũ, thể loại: Tiên hiệp, Hành động, Kiếm hiệp) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Lục Trần vốn chỉ là một đệ tử tạp dịch bị coi thường của Thanh Vân Tông. Một đêm mưa gió, cậu tình cờ nhặt được thanh kiếm gãy chứa đựng tàn hồn của một kiếm tiên thượng cổ. Từ đó, con đường hỏi kiếm trời xanh chính thức mở ra.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: thanh kiếm gãy trong đêm mưa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Đạo Vấn Thiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Thanh kiếm gãy trong đêm mưa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Thanh kiếm gãy trong đêm mưa —'),
(10003, 1, 3, 'Chương 3: Tàn hồn kiếm tiên', '【Chương 3: Tàn hồn kiếm tiên】 Câu chuyện của tác phẩm "Kiếm Đạo Vấn Thiên" (tác giả: Lâm Phong Vũ, thể loại: Tiên hiệp, Hành động, Kiếm hiệp) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Lục Trần vốn chỉ là một đệ tử tạp dịch bị coi thường của Thanh Vân Tông. Một đêm mưa gió, cậu tình cờ nhặt được thanh kiếm gãy chứa đựng tàn hồn của một kiếm tiên thượng cổ. Từ đó, con đường hỏi kiếm trời xanh chính thức mở ra.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: tàn hồn kiếm tiên, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Đạo Vấn Thiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Tàn hồn kiếm tiên tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Tàn hồn kiếm tiên —'),
(10004, 1, 4, 'Chương 4: Bước đầu dẫn khí nhập thể', '【Chương 4: Bước đầu dẫn khí nhập thể】 Câu chuyện của tác phẩm "Kiếm Đạo Vấn Thiên" (tác giả: Lâm Phong Vũ, thể loại: Tiên hiệp, Hành động, Kiếm hiệp) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Lục Trần vốn chỉ là một đệ tử tạp dịch bị coi thường của Thanh Vân Tông. Một đêm mưa gió, cậu tình cờ nhặt được thanh kiếm gãy chứa đựng tàn hồn của một kiếm tiên thượng cổ. Từ đó, con đường hỏi kiếm trời xanh chính thức mở ra.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: bước đầu dẫn khí nhập thể, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Đạo Vấn Thiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Bước đầu dẫn khí nhập thể tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Bước đầu dẫn khí nhập thể —'),
(10005, 1, 5, 'Chương 5: Khảo hạch ngoại môn', '【Chương 5: Khảo hạch ngoại môn】 Câu chuyện của tác phẩm "Kiếm Đạo Vấn Thiên" (tác giả: Lâm Phong Vũ, thể loại: Tiên hiệp, Hành động, Kiếm hiệp) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Lục Trần vốn chỉ là một đệ tử tạp dịch bị coi thường của Thanh Vân Tông. Một đêm mưa gió, cậu tình cờ nhặt được thanh kiếm gãy chứa đựng tàn hồn của một kiếm tiên thượng cổ. Từ đó, con đường hỏi kiếm trời xanh chính thức mở ra.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: khảo hạch ngoại môn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Đạo Vấn Thiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Khảo hạch ngoại môn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Khảo hạch ngoại môn —'),
(10006, 1, 6, 'Chương 6: Đối thủ đầu tiên', '【Chương 6: Đối thủ đầu tiên】 Câu chuyện của tác phẩm "Kiếm Đạo Vấn Thiên" (tác giả: Lâm Phong Vũ, thể loại: Tiên hiệp, Hành động, Kiếm hiệp) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Lục Trần vốn chỉ là một đệ tử tạp dịch bị coi thường của Thanh Vân Tông. Một đêm mưa gió, cậu tình cờ nhặt được thanh kiếm gãy chứa đựng tàn hồn của một kiếm tiên thượng cổ. Từ đó, con đường hỏi kiếm trời xanh chính thức mở ra.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: đối thủ đầu tiên, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Đạo Vấn Thiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Đối thủ đầu tiên tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Đối thủ đầu tiên —'),
(10007, 1, 7, 'Chương 7: Nhất kiếm phá vạn pháp', '【Chương 7: Nhất kiếm phá vạn pháp】 Câu chuyện của tác phẩm "Kiếm Đạo Vấn Thiên" (tác giả: Lâm Phong Vũ, thể loại: Tiên hiệp, Hành động, Kiếm hiệp) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Lục Trần vốn chỉ là một đệ tử tạp dịch bị coi thường của Thanh Vân Tông. Một đêm mưa gió, cậu tình cờ nhặt được thanh kiếm gãy chứa đựng tàn hồn của một kiếm tiên thượng cổ. Từ đó, con đường hỏi kiếm trời xanh chính thức mở ra.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: nhất kiếm phá vạn pháp, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Đạo Vấn Thiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Nhất kiếm phá vạn pháp tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Nhất kiếm phá vạn pháp —'),
(10008, 1, 8, 'Chương 8: Bí cảnh Thanh Vân', '【Chương 8: Bí cảnh Thanh Vân】 Câu chuyện của tác phẩm "Kiếm Đạo Vấn Thiên" (tác giả: Lâm Phong Vũ, thể loại: Tiên hiệp, Hành động, Kiếm hiệp) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Lục Trần vốn chỉ là một đệ tử tạp dịch bị coi thường của Thanh Vân Tông. Một đêm mưa gió, cậu tình cờ nhặt được thanh kiếm gãy chứa đựng tàn hồn của một kiếm tiên thượng cổ. Từ đó, con đường hỏi kiếm trời xanh chính thức mở ra.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: bí cảnh thanh vân, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Đạo Vấn Thiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Bí cảnh Thanh Vân tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Bí cảnh Thanh Vân —'),
(10009, 1, 9, 'Chương 9: Tranh đoạt linh dược', '【Chương 9: Tranh đoạt linh dược】 Câu chuyện của tác phẩm "Kiếm Đạo Vấn Thiên" (tác giả: Lâm Phong Vũ, thể loại: Tiên hiệp, Hành động, Kiếm hiệp) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Lục Trần vốn chỉ là một đệ tử tạp dịch bị coi thường của Thanh Vân Tông. Một đêm mưa gió, cậu tình cờ nhặt được thanh kiếm gãy chứa đựng tàn hồn của một kiếm tiên thượng cổ. Từ đó, con đường hỏi kiếm trời xanh chính thức mở ra.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: tranh đoạt linh dược, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Đạo Vấn Thiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Tranh đoạt linh dược tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Tranh đoạt linh dược —'),
(10010, 1, 10, 'Chương 10: Danh chấn tông môn', '【Chương 10: Danh chấn tông môn】 Câu chuyện của tác phẩm "Kiếm Đạo Vấn Thiên" (tác giả: Lâm Phong Vũ, thể loại: Tiên hiệp, Hành động, Kiếm hiệp) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Lục Trần vốn chỉ là một đệ tử tạp dịch bị coi thường của Thanh Vân Tông. Một đêm mưa gió, cậu tình cờ nhặt được thanh kiếm gãy chứa đựng tàn hồn của một kiếm tiên thượng cổ. Từ đó, con đường hỏi kiếm trời xanh chính thức mở ra.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: danh chấn tông môn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Đạo Vấn Thiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Danh chấn tông môn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Danh chấn tông môn —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (2, 'Mùa Hạ Năm Ấy Có Anh', 'Diệp An Nhiên', 'https://picsum.photos/seed/novelreader-v3-2/300/450', 'Sau bảy năm xa cách, Hạ Vy bất ngờ gặp lại Cố Minh Thành — mối tình đầu thời trung học nay đã trở thành kiến trúc sư danh tiếng. Những hiểu lầm năm xưa dần được tháo gỡ giữa nắng vàng rực rỡ của mùa hạ.', 'completed', 'novel', 'Ngôn tình,Đô thị,Thanh xuân', 10, 4.7, 980000, 1793800000000, 'mua ha nam ay co anh diep an nhien', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(20001, 2, 1, 'Chương 1: Cuộc hội ngộ nơi sân bay', '【Chương 1: Cuộc hội ngộ nơi sân bay】 Câu chuyện của tác phẩm "Mùa Hạ Năm Ấy Có Anh" (tác giả: Diệp An Nhiên, thể loại: Ngôn tình, Đô thị, Thanh xuân) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau bảy năm xa cách, Hạ Vy bất ngờ gặp lại Cố Minh Thành — mối tình đầu thời trung học nay đã trở thành kiến trúc sư danh tiếng. Những hiểu lầm năm xưa dần được tháo gỡ giữa nắng vàng rực rỡ của mùa hạ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: cuộc hội ngộ nơi sân bay, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Mùa Hạ Năm Ấy Có Anh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Cuộc hội ngộ nơi sân bay tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Cuộc hội ngộ nơi sân bay —'),
(20002, 2, 2, 'Chương 2: Bản thiết kế dang dở', '【Chương 2: Bản thiết kế dang dở】 Câu chuyện của tác phẩm "Mùa Hạ Năm Ấy Có Anh" (tác giả: Diệp An Nhiên, thể loại: Ngôn tình, Đô thị, Thanh xuân) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau bảy năm xa cách, Hạ Vy bất ngờ gặp lại Cố Minh Thành — mối tình đầu thời trung học nay đã trở thành kiến trúc sư danh tiếng. Những hiểu lầm năm xưa dần được tháo gỡ giữa nắng vàng rực rỡ của mùa hạ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: bản thiết kế dang dở, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Mùa Hạ Năm Ấy Có Anh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Bản thiết kế dang dở tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Bản thiết kế dang dở —'),
(20003, 2, 3, 'Chương 3: Cơn mưa rào năm mười bảy tuổi', '【Chương 3: Cơn mưa rào năm mười bảy tuổi】 Câu chuyện của tác phẩm "Mùa Hạ Năm Ấy Có Anh" (tác giả: Diệp An Nhiên, thể loại: Ngôn tình, Đô thị, Thanh xuân) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau bảy năm xa cách, Hạ Vy bất ngờ gặp lại Cố Minh Thành — mối tình đầu thời trung học nay đã trở thành kiến trúc sư danh tiếng. Những hiểu lầm năm xưa dần được tháo gỡ giữa nắng vàng rực rỡ của mùa hạ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: cơn mưa rào năm mười bảy tuổi, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Mùa Hạ Năm Ấy Có Anh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Cơn mưa rào năm mười bảy tuổi tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Cơn mưa rào năm mười bảy tuổi —'),
(20004, 2, 4, 'Chương 4: Bữa tối dưới ánh nến', '【Chương 4: Bữa tối dưới ánh nến】 Câu chuyện của tác phẩm "Mùa Hạ Năm Ấy Có Anh" (tác giả: Diệp An Nhiên, thể loại: Ngôn tình, Đô thị, Thanh xuân) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau bảy năm xa cách, Hạ Vy bất ngờ gặp lại Cố Minh Thành — mối tình đầu thời trung học nay đã trở thành kiến trúc sư danh tiếng. Những hiểu lầm năm xưa dần được tháo gỡ giữa nắng vàng rực rỡ của mùa hạ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: bữa tối dưới ánh nến, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Mùa Hạ Năm Ấy Có Anh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Bữa tối dưới ánh nến tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Bữa tối dưới ánh nến —'),
(20005, 2, 5, 'Chương 5: Bức thư chưa kịp gửi', '【Chương 5: Bức thư chưa kịp gửi】 Câu chuyện của tác phẩm "Mùa Hạ Năm Ấy Có Anh" (tác giả: Diệp An Nhiên, thể loại: Ngôn tình, Đô thị, Thanh xuân) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau bảy năm xa cách, Hạ Vy bất ngờ gặp lại Cố Minh Thành — mối tình đầu thời trung học nay đã trở thành kiến trúc sư danh tiếng. Những hiểu lầm năm xưa dần được tháo gỡ giữa nắng vàng rực rỡ của mùa hạ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: bức thư chưa kịp gửi, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Mùa Hạ Năm Ấy Có Anh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Bức thư chưa kịp gửi tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Bức thư chưa kịp gửi —'),
(20006, 2, 6, 'Chương 6: Lời thú nhận muộn màng', '【Chương 6: Lời thú nhận muộn màng】 Câu chuyện của tác phẩm "Mùa Hạ Năm Ấy Có Anh" (tác giả: Diệp An Nhiên, thể loại: Ngôn tình, Đô thị, Thanh xuân) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau bảy năm xa cách, Hạ Vy bất ngờ gặp lại Cố Minh Thành — mối tình đầu thời trung học nay đã trở thành kiến trúc sư danh tiếng. Những hiểu lầm năm xưa dần được tháo gỡ giữa nắng vàng rực rỡ của mùa hạ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: lời thú nhận muộn màng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Mùa Hạ Năm Ấy Có Anh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Lời thú nhận muộn màng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Lời thú nhận muộn màng —'),
(20007, 2, 7, 'Chương 7: Giông bão gia tộc', '【Chương 7: Giông bão gia tộc】 Câu chuyện của tác phẩm "Mùa Hạ Năm Ấy Có Anh" (tác giả: Diệp An Nhiên, thể loại: Ngôn tình, Đô thị, Thanh xuân) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau bảy năm xa cách, Hạ Vy bất ngờ gặp lại Cố Minh Thành — mối tình đầu thời trung học nay đã trở thành kiến trúc sư danh tiếng. Những hiểu lầm năm xưa dần được tháo gỡ giữa nắng vàng rực rỡ của mùa hạ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: giông bão gia tộc, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Mùa Hạ Năm Ấy Có Anh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Giông bão gia tộc tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Giông bão gia tộc —'),
(20008, 2, 8, 'Chương 8: Nắm tay đi qua ngày giông', '【Chương 8: Nắm tay đi qua ngày giông】 Câu chuyện của tác phẩm "Mùa Hạ Năm Ấy Có Anh" (tác giả: Diệp An Nhiên, thể loại: Ngôn tình, Đô thị, Thanh xuân) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau bảy năm xa cách, Hạ Vy bất ngờ gặp lại Cố Minh Thành — mối tình đầu thời trung học nay đã trở thành kiến trúc sư danh tiếng. Những hiểu lầm năm xưa dần được tháo gỡ giữa nắng vàng rực rỡ của mùa hạ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: nắm tay đi qua ngày giông, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Mùa Hạ Năm Ấy Có Anh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Nắm tay đi qua ngày giông tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Nắm tay đi qua ngày giông —'),
(20009, 2, 9, 'Chương 9: Hẹn ước dưới tán phượng vĩ', '【Chương 9: Hẹn ước dưới tán phượng vĩ】 Câu chuyện của tác phẩm "Mùa Hạ Năm Ấy Có Anh" (tác giả: Diệp An Nhiên, thể loại: Ngôn tình, Đô thị, Thanh xuân) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau bảy năm xa cách, Hạ Vy bất ngờ gặp lại Cố Minh Thành — mối tình đầu thời trung học nay đã trở thành kiến trúc sư danh tiếng. Những hiểu lầm năm xưa dần được tháo gỡ giữa nắng vàng rực rỡ của mùa hạ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: hẹn ước dưới tán phượng vĩ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Mùa Hạ Năm Ấy Có Anh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Hẹn ước dưới tán phượng vĩ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Hẹn ước dưới tán phượng vĩ —'),
(20010, 2, 10, 'Chương 10: Mùa hạ vĩnh cửu của đôi ta', '【Chương 10: Mùa hạ vĩnh cửu của đôi ta】 Câu chuyện của tác phẩm "Mùa Hạ Năm Ấy Có Anh" (tác giả: Diệp An Nhiên, thể loại: Ngôn tình, Đô thị, Thanh xuân) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau bảy năm xa cách, Hạ Vy bất ngờ gặp lại Cố Minh Thành — mối tình đầu thời trung học nay đã trở thành kiến trúc sư danh tiếng. Những hiểu lầm năm xưa dần được tháo gỡ giữa nắng vàng rực rỡ của mùa hạ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: mùa hạ vĩnh cửu của đôi ta, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Mùa Hạ Năm Ấy Có Anh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Mùa hạ vĩnh cửu của đôi ta tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Mùa hạ vĩnh cửu của đôi ta —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (3, 'Thám Tử Phố Cổ', 'Trần Minh Khuê', 'https://picsum.photos/seed/novelreader-v3-3/300/450', 'Giữa lòng ba mươi sáu phố phường Hà Nội cổ kính, thám tử tư Hoàng Bách cùng nữ pháp y Lan Khuê liên tiếp giải mã những vụ án hóc búa ẩn giấu đằng sau các cổ vật trăm năm.', 'ongoing', 'novel', 'Trinh thám,Hình sự,Đô thị', 10, 4.8, 870000, 1793800000000, 'tham tu pho co tran minh khue', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(30001, 3, 1, 'Chương 1: Mật mã trên chiếc bình gốm cổ', '【Chương 1: Mật mã trên chiếc bình gốm cổ】 Câu chuyện của tác phẩm "Thám Tử Phố Cổ" (tác giả: Trần Minh Khuê, thể loại: Trinh thám, Hình sự, Đô thị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa lòng ba mươi sáu phố phường Hà Nội cổ kính, thám tử tư Hoàng Bách cùng nữ pháp y Lan Khuê liên tiếp giải mã những vụ án hóc búa ẩn giấu đằng sau các cổ vật trăm năm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: mật mã trên chiếc bình gốm cổ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thám Tử Phố Cổ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Mật mã trên chiếc bình gốm cổ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Mật mã trên chiếc bình gốm cổ —'),
(30002, 3, 2, 'Chương 2: Bóng người dưới mái ngói rêu phong', '【Chương 2: Bóng người dưới mái ngói rêu phong】 Câu chuyện của tác phẩm "Thám Tử Phố Cổ" (tác giả: Trần Minh Khuê, thể loại: Trinh thám, Hình sự, Đô thị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa lòng ba mươi sáu phố phường Hà Nội cổ kính, thám tử tư Hoàng Bách cùng nữ pháp y Lan Khuê liên tiếp giải mã những vụ án hóc búa ẩn giấu đằng sau các cổ vật trăm năm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: bóng người dưới mái ngói rêu phong, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thám Tử Phố Cổ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Bóng người dưới mái ngói rêu phong tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Bóng người dưới mái ngói rêu phong —'),
(30003, 3, 3, 'Chương 3: Dấu vân tay thứ ba', '【Chương 3: Dấu vân tay thứ ba】 Câu chuyện của tác phẩm "Thám Tử Phố Cổ" (tác giả: Trần Minh Khuê, thể loại: Trinh thám, Hình sự, Đô thị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa lòng ba mươi sáu phố phường Hà Nội cổ kính, thám tử tư Hoàng Bách cùng nữ pháp y Lan Khuê liên tiếp giải mã những vụ án hóc búa ẩn giấu đằng sau các cổ vật trăm năm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: dấu vân tay thứ ba, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thám Tử Phố Cổ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Dấu vân tay thứ ba tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Dấu vân tay thứ ba —'),
(30004, 3, 4, 'Chương 4: Nhân chứng trong con ngõ nhỏ', '【Chương 4: Nhân chứng trong con ngõ nhỏ】 Câu chuyện của tác phẩm "Thám Tử Phố Cổ" (tác giả: Trần Minh Khuê, thể loại: Trinh thám, Hình sự, Đô thị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa lòng ba mươi sáu phố phường Hà Nội cổ kính, thám tử tư Hoàng Bách cùng nữ pháp y Lan Khuê liên tiếp giải mã những vụ án hóc búa ẩn giấu đằng sau các cổ vật trăm năm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: nhân chứng trong con ngõ nhỏ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thám Tử Phố Cổ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Nhân chứng trong con ngõ nhỏ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Nhân chứng trong con ngõ nhỏ —'),
(30005, 3, 5, 'Chương 5: Tiếng chuông đồng hồ lúc nửa đêm', '【Chương 5: Tiếng chuông đồng hồ lúc nửa đêm】 Câu chuyện của tác phẩm "Thám Tử Phố Cổ" (tác giả: Trần Minh Khuê, thể loại: Trinh thám, Hình sự, Đô thị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa lòng ba mươi sáu phố phường Hà Nội cổ kính, thám tử tư Hoàng Bách cùng nữ pháp y Lan Khuê liên tiếp giải mã những vụ án hóc búa ẩn giấu đằng sau các cổ vật trăm năm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: tiếng chuông đồng hồ lúc nửa đêm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thám Tử Phố Cổ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Tiếng chuông đồng hồ lúc nửa đêm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Tiếng chuông đồng hồ lúc nửa đêm —'),
(30006, 3, 6, 'Chương 6: Hồ sơ mật năm 1945', '【Chương 6: Hồ sơ mật năm 1945】 Câu chuyện của tác phẩm "Thám Tử Phố Cổ" (tác giả: Trần Minh Khuê, thể loại: Trinh thám, Hình sự, Đô thị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa lòng ba mươi sáu phố phường Hà Nội cổ kính, thám tử tư Hoàng Bách cùng nữ pháp y Lan Khuê liên tiếp giải mã những vụ án hóc búa ẩn giấu đằng sau các cổ vật trăm năm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: hồ sơ mật năm 1945, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thám Tử Phố Cổ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Hồ sơ mật năm 1945 tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Hồ sơ mật năm 1945 —'),
(30007, 3, 7, 'Chương 7: Cuộc đấu trí trên cầu Long Biên', '【Chương 7: Cuộc đấu trí trên cầu Long Biên】 Câu chuyện của tác phẩm "Thám Tử Phố Cổ" (tác giả: Trần Minh Khuê, thể loại: Trinh thám, Hình sự, Đô thị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa lòng ba mươi sáu phố phường Hà Nội cổ kính, thám tử tư Hoàng Bách cùng nữ pháp y Lan Khuê liên tiếp giải mã những vụ án hóc búa ẩn giấu đằng sau các cổ vật trăm năm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: cuộc đấu trí trên cầu long biên, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thám Tử Phố Cổ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Cuộc đấu trí trên cầu Long Biên tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Cuộc đấu trí trên cầu Long Biên —'),
(30008, 3, 8, 'Chương 8: Chiếc chìa khóa đồng thau', '【Chương 8: Chiếc chìa khóa đồng thau】 Câu chuyện của tác phẩm "Thám Tử Phố Cổ" (tác giả: Trần Minh Khuê, thể loại: Trinh thám, Hình sự, Đô thị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa lòng ba mươi sáu phố phường Hà Nội cổ kính, thám tử tư Hoàng Bách cùng nữ pháp y Lan Khuê liên tiếp giải mã những vụ án hóc búa ẩn giấu đằng sau các cổ vật trăm năm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: chiếc chìa khóa đồng thau, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thám Tử Phố Cổ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Chiếc chìa khóa đồng thau tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Chiếc chìa khóa đồng thau —'),
(30009, 3, 9, 'Chương 9: Sự thật phía sau bức tranh lụa', '【Chương 9: Sự thật phía sau bức tranh lụa】 Câu chuyện của tác phẩm "Thám Tử Phố Cổ" (tác giả: Trần Minh Khuê, thể loại: Trinh thám, Hình sự, Đô thị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa lòng ba mươi sáu phố phường Hà Nội cổ kính, thám tử tư Hoàng Bách cùng nữ pháp y Lan Khuê liên tiếp giải mã những vụ án hóc búa ẩn giấu đằng sau các cổ vật trăm năm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: sự thật phía sau bức tranh lụa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thám Tử Phố Cổ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Sự thật phía sau bức tranh lụa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Sự thật phía sau bức tranh lụa —'),
(30010, 3, 10, 'Chương 10: Ánh bình minh trên phố Hàng Đào', '【Chương 10: Ánh bình minh trên phố Hàng Đào】 Câu chuyện của tác phẩm "Thám Tử Phố Cổ" (tác giả: Trần Minh Khuê, thể loại: Trinh thám, Hình sự, Đô thị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa lòng ba mươi sáu phố phường Hà Nội cổ kính, thám tử tư Hoàng Bách cùng nữ pháp y Lan Khuê liên tiếp giải mã những vụ án hóc búa ẩn giấu đằng sau các cổ vật trăm năm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: ánh bình minh trên phố hàng đào, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thám Tử Phố Cổ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Ánh bình minh trên phố Hàng Đào tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Ánh bình minh trên phố Hàng Đào —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (4, 'Đô Thị Chí Tôn Y Thánh', 'Hàn Thiên Lâm', 'https://picsum.photos/seed/novelreader-v3-4/300/450', 'Truyền nhân cuối cùng của Cửu Chuyển Y Tiên xuống núi vào thành phố hoa lệ, vừa mở phòng khám Đông y cứu người, vừa âm thầm bảo vệ vị hônê khỏi những thế lực ngầm nguy hiểm.', 'ongoing', 'novel', 'Đô thị,Hành động,Hài hước', 10, 4.6, 920000, 1793800000000, 'do thi chi ton y thanh han thien lam', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(40001, 4, 1, 'Chương 1: Thần y xuống núi', '【Chương 1: Thần y xuống núi】 Câu chuyện của tác phẩm "Đô Thị Chí Tôn Y Thánh" (tác giả: Hàn Thiên Lâm, thể loại: Đô thị, Hành động, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Truyền nhân cuối cùng của Cửu Chuyển Y Tiên xuống núi vào thành phố hoa lệ, vừa mở phòng khám Đông y cứu người, vừa âm thầm bảo vệ vị hônê khỏi những thế lực ngầm nguy hiểm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: thần y xuống núi, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đô Thị Chí Tôn Y Thánh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Thần y xuống núi tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Thần y xuống núi —'),
(40002, 4, 2, 'Chương 2: Chín mũi kim bạc cứu mạng', '【Chương 2: Chín mũi kim bạc cứu mạng】 Câu chuyện của tác phẩm "Đô Thị Chí Tôn Y Thánh" (tác giả: Hàn Thiên Lâm, thể loại: Đô thị, Hành động, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Truyền nhân cuối cùng của Cửu Chuyển Y Tiên xuống núi vào thành phố hoa lệ, vừa mở phòng khám Đông y cứu người, vừa âm thầm bảo vệ vị hônê khỏi những thế lực ngầm nguy hiểm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: chín mũi kim bạc cứu mạng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đô Thị Chí Tôn Y Thánh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Chín mũi kim bạc cứu mạng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Chín mũi kim bạc cứu mạng —'),
(40003, 4, 3, 'Chương 3: Phòng khám nhỏ cuối phố', '【Chương 3: Phòng khám nhỏ cuối phố】 Câu chuyện của tác phẩm "Đô Thị Chí Tôn Y Thánh" (tác giả: Hàn Thiên Lâm, thể loại: Đô thị, Hành động, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Truyền nhân cuối cùng của Cửu Chuyển Y Tiên xuống núi vào thành phố hoa lệ, vừa mở phòng khám Đông y cứu người, vừa âm thầm bảo vệ vị hônê khỏi những thế lực ngầm nguy hiểm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: phòng khám nhỏ cuối phố, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đô Thị Chí Tôn Y Thánh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Phòng khám nhỏ cuối phố tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Phòng khám nhỏ cuối phố —'),
(40004, 4, 4, 'Chương 4: Đại hội y học phương Đông', '【Chương 4: Đại hội y học phương Đông】 Câu chuyện của tác phẩm "Đô Thị Chí Tôn Y Thánh" (tác giả: Hàn Thiên Lâm, thể loại: Đô thị, Hành động, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Truyền nhân cuối cùng của Cửu Chuyển Y Tiên xuống núi vào thành phố hoa lệ, vừa mở phòng khám Đông y cứu người, vừa âm thầm bảo vệ vị hônê khỏi những thế lực ngầm nguy hiểm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: đại hội y học phương đông, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đô Thị Chí Tôn Y Thánh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Đại hội y học phương Đông tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Đại hội y học phương Đông —'),
(40005, 4, 5, 'Chương 5: Cao thủ ẩn mình', '【Chương 5: Cao thủ ẩn mình】 Câu chuyện của tác phẩm "Đô Thị Chí Tôn Y Thánh" (tác giả: Hàn Thiên Lâm, thể loại: Đô thị, Hành động, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Truyền nhân cuối cùng của Cửu Chuyển Y Tiên xuống núi vào thành phố hoa lệ, vừa mở phòng khám Đông y cứu người, vừa âm thầm bảo vệ vị hônê khỏi những thế lực ngầm nguy hiểm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: cao thủ ẩn mình, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đô Thị Chí Tôn Y Thánh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Cao thủ ẩn mình tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Cao thủ ẩn mình —'),
(40006, 4, 6, 'Chương 6: Đơn thuốc ngàn vàng', '【Chương 6: Đơn thuốc ngàn vàng】 Câu chuyện của tác phẩm "Đô Thị Chí Tôn Y Thánh" (tác giả: Hàn Thiên Lâm, thể loại: Đô thị, Hành động, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Truyền nhân cuối cùng của Cửu Chuyển Y Tiên xuống núi vào thành phố hoa lệ, vừa mở phòng khám Đông y cứu người, vừa âm thầm bảo vệ vị hônê khỏi những thế lực ngầm nguy hiểm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: đơn thuốc ngàn vàng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đô Thị Chí Tôn Y Thánh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Đơn thuốc ngàn vàng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Đơn thuốc ngàn vàng —'),
(40007, 4, 7, 'Chương 7: Đêm mưa giải vây', '【Chương 7: Đêm mưa giải vây】 Câu chuyện của tác phẩm "Đô Thị Chí Tôn Y Thánh" (tác giả: Hàn Thiên Lâm, thể loại: Đô thị, Hành động, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Truyền nhân cuối cùng của Cửu Chuyển Y Tiên xuống núi vào thành phố hoa lệ, vừa mở phòng khám Đông y cứu người, vừa âm thầm bảo vệ vị hônê khỏi những thế lực ngầm nguy hiểm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: đêm mưa giải vây, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đô Thị Chí Tôn Y Thánh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Đêm mưa giải vây tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Đêm mưa giải vây —'),
(40008, 4, 8, 'Chương 8: Cổ phương thất truyền', '【Chương 8: Cổ phương thất truyền】 Câu chuyện của tác phẩm "Đô Thị Chí Tôn Y Thánh" (tác giả: Hàn Thiên Lâm, thể loại: Đô thị, Hành động, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Truyền nhân cuối cùng của Cửu Chuyển Y Tiên xuống núi vào thành phố hoa lệ, vừa mở phòng khám Đông y cứu người, vừa âm thầm bảo vệ vị hônê khỏi những thế lực ngầm nguy hiểm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: cổ phương thất truyền, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đô Thị Chí Tôn Y Thánh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Cổ phương thất truyền tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Cổ phương thất truyền —'),
(40009, 4, 9, 'Chương 9: Chấn động giới y đạo', '【Chương 9: Chấn động giới y đạo】 Câu chuyện của tác phẩm "Đô Thị Chí Tôn Y Thánh" (tác giả: Hàn Thiên Lâm, thể loại: Đô thị, Hành động, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Truyền nhân cuối cùng của Cửu Chuyển Y Tiên xuống núi vào thành phố hoa lệ, vừa mở phòng khám Đông y cứu người, vừa âm thầm bảo vệ vị hônê khỏi những thế lực ngầm nguy hiểm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: chấn động giới y đạo, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đô Thị Chí Tôn Y Thánh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Chấn động giới y đạo tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Chấn động giới y đạo —'),
(40010, 4, 10, 'Chương 10: Danh y hộ quốc', '【Chương 10: Danh y hộ quốc】 Câu chuyện của tác phẩm "Đô Thị Chí Tôn Y Thánh" (tác giả: Hàn Thiên Lâm, thể loại: Đô thị, Hành động, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Truyền nhân cuối cùng của Cửu Chuyển Y Tiên xuống núi vào thành phố hoa lệ, vừa mở phòng khám Đông y cứu người, vừa âm thầm bảo vệ vị hônê khỏi những thế lực ngầm nguy hiểm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: danh y hộ quốc, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đô Thị Chí Tôn Y Thánh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Danh y hộ quốc tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Danh y hộ quốc —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (5, 'Phàm Nhân Tu Tiên Lộ', 'Mộc Thanh Sơn', 'https://picsum.photos/seed/novelreader-v3-5/300/450', 'Hàn Phong sinh ra với tư chất ngũ hành tạp linh căn bình thường nhất. Nhờ một chiếc bình ngọc thần bí có khả năng thúc chín linh thảo ngàn năm và tấm lòng kiên định, cậu từng bước bước lên đỉnh cao tu tiên giới.', 'ongoing', 'novel', 'Tiên hiệp,Huyền huyễn,Phiêu lưu', 10, 4.9, 1540000, 1793800000000, 'pham nhan tu tien lo moc thanh son', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(50001, 5, 1, 'Chương 1: Chiếc bình ngọc xanh bí ẩn', '【Chương 1: Chiếc bình ngọc xanh bí ẩn】 Câu chuyện của tác phẩm "Phàm Nhân Tu Tiên Lộ" (tác giả: Mộc Thanh Sơn, thể loại: Tiên hiệp, Huyền huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Hàn Phong sinh ra với tư chất ngũ hành tạp linh căn bình thường nhất. Nhờ một chiếc bình ngọc thần bí có khả năng thúc chín linh thảo ngàn năm và tấm lòng kiên định, cậu từng bước bước lên đỉnh cao tu tiên giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: chiếc bình ngọc xanh bí ẩn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phàm Nhân Tu Tiên Lộ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Chiếc bình ngọc xanh bí ẩn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Chiếc bình ngọc xanh bí ẩn —'),
(50002, 5, 2, 'Chương 2: Ngũ hành tạp linh căn', '【Chương 2: Ngũ hành tạp linh căn】 Câu chuyện của tác phẩm "Phàm Nhân Tu Tiên Lộ" (tác giả: Mộc Thanh Sơn, thể loại: Tiên hiệp, Huyền huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Hàn Phong sinh ra với tư chất ngũ hành tạp linh căn bình thường nhất. Nhờ một chiếc bình ngọc thần bí có khả năng thúc chín linh thảo ngàn năm và tấm lòng kiên định, cậu từng bước bước lên đỉnh cao tu tiên giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: ngũ hành tạp linh căn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phàm Nhân Tu Tiên Lộ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Ngũ hành tạp linh căn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Ngũ hành tạp linh căn —'),
(50003, 5, 3, 'Chương 3: Dược viên trong thung lũng sâu', '【Chương 3: Dược viên trong thung lũng sâu】 Câu chuyện của tác phẩm "Phàm Nhân Tu Tiên Lộ" (tác giả: Mộc Thanh Sơn, thể loại: Tiên hiệp, Huyền huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Hàn Phong sinh ra với tư chất ngũ hành tạp linh căn bình thường nhất. Nhờ một chiếc bình ngọc thần bí có khả năng thúc chín linh thảo ngàn năm và tấm lòng kiên định, cậu từng bước bước lên đỉnh cao tu tiên giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: dược viên trong thung lũng sâu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phàm Nhân Tu Tiên Lộ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Dược viên trong thung lũng sâu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Dược viên trong thung lũng sâu —'),
(50004, 5, 4, 'Chương 4: Luyện chế Trúc Cơ Đan', '【Chương 4: Luyện chế Trúc Cơ Đan】 Câu chuyện của tác phẩm "Phàm Nhân Tu Tiên Lộ" (tác giả: Mộc Thanh Sơn, thể loại: Tiên hiệp, Huyền huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Hàn Phong sinh ra với tư chất ngũ hành tạp linh căn bình thường nhất. Nhờ một chiếc bình ngọc thần bí có khả năng thúc chín linh thảo ngàn năm và tấm lòng kiên định, cậu từng bước bước lên đỉnh cao tu tiên giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: luyện chế trúc cơ đan, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phàm Nhân Tu Tiên Lộ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Luyện chế Trúc Cơ Đan tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Luyện chế Trúc Cơ Đan —'),
(50005, 5, 5, 'Chương 5: Hắc Phong đạo nhân', '【Chương 5: Hắc Phong đạo nhân】 Câu chuyện của tác phẩm "Phàm Nhân Tu Tiên Lộ" (tác giả: Mộc Thanh Sơn, thể loại: Tiên hiệp, Huyền huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Hàn Phong sinh ra với tư chất ngũ hành tạp linh căn bình thường nhất. Nhờ một chiếc bình ngọc thần bí có khả năng thúc chín linh thảo ngàn năm và tấm lòng kiên định, cậu từng bước bước lên đỉnh cao tu tiên giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: hắc phong đạo nhân, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phàm Nhân Tu Tiên Lộ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Hắc Phong đạo nhân tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Hắc Phong đạo nhân —'),
(50006, 5, 6, 'Chương 6: Huyết chiến nơi hoang nguyên', '【Chương 6: Huyết chiến nơi hoang nguyên】 Câu chuyện của tác phẩm "Phàm Nhân Tu Tiên Lộ" (tác giả: Mộc Thanh Sơn, thể loại: Tiên hiệp, Huyền huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Hàn Phong sinh ra với tư chất ngũ hành tạp linh căn bình thường nhất. Nhờ một chiếc bình ngọc thần bí có khả năng thúc chín linh thảo ngàn năm và tấm lòng kiên định, cậu từng bước bước lên đỉnh cao tu tiên giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: huyết chiến nơi hoang nguyên, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phàm Nhân Tu Tiên Lộ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Huyết chiến nơi hoang nguyên tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Huyết chiến nơi hoang nguyên —'),
(50007, 5, 7, 'Chương 7: Động phủ cổ tu', '【Chương 7: Động phủ cổ tu】 Câu chuyện của tác phẩm "Phàm Nhân Tu Tiên Lộ" (tác giả: Mộc Thanh Sơn, thể loại: Tiên hiệp, Huyền huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Hàn Phong sinh ra với tư chất ngũ hành tạp linh căn bình thường nhất. Nhờ một chiếc bình ngọc thần bí có khả năng thúc chín linh thảo ngàn năm và tấm lòng kiên định, cậu từng bước bước lên đỉnh cao tu tiên giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: động phủ cổ tu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phàm Nhân Tu Tiên Lộ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Động phủ cổ tu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Động phủ cổ tu —'),
(50008, 5, 8, 'Chương 8: Kết Đan đại thành', '【Chương 8: Kết Đan đại thành】 Câu chuyện của tác phẩm "Phàm Nhân Tu Tiên Lộ" (tác giả: Mộc Thanh Sơn, thể loại: Tiên hiệp, Huyền huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Hàn Phong sinh ra với tư chất ngũ hành tạp linh căn bình thường nhất. Nhờ một chiếc bình ngọc thần bí có khả năng thúc chín linh thảo ngàn năm và tấm lòng kiên định, cậu từng bước bước lên đỉnh cao tu tiên giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: kết đan đại thành, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phàm Nhân Tu Tiên Lộ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Kết Đan đại thành tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Kết Đan đại thành —'),
(50009, 5, 9, 'Chương 9: Vượt biển Tinh Hải', '【Chương 9: Vượt biển Tinh Hải】 Câu chuyện của tác phẩm "Phàm Nhân Tu Tiên Lộ" (tác giả: Mộc Thanh Sơn, thể loại: Tiên hiệp, Huyền huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Hàn Phong sinh ra với tư chất ngũ hành tạp linh căn bình thường nhất. Nhờ một chiếc bình ngọc thần bí có khả năng thúc chín linh thảo ngàn năm và tấm lòng kiên định, cậu từng bước bước lên đỉnh cao tu tiên giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: vượt biển tinh hải, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phàm Nhân Tu Tiên Lộ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Vượt biển Tinh Hải tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Vượt biển Tinh Hải —'),
(50010, 5, 10, 'Chương 10: Tiên lộ mênh mông', '【Chương 10: Tiên lộ mênh mông】 Câu chuyện của tác phẩm "Phàm Nhân Tu Tiên Lộ" (tác giả: Mộc Thanh Sơn, thể loại: Tiên hiệp, Huyền huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Hàn Phong sinh ra với tư chất ngũ hành tạp linh căn bình thường nhất. Nhờ một chiếc bình ngọc thần bí có khả năng thúc chín linh thảo ngàn năm và tấm lòng kiên định, cậu từng bước bước lên đỉnh cao tu tiên giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: tiên lộ mênh mông, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phàm Nhân Tu Tiên Lộ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Tiên lộ mênh mông tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Tiên lộ mênh mông —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (6, 'Bí Ẩn Biệt Thự Hoa Hồng', 'Nguyễn Hà Vy', 'https://picsum.photos/seed/novelreader-v3-6/300/450', 'Một nhóm nhà nghiên cứu được mời đến căn biệt thự cổ trên đồi thông Đà Lạt vào đêm bão tuyết hiếm hoi. Từng bí mật tâm lý đen tối của các vị khách dần lộ diện khi cánh cổng sắt khép lại.', 'completed', 'novel', 'Trinh thám,Kinh dị,Tâm lý', 10, 4.7, 740000, 1793800000000, 'bi an biet thu hoa hong nguyen ha vy', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(60001, 6, 1, 'Chương 1: Thư mời từ sương mù', '【Chương 1: Thư mời từ sương mù】 Câu chuyện của tác phẩm "Bí Ẩn Biệt Thự Hoa Hồng" (tác giả: Nguyễn Hà Vy, thể loại: Trinh thám, Kinh dị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một nhóm nhà nghiên cứu được mời đến căn biệt thự cổ trên đồi thông Đà Lạt vào đêm bão tuyết hiếm hoi. Từng bí mật tâm lý đen tối của các vị khách dần lộ diện khi cánh cổng sắt khép lại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: thư mời từ sương mù, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bí Ẩn Biệt Thự Hoa Hồng", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Thư mời từ sương mù tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Thư mời từ sương mù —'),
(60002, 6, 2, 'Chương 2: Mười vị khách lạ mặt', '【Chương 2: Mười vị khách lạ mặt】 Câu chuyện của tác phẩm "Bí Ẩn Biệt Thự Hoa Hồng" (tác giả: Nguyễn Hà Vy, thể loại: Trinh thám, Kinh dị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một nhóm nhà nghiên cứu được mời đến căn biệt thự cổ trên đồi thông Đà Lạt vào đêm bão tuyết hiếm hoi. Từng bí mật tâm lý đen tối của các vị khách dần lộ diện khi cánh cổng sắt khép lại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: mười vị khách lạ mặt, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bí Ẩn Biệt Thự Hoa Hồng", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Mười vị khách lạ mặt tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Mười vị khách lạ mặt —'),
(60003, 6, 3, 'Chương 3: Bức chân dung không có mắt', '【Chương 3: Bức chân dung không có mắt】 Câu chuyện của tác phẩm "Bí Ẩn Biệt Thự Hoa Hồng" (tác giả: Nguyễn Hà Vy, thể loại: Trinh thám, Kinh dị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một nhóm nhà nghiên cứu được mời đến căn biệt thự cổ trên đồi thông Đà Lạt vào đêm bão tuyết hiếm hoi. Từng bí mật tâm lý đen tối của các vị khách dần lộ diện khi cánh cổng sắt khép lại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: bức chân dung không có mắt, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bí Ẩn Biệt Thự Hoa Hồng", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Bức chân dung không có mắt tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Bức chân dung không có mắt —'),
(60004, 6, 4, 'Chương 4: Tiếng dương cầm lúc hai giờ sáng', '【Chương 4: Tiếng dương cầm lúc hai giờ sáng】 Câu chuyện của tác phẩm "Bí Ẩn Biệt Thự Hoa Hồng" (tác giả: Nguyễn Hà Vy, thể loại: Trinh thám, Kinh dị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một nhóm nhà nghiên cứu được mời đến căn biệt thự cổ trên đồi thông Đà Lạt vào đêm bão tuyết hiếm hoi. Từng bí mật tâm lý đen tối của các vị khách dần lộ diện khi cánh cổng sắt khép lại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: tiếng dương cầm lúc hai giờ sáng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bí Ẩn Biệt Thự Hoa Hồng", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Tiếng dương cầm lúc hai giờ sáng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Tiếng dương cầm lúc hai giờ sáng —'),
(60005, 6, 5, 'Chương 5: Căn phòng khóa kín tầng áp mái', '【Chương 5: Căn phòng khóa kín tầng áp mái】 Câu chuyện của tác phẩm "Bí Ẩn Biệt Thự Hoa Hồng" (tác giả: Nguyễn Hà Vy, thể loại: Trinh thám, Kinh dị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một nhóm nhà nghiên cứu được mời đến căn biệt thự cổ trên đồi thông Đà Lạt vào đêm bão tuyết hiếm hoi. Từng bí mật tâm lý đen tối của các vị khách dần lộ diện khi cánh cổng sắt khép lại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: căn phòng khóa kín tầng áp mái, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bí Ẩn Biệt Thự Hoa Hồng", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Căn phòng khóa kín tầng áp mái tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Căn phòng khóa kín tầng áp mái —'),
(60006, 6, 6, 'Chương 6: Nhật ký của nữ chủ nhân', '【Chương 6: Nhật ký của nữ chủ nhân】 Câu chuyện của tác phẩm "Bí Ẩn Biệt Thự Hoa Hồng" (tác giả: Nguyễn Hà Vy, thể loại: Trinh thám, Kinh dị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một nhóm nhà nghiên cứu được mời đến căn biệt thự cổ trên đồi thông Đà Lạt vào đêm bão tuyết hiếm hoi. Từng bí mật tâm lý đen tối của các vị khách dần lộ diện khi cánh cổng sắt khép lại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: nhật ký của nữ chủ nhân, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bí Ẩn Biệt Thự Hoa Hồng", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Nhật ký của nữ chủ nhân tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Nhật ký của nữ chủ nhân —'),
(60007, 6, 7, 'Chương 7: Lời nói dối hoàn hảo', '【Chương 7: Lời nói dối hoàn hảo】 Câu chuyện của tác phẩm "Bí Ẩn Biệt Thự Hoa Hồng" (tác giả: Nguyễn Hà Vy, thể loại: Trinh thám, Kinh dị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một nhóm nhà nghiên cứu được mời đến căn biệt thự cổ trên đồi thông Đà Lạt vào đêm bão tuyết hiếm hoi. Từng bí mật tâm lý đen tối của các vị khách dần lộ diện khi cánh cổng sắt khép lại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: lời nói dối hoàn hảo, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bí Ẩn Biệt Thự Hoa Hồng", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Lời nói dối hoàn hảo tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Lời nói dối hoàn hảo —'),
(60008, 6, 8, 'Chương 8: Bông hồng đen thứ bảy', '【Chương 8: Bông hồng đen thứ bảy】 Câu chuyện của tác phẩm "Bí Ẩn Biệt Thự Hoa Hồng" (tác giả: Nguyễn Hà Vy, thể loại: Trinh thám, Kinh dị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một nhóm nhà nghiên cứu được mời đến căn biệt thự cổ trên đồi thông Đà Lạt vào đêm bão tuyết hiếm hoi. Từng bí mật tâm lý đen tối của các vị khách dần lộ diện khi cánh cổng sắt khép lại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: bông hồng đen thứ bảy, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bí Ẩn Biệt Thự Hoa Hồng", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Bông hồng đen thứ bảy tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Bông hồng đen thứ bảy —'),
(60009, 6, 9, 'Chương 9: Đối diện với quá khứ', '【Chương 9: Đối diện với quá khứ】 Câu chuyện của tác phẩm "Bí Ẩn Biệt Thự Hoa Hồng" (tác giả: Nguyễn Hà Vy, thể loại: Trinh thám, Kinh dị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một nhóm nhà nghiên cứu được mời đến căn biệt thự cổ trên đồi thông Đà Lạt vào đêm bão tuyết hiếm hoi. Từng bí mật tâm lý đen tối của các vị khách dần lộ diện khi cánh cổng sắt khép lại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: đối diện với quá khứ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bí Ẩn Biệt Thự Hoa Hồng", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Đối diện với quá khứ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Đối diện với quá khứ —'),
(60010, 6, 10, 'Chương 10: Khi sương mù tan biến', '【Chương 10: Khi sương mù tan biến】 Câu chuyện của tác phẩm "Bí Ẩn Biệt Thự Hoa Hồng" (tác giả: Nguyễn Hà Vy, thể loại: Trinh thám, Kinh dị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một nhóm nhà nghiên cứu được mời đến căn biệt thự cổ trên đồi thông Đà Lạt vào đêm bão tuyết hiếm hoi. Từng bí mật tâm lý đen tối của các vị khách dần lộ diện khi cánh cổng sắt khép lại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: khi sương mù tan biến, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bí Ẩn Biệt Thự Hoa Hồng", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Khi sương mù tan biến tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Khi sương mù tan biến —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (7, 'Truyện Kiều (Đoạn Trường Tân Thanh)', 'Nguyễn Du (Kinh điển)', 'https://picsum.photos/seed/novelreader-v3-7/300/450', 'Kiệt tác thơ Nôm lục bát bất hủ của đại thi hào Nguyễn Du, khắc họa số phận mười lăm năm lưu lạc đầy bi kịch nhưng sáng ngời phẩm hạnh và lòng hiếu thảo của nàng Thúy Kiều tài sắc vẹn toàn.', 'completed', 'novel', 'Văn học kinh điển,Văn học Việt Nam,Cổ đại', 10, 5.0, 2100000, 1793800000000, 'truyen kieu (doan truong tan thanh) nguyen du (kinh dien)', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(70001, 7, 1, 'Chương 1: Hồi 1 – Trăm năm trong cõi người ta, gia cảnh Vương viên ngoại', '【Chương 1: Hồi 1 – Trăm năm trong cõi người ta, gia cảnh Vương viên ngoại】 Câu chuyện của tác phẩm "Truyện Kiều (Đoạn Trường Tân Thanh)" (tác giả: Nguyễn Du (Kinh điển), thể loại: Văn học kinh điển, Văn học Việt Nam, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kiệt tác thơ Nôm lục bát bất hủ của đại thi hào Nguyễn Du, khắc họa số phận mười lăm năm lưu lạc đầy bi kịch nhưng sáng ngời phẩm hạnh và lòng hiếu thảo của nàng Thúy Kiều tài sắc vẹn toàn.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: hồi 1 – trăm năm trong cõi người ta, gia cảnh vương viên ngoại, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Truyện Kiều (Đoạn Trường Tân Thanh)", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Hồi 1 – Trăm năm trong cõi người ta, gia cảnh Vương viên ngoại tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Hồi 1 – Trăm năm trong cõi người ta, gia cảnh Vương viên ngoại —'),
(70002, 7, 2, 'Chương 2: Hồi 2 – Tiết Thanh minh du xuân và cuộc gặp gỡ Kim Trọng', '【Chương 2: Hồi 2 – Tiết Thanh minh du xuân và cuộc gặp gỡ Kim Trọng】 Câu chuyện của tác phẩm "Truyện Kiều (Đoạn Trường Tân Thanh)" (tác giả: Nguyễn Du (Kinh điển), thể loại: Văn học kinh điển, Văn học Việt Nam, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kiệt tác thơ Nôm lục bát bất hủ của đại thi hào Nguyễn Du, khắc họa số phận mười lăm năm lưu lạc đầy bi kịch nhưng sáng ngời phẩm hạnh và lòng hiếu thảo của nàng Thúy Kiều tài sắc vẹn toàn.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: hồi 2 – tiết thanh minh du xuân và cuộc gặp gỡ kim trọng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Truyện Kiều (Đoạn Trường Tân Thanh)", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Hồi 2 – Tiết Thanh minh du xuân và cuộc gặp gỡ Kim Trọng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Hồi 2 – Tiết Thanh minh du xuân và cuộc gặp gỡ Kim Trọng —'),
(70003, 7, 3, 'Chương 3: Hồi 3 – Đêm trăng thề nguyền dưới hiên Lãm Thúy', '【Chương 3: Hồi 3 – Đêm trăng thề nguyền dưới hiên Lãm Thúy】 Câu chuyện của tác phẩm "Truyện Kiều (Đoạn Trường Tân Thanh)" (tác giả: Nguyễn Du (Kinh điển), thể loại: Văn học kinh điển, Văn học Việt Nam, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kiệt tác thơ Nôm lục bát bất hủ của đại thi hào Nguyễn Du, khắc họa số phận mười lăm năm lưu lạc đầy bi kịch nhưng sáng ngời phẩm hạnh và lòng hiếu thảo của nàng Thúy Kiều tài sắc vẹn toàn.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: hồi 3 – đêm trăng thề nguyền dưới hiên lãm thúy, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Truyện Kiều (Đoạn Trường Tân Thanh)", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Hồi 3 – Đêm trăng thề nguyền dưới hiên Lãm Thúy tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Hồi 3 – Đêm trăng thề nguyền dưới hiên Lãm Thúy —'),
(70004, 7, 4, 'Chương 4: Hồi 4 – Gia biến bất ngờ, bán mình chuộc cha', '【Chương 4: Hồi 4 – Gia biến bất ngờ, bán mình chuộc cha】 Câu chuyện của tác phẩm "Truyện Kiều (Đoạn Trường Tân Thanh)" (tác giả: Nguyễn Du (Kinh điển), thể loại: Văn học kinh điển, Văn học Việt Nam, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kiệt tác thơ Nôm lục bát bất hủ của đại thi hào Nguyễn Du, khắc họa số phận mười lăm năm lưu lạc đầy bi kịch nhưng sáng ngời phẩm hạnh và lòng hiếu thảo của nàng Thúy Kiều tài sắc vẹn toàn.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: hồi 4 – gia biến bất ngờ, bán mình chuộc cha, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Truyện Kiều (Đoạn Trường Tân Thanh)", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Hồi 4 – Gia biến bất ngờ, bán mình chuộc cha tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Hồi 4 – Gia biến bất ngờ, bán mình chuộc cha —'),
(70005, 7, 5, 'Chương 5: Hồi 5 – Trao duyên cho Thúy Vân', '【Chương 5: Hồi 5 – Trao duyên cho Thúy Vân】 Câu chuyện của tác phẩm "Truyện Kiều (Đoạn Trường Tân Thanh)" (tác giả: Nguyễn Du (Kinh điển), thể loại: Văn học kinh điển, Văn học Việt Nam, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kiệt tác thơ Nôm lục bát bất hủ của đại thi hào Nguyễn Du, khắc họa số phận mười lăm năm lưu lạc đầy bi kịch nhưng sáng ngời phẩm hạnh và lòng hiếu thảo của nàng Thúy Kiều tài sắc vẹn toàn.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: hồi 5 – trao duyên cho thúy vân, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Truyện Kiều (Đoạn Trường Tân Thanh)", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Hồi 5 – Trao duyên cho Thúy Vân tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Hồi 5 – Trao duyên cho Thúy Vân —'),
(70006, 7, 6, 'Chương 6: Hồi 6 – Nỗi niềm Kiều ở lầu Ngưng Bích', '【Chương 6: Hồi 6 – Nỗi niềm Kiều ở lầu Ngưng Bích】 Câu chuyện của tác phẩm "Truyện Kiều (Đoạn Trường Tân Thanh)" (tác giả: Nguyễn Du (Kinh điển), thể loại: Văn học kinh điển, Văn học Việt Nam, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kiệt tác thơ Nôm lục bát bất hủ của đại thi hào Nguyễn Du, khắc họa số phận mười lăm năm lưu lạc đầy bi kịch nhưng sáng ngời phẩm hạnh và lòng hiếu thảo của nàng Thúy Kiều tài sắc vẹn toàn.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: hồi 6 – nỗi niềm kiều ở lầu ngưng bích, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Truyện Kiều (Đoạn Trường Tân Thanh)", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Hồi 6 – Nỗi niềm Kiều ở lầu Ngưng Bích tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Hồi 6 – Nỗi niềm Kiều ở lầu Ngưng Bích —'),
(70007, 7, 7, 'Chương 7: Hồi 7 – Thúc Sinh cứu Kiều khỏi chốn phong trần', '【Chương 7: Hồi 7 – Thúc Sinh cứu Kiều khỏi chốn phong trần】 Câu chuyện của tác phẩm "Truyện Kiều (Đoạn Trường Tân Thanh)" (tác giả: Nguyễn Du (Kinh điển), thể loại: Văn học kinh điển, Văn học Việt Nam, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kiệt tác thơ Nôm lục bát bất hủ của đại thi hào Nguyễn Du, khắc họa số phận mười lăm năm lưu lạc đầy bi kịch nhưng sáng ngời phẩm hạnh và lòng hiếu thảo của nàng Thúy Kiều tài sắc vẹn toàn.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: hồi 7 – thúc sinh cứu kiều khỏi chốn phong trần, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Truyện Kiều (Đoạn Trường Tân Thanh)", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Hồi 7 – Thúc Sinh cứu Kiều khỏi chốn phong trần tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Hồi 7 – Thúc Sinh cứu Kiều khỏi chốn phong trần —'),
(70008, 7, 8, 'Chương 8: Hồi 8 – Anh hùng Từ Hải giữa đất trời', '【Chương 8: Hồi 8 – Anh hùng Từ Hải giữa đất trời】 Câu chuyện của tác phẩm "Truyện Kiều (Đoạn Trường Tân Thanh)" (tác giả: Nguyễn Du (Kinh điển), thể loại: Văn học kinh điển, Văn học Việt Nam, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kiệt tác thơ Nôm lục bát bất hủ của đại thi hào Nguyễn Du, khắc họa số phận mười lăm năm lưu lạc đầy bi kịch nhưng sáng ngời phẩm hạnh và lòng hiếu thảo của nàng Thúy Kiều tài sắc vẹn toàn.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: hồi 8 – anh hùng từ hải giữa đất trời, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Truyện Kiều (Đoạn Trường Tân Thanh)", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Hồi 8 – Anh hùng Từ Hải giữa đất trời tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Hồi 8 – Anh hùng Từ Hải giữa đất trời —'),
(70009, 7, 9, 'Chương 9: Hồi 9 – Báo ân báo oán phân minh', '【Chương 9: Hồi 9 – Báo ân báo oán phân minh】 Câu chuyện của tác phẩm "Truyện Kiều (Đoạn Trường Tân Thanh)" (tác giả: Nguyễn Du (Kinh điển), thể loại: Văn học kinh điển, Văn học Việt Nam, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kiệt tác thơ Nôm lục bát bất hủ của đại thi hào Nguyễn Du, khắc họa số phận mười lăm năm lưu lạc đầy bi kịch nhưng sáng ngời phẩm hạnh và lòng hiếu thảo của nàng Thúy Kiều tài sắc vẹn toàn.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: hồi 9 – báo ân báo oán phân minh, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Truyện Kiều (Đoạn Trường Tân Thanh)", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Hồi 9 – Báo ân báo oán phân minh tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Hồi 9 – Báo ân báo oán phân minh —'),
(70010, 7, 10, 'Chương 10: Hồi 10 – Đoàn viên bên dòng sông Tiền Đường', '【Chương 10: Hồi 10 – Đoàn viên bên dòng sông Tiền Đường】 Câu chuyện của tác phẩm "Truyện Kiều (Đoạn Trường Tân Thanh)" (tác giả: Nguyễn Du (Kinh điển), thể loại: Văn học kinh điển, Văn học Việt Nam, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kiệt tác thơ Nôm lục bát bất hủ của đại thi hào Nguyễn Du, khắc họa số phận mười lăm năm lưu lạc đầy bi kịch nhưng sáng ngời phẩm hạnh và lòng hiếu thảo của nàng Thúy Kiều tài sắc vẹn toàn.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: hồi 10 – đoàn viên bên dòng sông tiền đường, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Truyện Kiều (Đoạn Trường Tân Thanh)", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Hồi 10 – Đoàn viên bên dòng sông Tiền Đường tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Hồi 10 – Đoàn viên bên dòng sông Tiền Đường —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (8, 'Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo', 'Nam Cao (Kinh điển)', 'https://picsum.photos/seed/novelreader-v3-8/300/450', 'Tuyển tập truyện ngắn hiện thực xuất sắc của nhà văn Nam Cao, phản ánh sâu sắc bi kịch người nông dân và người trí thức nghèo trước Cách mạng với lòng nhân đạo bao la.', 'completed', 'novel', 'Văn học Việt Nam,Văn học kinh điển,Tâm lý', 10, 4.9, 1650000, 1793800000000, 'tuyen tap hien thuc nam cao: lao hac & chi pheo nam cao (kinh dien)', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(80001, 8, 1, 'Chương 1: Lão Hạc và cậu Vàng trung thành', '【Chương 1: Lão Hạc và cậu Vàng trung thành】 Câu chuyện của tác phẩm "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo" (tác giả: Nam Cao (Kinh điển), thể loại: Văn học Việt Nam, Văn học kinh điển, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển tập truyện ngắn hiện thực xuất sắc của nhà văn Nam Cao, phản ánh sâu sắc bi kịch người nông dân và người trí thức nghèo trước Cách mạng với lòng nhân đạo bao la.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: lão hạc và cậu vàng trung thành, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Lão Hạc và cậu Vàng trung thành tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Lão Hạc và cậu Vàng trung thành —'),
(80002, 8, 2, 'Chương 2: Nỗi lòng người cha nghèo khổ', '【Chương 2: Nỗi lòng người cha nghèo khổ】 Câu chuyện của tác phẩm "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo" (tác giả: Nam Cao (Kinh điển), thể loại: Văn học Việt Nam, Văn học kinh điển, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển tập truyện ngắn hiện thực xuất sắc của nhà văn Nam Cao, phản ánh sâu sắc bi kịch người nông dân và người trí thức nghèo trước Cách mạng với lòng nhân đạo bao la.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: nỗi lòng người cha nghèo khổ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Nỗi lòng người cha nghèo khổ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Nỗi lòng người cha nghèo khổ —'),
(80003, 8, 3, 'Chương 3: Mảnh vườn giữ trọn cho con', '【Chương 3: Mảnh vườn giữ trọn cho con】 Câu chuyện của tác phẩm "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo" (tác giả: Nam Cao (Kinh điển), thể loại: Văn học Việt Nam, Văn học kinh điển, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển tập truyện ngắn hiện thực xuất sắc của nhà văn Nam Cao, phản ánh sâu sắc bi kịch người nông dân và người trí thức nghèo trước Cách mạng với lòng nhân đạo bao la.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: mảnh vườn giữ trọn cho con, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Mảnh vườn giữ trọn cho con tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Mảnh vườn giữ trọn cho con —'),
(80004, 8, 4, 'Chương 4: Tiếng khóc của ông giáo', '【Chương 4: Tiếng khóc của ông giáo】 Câu chuyện của tác phẩm "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo" (tác giả: Nam Cao (Kinh điển), thể loại: Văn học Việt Nam, Văn học kinh điển, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển tập truyện ngắn hiện thực xuất sắc của nhà văn Nam Cao, phản ánh sâu sắc bi kịch người nông dân và người trí thức nghèo trước Cách mạng với lòng nhân đạo bao la.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: tiếng khóc của ông giáo, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Tiếng khóc của ông giáo tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Tiếng khóc của ông giáo —'),
(80005, 8, 5, 'Chương 5: Chí Phèo và chiếc lò gạch cũ', '【Chương 5: Chí Phèo và chiếc lò gạch cũ】 Câu chuyện của tác phẩm "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo" (tác giả: Nam Cao (Kinh điển), thể loại: Văn học Việt Nam, Văn học kinh điển, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển tập truyện ngắn hiện thực xuất sắc của nhà văn Nam Cao, phản ánh sâu sắc bi kịch người nông dân và người trí thức nghèo trước Cách mạng với lòng nhân đạo bao la.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: chí phèo và chiếc lò gạch cũ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Chí Phèo và chiếc lò gạch cũ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Chí Phèo và chiếc lò gạch cũ —'),
(80006, 8, 6, 'Chương 6: Những vết sẹo trên gương mặt', '【Chương 6: Những vết sẹo trên gương mặt】 Câu chuyện của tác phẩm "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo" (tác giả: Nam Cao (Kinh điển), thể loại: Văn học Việt Nam, Văn học kinh điển, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển tập truyện ngắn hiện thực xuất sắc của nhà văn Nam Cao, phản ánh sâu sắc bi kịch người nông dân và người trí thức nghèo trước Cách mạng với lòng nhân đạo bao la.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: những vết sẹo trên gương mặt, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Những vết sẹo trên gương mặt tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Những vết sẹo trên gương mặt —'),
(80007, 8, 7, 'Chương 7: Bát cháo hành của Thị Nở', '【Chương 7: Bát cháo hành của Thị Nở】 Câu chuyện của tác phẩm "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo" (tác giả: Nam Cao (Kinh điển), thể loại: Văn học Việt Nam, Văn học kinh điển, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển tập truyện ngắn hiện thực xuất sắc của nhà văn Nam Cao, phản ánh sâu sắc bi kịch người nông dân và người trí thức nghèo trước Cách mạng với lòng nhân đạo bao la.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: bát cháo hành của thị nở, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Bát cháo hành của Thị Nở tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Bát cháo hành của Thị Nở —'),
(80008, 8, 8, 'Chương 8: Khát vọng hoàn lương cháy bỏng', '【Chương 8: Khát vọng hoàn lương cháy bỏng】 Câu chuyện của tác phẩm "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo" (tác giả: Nam Cao (Kinh điển), thể loại: Văn học Việt Nam, Văn học kinh điển, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển tập truyện ngắn hiện thực xuất sắc của nhà văn Nam Cao, phản ánh sâu sắc bi kịch người nông dân và người trí thức nghèo trước Cách mạng với lòng nhân đạo bao la.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: khát vọng hoàn lương cháy bỏng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Khát vọng hoàn lương cháy bỏng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Khát vọng hoàn lương cháy bỏng —'),
(80009, 8, 9, 'Chương 9: Bi kịch trước ngưỡng cửa lương thiện', '【Chương 9: Bi kịch trước ngưỡng cửa lương thiện】 Câu chuyện của tác phẩm "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo" (tác giả: Nam Cao (Kinh điển), thể loại: Văn học Việt Nam, Văn học kinh điển, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển tập truyện ngắn hiện thực xuất sắc của nhà văn Nam Cao, phản ánh sâu sắc bi kịch người nông dân và người trí thức nghèo trước Cách mạng với lòng nhân đạo bao la.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: bi kịch trước ngưỡng cửa lương thiện, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Bi kịch trước ngưỡng cửa lương thiện tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Bi kịch trước ngưỡng cửa lương thiện —'),
(80010, 8, 10, 'Chương 10: Đời thừa và giọt nước mắt người trí thức', '【Chương 10: Đời thừa và giọt nước mắt người trí thức】 Câu chuyện của tác phẩm "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo" (tác giả: Nam Cao (Kinh điển), thể loại: Văn học Việt Nam, Văn học kinh điển, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển tập truyện ngắn hiện thực xuất sắc của nhà văn Nam Cao, phản ánh sâu sắc bi kịch người nông dân và người trí thức nghèo trước Cách mạng với lòng nhân đạo bao la.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: đời thừa và giọt nước mắt người trí thức, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tuyển Tập Hiện Thực Nam Cao: Lão Hạc & Chí Phèo", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Đời thừa và giọt nước mắt người trí thức tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Đời thừa và giọt nước mắt người trí thức —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (9, 'Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển', 'Arthur Conan Doyle (Bản dịch Việt ngữ)', 'https://picsum.photos/seed/novelreader-v3-9/300/450', 'Những vụ án suy luận kinh điển tại căn hộ số 221B phố Baker, nơi mọi chi tiết nhỏ nhặt nhất từ vết bùn trên giày đến tàn thuốc lá đều dẫn tới chân tướng không thể chối cãi.', 'completed', 'novel', 'Trinh thám,Văn học kinh điển,Hình sự', 10, 4.9, 1320000, 1793800000000, 'ho so tham tu so 221b: tuyen tap trinh tham co dien arthur conan doyle (ban dich viet ngu)', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(90001, 9, 1, 'Chương 1: Cuộc gặp gỡ tại phố Baker', '【Chương 1: Cuộc gặp gỡ tại phố Baker】 Câu chuyện của tác phẩm "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển" (tác giả: Arthur Conan Doyle (Bản dịch Việt ngữ), thể loại: Trinh thám, Văn học kinh điển, Hình sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những vụ án suy luận kinh điển tại căn hộ số 221B phố Baker, nơi mọi chi tiết nhỏ nhặt nhất từ vết bùn trên giày đến tàn thuốc lá đều dẫn tới chân tướng không thể chối cãi.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: cuộc gặp gỡ tại phố baker, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Cuộc gặp gỡ tại phố Baker tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Cuộc gặp gỡ tại phố Baker —'),
(90002, 9, 2, 'Chương 2: Chiếc nhẫn cưới tại hiện trường', '【Chương 2: Chiếc nhẫn cưới tại hiện trường】 Câu chuyện của tác phẩm "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển" (tác giả: Arthur Conan Doyle (Bản dịch Việt ngữ), thể loại: Trinh thám, Văn học kinh điển, Hình sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những vụ án suy luận kinh điển tại căn hộ số 221B phố Baker, nơi mọi chi tiết nhỏ nhặt nhất từ vết bùn trên giày đến tàn thuốc lá đều dẫn tới chân tướng không thể chối cãi.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: chiếc nhẫn cưới tại hiện trường, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Chiếc nhẫn cưới tại hiện trường tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Chiếc nhẫn cưới tại hiện trường —'),
(90003, 9, 3, 'Chương 3: Dải băng lụa có đốm', '【Chương 3: Dải băng lụa có đốm】 Câu chuyện của tác phẩm "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển" (tác giả: Arthur Conan Doyle (Bản dịch Việt ngữ), thể loại: Trinh thám, Văn học kinh điển, Hình sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những vụ án suy luận kinh điển tại căn hộ số 221B phố Baker, nơi mọi chi tiết nhỏ nhặt nhất từ vết bùn trên giày đến tàn thuốc lá đều dẫn tới chân tướng không thể chối cãi.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: dải băng lụa có đốm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Dải băng lụa có đốm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Dải băng lụa có đốm —'),
(90004, 9, 4, 'Chương 4: Hội Tóc Đỏ kỳ bí', '【Chương 4: Hội Tóc Đỏ kỳ bí】 Câu chuyện của tác phẩm "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển" (tác giả: Arthur Conan Doyle (Bản dịch Việt ngữ), thể loại: Trinh thám, Văn học kinh điển, Hình sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những vụ án suy luận kinh điển tại căn hộ số 221B phố Baker, nơi mọi chi tiết nhỏ nhặt nhất từ vết bùn trên giày đến tàn thuốc lá đều dẫn tới chân tướng không thể chối cãi.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: hội tóc đỏ kỳ bí, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Hội Tóc Đỏ kỳ bí tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Hội Tóc Đỏ kỳ bí —'),
(90005, 9, 5, 'Chương 5: Bóng ma trên đầm lầy Baskerville', '【Chương 5: Bóng ma trên đầm lầy Baskerville】 Câu chuyện của tác phẩm "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển" (tác giả: Arthur Conan Doyle (Bản dịch Việt ngữ), thể loại: Trinh thám, Văn học kinh điển, Hình sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những vụ án suy luận kinh điển tại căn hộ số 221B phố Baker, nơi mọi chi tiết nhỏ nhặt nhất từ vết bùn trên giày đến tàn thuốc lá đều dẫn tới chân tướng không thể chối cãi.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: bóng ma trên đầm lầy baskerville, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Bóng ma trên đầm lầy Baskerville tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Bóng ma trên đầm lầy Baskerville —'),
(90006, 9, 6, 'Chương 6: Năm hạt cam khô', '【Chương 6: Năm hạt cam khô】 Câu chuyện của tác phẩm "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển" (tác giả: Arthur Conan Doyle (Bản dịch Việt ngữ), thể loại: Trinh thám, Văn học kinh điển, Hình sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những vụ án suy luận kinh điển tại căn hộ số 221B phố Baker, nơi mọi chi tiết nhỏ nhặt nhất từ vết bùn trên giày đến tàn thuốc lá đều dẫn tới chân tướng không thể chối cãi.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: năm hạt cam khô, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Năm hạt cam khô tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Năm hạt cam khô —'),
(90007, 9, 7, 'Chương 7: Bí mật những hình người nhảy múa', '【Chương 7: Bí mật những hình người nhảy múa】 Câu chuyện của tác phẩm "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển" (tác giả: Arthur Conan Doyle (Bản dịch Việt ngữ), thể loại: Trinh thám, Văn học kinh điển, Hình sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những vụ án suy luận kinh điển tại căn hộ số 221B phố Baker, nơi mọi chi tiết nhỏ nhặt nhất từ vết bùn trên giày đến tàn thuốc lá đều dẫn tới chân tướng không thể chối cãi.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: bí mật những hình người nhảy múa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Bí mật những hình người nhảy múa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Bí mật những hình người nhảy múa —'),
(90008, 9, 8, 'Chương 8: Chiếc vương miện đá quý', '【Chương 8: Chiếc vương miện đá quý】 Câu chuyện của tác phẩm "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển" (tác giả: Arthur Conan Doyle (Bản dịch Việt ngữ), thể loại: Trinh thám, Văn học kinh điển, Hình sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những vụ án suy luận kinh điển tại căn hộ số 221B phố Baker, nơi mọi chi tiết nhỏ nhặt nhất từ vết bùn trên giày đến tàn thuốc lá đều dẫn tới chân tướng không thể chối cãi.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: chiếc vương miện đá quý, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Chiếc vương miện đá quý tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Chiếc vương miện đá quý —'),
(90009, 9, 9, 'Chương 9: Cuộc đối đầu tại thác Reichenbach', '【Chương 9: Cuộc đối đầu tại thác Reichenbach】 Câu chuyện của tác phẩm "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển" (tác giả: Arthur Conan Doyle (Bản dịch Việt ngữ), thể loại: Trinh thám, Văn học kinh điển, Hình sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những vụ án suy luận kinh điển tại căn hộ số 221B phố Baker, nơi mọi chi tiết nhỏ nhặt nhất từ vết bùn trên giày đến tàn thuốc lá đều dẫn tới chân tướng không thể chối cãi.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: cuộc đối đầu tại thác reichenbach, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Cuộc đối đầu tại thác Reichenbach tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Cuộc đối đầu tại thác Reichenbach —'),
(90010, 9, 10, 'Chương 10: Sự trở về của vị thám tử đại tài', '【Chương 10: Sự trở về của vị thám tử đại tài】 Câu chuyện của tác phẩm "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển" (tác giả: Arthur Conan Doyle (Bản dịch Việt ngữ), thể loại: Trinh thám, Văn học kinh điển, Hình sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những vụ án suy luận kinh điển tại căn hộ số 221B phố Baker, nơi mọi chi tiết nhỏ nhặt nhất từ vết bùn trên giày đến tàn thuốc lá đều dẫn tới chân tướng không thể chối cãi.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: sự trở về của vị thám tử đại tài, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hồ Sơ Thám Tử Số 221B: Tuyển Tập Trinh Thám Cổ Điển", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Sự trở về của vị thám tử đại tài tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Sự trở về của vị thám tử đại tài —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (10, 'Thương Trường Đại Chiến: Phố Wall Đông Nam', 'Lê Hoàng Bách', 'https://picsum.photos/seed/novelreader-v3-10/300/450', 'Từ một chuyên viên phân tích tài chính trẻ tuổi tay trắng, Minh Quân bước vào cuộc chiến thâu tóm và sáp nhập các tập đoàn tỷ đô giữa trung tâm tài chính sôi động bậc nhất Đông Nam Á.', 'ongoing', 'novel', 'Kinh doanh,Đô thị,Tâm lý', 10, 4.7, 690000, 1793800000000, 'thuong truong dai chien: pho wall dong nam le hoang bach', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(100001, 10, 1, 'Chương 1: Cú sập sàn chứng khoán lúc mở cửa', '【Chương 1: Cú sập sàn chứng khoán lúc mở cửa】 Câu chuyện của tác phẩm "Thương Trường Đại Chiến: Phố Wall Đông Nam" (tác giả: Lê Hoàng Bách, thể loại: Kinh doanh, Đô thị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một chuyên viên phân tích tài chính trẻ tuổi tay trắng, Minh Quân bước vào cuộc chiến thâu tóm và sáp nhập các tập đoàn tỷ đô giữa trung tâm tài chính sôi động bậc nhất Đông Nam Á.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: cú sập sàn chứng khoán lúc mở cửa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thương Trường Đại Chiến: Phố Wall Đông Nam", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Cú sập sàn chứng khoán lúc mở cửa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Cú sập sàn chứng khoán lúc mở cửa —'),
(100002, 10, 2, 'Chương 2: Bản báo cáo tài chính bị che giấu', '【Chương 2: Bản báo cáo tài chính bị che giấu】 Câu chuyện của tác phẩm "Thương Trường Đại Chiến: Phố Wall Đông Nam" (tác giả: Lê Hoàng Bách, thể loại: Kinh doanh, Đô thị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một chuyên viên phân tích tài chính trẻ tuổi tay trắng, Minh Quân bước vào cuộc chiến thâu tóm và sáp nhập các tập đoàn tỷ đô giữa trung tâm tài chính sôi động bậc nhất Đông Nam Á.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: bản báo cáo tài chính bị che giấu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thương Trường Đại Chiến: Phố Wall Đông Nam", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Bản báo cáo tài chính bị che giấu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Bản báo cáo tài chính bị che giấu —'),
(100003, 10, 3, 'Chương 3: Đòn bẩy hai trăm triệu đô', '【Chương 3: Đòn bẩy hai trăm triệu đô】 Câu chuyện của tác phẩm "Thương Trường Đại Chiến: Phố Wall Đông Nam" (tác giả: Lê Hoàng Bách, thể loại: Kinh doanh, Đô thị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một chuyên viên phân tích tài chính trẻ tuổi tay trắng, Minh Quân bước vào cuộc chiến thâu tóm và sáp nhập các tập đoàn tỷ đô giữa trung tâm tài chính sôi động bậc nhất Đông Nam Á.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: đòn bẩy hai trăm triệu đô, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thương Trường Đại Chiến: Phố Wall Đông Nam", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Đòn bẩy hai trăm triệu đô tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Đòn bẩy hai trăm triệu đô —'),
(100004, 10, 4, 'Chương 4: Đêm không ngủ ở tầng bốn mươi tám', '【Chương 4: Đêm không ngủ ở tầng bốn mươi tám】 Câu chuyện của tác phẩm "Thương Trường Đại Chiến: Phố Wall Đông Nam" (tác giả: Lê Hoàng Bách, thể loại: Kinh doanh, Đô thị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một chuyên viên phân tích tài chính trẻ tuổi tay trắng, Minh Quân bước vào cuộc chiến thâu tóm và sáp nhập các tập đoàn tỷ đô giữa trung tâm tài chính sôi động bậc nhất Đông Nam Á.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: đêm không ngủ ở tầng bốn mươi tám, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thương Trường Đại Chiến: Phố Wall Đông Nam", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Đêm không ngủ ở tầng bốn mươi tám tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Đêm không ngủ ở tầng bốn mươi tám —'),
(100005, 10, 5, 'Chương 5: Thương vụ thâu tóm ngược', '【Chương 5: Thương vụ thâu tóm ngược】 Câu chuyện của tác phẩm "Thương Trường Đại Chiến: Phố Wall Đông Nam" (tác giả: Lê Hoàng Bách, thể loại: Kinh doanh, Đô thị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một chuyên viên phân tích tài chính trẻ tuổi tay trắng, Minh Quân bước vào cuộc chiến thâu tóm và sáp nhập các tập đoàn tỷ đô giữa trung tâm tài chính sôi động bậc nhất Đông Nam Á.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: thương vụ thâu tóm ngược, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thương Trường Đại Chiến: Phố Wall Đông Nam", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Thương vụ thâu tóm ngược tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Thương vụ thâu tóm ngược —'),
(100006, 10, 6, 'Chương 6: Đối tác bí ẩn từ Singapore', '【Chương 6: Đối tác bí ẩn từ Singapore】 Câu chuyện của tác phẩm "Thương Trường Đại Chiến: Phố Wall Đông Nam" (tác giả: Lê Hoàng Bách, thể loại: Kinh doanh, Đô thị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một chuyên viên phân tích tài chính trẻ tuổi tay trắng, Minh Quân bước vào cuộc chiến thâu tóm và sáp nhập các tập đoàn tỷ đô giữa trung tâm tài chính sôi động bậc nhất Đông Nam Á.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: đối tác bí ẩn từ singapore, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thương Trường Đại Chiến: Phố Wall Đông Nam", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Đối tác bí ẩn từ Singapore tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Đối tác bí ẩn từ Singapore —'),
(100007, 10, 7, 'Chương 7: Cạm bẫy cổ phiếu quỹ', '【Chương 7: Cạm bẫy cổ phiếu quỹ】 Câu chuyện của tác phẩm "Thương Trường Đại Chiến: Phố Wall Đông Nam" (tác giả: Lê Hoàng Bách, thể loại: Kinh doanh, Đô thị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một chuyên viên phân tích tài chính trẻ tuổi tay trắng, Minh Quân bước vào cuộc chiến thâu tóm và sáp nhập các tập đoàn tỷ đô giữa trung tâm tài chính sôi động bậc nhất Đông Nam Á.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: cạm bẫy cổ phiếu quỹ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thương Trường Đại Chiến: Phố Wall Đông Nam", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Cạm bẫy cổ phiếu quỹ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Cạm bẫy cổ phiếu quỹ —'),
(100008, 10, 8, 'Chương 8: Cuộc họp đại hội đồng cổ đông', '【Chương 8: Cuộc họp đại hội đồng cổ đông】 Câu chuyện của tác phẩm "Thương Trường Đại Chiến: Phố Wall Đông Nam" (tác giả: Lê Hoàng Bách, thể loại: Kinh doanh, Đô thị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một chuyên viên phân tích tài chính trẻ tuổi tay trắng, Minh Quân bước vào cuộc chiến thâu tóm và sáp nhập các tập đoàn tỷ đô giữa trung tâm tài chính sôi động bậc nhất Đông Nam Á.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: cuộc họp đại hội đồng cổ đông, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thương Trường Đại Chiến: Phố Wall Đông Nam", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Cuộc họp đại hội đồng cổ đông tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Cuộc họp đại hội đồng cổ đông —'),
(100009, 10, 9, 'Chương 9: Bước ngoặt phát hành cổ phiếu lần đầu', '【Chương 9: Bước ngoặt phát hành cổ phiếu lần đầu】 Câu chuyện của tác phẩm "Thương Trường Đại Chiến: Phố Wall Đông Nam" (tác giả: Lê Hoàng Bách, thể loại: Kinh doanh, Đô thị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một chuyên viên phân tích tài chính trẻ tuổi tay trắng, Minh Quân bước vào cuộc chiến thâu tóm và sáp nhập các tập đoàn tỷ đô giữa trung tâm tài chính sôi động bậc nhất Đông Nam Á.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: bước ngoặt phát hành cổ phiếu lần đầu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thương Trường Đại Chiến: Phố Wall Đông Nam", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Bước ngoặt phát hành cổ phiếu lần đầu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Bước ngoặt phát hành cổ phiếu lần đầu —'),
(100010, 10, 10, 'Chương 10: Đế chế tài chính mới trỗi dậy', '【Chương 10: Đế chế tài chính mới trỗi dậy】 Câu chuyện của tác phẩm "Thương Trường Đại Chiến: Phố Wall Đông Nam" (tác giả: Lê Hoàng Bách, thể loại: Kinh doanh, Đô thị, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một chuyên viên phân tích tài chính trẻ tuổi tay trắng, Minh Quân bước vào cuộc chiến thâu tóm và sáp nhập các tập đoàn tỷ đô giữa trung tâm tài chính sôi động bậc nhất Đông Nam Á.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: đế chế tài chính mới trỗi dậy, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thương Trường Đại Chiến: Phố Wall Đông Nam", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Đế chế tài chính mới trỗi dậy tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Đế chế tài chính mới trỗi dậy —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (11, 'Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt', 'Vũ Thành Nam', 'https://picsum.photos/seed/novelreader-v3-11/300/450', 'Nhà khảo cổ học trẻ tuổi Phong Sơn tình cờ giải mã được hoa văn trên mặt trống đồng cổ, mở ra cuộc hành trình xuyên rừng già Tây Bắc tìm kiếm di tích thất lạc của nền văn minh Lạc Việt.', 'ongoing', 'novel', 'Phiêu lưu,Lịch sử,Linh dị', 10, 4.8, 840000, 1793800000000, 'co mo ky thu: dau an lac viet vu thanh nam', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(110001, 11, 1, 'Chương 1: Mảnh trống đồng dưới đáy sông Hồng', '【Chương 1: Mảnh trống đồng dưới đáy sông Hồng】 Câu chuyện của tác phẩm "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt" (tác giả: Vũ Thành Nam, thể loại: Phiêu lưu, Lịch sử, Linh dị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nhà khảo cổ học trẻ tuổi Phong Sơn tình cờ giải mã được hoa văn trên mặt trống đồng cổ, mở ra cuộc hành trình xuyên rừng già Tây Bắc tìm kiếm di tích thất lạc của nền văn minh Lạc Việt.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: mảnh trống đồng dưới đáy sông hồng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Mảnh trống đồng dưới đáy sông Hồng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Mảnh trống đồng dưới đáy sông Hồng —'),
(110002, 11, 2, 'Chương 2: Mật ngữ chim Lạc mười bốn cánh', '【Chương 2: Mật ngữ chim Lạc mười bốn cánh】 Câu chuyện của tác phẩm "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt" (tác giả: Vũ Thành Nam, thể loại: Phiêu lưu, Lịch sử, Linh dị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nhà khảo cổ học trẻ tuổi Phong Sơn tình cờ giải mã được hoa văn trên mặt trống đồng cổ, mở ra cuộc hành trình xuyên rừng già Tây Bắc tìm kiếm di tích thất lạc của nền văn minh Lạc Việt.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: mật ngữ chim lạc mười bốn cánh, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Mật ngữ chim Lạc mười bốn cánh tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Mật ngữ chim Lạc mười bốn cánh —'),
(110003, 11, 3, 'Chương 3: Bản đồ cổ trong ngôi chùa đá', '【Chương 3: Bản đồ cổ trong ngôi chùa đá】 Câu chuyện của tác phẩm "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt" (tác giả: Vũ Thành Nam, thể loại: Phiêu lưu, Lịch sử, Linh dị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nhà khảo cổ học trẻ tuổi Phong Sơn tình cờ giải mã được hoa văn trên mặt trống đồng cổ, mở ra cuộc hành trình xuyên rừng già Tây Bắc tìm kiếm di tích thất lạc của nền văn minh Lạc Việt.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: bản đồ cổ trong ngôi chùa đá, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Bản đồ cổ trong ngôi chùa đá tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Bản đồ cổ trong ngôi chùa đá —'),
(110004, 11, 4, 'Chương 4: Hành trình vượt đỉnh Hoàng Liên', '【Chương 4: Hành trình vượt đỉnh Hoàng Liên】 Câu chuyện của tác phẩm "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt" (tác giả: Vũ Thành Nam, thể loại: Phiêu lưu, Lịch sử, Linh dị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nhà khảo cổ học trẻ tuổi Phong Sơn tình cờ giải mã được hoa văn trên mặt trống đồng cổ, mở ra cuộc hành trình xuyên rừng già Tây Bắc tìm kiếm di tích thất lạc của nền văn minh Lạc Việt.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: hành trình vượt đỉnh hoàng liên, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Hành trình vượt đỉnh Hoàng Liên tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Hành trình vượt đỉnh Hoàng Liên —'),
(110005, 11, 5, 'Chương 5: Cổng đá ngàn năm giữa rừng sương', '【Chương 5: Cổng đá ngàn năm giữa rừng sương】 Câu chuyện của tác phẩm "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt" (tác giả: Vũ Thành Nam, thể loại: Phiêu lưu, Lịch sử, Linh dị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nhà khảo cổ học trẻ tuổi Phong Sơn tình cờ giải mã được hoa văn trên mặt trống đồng cổ, mở ra cuộc hành trình xuyên rừng già Tây Bắc tìm kiếm di tích thất lạc của nền văn minh Lạc Việt.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: cổng đá ngàn năm giữa rừng sương, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Cổng đá ngàn năm giữa rừng sương tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Cổng đá ngàn năm giữa rừng sương —'),
(110006, 11, 6, 'Chương 6: Cơ quan thủy ngân cổ đại', '【Chương 6: Cơ quan thủy ngân cổ đại】 Câu chuyện của tác phẩm "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt" (tác giả: Vũ Thành Nam, thể loại: Phiêu lưu, Lịch sử, Linh dị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nhà khảo cổ học trẻ tuổi Phong Sơn tình cờ giải mã được hoa văn trên mặt trống đồng cổ, mở ra cuộc hành trình xuyên rừng già Tây Bắc tìm kiếm di tích thất lạc của nền văn minh Lạc Việt.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: cơ quan thủy ngân cổ đại, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Cơ quan thủy ngân cổ đại tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Cơ quan thủy ngân cổ đại —'),
(110007, 11, 7, 'Chương 7: Bức phù điêu Âu Lạc', '【Chương 7: Bức phù điêu Âu Lạc】 Câu chuyện của tác phẩm "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt" (tác giả: Vũ Thành Nam, thể loại: Phiêu lưu, Lịch sử, Linh dị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nhà khảo cổ học trẻ tuổi Phong Sơn tình cờ giải mã được hoa văn trên mặt trống đồng cổ, mở ra cuộc hành trình xuyên rừng già Tây Bắc tìm kiếm di tích thất lạc của nền văn minh Lạc Việt.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: bức phù điêu âu lạc, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Bức phù điêu Âu Lạc tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Bức phù điêu Âu Lạc —'),
(110008, 11, 8, 'Chương 8: Lời nguyền kẻ giữ mộ', '【Chương 8: Lời nguyền kẻ giữ mộ】 Câu chuyện của tác phẩm "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt" (tác giả: Vũ Thành Nam, thể loại: Phiêu lưu, Lịch sử, Linh dị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nhà khảo cổ học trẻ tuổi Phong Sơn tình cờ giải mã được hoa văn trên mặt trống đồng cổ, mở ra cuộc hành trình xuyên rừng già Tây Bắc tìm kiếm di tích thất lạc của nền văn minh Lạc Việt.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: lời nguyền kẻ giữ mộ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Lời nguyền kẻ giữ mộ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Lời nguyền kẻ giữ mộ —'),
(110009, 11, 9, 'Chương 9: Kho báu tri thức người xưa', '【Chương 9: Kho báu tri thức người xưa】 Câu chuyện của tác phẩm "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt" (tác giả: Vũ Thành Nam, thể loại: Phiêu lưu, Lịch sử, Linh dị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nhà khảo cổ học trẻ tuổi Phong Sơn tình cờ giải mã được hoa văn trên mặt trống đồng cổ, mở ra cuộc hành trình xuyên rừng già Tây Bắc tìm kiếm di tích thất lạc của nền văn minh Lạc Việt.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: kho báu tri thức người xưa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Kho báu tri thức người xưa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Kho báu tri thức người xưa —'),
(110010, 11, 10, 'Chương 10: Tiếng trống đồng vọng giữa đại ngàn', '【Chương 10: Tiếng trống đồng vọng giữa đại ngàn】 Câu chuyện của tác phẩm "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt" (tác giả: Vũ Thành Nam, thể loại: Phiêu lưu, Lịch sử, Linh dị) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nhà khảo cổ học trẻ tuổi Phong Sơn tình cờ giải mã được hoa văn trên mặt trống đồng cổ, mở ra cuộc hành trình xuyên rừng già Tây Bắc tìm kiếm di tích thất lạc của nền văn minh Lạc Việt.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: tiếng trống đồng vọng giữa đại ngàn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Cổ Mộ Kỳ Thư: Dấu Ấn Lạc Việt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Tiếng trống đồng vọng giữa đại ngàn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Tiếng trống đồng vọng giữa đại ngàn —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (12, 'Tiệm Trà Đêm Cuối Phố', 'Lâm Thảo Nguyên', 'https://picsum.photos/seed/novelreader-v3-12/300/450', 'Chỉ mở cửa từ mười một giờ đêm đến bốn giờ sáng, tiệm trà nhỏ của An Nhiên pha những ấm trà thảo mộc ấm áp giúp thực khách lắng nghe ký ức và chữa lành những tổn thương sâu kín nhất.', 'completed', 'novel', 'Chữa lành,Kỳ ảo,Ẩm thực', 10, 4.9, 910000, 1793800000000, 'tiem tra dem cuoi pho lam thao nguyen', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(120001, 12, 1, 'Chương 1: Ấm trà hoa cúc cho người mất ngủ', '【Chương 1: Ấm trà hoa cúc cho người mất ngủ】 Câu chuyện của tác phẩm "Tiệm Trà Đêm Cuối Phố" (tác giả: Lâm Thảo Nguyên, thể loại: Chữa lành, Kỳ ảo, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Chỉ mở cửa từ mười một giờ đêm đến bốn giờ sáng, tiệm trà nhỏ của An Nhiên pha những ấm trà thảo mộc ấm áp giúp thực khách lắng nghe ký ức và chữa lành những tổn thương sâu kín nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: ấm trà hoa cúc cho người mất ngủ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tiệm Trà Đêm Cuối Phố", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Ấm trà hoa cúc cho người mất ngủ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Ấm trà hoa cúc cho người mất ngủ —'),
(120002, 12, 2, 'Chương 2: Chiếc đồng hồ chạy ngược chiều', '【Chương 2: Chiếc đồng hồ chạy ngược chiều】 Câu chuyện của tác phẩm "Tiệm Trà Đêm Cuối Phố" (tác giả: Lâm Thảo Nguyên, thể loại: Chữa lành, Kỳ ảo, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Chỉ mở cửa từ mười một giờ đêm đến bốn giờ sáng, tiệm trà nhỏ của An Nhiên pha những ấm trà thảo mộc ấm áp giúp thực khách lắng nghe ký ức và chữa lành những tổn thương sâu kín nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: chiếc đồng hồ chạy ngược chiều, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tiệm Trà Đêm Cuối Phố", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Chiếc đồng hồ chạy ngược chiều tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Chiếc đồng hồ chạy ngược chiều —'),
(120003, 12, 3, 'Chương 3: Vị khách mang chiếc ô đỏ', '【Chương 3: Vị khách mang chiếc ô đỏ】 Câu chuyện của tác phẩm "Tiệm Trà Đêm Cuối Phố" (tác giả: Lâm Thảo Nguyên, thể loại: Chữa lành, Kỳ ảo, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Chỉ mở cửa từ mười một giờ đêm đến bốn giờ sáng, tiệm trà nhỏ của An Nhiên pha những ấm trà thảo mộc ấm áp giúp thực khách lắng nghe ký ức và chữa lành những tổn thương sâu kín nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: vị khách mang chiếc ô đỏ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tiệm Trà Đêm Cuối Phố", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Vị khách mang chiếc ô đỏ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Vị khách mang chiếc ô đỏ —'),
(120004, 12, 4, 'Chương 4: Hương trà sen ướp sương mai', '【Chương 4: Hương trà sen ướp sương mai】 Câu chuyện của tác phẩm "Tiệm Trà Đêm Cuối Phố" (tác giả: Lâm Thảo Nguyên, thể loại: Chữa lành, Kỳ ảo, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Chỉ mở cửa từ mười một giờ đêm đến bốn giờ sáng, tiệm trà nhỏ của An Nhiên pha những ấm trà thảo mộc ấm áp giúp thực khách lắng nghe ký ức và chữa lành những tổn thương sâu kín nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: hương trà sen ướp sương mai, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tiệm Trà Đêm Cuối Phố", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Hương trà sen ướp sương mai tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Hương trà sen ướp sương mai —'),
(120005, 12, 5, 'Chương 5: Bánh đậu xanh của bà ngoại', '【Chương 5: Bánh đậu xanh của bà ngoại】 Câu chuyện của tác phẩm "Tiệm Trà Đêm Cuối Phố" (tác giả: Lâm Thảo Nguyên, thể loại: Chữa lành, Kỳ ảo, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Chỉ mở cửa từ mười một giờ đêm đến bốn giờ sáng, tiệm trà nhỏ của An Nhiên pha những ấm trà thảo mộc ấm áp giúp thực khách lắng nghe ký ức và chữa lành những tổn thương sâu kín nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: bánh đậu xanh của bà ngoại, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tiệm Trà Đêm Cuối Phố", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Bánh đậu xanh của bà ngoại tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Bánh đậu xanh của bà ngoại —'),
(120006, 12, 6, 'Chương 6: Bản nhạc không lời trong đêm mưa', '【Chương 6: Bản nhạc không lời trong đêm mưa】 Câu chuyện của tác phẩm "Tiệm Trà Đêm Cuối Phố" (tác giả: Lâm Thảo Nguyên, thể loại: Chữa lành, Kỳ ảo, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Chỉ mở cửa từ mười một giờ đêm đến bốn giờ sáng, tiệm trà nhỏ của An Nhiên pha những ấm trà thảo mộc ấm áp giúp thực khách lắng nghe ký ức và chữa lành những tổn thương sâu kín nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: bản nhạc không lời trong đêm mưa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tiệm Trà Đêm Cuối Phố", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Bản nhạc không lời trong đêm mưa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Bản nhạc không lời trong đêm mưa —'),
(120007, 12, 7, 'Chương 7: Lá thư gửi về mười năm trước', '【Chương 7: Lá thư gửi về mười năm trước】 Câu chuyện của tác phẩm "Tiệm Trà Đêm Cuối Phố" (tác giả: Lâm Thảo Nguyên, thể loại: Chữa lành, Kỳ ảo, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Chỉ mở cửa từ mười một giờ đêm đến bốn giờ sáng, tiệm trà nhỏ của An Nhiên pha những ấm trà thảo mộc ấm áp giúp thực khách lắng nghe ký ức và chữa lành những tổn thương sâu kín nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: lá thư gửi về mười năm trước, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tiệm Trà Đêm Cuối Phố", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Lá thư gửi về mười năm trước tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Lá thư gửi về mười năm trước —'),
(120008, 12, 8, 'Chương 8: Chén trà ấm lúc giao thừa', '【Chương 8: Chén trà ấm lúc giao thừa】 Câu chuyện của tác phẩm "Tiệm Trà Đêm Cuối Phố" (tác giả: Lâm Thảo Nguyên, thể loại: Chữa lành, Kỳ ảo, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Chỉ mở cửa từ mười một giờ đêm đến bốn giờ sáng, tiệm trà nhỏ của An Nhiên pha những ấm trà thảo mộc ấm áp giúp thực khách lắng nghe ký ức và chữa lành những tổn thương sâu kín nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: chén trà ấm lúc giao thừa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tiệm Trà Đêm Cuối Phố", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Chén trà ấm lúc giao thừa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Chén trà ấm lúc giao thừa —'),
(120009, 12, 9, 'Chương 9: Bí mật của người pha trà', '【Chương 9: Bí mật của người pha trà】 Câu chuyện của tác phẩm "Tiệm Trà Đêm Cuối Phố" (tác giả: Lâm Thảo Nguyên, thể loại: Chữa lành, Kỳ ảo, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Chỉ mở cửa từ mười một giờ đêm đến bốn giờ sáng, tiệm trà nhỏ của An Nhiên pha những ấm trà thảo mộc ấm áp giúp thực khách lắng nghe ký ức và chữa lành những tổn thương sâu kín nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: bí mật của người pha trà, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tiệm Trà Đêm Cuối Phố", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Bí mật của người pha trà tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Bí mật của người pha trà —'),
(120010, 12, 10, 'Chương 10: Bình minh dịu dàng cuối con phố', '【Chương 10: Bình minh dịu dàng cuối con phố】 Câu chuyện của tác phẩm "Tiệm Trà Đêm Cuối Phố" (tác giả: Lâm Thảo Nguyên, thể loại: Chữa lành, Kỳ ảo, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Chỉ mở cửa từ mười một giờ đêm đến bốn giờ sáng, tiệm trà nhỏ của An Nhiên pha những ấm trà thảo mộc ấm áp giúp thực khách lắng nghe ký ức và chữa lành những tổn thương sâu kín nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: bình minh dịu dàng cuối con phố, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Tiệm Trà Đêm Cuối Phố", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Bình minh dịu dàng cuối con phố tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Bình minh dịu dàng cuối con phố —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (13, 'Chuyển Sinh Thành Thợ Rèn Ở Dị Giới', 'Minh Nhật', 'https://picsum.photos/seed/novelreader-v3-13/300/450', 'Kỹ sư luyện kim Khải Minh chuyển sinh sang thế giới kiếm và ma thuật với Hệ Thống Thợ Rèn Thần Cấp. Thay vì ra trận chém giết, cậu mở một lò rèn nhỏ nhưng mọi thanh kiếm cậu tạo ra đều làm rung chuyển lục địa.', 'ongoing', 'light_novel', 'Isekai,Fantasy,Hệ thống', 10, 4.7, 890000, 1793800000000, 'chuyen sinh thanh tho ren o di gioi minh nhat', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(130001, 13, 1, 'Chương 1: Lò rèn nhỏ ở thị trấn biên thùy', '【Chương 1: Lò rèn nhỏ ở thị trấn biên thùy】 Câu chuyện của tác phẩm "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới" (tác giả: Minh Nhật, thể loại: Isekai, Fantasy, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kỹ sư luyện kim Khải Minh chuyển sinh sang thế giới kiếm và ma thuật với Hệ Thống Thợ Rèn Thần Cấp. Thay vì ra trận chém giết, cậu mở một lò rèn nhỏ nhưng mọi thanh kiếm cậu tạo ra đều làm rung chuyển lục địa.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: lò rèn nhỏ ở thị trấn biên thùy, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Lò rèn nhỏ ở thị trấn biên thùy tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Lò rèn nhỏ ở thị trấn biên thùy —'),
(130002, 13, 2, 'Chương 2: Bản vẽ ma pháp trận trên lưỡi kiếm', '【Chương 2: Bản vẽ ma pháp trận trên lưỡi kiếm】 Câu chuyện của tác phẩm "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới" (tác giả: Minh Nhật, thể loại: Isekai, Fantasy, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kỹ sư luyện kim Khải Minh chuyển sinh sang thế giới kiếm và ma thuật với Hệ Thống Thợ Rèn Thần Cấp. Thay vì ra trận chém giết, cậu mở một lò rèn nhỏ nhưng mọi thanh kiếm cậu tạo ra đều làm rung chuyển lục địa.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: bản vẽ ma pháp trận trên lưỡi kiếm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Bản vẽ ma pháp trận trên lưỡi kiếm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Bản vẽ ma pháp trận trên lưỡi kiếm —'),
(130003, 13, 3, 'Chương 3: Thanh đoản kiếm cho nữ mạo hiểm giả', '【Chương 3: Thanh đoản kiếm cho nữ mạo hiểm giả】 Câu chuyện của tác phẩm "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới" (tác giả: Minh Nhật, thể loại: Isekai, Fantasy, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kỹ sư luyện kim Khải Minh chuyển sinh sang thế giới kiếm và ma thuật với Hệ Thống Thợ Rèn Thần Cấp. Thay vì ra trận chém giết, cậu mở một lò rèn nhỏ nhưng mọi thanh kiếm cậu tạo ra đều làm rung chuyển lục địa.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: thanh đoản kiếm cho nữ mạo hiểm giả, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Thanh đoản kiếm cho nữ mạo hiểm giả tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Thanh đoản kiếm cho nữ mạo hiểm giả —'),
(130004, 13, 4, 'Chương 4: Quặng Tinh Thiết ngàn năm', '【Chương 4: Quặng Tinh Thiết ngàn năm】 Câu chuyện của tác phẩm "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới" (tác giả: Minh Nhật, thể loại: Isekai, Fantasy, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kỹ sư luyện kim Khải Minh chuyển sinh sang thế giới kiếm và ma thuật với Hệ Thống Thợ Rèn Thần Cấp. Thay vì ra trận chém giết, cậu mở một lò rèn nhỏ nhưng mọi thanh kiếm cậu tạo ra đều làm rung chuyển lục địa.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: quặng tinh thiết ngàn năm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Quặng Tinh Thiết ngàn năm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Quặng Tinh Thiết ngàn năm —'),
(130005, 13, 5, 'Chương 5: Ngọn lửa Phượng Hoàng thức tỉnh', '【Chương 5: Ngọn lửa Phượng Hoàng thức tỉnh】 Câu chuyện của tác phẩm "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới" (tác giả: Minh Nhật, thể loại: Isekai, Fantasy, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kỹ sư luyện kim Khải Minh chuyển sinh sang thế giới kiếm và ma thuật với Hệ Thống Thợ Rèn Thần Cấp. Thay vì ra trận chém giết, cậu mở một lò rèn nhỏ nhưng mọi thanh kiếm cậu tạo ra đều làm rung chuyển lục địa.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: ngọn lửa phượng hoàng thức tỉnh, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Ngọn lửa Phượng Hoàng thức tỉnh tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Ngọn lửa Phượng Hoàng thức tỉnh —'),
(130006, 13, 6, 'Chương 6: Đơn đặt hàng của Hiệp Sĩ Đoàn', '【Chương 6: Đơn đặt hàng của Hiệp Sĩ Đoàn】 Câu chuyện của tác phẩm "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới" (tác giả: Minh Nhật, thể loại: Isekai, Fantasy, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kỹ sư luyện kim Khải Minh chuyển sinh sang thế giới kiếm và ma thuật với Hệ Thống Thợ Rèn Thần Cấp. Thay vì ra trận chém giết, cậu mở một lò rèn nhỏ nhưng mọi thanh kiếm cậu tạo ra đều làm rung chuyển lục địa.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: đơn đặt hàng của hiệp sĩ đoàn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Đơn đặt hàng của Hiệp Sĩ Đoàn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Đơn đặt hàng của Hiệp Sĩ Đoàn —'),
(130007, 13, 7, 'Chương 7: Khiên chắn rồng thiêng', '【Chương 7: Khiên chắn rồng thiêng】 Câu chuyện của tác phẩm "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới" (tác giả: Minh Nhật, thể loại: Isekai, Fantasy, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kỹ sư luyện kim Khải Minh chuyển sinh sang thế giới kiếm và ma thuật với Hệ Thống Thợ Rèn Thần Cấp. Thay vì ra trận chém giết, cậu mở một lò rèn nhỏ nhưng mọi thanh kiếm cậu tạo ra đều làm rung chuyển lục địa.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: khiên chắn rồng thiêng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Khiên chắn rồng thiêng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Khiên chắn rồng thiêng —'),
(130008, 13, 8, 'Chương 8: Đấu giá hội hoàng gia', '【Chương 8: Đấu giá hội hoàng gia】 Câu chuyện của tác phẩm "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới" (tác giả: Minh Nhật, thể loại: Isekai, Fantasy, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kỹ sư luyện kim Khải Minh chuyển sinh sang thế giới kiếm và ma thuật với Hệ Thống Thợ Rèn Thần Cấp. Thay vì ra trận chém giết, cậu mở một lò rèn nhỏ nhưng mọi thanh kiếm cậu tạo ra đều làm rung chuyển lục địa.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: đấu giá hội hoàng gia, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Đấu giá hội hoàng gia tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Đấu giá hội hoàng gia —'),
(130009, 13, 9, 'Chương 9: Thần khí xuất thế', '【Chương 9: Thần khí xuất thế】 Câu chuyện của tác phẩm "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới" (tác giả: Minh Nhật, thể loại: Isekai, Fantasy, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kỹ sư luyện kim Khải Minh chuyển sinh sang thế giới kiếm và ma thuật với Hệ Thống Thợ Rèn Thần Cấp. Thay vì ra trận chém giết, cậu mở một lò rèn nhỏ nhưng mọi thanh kiếm cậu tạo ra đều làm rung chuyển lục địa.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: thần khí xuất thế, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Thần khí xuất thế tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Thần khí xuất thế —'),
(130010, 13, 10, 'Chương 10: Danh hiệu Đại Tông Sư Rèn Đúc', '【Chương 10: Danh hiệu Đại Tông Sư Rèn Đúc】 Câu chuyện của tác phẩm "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới" (tác giả: Minh Nhật, thể loại: Isekai, Fantasy, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Kỹ sư luyện kim Khải Minh chuyển sinh sang thế giới kiếm và ma thuật với Hệ Thống Thợ Rèn Thần Cấp. Thay vì ra trận chém giết, cậu mở một lò rèn nhỏ nhưng mọi thanh kiếm cậu tạo ra đều làm rung chuyển lục địa.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: danh hiệu đại tông sư rèn đúc, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Chuyển Sinh Thành Thợ Rèn Ở Dị Giới", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Danh hiệu Đại Tông Sư Rèn Đúc tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Danh hiệu Đại Tông Sư Rèn Đúc —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (14, 'Câu Lạc Bộ Văn Học Sau Giờ Học', 'Hạ Miên', 'https://picsum.photos/seed/novelreader-v3-14/300/450', 'Vì muốn tìm một góc yên tĩnh đọc sách, Gia Huy gia nhập Câu lạc bộ Văn học sắp bị giải thể, nào ngờ lại vướng vào kế hoạch xuất bản tập san toàn trường cùng bốn thành viên siêu cá tính.', 'completed', 'light_novel', 'Học đường,Thanh xuân,Hài hước', 10, 4.6, 640000, 1793800000000, 'cau lac bo van hoc sau gio hoc ha mien', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(140001, 14, 1, 'Chương 1: Phòng sinh hoạt cuối hành lang tầng ba', '【Chương 1: Phòng sinh hoạt cuối hành lang tầng ba】 Câu chuyện của tác phẩm "Câu Lạc Bộ Văn Học Sau Giờ Học" (tác giả: Hạ Miên, thể loại: Học đường, Thanh xuân, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Vì muốn tìm một góc yên tĩnh đọc sách, Gia Huy gia nhập Câu lạc bộ Văn học sắp bị giải thể, nào ngờ lại vướng vào kế hoạch xuất bản tập san toàn trường cùng bốn thành viên siêu cá tính.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: phòng sinh hoạt cuối hành lang tầng ba, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Câu Lạc Bộ Văn Học Sau Giờ Học", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Phòng sinh hoạt cuối hành lang tầng ba tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Phòng sinh hoạt cuối hành lang tầng ba —'),
(140002, 14, 2, 'Chương 2: Vị hội trưởng chỉ thích viết thơ tình', '【Chương 2: Vị hội trưởng chỉ thích viết thơ tình】 Câu chuyện của tác phẩm "Câu Lạc Bộ Văn Học Sau Giờ Học" (tác giả: Hạ Miên, thể loại: Học đường, Thanh xuân, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Vì muốn tìm một góc yên tĩnh đọc sách, Gia Huy gia nhập Câu lạc bộ Văn học sắp bị giải thể, nào ngờ lại vướng vào kế hoạch xuất bản tập san toàn trường cùng bốn thành viên siêu cá tính.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: vị hội trưởng chỉ thích viết thơ tình, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Câu Lạc Bộ Văn Học Sau Giờ Học", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Vị hội trưởng chỉ thích viết thơ tình tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Vị hội trưởng chỉ thích viết thơ tình —'),
(140003, 14, 3, 'Chương 3: Chiến dịch tuyển thành viên mới', '【Chương 3: Chiến dịch tuyển thành viên mới】 Câu chuyện của tác phẩm "Câu Lạc Bộ Văn Học Sau Giờ Học" (tác giả: Hạ Miên, thể loại: Học đường, Thanh xuân, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Vì muốn tìm một góc yên tĩnh đọc sách, Gia Huy gia nhập Câu lạc bộ Văn học sắp bị giải thể, nào ngờ lại vướng vào kế hoạch xuất bản tập san toàn trường cùng bốn thành viên siêu cá tính.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: chiến dịch tuyển thành viên mới, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Câu Lạc Bộ Văn Học Sau Giờ Học", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Chiến dịch tuyển thành viên mới tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Chiến dịch tuyển thành viên mới —'),
(140004, 14, 4, 'Chương 4: Bản thảo đầu tay bị gió thổi bay', '【Chương 4: Bản thảo đầu tay bị gió thổi bay】 Câu chuyện của tác phẩm "Câu Lạc Bộ Văn Học Sau Giờ Học" (tác giả: Hạ Miên, thể loại: Học đường, Thanh xuân, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Vì muốn tìm một góc yên tĩnh đọc sách, Gia Huy gia nhập Câu lạc bộ Văn học sắp bị giải thể, nào ngờ lại vướng vào kế hoạch xuất bản tập san toàn trường cùng bốn thành viên siêu cá tính.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: bản thảo đầu tay bị gió thổi bay, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Câu Lạc Bộ Văn Học Sau Giờ Học", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Bản thảo đầu tay bị gió thổi bay tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Bản thảo đầu tay bị gió thổi bay —'),
(140005, 14, 5, 'Chương 5: Buổi họp nhóm ở tiệm bánh ngọt', '【Chương 5: Buổi họp nhóm ở tiệm bánh ngọt】 Câu chuyện của tác phẩm "Câu Lạc Bộ Văn Học Sau Giờ Học" (tác giả: Hạ Miên, thể loại: Học đường, Thanh xuân, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Vì muốn tìm một góc yên tĩnh đọc sách, Gia Huy gia nhập Câu lạc bộ Văn học sắp bị giải thể, nào ngờ lại vướng vào kế hoạch xuất bản tập san toàn trường cùng bốn thành viên siêu cá tính.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: buổi họp nhóm ở tiệm bánh ngọt, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Câu Lạc Bộ Văn Học Sau Giờ Học", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Buổi họp nhóm ở tiệm bánh ngọt tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Buổi họp nhóm ở tiệm bánh ngọt —'),
(140006, 14, 6, 'Chương 6: Lễ hội văn hóa mùa thu', '【Chương 6: Lễ hội văn hóa mùa thu】 Câu chuyện của tác phẩm "Câu Lạc Bộ Văn Học Sau Giờ Học" (tác giả: Hạ Miên, thể loại: Học đường, Thanh xuân, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Vì muốn tìm một góc yên tĩnh đọc sách, Gia Huy gia nhập Câu lạc bộ Văn học sắp bị giải thể, nào ngờ lại vướng vào kế hoạch xuất bản tập san toàn trường cùng bốn thành viên siêu cá tính.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: lễ hội văn hóa mùa thu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Câu Lạc Bộ Văn Học Sau Giờ Học", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Lễ hội văn hóa mùa thu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Lễ hội văn hóa mùa thu —'),
(140007, 14, 7, 'Chương 7: Cuộc thi viết truyện ngắn liên trường', '【Chương 7: Cuộc thi viết truyện ngắn liên trường】 Câu chuyện của tác phẩm "Câu Lạc Bộ Văn Học Sau Giờ Học" (tác giả: Hạ Miên, thể loại: Học đường, Thanh xuân, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Vì muốn tìm một góc yên tĩnh đọc sách, Gia Huy gia nhập Câu lạc bộ Văn học sắp bị giải thể, nào ngờ lại vướng vào kế hoạch xuất bản tập san toàn trường cùng bốn thành viên siêu cá tính.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: cuộc thi viết truyện ngắn liên trường, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Câu Lạc Bộ Văn Học Sau Giờ Học", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Cuộc thi viết truyện ngắn liên trường tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Cuộc thi viết truyện ngắn liên trường —'),
(140008, 14, 8, 'Chương 8: Cơn mưa chiều ngoài khung cửa lớp', '【Chương 8: Cơn mưa chiều ngoài khung cửa lớp】 Câu chuyện của tác phẩm "Câu Lạc Bộ Văn Học Sau Giờ Học" (tác giả: Hạ Miên, thể loại: Học đường, Thanh xuân, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Vì muốn tìm một góc yên tĩnh đọc sách, Gia Huy gia nhập Câu lạc bộ Văn học sắp bị giải thể, nào ngờ lại vướng vào kế hoạch xuất bản tập san toàn trường cùng bốn thành viên siêu cá tính.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: cơn mưa chiều ngoài khung cửa lớp, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Câu Lạc Bộ Văn Học Sau Giờ Học", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Cơn mưa chiều ngoài khung cửa lớp tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Cơn mưa chiều ngoài khung cửa lớp —'),
(140009, 14, 9, 'Chương 9: Tập san kỷ niệm ngày ra trường', '【Chương 9: Tập san kỷ niệm ngày ra trường】 Câu chuyện của tác phẩm "Câu Lạc Bộ Văn Học Sau Giờ Học" (tác giả: Hạ Miên, thể loại: Học đường, Thanh xuân, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Vì muốn tìm một góc yên tĩnh đọc sách, Gia Huy gia nhập Câu lạc bộ Văn học sắp bị giải thể, nào ngờ lại vướng vào kế hoạch xuất bản tập san toàn trường cùng bốn thành viên siêu cá tính.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: tập san kỷ niệm ngày ra trường, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Câu Lạc Bộ Văn Học Sau Giờ Học", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Tập san kỷ niệm ngày ra trường tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Tập san kỷ niệm ngày ra trường —'),
(140010, 14, 10, 'Chương 10: Hẹn gặp lại dưới hàng cây anh đào', '【Chương 10: Hẹn gặp lại dưới hàng cây anh đào】 Câu chuyện của tác phẩm "Câu Lạc Bộ Văn Học Sau Giờ Học" (tác giả: Hạ Miên, thể loại: Học đường, Thanh xuân, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Vì muốn tìm một góc yên tĩnh đọc sách, Gia Huy gia nhập Câu lạc bộ Văn học sắp bị giải thể, nào ngờ lại vướng vào kế hoạch xuất bản tập san toàn trường cùng bốn thành viên siêu cá tính.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: hẹn gặp lại dưới hàng cây anh đào, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Câu Lạc Bộ Văn Học Sau Giờ Học", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Hẹn gặp lại dưới hàng cây anh đào tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Hẹn gặp lại dưới hàng cây anh đào —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (15, 'Ma Vương Muốn Nghỉ Hưu Ở Quê', 'Bạch Vũ', 'https://picsum.photos/seed/novelreader-v3-15/300/450', 'Sau ba trăm năm trị vì Ma giới mệt mỏi vì giấy tờ hành chính, Ma Vương quyết định giả chết rồi về một ngôi làng hẻo lánh trồng rau nuôi cá, nào ngờ nữ Dũng Giả cũng dọn về ở ngay sát vách.', 'ongoing', 'light_novel', 'Fantasy,Điền văn,Hài hước', 10, 4.8, 780000, 1793800000000, 'ma vuong muon nghi huu o que bach vu', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(150001, 15, 1, 'Chương 1: Đơn xin từ chức của Ma Vương', '【Chương 1: Đơn xin từ chức của Ma Vương】 Câu chuyện của tác phẩm "Ma Vương Muốn Nghỉ Hưu Ở Quê" (tác giả: Bạch Vũ, thể loại: Fantasy, Điền văn, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau ba trăm năm trị vì Ma giới mệt mỏi vì giấy tờ hành chính, Ma Vương quyết định giả chết rồi về một ngôi làng hẻo lánh trồng rau nuôi cá, nào ngờ nữ Dũng Giả cũng dọn về ở ngay sát vách.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: đơn xin từ chức của ma vương, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ma Vương Muốn Nghỉ Hưu Ở Quê", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Đơn xin từ chức của Ma Vương tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Đơn xin từ chức của Ma Vương —'),
(150002, 15, 2, 'Chương 2: Mảnh vườn cải xanh bên bờ suối', '【Chương 2: Mảnh vườn cải xanh bên bờ suối】 Câu chuyện của tác phẩm "Ma Vương Muốn Nghỉ Hưu Ở Quê" (tác giả: Bạch Vũ, thể loại: Fantasy, Điền văn, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau ba trăm năm trị vì Ma giới mệt mỏi vì giấy tờ hành chính, Ma Vương quyết định giả chết rồi về một ngôi làng hẻo lánh trồng rau nuôi cá, nào ngờ nữ Dũng Giả cũng dọn về ở ngay sát vách.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: mảnh vườn cải xanh bên bờ suối, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ma Vương Muốn Nghỉ Hưu Ở Quê", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Mảnh vườn cải xanh bên bờ suối tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Mảnh vườn cải xanh bên bờ suối —'),
(150003, 15, 3, 'Chương 3: Hàng xóm mới lại là nữ Dũng Giả', '【Chương 3: Hàng xóm mới lại là nữ Dũng Giả】 Câu chuyện của tác phẩm "Ma Vương Muốn Nghỉ Hưu Ở Quê" (tác giả: Bạch Vũ, thể loại: Fantasy, Điền văn, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau ba trăm năm trị vì Ma giới mệt mỏi vì giấy tờ hành chính, Ma Vương quyết định giả chết rồi về một ngôi làng hẻo lánh trồng rau nuôi cá, nào ngờ nữ Dũng Giả cũng dọn về ở ngay sát vách.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: hàng xóm mới lại là nữ dũng giả, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ma Vương Muốn Nghỉ Hưu Ở Quê", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Hàng xóm mới lại là nữ Dũng Giả tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Hàng xóm mới lại là nữ Dũng Giả —'),
(150004, 15, 4, 'Chương 4: Dùng ma pháp cấp mười để tưới rau', '【Chương 4: Dùng ma pháp cấp mười để tưới rau】 Câu chuyện của tác phẩm "Ma Vương Muốn Nghỉ Hưu Ở Quê" (tác giả: Bạch Vũ, thể loại: Fantasy, Điền văn, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau ba trăm năm trị vì Ma giới mệt mỏi vì giấy tờ hành chính, Ma Vương quyết định giả chết rồi về một ngôi làng hẻo lánh trồng rau nuôi cá, nào ngờ nữ Dũng Giả cũng dọn về ở ngay sát vách.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: dùng ma pháp cấp mười để tưới rau, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ma Vương Muốn Nghỉ Hưu Ở Quê", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Dùng ma pháp cấp mười để tưới rau tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Dùng ma pháp cấp mười để tưới rau —'),
(150005, 15, 5, 'Chương 5: Con chó canh nhà hóa ra là Địa Ngục Khuyển', '【Chương 5: Con chó canh nhà hóa ra là Địa Ngục Khuyển】 Câu chuyện của tác phẩm "Ma Vương Muốn Nghỉ Hưu Ở Quê" (tác giả: Bạch Vũ, thể loại: Fantasy, Điền văn, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau ba trăm năm trị vì Ma giới mệt mỏi vì giấy tờ hành chính, Ma Vương quyết định giả chết rồi về một ngôi làng hẻo lánh trồng rau nuôi cá, nào ngờ nữ Dũng Giả cũng dọn về ở ngay sát vách.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: con chó canh nhà hóa ra là địa ngục khuyển, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ma Vương Muốn Nghỉ Hưu Ở Quê", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Con chó canh nhà hóa ra là Địa Ngục Khuyển tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Con chó canh nhà hóa ra là Địa Ngục Khuyển —'),
(150006, 15, 6, 'Chương 6: Phiên chợ quê ngày cuối tuần', '【Chương 6: Phiên chợ quê ngày cuối tuần】 Câu chuyện của tác phẩm "Ma Vương Muốn Nghỉ Hưu Ở Quê" (tác giả: Bạch Vũ, thể loại: Fantasy, Điền văn, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau ba trăm năm trị vì Ma giới mệt mỏi vì giấy tờ hành chính, Ma Vương quyết định giả chết rồi về một ngôi làng hẻo lánh trồng rau nuôi cá, nào ngờ nữ Dũng Giả cũng dọn về ở ngay sát vách.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: phiên chợ quê ngày cuối tuần, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ma Vương Muốn Nghỉ Hưu Ở Quê", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Phiên chợ quê ngày cuối tuần tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Phiên chợ quê ngày cuối tuần —'),
(150007, 15, 7, 'Chương 7: Bữa lẩu rau rừng ấm cúng', '【Chương 7: Bữa lẩu rau rừng ấm cúng】 Câu chuyện của tác phẩm "Ma Vương Muốn Nghỉ Hưu Ở Quê" (tác giả: Bạch Vũ, thể loại: Fantasy, Điền văn, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau ba trăm năm trị vì Ma giới mệt mỏi vì giấy tờ hành chính, Ma Vương quyết định giả chết rồi về một ngôi làng hẻo lánh trồng rau nuôi cá, nào ngờ nữ Dũng Giả cũng dọn về ở ngay sát vách.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: bữa lẩu rau rừng ấm cúng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ma Vương Muốn Nghỉ Hưu Ở Quê", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Bữa lẩu rau rừng ấm cúng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Bữa lẩu rau rừng ấm cúng —'),
(150008, 15, 8, 'Chương 8: Bộ hạ cũ tìm đến tận làng', '【Chương 8: Bộ hạ cũ tìm đến tận làng】 Câu chuyện của tác phẩm "Ma Vương Muốn Nghỉ Hưu Ở Quê" (tác giả: Bạch Vũ, thể loại: Fantasy, Điền văn, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau ba trăm năm trị vì Ma giới mệt mỏi vì giấy tờ hành chính, Ma Vương quyết định giả chết rồi về một ngôi làng hẻo lánh trồng rau nuôi cá, nào ngờ nữ Dũng Giả cũng dọn về ở ngay sát vách.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: bộ hạ cũ tìm đến tận làng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ma Vương Muốn Nghỉ Hưu Ở Quê", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Bộ hạ cũ tìm đến tận làng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Bộ hạ cũ tìm đến tận làng —'),
(150009, 15, 9, 'Chương 9: Bảo vệ mùa màng khỏi bão lớn', '【Chương 9: Bảo vệ mùa màng khỏi bão lớn】 Câu chuyện của tác phẩm "Ma Vương Muốn Nghỉ Hưu Ở Quê" (tác giả: Bạch Vũ, thể loại: Fantasy, Điền văn, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau ba trăm năm trị vì Ma giới mệt mỏi vì giấy tờ hành chính, Ma Vương quyết định giả chết rồi về một ngôi làng hẻo lánh trồng rau nuôi cá, nào ngờ nữ Dũng Giả cũng dọn về ở ngay sát vách.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: bảo vệ mùa màng khỏi bão lớn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ma Vương Muốn Nghỉ Hưu Ở Quê", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Bảo vệ mùa màng khỏi bão lớn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Bảo vệ mùa màng khỏi bão lớn —'),
(150010, 15, 10, 'Chương 10: Cuộc sống điền viên bình yên', '【Chương 10: Cuộc sống điền viên bình yên】 Câu chuyện của tác phẩm "Ma Vương Muốn Nghỉ Hưu Ở Quê" (tác giả: Bạch Vũ, thể loại: Fantasy, Điền văn, Hài hước) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sau ba trăm năm trị vì Ma giới mệt mỏi vì giấy tờ hành chính, Ma Vương quyết định giả chết rồi về một ngôi làng hẻo lánh trồng rau nuôi cá, nào ngờ nữ Dũng Giả cũng dọn về ở ngay sát vách.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: cuộc sống điền viên bình yên, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ma Vương Muốn Nghỉ Hưu Ở Quê", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Cuộc sống điền viên bình yên tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Cuộc sống điền viên bình yên —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (16, 'Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói', 'Tuyết Linh', 'https://picsum.photos/seed/novelreader-v3-16/300/450', 'Nữ sinh trung học Minh Châu vô tình cứu một chú mèo đen biết nói tiếng người và nhìn thấy dấu vết ma thuật, từ đó cả hai hợp sức phá giải những vụ việc kỳ bí trong thành phố cảng.', 'ongoing', 'light_novel', 'Trinh thám,Kỳ ảo,Học đường', 10, 4.7, 610000, 1793800000000, 'thieu nu tham tu va con meo den biet noi tuyet linh', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(160001, 16, 1, 'Chương 1: Quý ngài mèo đen đội mũ phớt', '【Chương 1: Quý ngài mèo đen đội mũ phớt】 Câu chuyện của tác phẩm "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói" (tác giả: Tuyết Linh, thể loại: Trinh thám, Kỳ ảo, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nữ sinh trung học Minh Châu vô tình cứu một chú mèo đen biết nói tiếng người và nhìn thấy dấu vết ma thuật, từ đó cả hai hợp sức phá giải những vụ việc kỳ bí trong thành phố cảng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: quý ngài mèo đen đội mũ phớt, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Quý ngài mèo đen đội mũ phớt tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Quý ngài mèo đen đội mũ phớt —'),
(160002, 16, 2, 'Chương 2: Vụ mất tích chiếc vĩ cầm cổ', '【Chương 2: Vụ mất tích chiếc vĩ cầm cổ】 Câu chuyện của tác phẩm "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói" (tác giả: Tuyết Linh, thể loại: Trinh thám, Kỳ ảo, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nữ sinh trung học Minh Châu vô tình cứu một chú mèo đen biết nói tiếng người và nhìn thấy dấu vết ma thuật, từ đó cả hai hợp sức phá giải những vụ việc kỳ bí trong thành phố cảng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: vụ mất tích chiếc vĩ cầm cổ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Vụ mất tích chiếc vĩ cầm cổ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Vụ mất tích chiếc vĩ cầm cổ —'),
(160003, 16, 3, 'Chương 3: Dấu chân phát sáng trên bến cảng', '【Chương 3: Dấu chân phát sáng trên bến cảng】 Câu chuyện của tác phẩm "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói" (tác giả: Tuyết Linh, thể loại: Trinh thám, Kỳ ảo, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nữ sinh trung học Minh Châu vô tình cứu một chú mèo đen biết nói tiếng người và nhìn thấy dấu vết ma thuật, từ đó cả hai hợp sức phá giải những vụ việc kỳ bí trong thành phố cảng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: dấu chân phát sáng trên bến cảng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Dấu chân phát sáng trên bến cảng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Dấu chân phát sáng trên bến cảng —'),
(160004, 16, 4, 'Chương 4: Thư viện ngầm dưới tháp chuông', '【Chương 4: Thư viện ngầm dưới tháp chuông】 Câu chuyện của tác phẩm "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói" (tác giả: Tuyết Linh, thể loại: Trinh thám, Kỳ ảo, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nữ sinh trung học Minh Châu vô tình cứu một chú mèo đen biết nói tiếng người và nhìn thấy dấu vết ma thuật, từ đó cả hai hợp sức phá giải những vụ việc kỳ bí trong thành phố cảng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: thư viện ngầm dưới tháp chuông, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Thư viện ngầm dưới tháp chuông tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Thư viện ngầm dưới tháp chuông —'),
(160005, 16, 5, 'Chương 5: Bóng ma trong rạp hát cũ', '【Chương 5: Bóng ma trong rạp hát cũ】 Câu chuyện của tác phẩm "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói" (tác giả: Tuyết Linh, thể loại: Trinh thám, Kỳ ảo, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nữ sinh trung học Minh Châu vô tình cứu một chú mèo đen biết nói tiếng người và nhìn thấy dấu vết ma thuật, từ đó cả hai hợp sức phá giải những vụ việc kỳ bí trong thành phố cảng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: bóng ma trong rạp hát cũ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Bóng ma trong rạp hát cũ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Bóng ma trong rạp hát cũ —'),
(160006, 16, 6, 'Chương 6: Mật mã trong hộp nhạc bạc', '【Chương 6: Mật mã trong hộp nhạc bạc】 Câu chuyện của tác phẩm "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói" (tác giả: Tuyết Linh, thể loại: Trinh thám, Kỳ ảo, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nữ sinh trung học Minh Châu vô tình cứu một chú mèo đen biết nói tiếng người và nhìn thấy dấu vết ma thuật, từ đó cả hai hợp sức phá giải những vụ việc kỳ bí trong thành phố cảng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: mật mã trong hộp nhạc bạc, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Mật mã trong hộp nhạc bạc tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Mật mã trong hộp nhạc bạc —'),
(160007, 16, 7, 'Chương 7: Chuyến tàu đêm xuyên sương mù', '【Chương 7: Chuyến tàu đêm xuyên sương mù】 Câu chuyện của tác phẩm "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói" (tác giả: Tuyết Linh, thể loại: Trinh thám, Kỳ ảo, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nữ sinh trung học Minh Châu vô tình cứu một chú mèo đen biết nói tiếng người và nhìn thấy dấu vết ma thuật, từ đó cả hai hợp sức phá giải những vụ việc kỳ bí trong thành phố cảng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: chuyến tàu đêm xuyên sương mù, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Chuyến tàu đêm xuyên sương mù tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Chuyến tàu đêm xuyên sương mù —'),
(160008, 16, 8, 'Chương 8: Kẻ đánh cắp ký ức', '【Chương 8: Kẻ đánh cắp ký ức】 Câu chuyện của tác phẩm "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói" (tác giả: Tuyết Linh, thể loại: Trinh thám, Kỳ ảo, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nữ sinh trung học Minh Châu vô tình cứu một chú mèo đen biết nói tiếng người và nhìn thấy dấu vết ma thuật, từ đó cả hai hợp sức phá giải những vụ việc kỳ bí trong thành phố cảng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: kẻ đánh cắp ký ức, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Kẻ đánh cắp ký ức tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Kẻ đánh cắp ký ức —'),
(160009, 16, 9, 'Chương 9: Phiên tòa dưới ánh trăng', '【Chương 9: Phiên tòa dưới ánh trăng】 Câu chuyện của tác phẩm "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói" (tác giả: Tuyết Linh, thể loại: Trinh thám, Kỳ ảo, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nữ sinh trung học Minh Châu vô tình cứu một chú mèo đen biết nói tiếng người và nhìn thấy dấu vết ma thuật, từ đó cả hai hợp sức phá giải những vụ việc kỳ bí trong thành phố cảng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: phiên tòa dưới ánh trăng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Phiên tòa dưới ánh trăng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Phiên tòa dưới ánh trăng —'),
(160010, 16, 10, 'Chương 10: Cộng sự ăn ý nhất thế gian', '【Chương 10: Cộng sự ăn ý nhất thế gian】 Câu chuyện của tác phẩm "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói" (tác giả: Tuyết Linh, thể loại: Trinh thám, Kỳ ảo, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Nữ sinh trung học Minh Châu vô tình cứu một chú mèo đen biết nói tiếng người và nhìn thấy dấu vết ma thuật, từ đó cả hai hợp sức phá giải những vụ việc kỳ bí trong thành phố cảng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: cộng sự ăn ý nhất thế gian, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiếu Nữ Thám Tử Và Con Mèo Đen Biết Nói", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Cộng sự ăn ý nhất thế gian tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Cộng sự ăn ý nhất thế gian —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (17, 'Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia', 'Hoàng Thiên', 'https://picsum.photos/seed/novelreader-v3-17/300/450', 'Không có thiên phú ma pháp nguyên tố nhưng sở hữu thể chất phá giải mọi ma trận, thiếu niên Lôi Vũ bước vào Học Viện Hoàng Gia và làm đảo lộn bảng xếp hạng thực lực.', 'ongoing', 'light_novel', 'Học đường,Fantasy,Hành động', 10, 4.8, 930000, 1793800000000, 'kiem si cap f va hoc vien ma thuat hoang gia hoang thien', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(170001, 17, 1, 'Chương 1: Bài kiểm tra ma lực bằng không', '【Chương 1: Bài kiểm tra ma lực bằng không】 Câu chuyện của tác phẩm "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia" (tác giả: Hoàng Thiên, thể loại: Học đường, Fantasy, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Không có thiên phú ma pháp nguyên tố nhưng sở hữu thể chất phá giải mọi ma trận, thiếu niên Lôi Vũ bước vào Học Viện Hoàng Gia và làm đảo lộn bảng xếp hạng thực lực.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: bài kiểm tra ma lực bằng không, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Bài kiểm tra ma lực bằng không tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Bài kiểm tra ma lực bằng không —'),
(170002, 17, 2, 'Chương 2: Thanh kiếm gỗ chém đứt cầu lửa', '【Chương 2: Thanh kiếm gỗ chém đứt cầu lửa】 Câu chuyện của tác phẩm "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia" (tác giả: Hoàng Thiên, thể loại: Học đường, Fantasy, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Không có thiên phú ma pháp nguyên tố nhưng sở hữu thể chất phá giải mọi ma trận, thiếu niên Lôi Vũ bước vào Học Viện Hoàng Gia và làm đảo lộn bảng xếp hạng thực lực.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: thanh kiếm gỗ chém đứt cầu lửa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Thanh kiếm gỗ chém đứt cầu lửa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Thanh kiếm gỗ chém đứt cầu lửa —'),
(170003, 17, 3, 'Chương 3: Lớp học đặc biệt khu rừng phía đông', '【Chương 3: Lớp học đặc biệt khu rừng phía đông】 Câu chuyện của tác phẩm "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia" (tác giả: Hoàng Thiên, thể loại: Học đường, Fantasy, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Không có thiên phú ma pháp nguyên tố nhưng sở hữu thể chất phá giải mọi ma trận, thiếu niên Lôi Vũ bước vào Học Viện Hoàng Gia và làm đảo lộn bảng xếp hạng thực lực.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: lớp học đặc biệt khu rừng phía đông, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Lớp học đặc biệt khu rừng phía đông tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Lớp học đặc biệt khu rừng phía đông —'),
(170004, 17, 4, 'Chương 4: Giải đấu tân sinh toàn học viện', '【Chương 4: Giải đấu tân sinh toàn học viện】 Câu chuyện của tác phẩm "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia" (tác giả: Hoàng Thiên, thể loại: Học đường, Fantasy, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Không có thiên phú ma pháp nguyên tố nhưng sở hữu thể chất phá giải mọi ma trận, thiếu niên Lôi Vũ bước vào Học Viện Hoàng Gia và làm đảo lộn bảng xếp hạng thực lực.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: giải đấu tân sinh toàn học viện, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Giải đấu tân sinh toàn học viện tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Giải đấu tân sinh toàn học viện —'),
(170005, 17, 5, 'Chương 5: Ma đạo sư bí ẩn trong thư viện', '【Chương 5: Ma đạo sư bí ẩn trong thư viện】 Câu chuyện của tác phẩm "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia" (tác giả: Hoàng Thiên, thể loại: Học đường, Fantasy, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Không có thiên phú ma pháp nguyên tố nhưng sở hữu thể chất phá giải mọi ma trận, thiếu niên Lôi Vũ bước vào Học Viện Hoàng Gia và làm đảo lộn bảng xếp hạng thực lực.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: ma đạo sư bí ẩn trong thư viện, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Ma đạo sư bí ẩn trong thư viện tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Ma đạo sư bí ẩn trong thư viện —'),
(170006, 17, 6, 'Chương 6: Mê cung ngầm dưới lòng đất', '【Chương 6: Mê cung ngầm dưới lòng đất】 Câu chuyện của tác phẩm "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia" (tác giả: Hoàng Thiên, thể loại: Học đường, Fantasy, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Không có thiên phú ma pháp nguyên tố nhưng sở hữu thể chất phá giải mọi ma trận, thiếu niên Lôi Vũ bước vào Học Viện Hoàng Gia và làm đảo lộn bảng xếp hạng thực lực.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: mê cung ngầm dưới lòng đất, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Mê cung ngầm dưới lòng đất tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Mê cung ngầm dưới lòng đất —'),
(170007, 17, 7, 'Chương 7: Đòn kiếm tốc độ ánh sáng', '【Chương 7: Đòn kiếm tốc độ ánh sáng】 Câu chuyện của tác phẩm "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia" (tác giả: Hoàng Thiên, thể loại: Học đường, Fantasy, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Không có thiên phú ma pháp nguyên tố nhưng sở hữu thể chất phá giải mọi ma trận, thiếu niên Lôi Vũ bước vào Học Viện Hoàng Gia và làm đảo lộn bảng xếp hạng thực lực.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: đòn kiếm tốc độ ánh sáng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Đòn kiếm tốc độ ánh sáng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Đòn kiếm tốc độ ánh sáng —'),
(170008, 17, 8, 'Chương 8: Bảo vệ học viện trong đêm nguyệt thực', '【Chương 8: Bảo vệ học viện trong đêm nguyệt thực】 Câu chuyện của tác phẩm "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia" (tác giả: Hoàng Thiên, thể loại: Học đường, Fantasy, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Không có thiên phú ma pháp nguyên tố nhưng sở hữu thể chất phá giải mọi ma trận, thiếu niên Lôi Vũ bước vào Học Viện Hoàng Gia và làm đảo lộn bảng xếp hạng thực lực.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: bảo vệ học viện trong đêm nguyệt thực, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Bảo vệ học viện trong đêm nguyệt thực tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Bảo vệ học viện trong đêm nguyệt thực —'),
(170009, 17, 9, 'Chương 9: Huân chương Hiệp Sĩ danh dự', '【Chương 9: Huân chương Hiệp Sĩ danh dự】 Câu chuyện của tác phẩm "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia" (tác giả: Hoàng Thiên, thể loại: Học đường, Fantasy, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Không có thiên phú ma pháp nguyên tố nhưng sở hữu thể chất phá giải mọi ma trận, thiếu niên Lôi Vũ bước vào Học Viện Hoàng Gia và làm đảo lộn bảng xếp hạng thực lực.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: huân chương hiệp sĩ danh dự, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Huân chương Hiệp Sĩ danh dự tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Huân chương Hiệp Sĩ danh dự —'),
(170010, 17, 10, 'Chương 10: Bước lên đỉnh tháp Hoàng Gia', '【Chương 10: Bước lên đỉnh tháp Hoàng Gia】 Câu chuyện của tác phẩm "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia" (tác giả: Hoàng Thiên, thể loại: Học đường, Fantasy, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Không có thiên phú ma pháp nguyên tố nhưng sở hữu thể chất phá giải mọi ma trận, thiếu niên Lôi Vũ bước vào Học Viện Hoàng Gia và làm đảo lộn bảng xếp hạng thực lực.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: bước lên đỉnh tháp hoàng gia, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kiếm Sĩ Cấp F Và Học Viện Ma Thuật Hoàng Gia", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Bước lên đỉnh tháp Hoàng Gia tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Bước lên đỉnh tháp Hoàng Gia —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (18, 'Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác', 'Đặng Trúc', 'https://picsum.photos/seed/novelreader-v3-18/300/450', 'Cứ mỗi tối thứ Sáu, cánh cửa gỗ của quán cà phê nhỏ tại Sài Gòn lại kết nối với vương quốc Elf và tộc Người Lùn. Hương cà phê phin và bánh ngọt Việt Nam chinh phục trái tim thực khách dị giới.', 'completed', 'light_novel', 'Isekai,Ẩm thực,Chữa lành', 10, 4.9, 820000, 1793800000000, 'quan ca phe dem thu sau o the gioi khac dang truc', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(180001, 18, 1, 'Chương 1: Cánh cửa gỗ rung chuông lúc nửa đêm', '【Chương 1: Cánh cửa gỗ rung chuông lúc nửa đêm】 Câu chuyện của tác phẩm "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác" (tác giả: Đặng Trúc, thể loại: Isekai, Ẩm thực, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cứ mỗi tối thứ Sáu, cánh cửa gỗ của quán cà phê nhỏ tại Sài Gòn lại kết nối với vương quốc Elf và tộc Người Lùn. Hương cà phê phin và bánh ngọt Việt Nam chinh phục trái tim thực khách dị giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: cánh cửa gỗ rung chuông lúc nửa đêm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Cánh cửa gỗ rung chuông lúc nửa đêm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Cánh cửa gỗ rung chuông lúc nửa đêm —'),
(180002, 18, 2, 'Chương 2: Vị khách Elf đầu tiên và ly bạc xỉu', '【Chương 2: Vị khách Elf đầu tiên và ly bạc xỉu】 Câu chuyện của tác phẩm "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác" (tác giả: Đặng Trúc, thể loại: Isekai, Ẩm thực, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cứ mỗi tối thứ Sáu, cánh cửa gỗ của quán cà phê nhỏ tại Sài Gòn lại kết nối với vương quốc Elf và tộc Người Lùn. Hương cà phê phin và bánh ngọt Việt Nam chinh phục trái tim thực khách dị giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: vị khách elf đầu tiên và ly bạc xỉu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Vị khách Elf đầu tiên và ly bạc xỉu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Vị khách Elf đầu tiên và ly bạc xỉu —'),
(180003, 18, 3, 'Chương 3: Bánh mì giòn nóng cho hiệp sĩ tuần tra', '【Chương 3: Bánh mì giòn nóng cho hiệp sĩ tuần tra】 Câu chuyện của tác phẩm "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác" (tác giả: Đặng Trúc, thể loại: Isekai, Ẩm thực, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cứ mỗi tối thứ Sáu, cánh cửa gỗ của quán cà phê nhỏ tại Sài Gòn lại kết nối với vương quốc Elf và tộc Người Lùn. Hương cà phê phin và bánh ngọt Việt Nam chinh phục trái tim thực khách dị giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: bánh mì giòn nóng cho hiệp sĩ tuần tra, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Bánh mì giòn nóng cho hiệp sĩ tuần tra tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Bánh mì giòn nóng cho hiệp sĩ tuần tra —'),
(180004, 18, 4, 'Chương 4: Người Lùn mê mẩn cà phê trứng', '【Chương 4: Người Lùn mê mẩn cà phê trứng】 Câu chuyện của tác phẩm "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác" (tác giả: Đặng Trúc, thể loại: Isekai, Ẩm thực, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cứ mỗi tối thứ Sáu, cánh cửa gỗ của quán cà phê nhỏ tại Sài Gòn lại kết nối với vương quốc Elf và tộc Người Lùn. Hương cà phê phin và bánh ngọt Việt Nam chinh phục trái tim thực khách dị giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: người lùn mê mẩn cà phê trứng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Người Lùn mê mẩn cà phê trứng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Người Lùn mê mẩn cà phê trứng —'),
(180005, 18, 5, 'Chương 5: Pháp sư hoàng cung tìm công thức flan', '【Chương 5: Pháp sư hoàng cung tìm công thức flan】 Câu chuyện của tác phẩm "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác" (tác giả: Đặng Trúc, thể loại: Isekai, Ẩm thực, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cứ mỗi tối thứ Sáu, cánh cửa gỗ của quán cà phê nhỏ tại Sài Gòn lại kết nối với vương quốc Elf và tộc Người Lùn. Hương cà phê phin và bánh ngọt Việt Nam chinh phục trái tim thực khách dị giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: pháp sư hoàng cung tìm công thức flan, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Pháp sư hoàng cung tìm công thức flan tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Pháp sư hoàng cung tìm công thức flan —'),
(180006, 18, 6, 'Chương 6: Đêm mưa bão và tô phở bò nghi ngút khói', '【Chương 6: Đêm mưa bão và tô phở bò nghi ngút khói】 Câu chuyện của tác phẩm "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác" (tác giả: Đặng Trúc, thể loại: Isekai, Ẩm thực, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cứ mỗi tối thứ Sáu, cánh cửa gỗ của quán cà phê nhỏ tại Sài Gòn lại kết nối với vương quốc Elf và tộc Người Lùn. Hương cà phê phin và bánh ngọt Việt Nam chinh phục trái tim thực khách dị giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: đêm mưa bão và tô phở bò nghi ngút khói, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Đêm mưa bão và tô phở bò nghi ngút khói tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Đêm mưa bão và tô phở bò nghi ngút khói —'),
(180007, 18, 7, 'Chương 7: Hạt cà phê trồng trên thảo nguyên gió', '【Chương 7: Hạt cà phê trồng trên thảo nguyên gió】 Câu chuyện của tác phẩm "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác" (tác giả: Đặng Trúc, thể loại: Isekai, Ẩm thực, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cứ mỗi tối thứ Sáu, cánh cửa gỗ của quán cà phê nhỏ tại Sài Gòn lại kết nối với vương quốc Elf và tộc Người Lùn. Hương cà phê phin và bánh ngọt Việt Nam chinh phục trái tim thực khách dị giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: hạt cà phê trồng trên thảo nguyên gió, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Hạt cà phê trồng trên thảo nguyên gió tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Hạt cà phê trồng trên thảo nguyên gió —'),
(180008, 18, 8, 'Chương 8: Buổi hòa nhạc nhỏ trong quán đêm', '【Chương 8: Buổi hòa nhạc nhỏ trong quán đêm】 Câu chuyện của tác phẩm "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác" (tác giả: Đặng Trúc, thể loại: Isekai, Ẩm thực, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cứ mỗi tối thứ Sáu, cánh cửa gỗ của quán cà phê nhỏ tại Sài Gòn lại kết nối với vương quốc Elf và tộc Người Lùn. Hương cà phê phin và bánh ngọt Việt Nam chinh phục trái tim thực khách dị giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: buổi hòa nhạc nhỏ trong quán đêm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Buổi hòa nhạc nhỏ trong quán đêm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Buổi hòa nhạc nhỏ trong quán đêm —'),
(180009, 18, 9, 'Chương 9: Lời cảm ơn từ nữ hoàng Tinh Linh', '【Chương 9: Lời cảm ơn từ nữ hoàng Tinh Linh】 Câu chuyện của tác phẩm "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác" (tác giả: Đặng Trúc, thể loại: Isekai, Ẩm thực, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cứ mỗi tối thứ Sáu, cánh cửa gỗ của quán cà phê nhỏ tại Sài Gòn lại kết nối với vương quốc Elf và tộc Người Lùn. Hương cà phê phin và bánh ngọt Việt Nam chinh phục trái tim thực khách dị giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: lời cảm ơn từ nữ hoàng tinh linh, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Lời cảm ơn từ nữ hoàng Tinh Linh tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Lời cảm ơn từ nữ hoàng Tinh Linh —'),
(180010, 18, 10, 'Chương 10: Hương thơm nối liền hai thế giới', '【Chương 10: Hương thơm nối liền hai thế giới】 Câu chuyện của tác phẩm "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác" (tác giả: Đặng Trúc, thể loại: Isekai, Ẩm thực, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cứ mỗi tối thứ Sáu, cánh cửa gỗ của quán cà phê nhỏ tại Sài Gòn lại kết nối với vương quốc Elf và tộc Người Lùn. Hương cà phê phin và bánh ngọt Việt Nam chinh phục trái tim thực khách dị giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: hương thơm nối liền hai thế giới, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Quán Cà Phê Đêm Thứ Sáu Ở Thế Giới Khác", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Hương thơm nối liền hai thế giới tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Hương thơm nối liền hai thế giới —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (19, 'Thư Viện Cuối Cùng Ở Tận Thế', 'Trịnh Khôi', 'https://picsum.photos/seed/novelreader-v3-19/300/450', 'Khi mặt đất bị bao phủ bởi bão từ và sinh vật biến dị, thủ thư trẻ tuổi Thiên Ân cùng đội hộ vệ cơ giới vượt qua hoang mạc để thu thập và bảo tồn những cuốn sách giấy cuối cùng của nhân loại.', 'ongoing', 'light_novel', 'Mạt thế,Khoa huyễn,Phiêu lưu', 10, 4.7, 750000, 1793800000000, 'thu vien cuoi cung o tan the trinh khoi', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(190001, 19, 1, 'Chương 1: Hầm trú ẩn số 09 dưới lòng thành phố', '【Chương 1: Hầm trú ẩn số 09 dưới lòng thành phố】 Câu chuyện của tác phẩm "Thư Viện Cuối Cùng Ở Tận Thế" (tác giả: Trịnh Khôi, thể loại: Mạt thế, Khoa huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mặt đất bị bao phủ bởi bão từ và sinh vật biến dị, thủ thư trẻ tuổi Thiên Ân cùng đội hộ vệ cơ giới vượt qua hoang mạc để thu thập và bảo tồn những cuốn sách giấy cuối cùng của nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: hầm trú ẩn số 09 dưới lòng thành phố, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thư Viện Cuối Cùng Ở Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Hầm trú ẩn số 09 dưới lòng thành phố tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Hầm trú ẩn số 09 dưới lòng thành phố —'),
(190002, 19, 2, 'Chương 2: Cuốn từ điển bách khoa trong đống đổ nát', '【Chương 2: Cuốn từ điển bách khoa trong đống đổ nát】 Câu chuyện của tác phẩm "Thư Viện Cuối Cùng Ở Tận Thế" (tác giả: Trịnh Khôi, thể loại: Mạt thế, Khoa huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mặt đất bị bao phủ bởi bão từ và sinh vật biến dị, thủ thư trẻ tuổi Thiên Ân cùng đội hộ vệ cơ giới vượt qua hoang mạc để thu thập và bảo tồn những cuốn sách giấy cuối cùng của nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: cuốn từ điển bách khoa trong đống đổ nát, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thư Viện Cuối Cùng Ở Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Cuốn từ điển bách khoa trong đống đổ nát tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Cuốn từ điển bách khoa trong đống đổ nát —'),
(190003, 19, 3, 'Chương 3: Đoàn xe bọc thép vượt bão cát', '【Chương 3: Đoàn xe bọc thép vượt bão cát】 Câu chuyện của tác phẩm "Thư Viện Cuối Cùng Ở Tận Thế" (tác giả: Trịnh Khôi, thể loại: Mạt thế, Khoa huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mặt đất bị bao phủ bởi bão từ và sinh vật biến dị, thủ thư trẻ tuổi Thiên Ân cùng đội hộ vệ cơ giới vượt qua hoang mạc để thu thập và bảo tồn những cuốn sách giấy cuối cùng của nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: đoàn xe bọc thép vượt bão cát, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thư Viện Cuối Cùng Ở Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Đoàn xe bọc thép vượt bão cát tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Đoàn xe bọc thép vượt bão cát —'),
(190004, 19, 4, 'Chương 4: Robot thủ thư mang ký hiệu A-12', '【Chương 4: Robot thủ thư mang ký hiệu A-12】 Câu chuyện của tác phẩm "Thư Viện Cuối Cùng Ở Tận Thế" (tác giả: Trịnh Khôi, thể loại: Mạt thế, Khoa huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mặt đất bị bao phủ bởi bão từ và sinh vật biến dị, thủ thư trẻ tuổi Thiên Ân cùng đội hộ vệ cơ giới vượt qua hoang mạc để thu thập và bảo tồn những cuốn sách giấy cuối cùng của nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: robot thủ thư mang ký hiệu a-12, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thư Viện Cuối Cùng Ở Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Robot thủ thư mang ký hiệu A-12 tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Robot thủ thư mang ký hiệu A-12 —'),
(190005, 19, 5, 'Chương 5: Tín hiệu cầu cứu từ đài thiên văn cũ', '【Chương 5: Tín hiệu cầu cứu từ đài thiên văn cũ】 Câu chuyện của tác phẩm "Thư Viện Cuối Cùng Ở Tận Thế" (tác giả: Trịnh Khôi, thể loại: Mạt thế, Khoa huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mặt đất bị bao phủ bởi bão từ và sinh vật biến dị, thủ thư trẻ tuổi Thiên Ân cùng đội hộ vệ cơ giới vượt qua hoang mạc để thu thập và bảo tồn những cuốn sách giấy cuối cùng của nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: tín hiệu cầu cứu từ đài thiên văn cũ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thư Viện Cuối Cùng Ở Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Tín hiệu cầu cứu từ đài thiên văn cũ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Tín hiệu cầu cứu từ đài thiên văn cũ —'),
(190006, 19, 6, 'Chương 6: Đêm canh gác giữa phế tích', '【Chương 6: Đêm canh gác giữa phế tích】 Câu chuyện của tác phẩm "Thư Viện Cuối Cùng Ở Tận Thế" (tác giả: Trịnh Khôi, thể loại: Mạt thế, Khoa huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mặt đất bị bao phủ bởi bão từ và sinh vật biến dị, thủ thư trẻ tuổi Thiên Ân cùng đội hộ vệ cơ giới vượt qua hoang mạc để thu thập và bảo tồn những cuốn sách giấy cuối cùng của nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: đêm canh gác giữa phế tích, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thư Viện Cuối Cùng Ở Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Đêm canh gác giữa phế tích tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Đêm canh gác giữa phế tích —'),
(190007, 19, 7, 'Chương 7: Hạt giống cây xanh trong trang sách cổ', '【Chương 7: Hạt giống cây xanh trong trang sách cổ】 Câu chuyện của tác phẩm "Thư Viện Cuối Cùng Ở Tận Thế" (tác giả: Trịnh Khôi, thể loại: Mạt thế, Khoa huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mặt đất bị bao phủ bởi bão từ và sinh vật biến dị, thủ thư trẻ tuổi Thiên Ân cùng đội hộ vệ cơ giới vượt qua hoang mạc để thu thập và bảo tồn những cuốn sách giấy cuối cùng của nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: hạt giống cây xanh trong trang sách cổ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thư Viện Cuối Cùng Ở Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Hạt giống cây xanh trong trang sách cổ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Hạt giống cây xanh trong trang sách cổ —'),
(190008, 19, 8, 'Chương 8: Cuộc chiến bảo vệ kho lưu trữ quốc gia', '【Chương 8: Cuộc chiến bảo vệ kho lưu trữ quốc gia】 Câu chuyện của tác phẩm "Thư Viện Cuối Cùng Ở Tận Thế" (tác giả: Trịnh Khôi, thể loại: Mạt thế, Khoa huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mặt đất bị bao phủ bởi bão từ và sinh vật biến dị, thủ thư trẻ tuổi Thiên Ân cùng đội hộ vệ cơ giới vượt qua hoang mạc để thu thập và bảo tồn những cuốn sách giấy cuối cùng của nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: cuộc chiến bảo vệ kho lưu trữ quốc gia, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thư Viện Cuối Cùng Ở Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Cuộc chiến bảo vệ kho lưu trữ quốc gia tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Cuộc chiến bảo vệ kho lưu trữ quốc gia —'),
(190009, 19, 9, 'Chương 9: Ánh sáng từ tháp truyền tin', '【Chương 9: Ánh sáng từ tháp truyền tin】 Câu chuyện của tác phẩm "Thư Viện Cuối Cùng Ở Tận Thế" (tác giả: Trịnh Khôi, thể loại: Mạt thế, Khoa huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mặt đất bị bao phủ bởi bão từ và sinh vật biến dị, thủ thư trẻ tuổi Thiên Ân cùng đội hộ vệ cơ giới vượt qua hoang mạc để thu thập và bảo tồn những cuốn sách giấy cuối cùng của nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: ánh sáng từ tháp truyền tin, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thư Viện Cuối Cùng Ở Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Ánh sáng từ tháp truyền tin tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Ánh sáng từ tháp truyền tin —'),
(190010, 19, 10, 'Chương 10: Tri thức hồi sinh nền văn minh', '【Chương 10: Tri thức hồi sinh nền văn minh】 Câu chuyện của tác phẩm "Thư Viện Cuối Cùng Ở Tận Thế" (tác giả: Trịnh Khôi, thể loại: Mạt thế, Khoa huyễn, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mặt đất bị bao phủ bởi bão từ và sinh vật biến dị, thủ thư trẻ tuổi Thiên Ân cùng đội hộ vệ cơ giới vượt qua hoang mạc để thu thập và bảo tồn những cuốn sách giấy cuối cùng của nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: tri thức hồi sinh nền văn minh, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thư Viện Cuối Cùng Ở Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Tri thức hồi sinh nền văn minh tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Tri thức hồi sinh nền văn minh —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (20, 'Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt', 'Khánh Linh', 'https://picsum.photos/seed/novelreader-v3-20/300/450', 'Xuyên không vào vai nữ công tước phản diện sắp bị lưu đày, thợ làm bánh Bảo Ngọc dứt khoát hủy hôn với thái tử kiêu ngạo để mở tiệm bánh Pháp giữa kinh đô và thu hút vị hoàng thúc lạnh lùng.', 'completed', 'light_novel', 'Xuyên không,Ngôn tình,Ẩm thực', 10, 4.8, 860000, 1793800000000, 'nu cong tuoc phan dien mo tiem banh ngot khanh linh', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(200001, 20, 1, 'Chương 1: Bản hôn ước bị xé nát giữa đại điện', '【Chương 1: Bản hôn ước bị xé nát giữa đại điện】 Câu chuyện của tác phẩm "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt" (tác giả: Khánh Linh, thể loại: Xuyên không, Ngôn tình, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Xuyên không vào vai nữ công tước phản diện sắp bị lưu đày, thợ làm bánh Bảo Ngọc dứt khoát hủy hôn với thái tử kiêu ngạo để mở tiệm bánh Pháp giữa kinh đô và thu hút vị hoàng thúc lạnh lùng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: bản hôn ước bị xé nát giữa đại điện, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Bản hôn ước bị xé nát giữa đại điện tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Bản hôn ước bị xé nát giữa đại điện —'),
(200002, 20, 2, 'Chương 2: Căn bếp phủ bụi ở lãnh địa phương bắc', '【Chương 2: Căn bếp phủ bụi ở lãnh địa phương bắc】 Câu chuyện của tác phẩm "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt" (tác giả: Khánh Linh, thể loại: Xuyên không, Ngôn tình, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Xuyên không vào vai nữ công tước phản diện sắp bị lưu đày, thợ làm bánh Bảo Ngọc dứt khoát hủy hôn với thái tử kiêu ngạo để mở tiệm bánh Pháp giữa kinh đô và thu hút vị hoàng thúc lạnh lùng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: căn bếp phủ bụi ở lãnh địa phương bắc, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Căn bếp phủ bụi ở lãnh địa phương bắc tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Căn bếp phủ bụi ở lãnh địa phương bắc —'),
(200003, 20, 3, 'Chương 3: Mẻ bánh sừng bò thơm lừng phố cổ', '【Chương 3: Mẻ bánh sừng bò thơm lừng phố cổ】 Câu chuyện của tác phẩm "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt" (tác giả: Khánh Linh, thể loại: Xuyên không, Ngôn tình, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Xuyên không vào vai nữ công tước phản diện sắp bị lưu đày, thợ làm bánh Bảo Ngọc dứt khoát hủy hôn với thái tử kiêu ngạo để mở tiệm bánh Pháp giữa kinh đô và thu hút vị hoàng thúc lạnh lùng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: mẻ bánh sừng bò thơm lừng phố cổ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Mẻ bánh sừng bò thơm lừng phố cổ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Mẻ bánh sừng bò thơm lừng phố cổ —'),
(200004, 20, 4, 'Chương 4: Vị hoàng thúc hảo ngọt ẩn danh', '【Chương 4: Vị hoàng thúc hảo ngọt ẩn danh】 Câu chuyện của tác phẩm "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt" (tác giả: Khánh Linh, thể loại: Xuyên không, Ngôn tình, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Xuyên không vào vai nữ công tước phản diện sắp bị lưu đày, thợ làm bánh Bảo Ngọc dứt khoát hủy hôn với thái tử kiêu ngạo để mở tiệm bánh Pháp giữa kinh đô và thu hút vị hoàng thúc lạnh lùng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: vị hoàng thúc hảo ngọt ẩn danh, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Vị hoàng thúc hảo ngọt ẩn danh tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Vị hoàng thúc hảo ngọt ẩn danh —'),
(200005, 20, 5, 'Chương 5: Cuộc thi ẩm thực mừng quốc khánh', '【Chương 5: Cuộc thi ẩm thực mừng quốc khánh】 Câu chuyện của tác phẩm "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt" (tác giả: Khánh Linh, thể loại: Xuyên không, Ngôn tình, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Xuyên không vào vai nữ công tước phản diện sắp bị lưu đày, thợ làm bánh Bảo Ngọc dứt khoát hủy hôn với thái tử kiêu ngạo để mở tiệm bánh Pháp giữa kinh đô và thu hút vị hoàng thúc lạnh lùng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: cuộc thi ẩm thực mừng quốc khánh, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Cuộc thi ẩm thực mừng quốc khánh tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Cuộc thi ẩm thực mừng quốc khánh —'),
(200006, 20, 6, 'Chương 6: Trà chiều cùng các phu nhân quý tộc', '【Chương 6: Trà chiều cùng các phu nhân quý tộc】 Câu chuyện của tác phẩm "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt" (tác giả: Khánh Linh, thể loại: Xuyên không, Ngôn tình, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Xuyên không vào vai nữ công tước phản diện sắp bị lưu đày, thợ làm bánh Bảo Ngọc dứt khoát hủy hôn với thái tử kiêu ngạo để mở tiệm bánh Pháp giữa kinh đô và thu hút vị hoàng thúc lạnh lùng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: trà chiều cùng các phu nhân quý tộc, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Trà chiều cùng các phu nhân quý tộc tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Trà chiều cùng các phu nhân quý tộc —'),
(200007, 20, 7, 'Chương 7: Đập tan âm mưu đầu độc nguyên liệu', '【Chương 7: Đập tan âm mưu đầu độc nguyên liệu】 Câu chuyện của tác phẩm "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt" (tác giả: Khánh Linh, thể loại: Xuyên không, Ngôn tình, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Xuyên không vào vai nữ công tước phản diện sắp bị lưu đày, thợ làm bánh Bảo Ngọc dứt khoát hủy hôn với thái tử kiêu ngạo để mở tiệm bánh Pháp giữa kinh đô và thu hút vị hoàng thúc lạnh lùng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: đập tan âm mưu đầu độc nguyên liệu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Đập tan âm mưu đầu độc nguyên liệu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Đập tan âm mưu đầu độc nguyên liệu —'),
(200008, 20, 8, 'Chương 8: Chiếc bánh kem ba tầng đêm vũ hội', '【Chương 8: Chiếc bánh kem ba tầng đêm vũ hội】 Câu chuyện của tác phẩm "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt" (tác giả: Khánh Linh, thể loại: Xuyên không, Ngôn tình, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Xuyên không vào vai nữ công tước phản diện sắp bị lưu đày, thợ làm bánh Bảo Ngọc dứt khoát hủy hôn với thái tử kiêu ngạo để mở tiệm bánh Pháp giữa kinh đô và thu hút vị hoàng thúc lạnh lùng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: chiếc bánh kem ba tầng đêm vũ hội, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Chiếc bánh kem ba tầng đêm vũ hội tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Chiếc bánh kem ba tầng đêm vũ hội —'),
(200009, 20, 9, 'Chương 9: Lời cầu hôn ngọt hơn mật ong', '【Chương 9: Lời cầu hôn ngọt hơn mật ong】 Câu chuyện của tác phẩm "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt" (tác giả: Khánh Linh, thể loại: Xuyên không, Ngôn tình, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Xuyên không vào vai nữ công tước phản diện sắp bị lưu đày, thợ làm bánh Bảo Ngọc dứt khoát hủy hôn với thái tử kiêu ngạo để mở tiệm bánh Pháp giữa kinh đô và thu hút vị hoàng thúc lạnh lùng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: lời cầu hôn ngọt hơn mật ong, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Lời cầu hôn ngọt hơn mật ong tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Lời cầu hôn ngọt hơn mật ong —'),
(200010, 20, 10, 'Chương 10: Bà chủ chuỗi tiệm bánh hoàng gia', '【Chương 10: Bà chủ chuỗi tiệm bánh hoàng gia】 Câu chuyện của tác phẩm "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt" (tác giả: Khánh Linh, thể loại: Xuyên không, Ngôn tình, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Xuyên không vào vai nữ công tước phản diện sắp bị lưu đày, thợ làm bánh Bảo Ngọc dứt khoát hủy hôn với thái tử kiêu ngạo để mở tiệm bánh Pháp giữa kinh đô và thu hút vị hoàng thúc lạnh lùng.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: bà chủ chuỗi tiệm bánh hoàng gia, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nữ Công Tước Phản Diện Mở Tiệm Bánh Ngọt", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Bà chủ chuỗi tiệm bánh hoàng gia tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Bà chủ chuỗi tiệm bánh hoàng gia —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (21, 'Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa', 'Quang Huy', 'https://picsum.photos/seed/novelreader-v3-21/300/450', 'Trên chuyến tàu hơi nước ma đạo dài ba ngàn cây số xuyên qua bảy vương quốc, giả kim thuật sư trẻ tuổi Hải Đăng tình cờ nắm giữ viên Đá Triết Gia chưa hoàn chỉnh.', 'ongoing', 'light_novel', 'Fantasy,Phiêu lưu,Khoa huyễn', 10, 4.6, 590000, 1793800000000, 'gia kim thuat su tap su va chuyen tau xuyen luc dia quang huy', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(210001, 21, 1, 'Chương 1: Sân ga số 7 và tiếng còi hơi nước', '【Chương 1: Sân ga số 7 và tiếng còi hơi nước】 Câu chuyện của tác phẩm "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa" (tác giả: Quang Huy, thể loại: Fantasy, Phiêu lưu, Khoa huyễn) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Trên chuyến tàu hơi nước ma đạo dài ba ngàn cây số xuyên qua bảy vương quốc, giả kim thuật sư trẻ tuổi Hải Đăng tình cờ nắm giữ viên Đá Triết Gia chưa hoàn chỉnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: sân ga số 7 và tiếng còi hơi nước, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Sân ga số 7 và tiếng còi hơi nước tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Sân ga số 7 và tiếng còi hơi nước —'),
(210002, 21, 2, 'Chương 2: Toa tàu nghiên cứu của hội Giả Kim', '【Chương 2: Toa tàu nghiên cứu của hội Giả Kim】 Câu chuyện của tác phẩm "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa" (tác giả: Quang Huy, thể loại: Fantasy, Phiêu lưu, Khoa huyễn) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Trên chuyến tàu hơi nước ma đạo dài ba ngàn cây số xuyên qua bảy vương quốc, giả kim thuật sư trẻ tuổi Hải Đăng tình cờ nắm giữ viên Đá Triết Gia chưa hoàn chỉnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: toa tàu nghiên cứu của hội giả kim, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Toa tàu nghiên cứu của hội Giả Kim tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Toa tàu nghiên cứu của hội Giả Kim —'),
(210003, 21, 3, 'Chương 3: Viên đá phát sáng trong va li da', '【Chương 3: Viên đá phát sáng trong va li da】 Câu chuyện của tác phẩm "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa" (tác giả: Quang Huy, thể loại: Fantasy, Phiêu lưu, Khoa huyễn) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Trên chuyến tàu hơi nước ma đạo dài ba ngàn cây số xuyên qua bảy vương quốc, giả kim thuật sư trẻ tuổi Hải Đăng tình cờ nắm giữ viên Đá Triết Gia chưa hoàn chỉnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: viên đá phát sáng trong va li da, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Viên đá phát sáng trong va li da tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Viên đá phát sáng trong va li da —'),
(210004, 21, 4, 'Chương 4: Vượt cầu treo qua hẻm núi Tử Thần', '【Chương 4: Vượt cầu treo qua hẻm núi Tử Thần】 Câu chuyện của tác phẩm "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa" (tác giả: Quang Huy, thể loại: Fantasy, Phiêu lưu, Khoa huyễn) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Trên chuyến tàu hơi nước ma đạo dài ba ngàn cây số xuyên qua bảy vương quốc, giả kim thuật sư trẻ tuổi Hải Đăng tình cờ nắm giữ viên Đá Triết Gia chưa hoàn chỉnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: vượt cầu treo qua hẻm núi tử thần, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Vượt cầu treo qua hẻm núi Tử Thần tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Vượt cầu treo qua hẻm núi Tử Thần —'),
(210005, 21, 5, 'Chương 5: Kẻ trộm đeo mặt nạ bạc', '【Chương 5: Kẻ trộm đeo mặt nạ bạc】 Câu chuyện của tác phẩm "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa" (tác giả: Quang Huy, thể loại: Fantasy, Phiêu lưu, Khoa huyễn) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Trên chuyến tàu hơi nước ma đạo dài ba ngàn cây số xuyên qua bảy vương quốc, giả kim thuật sư trẻ tuổi Hải Đăng tình cờ nắm giữ viên Đá Triết Gia chưa hoàn chỉnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: kẻ trộm đeo mặt nạ bạc, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Kẻ trộm đeo mặt nạ bạc tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Kẻ trộm đeo mặt nạ bạc —'),
(210006, 21, 6, 'Chương 6: Trạm dừng chân giữa thảo nguyên tuyết', '【Chương 6: Trạm dừng chân giữa thảo nguyên tuyết】 Câu chuyện của tác phẩm "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa" (tác giả: Quang Huy, thể loại: Fantasy, Phiêu lưu, Khoa huyễn) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Trên chuyến tàu hơi nước ma đạo dài ba ngàn cây số xuyên qua bảy vương quốc, giả kim thuật sư trẻ tuổi Hải Đăng tình cờ nắm giữ viên Đá Triết Gia chưa hoàn chỉnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: trạm dừng chân giữa thảo nguyên tuyết, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Trạm dừng chân giữa thảo nguyên tuyết tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Trạm dừng chân giữa thảo nguyên tuyết —'),
(210007, 21, 7, 'Chương 7: Công thức dung hợp kim loại cổ', '【Chương 7: Công thức dung hợp kim loại cổ】 Câu chuyện của tác phẩm "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa" (tác giả: Quang Huy, thể loại: Fantasy, Phiêu lưu, Khoa huyễn) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Trên chuyến tàu hơi nước ma đạo dài ba ngàn cây số xuyên qua bảy vương quốc, giả kim thuật sư trẻ tuổi Hải Đăng tình cờ nắm giữ viên Đá Triết Gia chưa hoàn chỉnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: công thức dung hợp kim loại cổ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Công thức dung hợp kim loại cổ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Công thức dung hợp kim loại cổ —'),
(210008, 21, 8, 'Chương 8: Cuộc rượt đuổi trên nóc tàu tốc hành', '【Chương 8: Cuộc rượt đuổi trên nóc tàu tốc hành】 Câu chuyện của tác phẩm "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa" (tác giả: Quang Huy, thể loại: Fantasy, Phiêu lưu, Khoa huyễn) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Trên chuyến tàu hơi nước ma đạo dài ba ngàn cây số xuyên qua bảy vương quốc, giả kim thuật sư trẻ tuổi Hải Đăng tình cờ nắm giữ viên Đá Triết Gia chưa hoàn chỉnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: cuộc rượt đuổi trên nóc tàu tốc hành, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Cuộc rượt đuổi trên nóc tàu tốc hành tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Cuộc rượt đuổi trên nóc tàu tốc hành —'),
(210009, 21, 9, 'Chương 9: Bí mật nhà ga cuối cùng', '【Chương 9: Bí mật nhà ga cuối cùng】 Câu chuyện của tác phẩm "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa" (tác giả: Quang Huy, thể loại: Fantasy, Phiêu lưu, Khoa huyễn) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Trên chuyến tàu hơi nước ma đạo dài ba ngàn cây số xuyên qua bảy vương quốc, giả kim thuật sư trẻ tuổi Hải Đăng tình cờ nắm giữ viên Đá Triết Gia chưa hoàn chỉnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: bí mật nhà ga cuối cùng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Bí mật nhà ga cuối cùng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Bí mật nhà ga cuối cùng —'),
(210010, 21, 10, 'Chương 10: Chân trời mới của giả kim thuật', '【Chương 10: Chân trời mới của giả kim thuật】 Câu chuyện của tác phẩm "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa" (tác giả: Quang Huy, thể loại: Fantasy, Phiêu lưu, Khoa huyễn) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Trên chuyến tàu hơi nước ma đạo dài ba ngàn cây số xuyên qua bảy vương quốc, giả kim thuật sư trẻ tuổi Hải Đăng tình cờ nắm giữ viên Đá Triết Gia chưa hoàn chỉnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: chân trời mới của giả kim thuật, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Giả Kim Thuật Sư Tập Sự Và Chuyến Tàu Xuyên Lục Địa", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Chân trời mới của giả kim thuật tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Chân trời mới của giả kim thuật —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (22, 'Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí', 'Phương Nghi', 'https://picsum.photos/seed/novelreader-v3-22/300/450', 'Tại thị trấn đồng hồ ven biển, nghệ nhân cơ khí trầm lặng chế tạo những con rối tự động biết đàn dương cầm, giúp người dân gửi gắm những tâm sự chưa từng dám nói thành lời.', 'completed', 'light_novel', 'Kỳ ảo,Tâm lý,Chữa lành', 10, 4.8, 670000, 1793800000000, 'ban giao huong anh trang va nguoi che tao bup be co khi phuong nghi', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(220001, 22, 1, 'Chương 1: Xưởng cơ khí dưới chân ngọn hải đăng', '【Chương 1: Xưởng cơ khí dưới chân ngọn hải đăng】 Câu chuyện của tác phẩm "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí" (tác giả: Phương Nghi, thể loại: Kỳ ảo, Tâm lý, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tại thị trấn đồng hồ ven biển, nghệ nhân cơ khí trầm lặng chế tạo những con rối tự động biết đàn dương cầm, giúp người dân gửi gắm những tâm sự chưa từng dám nói thành lời.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: xưởng cơ khí dưới chân ngọn hải đăng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Xưởng cơ khí dưới chân ngọn hải đăng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Xưởng cơ khí dưới chân ngọn hải đăng —'),
(220002, 22, 2, 'Chương 2: Trái tim dây cót bằng đồng đỏ', '【Chương 2: Trái tim dây cót bằng đồng đỏ】 Câu chuyện của tác phẩm "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí" (tác giả: Phương Nghi, thể loại: Kỳ ảo, Tâm lý, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tại thị trấn đồng hồ ven biển, nghệ nhân cơ khí trầm lặng chế tạo những con rối tự động biết đàn dương cầm, giúp người dân gửi gắm những tâm sự chưa từng dám nói thành lời.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: trái tim dây cót bằng đồng đỏ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Trái tim dây cót bằng đồng đỏ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Trái tim dây cót bằng đồng đỏ —'),
(220003, 22, 3, 'Chương 3: Bản nhạc đêm trăng tròn', '【Chương 3: Bản nhạc đêm trăng tròn】 Câu chuyện của tác phẩm "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí" (tác giả: Phương Nghi, thể loại: Kỳ ảo, Tâm lý, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tại thị trấn đồng hồ ven biển, nghệ nhân cơ khí trầm lặng chế tạo những con rối tự động biết đàn dương cầm, giúp người dân gửi gắm những tâm sự chưa từng dám nói thành lời.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: bản nhạc đêm trăng tròn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Bản nhạc đêm trăng tròn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Bản nhạc đêm trăng tròn —'),
(220004, 22, 4, 'Chương 4: Cô bé mù và con chim sơn ca máy', '【Chương 4: Cô bé mù và con chim sơn ca máy】 Câu chuyện của tác phẩm "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí" (tác giả: Phương Nghi, thể loại: Kỳ ảo, Tâm lý, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tại thị trấn đồng hồ ven biển, nghệ nhân cơ khí trầm lặng chế tạo những con rối tự động biết đàn dương cầm, giúp người dân gửi gắm những tâm sự chưa từng dám nói thành lời.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: cô bé mù và con chim sơn ca máy, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Cô bé mù và con chim sơn ca máy tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Cô bé mù và con chim sơn ca máy —'),
(220005, 22, 5, 'Chương 5: Bức thư kẹt trong bánh răng cổ', '【Chương 5: Bức thư kẹt trong bánh răng cổ】 Câu chuyện của tác phẩm "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí" (tác giả: Phương Nghi, thể loại: Kỳ ảo, Tâm lý, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tại thị trấn đồng hồ ven biển, nghệ nhân cơ khí trầm lặng chế tạo những con rối tự động biết đàn dương cầm, giúp người dân gửi gắm những tâm sự chưa từng dám nói thành lời.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: bức thư kẹt trong bánh răng cổ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Bức thư kẹt trong bánh răng cổ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Bức thư kẹt trong bánh răng cổ —'),
(220006, 22, 6, 'Chương 6: Ngày hội đồng hồ toàn thị trấn', '【Chương 6: Ngày hội đồng hồ toàn thị trấn】 Câu chuyện của tác phẩm "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí" (tác giả: Phương Nghi, thể loại: Kỳ ảo, Tâm lý, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tại thị trấn đồng hồ ven biển, nghệ nhân cơ khí trầm lặng chế tạo những con rối tự động biết đàn dương cầm, giúp người dân gửi gắm những tâm sự chưa từng dám nói thành lời.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: ngày hội đồng hồ toàn thị trấn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Ngày hội đồng hồ toàn thị trấn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Ngày hội đồng hồ toàn thị trấn —'),
(220007, 22, 7, 'Chương 7: Cơn bão biển lớn nhất thập kỷ', '【Chương 7: Cơn bão biển lớn nhất thập kỷ】 Câu chuyện của tác phẩm "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí" (tác giả: Phương Nghi, thể loại: Kỳ ảo, Tâm lý, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tại thị trấn đồng hồ ven biển, nghệ nhân cơ khí trầm lặng chế tạo những con rối tự động biết đàn dương cầm, giúp người dân gửi gắm những tâm sự chưa từng dám nói thành lời.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: cơn bão biển lớn nhất thập kỷ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Cơn bão biển lớn nhất thập kỷ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Cơn bão biển lớn nhất thập kỷ —'),
(220008, 22, 8, 'Chương 8: Tiếng đàn dẫn đường cho tàu về bến', '【Chương 8: Tiếng đàn dẫn đường cho tàu về bến】 Câu chuyện của tác phẩm "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí" (tác giả: Phương Nghi, thể loại: Kỳ ảo, Tâm lý, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tại thị trấn đồng hồ ven biển, nghệ nhân cơ khí trầm lặng chế tạo những con rối tự động biết đàn dương cầm, giúp người dân gửi gắm những tâm sự chưa từng dám nói thành lời.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: tiếng đàn dẫn đường cho tàu về bến, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Tiếng đàn dẫn đường cho tàu về bến tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Tiếng đàn dẫn đường cho tàu về bến —'),
(220009, 22, 9, 'Chương 9: Phép màu của những nhịp đập cơ khí', '【Chương 9: Phép màu của những nhịp đập cơ khí】 Câu chuyện của tác phẩm "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí" (tác giả: Phương Nghi, thể loại: Kỳ ảo, Tâm lý, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tại thị trấn đồng hồ ven biển, nghệ nhân cơ khí trầm lặng chế tạo những con rối tự động biết đàn dương cầm, giúp người dân gửi gắm những tâm sự chưa từng dám nói thành lời.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: phép màu của những nhịp đập cơ khí, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Phép màu của những nhịp đập cơ khí tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Phép màu của những nhịp đập cơ khí —'),
(220010, 22, 10, 'Chương 10: Khúc vĩ thanh tràn ngập ánh sáng', '【Chương 10: Khúc vĩ thanh tràn ngập ánh sáng】 Câu chuyện của tác phẩm "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí" (tác giả: Phương Nghi, thể loại: Kỳ ảo, Tâm lý, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tại thị trấn đồng hồ ven biển, nghệ nhân cơ khí trầm lặng chế tạo những con rối tự động biết đàn dương cầm, giúp người dân gửi gắm những tâm sự chưa từng dám nói thành lời.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: khúc vĩ thanh tràn ngập ánh sáng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bản Giao Hưởng Ánh Trăng Và Người Chế Tạo Búp Bê Cơ Khí", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Khúc vĩ thanh tràn ngập ánh sáng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Khúc vĩ thanh tràn ngập ánh sáng —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (23, 'Thiên Long Kiếm Khách: Phong Vân Giang Hồ', 'Độc Cô Mặc', 'https://picsum.photos/seed/novelreader-v3-23/300/450', 'Một cuốn Cửu Thiên Kiếm Phổ tái xuất khiến võ lâm dậy sóng. Thiếu hiệp Tần Phong từ đỉnh Hoa Sơn bước vào giang hồ hiểm ác, lấy nghĩa hiệp làm trọng, bình định phân tranh bát đại môn phái.', 'ongoing', 'novel', 'Kiếm hiệp,Cổ đại,Hành động', 10, 4.8, 940000, 1793800000000, 'thien long kiem khach: phong van giang ho doc co mac', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(230001, 23, 1, 'Chương 1: Đêm mưa ở quán trọ Phong Lăng', '【Chương 1: Đêm mưa ở quán trọ Phong Lăng】 Câu chuyện của tác phẩm "Thiên Long Kiếm Khách: Phong Vân Giang Hồ" (tác giả: Độc Cô Mặc, thể loại: Kiếm hiệp, Cổ đại, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một cuốn Cửu Thiên Kiếm Phổ tái xuất khiến võ lâm dậy sóng. Thiếu hiệp Tần Phong từ đỉnh Hoa Sơn bước vào giang hồ hiểm ác, lấy nghĩa hiệp làm trọng, bình định phân tranh bát đại môn phái.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: đêm mưa ở quán trọ phong lăng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiên Long Kiếm Khách: Phong Vân Giang Hồ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Đêm mưa ở quán trọ Phong Lăng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Đêm mưa ở quán trọ Phong Lăng —'),
(230002, 23, 2, 'Chương 2: Mười tám đường Lạc Anh Kiếm Pháp', '【Chương 2: Mười tám đường Lạc Anh Kiếm Pháp】 Câu chuyện của tác phẩm "Thiên Long Kiếm Khách: Phong Vân Giang Hồ" (tác giả: Độc Cô Mặc, thể loại: Kiếm hiệp, Cổ đại, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một cuốn Cửu Thiên Kiếm Phổ tái xuất khiến võ lâm dậy sóng. Thiếu hiệp Tần Phong từ đỉnh Hoa Sơn bước vào giang hồ hiểm ác, lấy nghĩa hiệp làm trọng, bình định phân tranh bát đại môn phái.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: mười tám đường lạc anh kiếm pháp, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiên Long Kiếm Khách: Phong Vân Giang Hồ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Mười tám đường Lạc Anh Kiếm Pháp tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Mười tám đường Lạc Anh Kiếm Pháp —'),
(230003, 23, 3, 'Chương 3: Anh hùng hội tụ tại Tương Dương', '【Chương 3: Anh hùng hội tụ tại Tương Dương】 Câu chuyện của tác phẩm "Thiên Long Kiếm Khách: Phong Vân Giang Hồ" (tác giả: Độc Cô Mặc, thể loại: Kiếm hiệp, Cổ đại, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một cuốn Cửu Thiên Kiếm Phổ tái xuất khiến võ lâm dậy sóng. Thiếu hiệp Tần Phong từ đỉnh Hoa Sơn bước vào giang hồ hiểm ác, lấy nghĩa hiệp làm trọng, bình định phân tranh bát đại môn phái.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: anh hùng hội tụ tại tương dương, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiên Long Kiếm Khách: Phong Vân Giang Hồ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Anh hùng hội tụ tại Tương Dương tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Anh hùng hội tụ tại Tương Dương —'),
(230004, 23, 4, 'Chương 4: Âm mưu trên đỉnh Thiếu Thất', '【Chương 4: Âm mưu trên đỉnh Thiếu Thất】 Câu chuyện của tác phẩm "Thiên Long Kiếm Khách: Phong Vân Giang Hồ" (tác giả: Độc Cô Mặc, thể loại: Kiếm hiệp, Cổ đại, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một cuốn Cửu Thiên Kiếm Phổ tái xuất khiến võ lâm dậy sóng. Thiếu hiệp Tần Phong từ đỉnh Hoa Sơn bước vào giang hồ hiểm ác, lấy nghĩa hiệp làm trọng, bình định phân tranh bát đại môn phái.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: âm mưu trên đỉnh thiếu thất, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiên Long Kiếm Khách: Phong Vân Giang Hồ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Âm mưu trên đỉnh Thiếu Thất tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Âm mưu trên đỉnh Thiếu Thất —'),
(230005, 23, 5, 'Chương 5: Rượu nồng kết nghĩa huynh đệ', '【Chương 5: Rượu nồng kết nghĩa huynh đệ】 Câu chuyện của tác phẩm "Thiên Long Kiếm Khách: Phong Vân Giang Hồ" (tác giả: Độc Cô Mặc, thể loại: Kiếm hiệp, Cổ đại, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một cuốn Cửu Thiên Kiếm Phổ tái xuất khiến võ lâm dậy sóng. Thiếu hiệp Tần Phong từ đỉnh Hoa Sơn bước vào giang hồ hiểm ác, lấy nghĩa hiệp làm trọng, bình định phân tranh bát đại môn phái.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: rượu nồng kết nghĩa huynh đệ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiên Long Kiếm Khách: Phong Vân Giang Hồ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Rượu nồng kết nghĩa huynh đệ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Rượu nồng kết nghĩa huynh đệ —'),
(230006, 23, 6, 'Chương 6: Độc闯 Vạn Độc Cốc cứu người', '【Chương 6: Độc闯 Vạn Độc Cốc cứu người】 Câu chuyện của tác phẩm "Thiên Long Kiếm Khách: Phong Vân Giang Hồ" (tác giả: Độc Cô Mặc, thể loại: Kiếm hiệp, Cổ đại, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một cuốn Cửu Thiên Kiếm Phổ tái xuất khiến võ lâm dậy sóng. Thiếu hiệp Tần Phong từ đỉnh Hoa Sơn bước vào giang hồ hiểm ác, lấy nghĩa hiệp làm trọng, bình định phân tranh bát đại môn phái.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: độc闯 vạn độc cốc cứu người, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiên Long Kiếm Khách: Phong Vân Giang Hồ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Độc闯 Vạn Độc Cốc cứu người tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Độc闯 Vạn Độc Cốc cứu người —'),
(230007, 23, 7, 'Chương 7: Bí mật tấm bản đồ da dê', '【Chương 7: Bí mật tấm bản đồ da dê】 Câu chuyện của tác phẩm "Thiên Long Kiếm Khách: Phong Vân Giang Hồ" (tác giả: Độc Cô Mặc, thể loại: Kiếm hiệp, Cổ đại, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một cuốn Cửu Thiên Kiếm Phổ tái xuất khiến võ lâm dậy sóng. Thiếu hiệp Tần Phong từ đỉnh Hoa Sơn bước vào giang hồ hiểm ác, lấy nghĩa hiệp làm trọng, bình định phân tranh bát đại môn phái.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: bí mật tấm bản đồ da dê, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiên Long Kiếm Khách: Phong Vân Giang Hồ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Bí mật tấm bản đồ da dê tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Bí mật tấm bản đồ da dê —'),
(230008, 23, 8, 'Chương 8: Quyết chiến trên đỉnh Hoa Sơn', '【Chương 8: Quyết chiến trên đỉnh Hoa Sơn】 Câu chuyện của tác phẩm "Thiên Long Kiếm Khách: Phong Vân Giang Hồ" (tác giả: Độc Cô Mặc, thể loại: Kiếm hiệp, Cổ đại, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một cuốn Cửu Thiên Kiếm Phổ tái xuất khiến võ lâm dậy sóng. Thiếu hiệp Tần Phong từ đỉnh Hoa Sơn bước vào giang hồ hiểm ác, lấy nghĩa hiệp làm trọng, bình định phân tranh bát đại môn phái.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: quyết chiến trên đỉnh hoa sơn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiên Long Kiếm Khách: Phong Vân Giang Hồ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Quyết chiến trên đỉnh Hoa Sơn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Quyết chiến trên đỉnh Hoa Sơn —'),
(230009, 23, 9, 'Chương 9: Hóa giải mối thù ba mươi năm', '【Chương 9: Hóa giải mối thù ba mươi năm】 Câu chuyện của tác phẩm "Thiên Long Kiếm Khách: Phong Vân Giang Hồ" (tác giả: Độc Cô Mặc, thể loại: Kiếm hiệp, Cổ đại, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một cuốn Cửu Thiên Kiếm Phổ tái xuất khiến võ lâm dậy sóng. Thiếu hiệp Tần Phong từ đỉnh Hoa Sơn bước vào giang hồ hiểm ác, lấy nghĩa hiệp làm trọng, bình định phân tranh bát đại môn phái.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: hóa giải mối thù ba mươi năm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiên Long Kiếm Khách: Phong Vân Giang Hồ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Hóa giải mối thù ba mươi năm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Hóa giải mối thù ba mươi năm —'),
(230010, 23, 10, 'Chương 10: Tiêu dao cưỡi ngựa ngắm non sông', '【Chương 10: Tiêu dao cưỡi ngựa ngắm non sông】 Câu chuyện của tác phẩm "Thiên Long Kiếm Khách: Phong Vân Giang Hồ" (tác giả: Độc Cô Mặc, thể loại: Kiếm hiệp, Cổ đại, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Một cuốn Cửu Thiên Kiếm Phổ tái xuất khiến võ lâm dậy sóng. Thiếu hiệp Tần Phong từ đỉnh Hoa Sơn bước vào giang hồ hiểm ác, lấy nghĩa hiệp làm trọng, bình định phân tranh bát đại môn phái.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: tiêu dao cưỡi ngựa ngắm non sông, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thiên Long Kiếm Khách: Phong Vân Giang Hồ", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Tiêu dao cưỡi ngựa ngắm non sông tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Tiêu dao cưỡi ngựa ngắm non sông —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (24, 'Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh', 'Tô Nguyệt Hoa', 'https://picsum.photos/seed/novelreader-v3-24/300/450', 'Sống lại vào năm mười lăm tuổi khi bi kịch gia tộc chưa xảy ra, Thẩm Thanh Ca dùng trí tuệ sắc sảo từng bước hóa giải mưu sâu nơi nội trạch lẫn hậu cung, nắm giữ vận mệnh của chính mình.', 'completed', 'novel', 'Trọng sinh,Cung đấu,Gia đấu,Cổ đại', 10, 4.9, 1180000, 1793800000000, 'phuong vu cuu thien: hoang hau trung sinh to nguyet hoa', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(240001, 24, 1, 'Chương 1: Mở mắt trở về năm mười lăm tuổi', '【Chương 1: Mở mắt trở về năm mười lăm tuổi】 Câu chuyện của tác phẩm "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh" (tác giả: Tô Nguyệt Hoa, thể loại: Trọng sinh, Cung đấu, Gia đấu, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sống lại vào năm mười lăm tuổi khi bi kịch gia tộc chưa xảy ra, Thẩm Thanh Ca dùng trí tuệ sắc sảo từng bước hóa giải mưu sâu nơi nội trạch lẫn hậu cung, nắm giữ vận mệnh của chính mình.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: mở mắt trở về năm mười lăm tuổi, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Mở mắt trở về năm mười lăm tuổi tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Mở mắt trở về năm mười lăm tuổi —'),
(240002, 24, 2, 'Chương 2: Vạch trần kế hoạch tráo của hồi môn', '【Chương 2: Vạch trần kế hoạch tráo của hồi môn】 Câu chuyện của tác phẩm "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh" (tác giả: Tô Nguyệt Hoa, thể loại: Trọng sinh, Cung đấu, Gia đấu, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sống lại vào năm mười lăm tuổi khi bi kịch gia tộc chưa xảy ra, Thẩm Thanh Ca dùng trí tuệ sắc sảo từng bước hóa giải mưu sâu nơi nội trạch lẫn hậu cung, nắm giữ vận mệnh của chính mình.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: vạch trần kế hoạch tráo của hồi môn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Vạch trần kế hoạch tráo của hồi môn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Vạch trần kế hoạch tráo của hồi môn —'),
(240003, 24, 3, 'Chương 3: Nước cờ cao tay tại yến tiệc thưởng hoa', '【Chương 3: Nước cờ cao tay tại yến tiệc thưởng hoa】 Câu chuyện của tác phẩm "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh" (tác giả: Tô Nguyệt Hoa, thể loại: Trọng sinh, Cung đấu, Gia đấu, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sống lại vào năm mười lăm tuổi khi bi kịch gia tộc chưa xảy ra, Thẩm Thanh Ca dùng trí tuệ sắc sảo từng bước hóa giải mưu sâu nơi nội trạch lẫn hậu cung, nắm giữ vận mệnh của chính mình.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: nước cờ cao tay tại yến tiệc thưởng hoa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Nước cờ cao tay tại yến tiệc thưởng hoa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Nước cờ cao tay tại yến tiệc thưởng hoa —'),
(240004, 24, 4, 'Chương 4: Giữ vững quyền quản gia Thẩm phủ', '【Chương 4: Giữ vững quyền quản gia Thẩm phủ】 Câu chuyện của tác phẩm "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh" (tác giả: Tô Nguyệt Hoa, thể loại: Trọng sinh, Cung đấu, Gia đấu, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sống lại vào năm mười lăm tuổi khi bi kịch gia tộc chưa xảy ra, Thẩm Thanh Ca dùng trí tuệ sắc sảo từng bước hóa giải mưu sâu nơi nội trạch lẫn hậu cung, nắm giữ vận mệnh của chính mình.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: giữ vững quyền quản gia thẩm phủ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Giữ vững quyền quản gia Thẩm phủ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Giữ vững quyền quản gia Thẩm phủ —'),
(240005, 24, 5, 'Chương 5: Gặp gỡ vị vương gia trấn thủ biên ải', '【Chương 5: Gặp gỡ vị vương gia trấn thủ biên ải】 Câu chuyện của tác phẩm "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh" (tác giả: Tô Nguyệt Hoa, thể loại: Trọng sinh, Cung đấu, Gia đấu, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sống lại vào năm mười lăm tuổi khi bi kịch gia tộc chưa xảy ra, Thẩm Thanh Ca dùng trí tuệ sắc sảo từng bước hóa giải mưu sâu nơi nội trạch lẫn hậu cung, nắm giữ vận mệnh của chính mình.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: gặp gỡ vị vương gia trấn thủ biên ải, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Gặp gỡ vị vương gia trấn thủ biên ải tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Gặp gỡ vị vương gia trấn thủ biên ải —'),
(240006, 24, 6, 'Chương 6: Sóng ngầm nơi thâm cung lục viện', '【Chương 6: Sóng ngầm nơi thâm cung lục viện】 Câu chuyện của tác phẩm "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh" (tác giả: Tô Nguyệt Hoa, thể loại: Trọng sinh, Cung đấu, Gia đấu, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sống lại vào năm mười lăm tuổi khi bi kịch gia tộc chưa xảy ra, Thẩm Thanh Ca dùng trí tuệ sắc sảo từng bước hóa giải mưu sâu nơi nội trạch lẫn hậu cung, nắm giữ vận mệnh của chính mình.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: sóng ngầm nơi thâm cung lục viện, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Sóng ngầm nơi thâm cung lục viện tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Sóng ngầm nơi thâm cung lục viện —'),
(240007, 24, 7, 'Chương 7: Lật lại bản án oan của phụ thân', '【Chương 7: Lật lại bản án oan của phụ thân】 Câu chuyện của tác phẩm "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh" (tác giả: Tô Nguyệt Hoa, thể loại: Trọng sinh, Cung đấu, Gia đấu, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sống lại vào năm mười lăm tuổi khi bi kịch gia tộc chưa xảy ra, Thẩm Thanh Ca dùng trí tuệ sắc sảo từng bước hóa giải mưu sâu nơi nội trạch lẫn hậu cung, nắm giữ vận mệnh của chính mình.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: lật lại bản án oan của phụ thân, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Lật lại bản án oan của phụ thân tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Lật lại bản án oan của phụ thân —'),
(240008, 24, 8, 'Chương 8: Đêm đèn hoa đăng định ước', '【Chương 8: Đêm đèn hoa đăng định ước】 Câu chuyện của tác phẩm "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh" (tác giả: Tô Nguyệt Hoa, thể loại: Trọng sinh, Cung đấu, Gia đấu, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sống lại vào năm mười lăm tuổi khi bi kịch gia tộc chưa xảy ra, Thẩm Thanh Ca dùng trí tuệ sắc sảo từng bước hóa giải mưu sâu nơi nội trạch lẫn hậu cung, nắm giữ vận mệnh của chính mình.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: đêm đèn hoa đăng định ước, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Đêm đèn hoa đăng định ước tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Đêm đèn hoa đăng định ước —'),
(240009, 24, 9, 'Chương 9: Phượng hoàng tung cánh giữa cửu trùng', '【Chương 9: Phượng hoàng tung cánh giữa cửu trùng】 Câu chuyện của tác phẩm "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh" (tác giả: Tô Nguyệt Hoa, thể loại: Trọng sinh, Cung đấu, Gia đấu, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sống lại vào năm mười lăm tuổi khi bi kịch gia tộc chưa xảy ra, Thẩm Thanh Ca dùng trí tuệ sắc sảo từng bước hóa giải mưu sâu nơi nội trạch lẫn hậu cung, nắm giữ vận mệnh của chính mình.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: phượng hoàng tung cánh giữa cửu trùng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Phượng hoàng tung cánh giữa cửu trùng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Phượng hoàng tung cánh giữa cửu trùng —'),
(240010, 24, 10, 'Chương 10: Mẫu nghi thiên hạ, thịnh thế thái bình', '【Chương 10: Mẫu nghi thiên hạ, thịnh thế thái bình】 Câu chuyện của tác phẩm "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh" (tác giả: Tô Nguyệt Hoa, thể loại: Trọng sinh, Cung đấu, Gia đấu, Cổ đại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sống lại vào năm mười lăm tuổi khi bi kịch gia tộc chưa xảy ra, Thẩm Thanh Ca dùng trí tuệ sắc sảo từng bước hóa giải mưu sâu nơi nội trạch lẫn hậu cung, nắm giữ vận mệnh của chính mình.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: mẫu nghi thiên hạ, thịnh thế thái bình, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phượng Vũ Cửu Thiên: Hoàng Hậu Trùng Sinh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Mẫu nghi thiên hạ, thịnh thế thái bình tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Mẫu nghi thiên hạ, thịnh thế thái bình —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (25, 'Vạn Cổ Thần Đế: Bát Hoang Chí Tôn', 'Thiênằm Khoai Tây', 'https://picsum.photos/seed/novelreader-v3-25/300/450', 'Mang trong mình huyết mạch Cổ Thần từ thuở hồng hoang khai thiên lập địa, Diệp Thần thức tỉnh Long Hoàng Ấn, bước qua vạn giới chư thiên để tìm lại nguồn cội của các vị thần cổ đại.', 'ongoing', 'novel', 'Huyền huyễn,Tiên hiệp,Thần thoại', 10, 4.9, 1420000, 1793800000000, 'van co than de: bat hoang chi ton thienam khoai tay', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(250001, 25, 1, 'Chương 1: Long Hoàng Ấn thức tỉnh trong huyết mạch', '【Chương 1: Long Hoàng Ấn thức tỉnh trong huyết mạch】 Câu chuyện của tác phẩm "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn" (tác giả: Thiênằm Khoai Tây, thể loại: Huyền huyễn, Tiên hiệp, Thần thoại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Mang trong mình huyết mạch Cổ Thần từ thuở hồng hoang khai thiên lập địa, Diệp Thần thức tỉnh Long Hoàng Ấn, bước qua vạn giới chư thiên để tìm lại nguồn cội của các vị thần cổ đại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: long hoàng ấn thức tỉnh trong huyết mạch, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Long Hoàng Ấn thức tỉnh trong huyết mạch tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Long Hoàng Ấn thức tỉnh trong huyết mạch —'),
(250002, 25, 2, 'Chương 2: Phá tan xiềng xích phong ấn', '【Chương 2: Phá tan xiềng xích phong ấn】 Câu chuyện của tác phẩm "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn" (tác giả: Thiênằm Khoai Tây, thể loại: Huyền huyễn, Tiên hiệp, Thần thoại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Mang trong mình huyết mạch Cổ Thần từ thuở hồng hoang khai thiên lập địa, Diệp Thần thức tỉnh Long Hoàng Ấn, bước qua vạn giới chư thiên để tìm lại nguồn cội của các vị thần cổ đại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: phá tan xiềng xích phong ấn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Phá tan xiềng xích phong ấn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Phá tan xiềng xích phong ấn —'),
(250003, 25, 3, 'Chương 3: Thái Cổ Thần Sơn hiện thế', '【Chương 3: Thái Cổ Thần Sơn hiện thế】 Câu chuyện của tác phẩm "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn" (tác giả: Thiênằm Khoai Tây, thể loại: Huyền huyễn, Tiên hiệp, Thần thoại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Mang trong mình huyết mạch Cổ Thần từ thuở hồng hoang khai thiên lập địa, Diệp Thần thức tỉnh Long Hoàng Ấn, bước qua vạn giới chư thiên để tìm lại nguồn cội của các vị thần cổ đại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: thái cổ thần sơn hiện thế, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Thái Cổ Thần Sơn hiện thế tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Thái Cổ Thần Sơn hiện thế —'),
(250004, 25, 4, 'Chương 4: Thu phục Hỏa Lân Thần Thú', '【Chương 4: Thu phục Hỏa Lân Thần Thú】 Câu chuyện của tác phẩm "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn" (tác giả: Thiênằm Khoai Tây, thể loại: Huyền huyễn, Tiên hiệp, Thần thoại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Mang trong mình huyết mạch Cổ Thần từ thuở hồng hoang khai thiên lập địa, Diệp Thần thức tỉnh Long Hoàng Ấn, bước qua vạn giới chư thiên để tìm lại nguồn cội của các vị thần cổ đại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: thu phục hỏa lân thần thú, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Thu phục Hỏa Lân Thần Thú tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Thu phục Hỏa Lân Thần Thú —'),
(250005, 25, 5, 'Chương 5: Đại chiến thiên kiêu tám vực', '【Chương 5: Đại chiến thiên kiêu tám vực】 Câu chuyện của tác phẩm "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn" (tác giả: Thiênằm Khoai Tây, thể loại: Huyền huyễn, Tiên hiệp, Thần thoại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Mang trong mình huyết mạch Cổ Thần từ thuở hồng hoang khai thiên lập địa, Diệp Thần thức tỉnh Long Hoàng Ấn, bước qua vạn giới chư thiên để tìm lại nguồn cội của các vị thần cổ đại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: đại chiến thiên kiêu tám vực, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Đại chiến thiên kiêu tám vực tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Đại chiến thiên kiêu tám vực —'),
(250006, 25, 6, 'Chương 6: Truyền thừa của Bàn Cổ Điện', '【Chương 6: Truyền thừa của Bàn Cổ Điện】 Câu chuyện của tác phẩm "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn" (tác giả: Thiênằm Khoai Tây, thể loại: Huyền huyễn, Tiên hiệp, Thần thoại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Mang trong mình huyết mạch Cổ Thần từ thuở hồng hoang khai thiên lập địa, Diệp Thần thức tỉnh Long Hoàng Ấn, bước qua vạn giới chư thiên để tìm lại nguồn cội của các vị thần cổ đại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: truyền thừa của bàn cổ điện, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Truyền thừa của Bàn Cổ Điện tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Truyền thừa của Bàn Cổ Điện —'),
(250007, 25, 7, 'Chương 7: Bước qua Vực Ngoại Tinh Không', '【Chương 7: Bước qua Vực Ngoại Tinh Không】 Câu chuyện của tác phẩm "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn" (tác giả: Thiênằm Khoai Tây, thể loại: Huyền huyễn, Tiên hiệp, Thần thoại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Mang trong mình huyết mạch Cổ Thần từ thuở hồng hoang khai thiên lập địa, Diệp Thần thức tỉnh Long Hoàng Ấn, bước qua vạn giới chư thiên để tìm lại nguồn cội của các vị thần cổ đại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: bước qua vực ngoại tinh không, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Bước qua Vực Ngoại Tinh Không tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Bước qua Vực Ngoại Tinh Không —'),
(250008, 25, 8, 'Chương 8: Chém đứt Ma Thần xâm thực', '【Chương 8: Chém đứt Ma Thần xâm thực】 Câu chuyện của tác phẩm "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn" (tác giả: Thiênằm Khoai Tây, thể loại: Huyền huyễn, Tiên hiệp, Thần thoại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Mang trong mình huyết mạch Cổ Thần từ thuở hồng hoang khai thiên lập địa, Diệp Thần thức tỉnh Long Hoàng Ấn, bước qua vạn giới chư thiên để tìm lại nguồn cội của các vị thần cổ đại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: chém đứt ma thần xâm thực, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Chém đứt Ma Thần xâm thực tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Chém đứt Ma Thần xâm thực —'),
(250009, 25, 9, 'Chương 9: Chưởng khống quy tắc thời không', '【Chương 9: Chưởng khống quy tắc thời không】 Câu chuyện của tác phẩm "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn" (tác giả: Thiênằm Khoai Tây, thể loại: Huyền huyễn, Tiên hiệp, Thần thoại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Mang trong mình huyết mạch Cổ Thần từ thuở hồng hoang khai thiên lập địa, Diệp Thần thức tỉnh Long Hoàng Ấn, bước qua vạn giới chư thiên để tìm lại nguồn cội của các vị thần cổ đại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: chưởng khống quy tắc thời không, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Chưởng khống quy tắc thời không tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Chưởng khống quy tắc thời không —'),
(250010, 25, 10, 'Chương 10: Đứng trên đỉnh cao Vạn Cổ', '【Chương 10: Đứng trên đỉnh cao Vạn Cổ】 Câu chuyện của tác phẩm "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn" (tác giả: Thiênằm Khoai Tây, thể loại: Huyền huyễn, Tiên hiệp, Thần thoại) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Mang trong mình huyết mạch Cổ Thần từ thuở hồng hoang khai thiên lập địa, Diệp Thần thức tỉnh Long Hoàng Ấn, bước qua vạn giới chư thiên để tìm lại nguồn cội của các vị thần cổ đại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: đứng trên đỉnh cao vạn cổ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Vạn Cổ Thần Đế: Bát Hoang Chí Tôn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Đứng trên đỉnh cao Vạn Cổ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Đứng trên đỉnh cao Vạn Cổ —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (26, 'Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh', 'Phạm Nhật Quang', 'https://picsum.photos/seed/novelreader-v3-26/300/450', 'Phóng viên điều tra Quốc Bảo tìm về ngôi làng cổ nằm sâu trong thung lũng sương mù để tìm hiểu truyền thuyết tiếng sáo trúc lúc nửa đêm, qua đó phơi bày một sự thật bị chôn giấu suốt nửa thế kỷ.', 'ongoing', 'novel', 'Linh dị,Kinh dị,Trinh thám', 10, 4.7, 810000, 1793800000000, 'ngoi lang suong mu: ho so tam linh pham nhat quang', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(260001, 26, 1, 'Chương 1: Chuyến xe khách cuối cùng lên núi', '【Chương 1: Chuyến xe khách cuối cùng lên núi】 Câu chuyện của tác phẩm "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh" (tác giả: Phạm Nhật Quang, thể loại: Linh dị, Kinh dị, Trinh thám) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Phóng viên điều tra Quốc Bảo tìm về ngôi làng cổ nằm sâu trong thung lũng sương mù để tìm hiểu truyền thuyết tiếng sáo trúc lúc nửa đêm, qua đó phơi bày một sự thật bị chôn giấu suốt nửa thế kỷ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: chuyến xe khách cuối cùng lên núi, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Chuyến xe khách cuối cùng lên núi tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Chuyến xe khách cuối cùng lên núi —'),
(260002, 26, 2, 'Chương 2: Ngôi làng tắt đèn sau chín giờ tối', '【Chương 2: Ngôi làng tắt đèn sau chín giờ tối】 Câu chuyện của tác phẩm "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh" (tác giả: Phạm Nhật Quang, thể loại: Linh dị, Kinh dị, Trinh thám) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Phóng viên điều tra Quốc Bảo tìm về ngôi làng cổ nằm sâu trong thung lũng sương mù để tìm hiểu truyền thuyết tiếng sáo trúc lúc nửa đêm, qua đó phơi bày một sự thật bị chôn giấu suốt nửa thế kỷ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: ngôi làng tắt đèn sau chín giờ tối, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Ngôi làng tắt đèn sau chín giờ tối tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Ngôi làng tắt đèn sau chín giờ tối —'),
(260003, 26, 3, 'Chương 3: Tiếng sáo trúc vọng từ rừng trúc già', '【Chương 3: Tiếng sáo trúc vọng từ rừng trúc già】 Câu chuyện của tác phẩm "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh" (tác giả: Phạm Nhật Quang, thể loại: Linh dị, Kinh dị, Trinh thám) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Phóng viên điều tra Quốc Bảo tìm về ngôi làng cổ nằm sâu trong thung lũng sương mù để tìm hiểu truyền thuyết tiếng sáo trúc lúc nửa đêm, qua đó phơi bày một sự thật bị chôn giấu suốt nửa thế kỷ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: tiếng sáo trúc vọng từ rừng trúc già, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Tiếng sáo trúc vọng từ rừng trúc già tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Tiếng sáo trúc vọng từ rừng trúc già —'),
(260004, 26, 4, 'Chương 4: Bức ảnh đen trắng trong nhà từ đường', '【Chương 4: Bức ảnh đen trắng trong nhà từ đường】 Câu chuyện của tác phẩm "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh" (tác giả: Phạm Nhật Quang, thể loại: Linh dị, Kinh dị, Trinh thám) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Phóng viên điều tra Quốc Bảo tìm về ngôi làng cổ nằm sâu trong thung lũng sương mù để tìm hiểu truyền thuyết tiếng sáo trúc lúc nửa đêm, qua đó phơi bày một sự thật bị chôn giấu suốt nửa thế kỷ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: bức ảnh đen trắng trong nhà từ đường, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Bức ảnh đen trắng trong nhà từ đường tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Bức ảnh đen trắng trong nhà từ đường —'),
(260005, 26, 5, 'Chương 5: Người gác đền bên bến đò cổ', '【Chương 5: Người gác đền bên bến đò cổ】 Câu chuyện của tác phẩm "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh" (tác giả: Phạm Nhật Quang, thể loại: Linh dị, Kinh dị, Trinh thám) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Phóng viên điều tra Quốc Bảo tìm về ngôi làng cổ nằm sâu trong thung lũng sương mù để tìm hiểu truyền thuyết tiếng sáo trúc lúc nửa đêm, qua đó phơi bày một sự thật bị chôn giấu suốt nửa thế kỷ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: người gác đền bên bến đò cổ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Người gác đền bên bến đò cổ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Người gác đền bên bến đò cổ —'),
(260006, 26, 6, 'Chương 6: Dấu chân ướt nước trên bậc thềm đá', '【Chương 6: Dấu chân ướt nước trên bậc thềm đá】 Câu chuyện của tác phẩm "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh" (tác giả: Phạm Nhật Quang, thể loại: Linh dị, Kinh dị, Trinh thám) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Phóng viên điều tra Quốc Bảo tìm về ngôi làng cổ nằm sâu trong thung lũng sương mù để tìm hiểu truyền thuyết tiếng sáo trúc lúc nửa đêm, qua đó phơi bày một sự thật bị chôn giấu suốt nửa thế kỷ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: dấu chân ướt nước trên bậc thềm đá, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Dấu chân ướt nước trên bậc thềm đá tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Dấu chân ướt nước trên bậc thềm đá —'),
(260007, 26, 7, 'Chương 7: Cuốn gia phả bị xé mất ba trang', '【Chương 7: Cuốn gia phả bị xé mất ba trang】 Câu chuyện của tác phẩm "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh" (tác giả: Phạm Nhật Quang, thể loại: Linh dị, Kinh dị, Trinh thám) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Phóng viên điều tra Quốc Bảo tìm về ngôi làng cổ nằm sâu trong thung lũng sương mù để tìm hiểu truyền thuyết tiếng sáo trúc lúc nửa đêm, qua đó phơi bày một sự thật bị chôn giấu suốt nửa thế kỷ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: cuốn gia phả bị xé mất ba trang, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Cuốn gia phả bị xé mất ba trang tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Cuốn gia phả bị xé mất ba trang —'),
(260008, 26, 8, 'Chương 8: Đêm rằm tháng bảy mở cổng làng', '【Chương 8: Đêm rằm tháng bảy mở cổng làng】 Câu chuyện của tác phẩm "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh" (tác giả: Phạm Nhật Quang, thể loại: Linh dị, Kinh dị, Trinh thám) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Phóng viên điều tra Quốc Bảo tìm về ngôi làng cổ nằm sâu trong thung lũng sương mù để tìm hiểu truyền thuyết tiếng sáo trúc lúc nửa đêm, qua đó phơi bày một sự thật bị chôn giấu suốt nửa thế kỷ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: đêm rằm tháng bảy mở cổng làng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Đêm rằm tháng bảy mở cổng làng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Đêm rằm tháng bảy mở cổng làng —'),
(260009, 26, 9, 'Chương 9: Giải tỏa nỗi oan khuất năm xưa', '【Chương 9: Giải tỏa nỗi oan khuất năm xưa】 Câu chuyện của tác phẩm "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh" (tác giả: Phạm Nhật Quang, thể loại: Linh dị, Kinh dị, Trinh thám) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Phóng viên điều tra Quốc Bảo tìm về ngôi làng cổ nằm sâu trong thung lũng sương mù để tìm hiểu truyền thuyết tiếng sáo trúc lúc nửa đêm, qua đó phơi bày một sự thật bị chôn giấu suốt nửa thế kỷ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: giải tỏa nỗi oan khuất năm xưa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Giải tỏa nỗi oan khuất năm xưa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Giải tỏa nỗi oan khuất năm xưa —'),
(260010, 26, 10, 'Chương 10: Ánh nắng chiếu xuyên tầng sương mù', '【Chương 10: Ánh nắng chiếu xuyên tầng sương mù】 Câu chuyện của tác phẩm "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh" (tác giả: Phạm Nhật Quang, thể loại: Linh dị, Kinh dị, Trinh thám) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Phóng viên điều tra Quốc Bảo tìm về ngôi làng cổ nằm sâu trong thung lũng sương mù để tìm hiểu truyền thuyết tiếng sáo trúc lúc nửa đêm, qua đó phơi bày một sự thật bị chôn giấu suốt nửa thế kỷ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: ánh nắng chiếu xuyên tầng sương mù, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Ngôi Làng Sương Mù: Hồ Sơ Tâm Linh", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Ánh nắng chiếu xuyên tầng sương mù tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Ánh nắng chiếu xuyên tầng sương mù —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (27, 'Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế', 'Võ Hoàng Quân', 'https://picsum.photos/seed/novelreader-v3-27/300/450', 'Năm 2450, nhân loại bước vào kỷ nguyên du hành liên sao. Chỉ huy trẻ tuổi Trần Hải dẫn đầu hạm đội tuần dương Thiết Giáp bảo vệ biên giới Hệ Mặt Trời và khám phá các di tích văn minh ngoài hành tinh.', 'ongoing', 'novel', 'Khoa huyễn,Quân sự,Phiêu lưu', 10, 4.8, 760000, 1793800000000, 'ky nguyen ngan ha: ham doi tinh te vo hoang quan', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(270001, 27, 1, 'Chương 1: Trạm không gian Sao Mộc báo động đỏ', '【Chương 1: Trạm không gian Sao Mộc báo động đỏ】 Câu chuyện của tác phẩm "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế" (tác giả: Võ Hoàng Quân, thể loại: Khoa huyễn, Quân sự, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Năm 2450, nhân loại bước vào kỷ nguyên du hành liên sao. Chỉ huy trẻ tuổi Trần Hải dẫn đầu hạm đội tuần dương Thiết Giáp bảo vệ biên giới Hệ Mặt Trời và khám phá các di tích văn minh ngoài hành tinh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: trạm không gian sao mộc báo động đỏ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Trạm không gian Sao Mộc báo động đỏ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Trạm không gian Sao Mộc báo động đỏ —'),
(270002, 27, 2, 'Chương 2: Khởi động động cơ bước nhảy lượng tử', '【Chương 2: Khởi động động cơ bước nhảy lượng tử】 Câu chuyện của tác phẩm "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế" (tác giả: Võ Hoàng Quân, thể loại: Khoa huyễn, Quân sự, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Năm 2450, nhân loại bước vào kỷ nguyên du hành liên sao. Chỉ huy trẻ tuổi Trần Hải dẫn đầu hạm đội tuần dương Thiết Giáp bảo vệ biên giới Hệ Mặt Trời và khám phá các di tích văn minh ngoài hành tinh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: khởi động động cơ bước nhảy lượng tử, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Khởi động động cơ bước nhảy lượng tử tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Khởi động động cơ bước nhảy lượng tử —'),
(270003, 27, 3, 'Chương 3: Chiến thuật vây bọc trong vành đai thiên thạch', '【Chương 3: Chiến thuật vây bọc trong vành đai thiên thạch】 Câu chuyện của tác phẩm "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế" (tác giả: Võ Hoàng Quân, thể loại: Khoa huyễn, Quân sự, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Năm 2450, nhân loại bước vào kỷ nguyên du hành liên sao. Chỉ huy trẻ tuổi Trần Hải dẫn đầu hạm đội tuần dương Thiết Giáp bảo vệ biên giới Hệ Mặt Trời và khám phá các di tích văn minh ngoài hành tinh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: chiến thuật vây bọc trong vành đai thiên thạch, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Chiến thuật vây bọc trong vành đai thiên thạch tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Chiến thuật vây bọc trong vành đai thiên thạch —'),
(270004, 27, 4, 'Chương 4: Tín hiệu cổ xưa từ tinh vân Tiên Nữ', '【Chương 4: Tín hiệu cổ xưa từ tinh vân Tiên Nữ】 Câu chuyện của tác phẩm "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế" (tác giả: Võ Hoàng Quân, thể loại: Khoa huyễn, Quân sự, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Năm 2450, nhân loại bước vào kỷ nguyên du hành liên sao. Chỉ huy trẻ tuổi Trần Hải dẫn đầu hạm đội tuần dương Thiết Giáp bảo vệ biên giới Hệ Mặt Trời và khám phá các di tích văn minh ngoài hành tinh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: tín hiệu cổ xưa từ tinh vân tiên nữ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Tín hiệu cổ xưa từ tinh vân Tiên Nữ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Tín hiệu cổ xưa từ tinh vân Tiên Nữ —'),
(270005, 27, 5, 'Chương 5: Đổ bộ lên hành tinh băng giá', '【Chương 5: Đổ bộ lên hành tinh băng giá】 Câu chuyện của tác phẩm "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế" (tác giả: Võ Hoàng Quân, thể loại: Khoa huyễn, Quân sự, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Năm 2450, nhân loại bước vào kỷ nguyên du hành liên sao. Chỉ huy trẻ tuổi Trần Hải dẫn đầu hạm đội tuần dương Thiết Giáp bảo vệ biên giới Hệ Mặt Trời và khám phá các di tích văn minh ngoài hành tinh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: đổ bộ lên hành tinh băng giá, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Đổ bộ lên hành tinh băng giá tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Đổ bộ lên hành tinh băng giá —'),
(270006, 27, 6, 'Chương 6: Cơ giáp chiến đấu thế hệ thứ sáu', '【Chương 6: Cơ giáp chiến đấu thế hệ thứ sáu】 Câu chuyện của tác phẩm "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế" (tác giả: Võ Hoàng Quân, thể loại: Khoa huyễn, Quân sự, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Năm 2450, nhân loại bước vào kỷ nguyên du hành liên sao. Chỉ huy trẻ tuổi Trần Hải dẫn đầu hạm đội tuần dương Thiết Giáp bảo vệ biên giới Hệ Mặt Trời và khám phá các di tích văn minh ngoài hành tinh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: cơ giáp chiến đấu thế hệ thứ sáu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Cơ giáp chiến đấu thế hệ thứ sáu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Cơ giáp chiến đấu thế hệ thứ sáu —'),
(270007, 27, 7, 'Chương 7: Liên minh các thuộc địa không gian', '【Chương 7: Liên minh các thuộc địa không gian】 Câu chuyện của tác phẩm "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế" (tác giả: Võ Hoàng Quân, thể loại: Khoa huyễn, Quân sự, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Năm 2450, nhân loại bước vào kỷ nguyên du hành liên sao. Chỉ huy trẻ tuổi Trần Hải dẫn đầu hạm đội tuần dương Thiết Giáp bảo vệ biên giới Hệ Mặt Trời và khám phá các di tích văn minh ngoài hành tinh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: liên minh các thuộc địa không gian, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Liên minh các thuộc địa không gian tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Liên minh các thuộc địa không gian —'),
(270008, 27, 8, 'Chương 8: Trận hải chiến giữa biển sao', '【Chương 8: Trận hải chiến giữa biển sao】 Câu chuyện của tác phẩm "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế" (tác giả: Võ Hoàng Quân, thể loại: Khoa huyễn, Quân sự, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Năm 2450, nhân loại bước vào kỷ nguyên du hành liên sao. Chỉ huy trẻ tuổi Trần Hải dẫn đầu hạm đội tuần dương Thiết Giáp bảo vệ biên giới Hệ Mặt Trời và khám phá các di tích văn minh ngoài hành tinh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: trận hải chiến giữa biển sao, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Trận hải chiến giữa biển sao tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Trận hải chiến giữa biển sao —'),
(270009, 27, 9, 'Chương 9: Giải mã lõi năng lượng vĩnh cửu', '【Chương 9: Giải mã lõi năng lượng vĩnh cửu】 Câu chuyện của tác phẩm "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế" (tác giả: Võ Hoàng Quân, thể loại: Khoa huyễn, Quân sự, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Năm 2450, nhân loại bước vào kỷ nguyên du hành liên sao. Chỉ huy trẻ tuổi Trần Hải dẫn đầu hạm đội tuần dương Thiết Giáp bảo vệ biên giới Hệ Mặt Trời và khám phá các di tích văn minh ngoài hành tinh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: giải mã lõi năng lượng vĩnh cửu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Giải mã lõi năng lượng vĩnh cửu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Giải mã lõi năng lượng vĩnh cửu —'),
(270010, 27, 10, 'Chương 10: Bình minh của Liên Bang Ngân Hà', '【Chương 10: Bình minh của Liên Bang Ngân Hà】 Câu chuyện của tác phẩm "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế" (tác giả: Võ Hoàng Quân, thể loại: Khoa huyễn, Quân sự, Phiêu lưu) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Năm 2450, nhân loại bước vào kỷ nguyên du hành liên sao. Chỉ huy trẻ tuổi Trần Hải dẫn đầu hạm đội tuần dương Thiết Giáp bảo vệ biên giới Hệ Mặt Trời và khám phá các di tích văn minh ngoài hành tinh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: bình minh của liên bang ngân hà, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Kỷ Nguyên Ngân Hà: Hạm Đội Tinh Tế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Bình minh của Liên Bang Ngân Hà tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Bình minh của Liên Bang Ngân Hà —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (28, 'Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần', 'Lý Gia Thành', 'https://picsum.photos/seed/novelreader-v3-28/300/450', 'Tuyển thủ thể thao điện tử huyền thoại Lâm Vũ tái xuất trong tựa game thực tế ảo Thiên Giới với tài khoản tán nhân cấp một, dẫn dắt chiến đội trẻ chinh phục cúp vô địch thế giới.', 'ongoing', 'novel', 'Võng du,Thể thao,Hệ thống', 10, 4.8, 990000, 1793800000000, 'dinh cao vong du: huyen thoai kiem than ly gia thanh', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(280001, 28, 1, 'Chương 1: Đăng nhập Thiên Giới lúc không giờ', '【Chương 1: Đăng nhập Thiên Giới lúc không giờ】 Câu chuyện của tác phẩm "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần" (tác giả: Lý Gia Thành, thể loại: Võng du, Thể thao, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển thủ thể thao điện tử huyền thoại Lâm Vũ tái xuất trong tựa game thực tế ảo Thiên Giới với tài khoản tán nhân cấp một, dẫn dắt chiến đội trẻ chinh phục cúp vô địch thế giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: đăng nhập thiên giới lúc không giờ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Đăng nhập Thiên Giới lúc không giờ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Đăng nhập Thiên Giới lúc không giờ —'),
(280002, 28, 2, 'Chương 2: Vũ khí tự chế Thiên Cơ Ô', '【Chương 2: Vũ khí tự chế Thiên Cơ Ô】 Câu chuyện của tác phẩm "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần" (tác giả: Lý Gia Thành, thể loại: Võng du, Thể thao, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển thủ thể thao điện tử huyền thoại Lâm Vũ tái xuất trong tựa game thực tế ảo Thiên Giới với tài khoản tán nhân cấp một, dẫn dắt chiến đội trẻ chinh phục cúp vô địch thế giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: vũ khí tự chế thiên cơ ô, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Vũ khí tự chế Thiên Cơ Ô tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Vũ khí tự chế Thiên Cơ Ô —'),
(280003, 28, 3, 'Chương 3: Phá kỷ lục phó bản Rừng Băng Giá', '【Chương 3: Phá kỷ lục phó bản Rừng Băng Giá】 Câu chuyện của tác phẩm "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần" (tác giả: Lý Gia Thành, thể loại: Võng du, Thể thao, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển thủ thể thao điện tử huyền thoại Lâm Vũ tái xuất trong tựa game thực tế ảo Thiên Giới với tài khoản tán nhân cấp một, dẫn dắt chiến đội trẻ chinh phục cúp vô địch thế giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: phá kỷ lục phó bản rừng băng giá, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Phá kỷ lục phó bản Rừng Băng Giá tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Phá kỷ lục phó bản Rừng Băng Giá —'),
(280004, 28, 4, 'Chương 4: Cuộc vây săn của các đại công hội', '【Chương 4: Cuộc vây săn của các đại công hội】 Câu chuyện của tác phẩm "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần" (tác giả: Lý Gia Thành, thể loại: Võng du, Thể thao, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển thủ thể thao điện tử huyền thoại Lâm Vũ tái xuất trong tựa game thực tế ảo Thiên Giới với tài khoản tán nhân cấp một, dẫn dắt chiến đội trẻ chinh phục cúp vô địch thế giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: cuộc vây săn của các đại công hội, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Cuộc vây săn của các đại công hội tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Cuộc vây săn của các đại công hội —'),
(280005, 28, 5, 'Chương 5: Tuyển mộ những đồng đội tài năng', '【Chương 5: Tuyển mộ những đồng đội tài năng】 Câu chuyện của tác phẩm "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần" (tác giả: Lý Gia Thành, thể loại: Võng du, Thể thao, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển thủ thể thao điện tử huyền thoại Lâm Vũ tái xuất trong tựa game thực tế ảo Thiên Giới với tài khoản tán nhân cấp một, dẫn dắt chiến đội trẻ chinh phục cúp vô địch thế giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: tuyển mộ những đồng đội tài năng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Tuyển mộ những đồng đội tài năng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Tuyển mộ những đồng đội tài năng —'),
(280006, 28, 6, 'Chương 6: Giải đấu chuyên nghiệp mùa xuân khởi tranh', '【Chương 6: Giải đấu chuyên nghiệp mùa xuân khởi tranh】 Câu chuyện của tác phẩm "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần" (tác giả: Lý Gia Thành, thể loại: Võng du, Thể thao, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển thủ thể thao điện tử huyền thoại Lâm Vũ tái xuất trong tựa game thực tế ảo Thiên Giới với tài khoản tán nhân cấp một, dẫn dắt chiến đội trẻ chinh phục cúp vô địch thế giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: giải đấu chuyên nghiệp mùa xuân khởi tranh, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Giải đấu chuyên nghiệp mùa xuân khởi tranh tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Giải đấu chuyên nghiệp mùa xuân khởi tranh —'),
(280007, 28, 7, 'Chương 7: Chiến thuật đảo ngược tình thế phút chót', '【Chương 7: Chiến thuật đảo ngược tình thế phút chót】 Câu chuyện của tác phẩm "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần" (tác giả: Lý Gia Thành, thể loại: Võng du, Thể thao, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển thủ thể thao điện tử huyền thoại Lâm Vũ tái xuất trong tựa game thực tế ảo Thiên Giới với tài khoản tán nhân cấp một, dẫn dắt chiến đội trẻ chinh phục cúp vô địch thế giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: chiến thuật đảo ngược tình thế phút chót, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Chiến thuật đảo ngược tình thế phút chót tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Chiến thuật đảo ngược tình thế phút chót —'),
(280008, 28, 8, 'Chương 8: Bán kết nghẹt thở trước nhà đương kim vô địch', '【Chương 8: Bán kết nghẹt thở trước nhà đương kim vô địch】 Câu chuyện của tác phẩm "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần" (tác giả: Lý Gia Thành, thể loại: Võng du, Thể thao, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển thủ thể thao điện tử huyền thoại Lâm Vũ tái xuất trong tựa game thực tế ảo Thiên Giới với tài khoản tán nhân cấp một, dẫn dắt chiến đội trẻ chinh phục cúp vô địch thế giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: bán kết nghẹt thở trước nhà đương kim vô địch, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Bán kết nghẹt thở trước nhà đương kim vô địch tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Bán kết nghẹt thở trước nhà đương kim vô địch —'),
(280009, 28, 9, 'Chương 9: Trận chung kết lịch sử tại sân vận động quốc gia', '【Chương 9: Trận chung kết lịch sử tại sân vận động quốc gia】 Câu chuyện của tác phẩm "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần" (tác giả: Lý Gia Thành, thể loại: Võng du, Thể thao, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển thủ thể thao điện tử huyền thoại Lâm Vũ tái xuất trong tựa game thực tế ảo Thiên Giới với tài khoản tán nhân cấp một, dẫn dắt chiến đội trẻ chinh phục cúp vô địch thế giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: trận chung kết lịch sử tại sân vận động quốc gia, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Trận chung kết lịch sử tại sân vận động quốc gia tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Trận chung kết lịch sử tại sân vận động quốc gia —'),
(280010, 28, 10, 'Chương 10: Nâng cao chiếc cúp vàng danh giá', '【Chương 10: Nâng cao chiếc cúp vàng danh giá】 Câu chuyện của tác phẩm "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần" (tác giả: Lý Gia Thành, thể loại: Võng du, Thể thao, Hệ thống) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tuyển thủ thể thao điện tử huyền thoại Lâm Vũ tái xuất trong tựa game thực tế ảo Thiên Giới với tài khoản tán nhân cấp một, dẫn dắt chiến đội trẻ chinh phục cúp vô địch thế giới.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: nâng cao chiếc cúp vàng danh giá, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đỉnh Cao Võng Du: Huyền Thoại Kiếm Thần", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Nâng cao chiếc cúp vàng danh giá tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Nâng cao chiếc cúp vàng danh giá —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (29, 'Bình Minh Trên Đỉnh Trường Sơn', 'Ngô Tất Thành', 'https://picsum.photos/seed/novelreader-v3-29/300/450', 'Bản hùng ca xúc động về những người lính trẻ mở đường Trường Sơn và các chiến sĩ thông tin liên lạc kiên cường vượt qua mưa bom bão đạn, giữ vững mạch máu giao thông vì ngày thống nhất.', 'completed', 'novel', 'Quân sự,Lịch sử,Văn học Việt Nam', 10, 4.9, 880000, 1793800000000, 'binh minh tren dinh truong son ngo tat thanh', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(290001, 29, 1, 'Chương 1: Lá thư viết vội trên ba lô hành quân', '【Chương 1: Lá thư viết vội trên ba lô hành quân】 Câu chuyện của tác phẩm "Bình Minh Trên Đỉnh Trường Sơn" (tác giả: Ngô Tất Thành, thể loại: Quân sự, Lịch sử, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Bản hùng ca xúc động về những người lính trẻ mở đường Trường Sơn và các chiến sĩ thông tin liên lạc kiên cường vượt qua mưa bom bão đạn, giữ vững mạch máu giao thông vì ngày thống nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: lá thư viết vội trên ba lô hành quân, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bình Minh Trên Đỉnh Trường Sơn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Lá thư viết vội trên ba lô hành quân tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Lá thư viết vội trên ba lô hành quân —'),
(290002, 29, 2, 'Chương 2: Cung đường lửa qua trọng điểm', '【Chương 2: Cung đường lửa qua trọng điểm】 Câu chuyện của tác phẩm "Bình Minh Trên Đỉnh Trường Sơn" (tác giả: Ngô Tất Thành, thể loại: Quân sự, Lịch sử, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Bản hùng ca xúc động về những người lính trẻ mở đường Trường Sơn và các chiến sĩ thông tin liên lạc kiên cường vượt qua mưa bom bão đạn, giữ vững mạch máu giao thông vì ngày thống nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: cung đường lửa qua trọng điểm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bình Minh Trên Đỉnh Trường Sơn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Cung đường lửa qua trọng điểm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Cung đường lửa qua trọng điểm —'),
(290003, 29, 3, 'Chương 3: Tiếng đàn ghi ta bên bếp Hoàng Cầm', '【Chương 3: Tiếng đàn ghi ta bên bếp Hoàng Cầm】 Câu chuyện của tác phẩm "Bình Minh Trên Đỉnh Trường Sơn" (tác giả: Ngô Tất Thành, thể loại: Quân sự, Lịch sử, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Bản hùng ca xúc động về những người lính trẻ mở đường Trường Sơn và các chiến sĩ thông tin liên lạc kiên cường vượt qua mưa bom bão đạn, giữ vững mạch máu giao thông vì ngày thống nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: tiếng đàn ghi ta bên bếp hoàng cầm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bình Minh Trên Đỉnh Trường Sơn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Tiếng đàn ghi ta bên bếp Hoàng Cầm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Tiếng đàn ghi ta bên bếp Hoàng Cầm —'),
(290004, 29, 4, 'Chương 4: Đêm nối dây thông tin giữa rừng mưa', '【Chương 4: Đêm nối dây thông tin giữa rừng mưa】 Câu chuyện của tác phẩm "Bình Minh Trên Đỉnh Trường Sơn" (tác giả: Ngô Tất Thành, thể loại: Quân sự, Lịch sử, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Bản hùng ca xúc động về những người lính trẻ mở đường Trường Sơn và các chiến sĩ thông tin liên lạc kiên cường vượt qua mưa bom bão đạn, giữ vững mạch máu giao thông vì ngày thống nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: đêm nối dây thông tin giữa rừng mưa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bình Minh Trên Đỉnh Trường Sơn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Đêm nối dây thông tin giữa rừng mưa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Đêm nối dây thông tin giữa rừng mưa —'),
(290005, 29, 5, 'Chương 5: Tiểu đội xe không kính anh hùng', '【Chương 5: Tiểu đội xe không kính anh hùng】 Câu chuyện của tác phẩm "Bình Minh Trên Đỉnh Trường Sơn" (tác giả: Ngô Tất Thành, thể loại: Quân sự, Lịch sử, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Bản hùng ca xúc động về những người lính trẻ mở đường Trường Sơn và các chiến sĩ thông tin liên lạc kiên cường vượt qua mưa bom bão đạn, giữ vững mạch máu giao thông vì ngày thống nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: tiểu đội xe không kính anh hùng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bình Minh Trên Đỉnh Trường Sơn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Tiểu đội xe không kính anh hùng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Tiểu đội xe không kính anh hùng —'),
(290006, 29, 6, 'Chương 6: Nhành phong lan trắng nơi tuyến đầu', '【Chương 6: Nhành phong lan trắng nơi tuyến đầu】 Câu chuyện của tác phẩm "Bình Minh Trên Đỉnh Trường Sơn" (tác giả: Ngô Tất Thành, thể loại: Quân sự, Lịch sử, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Bản hùng ca xúc động về những người lính trẻ mở đường Trường Sơn và các chiến sĩ thông tin liên lạc kiên cường vượt qua mưa bom bão đạn, giữ vững mạch máu giao thông vì ngày thống nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: nhành phong lan trắng nơi tuyến đầu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bình Minh Trên Đỉnh Trường Sơn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Nhành phong lan trắng nơi tuyến đầu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Nhành phong lan trắng nơi tuyến đầu —'),
(290007, 29, 7, 'Chương 7: Giữ vững trận địa pháo cao xạ', '【Chương 7: Giữ vững trận địa pháo cao xạ】 Câu chuyện của tác phẩm "Bình Minh Trên Đỉnh Trường Sơn" (tác giả: Ngô Tất Thành, thể loại: Quân sự, Lịch sử, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Bản hùng ca xúc động về những người lính trẻ mở đường Trường Sơn và các chiến sĩ thông tin liên lạc kiên cường vượt qua mưa bom bão đạn, giữ vững mạch máu giao thông vì ngày thống nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: giữ vững trận địa pháo cao xạ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bình Minh Trên Đỉnh Trường Sơn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Giữ vững trận địa pháo cao xạ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Giữ vững trận địa pháo cao xạ —'),
(290008, 29, 8, 'Chương 8: Cuộc hội ngộ bất ngờ tại ngã ba Đồng Lộc', '【Chương 8: Cuộc hội ngộ bất ngờ tại ngã ba Đồng Lộc】 Câu chuyện của tác phẩm "Bình Minh Trên Đỉnh Trường Sơn" (tác giả: Ngô Tất Thành, thể loại: Quân sự, Lịch sử, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Bản hùng ca xúc động về những người lính trẻ mở đường Trường Sơn và các chiến sĩ thông tin liên lạc kiên cường vượt qua mưa bom bão đạn, giữ vững mạch máu giao thông vì ngày thống nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: cuộc hội ngộ bất ngờ tại ngã ba đồng lộc, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bình Minh Trên Đỉnh Trường Sơn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Cuộc hội ngộ bất ngờ tại ngã ba Đồng Lộc tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Cuộc hội ngộ bất ngờ tại ngã ba Đồng Lộc —'),
(290009, 29, 9, 'Chương 9: Đoàn quân tiến về phía nam', '【Chương 9: Đoàn quân tiến về phía nam】 Câu chuyện của tác phẩm "Bình Minh Trên Đỉnh Trường Sơn" (tác giả: Ngô Tất Thành, thể loại: Quân sự, Lịch sử, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Bản hùng ca xúc động về những người lính trẻ mở đường Trường Sơn và các chiến sĩ thông tin liên lạc kiên cường vượt qua mưa bom bão đạn, giữ vững mạch máu giao thông vì ngày thống nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: đoàn quân tiến về phía nam, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bình Minh Trên Đỉnh Trường Sơn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Đoàn quân tiến về phía nam tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Đoàn quân tiến về phía nam —'),
(290010, 29, 10, 'Chương 10: Cờ hoa rợp bóng ngày toàn thắng', '【Chương 10: Cờ hoa rợp bóng ngày toàn thắng】 Câu chuyện của tác phẩm "Bình Minh Trên Đỉnh Trường Sơn" (tác giả: Ngô Tất Thành, thể loại: Quân sự, Lịch sử, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Bản hùng ca xúc động về những người lính trẻ mở đường Trường Sơn và các chiến sĩ thông tin liên lạc kiên cường vượt qua mưa bom bão đạn, giữ vững mạch máu giao thông vì ngày thống nhất.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: cờ hoa rợp bóng ngày toàn thắng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Bình Minh Trên Đỉnh Trường Sơn", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Cờ hoa rợp bóng ngày toàn thắng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Cờ hoa rợp bóng ngày toàn thắng —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (30, 'Hào Khí Đông A: Tiếng Trống Bình Nguyên', 'Trần Quốc Tuấn Ký', 'https://picsum.photos/seed/novelreader-v3-30/300/450', 'Tiểu thuyết lịch sử dã sử hào hùng tái hiện hội nghị Bình Than, hội nghị Diên Hồng và chiến thắng Bạch Đằng Giang lừng lẫy của quân dân nhà Trần trước đội quân Nguyên Mông hùng mạnh.', 'completed', 'novel', 'Lịch sử,Dã sử,Quân sự', 10, 5.0, 1120000, 1793800000000, 'hao khi dong a: tieng trong binh nguyen tran quoc tuan ky', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(300001, 30, 1, 'Chương 1: Hội nghị Bình Than bên bến sông Lục Đầu', '【Chương 1: Hội nghị Bình Than bên bến sông Lục Đầu】 Câu chuyện của tác phẩm "Hào Khí Đông A: Tiếng Trống Bình Nguyên" (tác giả: Trần Quốc Tuấn Ký, thể loại: Lịch sử, Dã sử, Quân sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tiểu thuyết lịch sử dã sử hào hùng tái hiện hội nghị Bình Than, hội nghị Diên Hồng và chiến thắng Bạch Đằng Giang lừng lẫy của quân dân nhà Trần trước đội quân Nguyên Mông hùng mạnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: hội nghị bình than bên bến sông lục đầu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hào Khí Đông A: Tiếng Trống Bình Nguyên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Hội nghị Bình Than bên bến sông Lục Đầu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Hội nghị Bình Than bên bến sông Lục Đầu —'),
(300002, 30, 2, 'Chương 2: Lá cờ thêu sáu chữ vàng của Hoài Văn Hầu', '【Chương 2: Lá cờ thêu sáu chữ vàng của Hoài Văn Hầu】 Câu chuyện của tác phẩm "Hào Khí Đông A: Tiếng Trống Bình Nguyên" (tác giả: Trần Quốc Tuấn Ký, thể loại: Lịch sử, Dã sử, Quân sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tiểu thuyết lịch sử dã sử hào hùng tái hiện hội nghị Bình Than, hội nghị Diên Hồng và chiến thắng Bạch Đằng Giang lừng lẫy của quân dân nhà Trần trước đội quân Nguyên Mông hùng mạnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: lá cờ thêu sáu chữ vàng của hoài văn hầu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hào Khí Đông A: Tiếng Trống Bình Nguyên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Lá cờ thêu sáu chữ vàng của Hoài Văn Hầu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Lá cờ thêu sáu chữ vàng của Hoài Văn Hầu —'),
(300003, 30, 3, 'Chương 3: Lời thề Sát Thát vang dậy Diên Hồng', '【Chương 3: Lời thề Sát Thát vang dậy Diên Hồng】 Câu chuyện của tác phẩm "Hào Khí Đông A: Tiếng Trống Bình Nguyên" (tác giả: Trần Quốc Tuấn Ký, thể loại: Lịch sử, Dã sử, Quân sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tiểu thuyết lịch sử dã sử hào hùng tái hiện hội nghị Bình Than, hội nghị Diên Hồng và chiến thắng Bạch Đằng Giang lừng lẫy của quân dân nhà Trần trước đội quân Nguyên Mông hùng mạnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: lời thề sát thát vang dậy diên hồng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hào Khí Đông A: Tiếng Trống Bình Nguyên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Lời thề Sát Thát vang dậy Diên Hồng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Lời thề Sát Thát vang dậy Diên Hồng —'),
(300004, 30, 4, 'Chương 4: Hịch Tướng Sĩ truyền khắp ba quân', '【Chương 4: Hịch Tướng Sĩ truyền khắp ba quân】 Câu chuyện của tác phẩm "Hào Khí Đông A: Tiếng Trống Bình Nguyên" (tác giả: Trần Quốc Tuấn Ký, thể loại: Lịch sử, Dã sử, Quân sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tiểu thuyết lịch sử dã sử hào hùng tái hiện hội nghị Bình Than, hội nghị Diên Hồng và chiến thắng Bạch Đằng Giang lừng lẫy của quân dân nhà Trần trước đội quân Nguyên Mông hùng mạnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: hịch tướng sĩ truyền khắp ba quân, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hào Khí Đông A: Tiếng Trống Bình Nguyên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Hịch Tướng Sĩ truyền khắp ba quân tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Hịch Tướng Sĩ truyền khắp ba quân —'),
(300005, 30, 5, 'Chương 5: Kế sách vườn không nhà trống', '【Chương 5: Kế sách vườn không nhà trống】 Câu chuyện của tác phẩm "Hào Khí Đông A: Tiếng Trống Bình Nguyên" (tác giả: Trần Quốc Tuấn Ký, thể loại: Lịch sử, Dã sử, Quân sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tiểu thuyết lịch sử dã sử hào hùng tái hiện hội nghị Bình Than, hội nghị Diên Hồng và chiến thắng Bạch Đằng Giang lừng lẫy của quân dân nhà Trần trước đội quân Nguyên Mông hùng mạnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: kế sách vườn không nhà trống, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hào Khí Đông A: Tiếng Trống Bình Nguyên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Kế sách vườn không nhà trống tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Kế sách vườn không nhà trống —'),
(300006, 30, 6, 'Chương 6: Chiến thắng Chương Dương – Hàm Tử', '【Chương 6: Chiến thắng Chương Dương – Hàm Tử】 Câu chuyện của tác phẩm "Hào Khí Đông A: Tiếng Trống Bình Nguyên" (tác giả: Trần Quốc Tuấn Ký, thể loại: Lịch sử, Dã sử, Quân sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tiểu thuyết lịch sử dã sử hào hùng tái hiện hội nghị Bình Than, hội nghị Diên Hồng và chiến thắng Bạch Đằng Giang lừng lẫy của quân dân nhà Trần trước đội quân Nguyên Mông hùng mạnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: chiến thắng chương dương – hàm tử, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hào Khí Đông A: Tiếng Trống Bình Nguyên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Chiến thắng Chương Dương – Hàm Tử tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Chiến thắng Chương Dương – Hàm Tử —'),
(300007, 30, 7, 'Chương 7: Rừng cọc gỗ lim dưới lòng sông Bạch Đằng', '【Chương 7: Rừng cọc gỗ lim dưới lòng sông Bạch Đằng】 Câu chuyện của tác phẩm "Hào Khí Đông A: Tiếng Trống Bình Nguyên" (tác giả: Trần Quốc Tuấn Ký, thể loại: Lịch sử, Dã sử, Quân sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tiểu thuyết lịch sử dã sử hào hùng tái hiện hội nghị Bình Than, hội nghị Diên Hồng và chiến thắng Bạch Đằng Giang lừng lẫy của quân dân nhà Trần trước đội quân Nguyên Mông hùng mạnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: rừng cọc gỗ lim dưới lòng sông bạch đằng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hào Khí Đông A: Tiếng Trống Bình Nguyên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Rừng cọc gỗ lim dưới lòng sông Bạch Đằng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Rừng cọc gỗ lim dưới lòng sông Bạch Đằng —'),
(300008, 30, 8, 'Chương 8: Con nước thủy triều định đoạt giang sơn', '【Chương 8: Con nước thủy triều định đoạt giang sơn】 Câu chuyện của tác phẩm "Hào Khí Đông A: Tiếng Trống Bình Nguyên" (tác giả: Trần Quốc Tuấn Ký, thể loại: Lịch sử, Dã sử, Quân sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tiểu thuyết lịch sử dã sử hào hùng tái hiện hội nghị Bình Than, hội nghị Diên Hồng và chiến thắng Bạch Đằng Giang lừng lẫy của quân dân nhà Trần trước đội quân Nguyên Mông hùng mạnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: con nước thủy triều định đoạt giang sơn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hào Khí Đông A: Tiếng Trống Bình Nguyên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Con nước thủy triều định đoạt giang sơn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Con nước thủy triều định đoạt giang sơn —'),
(300009, 30, 9, 'Chương 9: Khúc khải hoàn ca về kinh thành Thăng Long', '【Chương 9: Khúc khải hoàn ca về kinh thành Thăng Long】 Câu chuyện của tác phẩm "Hào Khí Đông A: Tiếng Trống Bình Nguyên" (tác giả: Trần Quốc Tuấn Ký, thể loại: Lịch sử, Dã sử, Quân sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tiểu thuyết lịch sử dã sử hào hùng tái hiện hội nghị Bình Than, hội nghị Diên Hồng và chiến thắng Bạch Đằng Giang lừng lẫy của quân dân nhà Trần trước đội quân Nguyên Mông hùng mạnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: khúc khải hoàn ca về kinh thành thăng long, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hào Khí Đông A: Tiếng Trống Bình Nguyên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Khúc khải hoàn ca về kinh thành Thăng Long tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Khúc khải hoàn ca về kinh thành Thăng Long —'),
(300010, 30, 10, 'Chương 10: Xã tắc vững bền muôn thuở', '【Chương 10: Xã tắc vững bền muôn thuở】 Câu chuyện của tác phẩm "Hào Khí Đông A: Tiếng Trống Bình Nguyên" (tác giả: Trần Quốc Tuấn Ký, thể loại: Lịch sử, Dã sử, Quân sự) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tiểu thuyết lịch sử dã sử hào hùng tái hiện hội nghị Bình Than, hội nghị Diên Hồng và chiến thắng Bạch Đằng Giang lừng lẫy của quân dân nhà Trần trước đội quân Nguyên Mông hùng mạnh.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: xã tắc vững bền muôn thuở, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hào Khí Đông A: Tiếng Trống Bình Nguyên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Xã tắc vững bền muôn thuở tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Xã tắc vững bền muôn thuở —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (31, 'Sống Như Dòng Sông Chảy: Triết Lý An Nhiên', 'Tuệ Minh', 'https://picsum.photos/seed/novelreader-v3-31/300/450', 'Những suy ngẫm triết học sâu sắc kết hợp nghệ thuật sống tỉnh thức giữa đời sống hiện đại bận rộn, giúp người đọc buông bỏ lo âu, thấu hiểu bản thân và tìm thấy sự bình yên nội tại.', 'completed', 'novel', 'Triết học,Kỹ năng sống,Chữa lành', 10, 4.8, 730000, 1793800000000, 'song nhu dong song chay: triet ly an nhien tue minh', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(310001, 31, 1, 'Chương 1: Lắng nghe tiếng mưa rơi ngoài hiên', '【Chương 1: Lắng nghe tiếng mưa rơi ngoài hiên】 Câu chuyện của tác phẩm "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên" (tác giả: Tuệ Minh, thể loại: Triết học, Kỹ năng sống, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những suy ngẫm triết học sâu sắc kết hợp nghệ thuật sống tỉnh thức giữa đời sống hiện đại bận rộn, giúp người đọc buông bỏ lo âu, thấu hiểu bản thân và tìm thấy sự bình yên nội tại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: lắng nghe tiếng mưa rơi ngoài hiên, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Lắng nghe tiếng mưa rơi ngoài hiên tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Lắng nghe tiếng mưa rơi ngoài hiên —'),
(310002, 31, 2, 'Chương 2: Nghệ thuật buông bỏ những điều không thuộc về mình', '【Chương 2: Nghệ thuật buông bỏ những điều không thuộc về mình】 Câu chuyện của tác phẩm "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên" (tác giả: Tuệ Minh, thể loại: Triết học, Kỹ năng sống, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những suy ngẫm triết học sâu sắc kết hợp nghệ thuật sống tỉnh thức giữa đời sống hiện đại bận rộn, giúp người đọc buông bỏ lo âu, thấu hiểu bản thân và tìm thấy sự bình yên nội tại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: nghệ thuật buông bỏ những điều không thuộc về mình, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Nghệ thuật buông bỏ những điều không thuộc về mình tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Nghệ thuật buông bỏ những điều không thuộc về mình —'),
(310003, 31, 3, 'Chương 3: Dòng sông không bao giờ vội vã', '【Chương 3: Dòng sông không bao giờ vội vã】 Câu chuyện của tác phẩm "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên" (tác giả: Tuệ Minh, thể loại: Triết học, Kỹ năng sống, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những suy ngẫm triết học sâu sắc kết hợp nghệ thuật sống tỉnh thức giữa đời sống hiện đại bận rộn, giúp người đọc buông bỏ lo âu, thấu hiểu bản thân và tìm thấy sự bình yên nội tại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: dòng sông không bao giờ vội vã, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Dòng sông không bao giờ vội vã tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Dòng sông không bao giờ vội vã —'),
(310004, 31, 4, 'Chương 4: Sức mạnh của sự tĩnh lặng', '【Chương 4: Sức mạnh của sự tĩnh lặng】 Câu chuyện của tác phẩm "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên" (tác giả: Tuệ Minh, thể loại: Triết học, Kỹ năng sống, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những suy ngẫm triết học sâu sắc kết hợp nghệ thuật sống tỉnh thức giữa đời sống hiện đại bận rộn, giúp người đọc buông bỏ lo âu, thấu hiểu bản thân và tìm thấy sự bình yên nội tại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: sức mạnh của sự tĩnh lặng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Sức mạnh của sự tĩnh lặng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Sức mạnh của sự tĩnh lặng —'),
(310005, 31, 5, 'Chương 5: Đối diện với nghịch cảnh bằng tâm bình thản', '【Chương 5: Đối diện với nghịch cảnh bằng tâm bình thản】 Câu chuyện của tác phẩm "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên" (tác giả: Tuệ Minh, thể loại: Triết học, Kỹ năng sống, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những suy ngẫm triết học sâu sắc kết hợp nghệ thuật sống tỉnh thức giữa đời sống hiện đại bận rộn, giúp người đọc buông bỏ lo âu, thấu hiểu bản thân và tìm thấy sự bình yên nội tại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: đối diện với nghịch cảnh bằng tâm bình thản, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Đối diện với nghịch cảnh bằng tâm bình thản tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Đối diện với nghịch cảnh bằng tâm bình thản —'),
(310006, 31, 6, 'Chương 6: Hạnh phúc nằm ở giây phút hiện tại', '【Chương 6: Hạnh phúc nằm ở giây phút hiện tại】 Câu chuyện của tác phẩm "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên" (tác giả: Tuệ Minh, thể loại: Triết học, Kỹ năng sống, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những suy ngẫm triết học sâu sắc kết hợp nghệ thuật sống tỉnh thức giữa đời sống hiện đại bận rộn, giúp người đọc buông bỏ lo âu, thấu hiểu bản thân và tìm thấy sự bình yên nội tại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: hạnh phúc nằm ở giây phút hiện tại, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Hạnh phúc nằm ở giây phút hiện tại tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Hạnh phúc nằm ở giây phút hiện tại —'),
(310007, 31, 7, 'Chương 7: Lòng biết ơn làm giàu tâm hồn', '【Chương 7: Lòng biết ơn làm giàu tâm hồn】 Câu chuyện của tác phẩm "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên" (tác giả: Tuệ Minh, thể loại: Triết học, Kỹ năng sống, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những suy ngẫm triết học sâu sắc kết hợp nghệ thuật sống tỉnh thức giữa đời sống hiện đại bận rộn, giúp người đọc buông bỏ lo âu, thấu hiểu bản thân và tìm thấy sự bình yên nội tại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: lòng biết ơn làm giàu tâm hồn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Lòng biết ơn làm giàu tâm hồn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Lòng biết ơn làm giàu tâm hồn —'),
(310008, 31, 8, 'Chương 8: Kiên nhẫn như hạt mầm dưới đất sâu', '【Chương 8: Kiên nhẫn như hạt mầm dưới đất sâu】 Câu chuyện của tác phẩm "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên" (tác giả: Tuệ Minh, thể loại: Triết học, Kỹ năng sống, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những suy ngẫm triết học sâu sắc kết hợp nghệ thuật sống tỉnh thức giữa đời sống hiện đại bận rộn, giúp người đọc buông bỏ lo âu, thấu hiểu bản thân và tìm thấy sự bình yên nội tại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: kiên nhẫn như hạt mầm dưới đất sâu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Kiên nhẫn như hạt mầm dưới đất sâu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Kiên nhẫn như hạt mầm dưới đất sâu —'),
(310009, 31, 9, 'Chương 9: Thấu cảm để kết nối chân thành', '【Chương 9: Thấu cảm để kết nối chân thành】 Câu chuyện của tác phẩm "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên" (tác giả: Tuệ Minh, thể loại: Triết học, Kỹ năng sống, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những suy ngẫm triết học sâu sắc kết hợp nghệ thuật sống tỉnh thức giữa đời sống hiện đại bận rộn, giúp người đọc buông bỏ lo âu, thấu hiểu bản thân và tìm thấy sự bình yên nội tại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: thấu cảm để kết nối chân thành, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Thấu cảm để kết nối chân thành tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Thấu cảm để kết nối chân thành —'),
(310010, 31, 10, 'Chương 10: Trở về nhà trong chính tâm thức', '【Chương 10: Trở về nhà trong chính tâm thức】 Câu chuyện của tác phẩm "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên" (tác giả: Tuệ Minh, thể loại: Triết học, Kỹ năng sống, Chữa lành) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Những suy ngẫm triết học sâu sắc kết hợp nghệ thuật sống tỉnh thức giữa đời sống hiện đại bận rộn, giúp người đọc buông bỏ lo âu, thấu hiểu bản thân và tìm thấy sự bình yên nội tại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: trở về nhà trong chính tâm thức, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sống Như Dòng Sông Chảy: Triết Lý An Nhiên", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Trở về nhà trong chính tâm thức tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Trở về nhà trong chính tâm thức —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (32, 'Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian', 'Nguyễn Thành Đạt', 'https://picsum.photos/seed/novelreader-v3-32/300/450', 'Cẩm nang thực chiến về tư duy kỷ luật tự giác, quản trị năng lượng cá nhân và xây dựng thói quen bền vững để vươn tới thành công trong học tập cũng như sự nghiệp.', 'completed', 'novel', 'Kỹ năng sống,Kinh doanh,Triết học', 10, 4.7, 680000, 1793800000000, 'danh thuc tiem nang: nghe thuat lam chu thoi gian nguyen thanh dat', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(320001, 32, 1, 'Chương 1: Tư duy của người làm chủ vận mệnh', '【Chương 1: Tư duy của người làm chủ vận mệnh】 Câu chuyện của tác phẩm "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian" (tác giả: Nguyễn Thành Đạt, thể loại: Kỹ năng sống, Kinh doanh, Triết học) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cẩm nang thực chiến về tư duy kỷ luật tự giác, quản trị năng lượng cá nhân và xây dựng thói quen bền vững để vươn tới thành công trong học tập cũng như sự nghiệp.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: tư duy của người làm chủ vận mệnh, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Tư duy của người làm chủ vận mệnh tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Tư duy của người làm chủ vận mệnh —'),
(320002, 32, 2, 'Chương 2: Quy tắc hai phút chống trì hoãn', '【Chương 2: Quy tắc hai phút chống trì hoãn】 Câu chuyện của tác phẩm "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian" (tác giả: Nguyễn Thành Đạt, thể loại: Kỹ năng sống, Kinh doanh, Triết học) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cẩm nang thực chiến về tư duy kỷ luật tự giác, quản trị năng lượng cá nhân và xây dựng thói quen bền vững để vươn tới thành công trong học tập cũng như sự nghiệp.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: quy tắc hai phút chống trì hoãn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Quy tắc hai phút chống trì hoãn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Quy tắc hai phút chống trì hoãn —'),
(320003, 32, 3, 'Chương 3: Thiết lập mục tiêu rõ ràng và khả thi', '【Chương 3: Thiết lập mục tiêu rõ ràng và khả thi】 Câu chuyện của tác phẩm "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian" (tác giả: Nguyễn Thành Đạt, thể loại: Kỹ năng sống, Kinh doanh, Triết học) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cẩm nang thực chiến về tư duy kỷ luật tự giác, quản trị năng lượng cá nhân và xây dựng thói quen bền vững để vươn tới thành công trong học tập cũng như sự nghiệp.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: thiết lập mục tiêu rõ ràng và khả thi, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Thiết lập mục tiêu rõ ràng và khả thi tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Thiết lập mục tiêu rõ ràng và khả thi —'),
(320004, 32, 4, 'Chương 4: Quản trị năng lượng thay vì chỉ quản trị thời gian', '【Chương 4: Quản trị năng lượng thay vì chỉ quản trị thời gian】 Câu chuyện của tác phẩm "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian" (tác giả: Nguyễn Thành Đạt, thể loại: Kỹ năng sống, Kinh doanh, Triết học) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cẩm nang thực chiến về tư duy kỷ luật tự giác, quản trị năng lượng cá nhân và xây dựng thói quen bền vững để vươn tới thành công trong học tập cũng như sự nghiệp.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: quản trị năng lượng thay vì chỉ quản trị thời gian, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Quản trị năng lượng thay vì chỉ quản trị thời gian tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Quản trị năng lượng thay vì chỉ quản trị thời gian —'),
(320005, 32, 5, 'Chương 5: Sức mạnh cộng gộp của một phần trăm mỗi ngày', '【Chương 5: Sức mạnh cộng gộp của một phần trăm mỗi ngày】 Câu chuyện của tác phẩm "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian" (tác giả: Nguyễn Thành Đạt, thể loại: Kỹ năng sống, Kinh doanh, Triết học) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cẩm nang thực chiến về tư duy kỷ luật tự giác, quản trị năng lượng cá nhân và xây dựng thói quen bền vững để vươn tới thành công trong học tập cũng như sự nghiệp.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: sức mạnh cộng gộp của một phần trăm mỗi ngày, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Sức mạnh cộng gộp của một phần trăm mỗi ngày tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Sức mạnh cộng gộp của một phần trăm mỗi ngày —'),
(320006, 32, 6, 'Chương 6: Nghệ thuật tập trung sâu giữa thế giới số', '【Chương 6: Nghệ thuật tập trung sâu giữa thế giới số】 Câu chuyện của tác phẩm "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian" (tác giả: Nguyễn Thành Đạt, thể loại: Kỹ năng sống, Kinh doanh, Triết học) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cẩm nang thực chiến về tư duy kỷ luật tự giác, quản trị năng lượng cá nhân và xây dựng thói quen bền vững để vươn tới thành công trong học tập cũng như sự nghiệp.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: nghệ thuật tập trung sâu giữa thế giới số, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Nghệ thuật tập trung sâu giữa thế giới số tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Nghệ thuật tập trung sâu giữa thế giới số —'),
(320007, 32, 7, 'Chương 7: Giao tiếp thuyết phục và lắng nghe chủ động', '【Chương 7: Giao tiếp thuyết phục và lắng nghe chủ động】 Câu chuyện của tác phẩm "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian" (tác giả: Nguyễn Thành Đạt, thể loại: Kỹ năng sống, Kinh doanh, Triết học) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cẩm nang thực chiến về tư duy kỷ luật tự giác, quản trị năng lượng cá nhân và xây dựng thói quen bền vững để vươn tới thành công trong học tập cũng như sự nghiệp.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: giao tiếp thuyết phục và lắng nghe chủ động, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Giao tiếp thuyết phục và lắng nghe chủ động tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Giao tiếp thuyết phục và lắng nghe chủ động —'),
(320008, 32, 8, 'Chương 8: Tư duy tài chính thông minh cho người trẻ', '【Chương 8: Tư duy tài chính thông minh cho người trẻ】 Câu chuyện của tác phẩm "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian" (tác giả: Nguyễn Thành Đạt, thể loại: Kỹ năng sống, Kinh doanh, Triết học) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cẩm nang thực chiến về tư duy kỷ luật tự giác, quản trị năng lượng cá nhân và xây dựng thói quen bền vững để vươn tới thành công trong học tập cũng như sự nghiệp.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: tư duy tài chính thông minh cho người trẻ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Tư duy tài chính thông minh cho người trẻ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Tư duy tài chính thông minh cho người trẻ —'),
(320009, 32, 9, 'Chương 9: Vượt qua thất bại và tái tạo động lực', '【Chương 9: Vượt qua thất bại và tái tạo động lực】 Câu chuyện của tác phẩm "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian" (tác giả: Nguyễn Thành Đạt, thể loại: Kỹ năng sống, Kinh doanh, Triết học) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cẩm nang thực chiến về tư duy kỷ luật tự giác, quản trị năng lượng cá nhân và xây dựng thói quen bền vững để vươn tới thành công trong học tập cũng như sự nghiệp.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: vượt qua thất bại và tái tạo động lực, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Vượt qua thất bại và tái tạo động lực tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Vượt qua thất bại và tái tạo động lực —'),
(320010, 32, 10, 'Chương 10: Kiến tạo cuộc đời đáng sống', '【Chương 10: Kiến tạo cuộc đời đáng sống】 Câu chuyện của tác phẩm "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian" (tác giả: Nguyễn Thành Đạt, thể loại: Kỹ năng sống, Kinh doanh, Triết học) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Cẩm nang thực chiến về tư duy kỷ luật tự giác, quản trị năng lượng cá nhân và xây dựng thói quen bền vững để vươn tới thành công trong học tập cũng như sự nghiệp.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: kiến tạo cuộc đời đáng sống, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Đánh Thức Tiềm Năng: Nghệ Thuật Làm Chủ Thời Gian", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Kiến tạo cuộc đời đáng sống tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Kiến tạo cuộc đời đáng sống —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (33, 'Về Quê Trồng Hoa Nuôi Cá', 'Mộc Miên', 'https://picsum.photos/seed/novelreader-v3-33/300/450', 'Rời bỏ thành phố ồn ào khói bụi, Thanh Trúc trở về ngôi nhà gỗ của ông bà ở vùng cao nguyên Lâm Đồng, tự tay cải tạo mảnh vườn hoang, trồng hồng cổ, đào ao thả cá và nấu những bữa cơm quê dân dã.', 'completed', 'novel', 'Điền văn,Chữa lành,Ẩm thực', 10, 4.8, 790000, 1793800000000, 've que trong hoa nuoi ca moc mien', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(330001, 33, 1, 'Chương 1: Chuyến xe buýt sớm về vùng đồi thông', '【Chương 1: Chuyến xe buýt sớm về vùng đồi thông】 Câu chuyện của tác phẩm "Về Quê Trồng Hoa Nuôi Cá" (tác giả: Mộc Miên, thể loại: Điền văn, Chữa lành, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Rời bỏ thành phố ồn ào khói bụi, Thanh Trúc trở về ngôi nhà gỗ của ông bà ở vùng cao nguyên Lâm Đồng, tự tay cải tạo mảnh vườn hoang, trồng hồng cổ, đào ao thả cá và nấu những bữa cơm quê dân dã.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: chuyến xe buýt sớm về vùng đồi thông, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Về Quê Trồng Hoa Nuôi Cá", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Chuyến xe buýt sớm về vùng đồi thông tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Chuyến xe buýt sớm về vùng đồi thông —'),
(330002, 33, 2, 'Chương 2: Dọn dẹp ngôi nhà gỗ phủ rêu xanh', '【Chương 2: Dọn dẹp ngôi nhà gỗ phủ rêu xanh】 Câu chuyện của tác phẩm "Về Quê Trồng Hoa Nuôi Cá" (tác giả: Mộc Miên, thể loại: Điền văn, Chữa lành, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Rời bỏ thành phố ồn ào khói bụi, Thanh Trúc trở về ngôi nhà gỗ của ông bà ở vùng cao nguyên Lâm Đồng, tự tay cải tạo mảnh vườn hoang, trồng hồng cổ, đào ao thả cá và nấu những bữa cơm quê dân dã.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: dọn dẹp ngôi nhà gỗ phủ rêu xanh, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Về Quê Trồng Hoa Nuôi Cá", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Dọn dẹp ngôi nhà gỗ phủ rêu xanh tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Dọn dẹp ngôi nhà gỗ phủ rêu xanh —'),
(330003, 33, 3, 'Chương 3: Gieo những luống hạt cải đầu tiên', '【Chương 3: Gieo những luống hạt cải đầu tiên】 Câu chuyện của tác phẩm "Về Quê Trồng Hoa Nuôi Cá" (tác giả: Mộc Miên, thể loại: Điền văn, Chữa lành, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Rời bỏ thành phố ồn ào khói bụi, Thanh Trúc trở về ngôi nhà gỗ của ông bà ở vùng cao nguyên Lâm Đồng, tự tay cải tạo mảnh vườn hoang, trồng hồng cổ, đào ao thả cá và nấu những bữa cơm quê dân dã.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: gieo những luống hạt cải đầu tiên, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Về Quê Trồng Hoa Nuôi Cá", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Gieo những luống hạt cải đầu tiên tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Gieo những luống hạt cải đầu tiên —'),
(330004, 33, 4, 'Chương 4: Giàn hoa hồng cổ trước cổng rào', '【Chương 4: Giàn hoa hồng cổ trước cổng rào】 Câu chuyện của tác phẩm "Về Quê Trồng Hoa Nuôi Cá" (tác giả: Mộc Miên, thể loại: Điền văn, Chữa lành, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Rời bỏ thành phố ồn ào khói bụi, Thanh Trúc trở về ngôi nhà gỗ của ông bà ở vùng cao nguyên Lâm Đồng, tự tay cải tạo mảnh vườn hoang, trồng hồng cổ, đào ao thả cá và nấu những bữa cơm quê dân dã.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: giàn hoa hồng cổ trước cổng rào, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Về Quê Trồng Hoa Nuôi Cá", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Giàn hoa hồng cổ trước cổng rào tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Giàn hoa hồng cổ trước cổng rào —'),
(330005, 33, 5, 'Chương 5: Nồi cá kho tộ ngày mưa phùn', '【Chương 5: Nồi cá kho tộ ngày mưa phùn】 Câu chuyện của tác phẩm "Về Quê Trồng Hoa Nuôi Cá" (tác giả: Mộc Miên, thể loại: Điền văn, Chữa lành, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Rời bỏ thành phố ồn ào khói bụi, Thanh Trúc trở về ngôi nhà gỗ của ông bà ở vùng cao nguyên Lâm Đồng, tự tay cải tạo mảnh vườn hoang, trồng hồng cổ, đào ao thả cá và nấu những bữa cơm quê dân dã.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: nồi cá kho tộ ngày mưa phùn, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Về Quê Trồng Hoa Nuôi Cá", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Nồi cá kho tộ ngày mưa phùn tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Nồi cá kho tộ ngày mưa phùn —'),
(330006, 33, 6, 'Chương 6: Chú chó nhỏ lạc vào hiên nhà', '【Chương 6: Chú chó nhỏ lạc vào hiên nhà】 Câu chuyện của tác phẩm "Về Quê Trồng Hoa Nuôi Cá" (tác giả: Mộc Miên, thể loại: Điền văn, Chữa lành, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Rời bỏ thành phố ồn ào khói bụi, Thanh Trúc trở về ngôi nhà gỗ của ông bà ở vùng cao nguyên Lâm Đồng, tự tay cải tạo mảnh vườn hoang, trồng hồng cổ, đào ao thả cá và nấu những bữa cơm quê dân dã.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: chú chó nhỏ lạc vào hiên nhà, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Về Quê Trồng Hoa Nuôi Cá", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Chú chó nhỏ lạc vào hiên nhà tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Chú chó nhỏ lạc vào hiên nhà —'),
(330007, 33, 7, 'Chương 7: Mùa thu hoạch hồng giòn treo gió', '【Chương 7: Mùa thu hoạch hồng giòn treo gió】 Câu chuyện của tác phẩm "Về Quê Trồng Hoa Nuôi Cá" (tác giả: Mộc Miên, thể loại: Điền văn, Chữa lành, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Rời bỏ thành phố ồn ào khói bụi, Thanh Trúc trở về ngôi nhà gỗ của ông bà ở vùng cao nguyên Lâm Đồng, tự tay cải tạo mảnh vườn hoang, trồng hồng cổ, đào ao thả cá và nấu những bữa cơm quê dân dã.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: mùa thu hoạch hồng giòn treo gió, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Về Quê Trồng Hoa Nuôi Cá", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Mùa thu hoạch hồng giòn treo gió tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Mùa thu hoạch hồng giòn treo gió —'),
(330008, 33, 8, 'Chương 8: Đêm lửa trại cùng những người hàng xóm tốt bụng', '【Chương 8: Đêm lửa trại cùng những người hàng xóm tốt bụng】 Câu chuyện của tác phẩm "Về Quê Trồng Hoa Nuôi Cá" (tác giả: Mộc Miên, thể loại: Điền văn, Chữa lành, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Rời bỏ thành phố ồn ào khói bụi, Thanh Trúc trở về ngôi nhà gỗ của ông bà ở vùng cao nguyên Lâm Đồng, tự tay cải tạo mảnh vườn hoang, trồng hồng cổ, đào ao thả cá và nấu những bữa cơm quê dân dã.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: đêm lửa trại cùng những người hàng xóm tốt bụng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Về Quê Trồng Hoa Nuôi Cá", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Đêm lửa trại cùng những người hàng xóm tốt bụng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Đêm lửa trại cùng những người hàng xóm tốt bụng —'),
(330009, 33, 9, 'Chương 9: Mứt dâu tây tự làm gửi người phương xa', '【Chương 9: Mứt dâu tây tự làm gửi người phương xa】 Câu chuyện của tác phẩm "Về Quê Trồng Hoa Nuôi Cá" (tác giả: Mộc Miên, thể loại: Điền văn, Chữa lành, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Rời bỏ thành phố ồn ào khói bụi, Thanh Trúc trở về ngôi nhà gỗ của ông bà ở vùng cao nguyên Lâm Đồng, tự tay cải tạo mảnh vườn hoang, trồng hồng cổ, đào ao thả cá và nấu những bữa cơm quê dân dã.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: mứt dâu tây tự làm gửi người phương xa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Về Quê Trồng Hoa Nuôi Cá", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Mứt dâu tây tự làm gửi người phương xa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Mứt dâu tây tự làm gửi người phương xa —'),
(330010, 33, 10, 'Chương 10: Bốn mùa bình yên nơi mảnh vườn nhỏ', '【Chương 10: Bốn mùa bình yên nơi mảnh vườn nhỏ】 Câu chuyện của tác phẩm "Về Quê Trồng Hoa Nuôi Cá" (tác giả: Mộc Miên, thể loại: Điền văn, Chữa lành, Ẩm thực) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Rời bỏ thành phố ồn ào khói bụi, Thanh Trúc trở về ngôi nhà gỗ của ông bà ở vùng cao nguyên Lâm Đồng, tự tay cải tạo mảnh vườn hoang, trồng hồng cổ, đào ao thả cá và nấu những bữa cơm quê dân dã.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: bốn mùa bình yên nơi mảnh vườn nhỏ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Về Quê Trồng Hoa Nuôi Cá", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Bốn mùa bình yên nơi mảnh vườn nhỏ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Bốn mùa bình yên nơi mảnh vườn nhỏ —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (34, 'Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch', 'Lê Quang Minh', 'https://picsum.photos/seed/novelreader-v3-34/300/450', 'Từ sân bóng đất nện ở vùng quê nghèo đến học viện bóng đá trẻ chuyên nghiệp, tiền đạo trẻ Hoàng Nam cùng các đồng đội vượt qua chấn thương và định kiến để đưa đội tuyển chạm tay vào cúp vàng châu lục.', 'ongoing', 'novel', 'Thể thao,Thanh xuân,Học đường', 10, 4.8, 710000, 1793800000000, 'san co ruc lua: giac mo vo dich le quang minh', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(340001, 34, 1, 'Chương 1: Đôi giày vải rách trên sân bóng làng', '【Chương 1: Đôi giày vải rách trên sân bóng làng】 Câu chuyện của tác phẩm "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch" (tác giả: Lê Quang Minh, thể loại: Thể thao, Thanh xuân, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ sân bóng đất nện ở vùng quê nghèo đến học viện bóng đá trẻ chuyên nghiệp, tiền đạo trẻ Hoàng Nam cùng các đồng đội vượt qua chấn thương và định kiến để đưa đội tuyển chạm tay vào cúp vàng châu lục.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: đôi giày vải rách trên sân bóng làng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Đôi giày vải rách trên sân bóng làng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Đôi giày vải rách trên sân bóng làng —'),
(340002, 34, 2, 'Chương 2: Buổi tuyển chọn vào học viện bóng đá trẻ', '【Chương 2: Buổi tuyển chọn vào học viện bóng đá trẻ】 Câu chuyện của tác phẩm "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch" (tác giả: Lê Quang Minh, thể loại: Thể thao, Thanh xuân, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ sân bóng đất nện ở vùng quê nghèo đến học viện bóng đá trẻ chuyên nghiệp, tiền đạo trẻ Hoàng Nam cùng các đồng đội vượt qua chấn thương và định kiến để đưa đội tuyển chạm tay vào cúp vàng châu lục.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: buổi tuyển chọn vào học viện bóng đá trẻ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Buổi tuyển chọn vào học viện bóng đá trẻ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Buổi tuyển chọn vào học viện bóng đá trẻ —'),
(340003, 34, 3, 'Chương 3: Bài tập sút phạt một ngàn quả mỗi ngày', '【Chương 3: Bài tập sút phạt một ngàn quả mỗi ngày】 Câu chuyện của tác phẩm "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch" (tác giả: Lê Quang Minh, thể loại: Thể thao, Thanh xuân, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ sân bóng đất nện ở vùng quê nghèo đến học viện bóng đá trẻ chuyên nghiệp, tiền đạo trẻ Hoàng Nam cùng các đồng đội vượt qua chấn thương và định kiến để đưa đội tuyển chạm tay vào cúp vàng châu lục.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: bài tập sút phạt một ngàn quả mỗi ngày, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Bài tập sút phạt một ngàn quả mỗi ngày tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Bài tập sút phạt một ngàn quả mỗi ngày —'),
(340004, 34, 4, 'Chương 4: Trận ra mắt ở giải vô địch U19 quốc gia', '【Chương 4: Trận ra mắt ở giải vô địch U19 quốc gia】 Câu chuyện của tác phẩm "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch" (tác giả: Lê Quang Minh, thể loại: Thể thao, Thanh xuân, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ sân bóng đất nện ở vùng quê nghèo đến học viện bóng đá trẻ chuyên nghiệp, tiền đạo trẻ Hoàng Nam cùng các đồng đội vượt qua chấn thương và định kiến để đưa đội tuyển chạm tay vào cúp vàng châu lục.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: trận ra mắt ở giải vô địch u19 quốc gia, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Trận ra mắt ở giải vô địch U19 quốc gia tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Trận ra mắt ở giải vô địch U19 quốc gia —'),
(340005, 34, 5, 'Chương 5: Cú sút xa ở phút bù giờ cuối cùng', '【Chương 5: Cú sút xa ở phút bù giờ cuối cùng】 Câu chuyện của tác phẩm "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch" (tác giả: Lê Quang Minh, thể loại: Thể thao, Thanh xuân, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ sân bóng đất nện ở vùng quê nghèo đến học viện bóng đá trẻ chuyên nghiệp, tiền đạo trẻ Hoàng Nam cùng các đồng đội vượt qua chấn thương và định kiến để đưa đội tuyển chạm tay vào cúp vàng châu lục.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: cú sút xa ở phút bù giờ cuối cùng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Cú sút xa ở phút bù giờ cuối cùng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Cú sút xa ở phút bù giờ cuối cùng —'),
(340006, 34, 6, 'Chương 6: Vượt qua chấn thương dây chằng', '【Chương 6: Vượt qua chấn thương dây chằng】 Câu chuyện của tác phẩm "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch" (tác giả: Lê Quang Minh, thể loại: Thể thao, Thanh xuân, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ sân bóng đất nện ở vùng quê nghèo đến học viện bóng đá trẻ chuyên nghiệp, tiền đạo trẻ Hoàng Nam cùng các đồng đội vượt qua chấn thương và định kiến để đưa đội tuyển chạm tay vào cúp vàng châu lục.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: vượt qua chấn thương dây chằng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Vượt qua chấn thương dây chằng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Vượt qua chấn thương dây chằng —'),
(340007, 34, 7, 'Chương 7: Danh sách triệu tập đội tuyển quốc gia', '【Chương 7: Danh sách triệu tập đội tuyển quốc gia】 Câu chuyện của tác phẩm "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch" (tác giả: Lê Quang Minh, thể loại: Thể thao, Thanh xuân, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ sân bóng đất nện ở vùng quê nghèo đến học viện bóng đá trẻ chuyên nghiệp, tiền đạo trẻ Hoàng Nam cùng các đồng đội vượt qua chấn thương và định kiến để đưa đội tuyển chạm tay vào cúp vàng châu lục.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: danh sách triệu tập đội tuyển quốc gia, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Danh sách triệu tập đội tuyển quốc gia tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Danh sách triệu tập đội tuyển quốc gia —'),
(340008, 34, 8, 'Chương 8: Đêm tuyết trắng trên sân vận động châu lục', '【Chương 8: Đêm tuyết trắng trên sân vận động châu lục】 Câu chuyện của tác phẩm "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch" (tác giả: Lê Quang Minh, thể loại: Thể thao, Thanh xuân, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ sân bóng đất nện ở vùng quê nghèo đến học viện bóng đá trẻ chuyên nghiệp, tiền đạo trẻ Hoàng Nam cùng các đồng đội vượt qua chấn thương và định kiến để đưa đội tuyển chạm tay vào cúp vàng châu lục.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: đêm tuyết trắng trên sân vận động châu lục, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Đêm tuyết trắng trên sân vận động châu lục tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Đêm tuyết trắng trên sân vận động châu lục —'),
(340009, 34, 9, 'Chương 9: Loạt sút luân lưu cân não', '【Chương 9: Loạt sút luân lưu cân não】 Câu chuyện của tác phẩm "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch" (tác giả: Lê Quang Minh, thể loại: Thể thao, Thanh xuân, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ sân bóng đất nện ở vùng quê nghèo đến học viện bóng đá trẻ chuyên nghiệp, tiền đạo trẻ Hoàng Nam cùng các đồng đội vượt qua chấn thương và định kiến để đưa đội tuyển chạm tay vào cúp vàng châu lục.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: loạt sút luân lưu cân não, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Loạt sút luân lưu cân não tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Loạt sút luân lưu cân não —'),
(340010, 34, 10, 'Chương 10: Khúc ca chiến thắng giữa biển cờ đỏ sao vàng', '【Chương 10: Khúc ca chiến thắng giữa biển cờ đỏ sao vàng】 Câu chuyện của tác phẩm "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch" (tác giả: Lê Quang Minh, thể loại: Thể thao, Thanh xuân, Học đường) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ sân bóng đất nện ở vùng quê nghèo đến học viện bóng đá trẻ chuyên nghiệp, tiền đạo trẻ Hoàng Nam cùng các đồng đội vượt qua chấn thương và định kiến để đưa đội tuyển chạm tay vào cúp vàng châu lục.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: khúc ca chiến thắng giữa biển cờ đỏ sao vàng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Sân Cỏ Rực Lửa: Giấc Mơ Vô Địch", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Khúc ca chiến thắng giữa biển cờ đỏ sao vàng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Khúc ca chiến thắng giữa biển cờ đỏ sao vàng —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (35, 'Thần Thoại Đất Việt: Truyền Thuyết Lạc Long', 'Hùng Vương Sử Truyện', 'https://picsum.photos/seed/novelreader-v3-35/300/450', 'Tập truyện thần thoại và truyền thuyết dân gian Việt Nam được chắp bút giàu hình ảnh văn chương: từ Lạc Long Quân – Âu Cơ, Sơn Tinh – Thủy Tinh đến Thánh Gióng và Sự tích Hồ Gươm.', 'completed', 'novel', 'Thần thoại,Dã sử,Lịch sử', 10, 4.9, 950000, 1793800000000, 'than thoai dat viet: truyen thuyet lac long hung vuong su truyen', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(350001, 35, 1, 'Chương 1: Rồng Tiên hội ngộ mở cõi non sông', '【Chương 1: Rồng Tiên hội ngộ mở cõi non sông】 Câu chuyện của tác phẩm "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long" (tác giả: Hùng Vương Sử Truyện, thể loại: Thần thoại, Dã sử, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tập truyện thần thoại và truyền thuyết dân gian Việt Nam được chắp bút giàu hình ảnh văn chương: từ Lạc Long Quân – Âu Cơ, Sơn Tinh – Thủy Tinh đến Thánh Gióng và Sự tích Hồ Gươm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: rồng tiên hội ngộ mở cõi non sông, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Rồng Tiên hội ngộ mở cõi non sông tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Rồng Tiên hội ngộ mở cõi non sông —'),
(350002, 35, 2, 'Chương 2: Trăm trứng nở trăm con – Bọc điều nghĩa đồng bào', '【Chương 2: Trăm trứng nở trăm con – Bọc điều nghĩa đồng bào】 Câu chuyện của tác phẩm "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long" (tác giả: Hùng Vương Sử Truyện, thể loại: Thần thoại, Dã sử, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tập truyện thần thoại và truyền thuyết dân gian Việt Nam được chắp bút giàu hình ảnh văn chương: từ Lạc Long Quân – Âu Cơ, Sơn Tinh – Thủy Tinh đến Thánh Gióng và Sự tích Hồ Gươm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: trăm trứng nở trăm con – bọc điều nghĩa đồng bào, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Trăm trứng nở trăm con – Bọc điều nghĩa đồng bào tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Trăm trứng nở trăm con – Bọc điều nghĩa đồng bào —'),
(350003, 35, 3, 'Chương 3: Lạc Long Quân diệt Ngư Tinh vùng biển Đông', '【Chương 3: Lạc Long Quân diệt Ngư Tinh vùng biển Đông】 Câu chuyện của tác phẩm "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long" (tác giả: Hùng Vương Sử Truyện, thể loại: Thần thoại, Dã sử, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tập truyện thần thoại và truyền thuyết dân gian Việt Nam được chắp bút giàu hình ảnh văn chương: từ Lạc Long Quân – Âu Cơ, Sơn Tinh – Thủy Tinh đến Thánh Gióng và Sự tích Hồ Gươm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: lạc long quân diệt ngư tinh vùng biển đông, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Lạc Long Quân diệt Ngư Tinh vùng biển Đông tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Lạc Long Quân diệt Ngư Tinh vùng biển Đông —'),
(350004, 35, 4, 'Chương 4: Sơn Tinh – Thủy Tinh và cuộc cầu hôn Mỵ Nương', '【Chương 4: Sơn Tinh – Thủy Tinh và cuộc cầu hôn Mỵ Nương】 Câu chuyện của tác phẩm "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long" (tác giả: Hùng Vương Sử Truyện, thể loại: Thần thoại, Dã sử, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tập truyện thần thoại và truyền thuyết dân gian Việt Nam được chắp bút giàu hình ảnh văn chương: từ Lạc Long Quân – Âu Cơ, Sơn Tinh – Thủy Tinh đến Thánh Gióng và Sự tích Hồ Gươm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: sơn tinh – thủy tinh và cuộc cầu hôn mỵ nương, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Sơn Tinh – Thủy Tinh và cuộc cầu hôn Mỵ Nương tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Sơn Tinh – Thủy Tinh và cuộc cầu hôn Mỵ Nương —'),
(350005, 35, 5, 'Chương 5: Phù Đổng Thiên Vương cưỡi ngựa sắt phun lửa', '【Chương 5: Phù Đổng Thiên Vương cưỡi ngựa sắt phun lửa】 Câu chuyện của tác phẩm "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long" (tác giả: Hùng Vương Sử Truyện, thể loại: Thần thoại, Dã sử, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tập truyện thần thoại và truyền thuyết dân gian Việt Nam được chắp bút giàu hình ảnh văn chương: từ Lạc Long Quân – Âu Cơ, Sơn Tinh – Thủy Tinh đến Thánh Gióng và Sự tích Hồ Gươm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: phù đổng thiên vương cưỡi ngựa sắt phun lửa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Phù Đổng Thiên Vương cưỡi ngựa sắt phun lửa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Phù Đổng Thiên Vương cưỡi ngựa sắt phun lửa —'),
(350006, 35, 6, 'Chương 6: Chử Đồng Tử và Tiên Dung công chúa', '【Chương 6: Chử Đồng Tử và Tiên Dung công chúa】 Câu chuyện của tác phẩm "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long" (tác giả: Hùng Vương Sử Truyện, thể loại: Thần thoại, Dã sử, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tập truyện thần thoại và truyền thuyết dân gian Việt Nam được chắp bút giàu hình ảnh văn chương: từ Lạc Long Quân – Âu Cơ, Sơn Tinh – Thủy Tinh đến Thánh Gióng và Sự tích Hồ Gươm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: chử đồng tử và tiên dung công chúa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Chử Đồng Tử và Tiên Dung công chúa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Chử Đồng Tử và Tiên Dung công chúa —'),
(350007, 35, 7, 'Chương 7: Sự tích bánh chưng bánh giầy của Lang Liêu', '【Chương 7: Sự tích bánh chưng bánh giầy của Lang Liêu】 Câu chuyện của tác phẩm "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long" (tác giả: Hùng Vương Sử Truyện, thể loại: Thần thoại, Dã sử, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tập truyện thần thoại và truyền thuyết dân gian Việt Nam được chắp bút giàu hình ảnh văn chương: từ Lạc Long Quân – Âu Cơ, Sơn Tinh – Thủy Tinh đến Thánh Gióng và Sự tích Hồ Gươm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: sự tích bánh chưng bánh giầy của lang liêu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Sự tích bánh chưng bánh giầy của Lang Liêu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Sự tích bánh chưng bánh giầy của Lang Liêu —'),
(350008, 35, 8, 'Chương 8: Mai An Tiêm và quả dưa hấu đỏ ngoài đảo xa', '【Chương 8: Mai An Tiêm và quả dưa hấu đỏ ngoài đảo xa】 Câu chuyện của tác phẩm "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long" (tác giả: Hùng Vương Sử Truyện, thể loại: Thần thoại, Dã sử, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tập truyện thần thoại và truyền thuyết dân gian Việt Nam được chắp bút giàu hình ảnh văn chương: từ Lạc Long Quân – Âu Cơ, Sơn Tinh – Thủy Tinh đến Thánh Gióng và Sự tích Hồ Gươm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: mai an tiêm và quả dưa hấu đỏ ngoài đảo xa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Mai An Tiêm và quả dưa hấu đỏ ngoài đảo xa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Mai An Tiêm và quả dưa hấu đỏ ngoài đảo xa —'),
(350009, 35, 9, 'Chương 9: Nỏ thần Kim Quy thành Cổ Loa', '【Chương 9: Nỏ thần Kim Quy thành Cổ Loa】 Câu chuyện của tác phẩm "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long" (tác giả: Hùng Vương Sử Truyện, thể loại: Thần thoại, Dã sử, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tập truyện thần thoại và truyền thuyết dân gian Việt Nam được chắp bút giàu hình ảnh văn chương: từ Lạc Long Quân – Âu Cơ, Sơn Tinh – Thủy Tinh đến Thánh Gióng và Sự tích Hồ Gươm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: nỏ thần kim quy thành cổ loa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Nỏ thần Kim Quy thành Cổ Loa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Nỏ thần Kim Quy thành Cổ Loa —'),
(350010, 35, 10, 'Chương 10: Thuận Thiên Kiếm trả lại Rùa Vàng Hồ Gươm', '【Chương 10: Thuận Thiên Kiếm trả lại Rùa Vàng Hồ Gươm】 Câu chuyện của tác phẩm "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long" (tác giả: Hùng Vương Sử Truyện, thể loại: Thần thoại, Dã sử, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Tập truyện thần thoại và truyền thuyết dân gian Việt Nam được chắp bút giàu hình ảnh văn chương: từ Lạc Long Quân – Âu Cơ, Sơn Tinh – Thủy Tinh đến Thánh Gióng và Sự tích Hồ Gươm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: thuận thiên kiếm trả lại rùa vàng hồ gươm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Thần Thoại Đất Việt: Truyền Thuyết Lạc Long", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Thuận Thiên Kiếm trả lại Rùa Vàng Hồ Gươm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Thuận Thiên Kiếm trả lại Rùa Vàng Hồ Gươm —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (36, 'Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7', 'Đinh Hoàng Sơn', 'https://picsum.photos/seed/novelreader-v3-36/300/450', 'Đội trưởng đội trọng án số 7 Lương Thế Vinh cùng chuyên gia tâm lý tội phạm Hà My phối hợp truy tìm dấu vết trong những vụ án phức tạp nhất, nơi ranh giới thiện ác được phân tích đến từng biểu cảm vi mô.', 'ongoing', 'novel', 'Hình sự,Trinh thám,Tâm lý', 10, 4.8, 830000, 1793800000000, 'pha an luc nua dem: doi trong an so 7 dinh hoang son', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(360001, 36, 1, 'Chương 1: Cuộc gọi khẩn cấp lúc hai giờ mười lăm phút', '【Chương 1: Cuộc gọi khẩn cấp lúc hai giờ mười lăm phút】 Câu chuyện của tác phẩm "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7" (tác giả: Đinh Hoàng Sơn, thể loại: Hình sự, Trinh thám, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Đội trưởng đội trọng án số 7 Lương Thế Vinh cùng chuyên gia tâm lý tội phạm Hà My phối hợp truy tìm dấu vết trong những vụ án phức tạp nhất, nơi ranh giới thiện ác được phân tích đến từng biểu cảm vi mô.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: cuộc gọi khẩn cấp lúc hai giờ mười lăm phút, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Cuộc gọi khẩn cấp lúc hai giờ mười lăm phút tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Cuộc gọi khẩn cấp lúc hai giờ mười lăm phút —'),
(360002, 36, 2, 'Chương 2: Hiện trường không một dấu vết cạy cửa', '【Chương 2: Hiện trường không một dấu vết cạy cửa】 Câu chuyện của tác phẩm "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7" (tác giả: Đinh Hoàng Sơn, thể loại: Hình sự, Trinh thám, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Đội trưởng đội trọng án số 7 Lương Thế Vinh cùng chuyên gia tâm lý tội phạm Hà My phối hợp truy tìm dấu vết trong những vụ án phức tạp nhất, nơi ranh giới thiện ác được phân tích đến từng biểu cảm vi mô.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: hiện trường không một dấu vết cạy cửa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Hiện trường không một dấu vết cạy cửa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Hiện trường không một dấu vết cạy cửa —'),
(360003, 36, 3, 'Chương 3: Phân tích tâm lý qua nét chữ viết tay', '【Chương 3: Phân tích tâm lý qua nét chữ viết tay】 Câu chuyện của tác phẩm "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7" (tác giả: Đinh Hoàng Sơn, thể loại: Hình sự, Trinh thám, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Đội trưởng đội trọng án số 7 Lương Thế Vinh cùng chuyên gia tâm lý tội phạm Hà My phối hợp truy tìm dấu vết trong những vụ án phức tạp nhất, nơi ranh giới thiện ác được phân tích đến từng biểu cảm vi mô.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: phân tích tâm lý qua nét chữ viết tay, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Phân tích tâm lý qua nét chữ viết tay tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Phân tích tâm lý qua nét chữ viết tay —'),
(360004, 36, 4, 'Chương 4: Camera hành trình trên quốc lộ đêm mưa', '【Chương 4: Camera hành trình trên quốc lộ đêm mưa】 Câu chuyện của tác phẩm "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7" (tác giả: Đinh Hoàng Sơn, thể loại: Hình sự, Trinh thám, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Đội trưởng đội trọng án số 7 Lương Thế Vinh cùng chuyên gia tâm lý tội phạm Hà My phối hợp truy tìm dấu vết trong những vụ án phức tạp nhất, nơi ranh giới thiện ác được phân tích đến từng biểu cảm vi mô.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: camera hành trình trên quốc lộ đêm mưa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Camera hành trình trên quốc lộ đêm mưa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Camera hành trình trên quốc lộ đêm mưa —'),
(360005, 36, 5, 'Chương 5: Lời khai mâu thuẫn của ba nhân chứng', '【Chương 5: Lời khai mâu thuẫn của ba nhân chứng】 Câu chuyện của tác phẩm "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7" (tác giả: Đinh Hoàng Sơn, thể loại: Hình sự, Trinh thám, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Đội trưởng đội trọng án số 7 Lương Thế Vinh cùng chuyên gia tâm lý tội phạm Hà My phối hợp truy tìm dấu vết trong những vụ án phức tạp nhất, nơi ranh giới thiện ác được phân tích đến từng biểu cảm vi mô.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: lời khai mâu thuẫn của ba nhân chứng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Lời khai mâu thuẫn của ba nhân chứng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Lời khai mâu thuẫn của ba nhân chứng —'),
(360006, 36, 6, 'Chương 6: Cuộc thẩm vấn căng thẳng trong phòng kính', '【Chương 6: Cuộc thẩm vấn căng thẳng trong phòng kính】 Câu chuyện của tác phẩm "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7" (tác giả: Đinh Hoàng Sơn, thể loại: Hình sự, Trinh thám, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Đội trưởng đội trọng án số 7 Lương Thế Vinh cùng chuyên gia tâm lý tội phạm Hà My phối hợp truy tìm dấu vết trong những vụ án phức tạp nhất, nơi ranh giới thiện ác được phân tích đến từng biểu cảm vi mô.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: cuộc thẩm vấn căng thẳng trong phòng kính, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Cuộc thẩm vấn căng thẳng trong phòng kính tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Cuộc thẩm vấn căng thẳng trong phòng kính —'),
(360007, 36, 7, 'Chương 7: Mắt xích bị bỏ sót năm năm trước', '【Chương 7: Mắt xích bị bỏ sót năm năm trước】 Câu chuyện của tác phẩm "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7" (tác giả: Đinh Hoàng Sơn, thể loại: Hình sự, Trinh thám, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Đội trưởng đội trọng án số 7 Lương Thế Vinh cùng chuyên gia tâm lý tội phạm Hà My phối hợp truy tìm dấu vết trong những vụ án phức tạp nhất, nơi ranh giới thiện ác được phân tích đến từng biểu cảm vi mô.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: mắt xích bị bỏ sót năm năm trước, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Mắt xích bị bỏ sót năm năm trước tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Mắt xích bị bỏ sót năm năm trước —'),
(360008, 36, 8, 'Chương 8: Đêm mai phục tại cảng container', '【Chương 8: Đêm mai phục tại cảng container】 Câu chuyện của tác phẩm "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7" (tác giả: Đinh Hoàng Sơn, thể loại: Hình sự, Trinh thám, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Đội trưởng đội trọng án số 7 Lương Thế Vinh cùng chuyên gia tâm lý tội phạm Hà My phối hợp truy tìm dấu vết trong những vụ án phức tạp nhất, nơi ranh giới thiện ác được phân tích đến từng biểu cảm vi mô.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: đêm mai phục tại cảng container, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Đêm mai phục tại cảng container tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Đêm mai phục tại cảng container —'),
(360009, 36, 9, 'Chương 9: Bắt giữ kẻ chủ mưu trước giờ cất cánh', '【Chương 9: Bắt giữ kẻ chủ mưu trước giờ cất cánh】 Câu chuyện của tác phẩm "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7" (tác giả: Đinh Hoàng Sơn, thể loại: Hình sự, Trinh thám, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Đội trưởng đội trọng án số 7 Lương Thế Vinh cùng chuyên gia tâm lý tội phạm Hà My phối hợp truy tìm dấu vết trong những vụ án phức tạp nhất, nơi ranh giới thiện ác được phân tích đến từng biểu cảm vi mô.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: bắt giữ kẻ chủ mưu trước giờ cất cánh, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Bắt giữ kẻ chủ mưu trước giờ cất cánh tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Bắt giữ kẻ chủ mưu trước giờ cất cánh —'),
(360010, 36, 10, 'Chương 10: Công lý luôn lên tiếng', '【Chương 10: Công lý luôn lên tiếng】 Câu chuyện của tác phẩm "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7" (tác giả: Đinh Hoàng Sơn, thể loại: Hình sự, Trinh thám, Tâm lý) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Đội trưởng đội trọng án số 7 Lương Thế Vinh cùng chuyên gia tâm lý tội phạm Hà My phối hợp truy tìm dấu vết trong những vụ án phức tạp nhất, nơi ranh giới thiện ác được phân tích đến từng biểu cảm vi mô.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: công lý luôn lên tiếng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Phá Án Lúc Nửa Đêm: Đội Trọng Án Số 7", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Công lý luôn lên tiếng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Công lý luôn lên tiếng —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (37, 'Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế', 'Hàn Mặc Phong', 'https://picsum.photos/seed/novelreader-v3-37/300/450', 'Khi mưa thiên thạch mang theo bào tử biến dị rơi xuống Trái Đất, kỹ sư xây dựng Bách Khoa kích hoạt Hệ Thống Kiến Thiết Pháo Đài, biến khu căn cứ bỏ hoang thành thành trì vững chắc nhất nhân loại.', 'ongoing', 'novel', 'Mạt thế,Hệ thống,Hành động', 10, 4.7, 770000, 1793800000000, 'phao dai cuoi cung: binh minh sau tan the han mac phong', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(370001, 37, 1, 'Chương 1: Cơn mưa sao băng màu tím', '【Chương 1: Cơn mưa sao băng màu tím】 Câu chuyện của tác phẩm "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế" (tác giả: Hàn Mặc Phong, thể loại: Mạt thế, Hệ thống, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mưa thiên thạch mang theo bào tử biến dị rơi xuống Trái Đất, kỹ sư xây dựng Bách Khoa kích hoạt Hệ Thống Kiến Thiết Pháo Đài, biến khu căn cứ bỏ hoang thành thành trì vững chắc nhất nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: cơn mưa sao băng màu tím, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Cơn mưa sao băng màu tím tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Cơn mưa sao băng màu tím —'),
(370002, 37, 2, 'Chương 2: Kích hoạt Hệ Thống Kiến Thiết Pháo Đài', '【Chương 2: Kích hoạt Hệ Thống Kiến Thiết Pháo Đài】 Câu chuyện của tác phẩm "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế" (tác giả: Hàn Mặc Phong, thể loại: Mạt thế, Hệ thống, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mưa thiên thạch mang theo bào tử biến dị rơi xuống Trái Đất, kỹ sư xây dựng Bách Khoa kích hoạt Hệ Thống Kiến Thiết Pháo Đài, biến khu căn cứ bỏ hoang thành thành trì vững chắc nhất nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: kích hoạt hệ thống kiến thiết pháo đài, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Kích hoạt Hệ Thống Kiến Thiết Pháo Đài tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Kích hoạt Hệ Thống Kiến Thiết Pháo Đài —'),
(370003, 37, 3, 'Chương 3: Nâng cấp tường thành hợp kim titan', '【Chương 3: Nâng cấp tường thành hợp kim titan】 Câu chuyện của tác phẩm "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế" (tác giả: Hàn Mặc Phong, thể loại: Mạt thế, Hệ thống, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mưa thiên thạch mang theo bào tử biến dị rơi xuống Trái Đất, kỹ sư xây dựng Bách Khoa kích hoạt Hệ Thống Kiến Thiết Pháo Đài, biến khu căn cứ bỏ hoang thành thành trì vững chắc nhất nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: nâng cấp tường thành hợp kim titan, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Nâng cấp tường thành hợp kim titan tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Nâng cấp tường thành hợp kim titan —'),
(370004, 37, 4, 'Chương 4: Giải cứu đoàn người sống sót ở siêu thị', '【Chương 4: Giải cứu đoàn người sống sót ở siêu thị】 Câu chuyện của tác phẩm "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế" (tác giả: Hàn Mặc Phong, thể loại: Mạt thế, Hệ thống, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mưa thiên thạch mang theo bào tử biến dị rơi xuống Trái Đất, kỹ sư xây dựng Bách Khoa kích hoạt Hệ Thống Kiến Thiết Pháo Đài, biến khu căn cứ bỏ hoang thành thành trì vững chắc nhất nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: giải cứu đoàn người sống sót ở siêu thị, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Giải cứu đoàn người sống sót ở siêu thị tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Giải cứu đoàn người sống sót ở siêu thị —'),
(370005, 37, 5, 'Chương 5: Nhà kính thủy canh tự động dưới hầm ngầm', '【Chương 5: Nhà kính thủy canh tự động dưới hầm ngầm】 Câu chuyện của tác phẩm "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế" (tác giả: Hàn Mặc Phong, thể loại: Mạt thế, Hệ thống, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mưa thiên thạch mang theo bào tử biến dị rơi xuống Trái Đất, kỹ sư xây dựng Bách Khoa kích hoạt Hệ Thống Kiến Thiết Pháo Đài, biến khu căn cứ bỏ hoang thành thành trì vững chắc nhất nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: nhà kính thủy canh tự động dưới hầm ngầm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Nhà kính thủy canh tự động dưới hầm ngầm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Nhà kính thủy canh tự động dưới hầm ngầm —'),
(370006, 37, 6, 'Chương 6: Đợt tấn công của đàn thú biến dị', '【Chương 6: Đợt tấn công của đàn thú biến dị】 Câu chuyện của tác phẩm "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế" (tác giả: Hàn Mặc Phong, thể loại: Mạt thế, Hệ thống, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mưa thiên thạch mang theo bào tử biến dị rơi xuống Trái Đất, kỹ sư xây dựng Bách Khoa kích hoạt Hệ Thống Kiến Thiết Pháo Đài, biến khu căn cứ bỏ hoang thành thành trì vững chắc nhất nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: đợt tấn công của đàn thú biến dị, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Đợt tấn công của đàn thú biến dị tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Đợt tấn công của đàn thú biến dị —'),
(370007, 37, 7, 'Chương 7: Chế tạo huyết thanh kháng thể thế hệ một', '【Chương 7: Chế tạo huyết thanh kháng thể thế hệ một】 Câu chuyện của tác phẩm "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế" (tác giả: Hàn Mặc Phong, thể loại: Mạt thế, Hệ thống, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mưa thiên thạch mang theo bào tử biến dị rơi xuống Trái Đất, kỹ sư xây dựng Bách Khoa kích hoạt Hệ Thống Kiến Thiết Pháo Đài, biến khu căn cứ bỏ hoang thành thành trì vững chắc nhất nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: chế tạo huyết thanh kháng thể thế hệ một, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Chế tạo huyết thanh kháng thể thế hệ một tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Chế tạo huyết thanh kháng thể thế hệ một —'),
(370008, 37, 8, 'Chương 8: Kết nối liên lạc với căn cứ phương nam', '【Chương 8: Kết nối liên lạc với căn cứ phương nam】 Câu chuyện của tác phẩm "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế" (tác giả: Hàn Mặc Phong, thể loại: Mạt thế, Hệ thống, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mưa thiên thạch mang theo bào tử biến dị rơi xuống Trái Đất, kỹ sư xây dựng Bách Khoa kích hoạt Hệ Thống Kiến Thiết Pháo Đài, biến khu căn cứ bỏ hoang thành thành trì vững chắc nhất nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: kết nối liên lạc với căn cứ phương nam, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Kết nối liên lạc với căn cứ phương nam tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Kết nối liên lạc với căn cứ phương nam —'),
(370009, 37, 9, 'Chương 9: Chiến dịch thu hồi nhà máy điện mặt trời', '【Chương 9: Chiến dịch thu hồi nhà máy điện mặt trời】 Câu chuyện của tác phẩm "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế" (tác giả: Hàn Mặc Phong, thể loại: Mạt thế, Hệ thống, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mưa thiên thạch mang theo bào tử biến dị rơi xuống Trái Đất, kỹ sư xây dựng Bách Khoa kích hoạt Hệ Thống Kiến Thiết Pháo Đài, biến khu căn cứ bỏ hoang thành thành trì vững chắc nhất nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: chiến dịch thu hồi nhà máy điện mặt trời, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Chiến dịch thu hồi nhà máy điện mặt trời tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Chiến dịch thu hồi nhà máy điện mặt trời —'),
(370010, 37, 10, 'Chương 10: Ngọn hải đăng hy vọng của nhân loại', '【Chương 10: Ngọn hải đăng hy vọng của nhân loại】 Câu chuyện của tác phẩm "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế" (tác giả: Hàn Mặc Phong, thể loại: Mạt thế, Hệ thống, Hành động) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Khi mưa thiên thạch mang theo bào tử biến dị rơi xuống Trái Đất, kỹ sư xây dựng Bách Khoa kích hoạt Hệ Thống Kiến Thiết Pháo Đài, biến khu căn cứ bỏ hoang thành thành trì vững chắc nhất nhân loại.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: ngọn hải đăng hy vọng của nhân loại, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Pháo Đài Cuối Cùng: Bình Minh Sau Tận Thế", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Ngọn hải đăng hy vọng của nhân loại tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Ngọn hải đăng hy vọng của nhân loại —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (38, 'Hương Vị Cố Hương: Gian Bếp Của Ngoại', 'Vũ Quỳnh Hương', 'https://picsum.photos/seed/novelreader-v3-38/300/450', 'Giữa những tranh chấp thừa kế căn nhà cổ ba gian ở phố hội, cô cháu gái út Thảo Nguyên dùng chính cuốn sổ tay công thức nấu ăn gia truyền của bà ngoại để gắn kết lại đại gia đình bốn thế hệ.', 'completed', 'novel', 'Ẩm thực,Gia đấu,Văn học Việt Nam', 10, 4.9, 850000, 1793800000000, 'huong vi co huong: gian bep cua ngoai vu quynh huong', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(380001, 38, 1, 'Chương 1: Cuốn sổ tay ố vàng trong rương gỗ trầm', '【Chương 1: Cuốn sổ tay ố vàng trong rương gỗ trầm】 Câu chuyện của tác phẩm "Hương Vị Cố Hương: Gian Bếp Của Ngoại" (tác giả: Vũ Quỳnh Hương, thể loại: Ẩm thực, Gia đấu, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa những tranh chấp thừa kế căn nhà cổ ba gian ở phố hội, cô cháu gái út Thảo Nguyên dùng chính cuốn sổ tay công thức nấu ăn gia truyền của bà ngoại để gắn kết lại đại gia đình bốn thế hệ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: cuốn sổ tay ố vàng trong rương gỗ trầm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hương Vị Cố Hương: Gian Bếp Của Ngoại", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Cuốn sổ tay ố vàng trong rương gỗ trầm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Cuốn sổ tay ố vàng trong rương gỗ trầm —'),
(380002, 38, 2, 'Chương 2: Bát cao lầu chuẩn vị phố cổ Hội An', '【Chương 2: Bát cao lầu chuẩn vị phố cổ Hội An】 Câu chuyện của tác phẩm "Hương Vị Cố Hương: Gian Bếp Của Ngoại" (tác giả: Vũ Quỳnh Hương, thể loại: Ẩm thực, Gia đấu, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa những tranh chấp thừa kế căn nhà cổ ba gian ở phố hội, cô cháu gái út Thảo Nguyên dùng chính cuốn sổ tay công thức nấu ăn gia truyền của bà ngoại để gắn kết lại đại gia đình bốn thế hệ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: bát cao lầu chuẩn vị phố cổ hội an, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hương Vị Cố Hương: Gian Bếp Của Ngoại", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Bát cao lầu chuẩn vị phố cổ Hội An tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Bát cao lầu chuẩn vị phố cổ Hội An —'),
(380003, 38, 3, 'Chương 3: Mâm cơm giỗ tổ và những bất đồng gia tộc', '【Chương 3: Mâm cơm giỗ tổ và những bất đồng gia tộc】 Câu chuyện của tác phẩm "Hương Vị Cố Hương: Gian Bếp Của Ngoại" (tác giả: Vũ Quỳnh Hương, thể loại: Ẩm thực, Gia đấu, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa những tranh chấp thừa kế căn nhà cổ ba gian ở phố hội, cô cháu gái út Thảo Nguyên dùng chính cuốn sổ tay công thức nấu ăn gia truyền của bà ngoại để gắn kết lại đại gia đình bốn thế hệ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: mâm cơm giỗ tổ và những bất đồng gia tộc, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hương Vị Cố Hương: Gian Bếp Của Ngoại", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Mâm cơm giỗ tổ và những bất đồng gia tộc tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Mâm cơm giỗ tổ và những bất đồng gia tộc —'),
(380004, 38, 4, 'Chương 4: Bí quyết nước dùng trong vắt của ngoại', '【Chương 4: Bí quyết nước dùng trong vắt của ngoại】 Câu chuyện của tác phẩm "Hương Vị Cố Hương: Gian Bếp Của Ngoại" (tác giả: Vũ Quỳnh Hương, thể loại: Ẩm thực, Gia đấu, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa những tranh chấp thừa kế căn nhà cổ ba gian ở phố hội, cô cháu gái út Thảo Nguyên dùng chính cuốn sổ tay công thức nấu ăn gia truyền của bà ngoại để gắn kết lại đại gia đình bốn thế hệ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: bí quyết nước dùng trong vắt của ngoại, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hương Vị Cố Hương: Gian Bếp Của Ngoại", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Bí quyết nước dùng trong vắt của ngoại tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Bí quyết nước dùng trong vắt của ngoại —'),
(380005, 38, 5, 'Chương 5: Chè hạt sen long nhãn ngày nắng hạ', '【Chương 5: Chè hạt sen long nhãn ngày nắng hạ】 Câu chuyện của tác phẩm "Hương Vị Cố Hương: Gian Bếp Của Ngoại" (tác giả: Vũ Quỳnh Hương, thể loại: Ẩm thực, Gia đấu, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa những tranh chấp thừa kế căn nhà cổ ba gian ở phố hội, cô cháu gái út Thảo Nguyên dùng chính cuốn sổ tay công thức nấu ăn gia truyền của bà ngoại để gắn kết lại đại gia đình bốn thế hệ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: chè hạt sen long nhãn ngày nắng hạ, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hương Vị Cố Hương: Gian Bếp Của Ngoại", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Chè hạt sen long nhãn ngày nắng hạ tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Chè hạt sen long nhãn ngày nắng hạ —'),
(380006, 38, 6, 'Chương 6: Hóa giải hiềm khích giữa hai người bác', '【Chương 6: Hóa giải hiềm khích giữa hai người bác】 Câu chuyện của tác phẩm "Hương Vị Cố Hương: Gian Bếp Của Ngoại" (tác giả: Vũ Quỳnh Hương, thể loại: Ẩm thực, Gia đấu, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa những tranh chấp thừa kế căn nhà cổ ba gian ở phố hội, cô cháu gái út Thảo Nguyên dùng chính cuốn sổ tay công thức nấu ăn gia truyền của bà ngoại để gắn kết lại đại gia đình bốn thế hệ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: hóa giải hiềm khích giữa hai người bác, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hương Vị Cố Hương: Gian Bếp Của Ngoại", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Hóa giải hiềm khích giữa hai người bác tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Hóa giải hiềm khích giữa hai người bác —'),
(380007, 38, 7, 'Chương 7: Giữ lại ngôi nhà cổ trước lời mời mua giá cao', '【Chương 7: Giữ lại ngôi nhà cổ trước lời mời mua giá cao】 Câu chuyện của tác phẩm "Hương Vị Cố Hương: Gian Bếp Của Ngoại" (tác giả: Vũ Quỳnh Hương, thể loại: Ẩm thực, Gia đấu, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa những tranh chấp thừa kế căn nhà cổ ba gian ở phố hội, cô cháu gái út Thảo Nguyên dùng chính cuốn sổ tay công thức nấu ăn gia truyền của bà ngoại để gắn kết lại đại gia đình bốn thế hệ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: giữ lại ngôi nhà cổ trước lời mời mua giá cao, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hương Vị Cố Hương: Gian Bếp Của Ngoại", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Giữ lại ngôi nhà cổ trước lời mời mua giá cao tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Giữ lại ngôi nhà cổ trước lời mời mua giá cao —'),
(380008, 38, 8, 'Chương 8: Mở quán ăn gia truyền Hương Cố Hương', '【Chương 8: Mở quán ăn gia truyền Hương Cố Hương】 Câu chuyện của tác phẩm "Hương Vị Cố Hương: Gian Bếp Của Ngoại" (tác giả: Vũ Quỳnh Hương, thể loại: Ẩm thực, Gia đấu, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa những tranh chấp thừa kế căn nhà cổ ba gian ở phố hội, cô cháu gái út Thảo Nguyên dùng chính cuốn sổ tay công thức nấu ăn gia truyền của bà ngoại để gắn kết lại đại gia đình bốn thế hệ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: mở quán ăn gia truyền hương cố hương, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hương Vị Cố Hương: Gian Bếp Của Ngoại", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Mở quán ăn gia truyền Hương Cố Hương tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Mở quán ăn gia truyền Hương Cố Hương —'),
(380009, 38, 9, 'Chương 9: Thực khách phương xa tìm về hương vị xưa', '【Chương 9: Thực khách phương xa tìm về hương vị xưa】 Câu chuyện của tác phẩm "Hương Vị Cố Hương: Gian Bếp Của Ngoại" (tác giả: Vũ Quỳnh Hương, thể loại: Ẩm thực, Gia đấu, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa những tranh chấp thừa kế căn nhà cổ ba gian ở phố hội, cô cháu gái út Thảo Nguyên dùng chính cuốn sổ tay công thức nấu ăn gia truyền của bà ngoại để gắn kết lại đại gia đình bốn thế hệ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: thực khách phương xa tìm về hương vị xưa, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hương Vị Cố Hương: Gian Bếp Của Ngoại", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Thực khách phương xa tìm về hương vị xưa tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Thực khách phương xa tìm về hương vị xưa —'),
(380010, 38, 10, 'Chương 10: Mâm cỗ đoàn viên đêm ba mươi Tết', '【Chương 10: Mâm cỗ đoàn viên đêm ba mươi Tết】 Câu chuyện của tác phẩm "Hương Vị Cố Hương: Gian Bếp Của Ngoại" (tác giả: Vũ Quỳnh Hương, thể loại: Ẩm thực, Gia đấu, Văn học Việt Nam) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Giữa những tranh chấp thừa kế căn nhà cổ ba gian ở phố hội, cô cháu gái út Thảo Nguyên dùng chính cuốn sổ tay công thức nấu ăn gia truyền của bà ngoại để gắn kết lại đại gia đình bốn thế hệ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: mâm cỗ đoàn viên đêm ba mươi tết, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Hương Vị Cố Hương: Gian Bếp Của Ngoại", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Mâm cỗ đoàn viên đêm ba mươi Tết tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Mâm cỗ đoàn viên đêm ba mươi Tết —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (39, 'Nhật Ký Hoàng Cung: Nữ Quan Đại Nội', 'Lê Ngọc Hân', 'https://picsum.photos/seed/novelreader-v3-39/300/450', 'Từ một thiếu nữ bình dân thi đỗ vào Thượng Cung Cục lo việc sổ sách lễ nghi, Mai Tuyết Lan nhờ sự thông tuệ và chính trực đã vượt qua bao sóng gió chốn cung đình để trở thành Nữ quan bậc nhất phẩm.', 'completed', 'novel', 'Cung đấu,Cổ đại,Lịch sử', 10, 4.8, 790000, 1793800000000, 'nhat ky hoang cung: nu quan dai noi le ngoc han', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(390001, 39, 1, 'Chương 1: Kỳ khảo hạch tuyển nữ quan mùa xuân', '【Chương 1: Kỳ khảo hạch tuyển nữ quan mùa xuân】 Câu chuyện của tác phẩm "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội" (tác giả: Lê Ngọc Hân, thể loại: Cung đấu, Cổ đại, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một thiếu nữ bình dân thi đỗ vào Thượng Cung Cục lo việc sổ sách lễ nghi, Mai Tuyết Lan nhờ sự thông tuệ và chính trực đã vượt qua bao sóng gió chốn cung đình để trở thành Nữ quan bậc nhất phẩm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: kỳ khảo hạch tuyển nữ quan mùa xuân, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Kỳ khảo hạch tuyển nữ quan mùa xuân tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Kỳ khảo hạch tuyển nữ quan mùa xuân —'),
(390002, 39, 2, 'Chương 2: Quy tắc nghiêm ngặt nơi Thượng Cung Cục', '【Chương 2: Quy tắc nghiêm ngặt nơi Thượng Cung Cục】 Câu chuyện của tác phẩm "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội" (tác giả: Lê Ngọc Hân, thể loại: Cung đấu, Cổ đại, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một thiếu nữ bình dân thi đỗ vào Thượng Cung Cục lo việc sổ sách lễ nghi, Mai Tuyết Lan nhờ sự thông tuệ và chính trực đã vượt qua bao sóng gió chốn cung đình để trở thành Nữ quan bậc nhất phẩm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: quy tắc nghiêm ngặt nơi thượng cung cục, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Quy tắc nghiêm ngặt nơi Thượng Cung Cục tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Quy tắc nghiêm ngặt nơi Thượng Cung Cục —'),
(390003, 39, 3, 'Chương 3: Phát hiện sai sót trong sổ sách cống phẩm', '【Chương 3: Phát hiện sai sót trong sổ sách cống phẩm】 Câu chuyện của tác phẩm "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội" (tác giả: Lê Ngọc Hân, thể loại: Cung đấu, Cổ đại, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một thiếu nữ bình dân thi đỗ vào Thượng Cung Cục lo việc sổ sách lễ nghi, Mai Tuyết Lan nhờ sự thông tuệ và chính trực đã vượt qua bao sóng gió chốn cung đình để trở thành Nữ quan bậc nhất phẩm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: phát hiện sai sót trong sổ sách cống phẩm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Phát hiện sai sót trong sổ sách cống phẩm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Phát hiện sai sót trong sổ sách cống phẩm —'),
(390004, 39, 4, 'Chương 4: Bức thêu phượng hoàng mừng thọ Thái Hậu', '【Chương 4: Bức thêu phượng hoàng mừng thọ Thái Hậu】 Câu chuyện của tác phẩm "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội" (tác giả: Lê Ngọc Hân, thể loại: Cung đấu, Cổ đại, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một thiếu nữ bình dân thi đỗ vào Thượng Cung Cục lo việc sổ sách lễ nghi, Mai Tuyết Lan nhờ sự thông tuệ và chính trực đã vượt qua bao sóng gió chốn cung đình để trở thành Nữ quan bậc nhất phẩm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: bức thêu phượng hoàng mừng thọ thái hậu, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Bức thêu phượng hoàng mừng thọ Thái Hậu tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Bức thêu phượng hoàng mừng thọ Thái Hậu —'),
(390005, 39, 5, 'Chương 5: Giữ mình thanh bạch giữa cuộc chiến các phi tần', '【Chương 5: Giữ mình thanh bạch giữa cuộc chiến các phi tần】 Câu chuyện của tác phẩm "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội" (tác giả: Lê Ngọc Hân, thể loại: Cung đấu, Cổ đại, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một thiếu nữ bình dân thi đỗ vào Thượng Cung Cục lo việc sổ sách lễ nghi, Mai Tuyết Lan nhờ sự thông tuệ và chính trực đã vượt qua bao sóng gió chốn cung đình để trở thành Nữ quan bậc nhất phẩm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: giữ mình thanh bạch giữa cuộc chiến các phi tần, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Giữ mình thanh bạch giữa cuộc chiến các phi tần tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Giữ mình thanh bạch giữa cuộc chiến các phi tần —'),
(390006, 39, 6, 'Chương 6: Giải oan cho cung nữ đồng hương', '【Chương 6: Giải oan cho cung nữ đồng hương】 Câu chuyện của tác phẩm "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội" (tác giả: Lê Ngọc Hân, thể loại: Cung đấu, Cổ đại, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một thiếu nữ bình dân thi đỗ vào Thượng Cung Cục lo việc sổ sách lễ nghi, Mai Tuyết Lan nhờ sự thông tuệ và chính trực đã vượt qua bao sóng gió chốn cung đình để trở thành Nữ quan bậc nhất phẩm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: giải oan cho cung nữ đồng hương, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Giải oan cho cung nữ đồng hương tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Giải oan cho cung nữ đồng hương —'),
(390007, 39, 7, 'Chương 7: Soạn thảo điển lễ bang giao sứ thần', '【Chương 7: Soạn thảo điển lễ bang giao sứ thần】 Câu chuyện của tác phẩm "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội" (tác giả: Lê Ngọc Hân, thể loại: Cung đấu, Cổ đại, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một thiếu nữ bình dân thi đỗ vào Thượng Cung Cục lo việc sổ sách lễ nghi, Mai Tuyết Lan nhờ sự thông tuệ và chính trực đã vượt qua bao sóng gió chốn cung đình để trở thành Nữ quan bậc nhất phẩm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: soạn thảo điển lễ bang giao sứ thần, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Soạn thảo điển lễ bang giao sứ thần tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Soạn thảo điển lễ bang giao sứ thần —'),
(390008, 39, 8, 'Chương 8: Được ban lệnh bài xuất nhập Ngự Thư Phòng', '【Chương 8: Được ban lệnh bài xuất nhập Ngự Thư Phòng】 Câu chuyện của tác phẩm "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội" (tác giả: Lê Ngọc Hân, thể loại: Cung đấu, Cổ đại, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một thiếu nữ bình dân thi đỗ vào Thượng Cung Cục lo việc sổ sách lễ nghi, Mai Tuyết Lan nhờ sự thông tuệ và chính trực đã vượt qua bao sóng gió chốn cung đình để trở thành Nữ quan bậc nhất phẩm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: được ban lệnh bài xuất nhập ngự thư phòng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Được ban lệnh bài xuất nhập Ngự Thư Phòng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Được ban lệnh bài xuất nhập Ngự Thư Phòng —'),
(390009, 39, 9, 'Chương 9: Phò tá tân quân ổn định triều chính', '【Chương 9: Phò tá tân quân ổn định triều chính】 Câu chuyện của tác phẩm "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội" (tác giả: Lê Ngọc Hân, thể loại: Cung đấu, Cổ đại, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một thiếu nữ bình dân thi đỗ vào Thượng Cung Cục lo việc sổ sách lễ nghi, Mai Tuyết Lan nhờ sự thông tuệ và chính trực đã vượt qua bao sóng gió chốn cung đình để trở thành Nữ quan bậc nhất phẩm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: phò tá tân quân ổn định triều chính, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Phò tá tân quân ổn định triều chính tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Phò tá tân quân ổn định triều chính —'),
(390010, 39, 10, 'Chương 10: Bậc nữ trung hào kiệt lưu danh sử sách', '【Chương 10: Bậc nữ trung hào kiệt lưu danh sử sách】 Câu chuyện của tác phẩm "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội" (tác giả: Lê Ngọc Hân, thể loại: Cung đấu, Cổ đại, Lịch sử) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Từ một thiếu nữ bình dân thi đỗ vào Thượng Cung Cục lo việc sổ sách lễ nghi, Mai Tuyết Lan nhờ sự thông tuệ và chính trực đã vượt qua bao sóng gió chốn cung đình để trở thành Nữ quan bậc nhất phẩm.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: bậc nữ trung hào kiệt lưu danh sử sách, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Nhật Ký Hoàng Cung: Nữ Quan Đại Nội", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Bậc nữ trung hào kiệt lưu danh sử sách tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Bậc nữ trung hào kiệt lưu danh sử sách —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;

INSERT INTO public.truyen (id, title, author, cover_url, description, status, type, genres, total_chapters, rating, views, updated_at, search_text, moderation_status, owner_id) VALUES (40, 'Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không', 'Lâm Thiên Bảo', 'https://picsum.photos/seed/novelreader-v3-40/300/450', 'Sở hữu chiếc La Bàn Thời Không giúp quay ngược hai mươi bốn giờ và xuyên qua các chiều không gian phép thuật, nam sinh Minh Triết từng bước giải cứu Học viện Aether khỏi lời nguyền sụp đổ.', 'ongoing', 'light_novel', 'Xuyên không,Trọng sinh,Isekai,Kỳ ảo', 10, 4.8, 910000, 1793800000000, 'hoc vien phep thuat va chiec la ban xuyen khong lam thien bao', 'approved', '1') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, author=EXCLUDED.author, cover_url=EXCLUDED.cover_url, description=EXCLUDED.description, status=EXCLUDED.status, type=EXCLUDED.type, genres=EXCLUDED.genres, total_chapters=EXCLUDED.total_chapters, search_text=EXCLUDED.search_text, moderation_status='approved', deleted_at=NULL;
INSERT INTO public.chuong (id, novel_id, chapter_index, title, content) VALUES
(400001, 40, 1, 'Chương 1: Chiếc la bàn cổ trong phòng thí nghiệm', '【Chương 1: Chiếc la bàn cổ trong phòng thí nghiệm】 Câu chuyện của tác phẩm "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không" (tác giả: Lâm Thiên Bảo, thể loại: Xuyên không, Trọng sinh, Isekai, Kỳ ảo) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sở hữu chiếc La Bàn Thời Không giúp quay ngược hai mươi bốn giờ và xuyên qua các chiều không gian phép thuật, nam sinh Minh Triết từng bước giải cứu Học viện Aether khỏi lời nguyền sụp đổ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 1: chiếc la bàn cổ trong phòng thí nghiệm, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 1: Chiếc la bàn cổ trong phòng thí nghiệm tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 1: Chiếc la bàn cổ trong phòng thí nghiệm —'),
(400002, 40, 2, 'Chương 2: Vòng lặp hai mươi bốn giờ đầu tiên', '【Chương 2: Vòng lặp hai mươi bốn giờ đầu tiên】 Câu chuyện của tác phẩm "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không" (tác giả: Lâm Thiên Bảo, thể loại: Xuyên không, Trọng sinh, Isekai, Kỳ ảo) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sở hữu chiếc La Bàn Thời Không giúp quay ngược hai mươi bốn giờ và xuyên qua các chiều không gian phép thuật, nam sinh Minh Triết từng bước giải cứu Học viện Aether khỏi lời nguyền sụp đổ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 2: vòng lặp hai mươi bốn giờ đầu tiên, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 2: Vòng lặp hai mươi bốn giờ đầu tiên tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 2: Vòng lặp hai mươi bốn giờ đầu tiên —'),
(400003, 40, 3, 'Chương 3: Cánh cổng không gian dẫn tới tháp Aether', '【Chương 3: Cánh cổng không gian dẫn tới tháp Aether】 Câu chuyện của tác phẩm "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không" (tác giả: Lâm Thiên Bảo, thể loại: Xuyên không, Trọng sinh, Isekai, Kỳ ảo) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sở hữu chiếc La Bàn Thời Không giúp quay ngược hai mươi bốn giờ và xuyên qua các chiều không gian phép thuật, nam sinh Minh Triết từng bước giải cứu Học viện Aether khỏi lời nguyền sụp đổ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 3: cánh cổng không gian dẫn tới tháp aether, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 3: Cánh cổng không gian dẫn tới tháp Aether tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 3: Cánh cổng không gian dẫn tới tháp Aether —'),
(400004, 40, 4, 'Chương 4: Bắt tay cùng thiên tài ma pháp băng giá', '【Chương 4: Bắt tay cùng thiên tài ma pháp băng giá】 Câu chuyện của tác phẩm "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không" (tác giả: Lâm Thiên Bảo, thể loại: Xuyên không, Trọng sinh, Isekai, Kỳ ảo) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sở hữu chiếc La Bàn Thời Không giúp quay ngược hai mươi bốn giờ và xuyên qua các chiều không gian phép thuật, nam sinh Minh Triết từng bước giải cứu Học viện Aether khỏi lời nguyền sụp đổ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 4: bắt tay cùng thiên tài ma pháp băng giá, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 4: Bắt tay cùng thiên tài ma pháp băng giá tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 4: Bắt tay cùng thiên tài ma pháp băng giá —'),
(400005, 40, 5, 'Chương 5: Thay đổi kết cục buổi lễ khai giảng', '【Chương 5: Thay đổi kết cục buổi lễ khai giảng】 Câu chuyện của tác phẩm "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không" (tác giả: Lâm Thiên Bảo, thể loại: Xuyên không, Trọng sinh, Isekai, Kỳ ảo) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sở hữu chiếc La Bàn Thời Không giúp quay ngược hai mươi bốn giờ và xuyên qua các chiều không gian phép thuật, nam sinh Minh Triết từng bước giải cứu Học viện Aether khỏi lời nguyền sụp đổ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 5: thay đổi kết cục buổi lễ khai giảng, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 5: Thay đổi kết cục buổi lễ khai giảng tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 5: Thay đổi kết cục buổi lễ khai giảng —'),
(400006, 40, 6, 'Chương 6: Bí mật của bảy mảnh tinh thạch', '【Chương 6: Bí mật của bảy mảnh tinh thạch】 Câu chuyện của tác phẩm "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không" (tác giả: Lâm Thiên Bảo, thể loại: Xuyên không, Trọng sinh, Isekai, Kỳ ảo) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sở hữu chiếc La Bàn Thời Không giúp quay ngược hai mươi bốn giờ và xuyên qua các chiều không gian phép thuật, nam sinh Minh Triết từng bước giải cứu Học viện Aether khỏi lời nguyền sụp đổ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 6: bí mật của bảy mảnh tinh thạch, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 6: Bí mật của bảy mảnh tinh thạch tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 6: Bí mật của bảy mảnh tinh thạch —'),
(400007, 40, 7, 'Chương 7: Du hành về kỷ nguyên sáng lập học viện', '【Chương 7: Du hành về kỷ nguyên sáng lập học viện】 Câu chuyện của tác phẩm "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không" (tác giả: Lâm Thiên Bảo, thể loại: Xuyên không, Trọng sinh, Isekai, Kỳ ảo) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sở hữu chiếc La Bàn Thời Không giúp quay ngược hai mươi bốn giờ và xuyên qua các chiều không gian phép thuật, nam sinh Minh Triết từng bước giải cứu Học viện Aether khỏi lời nguyền sụp đổ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 7: du hành về kỷ nguyên sáng lập học viện, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 7: Du hành về kỷ nguyên sáng lập học viện tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 7: Du hành về kỷ nguyên sáng lập học viện —'),
(400008, 40, 8, 'Chương 8: Phá giải phong ấn Ma đạo sư bóng tối', '【Chương 8: Phá giải phong ấn Ma đạo sư bóng tối】 Câu chuyện của tác phẩm "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không" (tác giả: Lâm Thiên Bảo, thể loại: Xuyên không, Trọng sinh, Isekai, Kỳ ảo) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sở hữu chiếc La Bàn Thời Không giúp quay ngược hai mươi bốn giờ và xuyên qua các chiều không gian phép thuật, nam sinh Minh Triết từng bước giải cứu Học viện Aether khỏi lời nguyền sụp đổ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 8: phá giải phong ấn ma đạo sư bóng tối, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 8: Phá giải phong ấn Ma đạo sư bóng tối tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 8: Phá giải phong ấn Ma đạo sư bóng tối —'),
(400009, 40, 9, 'Chương 9: Chập trùng hai dòng thời gian', '【Chương 9: Chập trùng hai dòng thời gian】 Câu chuyện của tác phẩm "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không" (tác giả: Lâm Thiên Bảo, thể loại: Xuyên không, Trọng sinh, Isekai, Kỳ ảo) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sở hữu chiếc La Bàn Thời Không giúp quay ngược hai mươi bốn giờ và xuyên qua các chiều không gian phép thuật, nam sinh Minh Triết từng bước giải cứu Học viện Aether khỏi lời nguyền sụp đổ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 9: chập trùng hai dòng thời gian, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 9: Chập trùng hai dòng thời gian tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 9: Chập trùng hai dòng thời gian —'),
(400010, 40, 10, 'Chương 10: Bình minh mới của Học viện Aether', '【Chương 10: Bình minh mới của Học viện Aether】 Câu chuyện của tác phẩm "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không" (tác giả: Lâm Thiên Bảo, thể loại: Xuyên không, Trọng sinh, Isekai, Kỳ ảo) bước sang một diễn biến quan trọng khi những manh mối và nhân duyên bắt đầu hội tụ.

Sở hữu chiếc La Bàn Thời Không giúp quay ngược hai mươi bốn giờ và xuyên qua các chiều không gian phép thuật, nam sinh Minh Triết từng bước giải cứu Học viện Aether khỏi lời nguyền sụp đổ.

Bầu trời phía chân trời dần ửng sáng, những tia nắng đầu tiên xuyên qua tầng sương mỏng chiếu xuống con đường dài phía trước. Trong bối cảnh của chương 10: bình minh mới của học viện aether, từng nhân vật đều mang trong lòng một quyết tâm riêng biệt, sẵn sàng đối mặt với thử thách mới.

Cuộc đối thoại kéo dài bên ánh đèn ấm áp. Từng chi tiết tưởng chừng nhỏ nhặt từ những ngày tháng trước nay bỗng kết nối lại thành một bức tranh hoàn chỉnh, hé lộ nguyên nhân sâu xa đằng sau chuỗi sự kiện vừa qua.

Đôi khi chỉ một lựa chọn dứt khoát đúng thời điểm cũng đủ làm xoay chuyển toàn bộ cục diện. Chính vì vậy, mỗi bước đi lúc này đều đòi hỏi sự điềm tĩnh, trí tuệ sắc bén và lòng kiên định không lay chuyển.

Không gian xung quanh lắng đọng trong khoảnh khắc. Tiếng gió thổi qua hàng cây xào xạc hòa cùng nhịp bước chân vững vàng, tạo nên một bầu không khí vừa trang nghiêm vừa tràn đầy hy vọng.

Nhìn lại chặng đường đã đi qua từ đầu bộ truyện "Học Viện Phép Thuật Và Chiếc La Bàn Xuyên Không", những khó khăn ban đầu không hề làm chùn bước người trong cuộc mà trái lại càng tôi luyện bản lĩnh thêm vững vàng.

Khi diễn biến của Chương 10: Bình minh mới của Học viện Aether tiến dần đến cao trào, nút thắt quan trọng nhất trong chương đã được tháo gỡ một cách thuyết phục, đồng thời mở ra cánh cửa dẫn tới hành trình hấp dẫn ở chương kế tiếp.

— Hết Chương 10: Bình minh mới của Học viện Aether —')
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, content=EXCLUDED.content;
