import 'dart:convert';
import 'dart:io';

import 'package:bt_football_team/data_manager.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';
import 'main_bloc.dart';

class ApiManager {
  final MainBloc mainBloc = MainBloc();

  // Gets all teams participating in Premier League
  Future<dynamic> getTeams() async {
    try {
      final Uri url = Uri.parse(BASE_URL + 'teams/');
      var response = await http.get(url, headers: {'X-Auth-Token': AUTH_TOKEN});
      return json.decode(response.body)["teams"];
    } on SocketException {
      throw ("No Internet connection");
    } on HttpException {
      throw ("Couldn't find the post");
    } on FormatException {
      throw ("Bad response format");
    }
  }

  // Gets all matches that are finished within date range
  Future<dynamic> getMatches() async {
    try {
      Map<String, String> dateFromDateToMap = DataManager().getDateRange(NO_OF_DAYS);
      final Uri url = Uri.parse(BASE_URL + 'matches/?status=FINISHED&' + "dateFrom=" + dateFromDateToMap["dateFrom"]! + "&" + "dateTo=" + dateFromDateToMap["dateTo"]!);
      var response = await http.get(url, headers: {'X-Auth-Token': AUTH_TOKEN});
      return json.decode(response.body)["matches"];
    } on SocketException {
      throw ("No Internet connection");
    } on HttpException {
      throw ("Couldn't find the post");
    } on FormatException {
      throw ("Bad response format");
    }
  }
}
