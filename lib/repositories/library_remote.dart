import '../models/library_item.dart';

abstract interface class LibraryRemote {
  Future<List<LibraryItem>> getLibrary({String? userId});
  Future<void> upsertLibrary(LibraryItem item, {String? userId});
  Future<void> removeFromLibrary(int novelId, {String? userId});
}
