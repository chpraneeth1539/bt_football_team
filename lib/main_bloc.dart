import 'dart:async';

import 'package:bt_football_team/data_manager.dart';

import 'models.dart';

enum Event { streamDate, streamData }

class MainBloc {
  Map<Team, Score> allTeams = {};
  Map<String, String> dateRange = {};
  final _teamsStreamController = StreamController<Map<Team, Score>>();

  StreamSink<Map<Team, Score>> get teamsWonSink => _teamsStreamController.sink;
  Stream<Map<Team, Score>> get teamsWonStream => _teamsStreamController.stream;

  final _dateStreamController = StreamController<Map<String, String>>();
  StreamSink<Map<String, String>> get dateSink => _dateStreamController.sink;
  Stream<Map<String, String>> get dateStream => _dateStreamController.stream;

  final _eventStreamController = StreamController<Event>();

  StreamSink<Event> get eventSink => _eventStreamController.sink;
  Stream<Event> get eventStream => _eventStreamController.stream;

  void dispose() {
    _teamsStreamController.close();
    _dateStreamController.close();
    _eventStreamController.close();
  }

  MainBloc() {
    allTeams = {};
    dateRange = {};
    eventStream.listen((Event event) async {
      if (event == Event.streamData) {
        allTeams = await DataManager().getWinnerTeams();
        teamsWonSink.add(allTeams);
      } else {
        dateRange = DataManager().getDateRange();
        dateSink.add(dateRange);
      }
    });
  }
}
