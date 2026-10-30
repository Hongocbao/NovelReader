import '../utils/constants.dart';

/// Kiểu sắp xếp danh sách truyện.
enum NovelSort {
  /// Mới cập nhật trước.
  updated,

  /// Lượt đọc cao trước (truyện hot).
  views,

  /// Đánh giá cao trước.
  rating,

  /// Theo tên A-Z.
  title,
}

/// Thông tin một bộ truyện (truyện chữ hoặc Light Novel).
class Novel {
  final int id;
  final String title;
  final String author;
  final String coverUrl;
  final String description;

  /// ongoing | completed
  final String status;

  /// novel | light_novel
  final String type;
  final List<String> genres;
  final int totalChapters;
  final double rating;
  final int views;
  final DateTime updatedAt;

  const Novel({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.description,
    required this.status,
    required this.type,
    required this.genres,
    required this.totalChapters,
    required this.rating,
    required this.views,
    required this.updatedAt,
  });

  bool get isCompleted => status == NovelStatus.completed;
  bool get isLightNovel => type == NovelType.lightNovel;
  bool get isComic => type == NovelType.comic;

  /// Chuyển sang Map để lưu SQLite (genres nối bằng dấu phẩy).
  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'author': author,
        'cover_url': coverUrl,
        'description': description,
        'status': status,
        'type': type,
        'genres': genres.join(','),
        'total_chapters': totalChapters,
        'rating': rating,
        'views': views,
        'updated_at': updatedAt.millisecondsSinceEpoch,
      };

  /// Tạo từ một dòng SQLite.
  factory Novel.fromMap(Map<String, Object?> map) {
    final rawGenres = (map['genres'] as String?) ?? '';
    return Novel(
      id: map['id'] as int,
      title: (map['title'] as String?) ?? '',
      author: (map['author'] as String?) ?? '',
      coverUrl: (map['cover_url'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      status: (map['status'] as String?) ?? NovelStatus.ongoing,
      type: (map['type'] as String?) ?? NovelType.novel,
      genres: rawGenres
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      totalChapters: (map['total_chapters'] as int?) ?? 0,
      rating: ((map['rating'] as num?) ?? 0).toDouble(),
      views: (map['views'] as int?) ?? 0,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
          (map['updated_at'] as int?) ?? 0),
    );
  }

  Novel copyWith({
    int? id,
    String? title,
    String? author,
    String? coverUrl,
    String? description,
    String? status,
    String? type,
    List<String>? genres,
    int? totalChapters,
    double? rating,
    int? views,
    DateTime? updatedAt,
  }) {
    return Novel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      coverUrl: coverUrl ?? this.coverUrl,
      description: description ?? this.description,
      status: status ?? this.status,
      type: type ?? this.type,
      genres: genres ?? this.genres,
      totalChapters: totalChapters ?? this.totalChapters,
      rating: rating ?? this.rating,
      views: views ?? this.views,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => other is Novel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
