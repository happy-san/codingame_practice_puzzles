// @dart=2.11

import 'dart:io';

/// A self-balancing Binary Search Tree.
///
/// In AVL tree, difference in the height of left and right subtrees
///  of any node can be at most 1.
class AvlTree<T extends Comparable> {
  /// Root of the tree
  _AvlNode root;

  /// If after addition, height of parent node increases.
  bool _isTaller = false;

  /// Creates an empty AVL tree.
  AvlTree();

  /// Creates an AVL tree with all the values of [list].
  AvlTree.fromList(List<T> list) {
    for (var value in list) {
      add(value);
    }
  }

  /// Creates a new AVL tree with a single [value].
  AvlTree.withSingleValue(T value) : root = _AvlNode.withValue(value);

  /// Tests if this tree is empty.
  bool get isEmpty => root == null;

  void add(T value) {
    if (isEmpty) {
      root = _AvlNode();
      root = _add(root, value, true);
    } else {
      root = _add(root, value, false);
    }
  }

  int instanceCount(T value) => isEmpty ? 0 : _compareAndCheck(root, value);

  List<T> inOrder() {
    var result = <T>[];
    _inOrder(root, result);
    return result;
  }

  void nullify() => root = null;

  /// Balances the left heavy, imbalanced [node].
  _AvlNode _aBalanceLeft(_AvlNode node) {
    var lChild = node.left;

    // Addition done in left subtree of [lChild].
    if (lChild.balanceFactor == 1) {
      node.balanceFactor = lChild.balanceFactor = 0;
      // Single right rotation about [node] is performed to balance it.
      node = _rotateRight(node);
    }

    // Addition done in right subtree of [lChild].
    else {
      var rGrandChild = lChild.right;
      switch (rGrandChild.balanceFactor) {

        // Addition is done in right subtree of [rGrandChild].
        case -1:
          node.balanceFactor = 0;
          lChild.balanceFactor = 1;
          break;

        // Addition is done in left subtree of [rGrandChild].
        case 1:
          node.balanceFactor = -1;
          lChild.balanceFactor = 0;
          break;

        // [rGrandChild] is the newly added node.
        case 0:
          node.balanceFactor = lChild.balanceFactor = 0;
      }
      rGrandChild.balanceFactor = 0;
      // Left Right rotation is perfomed to balance [node].
      node.left = _rotateLeft(lChild);
      node = _rotateRight(node);
    }

    return node;
  }

  /// Balances the right heavy, imbalanced [node].
  _AvlNode _aBalanceRight(_AvlNode node) {
    var rChild = node.right;

    // Addition done in right subtree of [rChild].
    if (rChild.balanceFactor == -1) {
      node.balanceFactor = rChild.balanceFactor = 0;
      // Single left rotation about [node] is performed to balance it.
      node = _rotateLeft(node);
    }

    // Addition done in left subtree of [rChild].
    else {
      var lGrandChild = rChild.left;
      switch (lGrandChild.balanceFactor) {

        // Addition is done in right subtree of [lGrandChild].
        case -1:
          node.balanceFactor = 1;
          rChild.balanceFactor = 0;
          break;

        // Addition is done in left subtree of [lGrandChild].
        case 1:
          node.balanceFactor = 0;
          rChild.balanceFactor = -1;
          break;

        // [lGrandChild] is the newly added node.
        case 0:
          node.balanceFactor = rChild.balanceFactor = 0;
      }
      lGrandChild.balanceFactor = 0;
      // Right Left rotation is perfomed to balance [node].
      node.right = _rotateRight(rChild);
      node = _rotateLeft(node);
    }

    return node;
  }

  _AvlNode _add(_AvlNode node, T value, bool isNull) {
    if (isNull) {
      // Base case, node's value is set.
      node.value = value;
      _isTaller = true;
    } else if (node.value.compareTo(value) > 0) {
      if (node.left == null) {
        // If left subtree is null,
        //  create a new node and pass [isNull] as true.
        /*var newNode = _AvlNode(null);
        node.left = newNode;
        node.left = _add(newNode, value, true);*/
        node.left = _AvlNode();
        node.left = _add(node.left, value, true);
      } else {
        // Otherwise traverse to left subtree.
        node.left = _add(node.left, value, false);
      }
      if (_isTaller) {
        // Update balance factor of parent after addition.
        node = _aUpdateLeftBalanceFactor(node);
      }
    } else if (node.value.compareTo(value) < 0) {
      if (node.right == null) {
        // If right subtree is null,
        //  create a new node and pass [isNull] as true.
        node.right = _AvlNode();
        node.right = _add(node.right, value, true);
      } else {
        // Otherwise traverse to right subtree.
        node.right = _add(node.right, value, false);
      }
      if (_isTaller) {
        // Update balance factor of parent after addition.
        node = _aUpdateRightBalanceFactor(node);
      }
    } else {
      // Duplicate value found.
      node.instanceCount++;
      _isTaller = false;
    }
    return node;
  }

  /// Updates [balanceFactor] when addition is done in left subtree of [node].
  _AvlNode _aUpdateLeftBalanceFactor(_AvlNode node) {
    switch (node.balanceFactor) {

      // node was balanced.
      case 0:
        // node is left heavy now.
        node.balanceFactor = 1;
        break;

      // node was right heavy.
      case -1:
        // node is balanced now.
        node.balanceFactor = 0;
        _isTaller = false;
        break;

      // node was left heavy.
      case 1:
        // node is imbalanced now, has to be balanced.
        node = _aBalanceLeft(node);
        _isTaller = false;
    }
    return node;
  }

