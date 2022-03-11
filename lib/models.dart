class Team {
  int id = 0;
  String name = '';
  String address = '';
  String crestUrl = '';

  Team({required this.id, required this.name, this.crestUrl = '', this.address = ''});

  Team.from(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"],
        crestUrl = data["crestUrl"],
        address = data["address"];
}

enum winner { HOME_TEAM, AWAY_TEAM, DRAW }

class Match {
  int id = 0;
  int homeTeamID = 0;
  int awayTeamID = 0;
  winner winnerTeam;

  Match({required this.awayTeamID, required this.homeTeamID, required this.winnerTeam});

  Match.from(Map<String, dynamic> data)
      : id = data["id"],
        homeTeamID = data["homeTeam"]["id"],
        awayTeamID = data["awayTeam"]["id"],
        winnerTeam = data["score"]["winner"] == "HOME_TEAM" ? winner.HOME_TEAM : (data["score"]["winner"] == "AWAY_TEAM" ? winner.AWAY_TEAM : winner.DRAW);
}

class Score {
  int won = 0;
  int drawn = 0;

  Score({required this.won, required this.drawn});

  Score.from(Map<String, dynamic> data)
      : won = data["won"],
        drawn = data["drawn"];
}
