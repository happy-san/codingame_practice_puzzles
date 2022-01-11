import 'dart:io';

String readLineSync() {
  final s = stdin.readLineSync();
  return s ?? '';
}

class Vector {
  final num i;
  final num j;

  const Vector(this.i, this.j);

  @override
  String toString() => '(i: $i, j: $j)';
}

class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  @override
  String toString() => '(x: $x, y: $y)';

  @override
  bool operator ==(Object other) =>
      (other is Position && other.x == x && other.y == y);

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class Asteroid {
  final String depth;
  final Position displacementFromOrigin;

  Asteroid({
    required this.depth,
    required this.displacementFromOrigin,
  });

  factory Asteroid.fromPictureInfo({
    required String depth,
    required Position t1Position,
    required Position t2Position,
    required int t1,
    required int t2,
    required int t3,
  }) {
    stderr.writeln('$depth: $t1Position $t2Position');

    final displacementVector =
        Vector(t2Position.x - t1Position.x, t2Position.y - t1Position.y);
    final timeElapsed = t2 - t1;

    stderr.writeln('displacement vector: $displacementVector');
    stderr.writeln('time elapsed: $timeElapsed');

    final velocityVector = Vector(
      displacementVector.i / timeElapsed,
      displacementVector.j / timeElapsed,
    );
    stderr.writeln('velocity vector: $velocityVector');

    final t3Displacement = Position(
      (velocityVector.i * (t3 - t1)).floor(),
      (velocityVector.j * (t3 - t1)).floor(),
    );
    stderr.writeln('t3 displacement: $t3Displacement');

    final displacementFromOrigin = Position(
        t3Displacement.x + t1Position.x, t3Displacement.y + t1Position.y);
    stderr.writeln('displacement from origin: $displacementFromOrigin');

    return Asteroid(
      depth: depth,
      displacementFromOrigin: displacementFromOrigin,
    );
  }

  int compareTo(Object other) {
    if (other is Asteroid) {
      // A is the closest and Z the farthest asteroid.
      // If two or more asteroids have the same final coordinates, output only the closest one.

      final thisDepth = depth.codeUnitAt(0);
      final otherDepth = other.depth.codeUnitAt(0);

      return thisDepth < otherDepth
          ? -1
          : thisDepth == otherDepth
              ? 0
              : 1;
    }
    return 0;
  }
}

void addOrDisplace(Map<Position, Asteroid> t3Asteroids, Asteroid asteroid) {
  final key = asteroid.displacementFromOrigin;

  if (!t3Asteroids.containsKey(key) ||
      (t3Asteroids.containsKey(key) &&
          asteroid.compareTo(t3Asteroids[key]!) < 0)) {
    t3Asteroids[key] = asteroid;
  }

  stderr.writeln('');
}

void main() {
  List inputs;
  inputs = readLineSync().split(' ');
  final width = int.parse(inputs[0]);
  final height = int.parse(inputs[1]);
  final t1 = int.parse(inputs[2]);
  final t2 = int.parse(inputs[3]);
  final t3 = int.parse(inputs[4]);

  final asteroids = <String, Position>{};
  final t3Asteroids = <Position, Asteroid>{};

  for (var y = 0; y < height; y++) {
    inputs = readLineSync().split(' ');
    final row1 = inputs[0];
    final row2 = inputs[1];

    for (var x = 0; x < width; x++) {
      if (row1[x] != '.') {
        final depth = row1[x];

        if (asteroids.containsKey(depth)) {
          final asteroid = Asteroid.fromPictureInfo(
            depth: depth,
            t1Position: Position(x, y),
            t2Position: asteroids[depth]!,
            t1: t1,
            t2: t2,
            t3: t3,
          );

          addOrDisplace(t3Asteroids, asteroid);
        } else {
          asteroids[depth] = Position(x, y);
        }
      }
      if (row2[x] != '.') {
        final depth = row2[x];

        if (asteroids.containsKey(depth)) {
          final asteroid = Asteroid.fromPictureInfo(
            depth: depth,
            t1Position: asteroids[depth]!,
            t2Position: Position(x, y),
            t1: t1,
            t2: t2,
            t3: t3,
          );

          addOrDisplace(t3Asteroids, asteroid);
        } else {
          asteroids[depth] = Position(x, y);
        }
      }
    }
  }

  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final position = Position(x, y);

      if (t3Asteroids.containsKey(position)) {
        stdout.write(t3Asteroids[position]!.depth);
      } else {
        stdout.write('.');
      }
    }
    print('');
  }
}
