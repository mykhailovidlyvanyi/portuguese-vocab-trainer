// lib/utils/word_pool_builder.dart

import '../models/word_category.dart';
import '../models/word_entry.dart';

class WordPoolBuilder {
  List<WordEntry> fromCategory(WordCategory category) {
    return [
      ...category.words,
      ...category.subcategories.expand(fromCategory),
    ];
  }

  List<WordEntry> fromCategories(List<WordCategory> categories) {
    return categories.expand(fromCategory).toList();
  }

  List<WordEntry> fromCategoryInfinitives(WordCategory category) {
    return fromCategory(category)
        .where(
          (word) => word.type == 'verb' && !word.isConjugatedForm,
        )
        .toList();
  }

  List<WordEntry> fromCategoriesInfinitives(
    List<WordCategory> categories,
  ) {
    return fromCategories(categories)
        .where(
          (word) => word.type == 'verb' && !word.isConjugatedForm,
        )
        .toList();
  }
}
