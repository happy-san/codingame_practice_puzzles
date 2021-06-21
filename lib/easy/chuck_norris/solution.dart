// @dart=2.11

import 'dart:io';
import 'dart:math';

/// Returns 7-bit binary of [codeUnit]
String toBinary(int codeUnit) {
  var intBinary = 0;
  var i = 0;

  while (codeUnit > 0) {
    intBinary += (codeUnit % 2) * pow(10, i);
    codeUnit ~/= 2;
    i++;
  }

  /* return intBinary; */

  // Preface with 0's if [intBinary] is less than 7-bit
  var stringBinary = '';
  while (i < 7) {
    stringBinary += '0';
    i++;
  }
  stringBinary += intBinary.toString();
  return stringBinary;
}

/// Encodes [inputBinary] into unary message.
String encode(String inputBinary) {
  var message = '';
  var sequenceOf = '';
  bool isFirst;
  inputBinary.split('').forEach((bit) {
    if (sequenceOf == bit) {
      isFirst = false;
    } else {
      sequenceOf = bit;
      isFirst = true;
    }
    if (isFirst) {
      switch (bit) {
        case '0':
          message += ' 00 0';
          break;
        case '1':
          message += ' 0 0';
          break;
      }
    } else {
      message += '0';
    }
  });

  return message.trimLeft();
}

void main() {
  var input = stdin.readLineSync();
  var inputBinary = '';
  input
      .split('')
      .forEach((char) => inputBinary += toBinary(char.codeUnitAt(0)));
  print(encode(inputBinary));
}
