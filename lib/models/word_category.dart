// models/word_category.dart
import 'word_entry.dart';

class WordCategory {
  final String name;
  final List<WordEntry> words;

  WordCategory({required this.name, required this.words});
}
