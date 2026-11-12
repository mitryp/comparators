// ignore_for_file: deprecated_member_use_from_same_package

import 'package:comparators/comparators.dart';
import 'package:comparators/extensions.dart';
import 'package:test/test.dart';

import 'not_comparable.dart';
import 'utils.dart';

void main() {
  final comparator = compare<NotComparable>((nc) => nc.intValue).then(
    compareBool<NotComparable>((nc) => nc.boolValue),
  );

  group('Extensions tests', () {
    test('`ComparatorChaining` extension breaks ties', () {
      repeatSeeded((rand) {
        final list = rList(rand);
        final expected = [...list]..sort(matcherComparator);

        list.sort(comparator);

        expect(list, orderedEquals(expected));
      });
    });

    test('`ComparatorReversing` extension reverses the order', () {
      repeatSeeded((rand) {
        final list = rList(rand);
        final expected = ([...list]..sort(matcherComparator)).reversed.toList();

        list.sort(comparator.reversed);

        expect(list, orderedEquals(expected));
      });
    });
  });
}
