import '../models/reading_history.dart';

/// Các thao tác lịch sử trên máy chủ, tách riêng để kiểm tra khi mất mạng.
abstract interface class ReadingHistoryRemote {
  Future<List<ReadingHistory>> getHistory({String? userId});
  Future<ReadingHistory?> getHistoryFor(int novelId, {String? userId});
  Future<void> saveHistories(List<ReadingHistory> histories, {String? userId});
  Future<void> deleteHistory(int novelId, {String? userId});
  Future<void> clearHistory({String? userId});
}
