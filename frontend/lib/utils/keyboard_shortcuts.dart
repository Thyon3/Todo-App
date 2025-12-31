import 'package:flutter/services.dart';

class KeyboardShortcuts {
  // Keyboard shortcuts for desktop/web versions
  
  static const quickAddTask = SingleActivator(
    LogicalKeyboardKey.keyN,
    control: true,
  );
  
  static const searchTasks = SingleActivator(
    LogicalKeyboardKey.keyF,
    control: true,
  );
  
  static const markComplete = SingleActivator(
    LogicalKeyboardKey.keyD,
    control: true,
  );
  
  static const deleteTask = SingleActivator(
    LogicalKeyboardKey.delete,
    shift: true,
  );
  
  static const undo = SingleActivator(
    LogicalKeyboardKey.keyZ,
    control: true,
  );
  
  static const redo = SingleActivator(
    LogicalKeyboardKey.keyY,
    control: true,
  );
  
  static const selectAll = SingleActivator(
    LogicalKeyboardKey.keyA,
    control: true,
  );
  
  static const refresh = SingleActivator(
    LogicalKeyboardKey.keyR,
    control: true,
  );
  
  static const openSettings = SingleActivator(
    LogicalKeyboardKey.comma,
    control: true,
  );
  
  static const toggleDarkMode = SingleActivator(
    LogicalKeyboardKey.keyT,
    control: true,
    shift: true,
  );

  // Get shortcut description
  static String getShortcutDescription(SingleActivator shortcut) {
    final keys = <String>[];
    
    if (shortcut.control) keys.add('Ctrl');
    if (shortcut.shift) keys.add('Shift');
    if (shortcut.alt) keys.add('Alt');
    if (shortcut.meta) keys.add('Meta');
    
    keys.add(shortcut.trigger.keyLabel);
    
    return keys.join(' + ');
  }

  // All shortcuts map
  static Map<String, SingleActivator> getAllShortcuts() {
    return {
      'Quick Add Task': quickAddTask,
      'Search Tasks': searchTasks,
      'Mark Complete': markComplete,
      'Delete Task': deleteTask,
      'Undo': undo,
      'Redo': redo,
      'Select All': selectAll,
      'Refresh': refresh,
      'Settings': openSettings,
      'Toggle Dark Mode': toggleDarkMode,
    };
  }
}
