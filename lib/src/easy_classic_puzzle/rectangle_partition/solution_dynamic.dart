// Needs improvement, times out in Hi-density 2 and sometimes in Imbalance.

import 'dart:io';

var elementCounter = 0;

/// Removes the null entries in `countArray`.
void trim(List<List<int>> countArray) {
  countArray.removeWhere((entry) => entry[0] == null);
}

/// Adds measurement in countArray.
void addMeasurement(List<List<int>> countArray, int measurement) {
  var index = countArray.indexWhere((entry) => entry[0] == measurement);

  if (index >= 0) {
    // Measurement already present, increment it's count.
    countArray[index][1]++;
  } else {
    // Add measurement, set count to 1.
    countArray[elementCounter++] = [measurement, 1];
  }
}

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
List<List<int>> subMeasurement(List<int> measurementList) {
  final n = measurementList.length;

// Maps a sub-measurement to it's count.
  final countArray =
      List<List<int>>.generate(n + (n * n - 1) ~/ 2, (i) => List(2));

  for (var i = 0; i < n; i++) {
    addMeasurement(countArray, measurementList[i]);
    for (var j = i + 1; j < n; j++) {
      var diff = measurementList[j] - measurementList[i];
      addMeasurement(countArray, diff);
    }
  }
  trim(countArray);

  elementCounter = 0;
  return countArray;
}

/// Matches all the sub-measurements of `widthMeasurement` and `heightMeasurement`,
///  returns the count where they are equal.
int countSquares(
    List<List<int>> widthMeasurements, List<List<int>> heightMeasurements) {
  var count = 0;

  // Base case
  if (widthMeasurements.length == 1 && heightMeasurements.length == 1) {
    final x = widthMeasurements.first[0];
    final y = heightMeasurements.first[0];
    return x == y ? widthMeasurements[0][1] * heightMeasurements[0][1] : 0;
  }

  if (widthMeasurements.length > 1) {
    widthMeasurements.forEach((width) {
      count += countSquares([width], heightMeasurements);
    });
  } else {
    heightMeasurements.forEach((height) {
      count += countSquares(widthMeasurements, [height]);
    });
  }

  return count;
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

  print(countSquares(
      subMeasurement(widthMeasurements), subMeasurement(heightMeasurements)));
}
