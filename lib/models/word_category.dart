// models/word_category.dart

import 'word_entry.dart';

class WordCategory {
  final String name;
  final List<WordEntry> words;
  final List<WordCategory> subcategories;

  WordCategory({
    required this.name,
    this.words = const [],
    this.subcategories = const [],
  });
}