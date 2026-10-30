import 'dart:convert';

/// Một chương truyện. [content] chỉ có giá trị khi chương đã được tải về
/// (hoặc vừa được lấy từ nguồn dữ liệu để đọc online).
class Chapter {
  final int id;
  final int novelId;
  final int chapterIndex;
  final String title;
  final String? content;
  final bool isDownloaded;

  const Chapter({
    required this.id,
    required this.novelId,
    required this.chapterIndex,
    required this.title,
    this.content,
    this.isDownloaded = false,
  });

  /// Dung lượng nội dung (byte, mã hóa UTF-8).
  int get sizeInBytes =>
      content == null ? 0 : utf8.encode(content!).length;

  Map<String, Object?> toMap() => {
        'id': id,
        'novel_id': novelId,
        'chapter_index': chapterIndex,
        'title': title,
        'content': content,
        'is_downloaded': isDownloaded ? 1 : 0,
      };

  factory Chapter.fromMap(Map<String, Object?> map) => Chapter(
        id: map['id'] as int,
        novelId: map['novel_id'] as int,
        chapterIndex: map['chapter_index'] as int,
        title: (map['title'] as String?) ?? '',
        content: map['content'] as String?,
        isDownloaded: (map['is_downloaded'] as int?) == 1,
      );

  /// [clearContent] = true để xóa nội dung (vì copyWith không thể gán null).
  Chapter copyWith({
    int? id,
    int? novelId,
    int? chapterIndex,
    String? title,
    String? content,
    bool? isDownloaded,
    bool clearContent = false,
  }) {
    return Chapter(
      id: id ?? this.id,
      novelId: novelId ?? this.novelId,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      title: title ?? this.title,
      content: clearContent ? null : (content ?? this.content),
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Chapter &&
      other.id == id &&
      other.isDownloaded == isDownloaded;

  @override
  int get hashCode => Object.hash(id, isDownloaded);
}

/// Thông tin một chương đã tải, dùng cho màn hình Tải xuống.
class DownloadedChapter {
  final Chapter chapter;
  final String novelTitle;
  final String coverUrl;

  /// Dung lượng nội dung đã lưu (byte).
  final int sizeInBytes;

  const DownloadedChapter({
    required this.chapter,
    required this.novelTitle,
    required this.coverUrl,
    required this.sizeInBytes,
  });

  factory DownloadedChapter.fromMap(Map<String, Object?> map) =>
      DownloadedChapter(
        chapter: Chapter.fromMap(map),
        novelTitle: (map['novel_title'] as String?) ?? '',
        coverUrl: (map['cover_url'] as String?) ?? '',
        sizeInBytes: (map['size'] as int?) ?? 0,
      );
}
