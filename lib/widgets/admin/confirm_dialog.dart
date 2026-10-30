import 'package:flutter/material.dart';

/// Hộp thoại xác nhận thao tác quản trị quan trọng.
/// Hỗ trợ bắt buộc gõ lại chuỗi xác nhận [requireTypeMatch] (ví dụ tên truyện khi xóa).
class AdminConfirmDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String? requireTypeMatch;
  final bool isDestructive;

  const AdminConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Xác nhận',
    this.requireTypeMatch,
    this.isDestructive = false,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Xác nhận',
    String? requireTypeMatch,
    bool isDestructive = false,
  }) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AdminConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        requireTypeMatch: requireTypeMatch,
        isDestructive: isDestructive,
      ),
    );
    return res ?? false;
  }

  @override
  State<AdminConfirmDialog> createState() => _AdminConfirmDialogState();
}

class _AdminConfirmDialogState extends State<AdminConfirmDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool get _canConfirm {
    if (widget.requireTypeMatch == null) return true;
    return _ctrl.text.trim() == widget.requireTypeMatch!.trim();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.message),
          if (widget.requireTypeMatch != null) ...[
            const SizedBox(height: 12),
            Text(
              'Gõ chính xác "${widget.requireTypeMatch}" để xác nhận:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ctrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: widget.requireTypeMatch,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Hủy'),
        ),
        FilledButton(
          style: widget.isDestructive
              ? FilledButton.styleFrom(backgroundColor: cs.error)
              : null,
          onPressed: _canConfirm ? () => Navigator.pop(context, true) : null,
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}
