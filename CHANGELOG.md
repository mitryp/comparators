## 1.2.0

- Implemented `compareInverse` comparator for sorting in an inverse order as an alternative for `package:collection`'s
  `inverse`, as the latter requires `compare` to have an explicit generic.

## 1.1.0

- Implemented `sortSequentially` comparator as a concise alternative to comparator chaining with `then`;
- Added `package:collection` dependency;
- **Marked `then`, `reversed` Comparator extension methods and `compareTransformed` function as deprecated - they
  duplicate existing functionality of `package:collection`.**

## 1.0.0

- Initial version: implemented Java-like comparators in Dart.
