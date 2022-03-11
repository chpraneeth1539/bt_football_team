import 'package:bt_football_team/data_manager.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class ApiManager {
  // Gets all teams
  Future<dynamic> getTeams() async {
    final Uri url = Uri.parse(base_url + 'teams/');
    var response = await http.get(url, headers: {'X-Auth-Token': AUTH_TOKEN});
    return response.body;
  }

  // Gets all matches
  Future<dynamic> getMatches() async {
    Map<String, String> dateRange = DataManager().getDateRange();
    final Uri url = Uri.parse(base_url + 'matches/?' + "dateFrom=" + dateRange["dateFrom"]! + "&" + "dateTo=" + dateRange["dateTo"]!);
    var response = await http.get(url, headers: {'X-Auth-Token': AUTH_TOKEN});
    return response.body;
  }
}
