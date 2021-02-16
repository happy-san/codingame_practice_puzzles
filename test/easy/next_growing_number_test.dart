@TestOn('vm')

import 'dart:io';
import 'dart:convert';
import 'package:test/test.dart';

void main() {
  final path = 'lib/easy/next_growing_number/solution.dart';

  test('Test 1', () async {
    final input = [
      '19',
    ];
    final output = [
      '22',
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
  test('Test 2', () async {
    final input = [
      '99',
    ];
    final output = [
      '111',
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
  test('Test 3', () async {
    final input = [
      '2533',
    ];
    final output = [
      '2555',
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
  test('Test 4', () async {
    final input = [
      '123456879',
    ];
    final output = [
      '123456888',
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
  test('Test 5', () async {
    final input = [
      '11123159995399999',
    ];
    final output = [
      '11123333333333333',
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
