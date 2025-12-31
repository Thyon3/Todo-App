import '../models/task_model.dart';

enum EisenhowerQuadrant {
  urgentImportant, // Do First
  notUrgentImportant, // Schedule
  urgentNotImportant, // Delegate
  notUrgentNotImportant, // Eliminate
}

class EisenhowerMatrix {
  // Eisenhower Matrix for task prioritization
  
  static EisenhowerQuadrant categorizeTask(TaskModel task) {
    final isUrgent = _isUrgent(task);
    final isImportant = _isImportant(task);
    
    if (isUrgent && isImportant) {
      return EisenhowerQuadrant.urgentImportant;
    } else if (!isUrgent && isImportant) {
      return EisenhowerQuadrant.notUrgentImportant;
    } else if (isUrgent && !isImportant) {
      return EisenhowerQuadrant.urgentNotImportant;
    } else {
      return EisenhowerQuadrant.notUrgentNotImportant;
    }
  }

  static bool _isUrgent(TaskModel task) {
    // Task is urgent if:
    // - Due today or overdue
    // - Has high priority
    // - Due within 2 days
    
    if (task.isOverdue || task.isDueToday) return true;
    if (task.priority == TaskPriority.high) return true;
    
    if (task.dueDate != null) {
      final daysUntilDue = task.dueDate!.difference(DateTime.now()).inDays;
      if (daysUntilDue <= 2) return true;
    }
    
    return false;
  }

  static bool _isImportant(TaskModel task) {
    // Task is important if:
    // - Has high or medium priority
    // - Has subtasks (complex task)
    // - In a key category
    
    if (task.priority == TaskPriority.high || task.priority == TaskPriority.medium) {
      return true;
    }
    
    if (task.completionPercentage > 0) return true; // Has subtasks
    
    return false;
  }

  static Map<EisenhowerQuadrant, List<TaskModel>> groupTasksByQuadrant(
    List<TaskModel> tasks,
  ) {
    final grouped = <EisenhowerQuadrant, List<TaskModel>>{
      EisenhowerQuadrant.urgentImportant: [],
      EisenhowerQuadrant.notUrgentImportant: [],
      EisenhowerQuadrant.urgentNotImportant: [],
      EisenhowerQuadrant.notUrgentNotImportant: [],
    };
    
    for (final task in tasks) {
      if (task.status == TaskStatus.completed) continue;
      
      final quadrant = categorizeTask(task);
      grouped[quadrant]!.add(task);
    }
    
    return grouped;
  }

  static String getQuadrantName(EisenhowerQuadrant quadrant) {
    switch (quadrant) {
      case EisenhowerQuadrant.urgentImportant:
        return 'Do First';
      case EisenhowerQuadrant.notUrgentImportant:
        return 'Schedule';
      case EisenhowerQuadrant.urgentNotImportant:
        return 'Delegate';
      case EisenhowerQuadrant.notUrgentNotImportant:
        return 'Eliminate';
    }
  }

  static String getQuadrantDescription(EisenhowerQuadrant quadrant) {
    switch (quadrant) {
      case EisenhowerQuadrant.urgentImportant:
        return 'Urgent and Important - Do these tasks immediately';
      case EisenhowerQuadrant.notUrgentImportant:
        return 'Not Urgent but Important - Schedule these tasks';
      case EisenhowerQuadrant.urgentNotImportant:
        return 'Urgent but Not Important - Delegate if possible';
      case EisenhowerQuadrant.notUrgentNotImportant:
        return 'Neither Urgent nor Important - Consider eliminating';
    }
  }

  static String getQuadrantEmoji(EisenhowerQuadrant quadrant) {
    switch (quadrant) {
      case EisenhowerQuadrant.urgentImportant:
        return '🔴';
      case EisenhowerQuadrant.notUrgentImportant:
        return '🟡';
      case EisenhowerQuadrant.urgentNotImportant:
        return '🔵';
      case EisenhowerQuadrant.notUrgentNotImportant:
        return '⚪';
    }
  }
}
