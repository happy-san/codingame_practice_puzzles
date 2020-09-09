import 'dart:io';

void main() {
  var charWidth = int.parse(stdin.readLineSync());
  var charHeight = int.parse(stdin.readLineSync());
  var toConvert = stdin.readLineSync();

  // ASCII art input divided into [charHeight] rows.
  var rowInput = List<String>(charHeight);
  for (var i = 0; i < charHeight; i++) {
    rowInput[i] = stdin.readLineSync();
  }

  // Individual ASCII art characters.
  var asciiArtCharacters = List<Map<String, String>>.generate(27, (_) => {});
  var outputAsciiArt =
      List<Map<String, String>>.generate(toConvert.length, (_) => {});

  for (var i = 0; i < charHeight; i++) {
    var list = rowInput[i].split('').toList();
    var indexCounter = 0;

    asciiArtCharacters.forEach((asciiArtCharacter) {
      // Map each elemet of an [asciiArtCharacter] with it's coordinate as a key.
      for (var j = 0; j < charWidth; j++) {
        asciiArtCharacter.putIfAbsent(
            [i, j].toString(), () => list[indexCounter++]);
      }
    });
  }

  var i = 0;
  final indexCode = 'a'.codeUnitAt(0);
  toConvert.split('').forEach((char) {
    if (char.contains(RegExp(r'[a-z]|[A-Z]'))) {
      // The characters [a-z] or [A-Z] are shown with their respective ASCII art.
      var index = char.toLowerCase().codeUnitAt(0) % indexCode;
      outputAsciiArt[i++] = asciiArtCharacters[index];
    } else {
      // Other characters will be shown as a question mark in ASCII art.
      outputAsciiArt[i++] = asciiArtCharacters[26];
    }
  });

  // Print [outputAsciiArt] map in rows.
  for (var i = 0; i < charHeight; i++) {
    var row = '';
    outputAsciiArt.forEach((char) {
      for (var j = 0; j < charWidth; j++) {
        row += char[[i, j].toString()];
      }
    });
    print(row);
  }
}
