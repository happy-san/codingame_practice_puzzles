import 'dart:io';

const ones = {
  '1': 'one ',
  '2': 'two ',
  '3': 'three ',
  '4': 'four ',
  '5': 'five ',
  '6': 'six ',
  '7': 'seven ',
  '8': 'eight ',
  '9': 'nine ',
};

const tens = {
  '10': 'ten ',
  '11': 'eleven ',
  '12': 'twelve ',
  '13': 'thirteen ',
  '14': 'fourteen ',
  '15': 'fifteen ',
  '16': 'sixteen ',
  '17': 'seventeen ',
  '18': 'eighteen ',
  '19': 'nineteen ',
  '20': 'twenty ',
  '30': 'thirty ',
  '40': 'forty ',
  '50': 'fifty ',
  '60': 'sixty ',
  '70': 'seventy ',
  '80': 'eighty ',
  '90': 'ninety ',
};

const powerOfTens = {
  1: 'thousand ',
  2: 'million ',
  3: 'billion ',
  4: 'trillion ',
  5: 'quadrillion ',
  6: 'quintillion ',
};

final zeros = RegExp('^0+');

bool isZero(String number) {
  if (number.isEmpty) {
    return true;
  }
  for (final digit in number.split('')) {
    if (digit != '0') {
      return false;
    }
  }
  return true;
}

String reverseBuffer(StringBuffer buffer) =>
    buffer.toString().split('').reversed.join();

List<String> split(String number) {
  final parts = <String>[], buffer = StringBuffer();

  for (var i = number.length - 1, j = 1; i >= 0; i--, j++) {
    if (j % 3 == 0) {
      buffer.write(number[i]);
      parts.add(reverseBuffer(buffer));

      stderr.writeln('  part ${parts.length}: ${parts.last}');
      buffer.clear();
      continue;
    } else {
      buffer.write(number[i]);
    }
  }

  if (buffer.isNotEmpty) {
    parts.add(reverseBuffer(buffer));
    stderr.writeln('  part ${parts.length}: ${parts.last}');
  }

  return parts.reversed.toList();
}

String getTwoDigitCardinal(String number) {
  // '16', '60'
  if (number[0] == '1' || number[1] == '0') {
    return tens[number] ?? '';
  }

  // composite cardinal: '54'
  else {
    final firstPart = tens['${number[0]}0'] ?? '', secondPart = ones[number[1]];

    return '${firstPart.trimRight()}-$secondPart';
  }
}

String getOneDigitCardinal(String number) => ones[number] ?? '';

String getCardinal(String number) {
  stderr.writeln(number);
  if (isZero(number)) {
    return 'zero';
  }

  final buffer = StringBuffer();
  if (number[0] == '-') {
    buffer.write('negative ');
    number = number.substring(1);
  }

  final parts = split(number);
  var i = parts.length - 1;
  for (var part in parts) {
    part = part.replaceAll(zeros, '');

    if (isZero(part)) {
      continue;
    }

    // '402', '321'
    if (part.length == 3) {
      buffer.write(ones[part[0]]!);

      buffer.write('hundred ');

      // '402'
      if (part[1] == '0') {
        buffer.write(getOneDigitCardinal(part[2]));
      }

      // '321'
      else {
        buffer.write(getTwoDigitCardinal(part.substring(1)));
      }
    }

    // '21'
    else if (part.length == 2) {
      buffer.write(getTwoDigitCardinal(part));
    }

    // '1'
    else {
      buffer.write(getOneDigitCardinal(part));
    }

    // 1321 -> ['1', '321']; for part '1',   i = 1, add 'thousand ' to buffer
    if (i > 0) {
      buffer.write(powerOfTens[i] ?? '');
    }

    stderr.writeln('  buffer: ${buffer.toString()}');

    i--;
  }

  return buffer.toString().trimRight();
}

String readLineSync() => stdin.readLineSync() ?? '';

void main() {
  final n = int.parse(readLineSync());
  for (var i = 0; i < n; i++) {
    final x = readLineSync();
    print(getCardinal(x));
    stderr.writeln('');
  }
}
