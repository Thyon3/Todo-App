import '../models/task_model.dart';

class TaskValidator {
  static bool isValid(TaskModel task) {
    return task.title.trim().isNotEmpty;
  }

  static bool hasValidDueDate(TaskModel task) {
    if (task.dueDate == null) return true;
    return task.dueDate!.isAfter(DateTime.now().subtract(const Duration(days: 1)));
  }

  static bool hasValidReminder(TaskModel task) {
    if (!task.hasReminder) return true;
    if (task.reminderTime == null) return false;
    return task.reminderTime!.isAfter(DateTime.now());
  }

  static List<String> getValidationErrors(TaskModel task) {
    final errors = <String>[];

    if (task.title.trim().isEmpty) {
      errors.add('Title is required');
    }

    if (task.title.length > 100) {
      errors.add('Title must be less than 100 characters');
    }

    if (task.hasReminder && task.reminderTime == null) {
      errors.add('Reminder time is required when reminder is enabled');
    }

    if (task.hasReminder &&
        task.reminderTime != null &&
        task.reminderTime!.isBefore(DateTime.now())) {
      errors.add('Reminder time must be in the future');
    }

    return errors;
  }

  static bool canComplete(TaskModel task) {
    return task.status != TaskStatus.completed;
  }

  static bool canDelete(TaskModel task) {
    return true; // All tasks can be deleted
  }

  static bool canEdit(TaskModel task) {
    return true; // All tasks can be edited
  }
}
