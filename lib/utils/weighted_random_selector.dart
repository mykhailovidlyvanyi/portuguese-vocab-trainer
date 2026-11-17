// lib/utils/weighted_random_selector.dart

import 'dart:math';

class WeightedRandomSelector<T> {
  final Random _random;

  WeightedRandomSelector({Random? random}) : _random = random ?? Random();

  T next({
    required List<T> items,
    required double Function(T item) getWeight,
  }) {
    if (items.isEmpty) {
      throw StateError('No items available for selection.');
    }

    final weights = items.map((item) {
      final weight = getWeight(item);
      return weight.isFinite && weight > 0 ? weight : 0.0;
    }).toList();

    final maxWeight = weights.reduce(max);

    if (maxWeight == 0) {
      return items[_random.nextInt(items.length)];
    }

    // Масштабуємо ваги, щоб уникнути переповнення суми.
    final normalizedWeights =
    weights.map((weight) => weight / maxWeight).toList();

    final totalWeight = normalizedWeights.reduce((a, b) => a + b);

    var randomWeight = _random.nextDouble() * totalWeight;

    for (var i = 0; i < items.length; i++) {
      randomWeight -= normalizedWeights[i];

      if (randomWeight < 0) {
        return items[i];
      }
    }

    return items.last;
  }
}
