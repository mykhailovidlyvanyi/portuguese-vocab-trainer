// lib/models/word_entry.dart

import 'study_weight.dart';

class WordEntry {
  final String english;
  final String portuguese;
  final String type;
  final bool isConjugatedForm;
  final StudyWeight studyWeight;
  final String? englishHint;
  final String? portugueseHint;
  final int? numericValue;
  final String? person;
  final String? article;
  final String? gender;

  final Map<String, List<WordForm>> tenses;

  WordEntry({
    required this.english,
    required this.portuguese,
    this.type = 'word',
    this.isConjugatedForm = false,
    this.studyWeight = const StudyWeight(),
    this.englishHint,
    this.portugueseHint,
    this.numericValue,
    this.tenses = const {},
    this.person,
    this.article,
    this.gender,
  });

  factory WordEntry.fromJson(
    Map<String, dynamic> json, {
    Map<String, Map<String, String>> genderData = const {},
  }) {
    final Map<String, dynamic> rawTenses =
        (json['tenses'] as Map<String, dynamic>?) ?? {};

    final hints = json['hints'] as Map<String, dynamic>? ?? {};

    final gender = json['gender'] as String?;
    final genderInfo = gender == null ? null : genderData[gender];

    return WordEntry(
      english: json['english'] as String,
      portuguese: json['portuguese'] as String,
      type: json['type'] as String? ?? 'word',
      englishHint: hints['english'] as String?,
      portugueseHint: hints['portuguese'] as String?,
      numericValue: (json['numericValue'] as num?)?.toInt(),
      person: json['person'] as String?,
      article: json['article'] as String? ?? genderInfo?['article'],
      gender: gender,
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

  WordEntry copyWith({
    StudyWeight? studyWeight,
  }) {
    return WordEntry(
      english: english,
      portuguese: portuguese,
      type: type,
      isConjugatedForm: isConjugatedForm,
      studyWeight: studyWeight ?? this.studyWeight,
      englishHint: englishHint,
      portugueseHint: portugueseHint,
      numericValue: numericValue,
      person: person,
      article: article,
      gender: gender,
      tenses: tenses,
    );
  }

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

  List<WordEntry> toStudyEntries({
    Map<String, Map<String, String>> personHints = const {},
    double infinitiveWeight = 1.0,
    Map<String, double> personWeights = const {},
  }) {
    final weightedTenses = tenses.map(
      (tense, forms) => MapEntry(
        tense,
        forms
            .map(
              (form) => WordForm(
                person: form.person,
                english: form.english,
                portuguese: form.portuguese,
                englishHint: form.englishHint,
                portugueseHint: form.portugueseHint,
                englishPersonHint: personHints[form.person]?['english'],
                portuguesePersonHint: personHints[form.person]?['portuguese'],
                studyWeight: StudyWeight(
                  baseWeight: type == 'verb'
                      ? (personWeights[form.person] ?? 1.0)
                      : form.studyWeight.baseWeight,
                  learningMultiplier: form.studyWeight.learningMultiplier,
                ),
              ),
            )
            .toList(),
      ),
    );

    final entries = <WordEntry>[
      WordEntry(
        english: english,
        portuguese: portuguese,
        type: type,
        isConjugatedForm: false,
        studyWeight: StudyWeight(
          baseWeight:
              type == 'verb' ? infinitiveWeight : studyWeight.baseWeight,
          learningMultiplier: studyWeight.learningMultiplier,
        ),
        englishHint: englishHint,
        portugueseHint: portugueseHint,
        numericValue: numericValue,
        article: article,
        gender: gender,
        tenses: weightedTenses,
      ),
    ];

    for (final forms in weightedTenses.values) {
      for (final form in forms) {
        final personHint = personHints[form.person];

        entries.add(
          WordEntry(
            english: form.english,
            portuguese: form.portuguese,
            type: type,
            isConjugatedForm: true,
            person: form.person,
            article: article,
            gender: gender,
            studyWeight: form.studyWeight,
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
  final String? englishHint;
  final String? portugueseHint;
  final StudyWeight studyWeight;
  final String? englishPersonHint;
  final String? portuguesePersonHint;

  WordForm({
    required this.person,
    required this.english,
    required this.portuguese,
    this.englishHint,
    this.portugueseHint,
    this.studyWeight = const StudyWeight(),
    this.englishPersonHint,
    this.portuguesePersonHint,
  });

  factory WordForm.fromJson(Map<String, dynamic> json) {
    final hints = json['hints'] as Map<String, dynamic>? ?? {};

    return WordForm(
      person: json['person'] as String,
      english: json['english'] as String,
      portuguese: json['portuguese'] as String,
      englishHint: hints['english'] as String?,
      portugueseHint: hints['portuguese'] as String?,
    );
  }
}
