import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';

class TtsApiKeyDialog extends StatefulWidget {
  const TtsApiKeyDialog({super.key});
  @override
  State<TtsApiKeyDialog> createState() => _TtsApiKeyDialogState();
}

class _TtsApiKeyDialogState extends State<TtsApiKeyDialog> {
  late final _key = TextEditingController(
    text: context.read<SettingsProvider>().geminiApiKey,
  );
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final value = _key.text.trim();
    if (value.isEmpty) {
      setState(() => _error = 'Vui lòng nhập khóa Gemini.');
      return;
    }
    final settings = context.read<SettingsProvider>();
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await settings.setGeminiApiKey(value);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Chưa lưu được khóa. Vui lòng thử lại.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Khóa giọng AI'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Nhập khóa Gemini còn hạn mức để nghe giọng AI. Khóa này cũng dùng cho Trợ lý AI trong app.',
        ),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey('tts-api-key'),
          controller: _key,
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          enabled: !_saving,
          decoration: InputDecoration(
            labelText: 'Gemini API Key',
            errorText: _error,
          ),
          onSubmitted: (_) => _save(),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.pop(context),
        child: const Text('Hủy'),
      ),
      FilledButton(
        onPressed: _saving ? null : _save,
        child: Text(_saving ? 'Đang lưu…' : 'Lưu khóa'),
      ),
    ],
  );
}
