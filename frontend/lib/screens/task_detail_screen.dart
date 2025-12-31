import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../models/subtask_model.dart';
import '../providers/task_provider.dart';
import '../providers/category_provider.dart';
import '../config/app_theme.dart';
import 'add_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(taskToEdit: task),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteTask(context),
          ),
        ],
      ),
      body: Consumer2<TaskProvider, CategoryProvider>(
        builder: (context, taskProvider, categoryProvider, _) {
          final category = task.categoryId != null
              ? categoryProvider.getCategoryById(task.categoryId!)
              : null;
          final subtasks = taskProvider.getSubTasks(task.id);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and status
                Row(
                  children: [
                    Checkbox(
                      value: task.status == TaskStatus.completed,
                      onChanged: (value) {
                        taskProvider.toggleTaskCompletion(task.id);
                      },
                    ),
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          decoration: task.status == TaskStatus.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Priority badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.getPriorityColor(task.priority.index)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.getPriorityColor(task.priority.index),
                        ),
                      ),
                      child: Text(
                        task.priority.name.toUpperCase(),
                        style: TextStyle(
                          color: AppTheme.getPriorityColor(task.priority.index),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (category != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: category.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: category.color),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(category.icon, size: 16, color: category.color),
                            const SizedBox(width: 4),
                            Text(
                              category.name,
                              style: TextStyle(
                                color: category.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Description
                if (task.description.isNotEmpty) ...[
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Due date
                if (task.dueDate != null) ...[
                  _buildInfoRow(
                    context,
                    icon: Icons.calendar_today,
                    label: 'Due Date',
                    value: DateFormat('MMM dd, yyyy').format(task.dueDate!),
                    color: task.isOverdue ? Colors.red : null,
                  ),
                ],
                
                // Reminder
                if (task.hasReminder && task.reminderTime != null) ...[
                  _buildInfoRow(
                    context,
                    icon: Icons.notifications_active,
                    label: 'Reminder',
                    value: DateFormat('MMM dd, yyyy - hh:mm a')
                        .format(task.reminderTime!),
                  ),
                ],
                
                // Recurring
                if (task.isRecurring && task.recurringPattern != null) ...[
                  _buildInfoRow(
                    context,
                    icon: Icons.repeat,
                    label: 'Recurring',
                    value: task.recurringPattern!,
                  ),
                ],
                
                // Tags
                if (task.tags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Tags',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: task.tags.map((tag) {
                      return Chip(
                        label: Text('#$tag'),
                        backgroundColor: Colors.blue.withOpacity(0.1),
                      );
                    }).toList(),
                  ),
                ],
                
                // Subtasks
                if (subtasks.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtasks',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${subtasks.where((st) => st.isCompleted).length}/${subtasks.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...subtasks.map((subtask) {
                    return CheckboxListTile(
                      title: Text(
                        subtask.title,
                        style: TextStyle(
                          decoration: subtask.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      value: subtask.isCompleted,
                      onChanged: (value) {
                        taskProvider.toggleSubTaskCompletion(
                          subtask.id,
                          task.id,
                        );
                      },
                    );
                  }).toList(),
                ],
                
                // Notes
                if (task.notes != null && task.notes!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.notes!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
                
                const SizedBox(height: 24),
                
                // Metadata
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Created: ${DateFormat('MMM dd, yyyy - hh:mm a').format(task.createdAt)}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  'Updated: ${DateFormat('MMM dd, yyyy - hh:mm a').format(task.updatedAt)}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTask(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await context.read<TaskProvider>().deleteTask(task.id);
      if (success && context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted')),
        );
      }
    }
  }
}
