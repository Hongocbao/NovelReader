import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/app_database.dart';
import '../../database/v2_database_store.dart';
import '../../models/chapter_summary.dart';
import '../../models/glossary_term.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quest_provider.dart';

/// Thẻ tóm tắt "Previously on..." (Recap) khi độc giả quay lại đọc truyện (Mục 5.3).
/// Cam kết chống Spoil: Chỉ hiển thị tóm tắt của các chương `<= currentChapterIndex`.
class RecapBannerCard extends StatefulWidget {
  final int novelId;
  final int currentChapterIndex;

  const RecapBannerCard({
    super.key,
    required this.novelId,
    required this.currentChapterIndex,
  });

  @override
  State<RecapBannerCard> createState() => _RecapBannerCardState();
}

class _RecapBannerCardState extends State<RecapBannerCard> {
  List<ChapterSummary> _summaries = [];
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _loadSummaries();
  }

  @override
  void didUpdateWidget(covariant RecapBannerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentChapterIndex != widget.currentChapterIndex) {
      _loadSummaries();
    }
  }

  Future<void> _loadSummaries() async {
    try {
      final db = await AppDatabase.instance.database;
      final list = await V2DatabaseStore.getSummariesUpTo(
        db,
        widget.novelId,
        widget.currentChapterIndex,
      );
      if (mounted) {
        setState(() => _summaries = list);
      }
    } catch (_) {
      // Bỏ qua trong môi trường widget test cô lập không khởi tạo singleton DB
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed || _summaries.isEmpty) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: cs.secondaryContainer.withValues(alpha: 0.65),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history_edu, size: 18, color: cs.primary),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Previously on... (Tóm tắt các chương đã đọc)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _dismissed = true),
                  child: const Text('Bỏ qua'),
                ),
              ],
            ),
            for (final s in _summaries)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '• Chương ${s.chapterIndex}: ${s.summary}',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet Từ điển Thuật ngữ theo truyện (Glossary Sheet - Mục 5.3).
/// Chỉ hiển thị các thuật ngữ có `firstChapterIndex <= currentChapterIndex` để chống lộ cốt truyện.
class GlossarySheet extends StatefulWidget {
  final int novelId;
  final int currentChapterIndex;

  const GlossarySheet({
    super.key,
    required this.novelId,
    required this.currentChapterIndex,
  });

  @override
  State<GlossarySheet> createState() => _GlossarySheetState();
}

