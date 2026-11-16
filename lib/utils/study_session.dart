// lib/utils/study_session.dart

import 'dart:math';

import '../models/word_entry.dart';
import 'session_stats.dart';
import 'word_selector.dart';

class StudySession {
  final List<WordEntry> pool;
  final String mode;

  final WordSelector selector = WordSelector();
  final SessionStats stats = SessionStats();
  final Random _random = Random();

  late WordEntry current;
  late bool showEnglish;

  StudySession({
    required this.pool,
    required this.mode,
  }) {
    current = selector.nextWord(pool);
    showEnglish = _getNextDirection();
  }

  bool _getNextDirection() {
    if (mode == 'enToPt') return true;
    if (mode == 'ptToEn') return false;

    return _random.nextBool();
  }

  String? get currentPronoun {
    if (current.type != 'verb' ||
        !current.isConjugatedForm ||
        current.person == null) {
      return null;
    }

    if (showEnglish) {
      // English → Portuguese
      return current.person;
    }

    // Portuguese → English
    const englishPronouns = {
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

    return englishPronouns[current.person];
  }

  String get portugueseAnswer => current.portuguese.trim();

  String get englishAnswer => current.english.trim();

  void nextWord() {
    current = selector.nextWord(pool);
    showEnglish = _getNextDirection();
  }

  bool checkAnswer(String answer) {
    final expected = showEnglish
        ? portugueseAnswer.toLowerCase()
        : englishAnswer.toLowerCase();

    final normalized = answer.trim().toLowerCase();
    final isCorrect = normalized == expected;

    stats.answerSubmitted(isCorrect: isCorrect);

    return isCorrect;
  }

  String get expectedAnswer {
    return showEnglish ? portugueseAnswer : englishAnswer;
  }
}
