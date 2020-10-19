import 'dart:io';
import 'dart:math';

/// returns minimum difference between any two adjacent numbers
int minDiff(List list) {
  var minDiff = pow(10, 7);
  for (var i = 0; i < list.length - 1; i++) {
    minDiff = min(minDiff, list[i + 1] - list[i]);
  }
  return minDiff;
}

void main() {
  var N = int.parse(stdin.readLineSync());
  var inputList = [];
  for (var i = 0; i < N; i++) {
    inputList.add(int.parse(stdin.readLineSync()));
  }
  print(minDiff(inputList..sort()));
}
