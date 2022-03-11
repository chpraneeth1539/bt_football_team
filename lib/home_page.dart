import 'package:bt_football_team/main_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import 'models.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MainBloc mainBloc = MainBloc();

  @override
  void initState() {
    super.initState();
    mainBloc.eventSink.add(Event.streamDate);
    mainBloc.eventSink.add(Event.streamData);
  }

  @override
  void dispose() {
    mainBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    imageContainer({required String imageURL}) => Container(
          width: screenWidth * 0.30,
          height: screenWidth * 0.30,
          alignment: Alignment.center,
          child: (imageURL.endsWith('svg'))
              ? SvgPicture.network(
                  imageURL,
                  placeholderBuilder: (BuildContext context) => const SpinKitCircle(color: Colors.black, size: 40.0),
                )
              : CachedNetworkImage(
                  imageUrl: imageURL,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SpinKitCircle(color: Colors.black, size: 40.0),
                  errorWidget: (context, url, error) => const Text('Error loading image'),
                ),
        );

    teamWidget(Team eachTeam, int teamScore) => Container(
          color: Colors.white,
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              imageContainer(imageURL: eachTeam.crestUrl),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(eachTeam.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    Text(eachTeam.address),
                    Text('Won: ${teamScore}'),
                  ],
                ),
              ),
            ],
          ),
        );

    refreshButton() => Container(
          height: 50,
          width: screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: RawMaterialButton(
            child: const Text('Tap to refresh', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18)),
            onPressed: () {
              mainBloc.eventSink.add(Event.streamData);
              mainBloc.eventSink.add(Event.streamDate);
            },
          ),
        );

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30.0),
              child: Column(
                children: [
                  Text('Teams won most matches in last 30 days', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 14)),
                  StreamBuilder<Map<String, String>>(
                      stream: mainBloc.dateStream,
                      builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
                        if (snapshot.hasData) {
                          return Text('${snapshot.data!["dateFrom"]} to ${snapshot.data!["dateTo"]}', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500));
                        }
                        return const Text('');
                      }),
                  SizedBox(height: 5)
                ],
              )),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: StreamBuilder<Map<Team, int>>(
                    stream: mainBloc.teamsWonStream,
                    builder: (context, AsyncSnapshot<Map<Team, int>> snapshot) {
                      if (snapshot.hasError) Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const SpinKitCircle(color: Colors.black, size: 60.0);
                        default:
                          Map<Team, int> allTeams = snapshot.data!;
                          List<Team> teamsWon = allTeams.keys.toList();
                          List<int> teamsScore = allTeams.values.toList();
                          return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: allTeams.length,
                              itemBuilder: (context, index) {
                                return teamWidget(teamsWon[index], teamsScore[index]);
                              });
                      }
                    }),
              ),
              refreshButton(),
            ],
          ),
        ));
  }
}
