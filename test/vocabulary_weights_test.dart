// test/vocabulary_weights_test.dart

import 'package:flutter_test/flutter_test.dart';

import 'package:portuguese_vocab_trainer/models/word_category.dart';
import 'package:portuguese_vocab_trainer/models/word_entry.dart';
import 'package:portuguese_vocab_trainer/services/vocabulary_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<WordEntry> words;

  setUpAll(() async {
    final categories = await VocabularyService().loadCategories();
    words = _collectWords(categories);
  });

  group('Verb weights', () {
    test('infinitive has base weight 1.0', () {
      final ser = words.firstWhere(
        (word) =>
            word.type == 'verb' &&
            word.portuguese == 'ser' &&
            word.english == 'to be',
      );

      expect(ser.studyWeight.baseWeight, 1.0);
      expect(ser.studyWeight.learningMultiplier, 1.0);
    });

    test('verb forms have weights according to grammatical person', () {
      const expectedWeights = {
        'eu': 1.0,
        'tu': 1.0,
        'você': 0.33,
        'ele': 0.33,
        'ela': 0.33,
        'nós': 1.0,
        'eles': 0.33,
        'elas': 0.33,
        'vocês': 0.33,
      };

      for (final entry in expectedWeights.entries) {
        final word = words.firstWhere(
          (word) =>
              word.type == 'verb' &&
              word.portuguese == _serFormFor(entry.key) &&
              word.person == entry.key,
        );

        expect(
          word.studyWeight.baseWeight,
          entry.value,
          reason: 'Incorrect weight for ${entry.key}',
        );

        expect(
          word.studyWeight.learningMultiplier,
          1.0,
          reason: 'Unexpected learning multiplier for ${entry.key}',
        );
      }
    });
  });

  group('Number data', () {
    test('all entries with numericValue have type number', () {
      final numericWords =
          words.where((word) => word.numericValue != null).toList();

      expect(numericWords, isNotEmpty);

      for (final word in numericWords) {
        expect(
          word.type,
          'number',
          reason: 'Incorrect type for ${word.portuguese}',
        );
      }
    });

    test('cardinal gender variants have correct gender and weight', () {
      final oneVariants = words
          .where(
            (word) =>
                word.type == 'number' &&
                word.numericValue == 1 &&
                word.english == 'one',
          )
          .toList();

      expect(oneVariants, hasLength(2));

      final genders = oneVariants.map((word) => word.gender).toSet();

      expect(genders, {'masculine', 'feminine'});

      for (final word in oneVariants) {
        expect(
          word.studyWeight.baseWeight,
          0.5,
          reason: 'Incorrect weight for ${word.portuguese}',
        );
        expect(word.studyWeight.learningMultiplier, 1.0);
      }
    });

    test('ordinal gender variants have correct gender and weight', () {
      final firstVariants = words
          .where(
            (word) =>
                word.type == 'number' &&
                word.numericValue == 1 &&
                word.english == 'first',
          )
          .toList();

      expect(firstVariants, hasLength(2));

      final genders = firstVariants.map((word) => word.gender).toSet();

      expect(genders, {'masculine', 'feminine'});

      for (final word in firstVariants) {
        expect(word.studyWeight.baseWeight, 0.5);
        expect(word.studyWeight.learningMultiplier, 1.0);
      }
    });

    test('number without gender variants has base weight 1.0', () {
      final zero = words.firstWhere(
        (word) =>
            word.type == 'number' &&
            word.numericValue == 0 &&
            word.english == 'zero',
      );

      expect(zero.studyWeight.baseWeight, 1.0);
      expect(zero.studyWeight.learningMultiplier, 1.0);
    });

    test('all gender variants have weight 0.5', () {
      final genderGroups = <String, List<WordEntry>>{};

      for (final word in words.where(
        (word) =>
            word.type == 'number' &&
            (word.gender == 'masculine' || word.gender == 'feminine'),
      )) {
        final key = '${word.numericValue}_${word.english}';
        genderGroups.putIfAbsent(key, () => []).add(word);
      }

      for (final entry in genderGroups.entries) {
        final variants = entry.value;

        expect(
          variants.map((word) => word.gender).toSet(),
          {'masculine', 'feminine'},
          reason: 'Missing gender variant in group ${entry.key}',
        );

        for (final word in variants) {
          expect(
            word.studyWeight.baseWeight,
            0.5,
            reason: 'Incorrect weight for ${word.portuguese}',
          );

          expect(
            word.studyWeight.learningMultiplier,
            1.0,
            reason: 'Unexpected learning multiplier for ${word.portuguese}',
          );
        }
      }
    });
  });
}

List<WordEntry> _collectWords(List<WordCategory> categories) {
  final result = <WordEntry>[];

  for (final category in categories) {
    result.addAll(category.words);
    result.addAll(_collectWords(category.subcategories));
  }

  return result;
}

String _serFormFor(String person) {
  const forms = {
    'eu': 'sou',
    'tu': 'és',
    'você': 'é',
    'ele': 'é',
    'ela': 'é',
    'nós': 'somos',
    'eles': 'são',
    'elas': 'são',
    'vocês': 'são',
  };

  return forms[person]!;
}
