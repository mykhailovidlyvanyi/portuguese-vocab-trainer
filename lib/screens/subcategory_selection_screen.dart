// screens/subcategory_selection_screen.dart

import 'package:flutter/material.dart';
import '../models/word_category.dart';
import '../models/word_entry.dart';
import 'mode_selection_screen.dart';

class SubcategorySelectionScreen extends StatelessWidget {
  final WordCategory category;

  const SubcategorySelectionScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // Збираємо слова з усіх рівнів вкладеності
    final allWords = _getAllWords(category);

    final allWordsCategory = WordCategory(
      name: 'Усі ${category.name.toLowerCase()}',
      words: allWords,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: ListView(
        children: [
          // Навчання всіх слів поточної категорії
          if (category.subcategories.isNotEmpty && allWords.isNotEmpty)
            ListTile(
              title: Text('Усі ${category.name.toLowerCase()}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ModeSelectionScreen(
                    category: allWordsCategory,
                  ),
                ),
              ),
            ),

          // Підкатегорії
          ...category.subcategories.map((subcategory) {
            return ListTile(
              title: Text(subcategory.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => subcategory.subcategories.isNotEmpty
                      ? SubcategorySelectionScreen(category: subcategory)
                      : ModeSelectionScreen(category: subcategory),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Рекурсивно збираємо слова з усіх підкатегорій
  List<WordEntry> _getAllWords(WordCategory category) {
    return [
      ...category.words,
      ...category.subcategories.expand(_getAllWords),
    ];
  }
}