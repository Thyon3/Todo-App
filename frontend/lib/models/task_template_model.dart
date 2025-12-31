import 'package:uuid/uuid.dart';
import 'task_model.dart';

class TaskTemplateModel {
  final String id;
  final String name;
  final String description;
  final TaskPriority defaultPriority;
  final String? defaultCategoryId;
  final List<String> defaultTags;
  final List<String> subtaskTemplates;
  final DateTime createdAt;
  final int usageCount;

  TaskTemplateModel({
    String? id,
    required this.name,
    this.description = '',
    this.defaultPriority = TaskPriority.medium,
    this.defaultCategoryId,
    this.defaultTags = const [],
    this.subtaskTemplates = const [],
    DateTime? createdAt,
    this.usageCount = 0,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'defaultPriority': defaultPriority.index,
      'defaultCategoryId': defaultCategoryId,
      'defaultTags': defaultTags.join(','),
      'subtaskTemplates': subtaskTemplates.join('|||'),
      'createdAt': createdAt.toIso8601String(),
      'usageCount': usageCount,
    };
  }

  factory TaskTemplateModel.fromMap(Map<String, dynamic> map) {
    return TaskTemplateModel(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      defaultPriority: TaskPriority.values[map['defaultPriority'] ?? 1],
      defaultCategoryId: map['defaultCategoryId'],
      defaultTags: map['defaultTags']?.isNotEmpty == true
          ? map['defaultTags'].split(',')
          : [],
      subtaskTemplates: map['subtaskTemplates']?.isNotEmpty == true
          ? map['subtaskTemplates'].split('|||')
          : [],
      createdAt: DateTime.parse(map['createdAt']),
      usageCount: map['usageCount'] ?? 0,
    );
  }

  TaskModel createTask() {
    return TaskModel(
      title: name,
      description: description,
      priority: defaultPriority,
      categoryId: defaultCategoryId,
      tags: List.from(defaultTags),
    );
  }

  TaskTemplateModel copyWith({
    String? id,
    String? name,
    String? description,
    TaskPriority? defaultPriority,
    String? defaultCategoryId,
    List<String>? defaultTags,
    List<String>? subtaskTemplates,
    DateTime? createdAt,
    int? usageCount,
  }) {
    return TaskTemplateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      defaultPriority: defaultPriority ?? this.defaultPriority,
      defaultCategoryId: defaultCategoryId ?? this.defaultCategoryId,
      defaultTags: defaultTags ?? this.defaultTags,
      subtaskTemplates: subtaskTemplates ?? this.subtaskTemplates,
      createdAt: createdAt ?? this.createdAt,
      usageCount: usageCount ?? this.usageCount,
    );
  }
}
