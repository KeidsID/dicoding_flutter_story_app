/// Crops [value] when its length exceeds [maxLength].
///
/// ```dart
/// customTextOverflow(
///   'Flutter is the best',
///   maxLength: 10,
/// ); // return "Flutter is..."
/// ```
String customTextOverflow(String value, {required int maxLength}) =>
    (value.length > maxLength) ? '${value.substring(0, maxLength)}...' : value;
