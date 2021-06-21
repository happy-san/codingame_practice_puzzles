// @dart=2.11

import 'dart:io';

void main() {
  var alphabets = List.generate(26, (i) => String.fromCharCode(65 + i));

  var rotors = <Map<String, String>>[];

  var operation = stdin.readLineSync();
  var isEncodeOperation = operation.compareTo('ENCODE') == 0;

  var pseudoRandomNumber = int.parse(stdin.readLineSync());
  for (var i = 0; i < 3; i++) {
    var rotor = stdin.readLineSync();

    isEncodeOperation
        ? rotors.add(Map.fromIterables(alphabets, rotor.split('')))
        : rotors.add(Map.fromIterables(rotor.split(''), alphabets));
  }

  var message = stdin.readLineSync();

  print(isEncodeOperation
      ? encode(message, pseudoRandomNumber, rotors)
      : decode(message, rotors, pseudoRandomNumber));
}

String caeserShift(String character, int shiftBy) {
  var charCode = character.codeUnitAt(0) % 65;
  var shiftedCode = (charCode + shiftBy) % 26;

  return String.fromCharCode(shiftedCode + 65);
}

String decode(
    String message, List<Map<String, String>> rotors, int pseudoRandomNumber) {
  var decoded = '';

  for (var i = 0; i < message.length; i++) {
    var rotatedCharacter = rotate(message[i], rotors.reversed.toList());
    decoded += caeserShift(rotatedCharacter, -(pseudoRandomNumber + i));
  }

  return decoded;
}

String encode(
    String message, int pseudoRandomNumber, List<Map<String, String>> rotors) {
  var encoded = '';

  for (var i = 0; i < message.length; i++) {
    var shiftedCharacter = caeserShift(message[i], pseudoRandomNumber + i);
    encoded += rotate(shiftedCharacter, rotors);
  }

  return encoded;
}

String rotate(String shiftedCharacter, List<Map<String, String>> rotors) {
  for (var rotor in rotors) {
    shiftedCharacter = rotor[shiftedCharacter];
  }
  return shiftedCharacter;
}
