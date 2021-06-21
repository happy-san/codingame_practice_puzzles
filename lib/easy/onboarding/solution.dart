// @dart=2.11

import 'dart:io';

void main() {
  // game loop
  while (true) {
    var enemy1 = stdin.readLineSync(); // name of enemy 1
    var dist1 = int.parse(stdin.readLineSync()); // distance to enemy 1
    var enemy2 = stdin.readLineSync(); // name of enemy 2
    var dist2 = int.parse(stdin.readLineSync()); // distance to enemy 2

    if (dist1 < dist2) {
      print(enemy1);
    } else {
      print(enemy2);
    }
  }
}
