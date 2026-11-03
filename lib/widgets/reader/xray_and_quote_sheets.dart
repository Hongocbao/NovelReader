import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/chapter.dart';
import '../../models/novel.dart';
import '../../models/reader_settings.dart';
import '../../utils/constants.dart';
import 'paragraph_view.dart';

/// Bảng Hồ sơ X-Ray (phân tích tên nhân vật/địa danh nổi bật trong chương).
class ReaderXraySheet extends StatelessWidget {
  final Novel novel;
  final Chapter? chapter;
  final String content;
  final ValueChanged<String> onSelectEntity;

  const ReaderXraySheet({
    super.key,
    required this.novel,
    required this.chapter,
    required this.content,
    required this.onSelectEntity,
  });

  static final RegExp _nameRegex = RegExp(
    r'\b[A-ZÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ][a-zàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]+(?:\s+[A-ZÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ][a-zàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]+)+',
  );

  static const Set<String> _stopPhrases = {
    'Chương',
    'Hết chương',
    'Trong bối',
    'Khi thời',
    'Nhìn lại',
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final counts = <String, int>{};
    for (final m in _nameRegex.allMatches(content)) {
      final phrase = m.group(0)!.trim();
      if (_stopPhrases.any((s) => phrase.startsWith(s))) continue;
      counts[phrase] = (counts[phrase] ?? 0) + 1;
    }
    final topEntities = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final entities = topEntities.take(8).toList();
    final wordCount = content.isEmpty
        ? 0
        : content.split(RegExp(r'\s+')).length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.hub_rounded, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppStrings.xrayTitle,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(
              '${novel.title} • ${novel.author}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              novel.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Thống kê chương đang đọc (${chapter?.title ?? ""}): $wordCount từ • ước tính ${(wordCount / 220).ceil()} phút đọc',
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: scheme.primary),
            ),
            const SizedBox(height: 12),
            Text(
              'Nhân vật & Địa danh nổi bật trong chương (chạm để tô sáng):',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            if (entities.isEmpty)
              const Text('Chưa phát hiện tên riêng nổi bật.')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final e in entities)
                    ActionChip(
                      avatar: CircleAvatar(
                        backgroundColor: scheme.primaryContainer,
                        child: Text(
                          '${e.value}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      label: Text(e.key),
                      onPressed: () {
                        Navigator.pop(context);
                        onSelectEntity(e.key);
                      },
                    ),
                ],
              ),
            const SizedBox(height: 12),
            Text(
              AppStrings.keyboardShortcutsHint,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// Thẻ Trích Dẫn Nghệ Thuật (Quote Card) khi nhấn giữ một đoạn văn.
class ReaderQuoteSheet extends StatelessWidget {
  final Novel novel;
  final Chapter chapter;
  final String paragraph;
  final Future<void> Function() onSaveQuote;

  const ReaderQuoteSheet({
    super.key,
    required this.novel,
    required this.chapter,
    required this.paragraph,
    required this.onSaveQuote,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [scheme.primaryContainer, scheme.secondaryContainer],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    size: 32,
                    color: scheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    paragraph,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(fontStyle: FontStyle.italic, height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '— ${novel.title} (${novel.author})',
                    style: Theme.of(context).textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    chapter.title,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.copy_rounded),
                    label: const Text(AppStrings.copyQuote),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text:
                              '“$paragraph” — ${novel.title} (${chapter.title})',
                        ),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(AppStrings.copiedToClipboard),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.favorite_rounded),
                    label: const Text(AppStrings.saveQuote),
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final nav = Navigator.of(context);
                      try {
                        await onSaveQuote();
                        nav.pop();
                        messenger.showSnackBar(
                          const SnackBar(content: Text(AppStrings.quoteSaved)),
                        );
                      } catch (_) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Không lưu được trích dẫn. Hãy kiểm tra kết nối.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Giao diện lật trang ngang (`PageView`) tự động chia chương thành các trang vừa màn hình.
class ReaderHorizontalPager extends StatelessWidget {
  final Chapter chapter;
  final List<String> paragraphs;
  final ReaderSettings settings;
  final PageController controller;
  final int speakingParagraphIndex;
  final bool isListening;
  final String searchKeyword;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<String> onLongPressQuote;
  final ValueChanged<String> onTapImage;
  final Widget footer;

  const ReaderHorizontalPager({
    super.key,
    required this.chapter,
    required this.paragraphs,
    required this.settings,
    required this.controller,
    required this.speakingParagraphIndex,
    required this.isListening,
    required this.searchKeyword,
    required this.onPageChanged,
    required this.onLongPressQuote,
    required this.onTapImage,
    required this.footer,
  });

  /// Nhóm các đoạn văn thành từng trang (~6 đoạn mỗi trang).
  static List<List<String>> paginate(List<String> paragraphs) {
    const perPage = 6;
    if (paragraphs.isEmpty) return const [[]];
    final pages = <List<String>>[];
    for (var i = 0; i < paragraphs.length; i += perPage) {
      pages.add(
        paragraphs.sublist(
          i,
          (i + perPage > paragraphs.length) ? paragraphs.length : i + perPage,
        ),
      );
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final pages = paginate(paragraphs);
    return PageView.builder(
      controller: controller,
      itemCount: pages.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, pageIdx) {
        final chunk = pages[pageIdx];
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 64, 20, 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (pageIdx == 0) ...[
                Text(
                  chapter.title,
                  style: settings.textStyle.copyWith(
                    fontSize: settings.fontSize + 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
              ],
              for (final p in chunk)
                ReaderParagraphView(
                  chapter: chapter,
                  paragraph: p,
                  settings: settings,
                  searchKeyword: searchKeyword,
                  onLongPressQuote: () => onLongPressQuote(p),
                  onTapImage: onTapImage,
                ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Trang ${pageIdx + 1}/${pages.length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: settings.background.textColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
              if (pageIdx == pages.length - 1) ...[
                const SizedBox(height: 20),
                footer,
              ],
            ],
          ),
        );
      },
    );
  }
}
