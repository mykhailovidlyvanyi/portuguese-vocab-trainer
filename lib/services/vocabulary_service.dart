// services/vocabulary_service.dart

import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/word_category.dart';
import '../models/word_entry.dart';

class VocabularyService {
  Map<String, Map<String, String>> _personHints = {};

  double _verbInfinitiveWeight = 1.0;
  Map<String, double> _verbPersonWeights = {};

  double _numberDefaultWeight = 1.0;
  double _numberGenderVariantWeight = 0.5;

  Future<List<WordCategory>> loadCategories() async {
    await _loadPersonHints();
    await _loadWeightConfigs();

    final jsonString = await rootBundle.loadString(
      'assets/data/categories.json',
    );

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return Future.wait(
      jsonList.map(
            (item) => _parseCategory(item as Map<String, dynamic>),
      ),
    );
  }

  Future<void> _loadPersonHints() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/person_hints.json',
    );

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    _personHints = jsonMap.map(
          (person, hints) => MapEntry(
        person,
        Map<String, String>.from(hints as Map),
      ),
    );
  }

  Future<void> _loadWeightConfigs() async {
    final verbJson = jsonDecode(
      await rootBundle.loadString(
        'assets/data/weights/verb_weights.json',
      ),
    ) as Map<String, dynamic>;

    _verbInfinitiveWeight =
        (verbJson['infinitive'] as num).toDouble();

    final persons =
    verbJson['persons'] as Map<String, dynamic>;

    _verbPersonWeights = persons.map(
          (person, weight) => MapEntry(
        person,
        (weight as num).toDouble(),
      ),
    );

    final numberJson = jsonDecode(
      await rootBundle.loadString(
        'assets/data/weights/number_weights.json',
      ),
    ) as Map<String, dynamic>;

    _numberDefaultWeight =
        (numberJson['default'] as num).toDouble();

    final genderVariants =
    numberJson['genderVariants'] as Map<String, dynamic>;

    _numberGenderVariantWeight =
        (genderVariants['defaultWeight'] as num).toDouble();
  }

  Future<WordCategory> _parseCategory(
      Map<String, dynamic> json,
      ) async {
    final wordsFile = json['wordsFile'] as String?;

    final List<WordEntry> words = wordsFile == null
        ? []
        : await _loadWords(wordsFile);

    final List<dynamic> subcategoriesJson =
        json['subcategories'] as List<dynamic>? ?? [];

    final subcategories = await Future.wait(
      subcategoriesJson.map(
            (item) => _parseCategory(item as Map<String, dynamic>),
      ),
    );

    return WordCategory(
      name: json['name'] as String,
      words: words,
      subcategories: subcategories,
    );
  }

  List<WordEntry> _applyNumberWeights(List<WordEntry> words) {
    final genderByGroup = <String, Set<String>>{};

    for (final word in words) {
      if (word.numericValue == null) continue;

      final gender = word.englishHint?.toLowerCase().trim();

      if (gender != 'masculine' && gender != 'feminine') {
        continue;
      }

      final groupKey =
          '${word.numericValue}_${word.english.toLowerCase().trim()}';

      genderByGroup.putIfAbsent(groupKey, () => <String>{}).add(gender!);
    }

    return words.map((word) {
      if (word.numericValue == null) {
        return word;
      }

      final groupKey =
          '${word.numericValue}_${word.english.toLowerCase().trim()}';

      final genders = genderByGroup[groupKey] ?? {};

      final hasBothGenders =
          genders.contains('masculine') &&
              genders.contains('feminine');

      return word.copyWith(
        weight: hasBothGenders
            ? _numberGenderVariantWeight
            : _numberDefaultWeight,
      );
    }).toList();
  }

  Future<List<WordEntry>> _loadWords(String filePath) async {
    final jsonString = await rootBundle.loadString(
      'assets/data/$filePath',
    );

    final List<dynamic> jsonList = jsonDecode(jsonString);

    final words = jsonList
        .map(
          (item) => WordEntry.fromJson(
        item as Map<String, dynamic>,
      ),
    )
        .toList();

    final weightedWords = _applyNumberWeights(words);

    return weightedWords
        .expand(
          (word) => word.toStudyEntries(
        personHints: _personHints,
        infinitiveWeight: _verbInfinitiveWeight,
        personWeights: _verbPersonWeights,
      ),
    )
        .toList();
  }
}