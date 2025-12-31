import 'package:uuid/uuid.dart';

enum ReminderType { once, daily, weekly, monthly, yearly }

class ReminderModel {
  final String id;
  final String taskId;
  final DateTime reminderTime;
  final ReminderType type;
  final bool isEnabled;
  final String? customMessage;
  final DateTime createdAt;

  ReminderModel({
    String? id,
    required this.taskId,
    required this.reminderTime,
    this.type = ReminderType.once,
    this.isEnabled = true,
    this.customMessage,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'reminderTime': reminderTime.toIso8601String(),
      'type': type.index,
      'isEnabled': isEnabled ? 1 : 0,
      'customMessage': customMessage,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'],
      taskId: map['taskId'],
      reminderTime: DateTime.parse(map['reminderTime']),
      type: ReminderType.values[map['type'] ?? 0],
      isEnabled: map['isEnabled'] == 1,
      customMessage: map['customMessage'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  ReminderModel copyWith({
    String? id,
    String? taskId,
    DateTime? reminderTime,
    ReminderType? type,
    bool? isEnabled,
    String? customMessage,
    DateTime? createdAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      reminderTime: reminderTime ?? this.reminderTime,
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
      customMessage: customMessage ?? this.customMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
