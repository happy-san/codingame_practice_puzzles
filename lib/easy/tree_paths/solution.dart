import 'dart:io';

class Node {
  var _children = List<Node>(2);

  final String value;

  Node([this.value]);

  set leftChild(Node n) => _children[0] = n;
  Node get leftChild => _children[0];

  set rightChild(Node n) => _children[1] = n;
  Node get rightChild => _children[1];
}

class BinaryTree {
  Node root;

  void add({String value, String leftChild, String rightChild}) {
    if (root == null) {
      root = Node(value)
        ..leftChild = Node(leftChild)
        ..rightChild = Node(rightChild);
    } else {
      _getNodeHaving(value, root)
        ..leftChild = Node(leftChild)
        ..rightChild = Node(rightChild);
    }
  }

  bool _ifExistsNodeWith(String value) => _getNodeHaving(value, root) != null;

  Node _getNodeHaving(String value, Node node) {
    if (value == node.value) return node;

    if (node.leftChild == null && node.rightChild == null) return null;

    var returnNode = _getNodeHaving(value, node.leftChild);

    returnNode ??= _getNodeHaving(value, node.rightChild);

    return returnNode;
  }

  String getPathTo(String value) {
    if (value == root.value) return 'Root';

    return _ifExistsNodeWith(value)
        ? _getPathToNodeWith(value, root).sublist(1).reversed.toList().join(' ')
        : '';
  }

  List<dynamic> _getPathToNodeWith(String value, Node node) {
    if (value == node.value) return [true];

    if (node.leftChild == null && node.rightChild == null) return [false];

    var returnPath = _getPathToNodeWith(value, node.leftChild);

    if (returnPath.first) {
      return returnPath..add('Left');
    } else {
      returnPath = _getPathToNodeWith(value, node.rightChild);
      if (returnPath.first) {
        returnPath.add('Right');
      }
    }
    return returnPath;
  }
}

void main() {
  final numberOfNodes = stdin.readLineSync(),
      targetNode = stdin.readLineSync(),
      parentsWithTwoChildren = int.parse(stdin.readLineSync()),
      tree = BinaryTree();

  for (var i = 0; i < parentsWithTwoChildren; i++) {
    final inputs = stdin.readLineSync().split(' '),
        node = inputs[0],
        left = inputs[1],
        right = inputs[2];

    tree.add(value: node, leftChild: left, rightChild: right);
  }

  print(tree.getPathTo(targetNode));
}
