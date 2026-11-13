// models/word_entry.dart

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

    final hints = json['hints'] as Map<String, dynamic>? ?? {};

    return WordEntry(
      english: json['english'] as String,
      portuguese: json['portuguese'] as String,
      type: json['type'] as String? ?? 'word',
      weight: (json['weight'] as num).toDouble(),
      englishHint: hints['english'] as String?,
      portugueseHint: hints['portuguese'] as String?,
      numericValue: (json['numericValue'] as num?)?.toInt(),
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

  // Converts hints from different levels into one string.
  static String? _combineHints(List<String?> hints) {
    final result = <String>[];

    for (final hint in hints) {
      if (hint == null || hint.trim().isEmpty) continue;

      final parts = hint
          .split(',')
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty);

      for (final part in parts) {
        if (!result.any(
              (existing) => existing.toLowerCase() == part.toLowerCase(),
        )) {
          result.add(part);
        }
      }
    }

    return result.isEmpty ? null : result.join(', ');
  }

  // Converts the word and all its forms into individual study entries.
  List<WordEntry> toStudyEntries({
    Map<String, Map<String, String>> personHints = const {},
  }) {
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
        final personHint = personHints[form.person];

        entries.add(
          WordEntry(
            english: form.english,
            portuguese: form.portuguese,
            type: type,
            weight: form.weight,
            englishHint: _combineHints([
              englishHint,
              personHint?['english'],
              form.englishHint,
            ]),
            portugueseHint: _combineHints([
              portugueseHint,
              personHint?['portuguese'],
              form.portugueseHint,
            ]),
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
    final hints = json['hints'] as Map<String, dynamic>? ?? {};

    return WordForm(
      person: json['person'] as String,
      english: json['english'] as String,
      portuguese: json['portuguese'] as String,
      weight: (json['weight'] as num).toDouble(),
      englishHint: hints['english'] as String?,
      portugueseHint: hints['portuguese'] as String?,
    );
  }
}