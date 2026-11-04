import '../models/bookmark.dart';

abstract interface class BookmarkRemote {
  Future<List<Bookmark>> getBookmarks(int novelId, {String? userId});
  Future<int> addBookmark(Bookmark bookmark, {String? userId});
  Future<void> deleteBookmark(int id, {String? userId});
}
