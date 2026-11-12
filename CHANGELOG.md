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
