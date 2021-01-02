import 'dart:io';
import 'dart:math';

enum Connection { Series, Parallel }

String parse(String circuit, Map<String, int> map) {
  var list = circuit.split(' ');
  Connection type;

  for (var i = 1; i < list.length; i++) {
    // Start of new circuit.
    if (list[i].contains(RegExp(r'\[|\('))) {
      continue;
    }

    // Resistor name encountered.
    else if (list[i].contains(RegExp(r'[a-zA-Z]'))) {
      print('pass: $i');
      continue;
    }

    // End of circuit.
    else {
      type = list[i].contains(')') ? Connection.Series : Connection.Parallel;
      list[i] = '';
      var resistance = 0.0;
      // Retrace back while calculating resistance of this circuit.
      for (var j = i - 1;; j--) {
        // Ignore empty cells.
        if (list[j].compareTo('') == 0) {
          continue;
        }

        // Retraced back to starting of circuit.
        if (list[j].contains(RegExp(r'\[|\('))) {
          resistance =
              (type == Connection.Series) ? resistance : pow(resistance, -1);
          list[j] = resistance.toString();
          break;
        }

        // Name of a resistor, add it's value according to circuit type.
        else if (double.tryParse(list[j]) == null) {
          resistance += (type == Connection.Series)
              ? map[list[j]]
              : pow(map[list[j]], -1);
          list[j] = '';
        }

        // Resistance calculated previously.
        else {
          resistance += (type == Connection.Series)
              ? double.parse(list[j])
              : pow(double.parse(list[j]), -1);
          list[j] = '';
        }
      }
    }
  }

  return double.parse(list.first).toStringAsFixed(1);
}

void main() {
  List inputs;
  var N = int.parse(stdin.readLineSync());
  var map = <String, int>{};

  for (var i = 0; i < N; i++) {
    inputs = stdin.readLineSync().split(' ');
    var name = inputs[0];
    var R = int.parse(inputs[1]);

    map.putIfAbsent(name, () => R);
  }
  var circuit = stdin.readLineSync();

  print(parse(circuit, map));
}
