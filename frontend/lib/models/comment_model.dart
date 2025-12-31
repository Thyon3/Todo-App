import 'package:uuid/uuid.dart';

class CommentModel {
  final String id;
  final String taskId;
  final String content;
  final DateTime createdAt;
  final DateTime? editedAt;

  CommentModel({
    String? id,
    required this.taskId,
    required this.content,
    DateTime? createdAt,
    this.editedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'editedAt': editedAt?.toIso8601String(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      taskId: map['taskId'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      editedAt: map['editedAt'] != null ? DateTime.parse(map['editedAt']) : null,
    );
  }

  CommentModel copyWith({
    String? id,
    String? taskId,
    String? content,
    DateTime? createdAt,
    DateTime? editedAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  bool get isEdited => editedAt != null;
}
