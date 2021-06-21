@TestOn('vm')

import 'dart:io';
import 'dart:convert';
import 'package:test/test.dart';

import 'package:codingame_practice_puzzles/easy/lumen/solution.dart';

void main() {
  final path = 'lib/easy/lumen/solution.dart';

  group('Location: ', () {
    test('toString', () {
      expect(Location(0, 0).toString(), equals('(0,0)'));
      expect(Location(1, 0).toString(), equals('(1,0)'));
      expect(Location(0, -1).toString(), equals('(0,-1)'));
      expect(Location(1, -1).toString(), equals('(1,-1)'));
    });

    test('different objects with same x and y should be equal', () {
      expect(Location(0, 0) == Location(0, 0), isTrue);
      expect(Location(0, 1) == Location(1, 0), isFalse);
    });

    test('objects with same x and y should be identical in set', () {
      expect({Location(0, 0), Location(0, 0)}.length, equals(1));
      expect({Location(0, 0), Location(0, 1)}.length, equals(2));
    });
  });

  group('Surrounding square grid points: ', () {
    Location origin;

    setUp(() {
      origin = Location(0, 0);
    });

    test('Returns origin for square 0', () {
      expect(getSurroundingSquareLocations(origin, 0), equals({origin}));
    });

    test('Returns 8 points for square 1', () {
      expect(
          getSurroundingSquareLocations(origin, 1),
          equals({
            Location(1, 1),
            Location(0, 1),
            Location(1, 0),
            Location(-1, 1),
            Location(1, -1),
            Location(-1, 0),
            Location(0, -1),
            Location(-1, -1)
          }));
    });
    test('Returns 16 points for square 2', () {
      expect(
          getSurroundingSquareLocations(origin, 2),
          equals({
            Location(2, 2),
            Location(1, 2),
            Location(2, 1),
            Location(0, 2),
            Location(2, 0),
            Location(-1, 2),
            Location(2, -1),
            Location(-2, 2),
            Location(2, -2),
            Location(-2, 1),
            Location(1, -2),
            Location(-2, 0),
            Location(0, -2),
            Location(-2, -1),
            Location(-1, -2),
            Location(-2, -2),
          }));
    });

    test('Returns 24 points for square 3', () {
      expect(
          getSurroundingSquareLocations(origin, 3),
          equals({
            Location(3, 3),
            Location(2, 3),
            Location(3, 2),
            Location(1, 3),
            Location(3, 1),
            Location(0, 3),
            Location(3, 0),
            Location(-1, 3),
            Location(3, -1),
            Location(-2, 3),
            Location(3, -2),
            Location(-3, 3),
            Location(3, -3),
            Location(-3, 2),
            Location(2, -3),
            Location(-3, 1),
            Location(1, -3),
            Location(-3, 0),
            Location(0, -3),
            Location(-3, -1),
            Location(-1, -3),
            Location(-3, -2),
            Location(-2, -3),
            Location(-3, -3),
          }));
    });

    test('Candle not at origin', () {
      expect(
          getSurroundingSquareLocations(Location(1, 1), 1),
          equals({
            Location(2, 2),
            Location(2, 1),
            Location(1, 2),
            Location(2, 0),
            Location(0, 2),
            Location(1, 0),
            Location(0, 1),
            Location(0, 0),
          }));
    });
  });

  test('Grid Initialization', () {
    expect(Grid.ofSize(1).points.length, equals(1));
    expect(Grid.ofSize(2).points.length, equals(4));
    expect(Grid.ofSize(3).points.length, equals(9));
    expect(Grid.ofSize(4).points.length, equals(16));
    expect(Grid.ofSize(5).points.length, equals(25));

    expect(
        Grid.ofSize(1).points,
        equals({
          Location(0, 0),
        }));

    expect(
        Grid.ofSize(2).points,
        equals({
          Location(0, 0),
          Location(0, 1),
          Location(1, 0),
          Location(1, 1),
        }));

    expect(
        Grid.ofSize(3).points,
        equals({
          Location(0, 0),
          Location(0, 1),
          Location(0, 2),
          Location(1, 0),
          Location(1, 1),
          Location(1, 2),
          Location(2, 0),
          Location(2, 1),
          Location(2, 2),
        }));
  });

  test('Remove illuminated from the grid', () {
    var grid = Grid.ofSize(4);
    final candleLocation = Location(0, 0);
    var luminosity = 2, surroundingSquareNumber = 0;

    while (luminosity-- > 0 && grid.points.isNotEmpty) {
      grid = removeIlluminated(grid, candleLocation, surroundingSquareNumber++);
    }
    expect(
        grid.points,
        equals({
          Location(0, 2),
          Location(0, 3),
          Location(1, 2),
          Location(1, 3),
          Location(2, 0),
          Location(2, 1),
          Location(2, 2),
          Location(2, 3),
          Location(3, 0),
          Location(3, 1),
          Location(3, 2),
          Location(3, 3),
        }));
  });

  test('THEY only have one candle', () async {
    final input = [
      '5',
      '3',
      'X X X X X',
      'X C X X X',
      'X X X X X',
      'X X X X X',
      'X X X X X',
    ];
    final output = [
      '9',
    ];
    final process = await Process.start('dart', ['$path']);
    for (var line in input) {
      process.stdin.writeln(line);
    }
    final lineStream =
        process.stdout.transform(Utf8Decoder()).transform(LineSplitter());

    expect(lineStream, emitsInOrder([...output, emitsDone]));
    final err =
        process.stderr.transform(Utf8Decoder()).transform(LineSplitter());
    await for (var e in err) {
      print(e);
    }
  });
  test('THEY are doing a ritual', () async {
    final input = [
      '5',
      '3',
      'C X X X C',
      'X X X X X',
      'X X X X X',
      'X X X X X',
      'C X X X C',
    ];
    final output = [
      '0',
    ];
    final process = await Process.start('dart', ['$path']);
    for (var line in input) {
      process.stdin.writeln(line);
    }
    final lineStream =
        process.stdout.transform(Utf8Decoder()).transform(LineSplitter());

    expect(lineStream, emitsInOrder([...output, emitsDone]));
    final err =
        process.stderr.transform(Utf8Decoder()).transform(LineSplitter());
    await for (var e in err) {
      print(e);
    }
  });
  test('THEY have a large pit', () async {
    final input = [
      '5',
      '3',
      'X X X X X',
      'X C X X X',
      'X X X X X',
      'X X X C X',
      'X X X X X',
    ];
    final output = [
      '2',
    ];
    final process = await Process.start('dart', ['$path']);
    for (var line in input) {
      process.stdin.writeln(line);
    }
    final lineStream =
        process.stdout.transform(Utf8Decoder()).transform(LineSplitter());

    expect(lineStream, emitsInOrder([...output, emitsDone]));
    final err =
        process.stderr.transform(Utf8Decoder()).transform(LineSplitter());
    await for (var e in err) {
      print(e);
    }
  });
  test('THEY have a small cellar', () async {
    final input = [
      '6',
      '3',
      'X X X X X X',
      'X C X X X X',
      'X X X X X X',
      'X X X C X X',
      'X X X X X X',
      'X X X X X X',
    ];
    final output = [
      '4',
    ];
    final process = await Process.start('dart', ['$path']);
    for (var line in input) {
      process.stdin.writeln(line);
    }
    final lineStream =
        process.stdout.transform(Utf8Decoder()).transform(LineSplitter());

    expect(lineStream, emitsInOrder([...output, emitsDone]));
    final err =
        process.stderr.transform(Utf8Decoder()).transform(LineSplitter());
    await for (var e in err) {
      print(e);
    }
  });
}
