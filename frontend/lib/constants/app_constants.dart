class AppConstants {
  // App Info
  static const String appName = 'Offline Todo';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'todo_app.db';
  static const int databaseVersion = 1;
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String firstLaunchKey = 'first_launch';
  static const String notificationEnabledKey = 'notifications_enabled';
  
  // Notification Channels
  static const String taskReminderChannelId = 'task_reminders';
  static const String taskReminderChannelName = 'Task Reminders';
  
  // Limits
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxNotesLength = 1000;
  static const int maxTagsPerTask = 10;
  static const int maxSubtasksPerTask = 20;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Snackbar Durations
  static const Duration successSnackbarDuration = Duration(seconds: 2);
  static const Duration errorSnackbarDuration = Duration(seconds: 3);
  static const Duration infoSnackbarDuration = Duration(seconds: 2);
}
