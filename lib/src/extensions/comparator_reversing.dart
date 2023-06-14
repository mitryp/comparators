/// A [Comparator] extension adding the [reversed] getter to allow reversing the
/// comparing operation.
extension ComparatorReversing<T> on Comparator<T> {
  /// Returns a new [Comparator] that compares the elements in the reversed
  /// order.
  ///
  /// For example, if this comparator compares the elements in the ascending
  /// order, the reversed comparator will compare the elements in the descending
  /// order.
  Comparator<T> get reversed => (a, b) => call(b, a);
}
