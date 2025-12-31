import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';
import '../models/category_model.dart';
import '../models/subtask_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Database version for migration management
  static const int _databaseVersion = 1;
  static const String _databaseName = 'todo_app.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create Categories table
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        colorHex TEXT NOT NULL,
        iconCodePoint TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create Tasks table with indexes for performance
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        dueDate TEXT,
        dueTime TEXT,
        priority INTEGER NOT NULL DEFAULT 1,
        status INTEGER NOT NULL DEFAULT 0,
        categoryId TEXT,
        tags TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        hasReminder INTEGER NOT NULL DEFAULT 0,
        reminderTime TEXT,
        isRecurring INTEGER NOT NULL DEFAULT 0,
        recurringPattern TEXT,
        notes TEXT,
        completionPercentage INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE SET NULL
      )
    ''');

    // Create SubTasks table
    await db.execute('''
      CREATE TABLE subtasks (
        id TEXT PRIMARY KEY,
        taskId TEXT NOT NULL,
        title TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        orderIndex INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better query performance
    await db.execute(
        'CREATE INDEX idx_tasks_status ON tasks(status)');
    await db.execute(
        'CREATE INDEX idx_tasks_priority ON tasks(priority)');
    await db.execute(
        'CREATE INDEX idx_tasks_dueDate ON tasks(dueDate)');
    await db.execute(
        'CREATE INDEX idx_tasks_categoryId ON tasks(categoryId)');
    await db.execute(
        'CREATE INDEX idx_subtasks_taskId ON subtasks(taskId)');

    // Insert default categories
    final defaultCategories = CategoryModel.getDefaultCategories();
    for (final category in defaultCategories) {
      await db.insert('categories', category.toMap());
    }
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE tasks ADD COLUMN newColumn TEXT');
    // }
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // Reset database (useful for testing)
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    await deleteDatabase(path);
    _database = null;
  }
}
