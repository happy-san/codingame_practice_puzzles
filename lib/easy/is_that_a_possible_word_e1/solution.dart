import 'dart:io';
import 'dart:collection';

void main() {
  final inputs = (stdin.readLineSync() ?? '').split(' ').toSet();
  final states = (stdin.readLineSync() ?? '').split(' ').toSet();
  final LinkedHashMap transitions = LinkedHashMap<String, String>();

  final numberOfTransitions = int.parse(stdin.readLineSync() ?? '0');
  for (var i = 0; i < numberOfTransitions; i++) {
    final transition = (stdin.readLineSync() ?? '- - -').split(' ');
    final initialState = transition[0];
    final input = transition[1];
    final finalState = transition[2];

    if (states.contains(initialState) &&
        inputs.contains(input) &&
        states.contains(finalState)) {
      transitions['($initialState, $input)'] = finalState;
    }
  }
  final startState = stdin.readLineSync() ?? '';
  final endStates = (stdin.readLineSync() ?? '').split(' ').toSet();

  if (!states.contains(startState) || !states.containsAll(endStates)) {
    throw 'Invalid starting or ending state';
  }

//   stderr.writeln(states);
//   stderr.writeln(inputs);
//   stderr.writeln(transitions);

  final numberOfWords = int.parse(stdin.readLineSync() ?? '0');
  for (var i = 0; i < numberOfWords; i++) {
    final word = stdin.readLineSync() ?? '';
    var currentState = startState;
    var isValid;

    for (final letter in word.split('')) {
      // stderr.write('  $currentState - $letter -> ');
      if (transitions.containsKey('($currentState, $letter)')) {
        currentState = transitions['($currentState, $letter)']!;
        // stderr.writeln(currentState);
      } else {
        isValid = false;
        break;
      }
    }
    print(isValid ?? endStates.contains(currentState));
    // stderr.writeln('');
  }
}
