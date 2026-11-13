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
}
