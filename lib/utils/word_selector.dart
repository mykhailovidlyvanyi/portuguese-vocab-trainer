// utils/word_selector.dart

import '../models/word_entry.dart';
import 'dart:math';

class WordSelector {
  final Random _random = Random();

  WordEntry nextWord(List<WordEntry> pool) {
    final weightedPool = <WordEntry>[];
    for (var word in pool) {
      int count = (word.weight * 100).round();
      weightedPool.addAll(List.filled(count, word));
    }
    return weightedPool[_random.nextInt(weightedPool.length)];
  }
}
