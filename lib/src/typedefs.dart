/// A function that returns a value of a field of type [R] from the object of
/// type [T].
typedef FieldExtractor<T, R> = R Function(T);

/// A function that takes a value of type [T] and returns a value of a
/// [Comparable] type [R].
typedef ComparableTransformer<T, R extends Comparable> = FieldExtractor<T, R>;
