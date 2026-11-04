import 'dart:convert';
import 'dart:typed_data' show BytesBuilder, Uint8List;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../database/supabase_database.dart';
import '../utils/constants.dart';

/// Keep the same submission key when retrying an unchanged chapter after a
/// network failure: the server may already have committed the first request.
class AddChapterDialog extends StatefulWidget {
  const AddChapterDialog({
    super.key,
    this.onSave,
    this.onSaveWithSummary,
    this.initialTitle = '',
    this.initialContent = '',
    this.editing = false,
  }) : assert((onSave != null) != (onSaveWithSummary != null));

  final Future<void> Function(String title, String content, String requestId)?
  onSave;
  final Future<void> Function(
    String title,
    String content,
    String summary,
    String requestId,
  )?
  onSaveWithSummary;
  final String initialTitle;
  final String initialContent;
  final bool editing;

  @override
  State<AddChapterDialog> createState() => _AddChapterDialogState();
}

class _AddChapterDialogState extends State<AddChapterDialog> {
  late final _title = TextEditingController(text: widget.initialTitle);
  late final _content = TextEditingController(text: widget.initialContent);
  final _summary = TextEditingController();
  String? _requestId;
  ({String title, String content})? _submitted;
  bool _saving = false;
  String? _error;

  Future<void> _save() async {
    if (_saving) return;
    final payload = (title: _title.text.trim(), content: _content.text.trim());
    if (widget.editing && payload.title.isEmpty) {
      setState(() => _error = 'Vui lòng nhập tiêu đề chương.');
      return;
    }
    if (payload.content.isEmpty) {
      setState(() => _error = 'Vui lòng nhập nội dung chương.');
      return;
    }
    if (payload != _submitted) {
      _requestId = SupabaseDatabase.newImportRequestId();
      _submitted = payload;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      if (widget.onSaveWithSummary != null) {
        await widget.onSaveWithSummary!(
          payload.title,
          payload.content,
          _summary.text.trim(),
          _requestId!,
        );
      } else {
        await widget.onSave!(payload.title, payload.content, _requestId!);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) setState(() => _error = 'Không lưu được chương: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    _summary.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromDevice() async {
    if (_saving) return;
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'],
        dialogTitle: 'Chọn ảnh minh họa từ máy',
      );
      if (!mounted || files.isEmpty) return;
      final tags = <String>[];
      for (final file in files) {
        final builder = BytesBuilder(copy: false);
        await for (final chunk in file.readAsByteStream()) {
          if (builder.length + chunk.length > 10 * 1024 * 1024) {
            throw StateError('Ảnh ${file.name} vượt giới hạn 10 MB.');
          }
          builder.add(chunk);
        }
        final Uint8List bytes = builder.takeBytes();
        if (bytes.isEmpty) continue;
        final ext = file.name.split('.').last.toLowerCase();
        final mime = switch (ext) {
          'jpg' || 'jpeg' => 'image/jpeg',
          'png' => 'image/png',
          'webp' => 'image/webp',
          'gif' => 'image/gif',
          'bmp' => 'image/bmp',
          _ => 'image/png',
        };
        tags.add('[img]data:$mime;base64,${base64Encode(bytes)}[/img]');
      }
      if (tags.isEmpty || !mounted) return;
      final prefix = _content.text.trim().isEmpty
          ? ''
          : '${_content.text.trimRight()}\n\n';
      setState(() {
        _content.text = '$prefix${tags.join('\n\n')}\n';
      });
    } catch (e) {
      if (mounted) setState(() => _error = 'Không tải được ảnh: $e');
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: AlertDialog(
      title: Text(widget.editing ? 'Biên tập chương' : AppStrings.addChapter),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _title,
                enabled: !_saving,
                decoration: InputDecoration(
                  labelText: AppStrings.chapterTitleLabel,
                  hintText: widget.editing
                      ? null
                      : 'Để trống để tự đánh số chương',
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _saving ? null : _pickImageFromDevice,
                  icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
                  label: const Text('Tải ảnh từ máy lên'),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _content,
                enabled: !_saving,
                maxLines: 6,
                onChanged: widget.onSaveWithSummary == null
                    ? null
                    : (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: AppStrings.chapterContentLabel,
                  alignLabelWithHint: true,
                ),
              ),
              if (widget.onSaveWithSummary != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Số từ: ${_content.text.trim().isEmpty ? 0 : _content.text.trim().split(RegExp(r'\s+')).length} từ',
                ),
                if (RegExp(r'\[img\]\s*\[/img\]').hasMatch(_content.text))
                  Text(
                    'Phát hiện thẻ [img] rỗng!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: _summary,
                  enabled: !_saving,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Tóm tắt chương',
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text(AppStrings.cancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Đang lưu…' : AppStrings.save),
        ),
      ],
    ),
  );
}
