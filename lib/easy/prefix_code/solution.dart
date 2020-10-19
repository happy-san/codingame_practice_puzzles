import 'dart:io';

/// Node having two [chlidren] and a [value].
class Node {
  final children = List<Node>(2);
  int value;

  Node(this.value);
}

/// Trie data structure to store encoding scheme.
class Trie {
  final root = Node(null);

  /// Adds [value] to trie with [key].
  void add(List key, int value) {
    _add(root, key, value);
  }

  /// Traverses trie according to [string] and adds value, if present, at the end of path.
  List<int> searchString(String string) {
    final list = <int>[];
    // Pointer to traverse trie.
    var node = root;
    final length = string.length;
    for (var i = 0; i < length; i++) {
      var path = int.parse(string[i]);
      if (node.children[path] != null) {
        node = node.children[path];
        if (node.value != null) {
          // Value found, reset `node`.
          list.add(node.value);
          node = root;
        } else if (i + 1 == length) {
          // Value not found and it's the last bit of `string`.
          throw ('DECODE FAIL AT INDEX $i');
        }
      } else {
        // Path doesn't exist.
        throw ('DECODE FAIL AT INDEX ${list.length}');
      }
    }
    return list;
  }

  /// Makes path according to [key], reducing [key] at every step and adds [value] at the last step.
  void _add(Node node, List key, int value) {
    if (key.isEmpty) {
      node.value = value;
      return;
    }
    var path = key.first;
    key = key.sublist(1);

    node.children[path] ??= Node(null);
    _add(node.children[path], key, value);
  }
}

/// Converts the [key] into a list of integers.
List<int> getIntList(String key) {
  final list = List<int>.generate(key.length, (index) {
    var number = int.parse(key[0]);
    key = key.substring(1);
    return number;
  });

  return list;
}

void main() {
  List inputs;
  var trie = Trie();

  var n = int.parse(stdin.readLineSync());
  for (var i = 0; i < n; i++) {
    inputs = stdin.readLineSync().split(' ');
    var key = getIntList(inputs[0].toString());
    var value = int.parse(inputs[1]);

    trie.add(key, value);
  }

  var s = stdin.readLineSync();

  try {
    var list = trie.searchString(s);
    for (var char in list) {
      stdout.write(String.fromCharCode(char));
    }
  } catch (e) {
    print(e);
  }
}
