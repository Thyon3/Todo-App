import 'package:flutter/foundation.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<CategoryModel> _categories = [];
  Map<String, int> _usageCounts = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  List<CategoryModel> get categories => _categories;
  Map<String, int> get usageCounts => _usageCounts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize and load categories
  Future<void> initialize() async {
    await loadCategories();
  }

  // Load all categories
  Future<void> loadCategories() async {
    _setLoading(true);
    try {
      _categories = await _categoryService.getAllCategories();
      _usageCounts = await _categoryService.getCategoryUsageCounts();
      _error = null;
    } catch (e) {
      _error = 'Failed to load categories: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Create a new category
  Future<bool> createCategory(CategoryModel category) async {
    try {
      final created = await _categoryService.createCategory(category);
      _categories.add(created);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to create category: $e';
      notifyListeners();
      return false;
    }
  }

  // Update a category
  Future<bool> updateCategory(CategoryModel category) async {
    try {
      await _categoryService.updateCategory(category);
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = category;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update category: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete a category
  Future<bool> deleteCategory(String id) async {
    try {
      await _categoryService.deleteCategory(id);
      _categories.removeWhere((c) => c.id == id);
      _usageCounts.remove(id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete category: $e';
      notifyListeners();
      return false;
    }
  }

  // Get category by ID
  CategoryModel? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get usage count for a category
  int getUsageCount(String categoryId) {
    return _usageCounts[categoryId] ?? 0;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
