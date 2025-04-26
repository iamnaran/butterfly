

import 'dart:math';

class AppUtils {
  static final _random = Random();

  /// Generates a random integer between [min] and [max] (inclusive).
  static int getRandomInt({int min = 0, int max = 999999}) {
    assert(min <= max, 'min should be less than or equal to max');
    return min + _random.nextInt(max - min + 1);
  }
}