import '../models/subtask_model.dart';
import 'database_helper.dart';

class SubTaskService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create a new subtask
  Future<SubTaskModel> createSubTask(SubTaskModel subtask) async {
    final db = await _dbHelper.database;
    await db.insert('subtasks', subtask.toMap());
    return subtask;
  }

  // Get all subtasks for a task
  Future<List<SubTaskModel>> getSubTasksByTaskId(String taskId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'subtasks',
      where: 'taskId = ?',
      whereArgs: [taskId],
      orderBy: 'orderIndex ASC',
    );
    return List.generate(maps.length, (i) => SubTaskModel.fromMap(maps[i]));
  }

  // Get subtask by ID
  Future<SubTaskModel?> getSubTaskById(String id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'subtasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return SubTaskModel.fromMap(maps.first);
  }

  // Update subtask
  Future<int> updateSubTask(SubTaskModel subtask) async {
    final db = await _dbHelper.database;
    return await db.update(
      'subtasks',
      subtask.toMap(),
      where: 'id = ?',
      whereArgs: [subtask.id],
    );
  }

  // Toggle subtask completion
  Future<int> toggleSubTaskCompletion(String subtaskId) async {
    final subtask = await getSubTaskById(subtaskId);
    if (subtask == null) return 0;
    
    final updatedSubTask = subtask.copyWith(
      isCompleted: !subtask.isCompleted,
    );
    
    return await updateSubTask(updatedSubTask);
  }

  // Delete subtask
  Future<int> deleteSubTask(String id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'subtasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all subtasks for a task
  Future<int> deleteSubTasksByTaskId(String taskId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'subtasks',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
  }

  // Get subtask completion percentage for a task
  Future<int> getSubTaskCompletionPercentage(String taskId) async {
    final subtasks = await getSubTasksByTaskId(taskId);
    if (subtasks.isEmpty) return 0;
    
    final completedCount = subtasks.where((st) => st.isCompleted).length;
    return ((completedCount / subtasks.length) * 100).round();
  }

  // Reorder subtasks
  Future<void> reorderSubTasks(List<SubTaskModel> subtasks) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    
    for (int i = 0; i < subtasks.length; i++) {
      final updatedSubTask = subtasks[i].copyWith(orderIndex: i);
      batch.update(
        'subtasks',
        updatedSubTask.toMap(),
        where: 'id = ?',
        whereArgs: [updatedSubTask.id],
      );
    }
    
    await batch.commit(noResult: true);
  }
}
