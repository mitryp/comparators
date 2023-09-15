import 'dart:math' show Random;

import 'package:comparators/comparators.dart';
import 'package:comparators/extensions.dart';
import 'package:comparators/src/extensions/list_extension.dart';
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

  group('Comparator extensions tests', () {
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

  group('List extension tests', () {
    List<int> rIntList() =>
        List.generate(randomListLength, (_) => rand.nextInt(99999));

    test(
      'All methods throw a TypeError when used on a list '
      'of not comparable elements without a custom comparator',
      () => repeat(times: testRuns, () {
        final l = rList(rand);

        expect(l.min, throwsA(isA<TypeError>()));
        expect(l.max, throwsA(isA<TypeError>()));
        expect(l.isSorted, throwsA(isA<TypeError>()));
      }),
    );

    test(
      'Neither method throws when a comparator supplied',
      () => repeat(times: testRuns, () {
        final l = rList(rand);
        int comparator(NotComparable a, NotComparable b) => 1;

        expect(() => l.min(comparator), returnsNormally);
        expect(() => l.max(comparator), returnsNormally);
        expect(() => l.isSorted(comparator), returnsNormally);
      }),
    );

    test(
      '`isSorted` method works correctly',
      () => repeat(times: testRuns, () {
        final list = rIntList();

        expect(list.isSorted(), equals(_isSorted(list)));

        list.sort();

        expect(list.isSorted(), equals(_isSorted(list)));

        final reverseComparator = Comparable.compare.reversed;

        list.sort(reverseComparator);
        expect(list.isSorted(reverseComparator),
            equals(_isSorted(list, reverseComparator)));
      }),
    );
  });
}

bool _isSorted<E>(List<E> list, [Comparator<E>? comparator]) {
  final copy = list.toList()..sort(comparator);

  return _listEquality(list, copy);
}

bool _listEquality<E>(List<E> l1, List<E> l2) {
  if (l1.length != l2.length) {
    return false;
  }

  for (var i = 0; i < l1.length; i++) {
    if (l1[i] != l2[i]) return false;
  }

  return true;
}
