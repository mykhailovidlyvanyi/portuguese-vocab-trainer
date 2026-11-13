// lib/screens/subcategory_selection_screen.dart

import 'package:material_ui/material_ui.dart';

import '../models/word_category.dart';
import '../models/word_entry.dart';

import 'mode_selection_screen.dart';

import '../utils/word_pool_builder.dart';

class SubcategorySelectionScreen extends StatelessWidget {
  final WordCategory category;
  final List<WordCategory> allCategories;
  final String studyMethod;

  const SubcategorySelectionScreen({
    super.key,
    required this.category,
    required this.allCategories,
    required this.studyMethod,
  });

  @override
  Widget build(BuildContext context) {
    final availableSubcategories = studyMethod == 'multipleChoice'
        ? category.subcategories
            .where(
              (subcategory) => WordPoolBuilder()
                  .fromCategoryInfinitives(subcategory)
                  .isNotEmpty,
            )
            .toList()
        : category.subcategories;
    final allWords = studyMethod == 'multipleChoice'
        ? WordPoolBuilder().fromCategoryInfinitives(category)
        : _getAllWords(category);

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
          if (availableSubcategories.length > 1)
            ListTile(
              title: Text('Усі ${category.name.toLowerCase()}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ModeSelectionScreen(
                    category: allWordsCategory,
                    allCategories: allCategories,
                    studyMethod: studyMethod,
                  ),
                ),
              ),
            ),
          ...availableSubcategories.map((subcategory) {
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
                            studyMethod: studyMethod,
                          )
                        : ModeSelectionScreen(
                            category: subcategory,
                            allCategories: allCategories,
                            studyMethod: studyMethod,
                          )),
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
