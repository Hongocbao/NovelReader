import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/novel.dart';
import '../../providers/library_provider.dart';
import '../../providers/novel_provider.dart';
import '../novel_detail_screen.dart';

/// Chọn truyện theo tâm trạng (Mood Picker) & Gợi ý theo Gu bằng độ tương đồng Cosine (Mục 5.4).
class MoodPickerSheet extends StatefulWidget {
  const MoodPickerSheet({super.key});

  @override
  State<MoodPickerSheet> createState() => _MoodPickerSheetState();
}

class _MoodPickerSheetState extends State<MoodPickerSheet> {
  String _selectedMood = 'relax';

  static const _moods = [
    (
      key: 'relax',
      label: '🍵 Muốn thư giãn',
      genres: {'Hài hước': 3.0, 'Học đường': 2.5, 'Đô thị': 2.0},
    ),
    (
      key: 'thrill',
      label: '🕵️ Hồi hộp gay cấn',
      genres: {'Trinh thám': 3.5, 'Kinh dị': 3.0, 'Hành động': 2.5},
    ),
    (
      key: 'emotional',
      label: '💧 Muốn lắng đọng',
      genres: {'Ngôn tình': 3.5, 'Học đường': 2.5},
    ),
    (
      key: 'laugh',
      label: '😂 Muốn cười sảng khoái',
      genres: {'Hài hước': 4.0, 'Isekai': 2.5},
    ),
    (
      key: 'power',
      label: '🔥 Cần động lực bứt phá',
      genres: {'Tiên hiệp': 3.5, 'Hành động': 3.0, 'Fantasy': 2.5},
    ),
  ];

  /// Xếp hạng truyện theo điểm tâm trạng = trọng số thể loại + điểm đánh giá.
  List<Novel> _rankByMood(List<Novel> allNovels) {
    final mood = _moods.firstWhere((m) => m.key == _selectedMood);
    final scored = allNovels.map((n) {
      var score = n.rating;
      for (final g in n.genres) {
        score += (mood.genres[g] ?? 0) * 2.0;
      }
      return (novel: n, score: score);
    }).toList();
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(6).map((e) => e.novel).toList();
  }

  /// Tính gợi ý theo Gu (Cosine Similarity giữa vector thể loại lịch sử đọc & truyện chưa đọc).
  List<({Novel novel, String reason, double similarity})> _rankByCosineTaste(
    List<Novel> allNovels,
    LibraryProvider lib,
  ) {
    final userVec = <String, double>{};
    final readIds = <int>{};
    for (final h in lib.history) {
      readIds.add(h.novelId);
      for (final g in h.novel?.genres ?? const <String>[]) {
        userVec[g] = (userVec[g] ?? 0) + 2.0;
      }
    }
    for (final item in lib.items) {
      readIds.add(item.novelId);
      for (final g in item.novel?.genres ?? const <String>[]) {
        userVec[g] = (userVec[g] ?? 0) + 1.5;
      }
    }
    if (userVec.isEmpty) {
      userVec['Tiên hiệp'] = 2.0;
      userVec['Isekai'] = 1.8;
    }

    double normUser = 0;
    for (final v in userVec.values) {
      normUser += v * v;
    }
    normUser = sqrt(max(normUser, 1e-6));

    final results = <({Novel novel, String reason, double similarity})>[];
    for (final n in allNovels) {
      if (readIds.contains(n.id) && allNovels.length > 6) continue;
      double dot = 0;
      String topMatchedGenre = n.genres.isNotEmpty ? n.genres.first : 'Hot';
      double bestWeight = -1;
      for (final g in n.genres) {
        final w = userVec[g] ?? 0;
        dot += w;
        if (w > bestWeight) {
          bestWeight = w;
          topMatchedGenre = g;
        }
      }
      final normNovel = sqrt(max(n.genres.length.toDouble(), 1.0));
      final cosine = dot / (normUser * normNovel);
      results.add((
        novel: n,
        reason: 'Vì bạn hay đọc $topMatchedGenre',
        similarity: cosine + n.rating * 0.05,
      ));
    }
    results.sort((a, b) => b.similarity.compareTo(a.similarity));
    return results.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final novelProv = context.watch<NovelProvider>();
    final libProv = context.watch<LibraryProvider>();
    final pool = <Novel>{
      ...novelProv.featured,
      ...novelProv.newest,
      ...novelProv.hot,
      ...novelProv.completed,
    }.toList();

    final moodNovels = _rankByMood(pool);
    final cosineRecs = _rankByCosineTaste(pool, libProv);

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, scrollCtrl) => ListView(
        controller: scrollCtrl,
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            '🎭 Khám phá theo Tâm trạng (Mood Picker)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _moods.map((m) {
              return ChoiceChip(
                label: Text(m.label),
                selected: _selectedMood == m.key,
                onSelected: (_) => setState(() => _selectedMood = m.key),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          for (final n in moodNovels.take(3))
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.auto_stories_outlined),
              title: Text(
                n.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${n.author} • ${n.genres.join(", ")} • ★ ${n.rating}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NovelDetailScreen(novelId: n.id),
                  ),
                );
              },
            ),
          const Divider(height: 28),
          Text(
            '🧬 Gợi ý chuẩn Gu của bạn (Cosine Similarity)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          for (final rec in cosineRecs)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  rec.novel.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${rec.reason} • ★ ${rec.novel.rating}'),
                trailing: Chip(
                  label: Text(
                    '${(rec.similarity.clamp(0.45, 0.99) * 100).round()}% hợp gu',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NovelDetailScreen(novelId: rec.novel.id),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
