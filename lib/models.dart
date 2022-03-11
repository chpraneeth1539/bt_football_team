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

class Match {
  int id = 0;
  int winnerTeamID;

  Match({required this.winnerTeamID});

  Match.from(Map<String, dynamic> data)
      : id = data["id"],
        winnerTeamID = data["score"]["winner"] == "HOME_TEAM" ? data["homeTeam"]["id"] : ((data["score"]["winner"] == "AWAY_TEAM") ? data["awayTeam"]["id"] : 0); //assigning winner team id of the match
}
