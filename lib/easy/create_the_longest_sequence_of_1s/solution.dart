import 'dart:io';

void main() {
  final lengthsOfBitStringsOfOnes =
      stdin.readLineSync().split('0').map((string) => string.length).toList();

  stderr.writeln(lengthsOfBitStringsOfOnes);

  if (lengthsOfBitStringsOfOnes.length < 2) {
    print('1');
  } else {
    // Find two consecutive sequence of 1's such that the sum of numbers of 1's
    // in them is maximum.
    var maxSum = 0, previous = lengthsOfBitStringsOfOnes[0];

    for (var i = 1; i < lengthsOfBitStringsOfOnes.length; i++) {
      final current = lengthsOfBitStringsOfOnes[i];

      if (previous + current > maxSum) maxSum = previous + current;
      previous = current;
    }
    print(maxSum + 1);
  }
}
