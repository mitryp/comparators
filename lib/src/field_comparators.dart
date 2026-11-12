import 'typedefs.dart';
import 'util.dart';

Comparator<T> _compareTransformed<T, R>(
  FieldExtractor<T, R> fieldExtractor,
  ComparableTransformer<R, Comparable> comparableTransformer,
) =>
    (a, b) {
      final valueA = comparableTransformer(fieldExtractor(a));
      final valueB = comparableTransformer(fieldExtractor(b));

      return Comparable.compare(valueA, valueB);
    };

/// Returns a [Comparator] of type [T] comparing by the [Comparable] field extracted with the [fieldExtractor].
///
/// Example:
/// ```dart
/// // compare by a single field
/// users.sort(compare((u) => u.name));
///
/// // compare by multiple fields with `compareSequentially`
/// users.sort(compareSequentially([
///   compare((user) => user.name),
///   compare((user) => user.surname),
///   compare((user) => user.country),
/// ]));
/// ```
Comparator<T> compare<T>(FieldExtractor<T, Comparable> fieldExtractor) =>
    _compareTransformed<T, Comparable>(
      fieldExtractor,
      identityTransformer,
    );

/// Returns a [Comparator] of type [T] comparing by the [Comparable] field extracted with the [fieldExtractor],
/// in an inverse order.
/// Identical to calling `compare` with the arguments swapped:
/// ```dart
/// (a, b) => compare(...).call(b, a);
/// ```
///
/// Example:
/// ```dart
/// // compare by a single field in an inverse order
/// users.sort(compareInverse((u) => u.name));
/// ```
Comparator<T> compareInverse<T>(FieldExtractor<T, Comparable> fieldExtractor) {
  final comparator = compare(fieldExtractor);

  return (a, b) => comparator(b, a);
}

/// Returns a [Comparator] of type [T] comparing by the nullable [Comparable] field extracted with the [fieldExtractor].
///
/// Null values are placed after non-null ones, or before them if [nullsFirst] is true.
///
/// Example:
/// ```dart
/// // users without a nickname will come last
/// users.sort(compareNullable((u) => u.nickname));
/// ```
Comparator<T> compareNullable<T>(
  FieldExtractor<T, Comparable?> fieldExtractor, {
  bool nullsFirst = false,
}) {
  final nullOrder = nullsFirst ? -1 : 1;

  return (a, b) {
    final valueA = fieldExtractor(a);
    final valueB = fieldExtractor(b);

    if (valueA == null) return valueB == null ? 0 : nullOrder;
    if (valueB == null) return -nullOrder;

    return Comparable.compare(valueA, valueB);
  };
}

/// Returns a [Comparator] of type [T] comparing the fields extracted with the [fieldExtractor] using the given
/// [comparator].
///
/// Example:
/// ```dart
/// // case-insensitive comparison with `compareAsciiLowerCase` from the `package:collection`
/// users.sort(compareWith((u) => u.username, compareAsciiLowerCase));
/// ```
Comparator<T> compareWith<T, R>(
  FieldExtractor<T, R> fieldExtractor,
  Comparator<R> comparator,
) =>
    (a, b) => comparator(fieldExtractor(a), fieldExtractor(b));

/// Returns a comparator for a boolean field extracted with the given
/// [fieldExtractor].
///
/// Internally, it will use integer comparison and the following
/// transformation: `true => 1, false => 0`.
Comparator<T> compareBool<T>(FieldExtractor<T, bool> fieldExtractor) =>
    _compareTransformed(fieldExtractor, boolTransformer);

/// Returns a comparator for a boolean field extracted with the given
/// [fieldExtractor], placing `true` before `false`.
Comparator<T> compareBoolInverse<T>(FieldExtractor<T, bool> fieldExtractor) {
  final comparator = compareBool(fieldExtractor);

  return (a, b) => comparator(b, a);
}

/// Returns a comparator that will compare the values of [T] using the [comparators] in their order in the iterable.
/// Next comparators are used as tie breakers for the previous ones.
///
/// The [comparators] are read once, when this function is called.
/// Throws a [StateError] if [comparators] is empty.
///
/// This approach allows Dart to infer the comparator types from the context and does not require providing generics
/// explicitly for most cases.
///
/// Example:
/// ```dart
/// // chaining using `then` from the `package:collection`, exported by this package
/// users.sort(
///   compare<User>((user) => user.name).then(
///     compare<User>((user) => user.surname).then(
///       compare<User>((user) => user.country),
///     ),
///   ),
/// );
///
/// // with `compareSequentially`
/// users.sort(compareSequentially([
///   compare((user) => user.name),
///   compare((user) => user.surname),
///   compare((user) => user.country),
/// ]));
///
/// // using `inverse` from the `package:collection`, exported by this package
/// users.sort(compareSequentially([
///   // ...
///   compare((User user) => user.surname).inverse,
///   // ...
/// ]));
/// ```
Comparator<T> compareSequentially<T>(Iterable<Comparator<T>> comparators) {
  final list = List.of(comparators, growable: false);

  if (list.isEmpty) {
    throw StateError('An empty iterable of Comparators cannot be combined');
  }

  if (list.length == 1) return list.first;

  return (a, b) {
    for (final comparator in list) {
      final result = comparator(a, b);
      if (result != 0) return result;
    }

    return 0;
  };
}
