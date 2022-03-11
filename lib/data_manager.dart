import 'dart:convert';

import 'api_manager.dart';
import 'constants.dart';
import 'models.dart';

class DataManager {
  Map<String, String> getDateRange() {
    var timeStamp = DateTime.now();
    String toDate = timeStamp.toString().split(" ")[0];
    String fromDate = DateTime(timeStamp.year, timeStamp.month, timeStamp.day - 15).toString().split(" ")[0];
    String urls = base_url + 'matches/?' + fromDate + "&" + toDate;

    Map<String, String> dateRange = {"dateTo": toDate, "dateFrom": fromDate};
    return dateRange;
  }

  // Sets all teams
  Future<List<Team>> setTeams() async {
    final teamsData = await ApiManager().getTeams();
    List<Team> teams = List<Team>.from(json.decode(teamsData)["teams"].map((eachTeam) => Team.from(eachTeam)));
    return teams;
  }

  // Sets all matches
  Future<List<Match>> setMatches() async {
    List<Match> matches = [];
    final matchesData = await ApiManager().getMatches();
    matches = List<Match>.from(json.decode(matchesData)["matches"].map((eachMatch) => Match.from(eachMatch)));
    return matches;
  }

  Future<Map<Team, Score>> getWinnerTeams() async {
    List<Match> allMatches = await setMatches();

    Map<int, Score>? teams = {};

    for (var match in allMatches) {
      switch (match.winnerTeam) {
        case winner.HOME_TEAM:
          if (teams.containsKey(match.homeTeamID) && teams[match.homeTeamID] != null) {
            teams[match.homeTeamID] = Score.from({"won": teams[match.homeTeamID]!.won + 1, "drawn": teams[match.homeTeamID]!.drawn});
          } else {
            teams[match.homeTeamID] = Score.from({"won": 1, "drawn": 0});
          }
          break;
        case winner.AWAY_TEAM:
          if (teams.containsKey(match.awayTeamID) && teams[match.awayTeamID] != null) {
            teams[match.awayTeamID] = Score.from({"won": teams[match.awayTeamID]!.won + 1, "drawn": teams[match.awayTeamID]!.drawn});
          } else {
            teams[match.awayTeamID] = Score.from({"won": 1, "drawn": 0});
          }
          break;
        case winner.DRAW:
          if (teams.containsKey(match.homeTeamID) && teams[match.awayTeamID] != null) {
            teams[match.homeTeamID] = Score.from({"won": teams[match.homeTeamID]!.won, "drawn": teams[match.homeTeamID]!.drawn + 1});
          } else {
            teams[match.homeTeamID] = Score.from({"won": 0, "drawn": 1});
          }
          if (teams.containsKey(match.awayTeamID) && teams[match.awayTeamID] != null) {
            teams[match.awayTeamID] = Score.from({"won": teams[match.awayTeamID]!.won, "drawn": teams[match.awayTeamID]!.drawn + 1});
          } else {
            teams[match.awayTeamID] = Score.from({"won": 0, "drawn": 1});
          }
          break;
      }
    }

    teams.forEach((key, value) {
      print(key.toString() + " - " + "won: " + value.won.toString() + "     drawn: " + value.drawn.toString());
    });

    Map<int, List<int>> wins = {};
    int maxScore = 0, winningTeamID;

    teams.forEach((key, value) {
      if (maxScore < value.won) {
        maxScore = value.won;
        winningTeamID = key;
      }
      if (wins.containsKey(value.won) && wins[value.won] != null) {
        wins[value.won]?.add(key);
      } else {
        wins[value.won] = [key];
      }
    });

    print(wins[maxScore]);

    Map<Team, Score> finalTeams = {};
    List<Team> allTeams = await setTeams();

    for (Team eachTeam in allTeams) {
      if (wins[maxScore]!.contains(eachTeam.id)) {
        finalTeams[eachTeam] = teams[eachTeam.id]!;
      }
    }
    return finalTeams;
  }
}
