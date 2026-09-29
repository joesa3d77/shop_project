import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/models/category_model.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final bool selected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.category,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: selected ? AppColors.primary : AppColors.fieldBackground,
            child: ClipOval(
              child: category.image == null || category.image!.isEmpty
                  ? Icon(Icons.category_outlined, color: selected ? Colors.white : AppColors.grey)
                  : CachedNetworkImage(
                imageUrl: category.image!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    Icon(Icons.category_outlined, color: selected ? Colors.white : AppColors.grey),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(category.title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
