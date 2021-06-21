@TestOn('vm')

import 'dart:io';
import 'dart:convert';
import 'package:test/test.dart';

void main() {
  final path = 'lib/easy/is_that_a_possible_word_e1/solution.dart';

  test('Test 1', () async {
    final input = [
      'a b c',
      'A B',
      '6',
      'A a B',
      'A b B',
      'A c B',
      'B a A',
      'B b A',
      'B c A',
      'A',
      'B',
      '10',
      'a',
      'ab',
      'abc',
      'abcd',
      'abcde',
      'aabbcc',
      'aabbcca',
      'abcabcabc',
      'z',
      'abcabcabo',
    ];
    final output = [
      'true',
      'false',
      'true',
      'false',
      'false',
      'false',
      'true',
      'true',
      'false',
      'false',
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
      'a b c d',
      'A B C D',
      '16',
      'A a A',
      'A b B',
      'A c A',
      'A d A',
      'B a A',
      'B b B',
      'B c C',
      'B d A',
      'C a A',
      'C b B',
      'C c A',
      'C d D',
      'D a A',
      'D b B',
      'D c A',
      'D d A',
      'A',
      'D',
      '5',
      'bcd',
      'abacdb',
      'aaabbccadbcd',
      'aaabcdbdebcd',
      'bcdbcdbcdbcd',
    ];
    final output = [
      'true',
      'false',
      'true',
      'false',
      'true',
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
      'a b c d',
      'A B C',
      '6',
      'A a B',
      'B c C',
      'C a C',
      'C b C',
      'C c C',
      'C d C',
      'A',
      'C',
      '7',
      'ac',
      'ab',
      'acabcd',
      'acabcde',
      'a',
      'acaaacca',
      'cafds',
    ];
    final output = [
      'true',
      'false',
      'true',
      'false',
      'false',
      'true',
      'false',
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
      'a b c',
      'A B C',
      '5',
      'A a A',
      'A b B',
      'B a B',
      'B b A',
      'B c C',
      'A',
      'A B',
      '6',
      'bc',
      'bbabc',
      'aaaabababaac',
      'aaaaabaaaabbaa',
      'abbabacc',
      'abababababbadabbba',
    ];
    final output = [
      'false',
      'false',
      'false',
      'true',
      'false',
      'false',
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
