import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// Chip hiển thị một thể loại truyện, hỗ trợ trạng thái chọn/bỏ chọn.
class GenreChip extends StatelessWidget {
  final String genre;
  final bool selected;
  final VoidCallback? onTap;
  final bool showIcon;

  const GenreChip({
    super.key,
    required this.genre,
    this.selected = false,
    this.onTap,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap == null) {
      return Chip(
        avatar: showIcon ? Icon(Genres.iconOf(genre), size: 16) : null,
        label: Text(genre),
        visualDensity: VisualDensity.compact,
      );
    }
    return FilterChip(
      avatar: showIcon ? Icon(Genres.iconOf(genre), size: 16) : null,
      label: Text(genre),
      selected: selected,
      onSelected: (_) => onTap!(),
      visualDensity: VisualDensity.compact,
    );
  }
}
