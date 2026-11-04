import '../models/chapter_summary.dart';
import '../models/glossary_term.dart';

class ReaderExtrasPage<T> {
  ReaderExtrasPage(Iterable<T> items, {this.fromCache = false})
    : items = List<T>.unmodifiable(items);
  final List<T> items;
  final bool fromCache;
}

abstract interface class ReaderExtrasSource {
  Future<ReaderExtrasPage<GlossaryTerm>> getGlossaryForReader(
    int novelId,
    int chapterIndex, {
    int version = 0,
    bool offline = false,
  });
  Future<ReaderExtrasPage<ChapterSummary>> getSummariesForReader(
    int novelId,
    int chapterIndex, {
    int version = 0,
    bool offline = false,
  });
}

abstract interface class ReaderExtrasRemote {
  String get extrasUserId;
  Future<List<GlossaryTerm>> getReaderGlossary(int novelId, int chapterIndex);
  Future<List<ChapterSummary>> getReaderSummaries(
    int novelId,
    int chapterIndex,
  );
}
