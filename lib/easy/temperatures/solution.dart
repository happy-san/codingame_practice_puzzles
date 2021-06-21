// @dart=2.11

import 'dart:io';
import 'dart:math';

void main() {
  List inputs;
  var n =
      int.parse(stdin.readLineSync()); // The number of temperatures to analyse
  inputs = stdin.readLineSync().split(' ');
  int positiveTemp,
      negativeTemp; // Minimum positive and maximum negative temprature out of inputs.

  for (var i = 0; i < n; i++) {
    var inputTemp = int.parse(inputs[
        i]); // A temperature expressed as an integer ranging from -273 to 5526.

    if (inputTemp >= 0) {
      positiveTemp ??= inputTemp; // Initialize [positiveTemp].
      positiveTemp = min(inputTemp, positiveTemp);
    } else {
      negativeTemp ??= inputTemp; // Initialize [negativeTemp].
      negativeTemp = max(inputTemp, negativeTemp);
    }
  }

  try {
    // If two numbers are equally close to zero,
    //  positive integer has to be considered closest to zero.
    if (positiveTemp == -negativeTemp || positiveTemp < -negativeTemp) {
      print(positiveTemp);
    } else {
      print(negativeTemp);
    }
  } on NoSuchMethodError {
    if (positiveTemp == null && negativeTemp == null) {
      print('0');
      return;
    }

    if (positiveTemp != null) {
      print(positiveTemp);
    } else {
      print(negativeTemp);
    }
  }
}
