import 'dart:convert';

import 'api_manager.dart';
import 'models.dart';

class DataManager {
  //Gets the from and to dates
  Map<String, String> getDateRange() {
    var timeStamp = DateTime.now(); //Get current date
    String toDate = timeStamp.toString().split(" ")[0];
    String fromDate = DateTime(timeStamp.year, timeStamp.month, timeStamp.day - 30).toString().split(" ")[0];

    return {"dateTo": toDate, "dateFrom": fromDate};
  }

  // Sets all teams returns a map with key:value->TeamID:Team
  Future<Map<int, Team>> setTeams() async {
    final teamsData = await ApiManager().getTeams();
    List allTeamsData = json.decode(teamsData)["teams"];

    //Generating TeamID:Team instance
    Map<int, Team> teams = {};
    for (var element in allTeamsData) {
      teams[element["id"]] = Team.from(element);
    }
    return teams;
  }

  // Sets list of winner TeamIDs in matches
  Future<List<int>> setWinnerIDs() async {
    final matchesData = await ApiManager().getMatches();
    List<int> matches = List<int>.from(json.decode(matchesData)["matches"].map((eachMatch) => Match.from(eachMatch).winnerTeamID));
    return matches;
  }

  // Finds teams that has won most matches
  Future<Map<Team, int>> findMaxWonTeams(Map<int, int> teamsAndItsScores) async {
    Map<int, List<int>> winnerTeamIDs = {};
    Map<Team, int> mostWonTeams = {};
    int maxScore = 0;

    //Generating #wins:List of teamIDs having same number of wins.
    teamsAndItsScores.forEach((key, value) {
      if (maxScore < value) {
        maxScore = value;
      }
      if (winnerTeamIDs.containsKey(value) && winnerTeamIDs[value] != null) {
        winnerTeamIDs[value]?.add(key);
      } else {
        winnerTeamIDs[value] = [key];
      }
    });

    // Generating Team object for each team ID with maxScore.
    Map<int, Team> allTeamsInLeague = await setTeams();
    winnerTeamIDs[maxScore]?.forEach((element) {
      mostWonTeams[allTeamsInLeague[element]!] = maxScore;
    });

    return mostWonTeams;
  }

  Future<Map<Team, int>> generateMostWonTeams() async {
    List<int> winnerTeamIDs = await setWinnerIDs();

    //Generating TeamID: #wins
    Map<int, int> teamsAndItsScores = {};
    for (var eachWinnerTeamID in winnerTeamIDs) {
      if (teamsAndItsScores.containsKey(eachWinnerTeamID) && teamsAndItsScores[eachWinnerTeamID] != null) {
        teamsAndItsScores[eachWinnerTeamID] = teamsAndItsScores[eachWinnerTeamID]! + 1;
      } else {
        teamsAndItsScores[eachWinnerTeamID] = 1;
      }
    }
    teamsAndItsScores.remove(0); //Excludes matches that has score -> winner as DRAW

    return findMaxWonTeams(teamsAndItsScores);
  }
}
