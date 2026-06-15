import 'round.dart';

class Game {
  String teamA;
  String teamB;

  int totalA = 0;
  int totalB = 0;

  List<Round> rounds = [];

  Game({required this.teamA, required this.teamB});

  factory Game.fromJson(Map<String, dynamic> json) {
    final game = Game(
      teamA: json['teamA'] as String,
      teamB: json['teamB'] as String,
    );

    game.rounds = (json['rounds'] as List<dynamic>? ?? [])
        .map((roundJson) => Round.fromJson(roundJson as Map<String, dynamic>))
        .toList();
    game.totalA = game.rounds.fold(0, (total, round) => total + round.teamAScore);
    game.totalB = game.rounds.fold(0, (total, round) => total + round.teamBScore);

    return game;
  }

  Map<String, dynamic> toJson() {
    return {
      'teamA': teamA,
      'teamB': teamB,
      'rounds': rounds.map((round) => round.toJson()).toList(),
    };
  }

  void addRound({
    required int aPoints,
    required int bPoints,
    required String? aBonus,
    required String? bBonus,
  }) {
    int bonusA = _bonusValue(aBonus);
    int bonusB = _bonusValue(bBonus);

    int finalA = aPoints + bonusA;
    int finalB = bPoints + bonusB;

    totalA += finalA;
    totalB += finalB;

    rounds.add(Round(
      teamAScore: finalA,
      teamBScore: finalB,
      teamATichu: aBonus,
      teamBTichu: bBonus,
    ));
  }

  int _bonusValue(String? bonus) {
    switch (bonus) {
      case "TICHU_WIN":
        return 100;
      case "TICHU_LOSE":
        return -100;
      case "GRAND_WIN":
        return 200;
      case "GRAND_LOSE":
        return -200;
      default:
        return 0;
    }
  }
}
