import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../models/subtask_model.dart';
import '../services/task_service.dart';
import '../services/subtask_service.dart';
import '../services/notification_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();
  final SubTaskService _subTaskService = SubTaskService();
  final NotificationService _notificationService = NotificationService.instance;

  List<TaskModel> _tasks = [];
  List<TaskModel> _filteredTasks = [];
  Map<String, List<SubTaskModel>> _subtasksMap = {};
  
  bool _isLoading = false;
  String? _error;
  
  // Filter and sort options
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  String? _categoryFilter;
  String _searchQuery = '';
  TaskSortOption _sortOption = TaskSortOption.dueDate;

  // Getters
  List<TaskModel> get tasks => _filteredTasks;
  List<TaskModel> get allTasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  TaskStatus? get statusFilter => _statusFilter;
  TaskPriority? get priorityFilter => _priorityFilter;
  String? get categoryFilter => _categoryFilter;
  String get searchQuery => _searchQuery;
  TaskSortOption get sortOption => _sortOption;

  // Get subtasks for a task
  List<SubTaskModel> getSubTasks(String taskId) {
    return _subtasksMap[taskId] ?? [];
  }

  // Initialize and load tasks
  Future<void> initialize() async {
    await loadTasks();
    await _notificationService.initialize();
  }

  // Load all tasks
  Future<void> loadTasks() async {
    _setLoading(true);
    try {
      _tasks = await _taskService.getAllTasks();
      
      // Load subtasks for all tasks
      for (final task in _tasks) {
        final subtasks = await _subTaskService.getSubTasksByTaskId(task.id);
        _subtasksMap[task.id] = subtasks;
      }
      
      _applyFiltersAndSort();
      _error = null;
    } catch (e) {
      _error = 'Failed to load tasks: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Create a new task
  Future<bool> createTask(TaskModel task) async {
    try {
      final createdTask = await _taskService.createTask(task);
      _tasks.insert(0, createdTask);
      
      // Schedule notification if enabled
      if (task.hasReminder && task.reminderTime != null) {
        await _notificationService.scheduleTaskNotification(task);
      }
      
      _applyFiltersAndSort();
      return true;
    } catch (e) {
      _error = 'Failed to create task: $e';
      notifyListeners();
      return false;
    }
  }

  // Update a task
  Future<bool> updateTask(TaskModel task) async {
    try {
      await _taskService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      }
      
      // Update notification
      await _notificationService.cancelTaskNotification(task.id);
      if (task.hasReminder && task.reminderTime != null && task.status != TaskStatus.completed) {
        await _notificationService.scheduleTaskNotification(task);
      }
      
      _applyFiltersAndSort();
      return true;
    } catch (e) {
      _error = 'Failed to update task: $e';
      notifyListeners();
      return false;
    }
  }

  // Toggle task completion
  Future<bool> toggleTaskCompletion(String taskId) async {
    try {
      await _taskService.toggleTaskCompletion(taskId);
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        final task = _tasks[index];
        final newStatus = task.status == TaskStatus.completed 
            ? TaskStatus.pending 
            : TaskStatus.completed;
        _tasks[index] = task.copyWith(status: newStatus);
        
        // Cancel notification if completed
        if (newStatus == TaskStatus.completed) {
          await _notificationService.cancelTaskNotification(taskId);
        }
      }
      
      _applyFiltersAndSort();
      return true;
    } catch (e) {
      _error = 'Failed to toggle task: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete a task
  Future<bool> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      _tasks.removeWhere((t) => t.id == taskId);
      _subtasksMap.remove(taskId);
      
      // Cancel notification
      await _notificationService.cancelTaskNotification(taskId);
      
      _applyFiltersAndSort();
      return true;
    } catch (e) {
      _error = 'Failed to delete task: $e';
      notifyListeners();
      return false;
    }
  }

  // Batch delete tasks
  Future<bool> deleteTasks(List<String> taskIds) async {
    try {
      await _taskService.deleteTasks(taskIds);
      _tasks.removeWhere((t) => taskIds.contains(t.id));
      for (final id in taskIds) {
        _subtasksMap.remove(id);
        await _notificationService.cancelTaskNotification(id);
      }
      
      _applyFiltersAndSort();
      return true;
    } catch (e) {
      _error = 'Failed to delete tasks: $e';
      notifyListeners();
      return false;
    }
  }

  // Create a subtask
  Future<bool> createSubTask(SubTaskModel subtask) async {
    try {
      final created = await _subTaskService.createSubTask(subtask);
      if (!_subtasksMap.containsKey(subtask.taskId)) {
        _subtasksMap[subtask.taskId] = [];
      }
      _subtasksMap[subtask.taskId]!.add(created);
      
      // Update task completion percentage
      await _updateTaskCompletionPercentage(subtask.taskId);
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to create subtask: $e';
      notifyListeners();
      return false;
    }
  }

  // Toggle subtask completion
  Future<bool> toggleSubTaskCompletion(String subtaskId, String taskId) async {
    try {
      await _subTaskService.toggleSubTaskCompletion(subtaskId);
      final subtasks = _subtasksMap[taskId];
      if (subtasks != null) {
        final index = subtasks.indexWhere((st) => st.id == subtaskId);
        if (index != -1) {
          subtasks[index] = subtasks[index].copyWith(
            isCompleted: !subtasks[index].isCompleted,
          );
        }
      }
      
      // Update task completion percentage
      await _updateTaskCompletionPercentage(taskId);
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to toggle subtask: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete subtask
  Future<bool> deleteSubTask(String subtaskId, String taskId) async {
    try {
      await _subTaskService.deleteSubTask(subtaskId);
      _subtasksMap[taskId]?.removeWhere((st) => st.id == subtaskId);
      
      // Update task completion percentage
      await _updateTaskCompletionPercentage(taskId);
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete subtask: $e';
      notifyListeners();
      return false;
    }
  }

  // Update task completion percentage based on subtasks
  Future<void> _updateTaskCompletionPercentage(String taskId) async {
    final percentage = await _subTaskService.getSubTaskCompletionPercentage(taskId);
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
        completionPercentage: percentage,
      );
      await _taskService.updateTask(_tasks[taskIndex]);
    }
  }

  // Filter methods
  void setStatusFilter(TaskStatus? status) {
    _statusFilter = status;
    _applyFiltersAndSort();
  }

  void setPriorityFilter(TaskPriority? priority) {
    _priorityFilter = priority;
    _applyFiltersAndSort();
  }

  void setCategoryFilter(String? categoryId) {
    _categoryFilter = categoryId;
    _applyFiltersAndSort();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
  }

  void setSortOption(TaskSortOption option) {
    _sortOption = option;
    _applyFiltersAndSort();
  }

  void clearFilters() {
    _statusFilter = null;
    _priorityFilter = null;
    _categoryFilter = null;
    _searchQuery = '';
    _applyFiltersAndSort();
  }

  // Apply filters and sorting
  void _applyFiltersAndSort() {
    _filteredTasks = List.from(_tasks);

    // Apply status filter
    if (_statusFilter != null) {
      _filteredTasks = _filteredTasks
          .where((task) => task.status == _statusFilter)
          .toList();
    }

    // Apply priority filter
    if (_priorityFilter != null) {
      _filteredTasks = _filteredTasks
          .where((task) => task.priority == _priorityFilter)
          .toList();
    }

    // Apply category filter
    if (_categoryFilter != null) {
      _filteredTasks = _filteredTasks
          .where((task) => task.categoryId == _categoryFilter)
          .toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      _filteredTasks = _filteredTasks.where((task) {
        return task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            task.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            task.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    // Apply sorting
    _sortTasks();

    notifyListeners();
  }

  void _sortTasks() {
    switch (_sortOption) {
      case TaskSortOption.dueDate:
        _filteredTasks.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case TaskSortOption.priority:
        _filteredTasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case TaskSortOption.title:
        _filteredTasks.sort((a, b) => a.title.compareTo(b.title));
        break;
      case TaskSortOption.createdDate:
        _filteredTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
  }

  // Get tasks by category
  List<TaskModel> getTasksByCategory(String categoryId) {
    return _tasks.where((task) => task.categoryId == categoryId).toList();
  }

  // Get today's tasks
  List<TaskModel> get todaysTasks {
    return _tasks.where((task) => task.isDueToday).toList();
  }

  // Get overdue tasks
  List<TaskModel> get overdueTasks {
    return _tasks.where((task) => task.isOverdue).toList();
  }

  // Get completed tasks count
  int get completedTasksCount {
    return _tasks.where((task) => task.status == TaskStatus.completed).length;
  }

  // Get pending tasks count
  int get pendingTasksCount {
    return _tasks.where((task) => task.status == TaskStatus.pending).length;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

// Sort options enum
enum TaskSortOption {
  dueDate,
  priority,
  title,
  createdDate,
}
