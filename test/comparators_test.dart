import 'dart:math';

import 'package:comparators/comparators.dart';
import 'package:comparators/src/util.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:test_utils/test_utils.dart';

import 'not_comparable.dart';
import 'utils.dart';

void main() {
  final rand = Random();

  group('Utils tests', () {
    test(
      '`identityTransformer` works correctly',
      () => repeat(times: testRuns, () {
        final i = rand.nextInt(99999);

        expect(identityTransformer(i), equals(i));
      }),
    );

    test(
      '`boolTransformer` works correctly',
      () => repeat(times: testRuns, () {
        final b = rand.nextBool();
        final matcher = [false, true].indexOf(b);

        expect(boolTransformer(b), equals(matcher));
      }),
    );
  });

  group('Comparators tests', () {
    test(
      '`compareTransformed` works correctly',
      () => repeat(times: testRuns, () {
        final list = rList(rand);
        final comparator = compareTransformed<NotComparable, NotComparable>(
          (nc) => nc,
          (nc) => nc.intValue,
        );

        list.sort(comparator);

        expect(isSorted(list, comparator: comparator), isTrue);
      }),
    );

    test(
      '`compare` works correctly',
      () => repeat(times: testRuns, () {
        final list = rList(rand);
        final comparator = compare<NotComparable>((nc) => nc.intValue);

        list.sort(comparator);

        expect(isSorted(list, comparator: comparator), isTrue);
      }),
    );

    test(
      '`compareBool` works correctly',
      () => repeat(times: testRuns, () {
        final list = rList(rand);
        final comparator = compareBool<NotComparable>((nc) => nc.boolValue);

        list.sort(comparator);

        expect(isSorted(list, comparator: comparator), isTrue);
      }),
    );
  });
}
