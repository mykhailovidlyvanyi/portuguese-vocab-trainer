// screens/subcategory_selection_screen.dart

import 'package:flutter/material.dart';
import '../models/word_category.dart';
import 'mode_selection_screen.dart';

class SubcategorySelectionScreen extends StatelessWidget {
  final WordCategory category;

  const SubcategorySelectionScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // Збираємо слова з усіх підкатегорій
    final allWords = category.subcategories
        .expand((subcategory) => subcategory.words)
        .toList();

    // Створюємо категорію для всіх числівників
    final allNumbersCategory = WordCategory(
      name: 'Усі числівники',
      words: allWords,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: ListView(
        children: [
          // Навчання всіх числівників
          ListTile(
            title: const Text('Усі числівники'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ModeSelectionScreen(
                  category: allNumbersCategory,
                ),
              ),
            ),
          ),

          // Окремі підкатегорії
          ...category.subcategories.map((subcategory) {
            return ListTile(
              title: Text(subcategory.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ModeSelectionScreen(
                    category: subcategory,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}