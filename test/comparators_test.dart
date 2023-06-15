import 'dart:math';

import 'package:comparators/comparators.dart';

class DataClass {
  final int intValue;
  final bool boolValue;

  const DataClass(this.intValue, this.boolValue);

  DataClass.random(Random rand)
      : intValue = rand.nextInt(10),
        boolValue = rand.nextBool();

  @override
  String toString() => '$intValue $boolValue';
}

void main() {
  final rand = Random();
  final classes = List.generate(20, (_) => DataClass.random(rand));

  classes.sort(
    compare<DataClass>((dc) => dc.intValue).then(
      compareBool<DataClass>((dc) => dc.boolValue).reversed,
    ),
  );
  print(classes);
}
