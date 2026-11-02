/// Báo cáo vi phạm đối với bình luận, truyện, chương hoặc người dùng.
class ReportItem {
  final int? id;
  final String reporterId;
  final String reporterName;

  /// `comment` | `novel` | `chapter` | `user`
  final String targetType;
  final int targetId;
  final String targetSnapshot;
  final String reason;

  /// `open` | `resolved` | `rejected`
  final String status;
  final String? handledBy;
  final String? resolutionNote;
  final DateTime createdAt;

  const ReportItem({
    this.id,
    required this.reporterId,
    this.reporterName = 'Độc giả',
    required this.targetType,
    required this.targetId,
    this.targetSnapshot = '',
    required this.reason,
    this.status = 'open',
    this.handledBy,
    this.resolutionNote,
    required this.createdAt,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'reporter_id': reporterId,
        'reporter_name': reporterName,
        'target_type': targetType,
        'target_id': targetId,
        'target_snapshot': targetSnapshot,
        'reason': reason,
        'status': status,
        'handled_by': handledBy,
        'resolution_note': resolutionNote,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory ReportItem.fromMap(Map<String, Object?> map) => ReportItem(
        id: map['id'] as int?,
        reporterId: map['reporter_id']?.toString() ?? '',
        reporterName: (map['reporter_name'] as String?) ?? 'Độc giả',
        targetType: (map['target_type'] as String?) ?? 'comment',
        targetId: (map['target_id'] as int?) ?? 0,
        targetSnapshot: (map['target_snapshot'] as String?) ?? '',
        reason: (map['reason'] as String?) ?? '',
        status: (map['status'] as String?) ?? 'open',
        handledBy: map['handled_by']?.toString(),
        resolutionNote: map['resolution_note'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          (map['created_at'] as int?) ?? 0,
        ),
      );
}
