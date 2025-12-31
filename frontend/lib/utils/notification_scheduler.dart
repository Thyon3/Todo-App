import '../models/task_model.dart';
import '../services/notification_service.dart';

class NotificationScheduler {
  static final NotificationService _notificationService = 
      NotificationService.instance;

  static Future<void> scheduleForTask(TaskModel task) async {
    if (!task.hasReminder || task.reminderTime == null) return;
    await _notificationService.scheduleTaskNotification(task);
  }

  static Future<void> cancelForTask(String taskId) async {
    await _notificationService.cancelTaskNotification(taskId);
  }

  static Future<void> rescheduleForTask(TaskModel task) async {
    await cancelForTask(task.id);
    await scheduleForTask(task);
  }

  static Future<void> scheduleMultipleTasks(List<TaskModel> tasks) async {
    for (final task in tasks) {
      if (task.hasReminder && task.reminderTime != null) {
        await scheduleForTask(task);
      }
    }
  }

  static Future<void> cancelMultipleTasks(List<String> taskIds) async {
    for (final id in taskIds) {
      await cancelForTask(id);
    }
  }

  static Future<int> getScheduledCount() async {
    return await _notificationService.getScheduledNotificationsCount();
  }
}
