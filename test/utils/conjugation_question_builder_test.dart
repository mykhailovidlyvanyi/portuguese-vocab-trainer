// test/utils/conjugation_question_builder_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:portuguese_vocab_trainer/models/word_entry.dart';
import 'package:portuguese_vocab_trainer/models/study_weight.dart';
import 'package:portuguese_vocab_trainer/utils/conjugation_question_builder.dart';

void main() {
  late ConjugationQuestionBuilder builder;

  setUp(() {
    builder = ConjugationQuestionBuilder();
  });

  WordEntry createVerb({
    double baseWeight = 1.0,
    List<WordForm>? forms,
  }) {
    return WordEntry(
      english: 'to be',
      portuguese: 'ser',
      type: 'verb',
      studyWeight: StudyWeight(baseWeight: baseWeight),
      tenses: {
        'present': forms ??
            [
              WordForm(
                person: 'eu',
                english: 'I am',
                portuguese: 'eu sou',
              ),
              WordForm(
                person: 'tu',
                english: 'you are',
                portuguese: 'tu és',
              ),
              WordForm(
                person: 'você',
                english: 'you are',
                portuguese: 'você é',
              ),
              WordForm(
                person: 'nós',
                english: 'we are',
                portuguese: 'nós somos',
              ),
              WordForm(
                person: 'eles',
                english: 'they are',
                portuguese: 'eles são',
              ),
              WordForm(
                person: 'elas',
                english: 'they are',
                portuguese: 'elas são',
              ),
            ],
      },
    );
  }

  group('ConjugationQuestionBuilder', () {
    test('creates questions with the correct infinitive and person', () {
      final questions = builder.buildQuestions(
        pool: [createVerb()],
      );

      final question = questions.firstWhere(
        (question) => question.person == 'tu',
      );

      expect(question.infinitive, 'ser');
      expect(question.person, 'tu');
      expect(question.englishInfinitive, 'to be');
      expect(question.correctAnswer, 'és');
    });

    test('creates the correct English person with hints', () {
      final verb = createVerb(
        forms: [
          WordForm(
            person: 'tu',
            english: 'you are',
            portuguese: 'tu és',
            englishPersonHint: 'informal',
          ),
          WordForm(
            person: 'você',
            english: 'you are',
            portuguese: 'você é',
            englishPersonHint: 'singular, formal',
          ),
          WordForm(
            person: 'eles',
            english: 'they are',
            portuguese: 'eles são',
            englishPersonHint: 'plural masculine',
          ),
          WordForm(
            person: 'nós',
            english: 'we are',
            portuguese: 'nós somos',
          ),
        ],
      );

      final questions = builder.buildQuestions(pool: [verb]);

      expect(
        questions.firstWhere((q) => q.person == 'tu').englishPerson,
        'you (informal)',
      );
      expect(
        questions.firstWhere((q) => q.person == 'você').englishPerson,
        'you (singular, formal)',
      );
      expect(
        questions.firstWhere((q) => q.person == 'eles').englishPerson,
        'they (plural masculine)',
      );
      expect(
        questions.firstWhere((q) => q.person == 'nós').englishPerson,
        'we',
      );
    });

    test('keeps questions for persons with duplicate conjugated forms', () {
      final questions = builder.buildQuestions(
        pool: [createVerb()],
      );

      expect(
        questions.where((q) => q.person == 'eles'),
        hasLength(1),
      );
      expect(
        questions.where((q) => q.person == 'elas'),
        hasLength(1),
      );

      final eles = questions.firstWhere((q) => q.person == 'eles');
      final elas = questions.firstWhere((q) => q.person == 'elas');

      expect(eles.correctAnswer, 'são');
      expect(elas.correctAnswer, 'são');
    });

    test('skips verbs without present tense', () {
      final verb = WordEntry(
        english: 'to be',
        portuguese: 'ser',
        type: 'verb',
        tenses: {
          'past': [
            WordForm(
              person: 'eu',
              english: 'I was',
              portuguese: 'eu era',
            ),
            WordForm(
              person: 'tu',
              english: 'you were',
              portuguese: 'tu eras',
            ),
            WordForm(
              person: 'ele',
              english: 'he was',
              portuguese: 'ele era',
            ),
            WordForm(
              person: 'nós',
              english: 'we were',
              portuguese: 'nós éramos',
            ),
          ],
        },
      );

      final questions = builder.buildQuestions(pool: [verb]);

      expect(questions, isEmpty);
    });

    test('options contain bare conjugated forms without pronouns', () {
      final questions = builder.buildQuestions(
        pool: [createVerb()],
      );

      for (final question in questions) {
        expect(question.options, hasLength(4));

        for (final option in question.options) {
          expect(option, isNot(contains(' ')));
        }
      }
    });

    test('all options belong to the same verb', () {
      final questions = builder.buildQuestions(
        pool: [createVerb()],
      );

      const validForms = {'sou', 'és', 'é', 'somos', 'são'};

      for (final question in questions) {
        for (final option in question.options) {
          expect(validForms, contains(option));
        }
      }
    });

    test('each question has exactly one correct answer', () {
      final questions = builder.buildQuestions(
        pool: [createVerb()],
      );

      for (final question in questions) {
        expect(
          question.options.where(
            (option) => option == question.correctAnswer,
          ),
          hasLength(1),
        );
      }
    });

    test('duplicate conjugated forms are not repeated in options', () {
      final questions = builder.buildQuestions(
        pool: [createVerb()],
      );

      for (final question in questions) {
        expect(
          question.options.toSet().length,
          question.options.length,
        );
      }
    });

    test('skips verbs with fewer than four unique conjugated forms', () {
      final verb = createVerb(
        forms: [
          WordForm(
            person: 'eu',
            english: 'I am',
            portuguese: 'eu sou',
          ),
          WordForm(
            person: 'tu',
            english: 'you are',
            portuguese: 'tu és',
          ),
          WordForm(
            person: 'você',
            english: 'you are',
            portuguese: 'você é',
          ),
          WordForm(
            person: 'ele',
            english: 'he is',
            portuguese: 'ele é',
          ),
        ],
      );

      final questions = builder.buildQuestions(pool: [verb]);

      expect(questions, isEmpty);
    });

    test('question weight is the product of verb and form weights', () {
      final verb = createVerb(
        baseWeight: 2.0,
        forms: [
          WordForm(
            person: 'eu',
            english: 'I am',
            portuguese: 'eu sou',
            studyWeight: const StudyWeight(baseWeight: 0.5),
          ),
          WordForm(
            person: 'tu',
            english: 'you are',
            portuguese: 'tu és',
            studyWeight: const StudyWeight(baseWeight: 0.8),
          ),
          WordForm(
            person: 'você',
            english: 'you are',
            portuguese: 'você é',
            studyWeight: const StudyWeight(baseWeight: 1.0),
          ),
          WordForm(
            person: 'nós',
            english: 'we are',
            portuguese: 'nós somos',
            studyWeight: const StudyWeight(baseWeight: 1.0),
          ),
        ],
      );

      final questions = builder.buildQuestions(pool: [verb]);

      final question = questions.firstWhere(
        (question) => question.person == 'eu',
      );

      expect(question.studyWeight.baseWeight, 1.0);
      expect(question.studyWeight.effectiveWeight, 1.0);
    });

    test('question weight includes learning multipliers', () {
      final verb = WordEntry(
        english: 'to be',
        portuguese: 'ser',
        type: 'verb',
        studyWeight: const StudyWeight(
          baseWeight: 2.0,
          learningMultiplier: 3.0,
        ),
        tenses: {
          'present': [
            WordForm(
              person: 'eu',
              english: 'I am',
              portuguese: 'eu sou',
              studyWeight: const StudyWeight(
                baseWeight: 0.5,
                learningMultiplier: 2.0,
              ),
            ),
            WordForm(
              person: 'tu',
              english: 'you are',
              portuguese: 'tu és',
            ),
            WordForm(
              person: 'você',
              english: 'you are',
              portuguese: 'você é',
            ),
            WordForm(
              person: 'nós',
              english: 'we are',
              portuguese: 'nós somos',
            ),
          ],
        },
      );

      final questions = builder.buildQuestions(pool: [verb]);

      final question = questions.firstWhere(
        (question) => question.person == 'eu',
      );

      expect(question.studyWeight.baseWeight, 1.0);
      expect(question.studyWeight.learningMultiplier, 6.0);
      expect(question.studyWeight.effectiveWeight, 6.0);
    });

    test('nextQuestion throws when the question list is empty', () {
      expect(
        () => builder.nextQuestion([]),
        throwsStateError,
      );
    });
  });
}
