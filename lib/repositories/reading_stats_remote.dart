import '../models/reading_history.dart';

abstract interface class ReadingStatsRemote {
  Future<bool> recordReadingSession({
    required int wordsRead,
    required int minutesRead,
    String? userId,
    int novelId = 0,
    int chapterId = 0,
  });
  Future<List<ReadingSessionStat>> getReadingSessions({String? userId});
}