class _GlossarySheetState extends State<GlossarySheet> {
  List<GlossaryTerm> _terms = [];

  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  Future<void> _loadTerms() async {
    try {
      final db = await AppDatabase.instance.database;
      final list = await V2DatabaseStore.getGlossaryForNovel(
        db,
        widget.novelId,
        maxChapterIndex: widget.currentChapterIndex,
      );
      if (mounted) setState(() => _terms = list);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📖 Từ điển Thuật ngữ (đến Chương ${widget.currentChapterIndex})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Các thuật ngữ thuộc chương sau được ẩn tự động để bảo vệ trải nghiệm không Spoil.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          if (_terms.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('Chưa có thuật ngữ nào xuất hiện ở chương này.'),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _terms.length,
                itemBuilder: (context, index) {
                  final t = _terms[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      t.term,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.dotted,
                      ),
                    ),
                    subtitle: Text(t.meaning),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Hộp thoại Đọc nhanh RSVP (Rapid Serial Visual Presentation - Mục 5.3):
/// Hiển thị từng từ ở giữa màn hình với tốc độ 200–800 từ/phút, có Tạm dừng và Lùi 10 từ.
class RsvpSpeedReaderDialog extends StatefulWidget {
  final String text;

  const RsvpSpeedReaderDialog({super.key, required this.text});

  @override
  State<RsvpSpeedReaderDialog> createState() => _RsvpSpeedReaderDialogState();
}

class _RsvpSpeedReaderDialogState extends State<RsvpSpeedReaderDialog> {
  late final List<String> _words;
  int _index = 0;
  int _wpm = 350;
  bool _playing = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _words = widget.text
        .replaceAll(RegExp(r'\[img\].*?\[/img\]'), '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    _restartTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = context.read<AuthProvider>().currentUser.id;
      context.read<QuestProvider>().unlockBadge(uid, 'toc_do_anh_sang');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _restartTimer() {
    _timer?.cancel();
    if (!_playing || _words.isEmpty) return;
    final ms = (60000 / _wpm).round().clamp(75, 400);
    _timer = Timer.periodic(Duration(milliseconds: ms), (_) {
      if (!mounted) return;
      if (_index + 1 < _words.length) {
        setState(() => _index++);
      } else {
        setState(() => _playing = false);
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = _words.isEmpty ? '...' : _words[_index];
    return AlertDialog(
      title: const Text('⚡ Đọc nhanh RSVP (Từng từ siêu tốc)'),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                currentWord,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Từ ${_index + 1} / ${_words.length} • Tốc độ: $_wpm từ/phút'),
            Slider(
              value: _wpm.toDouble(),
              min: 200,
              max: 800,
              divisions: 12,
              label: '$_wpm WPM',
              onChanged: (v) {
                setState(() => _wpm = v.round());
                _restartTimer();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Lùi 10 từ',
                  icon: const Icon(Icons.replay_10),
                  onPressed: () => setState(
                    () => _index = (_index - 10).clamp(0, _words.length - 1),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    setState(() => _playing = !_playing);
                    _restartTimer();
                  },
                  icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
                  label: Text(_playing ? 'Tạm dừng' : 'Tiếp tục'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    );
  }
}

/// Bảng trộn Âm thanh nền (Ambient Mixer), Hẹn giờ ngủ TTS & Hộp thư thời gian (Mục 5.3).
class AmbientAndCapsuleSheet extends StatefulWidget {
  final int novelId;
  final int chapterId;
  final List<String> genres;
  final ValueChanged<int?> onSetSleepTimerMinutes;

  const AmbientAndCapsuleSheet({
    super.key,
    required this.novelId,
    required this.chapterId,
    required this.genres,
    required this.onSetSleepTimerMinutes,
  });

  @override
  State<AmbientAndCapsuleSheet> createState() => _AmbientAndCapsuleSheetState();
}

class _AmbientAndCapsuleSheetState extends State<AmbientAndCapsuleSheet> {
  double _rain = 0.0;
  double _cafe = 0.0;
  double _fire = 0.0;
  double _wind = 0.0;
  int? _sleepMinutes;
  final _capsuleCtrl = TextEditingController();
  int _unlockDays = 30;
  List<TimeCapsuleNote> _capsules = [];

  @override
  void initState() {
    super.initState();
    // Gợi ý âm thanh nền theo thể loại
    if (widget.genres.contains('Tiên hiệp')) {
      _wind = 0.65;
      _rain = 0.30;
    } else if (widget.genres.contains('Trinh thám')) {
      _rain = 0.70;
      _cafe = 0.40;
    }
    _loadCapsules();
  }

  @override
  void dispose() {
    _capsuleCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCapsules() async {
    final db = await AppDatabase.instance.database;
    if (!mounted) return;
    final userId = context.read<AuthProvider>().currentUser.id;
    final capsules = await V2DatabaseStore.getTimeCapsules(
      db,
      chapterId: widget.chapterId,
      userId: userId,
    );
    if (mounted) {
      setState(() {
        _capsules = capsules;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.5,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, scrollCtrl) => ListView(
        controller: scrollCtrl,
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            '🎧 Trộn âm thanh nền (Ambient Mixer)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gợi ý tự động theo thể loại (${widget.genres.isEmpty ? "Chung" : widget.genres.first}):',
            style: const TextStyle(fontSize: 12),
          ),
          _buildSlider('🌧️ Tiếng mưa rơi đêm khuya', _rain, (v) {
            setState(() => _rain = v);
            context.read<QuestProvider>().unlockBadge(
                  user.id,
                  'thin_hinh_am_thanh',
                );
          }),
          _buildSlider('☕ Quán cà phê trầm ấm', _cafe, (v) {
            setState(() => _cafe = v);
          }),
          _buildSlider('🔥 Lửa trại tí tách', _fire, (v) {
            setState(() => _fire = v);
          }),
          _buildSlider('🍃 Gió ngàn & Suối tiên', _wind, (v) {
            setState(() => _wind = v);
          }),
          const Divider(height: 24),
          Text(
            '⏲️ Hẹn giờ ngủ cho giọng đọc TTS',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [null, 15, 30, 60].map((m) {
              return ChoiceChip(
                label: Text(m == null ? 'Tắt hẹn giờ' : '$m phút'),
                selected: _sleepMinutes == m,
                onSelected: (_) {
                  setState(() => _sleepMinutes = m);
                  widget.onSetSleepTimerMinutes(m);
                },
              );
            }).toList(),
          ),
          const Divider(height: 28),
          Text(
            '⏳ Hộp thư thời gian (Time Capsule)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Gửi lời nhắn cho chính bạn ở tương lai tại chương này (mở sau 30 hoặc 90 ngày).',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _capsuleCtrl,
            decoration: const InputDecoration(
              hintText: 'Nhắn gửi cho bản thân khi đọc lại chương này...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ChoiceChip(
                label: const Text('30 ngày'),
                selected: _unlockDays == 30,
                onSelected: (_) => setState(() => _unlockDays = 30),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('90 ngày'),
                selected: _unlockDays == 90,
                onSelected: (_) => setState(() => _unlockDays = 90),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () async {
                  if (_capsuleCtrl.text.trim().isEmpty) return;
                  final db = await AppDatabase.instance.database;
                  await V2DatabaseStore.createTimeCapsule(
                    db,
                    TimeCapsuleNote(
                      userId: user.id,
                      novelId: widget.novelId,
                      chapterId: widget.chapterId,
                      note: _capsuleCtrl.text.trim(),
                      unlockAfterDays: _unlockDays,
                      createdAt: DateTime.now(),
                    ),
                  );
                  _capsuleCtrl.clear();
                  if (context.mounted) {
                    await context
                        .read<QuestProvider>()
                        .unlockBadge(user.id, 'nguoi_gui_thoi_gian');
                  }
                  await _loadCapsules();
                },
                icon: const Icon(Icons.lock_clock),
                label: const Text('Niêm phong thư'),
              ),
            ],
          ),
          for (final c in _capsules)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.hourglass_bottom),
              title: Text('Bạn của quá khứ nhắn: "${c.note}"'),
              subtitle: Text('Chu kỳ mở: ${c.unlockAfterDays} ngày'),
            ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(width: 170, child: Text(label, style: const TextStyle(fontSize: 13))),
        Expanded(
          child: Slider(value: value, onChanged: onChanged),
        ),
      ],
    );
  }
}
