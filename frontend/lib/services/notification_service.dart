import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/task_model.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._init();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._init();

  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigate to task detail
    final String? payload = response.payload;
    if (payload != null) {
      // You can use a navigation service or stream to handle this
      print('Notification tapped with payload: $payload');
    }
  }

  // Request notification permissions (especially for Android 13+)
  Future<bool> requestPermissions() async {
    if (await _isAndroid13OrHigher()) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
      return granted ?? false;
    }

    // For iOS
    final bool? granted = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return granted ?? false;
  }

  Future<bool> _isAndroid13OrHigher() async {
    // This is a simplified check - in production, use platform_version or similar
    return true;
  }

  // Schedule a notification for a task
  Future<void> scheduleTaskNotification(TaskModel task) async {
    if (!task.hasReminder || task.reminderTime == null) return;

    final scheduledDate = tz.TZDateTime.from(
      task.reminderTime!,
      tz.local,
    );

    // Only schedule if the time is in the future
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _notificationsPlugin.zonedSchedule(
      task.id.hashCode, // Use task ID hash as notification ID
      '📋 ${task.title}',
      task.description.isNotEmpty ? task.description : 'You have a task due!',
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'task_reminders',
          'Task Reminders',
          channelDescription: 'Notifications for task due dates and reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: _getPriorityColor(task.priority),
          styleInformation: BigTextStyleInformation(
            task.description.isNotEmpty 
                ? task.description 
                : 'Tap to view your task',
          ),
          actions: <AndroidNotificationAction>[
            const AndroidNotificationAction(
              'complete',
              'Mark Complete',
              showsUserInterface: true,
            ),
            const AndroidNotificationAction(
              'snooze',
              'Snooze 10m',
              showsUserInterface: false,
            ),
          ],
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          subtitle: _getPriorityLabel(task.priority),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: task.id,
    );
  }

  // Cancel a task notification
  Future<void> cancelTaskNotification(String taskId) async {
    await _notificationsPlugin.cancel(taskId.hashCode);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Schedule a snooze notification (10 minutes from now)
  Future<void> snoozeNotification(TaskModel task, {int minutes = 10}) async {
    final snoozeTime = tz.TZDateTime.now(tz.local).add(Duration(minutes: minutes));

    await _notificationsPlugin.zonedSchedule(
      task.id.hashCode,
      '🔔 Snoozed: ${task.title}',
      task.description.isNotEmpty ? task.description : 'Your snoozed task',
      snoozeTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'task_reminders',
          'Task Reminders',
          channelDescription: 'Notifications for task due dates and reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: task.id,
    );
  }

  // Show immediate notification (for testing or instant reminders)
  Future<void> showInstantNotification(
    String title,
    String body, {
    String? payload,
  }) async {
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notifications',
          'Instant Notifications',
          channelDescription: 'Immediate notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  // Get scheduled notifications count
  Future<int> getScheduledNotificationsCount() async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    return pending.length;
  }

  // Reschedule all task notifications (useful after device reboot)
  Future<void> rescheduleAllNotifications(List<TaskModel> tasks) async {
    await cancelAllNotifications();
    for (final task in tasks) {
      if (task.hasReminder && task.reminderTime != null) {
        await scheduleTaskNotification(task);
      }
    }
  }

  // Helper: Get priority color
  AndroidColor _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return const AndroidColor.fromARGB(255, 244, 67, 54); // Red
      case TaskPriority.medium:
        return const AndroidColor.fromARGB(255, 255, 152, 0); // Orange
      case TaskPriority.low:
        return const AndroidColor.fromARGB(255, 76, 175, 80); // Green
    }
  }

  // Helper: Get priority label
  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return '🔴 High Priority';
      case TaskPriority.medium:
        return '🟠 Medium Priority';
      case TaskPriority.low:
        return '🟢 Low Priority';
    }
  }
}
