class Round {
  final int teamAScore;
  final int teamBScore;
  final String? teamATichu;
  final String? teamBTichu;

  Round({
    required this.teamAScore,
    required this.teamBScore,
    this.teamATichu,
    this.teamBTichu,
  });

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      teamAScore: json['teamAScore'] as int,
      teamBScore: json['teamBScore'] as int,
      teamATichu: json['teamATichu'] as String?,
      teamBTichu: json['teamBTichu'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamAScore': teamAScore,
      'teamBScore': teamBScore,
      'teamATichu': teamATichu,
      'teamBTichu': teamBTichu,
    };
  }
}
