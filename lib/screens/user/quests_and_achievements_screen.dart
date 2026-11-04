import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/quest_provider.dart';
import '../../models/quest.dart';
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
  final _claimingQuestIds = <({String userId, int questId})>{};
  final _buyingShieldOwners = <String>{};
  final _pinningOwners = <String>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final uid = context.read<AuthProvider>().currentUser.id;
      context.read<QuestProvider>().loadForUser(uid);
    });
  }

  Future<void> _claimQuest(
    QuestProvider questProvider,
    AuthProvider authProvider,
    Quest quest,
  ) async {
    final owner = authProvider.currentUser.id;
    final key = (userId: owner, questId: quest.id);
    if (!_claimingQuestIds.add(key)) return;
    setState(() {});
    try {
      final reward = await questProvider.claimQuestReward(
        auth: authProvider,
        quest: quest,
      );
      if (!mounted || authProvider.currentUser.id != owner) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            reward > 0
                ? '🎉 Đã nhận +$reward Linh Thạch!'
                : 'Chưa thể nhận thưởng. Hãy tải lại nhiệm vụ và thử lại.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted || authProvider.currentUser.id != owner) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể nhận thưởng: $error')));
    } finally {
      _claimingQuestIds.remove(key);
      if (mounted) setState(() {});
    }
  }

  Future<void> _buyShield(AuthProvider auth) async {
    final owner = auth.currentUser.id;
    if (!_buyingShieldOwners.add(owner)) return;
    setState(() {});
    try {
      final ok = await auth.buyStreakShield();
      if (!mounted || auth.currentUser.id != owner) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? '🛡️ Đã trang bị Khiên bảo vệ Streak!'
                : 'Không đủ Linh Thạch (cần 20 Linh Thạch).',
          ),
        ),
      );
    } catch (error) {
      if (!mounted || auth.currentUser.id != owner) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Không thể mua Khiên: $error')));
    } finally {
      _buyingShieldOwners.remove(owner);
      if (mounted) setState(() {});
    }
  }

  Future<void> _togglePinned(AuthProvider auth, String code) async {
    final owner = auth.currentUser.id;
    if (!_pinningOwners.add(owner)) return;
    final current = List<String>.from(auth.currentUser.pinnedAchievements);
    if (current.contains(code)) {
      current.remove(code);
    } else if (current.length < 3) {
      current.add(code);
    } else {
      _pinningOwners.remove(owner);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chỉ được ghim tối đa 3 huy hiệu nổi bật.'),
        ),
      );
      return;
    }
    setState(() {});
    try {
      await auth.updateProfile(pinnedAchievements: current);
    } catch (error) {
      if (!mounted || auth.currentUser.id != owner) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chưa lưu được huy hiệu ghim: $error')),
      );
    } finally {
      _pinningOwners.remove(owner);
      if (mounted) setState(() {});
    }
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
            if (auth.balanceNeedsRefresh)
              IconButton(
                tooltip: 'Tải lại số dư',
                onPressed: auth.refreshCurrentUser,
                icon: const Icon(Icons.sync),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Chip(
                avatar: const Text('💎'),
                label: Text(
                  auth.balanceNeedsRefresh
                      ? 'Đang đồng bộ số dư'
                      : '${user.linhThach} Linh Thạch',
                ),
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
            : Column(
                children: [
                  if (questProv.error != null)
                    MaterialBanner(
                      content: Text(
                        'Không tải được dữ liệu nhiệm vụ: ${questProv.error}',
                      ),
                      leading: Icon(Icons.error_outline, color: cs.error),
                      actions: [
                        TextButton(
                          onPressed: () => questProv.loadForUser(user.id),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Tab 1: Nhiệm vụ & Streak Shield
                        ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Card(
                              color: cs.primaryContainer.withValues(
                                alpha: 0.55,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          '🔥',
                                          style: TextStyle(fontSize: 36),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (!user.hasStreakShield && !user.isGuest)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: FilledButton.tonal(
                                          onPressed:
                                              _buyingShieldOwners.contains(
                                                user.id,
                                              )
                                              ? null
                                              : () => _buyShield(auth),
                                          child: const Text(
                                            'Mua Khiên (20 💎)',
                                          ),
                                        ),
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
                                  final done =
                                      q.goalValue > 0 && prog >= q.goalValue;
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Chip(
                                                label: Text(
                                                  q.type.toUpperCase(),
                                                ),
                                                visualDensity:
                                                    VisualDensity.compact,
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
                                            value: q.goalValue > 0
                                                ? (prog / q.goalValue).clamp(
                                                    0.0,
                                                    1.0,
                                                  )
                                                : 0.0,
                                            minHeight: 8,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 12,
                                            runSpacing: 8,
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Text(
                                                'Tiến độ: $prog / ${q.goalValue}',
                                              ),
                                              if (claimed)
                                                const Chip(
                                                  label: Text('Đã nhận thưởng'),
                                                )
                                              else if (done && !user.isGuest)
                                                FilledButton(
                                                  onPressed:
                                                      _claimingQuestIds
                                                          .contains((
                                                            userId: user.id,
                                                            questId: q.id,
                                                          ))
                                                      ? null
                                                      : () => _claimQuest(
                                                          questProv,
                                                          auth,
                                                          q,
                                                        ),
                                                  child:
                                                      _claimingQuestIds
                                                          .contains((
                                                            userId: user.id,
                                                            questId: q.id,
                                                          ))
                                                      ? const SizedBox(
                                                          width: 18,
                                                          height: 18,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                              ),
                                                        )
                                                      : const Text(
                                                          'Nhận thưởng',
                                                        ),
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
                            final isPinned = user.pinnedAchievements.contains(
                              a.code,
                            );
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
                                    color: isUnlocked
                                        ? null
                                        : cs.onSurfaceVariant,
                                  ),
                                ),
                                subtitle: Text(a.description),
                                trailing: isUnlocked && !user.isGuest
                                    ? IconButton(
                                        tooltip: 'Ghim lên hồ sơ cá nhân (tối đa 3 huy hiệu)',
                                        icon: Icon(
                                          isPinned
                                              ? Icons.push_pin
                                              : Icons.push_pin_outlined,
                                          color: isPinned ? cs.primary : null,
                                        ),
                                        onPressed:
                                            _pinningOwners.contains(user.id)
                                            ? null
                                            : () => _togglePinned(auth, a.code),
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
                ],
              ),
      ),
    );
  }
}
