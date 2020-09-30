import 'dart:io';
import 'dart:math';

/// Sentinel node to represent leaf nodes in [RedBlackTree].
final RedBlackNode nil = RedBlackNode.sentinalNode();

/// Color states a [RedBlackNode] can be in.
enum Color {
  /// Red colored node.
  red,

  /// Black colored node.
  black
}

/// Data structure similar to [_Node], differs in having connection to it's
///  [parent] and an extra [color] attribute.
class RedBlackNode<T extends Comparable> {
  /// Value of the node.
  T value;

  /// [color] of the node.
  Color color;

  /// [parent] of the node.
  RedBlackNode parent;

  /// [left] child node.
  RedBlackNode left;

  /// [right] child node.
  RedBlackNode right;

  /// [instanceCount] of [_AvlNode] with [value].
  int instanceCount = 1;

  /// Default constructor for a new node.
  RedBlackNode(this.value, this.parent) {
    color = Color.red;
    left = right = nil;
  }

  /// Creates root with [value].
  RedBlackNode.root(this.value) {
    color = Color.black;
    left = right = nil;
  }

  /// Creates a sentinal node.
  RedBlackNode.sentinalNode() : color = Color.black;
}

/// A self-balancing [BinarySearchTree].
///
/// [RedBlackTree] has following properties:
/// * Each node is either red or black.
/// * The [root] is black.
/// * All leaves ([nil]) are black.
/// * If a node is red, then both its children are black.
/// * Every path from a given node to any of its descendant [nil] nodes goes
///    through the same number of black nodes.
class RedBlackTree<T extends Comparable> {
  /// Root of the tree.
  RedBlackNode root;

  /// Creates an empty Red Back tree.
  RedBlackTree();

  /// Tests if this tree is empty.
  bool get isEmpty => root == null;

  void add(T value) {
    root = isEmpty ? RedBlackNode.root(value) : _add(root, value);

    _addReorder(root);

    // Update root.
    while (_parent(root) != null) {
      root = _parent(root);
    }
  }

  List<T> inOrder() {
    var result = <T>[];
    if (!isEmpty) {
      _inOrder(root, result);
    }
    return result;
  }

  RedBlackNode _add(RedBlackNode node, T value) {
    if (value.compareTo(node.value) < 0) {
      if (node.left != nil) {
        return _add(node.left, value);
      } else {
        return (node.left = RedBlackNode(value, node));
      }
    } else if (value.compareTo(node.value) > 0) {
      if (node.right != nil) {
        return _add(node.right, value);
      } else {
        return (node.right = RedBlackNode(value, node));
      }
    } else {
      // Duplicate value found.
      node.instanceCount++;
      return root;
    }
  }

  void _addReorder(RedBlackNode node) {
    var parent = _parent(node);
    var uncle = _uncle(node);
    var grandparent = _grandParent(node);

    // [node] is [root].
    if (parent == null) {
      node.color = Color.black;
      return;
    }

    // [parent] is black, tree is valid.
    else if (parent.color == Color.black) {
      return;
    }

    // Double red problem encountered with red [uncle].
    else if (uncle.color == Color.red) {
      // Recolor [parent], [uncle] and [grandparent] of node.
      uncle.color = parent.color = Color.black;
      grandparent.color = Color.red;

      // Check if [grandparent] is not voilating any property.
      _addReorder(grandparent);
    }

    // Double red problem encountered with black [uncle].
    else {
      // [parent] is left child.
      if (parent == grandparent.left) {
        // [node] is right child, rotate left about [parent].
        if (node == parent.right) {
          _rotateLeft(parent);

          // Update [parent] and [node].
          parent = grandparent.left;
          node = parent.left;
        }

        // [node] is left child, rotate right about [grandparent].
        _rotateRight(grandparent);
      }

      // [parent] is right child.
      else if (parent == grandparent.right) {
        // [node] is left child, rotate right about [parent].
        if (node == parent.left) {
          _rotateRight(parent);

          // Update [parent] and [node].
          parent = grandparent.right;
          node = parent.right;
        }

        // [node] is right child, rotate left about [grandparent].
        _rotateLeft(grandparent);
      }

      grandparent.color = Color.red;
      parent.color = Color.black;
    }
  }

  /// Parent of [node]'s parent.
  RedBlackNode _grandParent(RedBlackNode node) => _parent(_parent(node));

  void _inOrder(RedBlackNode node, List<T> list) {
    if (node == nil) return;
    _inOrder(node.left, list);
    var i = node.instanceCount;
    while (i-- > 0) {
      list.add(node.value);
    }
    _inOrder(node.right, list);
  }

  /// Parent of [node].
  RedBlackNode _parent(RedBlackNode node) => node?.parent;

  /// Rotates [node] N to left and makes C it's parent.
  ///
  ///          N                 C
  ///         /↶\              /  \
  ///             C     ⟶     N
  ///            / \          / \
  ///           ⬤               ⬤
  /// Left subtree of C becomes right subtree of N.
  _rotateLeft(RedBlackNode node) {
    var child = node.right;
    var parent = _parent(node);

    node.right = child.left;
    child.left = node;
    node.parent = child;

    // Update other parent/child connections.
    if (node.right != nil) {
      node.right.parent = node;
    }

    // In case [node] is not [root].
    if (parent != null) {
      if (node == parent.left) {
        parent.left = child;
      } else if (node == parent.right) {
        parent.right = child;
      }
    }

    child.parent = parent;
  }

  /// Rotates [node] N to right and makes C it's parent.
  ///
  ///            N             C
  ///           /↷\    ⟶    /  \
  ///          C                  N
  ///         / \                / \
  ///            ⬤             ⬤
  /// Right subtree of C becomes left subtree of N.
  _rotateRight(RedBlackNode node) {
    var child = node.left;
    var parent = _parent(node);

    node.left = child.right;
    child.right = node;
    node.parent = child;

    // Update other parent/child connections.
    if (node.left != nil) {
      node.left.parent = node;
    }

    // In case [node] is not [root].
    if (parent != null) {
      if (node == parent.left) {
        parent.left = child;
      } else if (node == parent.right) {
        parent.right = child;
      }
    }

    child.parent = parent;
  }

  /// Sibling of [node].
  RedBlackNode _sibling(RedBlackNode node) {
    var parent = _parent(node);
    return node == parent?.left ? parent?.right : parent?.left;
  }

  /// Sibling of [node]'s parent.
  RedBlackNode _uncle(RedBlackNode node) {
    var parent = _parent(node);
    return (_sibling(parent));
  }
}

/// Returns minimum difference between any two adjacent numbers.
int minDiff(List list) {
  var minDiff = pow(10, 7);
  for (var i = 0; i < list.length - 1; i++) {
    minDiff = min(minDiff, list[i + 1] - list[i]);
  }
  return minDiff;
}

void main() {
  var N = int.parse(stdin.readLineSync());
  var tree = RedBlackTree();
  for (var i = 0; i < N; i++) {
    tree.add(int.parse(stdin.readLineSync()));
  }
  print(minDiff(tree.inOrder()));
}
