import '../models/task_model.dart';

class TaskDependencies {
  // Manage task dependencies (task A must be completed before task B)
  
  static Map<String, List<String>> _dependencies = {};
  
  // Add a dependency (taskId depends on dependsOnTaskId)
  static void addDependency(String taskId, String dependsOnTaskId) {
    if (!_dependencies.containsKey(taskId)) {
      _dependencies[taskId] = [];
    }
    
    if (!_dependencies[taskId]!.contains(dependsOnTaskId)) {
      _dependencies[taskId]!.add(dependsOnTaskId);
    }
  }

  // Remove a dependency
  static void removeDependency(String taskId, String dependsOnTaskId) {
    _dependencies[taskId]?.remove(dependsOnTaskId);
    
    if (_dependencies[taskId]?.isEmpty == true) {
      _dependencies.remove(taskId);
    }
  }

  // Get dependencies for a task
  static List<String> getDependencies(String taskId) {
    return _dependencies[taskId] ?? [];
  }

  // Check if task can be started (all dependencies completed)
  static bool canStartTask(String taskId, List<TaskModel> allTasks) {
    final dependencies = getDependencies(taskId);
    
    if (dependencies.isEmpty) return true;
    
    for (final depId in dependencies) {
      final depTask = allTasks.firstWhere(
        (t) => t.id == depId,
        orElse: () => TaskModel(title: ''),
      );
      
      if (depTask.title.isEmpty || depTask.status != TaskStatus.completed) {
        return false;
      }
    }
    
    return true;
  }

  // Get all blocked tasks (tasks waiting for dependencies)
  static List<String> getBlockedTasks(List<TaskModel> allTasks) {
    final blocked = <String>[];
    
    for (final entry in _dependencies.entries) {
      if (!canStartTask(entry.key, allTasks)) {
        blocked.add(entry.key);
      }
    }
    
    return blocked;
  }

  // Get tasks that are blocking others
  static List<String> getBlockingTasks(List<TaskModel> allTasks) {
    final blocking = <String>{};
    
    for (final entry in _dependencies.entries) {
      for (final depId in entry.value) {
        final depTask = allTasks.firstWhere(
          (t) => t.id == depId,
          orElse: () => TaskModel(title: ''),
        );
        
        if (depTask.title.isNotEmpty && depTask.status != TaskStatus.completed) {
          blocking.add(depId);
        }
      }
    }
    
    return blocking.toList();
  }

  // Get dependency chain (all tasks that depend on this task, recursively)
  static List<String> getDependencyChain(String taskId) {
    final chain = <String>[];
    final queue = [taskId];
    final visited = <String>{};
    
    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      
      if (visited.contains(current)) continue;
      visited.add(current);
      
      // Find tasks that depend on current task
      for (final entry in _dependencies.entries) {
        if (entry.value.contains(current) && !visited.contains(entry.key)) {
          chain.add(entry.key);
          queue.add(entry.key);
        }
      }
    }
    
    return chain;
  }

  // Check for circular dependencies
  static bool hasCircularDependency(String taskId, String dependsOnTaskId) {
    final chain = getDependencyChain(dependsOnTaskId);
    return chain.contains(taskId);
  }

  // Clear all dependencies
  static void clearAll() {
    _dependencies.clear();
  }

  // Export dependencies
  static Map<String, List<String>> exportDependencies() {
    return Map.from(_dependencies);
  }

  // Import dependencies
  static void importDependencies(Map<String, List<String>> deps) {
    _dependencies = Map.from(deps);
  }
}
