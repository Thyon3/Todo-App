import '../models/task_model.dart';

class TaskDuplicationHelper {
  static TaskModel duplicateTask(TaskModel original) {
    return TaskModel(
      title: '${original.title} (Copy)',
      description: original.description,
      dueDate: original.dueDate,
      dueTime: original.dueTime,
      priority: original.priority,
      status: TaskStatus.pending, // Reset to pending
      categoryId: original.categoryId,
      tags: List.from(original.tags),
      hasReminder: false, // Don't copy reminder
      reminderTime: null,
      isRecurring: original.isRecurring,
      recurringPattern: original.recurringPattern,
      notes: original.notes,
      completionPercentage: 0, // Reset progress
    );
  }

  static TaskModel duplicateTaskWithDate(TaskModel original, DateTime newDate) {
    return TaskModel(
      title: original.title,
      description: original.description,
      dueDate: newDate,
      dueTime: original.dueTime,
      priority: original.priority,
      status: TaskStatus.pending,
      categoryId: original.categoryId,
      tags: List.from(original.tags),
      hasReminder: original.hasReminder,
      reminderTime: original.reminderTime,
      isRecurring: original.isRecurring,
      recurringPattern: original.recurringPattern,
      notes: original.notes,
      completionPercentage: 0,
    );
  }
}
