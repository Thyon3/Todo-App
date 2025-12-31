import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/task_provider.dart';
import '../providers/category_provider.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            title: 'Appearance',
            children: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  return SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Enable dark theme'),
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                  );
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Notifications',
            children: [
              FutureBuilder<int>(
                future: NotificationService.instance.getScheduledNotificationsCount(),
                builder: (context, snapshot) {
                  return ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Scheduled Notifications'),
                    subtitle: Text(
                      snapshot.hasData 
                          ? '${snapshot.data} active reminders' 
                          : 'Loading...',
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.notification_add),
                title: const Text('Request Permissions'),
                subtitle: const Text('Allow notifications'),
                onTap: () async {
                  await NotificationService.instance.requestPermissions();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification permissions updated')),
                  );
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Data Management',
            children: [
              ListTile(
                leading: const Icon(Icons.backup),
                title: const Text('Export Data'),
                subtitle: const Text('Backup your tasks to JSON'),
                onTap: () => _exportData(context),
              ),
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Share Backup'),
                subtitle: const Text('Share tasks via other apps'),
                onTap: () => _shareBackup(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Clear All Data'),
                subtitle: const Text('Delete all tasks and categories'),
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () => _clearAllData(context),
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Statistics',
            children: [
              Consumer<TaskProvider>(
                builder: (context, taskProvider, _) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.task),
                        title: const Text('Total Tasks'),
                        trailing: Text(
                          '${taskProvider.allTasks.length}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.green),
                        title: const Text('Completed'),
                        trailing: Text(
                          '${taskProvider.completedTasksCount}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.pending, color: Colors.orange),
                        title: const Text('Pending'),
                        trailing: Text(
                          '${taskProvider.pendingTasksCount}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'About',
            children: [
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('Version'),
                subtitle: Text('1.0.0'),
              ),
              const ListTile(
                leading: Icon(Icons.code),
                title: Text('Built with Flutter'),
                subtitle: Text('Offline-first Todo App'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Future<void> _exportData(BuildContext context) async {
    try {
      final taskProvider = context.read<TaskProvider>();
      final categoryProvider = context.read<CategoryProvider>();

      final data = {
        'version': '1.0.0',
        'exportDate': DateTime.now().toIso8601String(),
        'tasks': taskProvider.allTasks.map((task) => task.toMap()).toList(),
        'categories': categoryProvider.categories.map((cat) => cat.toMap()).toList(),
      };

      final jsonString = jsonEncode(data);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/todo_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonString);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup saved to: ${file.path}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _shareBackup(BuildContext context) async {
    try {
      final taskProvider = context.read<TaskProvider>();
      final categoryProvider = context.read<CategoryProvider>();

      final data = {
        'version': '1.0.0',
        'exportDate': DateTime.now().toIso8601String(),
        'tasks': taskProvider.allTasks.map((task) => task.toMap()).toList(),
        'categories': categoryProvider.categories.map((cat) => cat.toMap()).toList(),
      };

      final jsonString = jsonEncode(data);
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/todo_backup.json');
      await file.writeAsString(jsonString);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Todo App Backup',
        text: 'My todo list backup from ${DateTime.now()}',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Share failed: $e')),
        );
      }
    }
  }

  Future<void> _clearAllData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to delete all tasks and categories? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final taskProvider = context.read<TaskProvider>();
        final allTaskIds = taskProvider.allTasks.map((t) => t.id).toList();
        await taskProvider.deleteTasks(allTaskIds);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All data cleared successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to clear data: $e')),
          );
        }
      }
    }
  }
}
