import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../utils/format.dart';
import '../utils/theme.dart';

/// Bảng tùy chỉnh giao diện đọc (cỡ chữ, font, giãn dòng, căn lề, nền, độ sáng).
class ReaderSettingsSheet extends StatelessWidget {
  final bool showPreview;

  /// Gợi ý chế độ cuộn dọc liên tục khi đang đọc truyện tranh.
  final bool isComic;

  const ReaderSettingsSheet({
    super.key,
    this.showPreview = false,
    this.isComic = false,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    final s = provider.reader;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  AppStrings.readerSettings,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: provider.resetReader,
                  child: const Text('Mặc định'),
                ),
              ],
            ),
            if (showPreview) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: s.background.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Text(
                  AppStrings.previewText,
                  textAlign: s.textAlign,
                  style: s.textStyle,
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Cỡ chữ
            _RowLabel(
              label: AppStrings.fontSize,
              value: '${s.fontSize.round()}',
            ),
            Row(
              children: [
                IconButton(
                  onPressed: s.fontSize > ReaderLimits.minFontSize
                      ? () => provider.setFontSize(s.fontSize - 1)
                      : null,
                  icon: const Icon(Icons.text_decrease),
                ),
                Expanded(
                  child: Slider(
                    value: s.fontSize,
                    min: ReaderLimits.minFontSize,
                    max: ReaderLimits.maxFontSize,
                    divisions: (ReaderLimits.maxFontSize -
                            ReaderLimits.minFontSize)
                        .round(),
                    label: '${s.fontSize.round()}',
                    onChanged: provider.setFontSize,
                  ),
                ),
                IconButton(
                  onPressed: s.fontSize < ReaderLimits.maxFontSize
                      ? () => provider.setFontSize(s.fontSize + 1)
                      : null,
                  icon: const Icon(Icons.text_increase),
                ),
              ],
            ),
            // Giãn dòng
            _RowLabel(
              label: AppStrings.lineHeight,
              value: s.lineHeight.toStringAsFixed(1),
            ),
            Slider(
              value: s.lineHeight,
              min: ReaderLimits.minLineHeight,
              max: ReaderLimits.maxLineHeight,
              divisions: 10,
              label: s.lineHeight.toStringAsFixed(1),
              onChanged: provider.setLineHeight,
            ),
            // Độ sáng
            _RowLabel(
              label: AppStrings.brightness,
              value: Format.percent(s.brightness),
            ),
            Row(
              children: [
                const Icon(Icons.brightness_low, size: 20),
                Expanded(
                  child: Slider(
                    value: s.brightness,
                    min: ReaderLimits.minBrightness,
                    max: ReaderLimits.maxBrightness,
                    onChanged: provider.setBrightness,
                  ),
                ),
                const Icon(Icons.brightness_high, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            // Phông chữ
            Text(AppStrings.font,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in ReaderLimits.fonts.entries)
                  ChoiceChip(
                    label: Text(
                      entry.key,
                      style: TextStyle(
                        fontFamily:
                            entry.value.isEmpty ? null : entry.value,
                      ),
                    ),
                    selected: s.fontFamily == entry.value,
                    onSelected: (_) => provider.setFontFamily(entry.value),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            // Căn lề
            Row(
              children: [
                Text(AppStrings.textAlign,
                    style: Theme.of(context).textTheme.labelLarge),
                const Spacer(),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: false,
                      icon: Icon(Icons.format_align_left, size: 18),
                      label: Text(AppStrings.alignLeft),
                    ),
                    ButtonSegment(
                      value: true,
                      icon: Icon(Icons.format_align_justify, size: 18),
                      label: Text(AppStrings.alignJustify),
                    ),
                  ],
                  selected: {s.justify},
                  onSelectionChanged: (v) => provider.setJustify(v.first),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Màu nền (4 nền đọc)
            Text(AppStrings.background,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final bg in ReaderBackground.values)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => provider.setBackground(bg),
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: bg.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: s.background == bg
                                  ? scheme.primary
                                  : scheme.outlineVariant,
                              width: s.background == bg ? 2.5 : 1,
                            ),
                          ),
                          child: Text(
                            bg.label,
                            style: TextStyle(
                              color: bg.textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Kiểu đọc: Cuộn dọc hoặc Lật trang ngang
            Row(
              children: [
                Text(AppStrings.readingMode,
                    style: Theme.of(context).textTheme.labelLarge),
                const Spacer(),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: false,
                      icon: Icon(Icons.swap_vert_rounded, size: 18),
                      label: Text(AppStrings.modeVerticalScroll),
                    ),
                    ButtonSegment(
                      value: true,
                      icon: Icon(Icons.auto_stories_outlined, size: 18),
                      label: Text(AppStrings.modeHorizontalPage),
                    ),
                  ],
                  selected: {s.horizontalPageMode},
                  onSelectionChanged: (v) =>
                      provider.setHorizontalPageMode(v.first),
                ),
              ],
            ),
            if (isComic) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.view_day_outlined, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Truyện tranh: chọn Cuộn dọc để đọc liên tục kiểu webtoon.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(AppStrings.keepScreenOn),
              value: s.keepScreenOn,
              onChanged: provider.setKeepScreenOn,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Row(
                children: [
                  Icon(Icons.smart_toy_rounded, size: 18, color: Color(0xFF8B5CF6)),
                  SizedBox(width: 8),
                  Text('Bong bóng Trợ lý AI'),
                ],
              ),
              subtitle: const Text(
                'Hiển thị bong bóng AI hỗ trợ tóm tắt, giải thích chương khi đọc',
                style: TextStyle(fontSize: 11.5),
              ),
              value: s.showAiBubble,
              onChanged: provider.setShowAiBubble,
            ),
          ],
        ),
      ),
    );
  }
}

class _RowLabel extends StatelessWidget {
  final String label;
  final String value;

  const _RowLabel({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const Spacer(),
        Text(value, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}
