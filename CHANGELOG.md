## 2.0.0

- **Breaking:** removed `package:comparators/extensions.dart` with the deprecated `then` and `reversed` extensions.
  `package:comparators/comparators.dart` now exports `then` and `inverse` from the `package:collection` instead;
- **Breaking:** removed the deprecated `compareTransformed`;
- Implemented `compareNullable` for comparing by nullable fields, with nulls placed last or first;
- Implemented `compareWith` for comparing by fields with a custom comparator;
- Implemented `compareBoolInverse` for placing `true` before `false`.

## 1.3.0

- Relaxed the `package:collection` constraint to `^1.15.0`, so the package can be used on Dart SDKs before 3.4 and
  Flutter SDKs that pin older `package:collection` versions;
- `compareSequentially` now reads the given iterable once and compares without nesting the comparators;
- `compareInverse` no longer creates a new comparator on every comparison;
- Fixed the `compare` documentation example and other documentation typos;
- Documented that `package:comparators/extensions.dart` conflicts with `then` from the `package:collection`.

## 1.2.0

- Implemented `compareInverse` comparator for sorting in an inverse order as an alternative for `package:collection`'s
  `inverse`, as the latter requires `compare` to have an explicit generic.

## 1.1.0

- Implemented `compareSequentially` comparator as a concise alternative to comparator chaining with `then`;
- Added `package:collection` dependency;
- **Marked `then`, `reversed` Comparator extension methods and `compareTransformed` function as deprecated - they
  duplicate existing functionality of `package:collection`.**

## 1.0.0

- Initial version: implemented Java-like comparators in Dart.
