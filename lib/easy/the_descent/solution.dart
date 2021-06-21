// @dart=2.11

import 'dart:io';

/*
 * The while loop represents the game.
 * Each iteration represents a turn of the game
 * where you are given inputs (the heights of the mountains)
 * and where you have to print an output (the index of the mountain to fire on)
 * The inputs you are given are automatically updated according to your last actions.
 */
void main() {
  // game loop
  while (true) {
    var maxHeight = 0;
    int toShootIndex;
    for (var i = 0; i < 8; i++) {
      var mountainH = int.parse(
          stdin.readLineSync()); // represents the height of one mountain.
      if (mountainH > maxHeight) {
        maxHeight = mountainH;
        toShootIndex = i;
      }
    }

    print(toShootIndex); // The index of the mountain to fire on.
  }
}
