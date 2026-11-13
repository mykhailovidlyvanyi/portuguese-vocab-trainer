// test/utils/study_session_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:portuguese_vocab_trainer/models/word_entry.dart';
import 'package:portuguese_vocab_trainer/utils/study_session.dart';

void main() {
  group('StudySession', () {
    late List<WordEntry> words;

    setUp(() {
      words = [
        WordEntry(
          english: 'apple',
          portuguese: 'maçã',
        ),
        WordEntry(
          english: 'house',
          portuguese: 'casa',
        ),
      ];
    });

    test('starts with a word from the pool', () {
      final session = StudySession(
        pool: words,
        mode: 'enToPt',
      );

      expect(words.contains(session.current), isTrue);
    });

    test('uses English to Portuguese direction', () {
      final session = StudySession(
        pool: words,
        mode: 'enToPt',
      );

      expect(session.showEnglish, isTrue);
      expect(session.expectedAnswer, session.current.portuguese);
    });

    test('uses Portuguese to English direction', () {
      final session = StudySession(
        pool: words,
        mode: 'ptToEn',
      );

      expect(session.showEnglish, isFalse);
      expect(session.expectedAnswer, session.current.english);
    });

    test('accepts correct answer', () {
      final session = StudySession(
        pool: words,
        mode: 'enToPt',
      );

      final result = session.checkAnswer(session.expectedAnswer);

      expect(result, isTrue);
      expect(session.stats.correct, 1);
      expect(session.stats.incorrect, 0);
      expect(session.stats.total, 1);
    });

    test('accepts answer with different case and whitespace', () {
      final session = StudySession(
        pool: words,
        mode: 'enToPt',
      );

      final answer = '  ${session.expectedAnswer.toUpperCase()}  ';
      final result = session.checkAnswer(answer);

      expect(result, isTrue);
    });

    test('rejects incorrect answer', () {
      final session = StudySession(
        pool: words,
        mode: 'enToPt',
      );

      final result = session.checkAnswer('incorrect');

      expect(result, isFalse);
      expect(session.stats.correct, 0);
      expect(session.stats.incorrect, 1);
      expect(session.stats.total, 1);
    });

    test('selects another word through nextWord', () {
      final session = StudySession(
        pool: [words.first],
        mode: 'enToPt',
      );

      session.nextWord();

      expect(session.current, words.first);
      expect(session.showEnglish, isTrue);
    });
  });
}
