// test/utils/word_pool_builder_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:portuguese_vocab_trainer/models/word_category.dart';
import 'package:portuguese_vocab_trainer/models/word_entry.dart';
import 'package:portuguese_vocab_trainer/utils/word_pool_builder.dart';

void main() {
  group('WordPoolBuilder', () {
    late WordPoolBuilder builder;

    setUp(() {
      builder = WordPoolBuilder();
    });

    test('collects words from a category', () {
      final apple = WordEntry(
        english: 'apple',
        portuguese: 'maçã',
      );

      final banana = WordEntry(
        english: 'banana',
        portuguese: 'banana',
      );

      final category = WordCategory(
        name: 'Fruits',
        words: [apple, banana],
      );

      final result = builder.fromCategory(category);

      expect(result, [apple, banana]);
    });

    test('collects words recursively from subcategories', () {
      final dog = WordEntry(
        english: 'dog',
        portuguese: 'cão',
      );

      final cat = WordEntry(
        english: 'cat',
        portuguese: 'gato',
      );

      final lion = WordEntry(
        english: 'lion',
        portuguese: 'leão',
      );

      final category = WordCategory(
        name: 'Animals',
        subcategories: [
          WordCategory(
            name: 'Pets',
            words: [dog, cat],
          ),
          WordCategory(
            name: 'Wild animals',
            subcategories: [
              WordCategory(
                name: 'Big cats',
                words: [lion],
              ),
            ],
          ),
        ],
      );

      final result = builder.fromCategory(category);

      expect(result, [dog, cat, lion]);
    });

    test('collects words from multiple categories', () {
      final apple = WordEntry(
        english: 'apple',
        portuguese: 'maçã',
      );

      final dog = WordEntry(
        english: 'dog',
        portuguese: 'cão',
      );

      final categories = [
        WordCategory(
          name: 'Fruits',
          words: [apple],
        ),
        WordCategory(
          name: 'Animals',
          words: [dog],
        ),
      ];

      final result = builder.fromCategories(categories);

      expect(result, [apple, dog]);
    });
  });
}
