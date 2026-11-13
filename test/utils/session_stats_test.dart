//test/utils/session_stats_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:portuguese_vocab_trainer/utils/session_stats.dart';

void main() {
  group('SessionStats', () {
    late SessionStats stats;

    setUp(() {
      stats = SessionStats();
    });

    test('starts with zero statistics', () {
      expect(stats.correct, 0);
      expect(stats.incorrect, 0);
      expect(stats.total, 0);
    });

    test('counts correct answers', () {
      stats.answerSubmitted(isCorrect: true);

      expect(stats.correct, 1);
      expect(stats.incorrect, 0);
      expect(stats.total, 1);
    });

    test('counts incorrect answers', () {
      stats.answerSubmitted(isCorrect: false);

      expect(stats.correct, 0);
      expect(stats.incorrect, 1);
      expect(stats.total, 1);
    });

    test('counts multiple submitted answers', () {
      stats.answerSubmitted(isCorrect: true);
      stats.answerSubmitted(isCorrect: false);
      stats.answerSubmitted(isCorrect: true);

      expect(stats.correct, 2);
      expect(stats.incorrect, 1);
      expect(stats.total, 3);
    });
  });
}