// lib/screens/category_selection_screen.dart

import 'package:material_ui/material_ui.dart';

import '../models/word_category.dart';

import 'mode_selection_screen.dart';
import 'subcategory_selection_screen.dart';

import '../utils/word_pool_builder.dart';

class CategorySelectionScreen extends StatelessWidget {
  final List<WordCategory> categories;
  final String studyMethod;

  const CategorySelectionScreen({
    super.key,
    required this.categories,
    required this.studyMethod,
  });

  @override
  Widget build(BuildContext context) {
    final availableCategories = studyMethod == 'multipleChoice'
        ? categories
            .where(
              (category) => WordPoolBuilder()
                  .fromCategoryInfinitives(category)
                  .isNotEmpty,
            )
            .toList()
        : categories;

    final categoriesList = [
      if (availableCategories.length > 1) "Усе",
      ...availableCategories.map((c) => c.name),
    ];

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
                            studyMethod: studyMethod,
                          )),
                );
                return;
              }

              final selectedCategory = availableCategories.firstWhere(
                (c) => c.name == categoryName,
              );

              if (selectedCategory.subcategories.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubcategorySelectionScreen(
                      category: selectedCategory,
                      allCategories: categories,
                      studyMethod: studyMethod,
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
                      studyMethod: studyMethod,
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
