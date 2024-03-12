import 'dart:math' show Random;

import 'not_comparable.dart';

const testRuns = 1000;
const randomListLength = 20;

/// Checks whether the given [list] of [NotComparable] is sorted with the given [comparator].
bool isSorted(List<NotComparable> list,
    {required Comparator<NotComparable> comparator}) {
  for (var i = 0; i < list.length - 1; i++) {
    if (comparator(list[i], list[i + 1]) > 0) return false;
  }

  return true;
}

/// Generates a list of [randomListLength] of random [NotComparable] objects.
List<NotComparable> rList(Random rand) =>
    List.generate(randomListLength, (_) => NotComparable.random(rand));

/// A comparator comparing first by [NotComparable.intValue], and then by [NotComparable.boolValue].
int matcherComparator(NotComparable a, NotComparable b) {
  if (a.intValue != b.intValue) return a.intValue.compareTo(b.intValue);

  final aB = a.boolValue ? 1 : 0, bB = b.boolValue ? 1 : 0;

  return aB.compareTo(bB);
}
