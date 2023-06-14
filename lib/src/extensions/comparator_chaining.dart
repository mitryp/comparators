/// A [Comparator] extension adding [then] method to allow chaining the
/// comparators together.
extension ComparatorChaining<T> on Comparator<T> {
  /// Returns a new [Comparator] combining this one and the given
  /// [nextComparator] in the lexicographical order.
  ///
  /// Firstly, this comparator will be used, and if the result is 0, the
  /// [nextComparator] will be used.
  Comparator<T> then(Comparator<T> nextComparator) => (a, b) {
        final firstComparison = call(a, b);

        if (firstComparison == 0) return nextComparator(a, b);
        return firstComparison;
      };
}
