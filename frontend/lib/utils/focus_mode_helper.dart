import 'package:flutter/material.dart';

class FocusModeHelper {
  // Focus mode to minimize distractions
  
  static bool _isFocusModeActive = false;
  static String? _currentFocusTaskId;
  static DateTime? _focusStartTime;
  
  static bool get isFocusModeActive => _isFocusModeActive;
  static String? get currentFocusTaskId => _currentFocusTaskId;
  static Duration? get focusDuration {
    if (_focusStartTime == null) return null;
    return DateTime.now().difference(_focusStartTime!);
  }

  static void startFocusMode(String taskId) {
    _isFocusModeActive = true;
    _currentFocusTaskId = taskId;
    _focusStartTime = DateTime.now();
  }

  static void endFocusMode() {
    _isFocusModeActive = false;
    _currentFocusTaskId = null;
    _focusStartTime = null;
  }

  static Map<String, dynamic> getFocusSession() {
    return {
      'isActive': _isFocusModeActive,
      'taskId': _currentFocusTaskId,
      'startTime': _focusStartTime?.toIso8601String(),
      'duration': focusDuration?.inSeconds,
    };
  }

  // Focus mode settings
  static const int defaultFocusDuration = 25 * 60; // 25 minutes (Pomodoro)
  static const int shortBreakDuration = 5 * 60; // 5 minutes
  static const int longBreakDuration = 15 * 60; // 15 minutes

  // Do Not Disturb settings for focus mode
  static Map<String, bool> getFocusModeSettings() {
    return {
      'hideOtherTasks': true,
      'muteNotifications': true,
      'showTimer': true,
      'lockScreen': false,
      'playWhiteNoise': false,
    };
  }

  // Focus mode UI theme
  static ThemeData getFocusModeTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      primaryColor: const Color(0xFF00C853),
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF00C853),
        secondary: const Color(0xFF64DD17),
        background: const Color(0xFF1A1A1A),
        surface: const Color(0xFF2A2A2A),
      ),
    );
  }

  // Motivational quotes for focus mode
  static List<String> getFocusQuotes() {
    return [
      "Focus on being productive instead of busy.",
      "Concentrate all your thoughts upon the work in hand.",
      "The successful warrior is the average man, with laser-like focus.",
      "Where focus goes, energy flows.",
      "Stay focused and never give up.",
      "Lack of direction, not lack of time, is the problem.",
      "The key to success is to focus our conscious mind on things we desire.",
    ];
  }

  static String getRandomFocusQuote() {
    final quotes = getFocusQuotes();
    return quotes[DateTime.now().millisecond % quotes.length];
  }
}
