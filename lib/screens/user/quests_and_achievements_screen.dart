import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/quest_provider.dart';
import '../../widgets/loading_view.dart';

/// Màn hình Nhiệm vụ (Ngày / Tuần / Sự kiện), Khiên bảo vệ Streak & Bộ sưu tập 20 Huy hiệu (Mục 5.2).
class QuestsAndAchievementsScreen extends StatefulWidget {
  final int initialTab;

  const QuestsAndAchievementsScreen({super.key, this.initialTab = 0});

  @override
  State<QuestsAndAchievementsScreen> createState() =>
      _QuestsAndAchievementsScreenState();
}

class _QuestsAndAchievementsScreenState
    extends State<QuestsAndAchievementsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = context.read<AuthProvider>().currentUser.id;
      context.read<QuestProvider>().loadForUser(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final questProv = context.watch<QuestProvider>();
    final user = auth.currentUser;
    final cs = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTab,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nhiệm vụ & Huy hiệu'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Chip(
                avatar: const Text('💎'),
                label: Text('${user.linhThach} Linh Thạch'),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.task_alt_outlined),
                text: 'Nhiệm vụ & Streak',
              ),
              Tab(
                icon: Icon(Icons.workspace_premium_outlined),
                text: '20 Huy hiệu Thành tựu',
              ),
            ],
          ),
        ),
        body: questProv.isLoading
            ? const LoadingView()
            : TabBarView(
                children: [
                  // Tab 1: Nhiệm vụ & Streak Shield
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        color: cs.primaryContainer.withValues(alpha: 0.55),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Text('🔥', style: TextStyle(fontSize: 36)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Chuỗi đọc liên tiếp: ${user.streak} ngày',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      user.hasStreakShield
                                          ? '🛡️ Đang có Khiên bảo vệ Streak (tự động giữ chuỗi 1 ngày bỏ lỡ)'
                                          : 'Đọc ít nhất 5 phút mỗi ngày để tăng Streak.',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              if (!user.hasStreakShield && !user.isGuest)
                                FilledButton.tonal(
                                  onPressed: () async {
                                    final ok = await auth.buyStreakShield();
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          ok
                                              ? '🛡️ Đã trang bị Khiên bảo vệ Streak (-20 Linh Thạch)!'
                                              : 'Không đủ Linh Thạch (cần 20 Linh Thạch).',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Mua Khiên (20 💎)'),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (final q in questProv.quests) ...[
                        Builder(
                          builder: (context) {
                            final prog = questProv.progressOf(q.id);
                            final claimed = questProv.isClaimed(q.id);
                            final done = prog >= q.goalValue;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Chip(
                                          label: Text(q.type.toUpperCase()),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            q.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '+${q.reward} 💎',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: cs.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: (prog / q.goalValue).clamp(
                                        0.0,
                                        1.0,
                                      ),
                                      minHeight: 8,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Tiến độ: $prog / ${q.goalValue}'),
                                        if (claimed)
                                          const Chip(
                                            label: Text('Đã nhận thưởng'),
                                          )
                                        else if (done && !user.isGuest)
                                          FilledButton(
                                            onPressed: () async {
                                              final reward = await questProv
                                                  .claimQuestReward(
                                                    auth: auth,
                                                    quest: q,
                                                  );
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '🎉 Đã nhận +$reward Linh Thạch!',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text('Nhận thưởng'),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                  // Tab 2: 20 Huy hiệu
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: questProv.achievements.length,
                    itemBuilder: (context, index) {
                      final a = questProv.achievements[index];
                      final isUnlocked = questProv.unlockedCodes.contains(
                        a.code,
                      );
                      final isPinned = user.pinnedAchievements.contains(a.code);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isUnlocked
                                ? cs.primaryContainer
                                : cs.surfaceContainerHighest,
                            child: Text(
                              a.icon,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                          title: Text(
                            a.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isUnlocked ? null : cs.onSurfaceVariant,
                            ),
                          ),
                          subtitle: Text(a.description),
                          trailing: isUnlocked && !user.isGuest
                              ? IconButton(
                                  tooltip:
                                      'Ghim lên hồ sơ cá nhân (tối đa 3 huy hiệu)',
                                  icon: Icon(
                                    isPinned
                                        ? Icons.push_pin
                                        : Icons.push_pin_outlined,
                                    color: isPinned ? cs.primary : null,
                                  ),
                                  onPressed: () {
                                    final current = List<String>.from(
                                      user.pinnedAchievements,
                                    );
                                    if (isPinned) {
                                      current.remove(a.code);
                                    } else if (current.length < 3) {
                                      current.add(a.code);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Chỉ được ghim tối đa 3 huy hiệu nổi bật.',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    auth.updateProfile(
                                      pinnedAchievements: current,
                                    );
                                  },
                                )
                              : Chip(
                                  label: Text(
                                    isUnlocked ? 'Đã mở' : 'Chưa mở',
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
