import '../models/task_model.dart';

class SmartSuggestions {
  // AI-like smart suggestions based on user patterns
  
  // Suggest best time to schedule a task
  static String suggestBestTime(List<TaskModel> completedTasks) {
    final hourCounts = <int, int>{};
    
    for (final task in completedTasks) {
      final hour = task.updatedAt.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }
    
    if (hourCounts.isEmpty) return 'Morning (9 AM)';
    
    final bestHour = hourCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    
    if (bestHour < 12) return 'Morning ($bestHour AM)';
    if (bestHour < 17) return 'Afternoon (${bestHour - 12} PM)';
    return 'Evening (${bestHour - 12} PM)';
  }

  // Suggest task category based on title/description
  static String? suggestCategory(
    String taskTitle,
    String taskDescription,
    Map<String, List<String>> categoryKeywords,
  ) {
    final text = '$taskTitle $taskDescription'.toLowerCase();
    
    for (final entry in categoryKeywords.entries) {
      for (final keyword in entry.value) {
        if (text.contains(keyword.toLowerCase())) {
          return entry.key;
        }
      }
    }
    
    return null;
  }

  // Suggest priority based on keywords
  static TaskPriority suggestPriority(String taskTitle, String taskDescription) {
    final text = '$taskTitle $taskDescription'.toLowerCase();
    
    const highPriorityKeywords = [
      'urgent', 'asap', 'critical', 'important', 'emergency', 
      'deadline', 'immediately', 'priority'
    ];
    
    const lowPriorityKeywords = [
      'someday', 'maybe', 'eventually', 'when free', 'optional'
    ];
    
    for (final keyword in highPriorityKeywords) {
      if (text.contains(keyword)) return TaskPriority.high;
    }
    
    for (final keyword in lowPriorityKeywords) {
      if (text.contains(keyword)) return TaskPriority.low;
    }
    
    return TaskPriority.medium;
  }

  // Suggest due date based on task content
  static DateTime? suggestDueDate(String taskTitle, String taskDescription) {
    final text = '$taskTitle $taskDescription'.toLowerCase();
    final now = DateTime.now();
    
    if (text.contains('today')) {
      return now;
    } else if (text.contains('tomorrow')) {
      return now.add(const Duration(days: 1));
    } else if (text.contains('next week')) {
      return now.add(const Duration(days: 7));
    } else if (text.contains('next month')) {
      return DateTime(now.year, now.month + 1, now.day);
    } else if (text.contains('weekend')) {
      final daysUntilSaturday = (DateTime.saturday - now.weekday + 7) % 7;
      return now.add(Duration(days: daysUntilSaturday));
    }
    
    return null;
  }

  // Suggest tags based on content
  static List<String> suggestTags(String taskTitle, String taskDescription) {
    final text = '$taskTitle $taskDescription'.toLowerCase();
    final suggestions = <String>[];
    
    final tagPatterns = {
      'meeting': ['meeting', 'call', 'conference'],
      'email': ['email', 'send', 'reply'],
      'shopping': ['buy', 'purchase', 'shop'],
      'reading': ['read', 'book', 'article'],
      'coding': ['code', 'develop', 'program', 'debug'],
      'design': ['design', 'mockup', 'wireframe'],
      'writing': ['write', 'blog', 'document'],
      'research': ['research', 'investigate', 'study'],
    };
    
    for (final entry in tagPatterns.entries) {
      for (final keyword in entry.value) {
        if (text.contains(keyword) && !suggestions.contains(entry.key)) {
          suggestions.add(entry.key);
        }
      }
    }
    
    return suggestions;
  }

  // Suggest similar tasks based on current task
  static List<TaskModel> findSimilarTasks(
    TaskModel currentTask,
    List<TaskModel> allTasks,
  ) {
    final similar = <TaskModel>[];
    
    for (final task in allTasks) {
      if (task.id == currentTask.id) continue;
      
      int similarityScore = 0;
      
      // Same category
      if (task.categoryId == currentTask.categoryId && currentTask.categoryId != null) {
        similarityScore += 3;
      }
      
      // Same priority
      if (task.priority == currentTask.priority) {
        similarityScore += 2;
      }
      
      // Common tags
      final commonTags = task.tags.where((tag) => currentTask.tags.contains(tag)).length;
      similarityScore += commonTags;
      
      // Similar title words
      final currentWords = currentTask.title.toLowerCase().split(' ');
      final taskWords = task.title.toLowerCase().split(' ');
      final commonWords = currentWords.where((word) => 
        word.length > 3 && taskWords.contains(word)
      ).length;
      similarityScore += commonWords;
      
      if (similarityScore >= 3) {
        similar.add(task);
      }
    }
    
    similar.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return similar.take(5).toList();
  }

  // Suggest optimal task breakdown for large tasks
  static List<String> suggestSubtasks(String taskTitle, String taskDescription) {
    final suggestions = <String>[];
    
    // If description mentions steps or phases
    if (taskDescription.toLowerCase().contains('step') ||
        taskDescription.toLowerCase().contains('phase')) {
      suggestions.add('Research and planning');
      suggestions.add('Implementation');
      suggestions.add('Testing and review');
      suggestions.add('Final adjustments');
    }
    
    // For project-related tasks
    if (taskTitle.toLowerCase().contains('project')) {
      suggestions.add('Define project scope');
      suggestions.add('Create timeline');
      suggestions.add('Assign responsibilities');
      suggestions.add('Track progress');
      suggestions.add('Complete documentation');
    }
    
    return suggestions;
  }
}
