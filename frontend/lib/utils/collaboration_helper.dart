class CollaborationHelper {
  // Task sharing and collaboration structure
  // For future implementation with backend sync
  
  // Generate shareable link for task
  static String generateShareableLink(String taskId) {
    return 'todo://share/task/$taskId';
  }

  // Parse shared task link
  static String? parseTaskLink(String link) {
    if (link.startsWith('todo://share/task/')) {
      return link.replaceFirst('todo://share/task/', '');
    }
    return null;
  }

  // Share task via text format
  static String generateTaskShareText(Map<String, dynamic> taskData) {
    final buffer = StringBuffer();
    buffer.writeln('📋 Task: ${taskData['title']}');
    
    if (taskData['description']?.isNotEmpty == true) {
      buffer.writeln('\n📝 ${taskData['description']}');
    }
    
    if (taskData['dueDate'] != null) {
      buffer.writeln('\n📅 Due: ${taskData['dueDate']}');
    }
    
    if (taskData['priority'] != null) {
      buffer.writeln('\n⚠️ Priority: ${taskData['priority']}');
    }
    
    if (taskData['tags'] != null && taskData['tags'].isNotEmpty) {
      buffer.writeln('\n🏷️ Tags: ${taskData['tags'].join(', ')}');
    }
    
    buffer.writeln('\n\nShared from Offline Todo App');
    
    return buffer.toString();
  }

  // Task assignment structure (for future multi-user)
  static Map<String, dynamic> createAssignment({
    required String taskId,
    required String assigneeEmail,
    DateTime? dueDate,
  }) {
    return {
      'taskId': taskId,
      'assigneeEmail': assigneeEmail,
      'assignedAt': DateTime.now().toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'status': 'pending',
    };
  }
}
