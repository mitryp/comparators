import 'dart:math' show Random;

/// A dataclass for testing purposes.
class NotComparable {
  final int intValue;
  final bool boolValue;

  const NotComparable(this.intValue, this.boolValue);

  /// Creates a random `NotComparable` instance using the given [random] generator.
  NotComparable.random(Random random)
      : intValue = random.nextInt(10),
        boolValue = random.nextBool();

  @override
  String toString() =>
      'NotComparable{intValue: $intValue, boolValue: $boolValue}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotComparable &&
          runtimeType == other.runtimeType &&
          intValue == other.intValue &&
          boolValue == other.boolValue;

  @override
  int get hashCode => intValue.hashCode ^ boolValue.hashCode;
}
