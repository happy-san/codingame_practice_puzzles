// @dart=2.11

import 'dart:io';
import 'dart:math';

class Location {
  double latitude;
  double longitude;

  Location(this.latitude, this.longitude);

  /// Returns distance between location [a] and [b] applying Equirectangular approximation.
  static double distanceBetween(Location a, Location b) {
    var x, y, d;
    x = (b.longitude - a.longitude) * cos((b.latitude + a.latitude) / 2);
    y = b.latitude - a.latitude;
    d = sqrt(pow(x, 2) + pow(y, 2)) * 6371;
    return d;
  }
}

// Returns name of defibrillator located the closest to the user’s location.
String closestDefibrillator(Location userLocation, List defibrillatorList) {
  var defibLocations = List.generate(defibrillatorList.length, (i) {
    return Location(
        double.parse(defibrillatorList[i][5].replaceFirst(',', '.')),
        double.parse(defibrillatorList[i][4].replaceFirst(',', '.')));
  });

  var minIndex = 0, minDistance = 20036.0; // 20036.0 is the maximum distance
  for (var i = 0; i < defibrillatorList.length; i++) {
    var distance = Location.distanceBetween(userLocation, defibLocations[i]);

    if (distance < minDistance) {
      minDistance = distance;
      minIndex = i;
    }
  }

  return defibrillatorList[minIndex][1];
}

void main() {
  var longitude = stdin.readLineSync();
  var latitude = stdin.readLineSync();
  var userLocation = Location(double.parse(latitude.replaceFirst(',', '.')),
      double.parse(longitude.replaceFirst(',', '.')));

  var defibrillatorCount = int.parse(stdin.readLineSync());

  var defibrillatorList = [];
  for (var i = 0; i < defibrillatorCount; i++) {
    defibrillatorList.add(stdin.readLineSync().split(';'));
  }

  print(closestDefibrillator(userLocation, defibrillatorList));
}
