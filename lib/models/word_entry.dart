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

  factory WordEntry.fromJson(Map<String, dynamic> json) {
    return WordEntry(
      english: json['english'] as String,
      portuguese: json['portuguese'] as String,
      weight: (json['weight'] as num).toDouble(),
      englishHint: json['englishHint'] as String?,
      portugueseHint: json['portugueseHint'] as String?,
      numericValue: json['numericValue'] as int?,
    );
  }
}