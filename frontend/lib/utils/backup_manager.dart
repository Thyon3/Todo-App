import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';
import '../models/category_model.dart';

class BackupManager {
  static Future<String> createBackup({
    required List<TaskModel> tasks,
    required List<CategoryModel> categories,
  }) async {
    final backup = {
      'version': '1.0.0',
      'timestamp': DateTime.now().toIso8601String(),
      'tasksCount': tasks.length,
      'categoriesCount': categories.length,
      'data': {
        'tasks': tasks.map((t) => t.toMap()).toList(),
        'categories': categories.map((c) => c.toMap()).toList(),
      },
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(backup);
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/backup_$timestamp.json');
    
    await file.writeAsString(jsonString);
    return file.path;
  }

  static Future<Map<String, dynamic>?> loadBackup(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;
      
      final jsonString = await file.readAsString();
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  static Future<List<String>> listBackups() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupFiles = directory
        .listSync()
        .where((file) => file.path.contains('backup_') && file.path.endsWith('.json'))
        .map((file) => file.path)
        .toList();
    
    backupFiles.sort((a, b) => b.compareTo(a)); // Most recent first
    return backupFiles;
  }

  static Future<bool> deleteBackup(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static String getBackupFileName(String filePath) {
    final parts = filePath.split('/');
    return parts.last;
  }

  static DateTime? getBackupDate(String filePath) {
    try {
      final fileName = getBackupFileName(filePath);
      final timestamp = int.parse(
        fileName.replaceAll('backup_', '').replaceAll('.json', ''),
      );
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      return null;
    }
  }
}
