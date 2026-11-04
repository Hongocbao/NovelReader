import '../models/bookmark.dart';

abstract interface class QuoteRemote {
  Future<List<QuoteItem>> getQuotes({String? userId});
  Future<int> addQuote(QuoteItem quote, {String? userId});
  Future<void> deleteQuote(int id, {String? userId});
}
