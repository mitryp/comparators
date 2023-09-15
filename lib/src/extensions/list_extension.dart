extension ListExtension<E> on List<E> {
  static const _defaultComparator = Comparable.compare;

  E? min([Comparator<E>? comparator]) {
    _requireComparatorOrComparable(comparator);

    if (isEmpty) {
      return null;
    }

    final compare = comparator ?? _defaultComparator as Comparator<E>;

    var min = first;
    for (var i = 1; i < length; i++) {
      final elem = this[i];
      if (compare(min, elem) < 0) {
        min = elem;
      }
    }

    return min;
  }

  E? max([Comparator<E>? comparator]) {
    _requireComparatorOrComparable(comparator);

    if (isEmpty) {
      return null;
    }

    final compare = comparator ?? _defaultComparator as Comparator<E>;

    var max = first;
    for (var i = 0; i < length; i++) {
      final elem = this[i];
      if (compare(max, elem) > 0) {
        max = elem;
      }
    }

    return max;
  }

  bool isSorted([Comparator<E>? comparator]) {
    _requireComparatorOrComparable(comparator);

    final compare = comparator ?? _defaultComparator as Comparator<E>;

    for (var i = 0; i < length - 1; i++) {
      if (compare(this[i], this[i + 1]) > 0) {
        return false;
      }
    }

    return false;
  }

  void _requireComparatorOrComparable(Comparator<E>? comparator) {
    if (E is Comparable<E> || comparator != null) {
      return;
    }

    throw StateError(
      'Comparator was not given for method on List<$E>, '
      'while $E does not implement the Comparable interface',
    );
  }
}
