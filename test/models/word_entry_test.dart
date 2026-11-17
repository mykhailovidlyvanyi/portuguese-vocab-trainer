// test/models/word_entry_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:portuguese_vocab_trainer/models/word_entry.dart';
import 'package:portuguese_vocab_trainer/models/study_weight.dart';

const genderData = {
  'masculine': {
    'english': 'masculine',
    'portuguese': 'masculino',
    'article': 'o',
  },
  'feminine': {
    'english': 'feminine',
    'portuguese': 'feminino',
    'article': 'a',
  },
};

void main() {
  group('WordEntry.fromJson', () {
    test('creates WordEntry with required fields', () {
      final word = WordEntry.fromJson({
        'english': 'to speak',
        'portuguese': 'falar',
      });

      expect(word.english, 'to speak');
      expect(word.portuguese, 'falar');
      expect(word.type, 'word');
      expect(word.studyWeight.baseWeight, 1.0);
      expect(word.studyWeight.learningMultiplier, 1.0);
      expect(word.isConjugatedForm, false);
      expect(word.englishHint, isNull);
      expect(word.portugueseHint, isNull);
      expect(word.tenses, isEmpty);
    });

    test('loads hints correctly', () {
      final word = WordEntry.fromJson({
        'english': 'house',
        'portuguese': 'casa',
        'type': 'noun',
        'hints': {
          'english': 'building',
          'portuguese': 'habitação',
        },
      });

      expect(word.englishHint, 'building');
      expect(word.portugueseHint, 'habitação');
    });

    test('loads numericValue correctly', () {
      final word = WordEntry.fromJson({
        'english': 'twenty',
        'portuguese': 'vinte',
        'type': 'number',
        'numericValue': 20,
      });

      expect(word.numericValue, 20);
    });

    test('loads person correctly', () {
      final word = WordEntry.fromJson({
        'english': 'I speak',
        'portuguese': 'falo',
        'type': 'verb',
        'person': 'eu',
      });

      expect(word.person, 'eu');
    });

    test('loads tenses and WordForms correctly', () {
      final word = WordEntry.fromJson({
        'english': 'to speak',
        'portuguese': 'falar',
        'type': 'verb',
        'tenses': {
          'present': [
            {
              'person': 'eu',
              'english': 'I speak',
              'portuguese': 'falo',
              'hints': {
                'english': 'first person',
                'portuguese': 'primeira pessoa',
              },
            },
          ],
        },
      });

      expect(word.tenses.keys, contains('present'));

      final forms = word.tenses['present']!;

      expect(forms, hasLength(1));
      expect(forms.first.person, 'eu');
      expect(forms.first.english, 'I speak');
      expect(forms.first.portuguese, 'falo');
      expect(forms.first.englishHint, 'first person');
      expect(forms.first.portugueseHint, 'primeira pessoa');
    });

    test('assigns masculine article automatically', () {
      final word = WordEntry.fromJson({
        'english': 'Saturday',
        'portuguese': 'sábado',
        'type': 'noun',
        'gender': 'masculine',
      }, genderData: genderData);

      expect(word.article, 'o');
      expect(word.gender, 'masculine');
    });

    test('assigns feminine article automatically', () {
      final word = WordEntry.fromJson({
        'english': 'Monday',
        'portuguese': 'segunda-feira',
        'type': 'noun',
        'gender': 'feminine',
      }, genderData: genderData);

      expect(word.article, 'a');
      expect(word.gender, 'feminine');
    });

    test('does not expose gender as a hint', () {
      final word = WordEntry.fromJson({
        'english': 'Monday',
        'portuguese': 'segunda-feira',
        'type': 'noun',
        'gender': 'feminine',
      }, genderData: genderData);

      expect(word.englishHint, isNull);
      expect(word.portugueseHint, isNull);
    });

    test('explicit article takes precedence over genderData', () {
      final word = WordEntry.fromJson({
        'english': 'Monday',
        'portuguese': 'segunda-feira',
        'type': 'noun',
        'gender': 'feminine',
        'article': 'the',
      }, genderData: genderData);

      expect(word.article, 'the');
    });

    test('does not assign article when gender is missing', () {
      final word = WordEntry.fromJson({
        'english': 'word',
        'portuguese': 'palavra',
        'type': 'noun',
      }, genderData: genderData);

      expect(word.article, isNull);
      expect(word.gender, isNull);
    });
  });

  group('WordEntry.copyWith', () {
    test('changes studyWeight', () {
      final word = WordEntry(
        english: 'house',
        portuguese: 'casa',
        studyWeight: const StudyWeight(baseWeight: 1.0),
      );

      final copiedWord = word.copyWith(
        studyWeight: const StudyWeight(baseWeight: 2.0),
      );

      expect(copiedWord.studyWeight.baseWeight, 2.0);
      expect(word.studyWeight.baseWeight, 1.0);
    });

    test('preserves all other fields when copying', () {
      final word = WordEntry(
        english: 'Saturday',
        portuguese: 'sábado',
        type: 'noun',
        studyWeight: const StudyWeight(baseWeight: 1.5),
        englishHint: 'day of the week',
        portugueseHint: 'dia da semana',
        numericValue: 7,
        person: 'eu',
        article: 'o',
        gender: 'masculine',
      );

      final copiedWord = word.copyWith(
        studyWeight: const StudyWeight(baseWeight: 2.0),
      );

      expect(copiedWord.english, word.english);
      expect(copiedWord.portuguese, word.portuguese);
      expect(copiedWord.type, word.type);
      expect(copiedWord.isConjugatedForm, word.isConjugatedForm);
      expect(copiedWord.englishHint, word.englishHint);
      expect(copiedWord.portugueseHint, word.portugueseHint);
      expect(copiedWord.numericValue, word.numericValue);
      expect(copiedWord.person, word.person);
      expect(copiedWord.article, word.article);
      expect(copiedWord.gender, word.gender);
      expect(copiedWord.tenses, same(word.tenses));
    });

    test('preserves studyWeight when no new value is provided', () {
      final word = WordEntry(
        english: 'house',
        portuguese: 'casa',
        studyWeight: const StudyWeight(
          baseWeight: 1.5,
          learningMultiplier: 2.0,
        ),
      );

      final copiedWord = word.copyWith();

      expect(copiedWord.studyWeight.baseWeight, 1.5);
      expect(copiedWord.studyWeight.learningMultiplier, 2.0);
    });
  });

  group('WordEntry.toStudyEntries', () {
    test('returns the original form when there are no tenses', () {
      final word = WordEntry(
        english: 'house',
        portuguese: 'casa',
        type: 'noun',
      );

      final entries = word.toStudyEntries();

      expect(entries, hasLength(1));
      expect(entries.first.english, 'house');
      expect(entries.first.portuguese, 'casa');
      expect(entries.first.isConjugatedForm, false);
    });

    test('uses infinitiveWeight for verbs', () {
      final word = WordEntry(
        english: 'to speak',
        portuguese: 'falar',
        type: 'verb',
      );

      final entries = word.toStudyEntries(infinitiveWeight: 2.5);

      expect(entries.first.studyWeight.baseWeight, 2.5);
    });

    test('preserves original weight for non-verbs', () {
      final word = WordEntry(
        english: 'house',
        portuguese: 'casa',
        type: 'noun',
        studyWeight: const StudyWeight(baseWeight: 1.5),
      );

      final entries = word.toStudyEntries(infinitiveWeight: 3.0);

      expect(entries.first.studyWeight.baseWeight, 1.5);
    });

    test('creates entries for all conjugated forms', () {
      final word = WordEntry(
        english: 'to speak',
        portuguese: 'falar',
        type: 'verb',
        tenses: {
          'present': [
            WordForm(
              person: 'eu',
              english: 'I speak',
              portuguese: 'falo',
            ),
            WordForm(
              person: 'tu',
              english: 'you speak',
              portuguese: 'falas',
            ),
          ],
        },
      );

      final entries = word.toStudyEntries();

      expect(entries, hasLength(3));

      expect(entries[1].english, 'I speak');
      expect(entries[1].portuguese, 'falo');
      expect(entries[1].person, 'eu');
      expect(entries[1].isConjugatedForm, true);

      expect(entries[2].english, 'you speak');
      expect(entries[2].portuguese, 'falas');
      expect(entries[2].person, 'tu');
      expect(entries[2].isConjugatedForm, true);
    });

    test('applies personWeights to conjugated forms', () {
      final word = WordEntry(
        english: 'to speak',
        portuguese: 'falar',
        type: 'verb',
        tenses: {
          'present': [
            WordForm(
              person: 'eu',
              english: 'I speak',
              portuguese: 'falo',
            ),
            WordForm(
              person: 'tu',
              english: 'you speak',
              portuguese: 'falas',
            ),
          ],
        },
      );

      final entries = word.toStudyEntries(
        infinitiveWeight: 2.0,
        personWeights: {
          'eu': 0.5,
          'tu': 1.5,
        },
      );

      expect(entries[0].studyWeight.baseWeight, 2.0);
      expect(entries[1].studyWeight.baseWeight, 0.5);
      expect(entries[2].studyWeight.baseWeight, 1.5);
    });

    test('uses default weight for persons without configured weight', () {
      final word = WordEntry(
        english: 'to speak',
        portuguese: 'falar',
        type: 'verb',
        tenses: {
          'present': [
            WordForm(
              person: 'eu',
              english: 'I speak',
              portuguese: 'falo',
            ),
          ],
        },
      );

      final entries = word.toStudyEntries(
        personWeights: {'tu': 0.5},
      );

      expect(entries[1].studyWeight.baseWeight, 1.0);
    });

    test('does not apply personWeights to non-verbs', () {
      final word = WordEntry(
        english: 'word',
        portuguese: 'palavra',
        type: 'noun',
        tenses: {
          'present': [
            WordForm(
              person: 'eu',
              english: 'I word',
              portuguese: 'palavro',
            ),
          ],
        },
      );

      final entries = word.toStudyEntries(
        personWeights: {'eu': 0.5},
      );

      expect(entries[1].studyWeight.baseWeight, 1.0);
    });

    test('preserves learningMultiplier when creating study entries', () {
      final word = WordEntry(
        english: 'to speak',
        portuguese: 'falar',
        type: 'verb',
        studyWeight: const StudyWeight(
          baseWeight: 1.0,
          learningMultiplier: 2.0,
        ),
        tenses: {
          'present': [
            WordForm(
              person: 'eu',
              english: 'I speak',
              portuguese: 'falo',
              studyWeight: const StudyWeight(
                baseWeight: 1.0,
                learningMultiplier: 3.0,
              ),
            ),
          ],
        },
      );

      final entries = word.toStudyEntries();

      expect(entries[0].studyWeight.learningMultiplier, 2.0);
      expect(entries[1].studyWeight.learningMultiplier, 3.0);
    });

    test('adds person hints to WordForms', () {
      final word = WordEntry(
        english: 'to speak',
        portuguese: 'falar',
        type: 'verb',
        tenses: {
          'present': [
            WordForm(
              person: 'eu',
              english: 'I speak',
              portuguese: 'falo',
            ),
          ],
        },
      );

      final entries = word.toStudyEntries(
        personHints: {
          'eu': {
            'english': 'first person',
            'portuguese': 'primeira pessoa',
          },
        },
      );

      final form = entries.first.tenses['present']!.first;

      expect(form.englishPersonHint, 'first person');
      expect(form.portuguesePersonHint, 'primeira pessoa');
    });

    test('combines and removes duplicate hints', () {
      final word = WordEntry(
        english: 'to speak',
        portuguese: 'falar',
        type: 'verb',
        englishHint: 'communication, speaking',
        portugueseHint: 'comunicação',
        tenses: {
          'present': [
            WordForm(
              person: 'eu',
              english: 'I speak',
              portuguese: 'falo',
              englishHint: 'Speaking, conversation',
              portugueseHint: 'conversa',
            ),
          ],
        },
      );

      final entries = word.toStudyEntries(
        personHints: {
          'eu': {
            'english': 'communication, first person',
            'portuguese': 'comunicação, primeira pessoa',
          },
        },
      );

      final form = entries[1];

      expect(
        form.englishHint,
        'communication, speaking, first person, conversation',
      );

      expect(
        form.portugueseHint,
        'comunicação, primeira pessoa, conversa',
      );
    });

    test('preserves article and gender in study entries', () {
      final word = WordEntry(
        english: 'Saturday',
        portuguese: 'sábado',
        type: 'noun',
        article: 'o',
        gender: 'masculine',
      );

      final entries = word.toStudyEntries();

      expect(entries.first.article, 'o');
      expect(entries.first.gender, 'masculine');
    });
  });

  group('WordForm', () {
    test('creates WordForm with required fields', () {
      final form = WordForm(
        person: 'eu',
        english: 'I speak',
        portuguese: 'falo',
      );

      expect(form.person, 'eu');
      expect(form.english, 'I speak');
      expect(form.portuguese, 'falo');
      expect(form.studyWeight.baseWeight, 1.0);
      expect(form.studyWeight.learningMultiplier, 1.0);
      expect(form.englishHint, isNull);
      expect(form.portugueseHint, isNull);
      expect(form.englishPersonHint, isNull);
      expect(form.portuguesePersonHint, isNull);
    });

    test('loads WordForm from JSON', () {
      final form = WordForm.fromJson({
        'person': 'eu',
        'english': 'I speak',
        'portuguese': 'falo',
        'hints': {
          'english': 'first person',
          'portuguese': 'primeira pessoa',
        },
      });

      expect(form.person, 'eu');
      expect(form.english, 'I speak');
      expect(form.portuguese, 'falo');
      expect(form.englishHint, 'first person');
      expect(form.portugueseHint, 'primeira pessoa');
    });

    test('loads WordForm without optional hints', () {
      final form = WordForm.fromJson({
        'person': 'eu',
        'english': 'I speak',
        'portuguese': 'falo',
      });

      expect(form.englishHint, isNull);
      expect(form.portugueseHint, isNull);
    });

    test('allows person hints and custom studyWeight through constructor', () {
      final form = WordForm(
        person: 'eu',
        english: 'I speak',
        portuguese: 'falo',
        studyWeight: const StudyWeight(
          baseWeight: 0.5,
          learningMultiplier: 2.0,
        ),
        englishPersonHint: 'first person',
        portuguesePersonHint: 'primeira pessoa',
      );

      expect(form.studyWeight.baseWeight, 0.5);
      expect(form.studyWeight.learningMultiplier, 2.0);
      expect(form.englishPersonHint, 'first person');
      expect(form.portuguesePersonHint, 'primeira pessoa');
    });
  });
}
