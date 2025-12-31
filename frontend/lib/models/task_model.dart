import 'package:uuid/uuid.dart';

enum TaskPriority { low, medium, high }

enum TaskStatus { pending, inProgress, completed }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final DateTime? dueTime;
  final TaskPriority priority;
  final TaskStatus status;
  final String? categoryId;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasReminder;
  final DateTime? reminderTime;
  final bool isRecurring;
  final String? recurringPattern; // daily, weekly, monthly
  final String? notes;
  final int completionPercentage;

  TaskModel({
    String? id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.dueTime,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.categoryId,
    this.tags = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.hasReminder = false,
    this.reminderTime,
    this.isRecurring = false,
    this.recurringPattern,
    this.notes,
    this.completionPercentage = 0,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert to Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'dueTime': dueTime?.toIso8601String(),
      'priority': priority.index,
      'status': status.index,
      'categoryId': categoryId,
      'tags': tags.join(','),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'hasReminder': hasReminder ? 1 : 0,
      'reminderTime': reminderTime?.toIso8601String(),
      'isRecurring': isRecurring ? 1 : 0,
      'recurringPattern': recurringPattern,
      'notes': notes,
      'completionPercentage': completionPercentage,
    };
  }

  // Create from Map (SQLite data)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      dueDate:
          map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      dueTime:
          map['dueTime'] != null ? DateTime.parse(map['dueTime']) : null,
      priority: TaskPriority.values[map['priority'] ?? 1],
      status: TaskStatus.values[map['status'] ?? 0],
      categoryId: map['categoryId'],
      tags: map['tags'] != null && map['tags'].isNotEmpty
          ? map['tags'].split(',')
          : [],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      hasReminder: map['hasReminder'] == 1,
      reminderTime: map['reminderTime'] != null
          ? DateTime.parse(map['reminderTime'])
          : null,
      isRecurring: map['isRecurring'] == 1,
      recurringPattern: map['recurringPattern'],
      notes: map['notes'],
      completionPercentage: map['completionPercentage'] ?? 0,
    );
  }

  // CopyWith method for immutability
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? dueTime,
    TaskPriority? priority,
    TaskStatus? status,
    String? categoryId,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? hasReminder,
    DateTime? reminderTime,
    bool? isRecurring,
    String? recurringPattern,
    String? notes,
    int? completionPercentage,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderTime: reminderTime ?? this.reminderTime,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPattern: recurringPattern ?? this.recurringPattern,
      notes: notes ?? this.notes,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }

  // Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  // Check if task is due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  // Check if task is due tomorrow
  bool get isDueTomorrow {
    if (dueDate == null) return false;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dueDate!.year == tomorrow.year &&
        dueDate!.month == tomorrow.month &&
        dueDate!.day == tomorrow.day;
  }
}
