## Make your sorts readable with functional by-field comparators

[![Dart Tests](https://github.com/mitryp/comparators/actions/workflows/test.yml/badge.svg)](https://github.com/mitryp/comparators/actions/workflows/test.yml?query=branch%3Amaster)
[![Pub package](https://img.shields.io/pub/v/comparators.svg)](https://pub.dev/packages/comparators)
[![Package publisher](https://img.shields.io/pub/publisher/comparators.svg)](https://pub.dev/packages/comparators/publisher)

The `comparators` package is a toolset for creating Java-like comparators in Dart, designed to provide a way  
to compare objects by their fields. It also provides a declarative way to combine comparators sequentially.

### Features

Import `comparators/comparators.dart` to use:
* By-field object comparators, in an ascending or an inverse order
* Nullable field comparison
* By-field comparison with a custom comparator
* Boolean comparison
* Combining comparators to break ties
* The `then` and `inverse` comparator extensions from the `package:collection`

### Migrating from 1.x

* `package:comparators/extensions.dart` is removed. Instead of its `then` and `reversed`, use `then` and `inverse`
  from the `package:collection`, which are exported by `package:comparators/comparators.dart`.
* `compareTransformed` is removed. Use `compare((x) => transform(x.field))`, `compareBool` or `compareWith` instead.

### Getting Started
To install the package, run `dart pub add comparators` or add the following line to your `pubspec.yaml`:
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
// this will sort the list by the username field of the User object, in a descending order
users.sort(compareInverse((u) => u.username));
```

Comparison by a nullable field:
```dart
// users without a nickname will come last, or first with `nullsFirst: true`
users.sort(compareNullable((u) => u.nickname));
```

Comparison by a field with a custom comparator:
```dart
// case-insensitive comparison with `compareAsciiLowerCase` from the `package:collection`
users.sort(compareWith((u) => u.username, compareAsciiLowerCase));
```

Comparison by a boolean field:
```dart
users.sort(compareBool((u) => u.isActive));

// active users first
users.sort(compareBoolInverse((u) => u.isActive));
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

The same result could be achieved using comparator chaining with `then` from the `package:collection`
(exported by this package), but in a less declarative way:
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
