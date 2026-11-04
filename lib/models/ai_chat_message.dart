import 'package:flutter/foundation.dart';

/// Đại diện cho một tin nhắn trong phiên hội thoại với Trợ lý AI Đọc Truyện.
@immutable
class AiChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final List<String> suggestions;
  final bool isError;
  final bool includeInContext;

  const AiChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.suggestions = const [],
    this.isError = false,
    this.includeInContext = true,
  });

  factory AiChatMessage.user(String text) {
    return AiChatMessage(
      id: 'user_${DateTime.now().microsecondsSinceEpoch}',
      content: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
  }

  factory AiChatMessage.ai(
    String text, {
    List<String> suggestions = const [],
    bool isError = false,
    bool includeInContext = true,
  }) {
    return AiChatMessage(
      id: 'ai_${DateTime.now().microsecondsSinceEpoch}',
      content: text.trim(),
      isUser: false,
      timestamp: DateTime.now(),
      suggestions: suggestions,
      isError: isError,
      includeInContext: includeInContext,
    );
  }
}
