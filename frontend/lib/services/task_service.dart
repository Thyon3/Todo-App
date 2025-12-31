import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';
import '../models/subtask_model.dart';
import 'database_helper.dart';

class TaskService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create a new task
  Future<TaskModel> createTask(TaskModel task) async {
    final db = await _dbHelper.database;
    await db.insert('tasks', task.toMap());
    return task;
  }

  // Get all tasks
  Future<List<TaskModel>> getAllTasks() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  // Get task by ID
  Future<TaskModel?> getTaskById(String id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return TaskModel.fromMap(maps.first);
  }

  // Get tasks by status
  Future<List<TaskModel>> getTasksByStatus(TaskStatus status) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'status = ?',
      whereArgs: [status.index],
      orderBy: 'dueDate ASC',
    );
    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  // Get tasks by priority
  Future<List<TaskModel>> getTasksByPriority(TaskPriority priority) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'priority = ?',
      whereArgs: [priority.index],
      orderBy: 'dueDate ASC',
    );
    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  // Get tasks by category
  Future<List<TaskModel>> getTasksByCategory(String categoryId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
      orderBy: 'dueDate ASC',
    );
    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  // Get tasks due today
  Future<List<TaskModel>> getTasksDueToday() async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();
    
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'dueDate >= ? AND dueDate <= ? AND status != ?',
      whereArgs: [startOfDay, endOfDay, TaskStatus.completed.index],
      orderBy: 'dueDate ASC',
    );
    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  // Get overdue tasks
  Future<List<TaskModel>> getOverdueTasks() async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'dueDate < ? AND status != ?',
      whereArgs: [now, TaskStatus.completed.index],
      orderBy: 'dueDate ASC',
    );
    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  // Search tasks
  Future<List<TaskModel>> searchTasks(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'title LIKE ? OR description LIKE ? OR tags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  // Update task
  Future<int> updateTask(TaskModel task) async {
    final db = await _dbHelper.database;
    final updatedTask = task.copyWith(updatedAt: DateTime.now());
    return await db.update(
      'tasks',
      updatedTask.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Toggle task completion
  Future<int> toggleTaskCompletion(String taskId) async {
    final task = await getTaskById(taskId);
    if (task == null) return 0;
    
    final newStatus = task.status == TaskStatus.completed 
        ? TaskStatus.pending 
        : TaskStatus.completed;
    
    final updatedTask = task.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    
    return await updateTask(updatedTask);
  }

  // Delete task
  Future<int> deleteTask(String id) async {
    final db = await _dbHelper.database;
    // Subtasks will be deleted automatically due to CASCADE
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Batch delete tasks
  Future<void> deleteTasks(List<String> ids) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (final id in ids) {
      batch.delete('tasks', where: 'id = ?', whereArgs: [id]);
    }
    await batch.commit(noResult: true);
  }

  // Get tasks count by status
  Future<Map<TaskStatus, int>> getTasksCountByStatus() async {
    final db = await _dbHelper.database;
    final result = <TaskStatus, int>{};
    
    for (final status in TaskStatus.values) {
      final count = Sqflite.firstIntValue(
        await db.rawQuery(
          'SELECT COUNT(*) FROM tasks WHERE status = ?',
          [status.index],
        ),
      );
      result[status] = count ?? 0;
    }
    
    return result;
  }

  // Get completion statistics for a date range
  Future<Map<String, dynamic>> getCompletionStats(
      DateTime startDate, DateTime endDate) async {
    final db = await _dbHelper.database;
    
    final completed = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM tasks WHERE status = ? AND updatedAt >= ? AND updatedAt <= ?',
        [TaskStatus.completed.index, startDate.toIso8601String(), endDate.toIso8601String()],
      ),
    ) ?? 0;
    
    final total = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM tasks WHERE createdAt >= ? AND createdAt <= ?',
        [startDate.toIso8601String(), endDate.toIso8601String()],
      ),
    ) ?? 0;
    
    return {
      'completed': completed,
      'total': total,
      'percentage': total > 0 ? (completed / total * 100).round() : 0,
    };
  }
}
