## Make your code readable with functional Java-like by-field comparators in Dart

[![Dart Tests](https://github.com/mitryp/comparators/actions/workflows/dart.yml/badge.svg)](https://github.com/mitryp/comparators/actions/workflows/dart.yml?branch=master)
[![Pub package](https://img.shields.io/pub/v/comparators.svg)](https://pub.dev/packages/comparators)
[![Package publisher](https://img.shields.io/pub/publisher/comparators.svg)](https://pub.dev/packages/comparators/publisher)

The `comparators` package is a toolset for creating Java-like comparators in Dart, designed to provide a way  
to compare objects by their fields. It also includes extensions to chain and 
invert comparators.

> This package includes some functionality already included in the `collection` package: extensions to chain and inverse  
> comparators.
>
> If you already use that package in your project and only need this functionality, you won't need this package.


### Features

Import `comparators/comparators.dart` to use:
* By-field object comparators
* Field transformation before comparison
* Boolean comparison

Import `comparators/extensions.dart` to use:
* Comparator chaining
* Comparator reversing


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

Comparison by a transformed field:
```dart
// this will sort the users by their username
// before comparing the usernames will be transformed with the provided transform
// in this case, it will lowercase the names to do a case insensitive comparison
users.sort(
  compareTransformed<User, String>((u) => u.username, (name) => name.toLowerCase()),
);
```

Comparison by a boolean field:
```dart
users.sort(compareBool((u) => u.isActive));
```
When comparing boolean, the function will use the integer comparison and the following transformation: 
`true => 1, false => 0`.

---

> The comparators can be chained together and reverted with the Comparator extensions imported from 
the `comparators/extensions.dart`.

Multi-field comparison with chaining and reverting:
```dart
// this will sort the users by their activity first, then by their email,
// and then by their username
users.sort(
  // the users which active is set to true will come first in the list
  compareBool<User>((u) => u.isActive).reversed.then(
        // if both compared users have the same activity, the tie will be broken comparing by their email field
        compare<User>((u) => u.email).then(
          // and then by their username
          compare<User>((u) => u.username),
        ),
      ),
);
```

### Issues and contributions

If you found any issues or would like to contribute to this package, feel free to do so at the project's 
[GitHub](https://github.com/mitryp/comparators).

### Roadmap
- [x] Basic java-like field comparators 
- [x] Comparator chaining/reversal
- [ ] List extensions
