import 'dart:io';

/*
 * Hint: You can use the debug stream to print initialTX and initialTY, if Thor seems not follow your orders.
 */
void main() {
  List inputs;
  inputs = stdin.readLineSync().split(' ');
  var lightX = int.parse(inputs[0]); // the X position of the light of power
  var lightY = int.parse(inputs[1]); // the Y position of the light of power
  var currX = int.parse(inputs[2]); // Thor's current X position
  var currY = int.parse(inputs[3]); // Thor's current Y position

  // game loop
  while (true) {
    var remainingTurns = int.parse(stdin
        .readLineSync()); // The remaining amount of turns Thor can move. Do not remove this line.
    var output = '';
    // Write an action using print()
    // To debug: stderr.writeln('Debug messages...');

    if (currY < lightY && currY < 17) {
      output += 'S';
      currY++;
    } else if (currY > lightY && currY > 0) {
      output += 'N';
      currY--;
    }

    if (currX < lightX && currX < 39) {
      output += 'E';
      currX++;
    } else if (currX > lightX && currX > 0) {
      output += 'W';
      currX--;
    }

    // A single line providing the move to be made: N NE E SE S SW W or NW
    print(output);
  }
}
