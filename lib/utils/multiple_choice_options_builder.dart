// lib/utils/multiple_choice_options_builder.dart

import 'dart:math';

import '../models/word_entry.dart';

class MultipleChoiceOptionsBuilder {
  final Random _random = Random();

  List<String> buildOptions({
    required List<WordEntry> pool,
    required WordEntry correctWord,
    required bool showEnglish,
  }) {
    final correctAnswer =
        (showEnglish ? correctWord.portuguese : correctWord.english).trim();

    final uniqueAnswers = <String, String>{};

    for (final word in pool) {
      final answer = (showEnglish ? word.portuguese : word.english).trim();
      final normalizedAnswer = answer.toLowerCase();

      if (answer.isNotEmpty &&
          normalizedAnswer != correctAnswer.toLowerCase()) {
        uniqueAnswers.putIfAbsent(normalizedAnswer, () => answer);
      }
    }

    final possibleAnswers = uniqueAnswers.values.toList();

    if (possibleAnswers.length < 3) {
      throw StateError(
        'Not enough unique answers to build multiple choice options.',
      );
    }

    possibleAnswers.shuffle(_random);

    final options = [
      correctAnswer,
      ...possibleAnswers.take(3),
    ];

    options.shuffle(_random);

    return options;
  }
}
