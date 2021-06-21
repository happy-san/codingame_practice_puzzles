// @dart=2.11

import 'dart:io';

/// Matches [topLabel] with corresponding [bottomLabel] by navigating [ghostLegDiagram].
String navigate(List<String> ghostLegDiagram, String topLabel, int start) {
  var level = 1,
      finalLevel = ghostLegDiagram.length - 2,
      currentGhostLegIndex = start,
      width = ghostLegDiagram[0].length;

  while (level <= finalLevel) {
    // Connector to left ghost leg found.
    if (currentGhostLegIndex > 2 &&
        ghostLegDiagram[level][currentGhostLegIndex - 1] == '-') {
      // Change ghost leg and descend.
      currentGhostLegIndex -= 3;
      level++;
    }

    // Connector to right ghost leg found.
    else if (currentGhostLegIndex < width - 3 &&
        ghostLegDiagram[level][currentGhostLegIndex + 1] == '-') {
      // Change ghost leg and descend.
      currentGhostLegIndex += 3;
      level++;
    }

    // No connectors, keep descending.
    else {
      level++;
    }
  }

  var bottomLabel = ghostLegDiagram.last[currentGhostLegIndex];
  return '$topLabel$bottomLabel';
}

void main() {
  List input;
  input = stdin.readLineSync().split(' ');
  var width = int.parse(input[0]);
  var height = int.parse(input[1]);

  var ghostLegDiagram = List<String>(height);
  for (var i = 0; i < height; i++) {
    ghostLegDiagram[i] = stdin.readLineSync();
  }
  var top = ghostLegDiagram.first;
  for (var i = 0; i < width; i += 3) {
    // For every top label.
    print(navigate(ghostLegDiagram, top[i], i));
  }
}
