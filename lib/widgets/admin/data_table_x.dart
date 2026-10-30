import 'package:flutter/material.dart';

/// Bảng dữ liệu mở rộng (DataTableX) cho khu Admin, hỗ trợ cuộn ngang/dọc mượt mà.
class DataTableX extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;

  const DataTableX({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: cs.surfaceContainerLow,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStatePropertyAll(
            cs.surfaceContainerHighest.withValues(alpha: 0.6),
          ),
          columns: columns,
          rows: rows,
        ),
      ),
    );
  }
}
