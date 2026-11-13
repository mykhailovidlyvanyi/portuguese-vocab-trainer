
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
    test('infinitive has weight 1.0', () {
      final ser = words.firstWhere(
            (word) =>
        word.type == 'verb' &&
            word.portuguese == 'ser' &&
            word.english == 'to be',
      );

      expect(ser.weight, 1.0);
    });

    test('verb forms have weights according to grammatical person', () {
      const expectedWeights = {
        'eu sou': 1.0,
        'tu és': 1.0,
        'você é': 0.33,
        'ele é': 0.33,
        'ela é': 0.33,
        'nós somos': 1.0,
        'eles são': 0.33,
        'elas são': 0.33,
        'vocês são': 0.33,
      };

      for (final entry in expectedWeights.entries) {
        final word = words.firstWhere(
              (word) => word.portuguese == entry.key,
        );

        expect(
          word.weight,
          entry.value,
          reason: 'Incorrect weight for ${entry.key}',
        );
      }
    });
  });

  group('Number weights', () {
    test('masculine and feminine forms have weight 0.5', () {
      final oneVariants = words.where(
            (word) =>
        word.numericValue == 1 &&
            word.english == 'one',
      ).toList();

      expect(oneVariants, hasLength(2));

      for (final word in oneVariants) {
        expect(
          word.weight,
          0.5,
          reason: 'Incorrect weight for ${word.portuguese}',
        );
      }
    });

    test('ordinal gender variants have weight 0.5', () {
      final firstVariants = words.where(
            (word) =>
        word.numericValue == 1 &&
            word.english == 'first',
      ).toList();

      expect(firstVariants, hasLength(2));

      for (final word in firstVariants) {
        expect(word.weight, 0.5);
      }
    });

    test('number without gender variants has weight 1.0', () {
      final zero = words.firstWhere(
            (word) =>
        word.numericValue == 0 &&
            word.english == 'zero',
      );

      expect(zero.weight, 1.0);
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
