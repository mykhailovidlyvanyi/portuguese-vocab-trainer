// screens/category_selection_screen.dart


import 'package:flutter/material.dart';

import '../models/word_category.dart';
import 'mode_selection_screen.dart';
import 'subcategory_selection_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  final List<WordCategory> categories;

  const CategorySelectionScreen({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final categoriesList = ["Усе", ...categories.map((c) => c.name)];

    return Scaffold(
      appBar: AppBar(title: const Text('Вибір категорії')),
      body: ListView.builder(
        itemCount: categoriesList.length,
        itemBuilder: (context, index) {
          final categoryName = categoriesList[index];

          return ListTile(
            title: Text(categoryName),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              if (categoryName == "Усе") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ModeSelectionScreen(
                      isAll: true,
                      allCategories: categories,
                    ),
                  ),
                );
                return;
              }

              final selectedCategory = categories.firstWhere(
                    (c) => c.name == categoryName,
              );

              if (selectedCategory.subcategories.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubcategorySelectionScreen(
                      category: selectedCategory,
                      allCategories: categories,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ModeSelectionScreen(
                      category: selectedCategory,
                      allCategories: categories,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
