/// A boolean to integer transformer to enable the boolean comparison.
/// True is mapped to 1, false is mapped to 0.
int boolTransformer(bool value) => value ? 1 : 0;

/// A transformer which returns the received [Comparable] value.
Comparable identityTransformer(Comparable comparable) => comparable;
