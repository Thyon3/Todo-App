import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../models/subtask_model.dart';
import '../providers/task_provider.dart';
import '../providers/category_provider.dart';
import '../config/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? taskToEdit;

  const AddTaskScreen({Key? key, this.taskToEdit}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TaskPriority _selectedPriority = TaskPriority.medium;
  String? _selectedCategoryId;
  bool _hasReminder = false;
  DateTime? _reminderDateTime;
  bool _isRecurring = false;
  String? _recurringPattern;
  
  List<String> _tags = [];
  final _tagController = TextEditingController();
  
  List<SubTaskModel> _subtasks = [];
  final _subtaskController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      _loadTaskData(widget.taskToEdit!);
    }
  }

  void _loadTaskData(TaskModel task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _notesController.text = task.notes ?? '';
    _selectedDate = task.dueDate;
    _selectedTime = task.dueTime != null 
        ? TimeOfDay.fromDateTime(task.dueTime!) 
        : null;
    _selectedPriority = task.priority;
    _selectedCategoryId = task.categoryId;
    _hasReminder = task.hasReminder;
    _reminderDateTime = task.reminderTime;
    _isRecurring = task.isRecurring;
    _recurringPattern = task.recurringPattern;
    _tags = List.from(task.tags);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _tagController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskToEdit == null ? 'Add Task' : 'Edit Task'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveTask,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter task title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: 16),
            
            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task description',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: 24),
            
            // Priority selector
            const Text(
              'Priority',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildPriorityButton(
                    TaskPriority.low,
                    'Low',
                    AppTheme.priorityLow,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPriorityButton(
                    TaskPriority.medium,
                    'Medium',
                    AppTheme.priorityMedium,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPriorityButton(
                    TaskPriority.high,
                    'High',
                    AppTheme.priorityHigh,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Category selector
            const Text(
              'Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Consumer<CategoryProvider>(
              builder: (context, categoryProvider, _) {
                return DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category),
                    hintText: 'Select a category',
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('No Category'),
                    ),
                    ...categoryProvider.categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: category.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(category.name),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Date and time picker
            const Text(
              'Due Date & Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectedDate == null ? null : _selectTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      _selectedTime == null
                          ? 'Select Time'
                          : _selectedTime!.format(context),
                    ),
                  ),
                ),
              ],
            ),
            
            if (_selectedDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                      _selectedTime = null;
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Date'),
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Reminder toggle
            SwitchListTile(
              title: const Text('Set Reminder'),
              subtitle: _reminderDateTime != null
                  ? Text(DateFormat('MMM dd, yyyy - hh:mm a')
                      .format(_reminderDateTime!))
                  : null,
              value: _hasReminder,
              onChanged: (value) {
                setState(() {
                  _hasReminder = value;
                  if (value && _reminderDateTime == null) {
                    _selectReminderDateTime();
                  }
                });
              },
            ),
            
            // Recurring toggle
            SwitchListTile(
              title: const Text('Recurring Task'),
              subtitle: _recurringPattern != null
                  ? Text(_recurringPattern!)
                  : null,
              value: _isRecurring,
              onChanged: (value) {
                setState(() {
                  _isRecurring = value;
                  if (value) {
                    _selectRecurringPattern();
                  }
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Tags section
            const Text(
              'Tags',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._tags.map((tag) {
                  return Chip(
                    label: Text('#$tag'),
                    onDeleted: () {
                      setState(() {
                        _tags.remove(tag);
                      });
                    },
                  );
                }).toList(),
                ActionChip(
                  label: const Text('+ Add Tag'),
                  onPressed: _addTag,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Subtasks section
            const Text(
              'Subtasks',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ..._subtasks.asMap().entries.map((entry) {
              final index = entry.key;
              final subtask = entry.value;
              return ListTile(
                leading: Checkbox(
                  value: subtask.isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _subtasks[index] = subtask.copyWith(
                        isCompleted: value ?? false,
                      );
                    });
                  },
                ),
                title: Text(subtask.title),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _subtasks.removeAt(index);
                    });
                  },
                ),
              );
            }).toList(),
            OutlinedButton.icon(
              onPressed: _addSubtask,
              icon: const Icon(Icons.add),
              label: const Text('Add Subtask'),
            ),
            
            const SizedBox(height: 24),
            
            // Notes field
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Additional notes',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityButton(
    TaskPriority priority,
    String label,
    Color color,
  ) {
    final isSelected = _selectedPriority == priority;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? color.withOpacity(0.1) : null,
        side: BorderSide(
          color: isSelected ? color : Colors.grey,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? color : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  Future<void> _selectReminderDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _reminderDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      
      if (time != null) {
        setState(() {
          _reminderDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _selectRecurringPattern() async {
    final pattern = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Recurring Pattern'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Daily'),
            child: const Text('Daily'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Weekly'),
            child: const Text('Weekly'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Monthly'),
            child: const Text('Monthly'),
          ),
        ],
      ),
    );
    
    if (pattern != null) {
      setState(() {
        _recurringPattern = pattern;
      });
    }
  }

  Future<void> _addTag() async {
    final tag = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: _tagController,
          decoration: const InputDecoration(hintText: 'Enter tag name'),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, _tagController.text);
              _tagController.clear();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    
    if (tag != null && tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
      });
    }
  }

  Future<void> _addSubtask() async {
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Subtask'),
        content: TextField(
          controller: _subtaskController,
          decoration: const InputDecoration(hintText: 'Enter subtask title'),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, _subtaskController.text);
              _subtaskController.clear();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    
    if (title != null && title.isNotEmpty) {
      setState(() {
        _subtasks.add(SubTaskModel(
          taskId: '', // Will be set when task is created
          title: title,
          orderIndex: _subtasks.length,
        ));
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      DateTime? dueDateTime;
      if (_selectedDate != null) {
        if (_selectedTime != null) {
          dueDateTime = DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          );
        } else {
          dueDateTime = _selectedDate;
        }
      }

      final task = TaskModel(
        id: widget.taskToEdit?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _selectedDate,
        dueTime: dueDateTime,
        priority: _selectedPriority,
        categoryId: _selectedCategoryId,
        tags: _tags,
        hasReminder: _hasReminder,
        reminderTime: _reminderDateTime,
        isRecurring: _isRecurring,
        recurringPattern: _recurringPattern,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      final taskProvider = context.read<TaskProvider>();
      bool success;
      
      if (widget.taskToEdit == null) {
        success = await taskProvider.createTask(task);
        
        // Add subtasks if any
        if (success && _subtasks.isNotEmpty) {
          for (final subtask in _subtasks) {
            await taskProvider.createSubTask(
              subtask.copyWith(taskId: task.id),
            );
          }
        }
      } else {
        success = await taskProvider.updateTask(task);
      }

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.taskToEdit == null 
                ? 'Task created successfully!' 
                : 'Task updated successfully!'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
