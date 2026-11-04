import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/ai_chat_message.dart';
import '../../models/chapter.dart';
import '../../models/novel.dart';
import '../../providers/settings_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/ai_reader_service.dart';

/// Bong bóng chat AI nổi (Draggable Floating Chat Bubble) cho màn hình đọc truyện.
class AiChatBubble extends StatefulWidget {
  final Novel? novel;
  final Chapter? chapter;
  final String? chapterContent;
  final AiReaderService? service;

  const AiChatBubble({
    super.key,
    this.novel,
    this.chapter,
    this.chapterContent,
    this.service,
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
    );
    _pulseController.forward().then((_) {
      if (mounted) _pulseController.reverse();
    });

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
        service: widget.service,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxX = math.max(0.0, constraints.maxWidth - 68);
        final maxY = math.max(0.0, constraints.maxHeight - 76);
        final minX = math.min(12.0, maxX);
        final minY = math.min(12.0, maxY);
        _position ??= Offset(maxX, maxY);
        final clampedX = _position!.dx.clamp(minX, maxX);
        final clampedY = _position!.dy.clamp(minY, maxY);
        return Stack(
          children: [
            Positioned(
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
                            colors: [
                              Color(0xFF6366F1),
                              Color(0xFF8B5CF6),
                              Color(0xFFEC4899),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6)
                                  .withValues(alpha: 0.45),
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
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
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
            ),
          ],
        );
      },
    );
  }
}

/// Giao diện bảng điều khiển Chat với Trợ Lý AI Độc Giả.
class AiReaderChatSheet extends StatefulWidget {
  final Novel? novel;
  final Chapter? chapter;
  final String? chapterContent;
  final AiReaderService? service;

  const AiReaderChatSheet({
    super.key,
    this.novel,
    this.chapter,
    this.chapterContent,
    this.service,
  });

  @override
  State<AiReaderChatSheet> createState() => _AiReaderChatSheetState();
}

