import '../models/task_model.dart';

class BatchOperations {
  // Batch operations for multiple tasks
  
  static Future<int> markMultipleAsComplete(
    List<String> taskIds,
    Future<bool> Function(String) markCompleteFunc,
  ) async {
    int successCount = 0;
    for (final id in taskIds) {
      final success = await markCompleteFunc(id);
      if (success) successCount++;
    }
    return successCount;
  }

  static Future<int> deleteMultipleTasks(
    List<String> taskIds,
    Future<bool> Function(String) deleteFunc,
  ) async {
    int successCount = 0;
    for (final id in taskIds) {
      final success = await deleteFunc(id);
      if (success) successCount++;
    }
    return successCount;
  }

  static Future<int> updateMultipleTasksCategory(
    List<String> taskIds,
    String newCategoryId,
    Future<bool> Function(TaskModel) updateFunc,
    Future<TaskModel?> Function(String) getTaskFunc,
  ) async {
    int successCount = 0;
    for (final id in taskIds) {
      final task = await getTaskFunc(id);
      if (task != null) {
        final updatedTask = task.copyWith(categoryId: newCategoryId);
        final success = await updateFunc(updatedTask);
        if (success) successCount++;
      }
    }
    return successCount;
  }

  static Future<int> updateMultipleTasksPriority(
    List<String> taskIds,
    TaskPriority newPriority,
    Future<bool> Function(TaskModel) updateFunc,
    Future<TaskModel?> Function(String) getTaskFunc,
  ) async {
    int successCount = 0;
    for (final id in taskIds) {
      final task = await getTaskFunc(id);
      if (task != null) {
        final updatedTask = task.copyWith(priority: newPriority);
        final success = await updateFunc(updatedTask);
        if (success) successCount++;
      }
    }
    return successCount;
  }

  static Future<List<TaskModel>> duplicateMultipleTasks(
    List<TaskModel> tasks,
    Future<bool> Function(TaskModel) createFunc,
  ) async {
    final duplicatedTasks = <TaskModel>[];
    
    for (final task in tasks) {
      final duplicated = TaskModel(
        title: '${task.title} (Copy)',
        description: task.description,
        priority: task.priority,
        categoryId: task.categoryId,
        tags: List.from(task.tags),
        dueDate: task.dueDate,
      );
      
      final success = await createFunc(duplicated);
      if (success) {
        duplicatedTasks.add(duplicated);
      }
    }
    
    return duplicatedTasks;
  }

  // Archive completed tasks older than specified days
  static List<TaskModel> getTasksToArchive(
    List<TaskModel> tasks,
    int daysOld,
  ) {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    
    return tasks.where((task) {
      return task.status == TaskStatus.completed &&
          task.updatedAt.isBefore(cutoffDate);
    }).toList();
  }

  // Move tasks between categories
  static Future<int> moveTasks(
    List<String> taskIds,
    String fromCategoryId,
    String toCategoryId,
    Future<bool> Function(TaskModel) updateFunc,
    Future<TaskModel?> Function(String) getTaskFunc,
  ) async {
    int successCount = 0;
    
    for (final id in taskIds) {
      final task = await getTaskFunc(id);
      if (task != null && task.categoryId == fromCategoryId) {
        final updatedTask = task.copyWith(categoryId: toCategoryId);
        final success = await updateFunc(updatedTask);
        if (success) successCount++;
      }
    }
    
    return successCount;
  }
}
