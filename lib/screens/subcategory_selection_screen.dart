// screens/subcategory_selection_screen.dart


import 'package:flutter/material.dart';

import '../models/word_category.dart';
import '../models/word_entry.dart';
import 'mode_selection_screen.dart';

class SubcategorySelectionScreen extends StatelessWidget {
  final WordCategory category;
  final List<WordCategory> allCategories;

  const SubcategorySelectionScreen({
    super.key,
    required this.category,
    required this.allCategories,
  });

  @override
  Widget build(BuildContext context) {
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
          if (category.subcategories.isNotEmpty && allWords.isNotEmpty)
            ListTile(
              title: Text('Усі ${category.name.toLowerCase()}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ModeSelectionScreen(
                    category: allWordsCategory,
                    allCategories: allCategories,
                  ),
                ),
              ),
            ),

          ...category.subcategories.map((subcategory) {
            return ListTile(
              title: Text(subcategory.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => subcategory.subcategories.isNotEmpty
                      ? SubcategorySelectionScreen(
                    category: subcategory,
                    allCategories: allCategories,
                  )
                      : ModeSelectionScreen(
                    category: subcategory,
                    allCategories: allCategories,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  List<WordEntry> _getAllWords(WordCategory category) {
    return [
      ...category.words,
      ...category.subcategories.expand(_getAllWords),
    ];
  }
}
