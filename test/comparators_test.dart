import 'dart:math';

import 'package:comparators/comparators.dart';
import 'package:comparators/src/util.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:test_utils/test_utils.dart';

import 'not_comparable.dart';
import 'utils.dart' as utils;

void main() {
  final rand = Random();

  group('Utils tests', () {
    test(
      '`identityTransformer` works correctly',
      () => repeat(times: utils.testRuns, () {
        final i = rand.nextInt(99999);

        expect(identityTransformer(i), equals(i));
      }),
    );

    test(
      '`boolTransformer` works correctly',
      () => repeat(times: utils.testRuns, () {
        final b = rand.nextBool();
        final matcher = [false, true].indexOf(b);

        expect(boolTransformer(b), equals(matcher));
      }),
    );
  });

  group('Comparators tests', () {
    test(
      '`compareTransformed` works correctly',
      () => repeat(times: utils.testRuns, () {
        final list = utils.rList(rand);
        // ignore: deprecated_member_use_from_same_package
        final comparator = compareTransformed<NotComparable, NotComparable>(
          (nc) => nc,
          (nc) => nc.intValue,
        );

        list.sort(comparator);

        expect(utils.isSorted(list, comparator: comparator), isTrue);
      }),
    );

    test(
      '`compare` works correctly',
      () => repeat(times: utils.testRuns, () {
        final list = utils.rList(rand);
        final comparator = compare<NotComparable>((nc) => nc.intValue);

        list.sort(comparator);

        expect(utils.isSorted(list, comparator: comparator), isTrue);
      }),
    );

    test(
      '`compareInverse` works correctly',
      () => repeat(times: utils.testRuns, () {
        final list = utils.rList(rand);
        final comparator = compareInverse<NotComparable>((nc) => nc.intValue);

        list.sort(comparator);

        expect(utils.isSorted(list, comparator: (a, b) => comparator(b, a)),
            isTrue);
      }),
    );

    test(
      '`compareBool` works correctly',
      () => repeat(times: utils.testRuns, () {
        final list = utils.rList(rand);
        final comparator = compareBool<NotComparable>((nc) => nc.boolValue);

        list.sort(comparator);

        expect(utils.isSorted(list, comparator: comparator), isTrue);
      }),
    );

    test(
      '`compareSequentially` works correctly',
      () => repeat(times: utils.testRuns, () {
        final list = utils.rList(rand);
        final matcher = [...list];

        final comparator = compareSequentially<NotComparable>([
          compare((nc) => nc.intValue),
          compareBool((nc) => nc.boolValue),
        ]);

        list.sort(comparator);
        matcher.sort(utils.matcherComparator);

        expect(list, orderedEquals(matcher));
      }),
    );
  });
}
