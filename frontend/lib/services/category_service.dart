import '../models/category_model.dart';
import 'database_helper.dart';

class CategoryService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create a new category
  Future<CategoryModel> createCategory(CategoryModel category) async {
    final db = await _dbHelper.database;
    await db.insert('categories', category.toMap());
    return category;
  }

  // Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      orderBy: 'createdAt ASC',
    );
    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  // Get category by ID
  Future<CategoryModel?> getCategoryById(String id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return CategoryModel.fromMap(maps.first);
  }

  // Update category
  Future<int> updateCategory(CategoryModel category) async {
    final db = await _dbHelper.database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  // Delete category
  Future<int> deleteCategory(String id) async {
    final db = await _dbHelper.database;
    // Tasks will have their categoryId set to NULL due to ON DELETE SET NULL
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get category usage count (number of tasks)
  Future<Map<String, int>> getCategoryUsageCounts() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT categoryId, COUNT(*) as count 
      FROM tasks 
      WHERE categoryId IS NOT NULL 
      GROUP BY categoryId
    ''');
    
    final Map<String, int> usageCounts = {};
    for (final row in result) {
      usageCounts[row['categoryId'] as String] = row['count'] as int;
    }
    return usageCounts;
  }
}
