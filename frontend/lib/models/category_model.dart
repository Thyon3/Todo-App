import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CategoryModel {
  final String id;
  final String name;
  final String colorHex;
  final String iconCodePoint;
  final DateTime createdAt;

  CategoryModel({
    String? id,
    required this.name,
    required this.colorHex,
    this.iconCodePoint = '0xe047', // Default icon code point
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // Convert to Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'colorHex': colorHex,
      'iconCodePoint': iconCodePoint,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Map (SQLite data)
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      colorHex: map['colorHex'],
      iconCodePoint: map['iconCodePoint'] ?? '0xe047',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Get color from hex
  Color get color {
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  // Get icon from code point
  IconData get icon {
    return IconData(int.parse(iconCodePoint), fontFamily: 'MaterialIcons');
  }

  // CopyWith method
  CategoryModel copyWith({
    String? id,
    String? name,
    String? colorHex,
    String? iconCodePoint,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Default categories
  static List<CategoryModel> getDefaultCategories() {
    return [
      CategoryModel(
        name: 'Work',
        colorHex: '#2196F3',
        iconCodePoint: '0xe8f9', // work icon
      ),
      CategoryModel(
        name: 'Personal',
        colorHex: '#4CAF50',
        iconCodePoint: '0xe7fd', // person icon
      ),
      CategoryModel(
        name: 'Shopping',
        colorHex: '#FF9800',
        iconCodePoint: '0xe8cc', // shopping_cart icon
      ),
      CategoryModel(
        name: 'Health',
        colorHex: '#F44336',
        iconCodePoint: '0xe3f8', // favorite icon
      ),
      CategoryModel(
        name: 'Education',
        colorHex: '#9C27B0',
        iconCodePoint: '0xe80c', // school icon
      ),
    ];
  }
}
