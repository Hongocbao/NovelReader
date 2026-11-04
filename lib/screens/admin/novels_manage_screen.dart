import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/novel.dart';
import '../../providers/admin_novel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/format.dart';
import '../../widgets/admin/confirm_dialog.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/loading_view.dart';
import 'chapter_editor_screen.dart';
import 'novel_editor_screen.dart';

/// Màn hình Quản lý Truyện & Chương của Admin (Mục 6.2).
/// Hỗ trợ tìm kiếm không dấu, lọc đa điều kiện, chọn nhiều để duyệt/ẩn/xóa mềm/gắn nổi bật.
class AdminNovelsManageScreen extends StatefulWidget {
  const AdminNovelsManageScreen({super.key});

  @override
  State<AdminNovelsManageScreen> createState() =>
      _AdminNovelsManageScreenState();
}

class _AdminNovelsManageScreenState extends State<AdminNovelsManageScreen> {
  final _searchCtrl = TextEditingController();
  String _modFilter = 'all';
  String _typeFilter = 'all';
  bool _showDeleted = false;
  final Set<int> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminNovelProvider>().loadNovels(includeDeleted: true);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Novel> _filtered(List<Novel> source) {
    final kw = Format.normalize(_searchCtrl.text);
    return source.where((n) {
      if (!_showDeleted && n.isDeleted) return false;
      if (_showDeleted && !n.isDeleted) return false;
      if (_modFilter != 'all' && n.moderationStatus != _modFilter) {
        return false;
      }
      if (_typeFilter != 'all' && n.type != _typeFilter) {
        return false;
      }
      if (kw.isNotEmpty) {
        final norm = Format.normalize('${n.title} ${n.author}');
        if (!norm.contains(kw)) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AdminNovelProvider>();
    final admin = context.watch<AuthProvider>().currentUser;
    final list = _filtered(prov.allNovels);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 280,
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Tìm tên truyện/tác giả (không dấu)...',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: _modFilter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Mọi trạng thái')),
                    DropdownMenuItem(value: 'approved', child: Text('Đã duyệt')),
                    DropdownMenuItem(value: 'pending', child: Text('Chờ duyệt')),
                    DropdownMenuItem(value: 'rejected', child: Text('Bị từ chối')),
                    DropdownMenuItem(value: 'draft', child: Text('Bản nháp')),
                  ],
                  onChanged: (v) => setState(() => _modFilter = v ?? 'all'),
                ),
                DropdownButton<String>(
                  value: _typeFilter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Mọi loại hình')),
                    DropdownMenuItem(
                      value: NovelType.novel,
                      child: Text('Truyện chữ'),
                    ),
                    DropdownMenuItem(
                      value: NovelType.lightNovel,
                      child: Text('Light Novel'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _typeFilter = v ?? 'all'),
                ),
                FilterChip(
                  label: const Text('Thùng rác (30 ngày)'),
                  selected: _showDeleted,
                  onSelected: (v) => setState(() {
                    _showDeleted = v;
                    _selectedIds.clear();
                  }),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NovelEditorScreen(),
                      ),
                    );
                    if (context.mounted) {
                      context
                          .read<AdminNovelProvider>()
                          .loadNovels(includeDeleted: true);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm / Nhập truyện'),
                ),
              ],
            ),
          ),
          if (_selectedIds.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Đã chọn ${_selectedIds.length} truyện:'),
                  TextButton.icon(
                    onPressed: () async {
                      await prov.approveNovels(
                        admin: admin,
                        novelIds: _selectedIds.toList(),
                      );
                      setState(_selectedIds.clear);
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Duyệt hàng loạt'),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await prov.setFeaturedStatus(
                        admin: admin,
                        novelIds: _selectedIds.toList(),
                        featured: true,
                      );
                      setState(_selectedIds.clear);
                    },
                    icon: const Icon(Icons.star_outline),
                    label: const Text('Gắn Đề cử'),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(_selectedIds.clear),
                    icon: const Icon(Icons.clear),
                    label: const Text('Bỏ chọn'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: prov.isLoading
                ? const LoadingView()
                : list.isEmpty
                    ? const EmptyView(
                        icon: Icons.menu_book_outlined,
                        message: 'Không có truyện nào khớp bộ lọc',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: list.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final n = list[index];
                          final selected = _selectedIds.contains(n.id);
                          return ListTile(
                            leading: Checkbox(
                              value: selected,
                              onChanged: (v) => setState(() {
                                if (v == true) {
                                  _selectedIds.add(n.id);
                                } else {
                                  _selectedIds.remove(n.id);
                                }
                              }),
                            ),
                            title: Row(
                              children: [
                                if (n.isFeatured)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Icon(
                                      Icons.auto_awesome,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    n.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              '${n.author} • ${n.totalChapters} chương • Trạng thái: ${n.moderationStatus.toUpperCase()}',
                            ),
                            trailing: Wrap(
                              spacing: 4,
                              children: [
                                IconButton(
                                  tooltip: 'Soạn chương & Thuật ngữ',
                                  icon: const Icon(Icons.list_alt),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ChapterEditorScreen(novel: n),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Sửa thông tin truyện',
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            NovelEditorScreen(novel: n),
                                      ),
                                    );
                                    if (context.mounted) {
                                      prov.loadNovels(includeDeleted: true);
                                    }
                                  },
                                ),
                                if (!n.isDeleted)
                                  IconButton(
                                    tooltip: 'Xóa mềm (cần gõ lại tên truyện)',
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                    onPressed: () async {
                                      final ok = await AdminConfirmDialog.show(
                                        context,
                                        title: 'Xóa mềm bộ truyện',
                                        message:
                                            'Truyện sẽ được chuyển vào thùng rác và có thể khôi phục trong 30 ngày.',
                                        confirmLabel: 'Xóa mềm',
                                        requireTypeMatch: n.title,
                                        isDestructive: true,
                                      );
                                      if (ok) {
                                        await prov.softDeleteNovel(admin, n.id);
                                      }
                                    },
                                  )
                                else
                                  TextButton.icon(
                                    onPressed: () =>
                                        prov.restoreNovel(admin, n.id),
                                    icon: const Icon(Icons.restore),
                                    label: const Text('Khôi phục'),
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
  }
}
