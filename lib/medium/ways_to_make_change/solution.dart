// @dart=2.11

import 'dart:io';
import 'dart:collection';

int nu = 1;

class Result {
  final Map<int, int> numberOfCoins;
  int _hashCode;

  Result(this.numberOfCoins) {
    _hashCode = hashCode;
  }

  @override
  String toString() => 'Coins: $numberOfCoins';

  @override
  bool operator ==(other) => other.hashCode == hashCode;

  @override
  int get hashCode {
    if (_hashCode == null) {
      if (numberOfCoins.isEmpty) {
        return 0;
      } else {
        var key = numberOfCoins.keys.first;
        var hash = '$key:${numberOfCoins[key]}'.hashCode;
        for (var i = 1; i < numberOfCoins.keys.length; i++) {
          key = numberOfCoins.keys.elementAt(i);
          hash ^= '$key:${numberOfCoins[key]}'.hashCode;
        }

        return hash;
      }
    } else {
      print(nu++);
      return _hashCode;
    }
  }
}

final memo = HashMap<int, Set<Result>>();

Set<Result> waysToSum(int target, List<int> coins) {
  if (memo.containsKey(target)) {
    // stderr.writeln('  >$map');
    return memo[target];
  }

  if (target == 0) {
    return {Result({})};
  }

  var results = <Result>{};
  for (final coin in coins) {
    if (coin <= target) {
      var _set = waysToSum(target - coin, coins);
      //   stderr.writeln('$target : $results || $_set ($coin)');
      _set = _set
          .map((result) => Result(Map.from(result.numberOfCoins)
            ..update(
              coin,
              (numberOfCoins) => ++numberOfCoins,
              ifAbsent: () => 1,
            )))
          .toSet();

      //   stderr.writeln('$target : $results || $_set');
      results = {...results, ..._set};
      //   stderr.writeln('$target : $results');
      //   stderr.writeln(' ');
    }
  }

  memo[target] = results;
//   stderr.writeln('Mapping $target to $results');
//   stderr.writeln(' ');
  return results;
}

void main() {
  // final sum = int.parse(stdin.readLineSync());
  // int numberOfCoins = int.parse(stdin.readLineSync());
  // final coins =
  //     stdin.readLineSync().split(' ').map((coin) => int.parse(coin)).toList();

  print(waysToSum(1000, [1, 2, 3, 4, 5]).length);
}
