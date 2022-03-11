import 'api_manager.dart';
import 'models.dart';

class DataManager {
  //Gets the from and to dates
  Map<String, String> getDateRange(int noOfDays) {
    var timeStamp = DateTime.now(); //Get current date
    String toDate = timeStamp.toString().split(" ")[0];
    String fromDate = DateTime(timeStamp.year, timeStamp.month, timeStamp.day - noOfDays).toString().split(" ")[0];
    return {"dateTo": toDate, "dateFrom": fromDate};
  }

  // Sets all teams returns a map with key:value->TeamID:Team
  Future<Map<int, Team>> setTeams() async {
    List allTeamsData = await ApiManager().getTeams();
    Map<int, Team> allTeamsMap = {};
    if (allTeamsData.isNotEmpty) {
      //Generating TeamID:Team instance
      for (var element in allTeamsData) {
        allTeamsMap[element["id"]] = Team.from(element);
      }
    }
    return allTeamsMap;
  }

  // Sets list of winner TeamIDs in matches
  Future<List<int>> setWinnerIDs() async {
    final matchesData = await ApiManager().getMatches();
    List<int> matches = [];
    if (matchesData != null) {
      matches = List<int>.from(matchesData.map((eachMatch) => Match.from(eachMatch).winnerTeamID));
    }
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
      List<int> temp = winnerTeamIDs[value] ?? [];
      temp.add(key);
      winnerTeamIDs[value] = temp;
    });

    // Generating Team object for each team ID with maxScore.
    Map<int, Team> allTeamsInLeague = await setTeams();
    if (allTeamsInLeague.keys.isEmpty) {
      return {};
    }
    winnerTeamIDs[maxScore]?.forEach((element) {
      mostWonTeams[allTeamsInLeague[element]!] = maxScore;
    });

    return mostWonTeams;
  }

  Future<Map<Team, int>> generateMostWonTeams() async {
    List<int> winnerTeamIDs = await setWinnerIDs();
    //Generating TeamID: #wins
    Map<int, int> teamsAndItsScores = {};
    if (winnerTeamIDs.isEmpty) {
      return {};
    }
    for (var eachWinnerTeamID in winnerTeamIDs) {
      int temp = (teamsAndItsScores[eachWinnerTeamID] ?? 0);
      teamsAndItsScores[eachWinnerTeamID] = temp + 1;
    }
    teamsAndItsScores.remove(0); //Excludes matches that are DRAWN

    return findMaxWonTeams(teamsAndItsScores);
  }
}
