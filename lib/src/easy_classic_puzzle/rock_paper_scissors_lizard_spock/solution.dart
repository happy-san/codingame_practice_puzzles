import 'dart:io';

class Player {
  final int id;
  final String sign;
  List<int> opponents;

  Player(this.id, this.sign) : opponents = [];

  void addOpponent(int id) => opponents.add(id);
}

Player duelWinner(Player p1, Player p2) {
  if (p1.sign == p2.sign) {
    // In case of a tie, the player with the lower id wins.
    if (p1.id < p2.id) {
      return p1..addOpponent(p2.id);
    } else {
      return p2..addOpponent(p1.id);
    }
  }

  // Rearrange [p1] and [p2] to reduce comparisions.
  var temp, rearrange = false;
  if (p1.sign == 'P' || p2.sign == 'P') {
    if (p1.sign != 'P') {
      rearrange = true;
    }
  } else if (p1.sign == 'R' || p2.sign == 'R') {
    if (p1.sign != 'R') {
      rearrange = true;
    }
  } else if (p1.sign == 'L' || p2.sign == 'L') {
    if (p1.sign != 'L') {
      rearrange = true;
    }
  } else if (p1.sign == 'S' || p2.sign == 'S') {
    if (p1.sign != 'S') {
      rearrange = true;
    }
  }

  if (rearrange) {
    temp = p1;
    p1 = p2;
    p2 = temp;
  }

  if (p1.sign.contains('P')) {
    // Paper covers Rock.
    if (p2.sign.contains('R')) {
      return p1..addOpponent(p2.id);
    }
    // Lizard eats Paper.
    if (p2.sign.contains('L')) {
      return p2..addOpponent(p1.id);
    }
    // Paper disproves Spock.
    if (p2.sign.contains('S')) {
      return p1..addOpponent(p2.id);
    }
    // Scissors cuts Paper.
    if (p2.sign.contains('C')) {
      return p2..addOpponent(p1.id);
    }
  } else if (p1.sign.contains('R')) {
    // Rock crushes Lizard.
    if (p2.sign.contains('L')) {
      return p1..addOpponent(p2.id);
    }
    // Spock vaporizes Rock.
    if (p2.sign.contains('S')) {
      return p2..addOpponent(p1.id);
    }
    // Rock crushes Scissors.
    if (p2.sign.contains('C')) {
      return p1..addOpponent(p2.id);
    }
  } else if (p1.sign.contains('L')) {
    // Lizard poisons Spock.
    if (p2.sign.contains('S')) {
      return p1..addOpponent(p2.id);
    }
    // Scissors decapitate Lizard.
    if (p2.sign.contains('C')) {
      return p2..addOpponent(p1.id);
    }
  } else if (p1.sign.contains('S')) {
    // Spock smashes Scissors.
    if (p2.sign.contains('C')) {
      return p1..addOpponent(p2.id);
    }
  }
  return null;
}

Player runTourney(Map<int, Player> playerMap) {
  var playerCount = playerMap.keys.length;

  // Base case.
  if (playerCount == 2) {
    var player1 = playerMap[playerMap.keys.toList()[0]];
    var player2 = playerMap[playerMap.keys.toList()[1]];

    return duelWinner(player1, player2);
  }

  var left = <int, Player>{}, right = <int, Player>{};
  var i = 0, mid = playerCount ~/ 2;
  playerMap.forEach((key, value) {
    if (i < mid) {
      left[key] = value;
    } else {
      right[key] = value;
    }
    i++;
  });

  return duelWinner(runTourney(left), runTourney(right));
}

void main() {
  var playerMap = <int, Player>{};
  var N = int.parse(stdin.readLineSync());
  for (var i = 0; i < N; i++) {
    var input = stdin.readLineSync().split(' ');
    var NUMPLAYER = int.parse(input[0]);
    var SIGNPLAYER = input[1];

    var player = Player(NUMPLAYER, SIGNPLAYER);
    playerMap[player.id] = player;
  }

  var winner = runTourney(playerMap);
  print(winner.id);
  print(winner.opponents.toString().replaceAll(RegExp(r'^\[|,|\]$'), ''));
}
