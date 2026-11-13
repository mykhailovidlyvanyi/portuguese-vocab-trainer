// test/utils/multiple_choice_options_builder_test.dart

import 'package:flutter_test/flutter_test.dart';

import 'package:portuguese_vocab_trainer/models/word_entry.dart';
import 'package:portuguese_vocab_trainer/utils/multiple_choice_options_builder.dart';

void main() {
  group('MultipleChoiceOptionsBuilder', () {
    final builder = MultipleChoiceOptionsBuilder();

    final pool = [
      WordEntry(english: 'to be', portuguese: 'ser', type: 'verb'),
      WordEntry(english: 'to be', portuguese: 'estar', type: 'verb'),
      WordEntry(english: 'to have', portuguese: 'ter', type: 'verb'),
      WordEntry(english: 'to go', portuguese: 'ir', type: 'verb'),
      WordEntry(english: 'to do', portuguese: 'fazer', type: 'verb'),
    ];

    test('returns exactly four options', () {
      final options = builder.buildOptions(
        pool: pool,
        correctWord: pool[0],
        showEnglish: true,
      );

      expect(options.length, 4);
    });

    test('returns unique options', () {
      final options = builder.buildOptions(
        pool: pool,
        correctWord: pool[0],
        showEnglish: true,
      );

      final normalizedOptions =
          options.map((option) => option.toLowerCase()).toSet();

      expect(normalizedOptions.length, 4);
    });

    test('removes duplicate English translations', () {
      final options = builder.buildOptions(
        pool: pool,
        correctWord: pool[0],
        showEnglish: false,
      );

      expect(
        options.where((option) => option.toLowerCase() == 'to be').length,
        1,
      );
    });

    test('throws StateError when there are not enough unique answers', () {
      final smallPool = [
        WordEntry(english: 'to be', portuguese: 'ser', type: 'verb'),
        WordEntry(english: 'to be', portuguese: 'estar', type: 'verb'),
        WordEntry(english: 'to have', portuguese: 'ter', type: 'verb'),
      ];

      expect(
        () => builder.buildOptions(
          pool: smallPool,
          correctWord: smallPool[0],
          showEnglish: false,
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