class _AiReaderChatSheetState extends State<AiReaderChatSheet> {
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final List<AiChatMessage> _messages = [];
  bool _isReplying = false;
  int _request = 0;
  String _owner = 'guest';
  AiReaderService get _service => widget.service ?? AiReaderService.instance;
  int get _scope => widget.novel?.id ?? 0;
  List<String> get _suggestions => widget.novel == null
      ? AiReaderService.generalSuggestions
      : AiReaderService.defaultSuggestions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final owner =
        Provider.of<AuthProvider?>(context)?.currentUser.id ?? 'guest';
    if (_messages.isNotEmpty && _owner == owner) return;
    _owner = owner;
    _request++;
    _isReplying = false;
    _messages.clear();
    _inputCtrl.clear();
    final saved = _service.getHistory(_scope, owner: _owner);
    if (saved.isNotEmpty) {
      _messages.addAll(saved);
    } else {
      _initWelcomeMessage();
    }
  }

  void _initWelcomeMessage() {
    final novel = widget.novel;
    _messages.add(
      AiChatMessage.ai(
        novel == null
            ? 'Xin chào! Mình là **trợ lý AI NovelReader**. Bạn có thể hỏi về học tập, '
                  'công nghệ, dịch thuật, viết nội dung hoặc trò chuyện về truyện.\n\nBạn cần mình giúp gì?'
            : 'Mình có thể hỗ trợ bạn đọc **${novel.title}**, '
                  'chương **${widget.chapter?.title ?? "hiện tại"}**, '
                  'và trả lời cả những câu hỏi ngoài truyện. Bạn muốn hỏi gì?',
        includeInContext: false,
      ),
    );
  }

  @override
  void dispose() {
    _request++;
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          0,
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

    final request = ++_request;
    setState(() {
      _messages.add(AiChatMessage.user(text));
      _isReplying = true;
    });
    _service.saveHistory(_scope, _messages, owner: _owner);
    _scrollToBottom();

    SettingsProvider? settingsProv;
    try {
      settingsProv = context.read<SettingsProvider>();
    } catch (_) {}

    try {
      final reply = await _service.generateReply(
        prompt: text,
        novel: widget.novel,
        chapter: widget.chapter,
        chapterContent: widget.chapterContent,
        history: List.of(_messages),
        geminiApiKey: settingsProv?.geminiApiKey,
      );

      if (mounted && request == _request) {
        setState(() {
          _messages.add(reply);
          _isReplying = false;
        });
        _service.saveHistory(_scope, _messages, owner: _owner);
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted && request == _request) {
        setState(() {
          _messages.add(
            AiChatMessage.ai(
              'Chưa kết nối được AI. Bạn hãy thử lại.',
              isError: true,
              includeInContext: false,
            ),
          );
          _isReplying = false;
        });
        _service.saveHistory(_scope, _messages, owner: _owner);
        _scrollToBottom();
      }
    }
  }

  void _resetChat() {
    _request++;
    _service.clearHistory(_scope, owner: _owner);
    setState(() {
      _messages.clear();
      _isReplying = false;
      _initWelcomeMessage();
    });
    _service.saveHistory(_scope, _messages, owner: _owner);
  }

  void _retry() {
    if (_isReplying || _messages.length < 2 || !_messages.last.isError) return;
    _messages.removeLast();
    if (!_messages.last.isUser) return;
    final question = _messages.removeLast().content;
    _handleSend(question);
  }

  Future<void> _showApiKeyDialog() async {
    SettingsProvider? settingsProv;
    try {
      settingsProv = context.read<SettingsProvider>();
    } catch (_) {}
    if (settingsProv == null) return;

    final saved = await showDialog<String>(
      context: context,
      builder: (_) =>
          _GeminiApiKeyDialog(initialKey: settingsProv!.geminiApiKey),
    );
    if (saved != null && mounted) {
      await settingsProv.setGeminiApiKey(saved);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            saved.isEmpty
                ? 'Đã xóa khóa. Hỏi đáp tự do cần khóa Gemini để kết nối.'
                : 'Đã lưu Gemini API Key thành công!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final sheetBg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final chTitle = widget.chapter?.title ?? 'Hỏi đáp tự do';

    // Khi bàn phím bật lên, đẩy sheet lên trên và thu nhỏ chiều cao
    // để ô nhập không bị bàn phím che mất.
    final media = MediaQuery.of(context);
    final keyboard = media.viewInsets.bottom;
    final maxHeight = math.max(
      0.0,
      media.size.height - keyboard - media.padding.top - 16,
    );
    final sheetHeight = math.min(media.size.height * 0.85, maxHeight);
    final compact = sheetHeight < 320;

    return Container(
      height: sheetHeight,
      margin: EdgeInsets.only(bottom: keyboard),
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
                      Text(
                        widget.novel == null
                            ? 'Trợ lý AI NovelReader'
                            : 'Trợ Lý AI Độc Giả',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.novel == null
                            ? 'Hỏi đáp tự do • Gemini'
                            : '${widget.novel!.title} • $chTitle',
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
                  tooltip: 'Cấu hình Gemini API Key',
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 40,
                  ),
                  padding: const EdgeInsets.all(6),
                  icon: const Icon(Icons.vpn_key_rounded, size: 20),
                  onPressed: _showApiKeyDialog,
                ),
                IconButton(
                  tooltip: 'Làm mới cuộc trò chuyện',
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 40,
                  ),
                  padding: const EdgeInsets.all(6),
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  onPressed: _resetChat,
                ),
                IconButton(
                  tooltip: 'Đóng',
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 40,
                  ),
                  padding: const EdgeInsets.all(6),
                  icon: const Icon(Icons.close_rounded, size: 22),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Quick Suggestion Chips (Gợi ý câu hỏi nhanh)
          if (!compact)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: _suggestions.map((s) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(s, style: const TextStyle(fontSize: 12.5)),
                        backgroundColor: isDark
                            ? const Color(0xFF2E2E3E)
                            : const Color(0xFFF1F5F9),
                        side: BorderSide(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
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
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[_messages.length - 1 - index];
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
                    'AI đang trả lời…',
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
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: _inputCtrl,
                        maxLines: compact ? 1 : 3,
                        maxLength: 16000,
                        minLines: 1,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _handleSend(),
                        decoration: const InputDecoration(
                          hintText: 'Nhập câu hỏi cho AI…',
                          counterText: '',
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
                      onPressed: _isReplying ? null : () => _handleSend(),
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
                    child: _buildMarkdownRichText(
                      msg.content,
                      TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  if (msg.isError && identical(msg, _messages.last))
                    TextButton.icon(
                      onPressed: _isReplying ? null : _retry,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Thử lại'),
                    ),
                  if (!msg.isError && msg.includeInContext)
                    TextButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: msg.content),
                        );
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã sao chép câu trả lời'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 15),
                      label: const Text('Sao chép'),
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
                              color: const Color(0xFF8B5CF6)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF8B5CF6)
                                    .withValues(alpha: 0.25),
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

  Widget _buildMarkdownRichText(String raw, TextStyle baseStyle) {
    final spans = <InlineSpan>[];
    final pattern = RegExp(r'\*\*(.+?)\*\*|\*(.+?)\*', dotAll: true);
    var lastEnd = 0;
    for (final match in pattern.allMatches(raw)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: raw.substring(lastEnd, match.start)));
      }
      final boldText = match.group(1);
      final italicText = match.group(2);
      if (boldText != null) {
        spans.add(
          TextSpan(
            text: boldText,
            style: baseStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        );
      } else if (italicText != null) {
        spans.add(
          TextSpan(
            text: italicText,
            style: baseStyle.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      }
      lastEnd = match.end;
    }
    if (lastEnd < raw.length) {
      spans.add(TextSpan(text: raw.substring(lastEnd)));
    }
    return SelectableText.rich(TextSpan(style: baseStyle, children: spans));
  }
}

class _GeminiApiKeyDialog extends StatefulWidget {
  final String initialKey;

  const _GeminiApiKeyDialog({required this.initialKey});

  @override
  State<_GeminiApiKeyDialog> createState() => _GeminiApiKeyDialogState();
}

class _GeminiApiKeyDialogState extends State<_GeminiApiKeyDialog> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialKey);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.vpn_key_rounded, color: Color(0xFF8B5CF6)),
          SizedBox(width: 8),
          Expanded(child: Text('Cấu hình Gemini API Key')),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dùng khóa Google AI Studio hoặc Vertex Express để hỏi đáp với Gemini. '
            'Khóa Vertex Express cần bật Vertex AI API trong dự án Google Cloud. '
            'Nếu chưa có khóa, chỉ dùng được phân tích truyện cục bộ.',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ctrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Gemini API Key',
              hintText: 'AIzaSy... hoặc AQ....',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (v) => Navigator.pop(context, v.trim()),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _ctrl.text.trim()),
          child: const Text('Lưu Key'),
        ),
      ],
    );
  }
}
