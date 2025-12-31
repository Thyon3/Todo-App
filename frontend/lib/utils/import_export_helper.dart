import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';

class ImportExportHelper {
  // Export to CSV format
  static Future<String> exportToCSV(List<TaskModel> tasks) async {
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln('Title,Description,Due Date,Priority,Status,Category,Tags,Created At,Completed');
    
    // Data
    for (final task in tasks) {
      buffer.writeln([
        _escapeCsv(task.title),
        _escapeCsv(task.description),
        task.dueDate?.toIso8601String() ?? '',
        task.priority.name,
        task.status.name,
        task.categoryId ?? '',
        task.tags.join(';'),
        task.createdAt.toIso8601String(),
        task.status == TaskStatus.completed ? 'Yes' : 'No',
      ].join(','));
    }
    
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/tasks_export_$timestamp.csv');
    await file.writeAsString(buffer.toString());
    
    return file.path;
  }

  // Export to iCalendar format (.ics) for calendar integration
  static Future<String> exportToICalendar(List<TaskModel> tasks) async {
    final buffer = StringBuffer();
    
    buffer.writeln('BEGIN:VCALENDAR');
    buffer.writeln('VERSION:2.0');
    buffer.writeln('PRODID:-//Offline Todo App//EN');
    buffer.writeln('CALSCALE:GREGORIAN');
    
    for (final task in tasks) {
      if (task.dueDate != null) {
        buffer.writeln('BEGIN:VTODO');
        buffer.writeln('UID:${task.id}@offlinetodo.app');
        buffer.writeln('DTSTAMP:${_formatICalDateTime(task.createdAt)}');
        buffer.writeln('SUMMARY:${task.title}');
        if (task.description.isNotEmpty) {
          buffer.writeln('DESCRIPTION:${task.description}');
        }
        buffer.writeln('DUE:${_formatICalDateTime(task.dueDate!)}');
        buffer.writeln('PRIORITY:${_getICalPriority(task.priority)}');
        buffer.writeln('STATUS:${task.status == TaskStatus.completed ? 'COMPLETED' : 'NEEDS-ACTION'}');
        buffer.writeln('END:VTODO');
      }
    }
    
    buffer.writeln('END:VCALENDAR');
    
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/tasks_$timestamp.ics');
    await file.writeAsString(buffer.toString());
    
    return file.path;
  }

  // Import from JSON
  static Future<List<TaskModel>> importFromJSON(String filePath) async {
    try {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString);
      
      if (jsonData is Map && jsonData.containsKey('data')) {
        final tasks = jsonData['data']['tasks'] as List;
        return tasks.map((taskMap) => TaskModel.fromMap(taskMap)).toList();
      } else if (jsonData is List) {
        return jsonData.map((taskMap) => TaskModel.fromMap(taskMap)).toList();
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static String _formatICalDateTime(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first + 'Z';
  }

  static int _getICalPriority(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 1;
      case TaskPriority.medium:
        return 5;
      case TaskPriority.low:
        return 9;
    }
  }
}
