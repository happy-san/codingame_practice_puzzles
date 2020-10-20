import 'dart:io';

void main(List<String> args) {
  var filename = 'test.dart';
  var file = File(filename).openWrite();

  stdout.write('Enter dart-file to be tested: ');
  final path = stdin.readLineSync();

  stdout.write('Enter number of tests: ');
  final testNumber = int.tryParse(stdin.readLineSync());

// Open main().
  file.write('''
@TestOn('vm')

import 'dart:io';
import 'dart:convert';
import 'package:test/test.dart';

void main(List<String> args) {
''');

// Create path variable.
  file.write('''
    final path = 
      '$path';

''');

  for (var i = 0; i < testNumber; i++) {
    stdout.write('Enter name of test ${i + 1}: ');
    final testName = stdin.readLineSync();

    stdout.write('Enter number of input lines: ');
    final inputNumber = int.tryParse(stdin.readLineSync());
    final input = <String>[];
    print('Enter input:');
    for (var j = 0; j < inputNumber; j++) {
      input.add(stdin.readLineSync());
      input[j] = "'${input[j]}'";
    }
    input.last = '${input.last},';

    stdout.write('Enter number of output lines: ');
    final outputNumber = int.tryParse(stdin.readLineSync());
    final output = <String>[];
    print('Enter output:');
    for (var j = 0; j < outputNumber; j++) {
      output.add(stdin.readLineSync());
      output[j] = "'${output[j]}'";
    }
    output.last = '${output.last},';

// Create a new test.
    file.write('''
  test('$testName', () async {
''');

// Create input variable.
    file.write('''
    final input = 
      $input;
''');

// Create output variable.
    file.write('''
    final output = 
      $output;
''');

// Open file to be tested.
    file.write('''
    final process = await Process.start('dart', ['\$path']);
''');

// Send input.
    file.write('''
    for (var line in input) {
      process.stdin.writeln(line);
    }
''');

// Check output.
    file.write('''
    final lineStream =
        process.stdout.transform(Utf8Decoder()).transform(LineSplitter());

    expect(
        lineStream,
        emitsInOrder([
          ...output,
          emitsDone
        ]));
''');

// Print errors, if any.
    file.write('''
    final err = process.stderr.transform(Utf8Decoder()).transform(LineSplitter());
    await for (var e in err) {
      print(e);
    }
''');

// Close test.
    file.write('''
  });
''');
  }

// Close main().
  file.write('''
}
''');
}
