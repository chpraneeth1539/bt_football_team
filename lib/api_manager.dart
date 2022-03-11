import 'package:bt_football_team/data_manager.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class ApiManager {
  // Gets all teams participating in Premier League
  Future<dynamic> getTeams() async {
    final Uri url = Uri.parse(BASE_URL + 'teams/');
    var response = await http.get(url, headers: {'X-Auth-Token': AUTH_TOKEN});
    return response.body;
  }

  // Gets all matches that are finished within date range
  Future<dynamic> getMatches() async {
    Map<String, String> dateFromDateToMap = DataManager().getDateRange();
    final Uri url = Uri.parse(BASE_URL + 'matches/?status=FINISHED&' + "dateFrom=" + dateFromDateToMap["dateFrom"]! + "&" + "dateTo=" + dateFromDateToMap["dateTo"]!);
    var response = await http.get(url, headers: {'X-Auth-Token': AUTH_TOKEN});
    return response.body;
  }
}
