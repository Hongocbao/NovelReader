import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthorDraft {
  static const defaultChapterTitle = 'Chương 1: Khởi đầu mới';
  const AuthorDraft({
    this.title = '',
    this.description = '',
    this.chapterTitle = defaultChapterTitle,
    this.content = '',
    this.requestId = '',
  });
  final String title;
  final String description;
  final String chapterTitle;
  final String content;
  final String requestId;
  bool get isEmpty =>
      title.isEmpty &&
      description.isEmpty &&
      content.isEmpty &&
      (chapterTitle.isEmpty || chapterTitle == defaultChapterTitle);
  Map<String, Object?> toMap() => {
    'v': 1,
    'title': title,
    'description': description,
    'chapter_title': chapterTitle,
    'content': content,
    'request_id': requestId,
  };
  @override
  bool operator ==(Object other) =>
      other is AuthorDraft &&
      title == other.title &&
      description == other.description &&
      chapterTitle == other.chapterTitle &&
      content == other.content &&
      requestId == other.requestId;
  @override
  int get hashCode =>
      Object.hash(title, description, chapterTitle, content, requestId);
}

/// One JSON value keeps the content and its retry key in the same saved version.
/// Serialize saves/clears across reopened screens sharing the same preferences.
class AuthorDraftStore {
  AuthorDraftStore(this.prefs);
  final SharedPreferences prefs;
  static final _tails = <(SharedPreferences, String), Future<void>>{};
  static String keyFor(String userId) => 'author_draft_v2_$userId';

  AuthorDraft load(String userId) {
    if (userId.isEmpty) return const AuthorDraft();
    final raw = prefs.getString(keyFor(userId));
    if (raw != null) {
      final data = jsonDecode(raw);
      if (data is! Map || data['v'] != 1) {
        throw const FormatException('Bản nháp chưa đọc được.');
      }
      String value(String key) =>
          data[key] is String ? data[key] as String : '';
      return AuthorDraft(
        title: value('title'),
        description: value('description'),
        chapterTitle: value('chapter_title'),
        content: value('content'),
        requestId: value('request_id'),
      );
    }
    String legacy(String field, [String fallback = '']) =>
        prefs.getString('author_draft_${field}_$userId') ?? fallback;
    return AuthorDraft(
      title: legacy('title'),
      description: legacy('description'),
      chapterTitle: legacy('chapter_title', AuthorDraft.defaultChapterTitle),
      content: legacy('content'),
      requestId: legacy('request_id'),
    );
  }

  Future<T> _serialize<T>(String userId, Future<T> Function() action) async {
    if (userId.isEmpty) throw ArgumentError('Cần tài khoản để lưu bản nháp.');
    final key = (prefs, userId);
    final previous = _tails[key];
    final done = Completer<void>();
    _tails[key] = done.future;
    await previous;
    try {
      return await action();
    } finally {
      done.complete();
      if (identical(_tails[key], done.future)) _tails.remove(key);
    }
  }

  Future<void> _write(String userId, AuthorDraft draft) async {
    if (!await prefs.setString(keyFor(userId), jsonEncode(draft.toMap()))) {
      throw StateError('Không lưu được bản nháp trên thiết bị.');
    }
  }

  Future<void> save(String userId, AuthorDraft draft) =>
      _serialize(userId, () => _write(userId, draft));
  Future<bool> clearIfMatches(
    String userId,
    AuthorDraft submitted,
  ) => _serialize(userId, () async {
    if (load(userId) != submitted) return false;
    // Keep an empty record so legacy fields cannot resurrect a submitted draft.
    await _write(userId, const AuthorDraft());
    return true;
  });
}
