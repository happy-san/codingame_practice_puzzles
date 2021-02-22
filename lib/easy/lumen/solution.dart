import 'dart:io';

class Location {
  final int x;
  final int y;

  const Location(this.x, this.y);

  @override
  String toString() {
    return '($x,$y)';
  }

  @override
  bool operator ==(other) =>
      (other is Location) && (other.x == x) && (other.y == y);

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class Grid {
  Set<Location> points;

  Grid.ofSize(int size) {
    points = {};
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        points.add(Location(i, j));
      }
    }
  }
}

Set<Location> getSurroundingSquareLocations(Location origin, int squareNumber) {
  var locations = <Location>{}, xOffset = origin.x, yOffset = origin.y;

  for (var i = squareNumber, j = squareNumber; i >= -squareNumber;) {
    if (i == j) {
      locations.add(Location(i + xOffset, j + yOffset));
      i--;
    } else {
      locations.add(Location(i + xOffset, j + yOffset));
      locations.add(Location(j + xOffset, i + yOffset));
      i > -squareNumber ? i-- : j--;
    }
  }

  return locations;
}

Grid removeIlluminated(
    Grid grid, Location candleLocation, int squareNumber, int luminosity) {
  //stderr.writeln('Candle $candleLocation: SquareNumber $squareNumber, Luminosity $luminosity');
  var squareLocations =
      getSurroundingSquareLocations(candleLocation, squareNumber);

  //stderr.writeln('  $squareLocations');

  for (var location in squareLocations) {
    grid.points.remove(location);
  }

  return grid;
}

void main() {
  final gridSize = int.parse(stdin.readLineSync());
  final luminosity = int.parse(stdin.readLineSync());
  final candleLocations = <Location>[];

  for (var i = 0; i < gridSize; i++) {
    final inputs = stdin.readLineSync().split(' ');
    for (var j = 0; j < gridSize; j++) {
      if (inputs[j] == 'C') {
        candleLocations.add(Location(i, gridSize - 1 - j));
      }
    }
  }

  //stderr.writeln(candleLocations);

  var grid = Grid.ofSize(gridSize);

  for (final location in candleLocations) {
    var _luminosity = luminosity;
    var surroundingSquareNumber = 0;

    while (_luminosity > 0) {
      grid = removeIlluminated(
          grid, location, surroundingSquareNumber++, _luminosity--);
    }
  }

  //stderr.writeln(grid.points);

  print(grid.points.length);
}
