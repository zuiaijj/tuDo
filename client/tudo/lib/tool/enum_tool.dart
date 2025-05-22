import 'dart:math';

T? enumFromIndex<T>(Iterable<T> values, int index) {
  return values.toList()[min(values.length - 1, max(0, index))];
}

T? enumFromName<T>(Iterable<T> values, String name) {
  return values
      .firstWhere((element) => element.toString().split(".").last == name);
}
