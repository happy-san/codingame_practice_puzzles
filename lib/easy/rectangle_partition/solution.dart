// @dart=2.11

import 'dart:io';

/// Returns all possible sub-measurements.
///
/// Suppose you have width measurements: `[a, b, c, w]`
///  where w is the maximum width of the rectangle.
///
///     0___a_____b__________c____w
///     |   |     |          |    |
///     |___|_____|__________|____|
///
/// The sub-measurements are: `[a, a-b, a-c, a-w, b, b-c, b-w, c, c-w, w]`.
Map<int, int> subMeasurement(List<int> measurementList) {
// Maps a sub-measurement to it's count, is essentially a count array.
  final map = <int, int>{};

  final length = measurementList.length;
  for (var i = 0; i < length; i++) {
    map.update(
      measurementList[i],
      (count) => ++count,
      ifAbsent: () => 1,
    );

    for (var j = i + 1; j < length; j++) {
      var diff = measurementList[j] - measurementList[i];
      map.update(
        diff,
        (count) => ++count,
        ifAbsent: () => 1,
      );
    }
  }

  return map;
}

/// Matches all the sub-measurements of `widthMeasurement` and `heightMeasurement`,
///  returns the count where they are equal.
int countSquares(List<int> widthMeasurements, List<int> heightMeasurements) {
  var counter = 0;

  final subWidth = subMeasurement(widthMeasurements);
  final subHeight = subMeasurement(heightMeasurements);

  for (final measurement in subWidth.keys.toList()) {
    if (subHeight.containsKey(measurement)) {
      counter += subWidth[measurement] * subHeight[measurement];
    }
  }

  return counter;
}

void main() {
  List inputs;
  inputs = stdin.readLineSync().split(' ');
  final countX = int.parse(inputs[2]);
  final countY = int.parse(inputs[3]);

  final widthMeasurements = List<int>(countX + 1),
      heightMeasurements = List<int>(countY + 1);
  // Put width and height as last elements in respective lists.
  widthMeasurements.last = int.parse(inputs[0]);
  heightMeasurements.last = int.parse(inputs[1]);

  inputs = stdin.readLineSync().split(' ');
  for (var i = 0; i < countX; i++) {
    widthMeasurements[i] = int.parse(inputs[i]);
  }

  inputs = stdin.readLineSync().split(' ');
  for (var i = 0; i < countY; i++) {
    heightMeasurements[i] = int.parse(inputs[i]);
  }

  print(countSquares(widthMeasurements, heightMeasurements));
}
