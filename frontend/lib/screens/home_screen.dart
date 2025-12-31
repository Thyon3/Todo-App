import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../providers/category_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/task_card.dart';
import '../config/app_theme.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';
import 'settings_screen.dart';
import 'categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeData();
  }

  Future<void> _initializeData() async {
    final taskProvider = context.read<TaskProvider>();
    final categoryProvider = context.read<CategoryProvider>();
    
    await Future.wait([
      taskProvider.initialize(),
      categoryProvider.initialize(),
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search tasks...',
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  context.read<TaskProvider>().setSearchQuery(query);
                },
              )
            : const Text('My Tasks'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<TaskProvider>().setSearchQuery('');
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortBottomSheet,
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode 
                      ? Icons.light_mode 
                      : Icons.dark_mode,
                ),
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Today'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
          onTap: (index) {
            final taskProvider = context.read<TaskProvider>();
            switch (index) {
              case 0:
                taskProvider.setStatusFilter(null);
                break;
              case 1:
                taskProvider.setStatusFilter(null);
                break;
              case 2:
                taskProvider.setStatusFilter(TaskStatus.pending);
                break;
              case 3:
                taskProvider.setStatusFilter(TaskStatus.completed);
                break;
            }
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(showAll: true),
          _buildTaskList(todayOnly: true),
          _buildTaskList(showAll: true),
          _buildTaskList(showAll: true),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildTaskList({bool showAll = false, bool todayOnly = false}) {
    return Consumer2<TaskProvider, CategoryProvider>(
      builder: (context, taskProvider, categoryProvider, _) {
        if (taskProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<TaskModel> tasks = todayOnly 
            ? taskProvider.todaysTasks 
            : taskProvider.tasks;

        if (tasks.isEmpty) {
          return _buildEmptyState();
        }

        // Group tasks by date for better organization
        final groupedTasks = _groupTasksByDate(tasks);

        return RefreshIndicator(
          onRefresh: () => taskProvider.loadTasks(),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: groupedTasks.length,
            itemBuilder: (context, index) {
              final entry = groupedTasks.entries.elementAt(index);
              final dateLabel = entry.key;
              final dateTasks = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      dateLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...dateTasks.map((task) {
                    final category = task.categoryId != null
                        ? categoryProvider.getCategoryById(task.categoryId!)
                        : null;

                    return TaskCard(
                      task: task,
                      categoryName: category?.name,
                      categoryColor: category?.color,
                      onTap: () => _navigateToTaskDetail(task),
                      onComplete: () => _toggleTaskCompletion(task.id),
                      onDelete: () => _deleteTask(task.id),
                    );
                  }).toList(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'No tasks yet!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first task',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<TaskModel>> _groupTasksByDate(List<TaskModel> tasks) {
    final Map<String, List<TaskModel>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final task in tasks) {
      String label;
      if (task.isOverdue && task.status != TaskStatus.completed) {
        label = '⚠️ Overdue';
      } else if (task.isDueToday) {
        label = '📅 Today';
      } else if (task.isDueTomorrow) {
        label = '📅 Tomorrow';
      } else if (task.dueDate != null) {
        final daysUntil = task.dueDate!.difference(today).inDays;
        if (daysUntil <= 7) {
          label = '📅 This Week';
        } else {
          label = '📅 Later';
        }
      } else {
        label = '📋 No Due Date';
      }

      if (!grouped.containsKey(label)) {
        grouped[label] = [];
      }
      grouped[label]!.add(task);
    }

    return grouped;
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Todo App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Consumer<TaskProvider>(
                  builder: (context, taskProvider, _) {
                    return Text(
                      '${taskProvider.pendingTasksCount} pending tasks',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to dashboard
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoriesScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Statistics'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to statistics
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup & Restore'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to backup
            },
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer2<TaskProvider, CategoryProvider>(
          builder: (context, taskProvider, categoryProvider, _) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Priority', style: TextStyle(fontWeight: FontWeight.w600)),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('High'),
                        selected: taskProvider.priorityFilter == TaskPriority.high,
                        onSelected: (selected) {
                          taskProvider.setPriorityFilter(
                            selected ? TaskPriority.high : null,
                          );
                        },
                      ),
                      FilterChip(
                        label: const Text('Medium'),
                        selected: taskProvider.priorityFilter == TaskPriority.medium,
                        onSelected: (selected) {
                          taskProvider.setPriorityFilter(
                            selected ? TaskPriority.medium : null,
                          );
                        },
                      ),
                      FilterChip(
                        label: const Text('Low'),
                        selected: taskProvider.priorityFilter == TaskPriority.low,
                        onSelected: (selected) {
                          taskProvider.setPriorityFilter(
                            selected ? TaskPriority.low : null,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          taskProvider.clearFilters();
                          Navigator.pop(context);
                        },
                        child: const Text('Clear All'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<TaskProvider>(
          builder: (context, taskProvider, _) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<TaskSortOption>(
                    title: const Text('Due Date'),
                    value: TaskSortOption.dueDate,
                    groupValue: taskProvider.sortOption,
                    onChanged: (value) {
                      if (value != null) {
                        taskProvider.setSortOption(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  RadioListTile<TaskSortOption>(
                    title: const Text('Priority'),
                    value: TaskSortOption.priority,
                    groupValue: taskProvider.sortOption,
                    onChanged: (value) {
                      if (value != null) {
                        taskProvider.setSortOption(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  RadioListTile<TaskSortOption>(
                    title: const Text('Title'),
                    value: TaskSortOption.title,
                    groupValue: taskProvider.sortOption,
                    onChanged: (value) {
                      if (value != null) {
                        taskProvider.setSortOption(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  RadioListTile<TaskSortOption>(
                    title: const Text('Created Date'),
                    value: TaskSortOption.createdDate,
                    groupValue: taskProvider.sortOption,
                    onChanged: (value) {
                      if (value != null) {
                        taskProvider.setSortOption(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToTaskDetail(TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );
  }

  Future<void> _toggleTaskCompletion(String taskId) async {
    final success = await context.read<TaskProvider>().toggleTaskCompletion(taskId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated!')),
      );
    }
  }

  Future<void> _deleteTask(String taskId) async {
    final confirm = await showDialog<bool>(
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
              backgroundColor: AppTheme.errorLight,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await context.read<TaskProvider>().deleteTask(taskId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted!')),
        );
      }
    }
  }
}
