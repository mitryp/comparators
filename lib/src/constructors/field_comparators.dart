import '../typedefs.dart';

/// Returns a [Comparator] of type [T] comparing by the field of type [R] with
/// the [fieldComparator].
///
/// The field value will be extracted with the [fieldExtractor].
///
/// Example:
/// ```dart
/// // a custom comparator for the string field.
/// int stringCompare(String a, String b) => a.compareTo(b);
///
/// // use the custom comparator to compare the objects
/// users.sort(customCompare((u) => u.name, stringCompare));
///
/// // alternatively, a closure can be used instead. it will most likely require
/// // specifying the type parameters explicitly
/// users.sort(
///   customCompare<User, String>((u) => u.name, (a, b) => a.compareTo(b)),
/// );
/// ```
Comparator<T> customCompare<T, R>(
  FieldExtractor<T, R> fieldExtractor,
  Comparator<R> fieldComparator,
) {
  return (a, b) {
    final valueA = fieldExtractor(a);
    final valueB = fieldExtractor(b);

    return fieldComparator(valueA, valueB);
  };
}

/// Returns a [Comparator] of type [T] comparing by the [Comparable] field of
/// type [R] extracted with the [fieldExtractor].
///
/// It is a shorthand for the [customCompare] function with [Comparable.compare]
/// comparator.
///
/// Example:
/// ```dart
/// // compare by a single field
/// users.sort(compareBy((u) => u.name));
///
/// // compare by multiple fields with comparator chaining
/// // unfortunately, Dart cannot infer chained types correctly, so it is
/// // required to provide the type parameters explicitly
/// users.sort(
///   compareBy<User, String>((user) => user.name).then(
///     compareBy<User, String>((user) => user.surname).then(
///       compareBy((user) => user.country),
///     ),
///   ),
/// );
/// ```
Comparator<T> compareBy<T, R extends Comparable<R>>(
  FieldExtractor<T, R> fieldExtractor,
) {
  return customCompare(fieldExtractor, Comparable.compare);
}
