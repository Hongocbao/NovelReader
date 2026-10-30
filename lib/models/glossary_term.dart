/// Thuật ngữ giải nghĩa theo từng bộ truyện (chống spoil bằng [firstChapterIndex]).
class GlossaryTerm {
  final int? id;
  final int novelId;
  final String term;
  final String meaning;
  final int firstChapterIndex;

  const GlossaryTerm({
    this.id,
    required this.novelId,
    required this.term,
    required this.meaning,
    this.firstChapterIndex = 1,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'novel_id': novelId,
        'term': term,
        'meaning': meaning,
        'first_chapter_index': firstChapterIndex,
      };

  factory GlossaryTerm.fromMap(Map<String, Object?> map) => GlossaryTerm(
        id: map['id'] as int?,
        novelId: (map['novel_id'] as int?) ?? 0,
        term: (map['term'] as String?) ?? '',
        meaning: (map['meaning'] as String?) ?? '',
        firstChapterIndex: (map['first_chapter_index'] as int?) ?? 1,
      );
}
