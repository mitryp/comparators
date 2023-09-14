import 'dart:math' show Random;

import 'package:comparators/comparators.dart';
import 'package:comparators/extensions.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:test_utils/test_utils.dart';

import 'not_comparable.dart';
import 'utils.dart';

void main() {
  final rand = Random();
  final comparator = compare<NotComparable>((nc) => nc.intValue).then(
    compareBool<NotComparable>((nc) => nc.boolValue),
  );

  group('Extensions tests', () {
    test(
      '`ComparatorChaining` extension works correctly',
      () => repeat(times: testRuns, () {
        final list = rList(rand);

        final listMatcher = list.toList();
        int matcherComparator(NotComparable a, NotComparable b) {
          if (a.intValue != b.intValue) return a.intValue.compareTo(b.intValue);

          final aB = a.boolValue ? 1 : 0, bB = b.boolValue ? 1 : 0;

          return aB.compareTo(bB);
        }

        list.sort(comparator);
        listMatcher.sort(matcherComparator);

        expect(list, orderedEquals(listMatcher));
      }),
    );

    test(
      '`ComparatorReversing` extension works correctly',
      () => repeat(times: testRuns, () {
        final list = rList(rand);
        var listMatcher = list.toList();

        list.sort(comparator.reversed);
        listMatcher = (listMatcher..sort(comparator)).reversed.toList();

        expect(list, orderedEquals(listMatcher));
      }),
    );
  });
}
