// screens/category_selection_screen.dart


import 'package:flutter/material.dart';
import '../data/words_data.dart';
import 'mode_selection_screen.dart';
import 'subcategory_selection_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

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
                      category: categoryName,
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
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ModeSelectionScreen(
                      category: categoryName,
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
