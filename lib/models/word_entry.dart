// models/word_entry.dart
class WordEntry {
  final String english;
  final String portuguese;
  final double weight;
  final String? englishHint;
  final String? portugueseHint;
  final int? numericValue;

  WordEntry({
    required this.english,
    required this.portuguese,
    required this.weight,
    this.englishHint,
    this.portugueseHint,
    this.numericValue,
  });
}
