import 'package:collection/collection.dart' show compareAsciiLowerCase;
import 'package:comparators/comparators.dart';
import 'package:comparators/src/util.dart';
import 'package:test/test.dart';

import 'not_comparable.dart';
import 'utils.dart';

void main() {
  group('Utils tests', () {
    test('`identityTransformer` returns its argument', () {
      expect(identityTransformer(42), 42);
      expect(identityTransformer('a'), 'a');
    });

    test('`boolTransformer` maps false to 0 and true to 1', () {
      expect(boolTransformer(false), 0);
      expect(boolTransformer(true), 1);
    });
  });

  group('Comparators tests', () {
    test('`compare` sorts in an ascending order', () {
      repeatSeeded((rand) {
        final list = rList(rand);
        final expected = ints(list)..sort();

        list.sort(compare((nc) => nc.intValue));

        expect(ints(list), expected);
      });
    });

    test('`compare` returns the sign of `compareTo`', () {
      final comparator = compare<String>((s) => s);

      expect(comparator('a', 'b'), lessThan(0));
      expect(comparator('b', 'a'), greaterThan(0));
      expect(comparator('a', 'a'), 0);
    });

    test('`compareInverse` sorts in a descending order', () {
      repeatSeeded((rand) {
        final list = rList(rand);
        final expected = ints(list)..sort((a, b) => b.compareTo(a));

        list.sort(compareInverse((nc) => nc.intValue));

        expect(ints(list), expected);
      });
    });

    test('`compareInverse` returns the opposite sign of `compare`', () {
      final comparator = compareInverse<String>((s) => s);

      expect(comparator('a', 'b'), greaterThan(0));
      expect(comparator('b', 'a'), lessThan(0));
      expect(comparator('a', 'a'), 0);
    });

    test('`compareBool` puts false before true', () {
      repeatSeeded((rand) {
        final list = rList(rand);
        final falseCount = list.where((nc) => !nc.boolValue).length;
        final expected = [
          for (var i = 0; i < list.length; i++) i >= falseCount,
        ];

        list.sort(compareBool((nc) => nc.boolValue));

        expect(bools(list), expected);
      });
    });

    test('`compareBoolInverse` puts true before false', () {
      repeatSeeded((rand) {
        final list = rList(rand);
        final trueCount = list.where((nc) => nc.boolValue).length;
        final expected = [
          for (var i = 0; i < list.length; i++) i < trueCount,
        ];

        list.sort(compareBoolInverse((nc) => nc.boolValue));

        expect(bools(list), expected);
      });
    });

    test('`compareNullable` puts nulls last by default', () {
      final list = ['b', null, 'a', null, 'c'];

      list.sort(compareNullable((s) => s));

      expect(list, ['a', 'b', 'c', null, null]);
    });

    test('`compareNullable` puts nulls first with `nullsFirst`', () {
      final list = ['b', null, 'a', null, 'c'];

      list.sort(compareNullable((s) => s, nullsFirst: true));

      expect(list, [null, null, 'a', 'b', 'c']);
    });

    test('`compareNullable` treats two nulls as equal', () {
      expect(compareNullable<String?>((s) => s)(null, null), 0);
    });

    test('`compareWith` compares fields with the given comparator', () {
      final list = ['b', 'C', 'a', 'B'];

      list.sort(compareWith((s) => s, compareAsciiLowerCase));

      expect(list, ['a', 'B', 'b', 'C']);
    });

    test('`compareWith` passes the extracted fields to the comparator', () {
      repeatSeeded((rand) {
        final list = rList(rand);
        final expected = ints(list)..sort((a, b) => b.compareTo(a));

        list.sort(compareWith((nc) => nc.intValue, (int a, int b) => b - a));

        expect(ints(list), expected);
      });
    });

    test('`compareSequentially` breaks ties with the next comparators', () {
      repeatSeeded((rand) {
        final list = rList(rand);
        final expected = [...list]..sort(matcherComparator);

        list.sort(compareSequentially([
          compare((nc) => nc.intValue),
          compareBool((nc) => nc.boolValue),
        ]));

        expect(list, orderedEquals(expected));
      });
    });

    test('`compareSequentially` respects the comparators order', () {
      const a = NotComparable(1, true), b = NotComparable(2, false);

      final byIntFirst = compareSequentially<NotComparable>([
        compare((nc) => nc.intValue),
        compareBool((nc) => nc.boolValue),
      ]);
      final byBoolFirst = compareSequentially<NotComparable>([
        compareBool((nc) => nc.boolValue),
        compare((nc) => nc.intValue),
      ]);

      expect(byIntFirst(a, b), lessThan(0));
      expect(byBoolFirst(a, b), greaterThan(0));
    });

    test('`compareSequentially` supports inverted comparators', () {
      final list = [
        const NotComparable(1, false),
        const NotComparable(0, true),
        const NotComparable(1, true),
        const NotComparable(0, false),
      ];

      list.sort(compareSequentially([
        compareBool((NotComparable nc) => nc.boolValue).inverse,
        compare((nc) => nc.intValue),
      ]));

      expect(list, const [
        NotComparable(0, true),
        NotComparable(1, true),
        NotComparable(0, false),
        NotComparable(1, false),
      ]);
    });

    test('`compareSequentially` returns 0 when all comparators tie', () {
      final comparator = compareSequentially<NotComparable>([
        compare((nc) => nc.intValue),
        compareBool((nc) => nc.boolValue),
      ]);

      expect(
          comparator(
              const NotComparable(1, true), const NotComparable(1, true)),
          0);
    });

    test('`compareSequentially` with a single comparator returns it', () {
      final comparator = compare<NotComparable>((nc) => nc.intValue);

      expect(compareSequentially([comparator]), same(comparator));
    });

    test('`compareSequentially` reads the iterable once', () {
      var reads = 0;
      final comparators = [
        compare<NotComparable>((nc) => nc.intValue),
        compareBool<NotComparable>((nc) => nc.boolValue),
      ].map((c) {
        reads++;
        return c;
      });

      final comparator = compareSequentially(comparators);
      comparator(const NotComparable(1, true), const NotComparable(1, false));

      expect(reads, 2);
    });

    test('`compareSequentially` throws on an empty iterable', () {
      expect(
        () => compareSequentially<NotComparable>([]),
        throwsStateError,
      );
    });
  });
}
