// lib/utils/conjugation_question_builder.dart

import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/word_entry.dart';
import '../models/study_weight.dart';

import 'weighted_random_selector.dart';

class ConjugationQuestion {
  final String infinitive;
  final String person;
  final String englishInfinitive;
  final String englishPerson;
  final String correctAnswer;
  final List<String> options;
  final StudyWeight studyWeight;

  const ConjugationQuestion({
    required this.infinitive,
    required this.person,
    required this.englishInfinitive,
    required this.englishPerson,
    required this.correctAnswer,
    required this.options,
    required this.studyWeight,
  });
}

class ConjugationQuestionBuilder {
  final Random _random = Random();

  final WeightedRandomSelector<ConjugationQuestion> _selector =
      WeightedRandomSelector<ConjugationQuestion>();

  // Прибираємо займенник із португальської форми.
  // Наприклад: "tu estás" -> "estás".
  String _getConjugatedVerb(WordForm form) {
    final portuguese = form.portuguese.trim();
    final person = form.person.trim();
    final prefix = '$person ';

    if (portuguese.toLowerCase().startsWith(prefix.toLowerCase())) {
      return portuguese.substring(prefix.length).trim();
    }

    return portuguese;
  }

  String _getEnglishPerson(WordForm form) {
    const pronouns = {
      'eu': 'I',
      'tu': 'you',
      'você': 'you',
      'ele': 'he',
      'ela': 'she',
      'nós': 'we',
      'vocês': 'you',
      'eles': 'they',
      'elas': 'they',
    };

    final pronoun = pronouns[form.person] ?? form.person;
    final hint = form.englishPersonHint?.trim();

    if (hint == null || hint.isEmpty) {
      return pronoun;
    }

    return '$pronoun ($hint)';
  }

  List<ConjugationQuestion> buildQuestions({
    required List<WordEntry> pool,
  }) {
    final questions = <ConjugationQuestion>[];

    for (final verb in pool) {
      if (verb.type != 'verb' || verb.isConjugatedForm || verb.tenses.isEmpty) {
        continue;
      }

      final forms = verb.tenses['present'];

      if (forms == null || forms.isEmpty) {
        continue;
      }

      // Збираємо унікальні форми дієслова без займенників.
      final uniqueForms = <String, String>{};

      for (final form in forms) {
        final answer = _getConjugatedVerb(form);

        if (answer.isNotEmpty) {
          uniqueForms.putIfAbsent(
            answer.toLowerCase(),
            () => answer,
          );
        }
      }

      // Потрібно щонайменше 4 різні форми.
      if (uniqueForms.length < 4) {
        continue;
      }

      for (final form in forms) {
        final correctAnswer = _getConjugatedVerb(form);

        if (correctAnswer.isEmpty) {
          continue;
        }

        final normalizedCorrectAnswer = correctAnswer.toLowerCase();

        final distractors = uniqueForms.entries
            .where((entry) => entry.key != normalizedCorrectAnswer)
            .map((entry) => entry.value)
            .toList();

        if (distractors.length < 3) {
          continue;
        }

        distractors.shuffle(_random);

        final options = [
          correctAnswer,
          ...distractors.take(3),
        ]..shuffle(_random);

        questions.add(
          ConjugationQuestion(
            infinitive: verb.portuguese,
            person: form.person,
            englishInfinitive: verb.english,
            englishPerson: _getEnglishPerson(form),
            correctAnswer: correctAnswer,
            options: options,
            studyWeight: StudyWeight(
              baseWeight:
                  verb.studyWeight.baseWeight * form.studyWeight.baseWeight,
              learningMultiplier: verb.studyWeight.learningMultiplier *
                  form.studyWeight.learningMultiplier,
            ),
          ),
        );
      }
    }

    return questions;
  }

  ConjugationQuestion nextQuestion(
    List<ConjugationQuestion> questions,
  ) {
    final selected = _selector.next(
      items: questions,
      getWeight: (question) => question.studyWeight.effectiveWeight,
    );

    debugPrint(
      'Selected conjugation: ${selected.infinitive} '
      '(${selected.englishInfinitive}) | '
      'Person: ${selected.person} | '
      'Answer: ${selected.correctAnswer} | '
      'Base Weight: ${selected.studyWeight.baseWeight} | '
      'Learning Multiplier: ${selected.studyWeight.learningMultiplier} | '
      'Effective Weight: ${selected.studyWeight.effectiveWeight}',
    );

    return selected;
  }
}
