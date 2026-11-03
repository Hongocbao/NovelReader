import 'package:flutter/material.dart';

import '../../models/ai_chat_message.dart';
import '../../models/chapter.dart';
import '../../models/novel.dart';
import '../../services/ai_reader_service.dart';

/// Bong bóng chat AI nổi (Draggable Floating Chat Bubble) cho màn hình đọc truyện.
class AiChatBubble extends StatefulWidget {
  final Novel novel;
  final Chapter? chapter;
  final String? chapterContent;

  const AiChatBubble({
    super.key,
    required this.novel,
    required this.chapter,
    required this.chapterContent,
  });

  @override
  State<AiChatBubble> createState() => _AiChatBubbleState();
}

class _AiChatBubbleState extends State<AiChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Tọa độ vị trí bong bóng trên màn hình (mặc định dưới cùng bên phải)
  Offset? _position;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _openChatSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AiReaderChatSheet(
        novel: widget.novel,
        chapter: widget.chapter,
        chapterContent: widget.chapterContent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Khởi tạo vị trí mặc định nếu chưa kéo: góc dưới phải, cách cạnh 16px, cách đáy 90px
    _position ??= Offset(
      screenSize.width - 68,
      screenSize.height - 150,
    );

    // Giới hạn trong vùng màn hình an toàn
    final clampedX = _position!.dx.clamp(12.0, screenSize.width - 68.0);
    final clampedY = _position!.dy.clamp(60.0, screenSize.height - 110.0);

    return Positioned(
      left: clampedX,
      top: clampedY,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position = Offset(
              clampedX + details.delta.dx,
              clampedY + details.delta.dy,
            );
          });
        },
        child: ScaleTransition(
          scale: _pulseAnimation,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openChatSheet(context),
              borderRadius: BorderRadius.circular(28),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.45),
                      blurRadius: 14,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.smart_toy_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.5,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: const Text(
                          'AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Giao diện bảng điều khiển Chat với Trợ Lý AI Độc Giả.
class AiReaderChatSheet extends StatefulWidget {
  final Novel novel;
  final Chapter? chapter;
  final String? chapterContent;

  const AiReaderChatSheet({
    super.key,
    required this.novel,
    required this.chapter,
    required this.chapterContent,
  });

  @override
  State<AiReaderChatSheet> createState() => _AiReaderChatSheetState();
}

class _AiReaderChatSheetState extends State<AiReaderChatSheet> {
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final List<AiChatMessage> _messages = [];
  bool _isReplying = false;

  @override
  void initState() {
    super.initState();
    _initWelcomeMessage();
  }

  void _initWelcomeMessage() {
    final chTitle = widget.chapter?.title ?? 'Chương hiện tại';
    _messages.add(
      AiChatMessage.ai(
        'Xin chào bạn! Mình là **Trợ lý AI Độc Giả** 🤖📖✨.\n\n'
        'Mình đang đồng hành cùng bạn khi đọc bộ truyện **"${widget.novel.title}"** (đặc biệt là tại *$chTitle*).\n\n'
        'Bạn có thể hỏi mình tóm tắt chương, giải thích nhân vật, dự đoán diễn biến hoặc bất kỳ điều gì nhé!',
        suggestions: AiReaderService.defaultSuggestions,
      ),
    );
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend([String? presetText]) async {
    final text = (presetText ?? _inputCtrl.text).trim();
    if (text.isEmpty || _isReplying) return;

    if (presetText == null) {
      _inputCtrl.clear();
    }

    setState(() {
      _messages.add(AiChatMessage.user(text));
      _isReplying = true;
    });
    _scrollToBottom();

    try {
      final reply = await AiReaderService.instance.generateReply(
        prompt: text,
        novel: widget.novel,
        chapter: widget.chapter,
        chapterContent: widget.chapterContent,
        history: _messages,
      );

      if (mounted) {
        setState(() {
          _messages.add(reply);
          _isReplying = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            AiChatMessage.ai('⚠️ Rất tiếc, đã có lỗi nhỏ xảy ra: $e'),
          );
          _isReplying = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _resetChat() {
    setState(() {
      _messages.clear();
      _initWelcomeMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final sheetBg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final chTitle = widget.chapter?.title ?? 'Đang đọc';

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Thanh kéo trên cùng
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Trợ Lý AI Độc Giả',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Smart RAG',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${widget.novel.title} • $chTitle',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Làm mới cuộc trò chuyện',
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  onPressed: _resetChat,
                ),
                IconButton(
                  tooltip: 'Đóng',
                  icon: const Icon(Icons.close_rounded, size: 22),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Quick Suggestion Chips (Gợi ý câu hỏi nhanh)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: AiReaderService.defaultSuggestions.map((s) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(s, style: const TextStyle(fontSize: 12.5)),
                      backgroundColor: isDark
                          ? const Color(0xFF2E2E3E)
                          : const Color(0xFFF1F5F9),
                      side: BorderSide(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onPressed: () => _handleSend(s),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const Divider(height: 1),

          // Danh sách tin nhắn Chat
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageItem(msg, colorScheme, isDark);
              },
            ),
          ),

          // Typing Indicator khi AI đang phản hồi
          if (_isReplying)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      size: 16,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI đang đọc hiểu chương truyện...',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ),
            ),

          // Ô nhập tin nhắn
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              decoration: BoxDecoration(
                color: sheetBg,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2A2A3C)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                        ),
                      ),
                      child: TextField(
                        controller: _inputCtrl,
                        maxLines: 4,
                        minLines: 1,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _handleSend(),
                        decoration: const InputDecoration(
                          hintText: 'Hỏi AI về tình tiết, nhân vật chương này...',
                          hintStyle: TextStyle(fontSize: 13.5),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      tooltip: 'Gửi câu hỏi',
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => _handleSend(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(
    AiChatMessage msg,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 48),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            msg.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      );
    }

    // Tin nhắn từ AI
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 36),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF28283C)
                          : const Color(0xFFF8FAFC),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.06),
                      ),
                    ),
                    child: SelectableText(
                      msg.content,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  if (msg.suggestions.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: msg.suggestions.map((s) {
                        return InkWell(
                          onTap: () => _handleSend(s),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                              ),
                            ),
                            child: Text(
                              s,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF8B5CF6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
