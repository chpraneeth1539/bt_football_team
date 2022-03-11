import 'dart:async';

import 'package:bt_football_team/constants.dart';

import 'data_manager.dart';
import 'models.dart';

enum Event { streamDate, streamData }

class MainBloc {
  Map<Team, int> allTeams = {};
  Map<String, String> dateRange = {};
  final _teamsStreamController = StreamController<Map<Team, int>>();

  StreamSink<Map<Team, int>> get teamsWonSink => _teamsStreamController.sink;

  Stream<Map<Team, int>> get teamsWonStream => _teamsStreamController.stream;

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
      switch (event) {
        case Event.streamData:
          try {
            allTeams = await DataManager().generateMostWonTeams();
            teamsWonSink.add(allTeams);
          } catch (e) {
            teamsWonSink.addError(e);
          }
          break;
        case Event.streamDate:
          dateRange = DataManager().getDateRange(NO_OF_DAYS);
          dateSink.add(dateRange);
          break;
      }
    });
  }
}