  /// Updates [balanceFactor] when addition is done in right subtree of [node].
  _AvlNode _aUpdateRightBalanceFactor(_AvlNode node) {
    switch (node.balanceFactor) {

      // node was balanced.
      case 0:
        // node is right heavy now.
        node.balanceFactor = -1;
        break;

      // node was left heavy.
      case 1:
        // node is balanced now.
        node.balanceFactor = 0;
        _isTaller = false;
        break;

      // node was right heavy.
      case -1:
        // node is imbalanced now, has to be balanced.
        node = _aBalanceRight(node);
        _isTaller = false;
    }
    return node;
  }

  int _compareAndCheck(_AvlNode node, T value) {
    if (node.value == value) return node.instanceCount;
    return (node.value.compareTo(value) >= 0
        ? (node.left != null ? _compareAndCheck(node.left, value) : 0)
        : (node.right != null ? _compareAndCheck(node.right, value) : 0));
  }

  void _inOrder(_AvlNode node, List<T> list) {
    if (node == null) return;
    _inOrder(node.left, list);
    list.add(node.value);
    _inOrder(node.right, list);
  }

  /// Rotates [rightUnbalancedNode] U to left and makes C it's parent.
  ///
  ///          U                 C
  ///         /↶\              /  \
  ///             C     ⟶     U
  ///            / \          / \
  ///           ⬤               ⬤
  /// Left subtree of C becomes right subtree of U.
  _AvlNode _rotateLeft(_AvlNode rightUnbalancedNode) {
    var rightChild = rightUnbalancedNode.right;
    rightUnbalancedNode.right = rightChild.left;
    rightChild.left = rightUnbalancedNode;
    return rightChild;
  }

  /// Rotates [leftUnbalancedNode] U to right and makes C it's parent.
  ///
  ///            U             C
  ///           /↷\    ⟶    /  \
  ///          C                  U
  ///         / \                / \
  ///            ⬤             ⬤
  /// Right subtree of C becomes left subtree of U.
  _AvlNode _rotateRight(_AvlNode leftUnbalancedNode) {
    var leftChild = leftUnbalancedNode.left;
    leftUnbalancedNode.left = leftChild.right;
    leftChild.right = leftUnbalancedNode;
    return leftChild;
  }
}

/// Data structure similar to a Node, differs in having a [balanceFactor].
class _AvlNode<T extends Comparable> {
  /// Difference between height of left and right subtree.
  ///
  /// [balanceFactor] ∈ `{-1, 0, 1}`.
  /// Any [_AvlNode] having [balanceFactor] outside this set is imbalanced.
  int balanceFactor;

  /// Value of the node.
  T value;

  /// [left] child node.
  _AvlNode<T> left;

  /// [right] child node.
  _AvlNode<T> right;

  /// [instanceCount] of [_AvlNode] with [value].
  int instanceCount = 1;

  /// Creates an empty avlNode.
  _AvlNode() : balanceFactor = 0;

  /// Creates an avlNode with [value].
  _AvlNode.withValue(this.value) : balanceFactor = 0;
}

/// Returns all possible sub-measurements.
///
/// Suppose you have width measurements: `[a, b, c, w]`
///  where w is the maximum width of the rectangle.
///
///     0___a_____b__________c____w
///     |   |     |          |    |
///     |___|_____|__________|____|
///
/// The sub-measurements are: `[a, a-b, a-c, a-w, b, b-c, b-w, c, c-w, w]`.
AvlTree subMeasurement(List<int> measurementList) {
  final n = measurementList.length;

  var tree = AvlTree();
  for (var i = 0; i < n; i++) {
    tree.add(measurementList[i]);
    for (var j = i + 1; j < n; j++) {
      var diff = measurementList[j] - measurementList[i];
      tree.add(diff);
    }
  }
  return tree;
}

/// Matches all the sub-measurements of `widthMeasurement` and `heightMeasurement`,
///  returns the count where they are equal.
int countSquares(AvlTree widthMeasurements, AvlTree heightMeasurements) {
  var count = 0;

  for (var measurement in widthMeasurements.inOrder()) {
    count += widthMeasurements.instanceCount(measurement) *
        heightMeasurements.instanceCount(measurement);
  }

  return count;
}

void main() {
  List inputs;
  inputs = stdin.readLineSync().split(' ');
  final countX = int.parse(inputs[2]);
  final countY = int.parse(inputs[3]);

  final widthMeasurements = List<int>(countX + 1),
      heightMeasurements = List<int>(countY + 1);
  // Put width and height as last elements in respective lists.
  widthMeasurements.last = int.parse(inputs[0]);
  heightMeasurements.last = int.parse(inputs[1]);

  inputs = stdin.readLineSync().split(' ');
  for (var i = 0; i < countX; i++) {
    widthMeasurements[i] = int.parse(inputs[i]);
  }

  inputs = stdin.readLineSync().split(' ');
  for (var i = 0; i < countY; i++) {
    heightMeasurements[i] = int.parse(inputs[i]);
  }

  print(countSquares(
      subMeasurement(widthMeasurements), subMeasurement(heightMeasurements)));
}
