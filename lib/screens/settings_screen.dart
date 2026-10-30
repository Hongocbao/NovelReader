import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

import '../providers/library_provider.dart';
import '../providers/novel_provider.dart';
import '../providers/reader_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../utils/format.dart';
import '../utils/theme.dart';
import '../widgets/reader_settings_sheet.dart';
import 'downloads_screen.dart';
import 'history_screen.dart';
import 'novel_detail_screen.dart';
import 'stats_screen.dart';

/// Màn hình Cài đặt & Cá nhân:
/// - Thống kê nhanh (Tủ sách, Đã đọc, Chương đã tải), lối tắt Lịch sử & Tải xuống.
/// - Giao diện sáng / tối / theo hệ thống.
/// - Cài đặt đọc mặc định.
/// - Chế độ offline giả lập (để kiểm thử đọc chương đã tải).
/// - Xóa cache ảnh, xóa lịch sử tìm kiếm.
class SettingsScreen extends StatefulWidget {
  final VoidCallback? onOpenHistory;
  final VoidCallback? onOpenDownloads;

  const SettingsScreen({
    super.key,
    this.onOpenHistory,
    this.onOpenDownloads,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rp = context.read<ReaderProvider>();
      if (!rp.downloadsLoaded && !rp.downloadsLoading) {
        rp.loadDownloads();
      }
      final lp = context.read<LibraryProvider>();
      if (!lp.isLoaded && !lp.isLoading) {
        lp.load();
      }
    });
  }

  Future<void> _clearImageCache() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await DefaultCacheManager().emptyCache();
    } catch (_) {}
    PaintingBinding.instance.imageCache.clear();
    messenger.showSnackBar(
      const SnackBar(content: Text(AppStrings.clearImageCacheDone)),
    );
  }

  Future<void> _showExportBackupDialog() async {
    final jsonStr = await context.read<LibraryProvider>().exportBackupJson();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.exportBackup),
        content: SizedBox(
          width: double.maxFinite,
          height: 260,
          child: SelectableText(
            jsonStr,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Sao chép JSON'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonStr));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.backupCopied)),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showImportBackupDialog() async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.importBackup),
        content: TextField(
          controller: ctrl,
          maxLines: 8,
          decoration: const InputDecoration(
            hintText: '{"backup_version": 1, "library": [...]}',
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
    if (ok == true && ctrl.text.trim().isNotEmpty && mounted) {
      final messenger = ScaffoldMessenger.of(context);
      try {
        await context
            .read<LibraryProvider>()
            .importBackupJson(ctrl.text.trim());
        messenger.showSnackBar(
          const SnackBar(content: Text(AppStrings.restoreSuccess)),
        );
      } catch (_) {
        messenger.showSnackBar(
          const SnackBar(content: Text(AppStrings.restoreInvalid)),
        );
      }
    }
  }

  Future<void> _showCreateNovelDialog() async {
    final titleCtrl = TextEditingController();
    final authorCtrl = TextEditingController(text: AppStrings.guestName);
    final coverCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final rawCtrl = TextEditingController(
      text: 'Chương 1: Khởi đầu hành trình\n'
          'Viết hoặc dán nội dung chương 1 tại đây...\n\n'
          'Chương 2: Bước ngoặt\n'
          'Nội dung chương 2 (ứng dụng sẽ tự động tách thành các chương riêng)...',
    );
    var type = NovelType.novel;
    var status = NovelStatus.ongoing;
    final selectedGenres = <String>{Genres.all.first};

    final createdId = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final detectedCount =
              NovelProvider.parseChaptersFromText(rawCtrl.text).length;
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.createOrImportNovel,
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: AppStrings.novelTitleLabel,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: authorCtrl,
                    decoration: const InputDecoration(
                      labelText: AppStrings.novelAuthorLabel,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: coverCtrl,
                    decoration: const InputDecoration(
                      labelText: AppStrings.novelCoverUrlLabel,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: AppStrings.novelDescLabel,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: NovelType.novel,
                              label: Text(AppStrings.typeNovel),
                            ),
                            ButtonSegment(
                              value: NovelType.lightNovel,
                              label: Text(AppStrings.typeLightNovel),
                            ),
                            ButtonSegment(
                              value: NovelType.comic,
                              label: Text(AppStrings.typeComic),
                            ),
                          ],
                          selected: {type},
                          onSelectionChanged: (v) =>
                              setSheetState(() => type = v.first),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: NovelStatus.ongoing,
                              label: Text(AppStrings.statusOngoing),
                            ),
                            ButtonSegment(
                              value: NovelStatus.completed,
                              label: Text(AppStrings.statusCompleted),
                            ),
                          ],
                          selected: {status},
                          onSelectionChanged: (v) =>
                              setSheetState(() => status = v.first),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      for (final g in Genres.all)
                        FilterChip(
                          label: Text(g),
                          selected: selectedGenres.contains(g),
                          visualDensity: VisualDensity.compact,
                          onSelected: (v) => setSheetState(() {
                            if (v) {
                              selectedGenres.add(g);
                            } else if (selectedGenres.length > 1) {
                              selectedGenres.remove(g);
                            }
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: rawCtrl,
                    maxLines: 6,
                    onChanged: (_) => setSheetState(() {}),
                    decoration: InputDecoration(
                      labelText:
                          '${AppStrings.rawChaptersLabel} ($detectedCount chương)',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(AppStrings.cancel),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        icon: const Icon(Icons.save_outlined),
                        label: Text('${AppStrings.save} ($detectedCount ch.)'),
                        onPressed: () async {
                          if (titleCtrl.text.trim().isEmpty) return;
                          final np = ctx.read<NovelProvider>();
                          final rp = ctx.read<ReaderProvider>();
                          final novel = await np.createCustomNovel(
                            title: titleCtrl.text,
                            author: authorCtrl.text.trim().isEmpty
                                ? AppStrings.guestName
                                : authorCtrl.text,
                            description: descCtrl.text.trim().isEmpty
                                ? 'Truyện do người dùng thêm vào ứng dụng.'
                                : descCtrl.text,
                            status: status,
                            type: type,
                            genres: selectedGenres.toList(),
                            rawChaptersText: rawCtrl.text,
                            coverUrl: coverCtrl.text,
                          );
                          await rp.loadDownloads();
                          if (ctx.mounted) Navigator.pop(ctx, novel.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    if (createdId != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.novelCreatedSuccess)),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => NovelDetailScreen(novelId: createdId),
        ),
      );
    }
  }

  void _showQuotesSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => Consumer<LibraryProvider>(
        builder: (ctx, lp, _) {
          final quotes = lp.quotes;
          final scheme = Theme.of(ctx).colorScheme;
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            maxChildSize: 0.92,
            builder: (_, scrollCtrl) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '${AppStrings.quotesCollection} (${quotes.length})',
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: quotes.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              AppStrings.emptyQuotes,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: scheme.onSurfaceVariant),
                            ),
                          ),
                        )
                      : ListView.separated(
                          controller: scrollCtrl,
                          padding: const EdgeInsets.all(16),
                          itemCount: quotes.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            final q = quotes[i];
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: LinearGradient(
                                  colors: [
                                    scheme.primaryContainer,
                                    scheme.secondaryContainer,
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.format_quote_rounded,
                                        color: scheme.primary,
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          if (q.id != null) {
                                            lp.removeQuote(q.id!);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    q.content,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      height: 1.45,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '— ${q.novelTitle} (${q.author}) • ${q.chapterTitle}',
                                    style:
                                        Theme.of(ctx).textTheme.labelMedium,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SettingsProvider>();
    final lp = context.watch<LibraryProvider>();
    final rp = context.watch<ReaderProvider>();
    final np = context.watch<NovelProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.gap),
        children: [
          // Hồ sơ + thống kê nhanh
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: scheme.primaryContainer,
                        foregroundColor: scheme.onPrimaryContainer,
                        child: const Icon(Icons.person_rounded, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppStrings.guestName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: scheme.tertiaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '★ ${lp.readerRankTitle}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: scheme.onTertiaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AppStrings.guestDesc,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatBox(
                        label: AppStrings.statsLibrary,
                        value: '${lp.items.length}',
                      ),
                      _StatBox(
                        label: AppStrings.statsHistory,
                        value: '${lp.history.length}',
                      ),
                      _StatBox(
                        label: AppStrings.statsDownloads,
                        value: '${rp.downloadedCount}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Lối tắt Lịch sử & Tải xuống
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.history_rounded),
                  title: const Text(AppStrings.history),
                  subtitle: Text('${lp.history.length} truyện'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: widget.onOpenHistory ??
                      () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const HistoryScreen(),
                            ),
                          ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.download_done_rounded),
                  title: const Text(AppStrings.downloads),
                  subtitle: Text(
                    '${rp.downloadedCount} chương • ${Format.bytes(rp.downloadedBytes)}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: widget.onOpenDownloads ??
                      () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DownloadsScreen(),
                            ),
                          ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.bar_chart_rounded),
                  title: const Text(AppStrings.statsScreenTitle),
                  subtitle: Text(
                    'Streak ${lp.currentStreak} ngày • ${Format.views(lp.totalWordsRead)} từ đã đọc',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StatsScreen()),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.format_quote_rounded),
                  title: const Text(AppStrings.quotesCollection),
                  subtitle: Text('${lp.quotes.length} trích dẫn đã lưu'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showQuotesSheet,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.post_add_rounded),
                  title: const Text(AppStrings.createOrImportNovel),
                  subtitle: const Text(AppStrings.createOrImportDesc),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showCreateNovelDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Giao diện
          Text(
            AppStrings.appearance,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        icon: Icon(Icons.brightness_auto_outlined),
                        label: Text(AppStrings.themeSystem),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        icon: Icon(Icons.light_mode_outlined),
                        label: Text(AppStrings.themeLight),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode_outlined),
                        label: Text(AppStrings.themeDark),
                      ),
                    ],
                    selected: {sp.themeMode},
                    onSelectionChanged: (s) => sp.setThemeMode(s.first),
                  ),
                  const Divider(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.text_fields_rounded),
                    title: const Text(AppStrings.defaultReaderSettings),
                    subtitle: Text(
                      'Cỡ ${sp.reader.fontSize.round()} • Nền ${sp.reader.background.label}',
                    ),
                    trailing: const Icon(Icons.tune_rounded),
                    onTap: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) =>
                          const ReaderSettingsSheet(showPreview: true),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Dữ liệu & bộ nhớ
          Text(
            AppStrings.dataAndStorage,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.cloud_off_outlined),
                  title: const Text(AppStrings.forceOffline),
                  subtitle: const Text(AppStrings.forceOfflineDesc),
                  value: sp.forceOffline,
                  onChanged: sp.setForceOffline,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.cleaning_services_outlined),
                  title: const Text(AppStrings.clearImageCache),
                  onTap: _clearImageCache,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.manage_search_rounded),
                  title: const Text(AppStrings.clearSearchHistory),
                  subtitle: Text('${np.searchHistory.length} từ khóa'),
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await np.clearSearchHistory();
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(AppStrings.clearSearchHistoryDone),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.upload_file_outlined),
                  title: const Text(AppStrings.exportBackup),
                  subtitle: const Text(
                    'Sao lưu tủ sách, lịch sử đọc, bookmark & trích dẫn',
                  ),
                  onTap: _showExportBackupDialog,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restore_page_outlined),
                  title: const Text(AppStrings.importBackup),
                  subtitle: const Text(
                    'Dán chuỗi JSON đã sao lưu để khôi phục dữ liệu',
                  ),
                  onTap: _showImportBackupDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Giới thiệu
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline_rounded),
              title: Text('${AppStrings.about} ${AppInfo.appName} v1.0.0'),
              subtitle: Text(AppStrings.aboutDesc),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
