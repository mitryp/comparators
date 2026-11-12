import 'typedefs.dart';
import 'util.dart';

/// Returns a [Comparator] of type [T] comparing by the fields of type [R].
/// Takes a [comparableTransformer] that is used to transform a value obtained
/// by the [fieldExtractor] to a [Comparable] object.
///
/// Example:
/// ```dart
/// // a boolean transformer. bool is not a Comparable type, so this function
/// // transforms it into an integer, which is Comparable
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
/// // in this package, there is `compareBool` function which does the same as in this example
/// ```
@Deprecated('It will be made private starting from v2.0.0. '
    'Use `compare((x) => transform(x.field))` instead')
Comparator<T> compareTransformed<T, R>(
  FieldExtractor<T, R> fieldExtractor,
  ComparableTransformer<R, Comparable> comparableTransformer,
) =>
    _compareTransformed(fieldExtractor, comparableTransformer);

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

/// Returns a comparator for a boolean field extracted with the given
/// [fieldExtractor].
///
/// Internally, it will use integer comparison and the following
/// transformation: `true => 1, false => 0`.
Comparator<T> compareBool<T>(FieldExtractor<T, bool> fieldExtractor) =>
    _compareTransformed(fieldExtractor, boolTransformer);

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
/// // chaining using `then` from the `package:collection`
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
/// // using `inverse` from the `package:collection`
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
