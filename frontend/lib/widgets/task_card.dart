import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vibration/vibration.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../config/app_theme.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback onComplete;
  final VoidCallback onDelete;
  final String? categoryName;
  final Color? categoryColor;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onComplete,
    required this.onDelete,
    this.categoryName,
    this.categoryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) {
              _triggerHaptic();
              onDelete();
            },
            backgroundColor: AppTheme.errorLight,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) {
              _triggerHaptic();
              onComplete();
            },
            backgroundColor: AppTheme.statusCompleted,
            foregroundColor: Colors.white,
            icon: task.status == TaskStatus.completed 
                ? Icons.undo 
                : Icons.check,
            label: task.status == TaskStatus.completed ? 'Undo' : 'Done',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with checkbox and priority
                Row(
                  children: [
                    // Checkbox
                    Checkbox(
                      value: task.status == TaskStatus.completed,
                      onChanged: (value) {
                        _triggerHaptic();
                        onComplete();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Title
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: task.status == TaskStatus.completed
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.status == TaskStatus.completed
                              ? Colors.grey
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Priority indicator
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.getPriorityColor(task.priority.index),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                
                // Description
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 56),
                    child: Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                
                // Progress bar for subtasks
                if (task.completionPercentage > 0) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 56),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${task.completionPercentage}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: task.completionPercentage / 100,
                            minHeight: 6,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Footer with category, date, and tags
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 56),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Category badge
                      if (categoryName != null) ...[
                        _buildBadge(
                          label: categoryName!,
                          color: categoryColor ?? Colors.grey,
                          icon: Icons.label,
                        ),
                      ],
                      
                      // Due date
                      if (task.dueDate != null) ...[
                        _buildBadge(
                          label: _formatDueDate(task.dueDate!),
                          color: task.isOverdue
                              ? AppTheme.errorLight
                              : task.isDueToday
                                  ? AppTheme.priorityMedium
                                  : Colors.grey,
                          icon: Icons.calendar_today,
                        ),
                      ],
                      
                      // Reminder indicator
                      if (task.hasReminder) ...[
                        _buildBadge(
                          label: 'Reminder',
                          color: AppTheme.primaryLight,
                          icon: Icons.notifications_active,
                        ),
                      ],
                      
                      // Recurring indicator
                      if (task.isRecurring) ...[
                        _buildBadge(
                          label: 'Recurring',
                          color: AppTheme.secondaryLight,
                          icon: Icons.repeat,
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Tags
                if (task.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 56),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: task.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '#$tag',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == tomorrow) {
      return 'Tomorrow';
    } else if (dateOnly.isBefore(today)) {
      return 'Overdue';
    } else {
      return DateFormat('MMM dd').format(date);
    }
  }

  Future<void> _triggerHaptic() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }
  }
}
