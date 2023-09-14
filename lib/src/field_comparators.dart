import 'package:comparators/src/util.dart';

import 'typedefs.dart';

/// Returns a [Comparator] of type [T] comparing by the fields of type [R].
/// Takes a [comparableTransformer] that is used to transform a value obtained
/// by the [fieldExtractor] to a [Comparable] object.
///
/// Example:
/// ```dart
/// // a boolean transformer. bool is not a Comparable type, so this function
/// // transforms it into an integer, which is
/// int boolTransformer(bool value) => value ? 1 : 0;
///
/// // use the transformer defined above to transform the extracted bool field
/// // values into Comparable objects
/// users.sort(compareTransformed((u) => u.isAdmin, boolTransformer));
///
/// // alternatively, a closure can be used instead. it will most likely require
/// // specifying the type parameters explicitly
/// users.sort(
///   compareTransformed<User, bool>((u) => u.isAdmin, (val) => val ? 1 : 0),
/// );
/// // in this package, there is `compareBool` function which does the same same as in this example
/// ```
Comparator<T> compareTransformed<T, R>(
  FieldExtractor<T, R> fieldExtractor,
  ComparableTransformer<R, Comparable> comparableTransformer,
) {
  return (a, b) {
    final valueA = comparableTransformer(fieldExtractor(a));
    final valueB = comparableTransformer(fieldExtractor(b));

    return Comparable.compare(valueA, valueB);
  };
}

/// Returns a [Comparator] of type [T] comparing by the [Comparable] field of
/// type [R] extracted with the [fieldExtractor].
///
/// It is a shorthand for the [compareTransformed] comparator function for the
/// fields that are [Comparable] by themselves.
///
/// Example:
/// ```dart
/// // compare by a single field
/// users.sort(compare((u) => u.name));
///
/// // compare by multiple fields with comparator chaining
/// // unfortunately, Dart cannot infer chained types correctly, so it is
/// // required to provide the type parameters explicitly
/// users.sort(
///   compare<User>((user) => user.name).then(
///     compare<User>((user) => user.surname).then(
///       compare<User>((user) => user.country),
///     ),
///   ),
/// );
/// ```
Comparator<T> compare<T>(FieldExtractor<T, Comparable> fieldExtractor) {
  return compareTransformed<T, Comparable>(fieldExtractor, identityTransformer);
}

/// Returns a comparator for a boolean field extracted with the given
/// [fieldExtractor].
///
/// Internally it will use the integer comparison and the following
/// transformation: `true => 1, false => 0`.
Comparator<T> compareBool<T>(FieldExtractor<T, bool> fieldExtractor) {
  return compareTransformed(fieldExtractor, boolTransformer);
}
