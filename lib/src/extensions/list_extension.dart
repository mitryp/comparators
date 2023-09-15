/// A [List] extension adding methods related to [Comparator]s - [min], [max], [isSorted].
extension ListExtension<E> on List<E> {
  /// A default comparator used in the methods when custom comparator is not given.
  static int _defaultComparator(dynamic a, dynamic b) =>
      Comparable.compare(a as Comparable, b as Comparable);

  /// Returns a minimum value of this list, comparing by the [comparator] if given, otherwise by
  /// the [_defaultComparator]. If the list is empty, returns null.
  ///
  /// The default implementation uses [Comparable.compare] if [comparator] is omitted, so make sure
  /// to pass the [comparator] for not comparable types - otherwise, this method will throw a
  /// TypeError.
  E? min([Comparator<E>? comparator]) => _findComparisonExtremum(
      comparator ?? _defaultComparator, (compRes) => compRes < 0);

  /// Returns a maximum value of this list, comparing by the [comparator] if given, otherwise by
  /// the [_defaultComparator]. If the list is empty, returns null.
  ///
  /// The default implementation uses [Comparable.compare] if [comparator] is omitted, so make sure
  /// to pass the [comparator] for not comparable types - otherwise, this method will throw a
  /// TypeError.
  E? max([Comparator<E>? comparator]) => _findComparisonExtremum(
      comparator ?? _defaultComparator, (compRes) => compRes > 0);

  /// Returns true if this list is sorted according to the given [comparator].
  ///
  /// The default implementation uses [Comparable.compare] if [comparator] is omitted, so make sure
  /// to pass the [comparator] for not comparable types - otherwise, this method will throw a
  /// TypeError.
  bool isSorted([Comparator<E>? comparator]) {
    final compare = comparator ?? _defaultComparator;

    for (var i = 0; i < length - 1; i++) {
      if (compare(this[i], this[i + 1]) > 0) {
        return false;
      }
    }

    return true;
  }

  E? _findComparisonExtremum(
      Comparator<E> comparator, bool Function(int compRes) predicate) {
    if (isEmpty) {
      return null;
    }

    var current = first;
    for (var i = 1; i < length; i++) {
      final elem = this[i];
      if (predicate(comparator(current, elem))) {
        current = elem;
      }
    }

    return current;
  }
}
