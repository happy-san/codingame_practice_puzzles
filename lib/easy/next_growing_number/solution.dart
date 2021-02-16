import 'dart:io';

String increment(String digit) {
  var n = digit.codeUnitAt(0) % 48; // mod '0'

  n = (n + 1) % 10;

  return String.fromCharCode(n + 48);
}

String getNextGrowingNumber(String input) {
  var number = input.split(''),
      length = number.length,
      i = length - 1,
      isCarried = true;

  do {
    final digit = number[i];

    if (increment(digit) == '0') {
      number[i] = '0';
    } else {
      number[i] = increment(digit);
      isCarried = false;
    }
    i--;
  } while (isCarried && i >= 0);

  number = isCarried ? ['1', ...number] : number;
  length = isCarried ? ++length : length;

  for (var i = 1, previous = number[0]; i < length; i++) {
    if (previous.compareTo(number[i]) <= 0) {
      previous = previous.compareTo(number[i]) < 0 ? number[i] : previous;
      continue;
    } else {
      for (var j = i; j < length; j++) {
        number[j] = previous;
      }
      break;
    }
  }

  return number.join('');
}

void main() {
  print(getNextGrowingNumber(stdin.readLineSync()));
}
