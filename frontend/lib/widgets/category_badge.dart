import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryBadge extends StatelessWidget {
  final CategoryModel category;
  final bool showIcon;

  const CategoryBadge({
    Key? key,
    required this.category,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: category.color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(category.icon, size: 14, color: category.color),
            const SizedBox(width: 4),
          ],
          Text(
            category.name,
            style: TextStyle(
              fontSize: 12,
              color: category.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
