// @dart=2.11

import 'dart:io';

/// Dictionary to store state of all the cells.
///
///     All possible inputs:         | Corresponding entries in [dictionary]:
///     OPERATION: `value` _         | `[0, value]`
///     OPERATION: $link _           | `[1, link]`
///     OPERATION: `value` $link     | `[2, value, link, 'operation']`
///     OPERATION: $link `value`     | `[3, link, value, 'operation']`
///     OPERATION: $link $link       | `[4, link, link, 'operation']`
///     OPERATION: `value1` `value2` | `[0, returnValue]`, `returnValue` = operation(`value1`, `value2`);
List<List<dynamic>> dictionary = List.generate(100, (i) => List(4));

/// Evaluates and updates the entry at [index] in [dictionary].
num evaluate(int index) {
  var entry = dictionary[index];

  var val;
  switch (entry[0]) {

    // Value present.
    case 0:
      return entry[1];

    // Link present.
    case 1:
      val = evaluate(entry[1]);
      break;

    // Value, link and operation present.
    case 2:
      switch (entry[3]) {
        case 'add':
          val = add(entry[1], evaluate(entry[2]));
          break;
        case 'sub':
          val = sub(entry[1], evaluate(entry[2]));
          break;
        case 'mult':
          val = mult(entry[1], evaluate(entry[2]));
          break;
      }
      break;

    // Link, value and operation present.
    case 3:
      switch (entry[3]) {
        case 'add':
          val = add(evaluate(entry[1]), entry[2]);
          break;
        case 'sub':
          val = sub(evaluate(entry[1]), entry[2]);
          break;
        case 'mult':
          val = mult(evaluate(entry[1]), entry[2]);
          break;
      }
      break;

    // Two links and operation present.
    case 4:
      switch (entry[3]) {
        case 'add':
          val = add(evaluate(entry[1]), evaluate(entry[2]));
          break;
        case 'sub':
          val = sub(evaluate(entry[1]), evaluate(entry[2]));
          break;
        case 'mult':
          val = mult(evaluate(entry[1]), evaluate(entry[2]));
          break;
      }
      break;
  }

  // Update entry in dictinary with [value].
  entry[0] = 0;
  entry[1] = val;
  return val;
}

void addNewEntry(index, operation, arg1, arg2) {
  // If only values are present in input.
  //  OPERATION: `value` _
  //  OPERATION: `value1` `value2`
  var onlyValues =
      !arg1.contains('\$') && (!arg2.contains('\$') || arg2.contains('_'));

  if (!onlyValues && !arg2.contains('_')) {
    // Both [arg1] and [arg2] are links.
    //  OPERATION: $link $link
    if (arg1.contains('\$') && arg2.contains('\$')) {
      dictionary[index] = [
        4,
        int.parse(arg1.replaceFirst('\$', '')),
        int.parse(arg2.replaceFirst('\$', '')),
      ];
    }

    // Only [arg1] is link.
    //  OPERATION: $link `value`
    else if (arg1.contains('\$')) {
      dictionary[index] = [
        3,
        int.parse(arg1.replaceFirst('\$', '')),
        num.parse(arg2),
      ];
    }

    // Only [arg2] is link.
    //  OPERATION: `value` $link
    else {
      dictionary[index] = [
        2,
        num.parse(arg1),
        int.parse(arg2.replaceFirst('\$', '')),
      ];
    }
  }

  switch (operation) {
    case 'VALUE':
      if (onlyValues) {
        dictionary[index] = [0, num.parse(arg1)];
      } else {
        // OPERATION: $link _
        dictionary[index] = [1, int.parse(arg1.replaceFirst('\$', ''))];
      }
      break;
    case 'ADD':
      if (onlyValues) {
        dictionary[index] = [0, add(num.parse(arg1), num.parse(arg2))];
      } else {
        dictionary[index].add('add');
      }
      break;
    case 'SUB':
      if (onlyValues) {
        dictionary[index] = [0, sub(num.parse(arg1), num.parse(arg2))];
      } else {
        dictionary[index].add('sub');
      }
      break;
    case 'MULT':
      if (onlyValues) {
        dictionary[index] = [0, mult(num.parse(arg1), num.parse(arg2))];
      } else {
        dictionary[index].add('mult');
      }
      break;
  }
}

num add(num a, num b) => a + b;

num sub(num a, num b) => a - b;

num mult(num a, num b) => a * b;

void main() {
  var N = int.parse(stdin.readLineSync());
  for (var i = 0; i < N; i++) {
    var inputs = stdin.readLineSync().split(' ');
    var operation = inputs[0];
    var arg1 = inputs[1];
    var arg2 = inputs[2];

    addNewEntry(i, operation, arg1, arg2);
  }
  for (var i = 0; i < N; i++) {
    print(evaluate(i));
  }
}
