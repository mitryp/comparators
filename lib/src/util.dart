/// A boolean to integer transformer to enable the boolean comparison.
int boolTransformer(bool value) => value ? 1 : 0;

/// A transformer which returns the received value.
Comparable identityTransformer(Comparable comparable) => comparable;
