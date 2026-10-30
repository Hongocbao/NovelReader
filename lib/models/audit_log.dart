/// Bản ghi nhật ký thao tác của Quản trị viên (Audit Log) - chỉ ghi thêm, không sửa/xóa.
class AuditLog {
  final int? id;
  final int adminId;
  final String adminName;
  final String action;
  final String target;
  final String detail;
  final DateTime createdAt;

  const AuditLog({
    this.id,
    required this.adminId,
    this.adminName = 'Admin',
    required this.action,
    required this.target,
    required this.detail,
    required this.createdAt,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'admin_id': adminId,
        'admin_name': adminName,
        'action': action,
        'target': target,
        'detail': detail,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory AuditLog.fromMap(Map<String, Object?> map) => AuditLog(
        id: map['id'] as int?,
        adminId: (map['admin_id'] as int?) ?? 1,
        adminName: (map['admin_name'] as String?) ?? 'Admin',
        action: (map['action'] as String?) ?? '',
        target: (map['target'] as String?) ?? '',
        detail: (map['detail'] as String?) ?? '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          (map['created_at'] as int?) ?? 0,
        ),
      );
}
