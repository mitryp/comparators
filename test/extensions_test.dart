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
  // ignore: deprecated_member_use_from_same_package
  final comparator = compare<NotComparable>((nc) => nc.intValue).then(
    compareBool<NotComparable>((nc) => nc.boolValue),
  );

  group('Extensions tests', () {
    test(
      '`ComparatorChaining` extension works correctly',
      () => repeat(times: testRuns, () {
        final list = rList(rand);

        final listMatcher = list.toList();

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

        // ignore: deprecated_member_use_from_same_package
        list.sort(comparator.reversed);
        listMatcher = (listMatcher..sort(comparator)).reversed.toList();

        expect(list, orderedEquals(listMatcher));
      }),
    );
  });
}
