// lib/utils/word_selector.dart

import 'package:flutter/foundation.dart';

import '../models/word_entry.dart';
import 'weighted_random_selector.dart';

class WordSelector {
  final WeightedRandomSelector<WordEntry> _selector =
      WeightedRandomSelector<WordEntry>();

  WordEntry nextWord(List<WordEntry> pool) {
    final selected = _selector.next(
      items: pool,
      getWeight: (word) => word.studyWeight.effectiveWeight,
    );

    debugPrint(
      'Selected word: ${selected.portuguese} (${selected.english}) | '
      'Base Weight: ${selected.studyWeight.baseWeight} | '
      'Learning Multiplier: ${selected.studyWeight.learningMultiplier} | '
      'Effective Weight: ${selected.studyWeight.effectiveWeight}',
    );

    return selected;
  }
}