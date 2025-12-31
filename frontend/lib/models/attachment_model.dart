import 'package:uuid/uuid.dart';

enum AttachmentType { image, file, audio, link }

class AttachmentModel {
  final String id;
  final String taskId;
  final String fileName;
  final String filePath;
  final AttachmentType type;
  final int fileSize; // in bytes
  final DateTime createdAt;

  AttachmentModel({
    String? id,
    required this.taskId,
    required this.fileName,
    required this.filePath,
    required this.type,
    this.fileSize = 0,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'fileName': fileName,
      'filePath': filePath,
      'type': type.index,
      'fileSize': fileSize,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AttachmentModel.fromMap(Map<String, dynamic> map) {
    return AttachmentModel(
      id: map['id'],
      taskId: map['taskId'],
      fileName: map['fileName'],
      filePath: map['filePath'],
      type: AttachmentType.values[map['type'] ?? 0],
      fileSize: map['fileSize'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String get formattedSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
