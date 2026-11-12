import 'dart:math' show Random;

import 'not_comparable.dart';

const testRuns = 200;
const randomListLength = 20;

/// Runs [body] [testRuns] times with a seeded [Random], so failures are reproducible.
void repeatSeeded(void Function(Random rand) body) {
  for (var seed = 0; seed < testRuns; seed++) {
    body(Random(seed));
  }
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

List<int> ints(Iterable<NotComparable> list) =>
    list.map((nc) => nc.intValue).toList();

List<bool> bools(Iterable<NotComparable> list) =>
    list.map((nc) => nc.boolValue).toList();
