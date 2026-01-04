## Make your sorts readable with functional by-field comparators

[![Dart Tests](https://github.com/mitryp/comparators/actions/workflows/test.yml/badge.svg)](https://github.com/mitryp/comparators/actions/workflows/dart.yml?branch=master)
[![Pub package](https://img.shields.io/pub/v/comparators.svg)](https://pub.dev/packages/comparators)
[![Package publisher](https://img.shields.io/pub/publisher/comparators.svg)](https://pub.dev/packages/comparators/publisher)

The `comparators` package is a toolset for creating Java-like comparators in Dart, designed to provide a way  
to compare objects by their fields. It also provides a declarative way to combine comparators sequentially.

### Features

Import `comparators/comparators.dart` to use:
* By-field object comparators
* Boolean comparison
* Combining comparators to break ties

Comparator extensions `then` and `reversed` from this package are **deprecated** and will be removed in 2.0.0.
Please, use the analogues from the `package:collection`: `then` and `inverse`.

In 2.0.0, this package will export those instead of the removed ones. 

### Getting Started
To install the package, run `pub add comparators` or add the following line to your `pubspec.yaml`:
```yaml
dependencies:
  # other dependencies
  comparators: ^<version>
```


### Usage

> The following utility functions can be imported from the `comparators/comparators.dart` file.

Comparison by a single field:
```dart
// this will sort the list by the username field of the User object
users.sort(compare((u) => u.username));
```

Comparison by a single field in an inverse order:
```dart
// this will sort the list by the username field of the User object
users.sort(compareInverse((u) => u.username));
```

Comparison by a boolean field:
```dart
users.sort(compareBool((u) => u.isActive));
```
When comparing boolean, the function will use the integer comparison and the following transformation: 
`true => 1, false => 0`.

Combining comparators to compare sequentially:
```dart
users.sort(compareSequentially([
    compare((user) => user.name),
    compare((user) => user.surname),
    compare((user) => user.country),
]));
```

In this example, user objects will be compared by a name first,
then by a surname, and by a country.

The same result could be achieved using comparator chaining from the `package:collection`,
but in a less declarative way:
```dart
users.sort(
  compare((User user) => user.name).then(
    compare((User user) => user.surname).then(
      compare((User user) => user.country),
    ),
  ),
);
```

Also, note that the compiler cannot infer types in the example with chaining, 
but can with `compareSequentially`.

---

### Issues and contributions

If you found any issues or would like to contribute to this package, feel free to do so at the project's 
[GitHub](https://github.com/mitryp/comparators).
Contributions are welcome - start the discussion in the 
[Issue tracker](https://github.com/mitryp/comparators/issues).
