class NotificationChannels {
  // Different notification channels for better organization
  
  static const String taskReminders = 'task_reminders';
  static const String taskReminderName = 'Task Reminders';
  static const String taskReminderDesc = 'Notifications for task due dates and reminders';
  
  static const String dailyDigest = 'daily_digest';
  static const String dailyDigestName = 'Daily Digest';
  static const String dailyDigestDesc = 'Daily summary of tasks and progress';
  
  static const String achievements = 'achievements';
  static const String achievementsName = 'Achievements';
  static const String achievementsDesc = 'Notifications for unlocked achievements and milestones';
  
  static const String overdueTasks = 'overdue_tasks';
  static const String overdueTasksName = 'Overdue Alerts';
  static const String overdueTasksDesc = 'Alerts for overdue tasks';
  
  static const String locationReminders = 'location_reminders';
  static const String locationRemindersName = 'Location Reminders';
  static const String locationRemindersDesc = 'Location-based task reminders';

  static Map<String, Map<String, String>> getAllChannels() {
    return {
      taskReminders: {
        'name': taskReminderName,
        'description': taskReminderDesc,
        'importance': 'high',
      },
      dailyDigest: {
        'name': dailyDigestName,
        'description': dailyDigestDesc,
        'importance': 'default',
      },
      achievements: {
        'name': achievementsName,
        'description': achievementsDesc,
        'importance': 'default',
      },
      overdueTasks: {
        'name': overdueTasksName,
        'description': overdueTasksDesc,
        'importance': 'high',
      },
      locationReminders: {
        'name': locationRemindersName,
        'description': locationRemindersDesc,
        'importance': 'high',
      },
    };
  }
}
