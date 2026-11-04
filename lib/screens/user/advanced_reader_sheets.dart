import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/app_database.dart';
import '../../database/v2_database_store.dart';
import '../../models/chapter_summary.dart';
import '../../models/glossary_term.dart';
import '../../repositories/reader_extras_source.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quest_provider.dart';

/// Tóm tắt và thuật ngữ chỉ sử dụng dữ liệu trong phạm vi chương đang đọc.
class RecapBannerCard extends StatefulWidget {
  final int novelId;
  final int currentChapterIndex;
  final int version;
  final String userKey;
  final ReaderExtrasSource? source;

  const RecapBannerCard({
    super.key,
    required this.novelId,
    required this.currentChapterIndex,
    this.version = 0,
    this.userKey = '',
    this.source,
  });
  @override
  State<RecapBannerCard> createState() => _RecapBannerCardState();
}

class _RecapBannerCardState extends State<RecapBannerCard> {
  List<ChapterSummary> _summaries = [];
  bool _dismissed = false;
  bool _loading = true;
  bool _error = false;
  bool _cached = false;
  int _request = 0;

  @override
  void initState() {
    super.initState();
    _loadSummaries();
  }

  @override
  void didUpdateWidget(covariant RecapBannerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changedBook =
        oldWidget.novelId != widget.novelId ||
        oldWidget.userKey != widget.userKey;
    if (changedBook) _dismissed = false;
    if (changedBook ||
        oldWidget.currentChapterIndex != widget.currentChapterIndex ||
        oldWidget.version != widget.version ||
        oldWidget.source != widget.source) {
      _loadSummaries();
    }
  }

  Future<void> _loadSummaries() async {
    final request = ++_request;
    final book = widget.novelId;
    final index = widget.currentChapterIndex;
    setState(() {
      _summaries = [];
      _loading = true;
      _error = false;
    });
    try {
      final page = await (widget.source ?? AppDatabase.instance)
          .getSummariesForReader(book, index, version: widget.version);
      if (!mounted || request != _request) return;
      final items =
          page.items
              .where(
                (s) =>
                    s.novelId == book &&
                    s.chapterIndex >= 1 &&
                    s.chapterIndex <= index,
              )
              .toList()
            ..sort((a, b) => b.chapterIndex.compareTo(a.chapterIndex));
      setState(() {
        _summaries = items.take(3).toList();
        _cached = page.fromCache;
      });
    } catch (_) {
      if (mounted && request == _request) setState(() => _error = true);
    } finally {
      if (mounted && request == _request) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed || _loading || (!_error && _summaries.isEmpty)) {
      return const SizedBox.shrink();
    }
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
                    'Tóm tắt các chương đã đọc',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _dismissed = true),
                  child: const Text('Bỏ qua'),
                ),
              ],
            ),
            if (_error) ...[
              const Text(
                'Chưa tải được tóm tắt. Bạn vẫn có thể đọc truyện bình thường.',
              ),
              TextButton(
                onPressed: _loadSummaries,
                child: const Text('Thử lại'),
              ),
            ] else ...[
              if (_cached)
                const Text(
                  'Bản tóm tắt đã lưu trên thiết bị',
                  style: TextStyle(fontSize: 12),
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
          ],
        ),
      ),
    );
  }
}

class GlossarySheet extends StatefulWidget {
  final int novelId;
  final int currentChapterIndex;
  final int version;
  final String userKey;
  final ReaderExtrasSource? source;
  const GlossarySheet({
    super.key,
    required this.novelId,
    required this.currentChapterIndex,
    this.version = 0,
    this.userKey = '',
    this.source,
  });
  @override
  State<GlossarySheet> createState() => _GlossarySheetState();
}

class _GlossarySheetState extends State<GlossarySheet> {
  List<GlossaryTerm> _terms = [];
  bool _loading = true;
  bool _error = false;
  bool _cached = false;
  int _request = 0;
  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  @override
  void didUpdateWidget(covariant GlossarySheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.novelId != widget.novelId ||
        oldWidget.currentChapterIndex != widget.currentChapterIndex ||
        oldWidget.version != widget.version ||
        oldWidget.userKey != widget.userKey ||
        oldWidget.source != widget.source) {
      _loadTerms();
    }
  }

  Future<void> _loadTerms() async {
    final request = ++_request;
    final book = widget.novelId;
    final index = widget.currentChapterIndex;
    setState(() {
      _terms = [];
      _loading = true;
      _error = false;
    });
    try {
      final page = await (widget.source ?? AppDatabase.instance)
          .getGlossaryForReader(book, index, version: widget.version);
      if (!mounted || request != _request) return;
      setState(() {
        _terms = page.items
            .where(
              (t) =>
                  t.novelId == book &&
                  t.firstChapterIndex >= 1 &&
                  t.firstChapterIndex <= index,
            )
            .toList();
        _cached = page.fromCache;
      });
    } catch (_) {
      if (mounted && request == _request) setState(() => _error = true);
    } finally {
      if (mounted && request == _request) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Từ điển thuật ngữ (đến Chương ${widget.currentChapterIndex})',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'Thuật ngữ của chương sau được ẩn để tránh lộ cốt truyện.',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 12),
        if (_loading)
          const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_error) ...[
          const Text('Chưa tải được từ điển. Kiểm tra kết nối rồi thử lại.'),
          TextButton(onPressed: _loadTerms, child: const Text('Thử lại')),
        ] else ...[
          if (_cached)
            const Text(
              'Bản đã lưu trên thiết bị',
              style: TextStyle(fontSize: 12),
            ),
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(t.meaning),
                  );
                },
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _loadTerms,
              child: const Text('Làm mới'),
            ),
          ),
        ],
      ],
    ),
  );
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
