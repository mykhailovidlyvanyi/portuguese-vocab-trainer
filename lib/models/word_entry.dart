
class WordEntry {
  final String english;
  final String portuguese;
  final String type;
  final double weight;
  final String? englishHint;
  final String? portugueseHint;
  final int? numericValue;

  final Map<String, List<WordForm>> tenses;

  WordEntry({
    required this.english,
    required this.portuguese,
    this.type = 'word',
    required this.weight,
    this.englishHint,
    this.portugueseHint,
    this.numericValue,
    this.tenses = const {},
  });

  factory WordEntry.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> rawTenses =
        (json['tenses'] as Map<String, dynamic>?) ?? {};

    return WordEntry(
      english: json['english'] as String,
      portuguese: json['portuguese'] as String,
      type: json['type'] as String? ?? 'word',
      weight: (json['weight'] as num).toDouble(),
      englishHint: json['englishHint'] as String?,
      portugueseHint: json['portugueseHint'] as String?,
      numericValue: json['numericValue'] as int?,
      tenses: rawTenses.map(
            (tense, forms) => MapEntry(
          tense,
          (forms as List)
              .map(
                (form) => WordForm.fromJson(
              form as Map<String, dynamic>,
            ),
          )
              .toList(),
        ),
      ),
    );
  }

  // Converts the word and all its forms into individual study entries.
  List<WordEntry> toStudyEntries() {
    final entries = <WordEntry>[
      WordEntry(
        english: english,
        portuguese: portuguese,
        type: type,
        weight: weight,
        englishHint: englishHint,
        portugueseHint: portugueseHint,
        numericValue: numericValue,
      ),
    ];

    for (final forms in tenses.values) {
      for (final form in forms) {
        entries.add(
          WordEntry(
            english: form.english,
            portuguese: form.portuguese,
            type: type,
            weight: form.weight,
            englishHint: form.englishHint,
            portugueseHint: form.portugueseHint,
          ),
        );
      }
    }

    return entries;
  }
}

class WordForm {
  final String person;
  final String english;
  final String portuguese;
  final double weight;
  final String? englishHint;
  final String? portugueseHint;

  WordForm({
    required this.person,
    required this.english,
    required this.portuguese,
    required this.weight,
    this.englishHint,
    this.portugueseHint,
  });

  factory WordForm.fromJson(Map<String, dynamic> json) {
    return WordForm(
      person: json['person'] as String,
      english: json['english'] as String,
      portuguese: json['portuguese'] as String,
      weight: (json['weight'] as num).toDouble(),
      englishHint: json['englishHint'] as String?,
      portugueseHint: json['portugueseHint'] as String?,
    );
  }
}
