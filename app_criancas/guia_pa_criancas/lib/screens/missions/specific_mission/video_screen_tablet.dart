import 'dart:async';
import 'package:app_criancas/widgets/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../widgets/color_parser.dart';
import 'package:video_player/video_player.dart';
import '../../../auth.dart';

class VideoScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  VideoScreenTabletPortrait(this.mission);

  @override
  _VideoScreenTabletPortraitState createState() =>
      _VideoScreenTabletPortraitState(mission);
}

class _VideoScreenTabletPortraitState extends State<VideoScreenTabletPortrait>
    with WidgetsBindingObserver {
  Mission mission;

  _VideoScreenTabletPortraitState(this.mission);
  int _state = 0;

  String _userID;
  Map resultados;
  bool _done;
  int _timeSpentOnThisScreen;
  int _timeVisited;
  int _counterVisited;
  DateTime _paused;
  DateTime _returned;
  int _totalPaused;
  DateTime _start;
  DateTime _end;

  @override
  void initState() {
    Auth().getUser().then((user) {
      setState(() {
        _userID = user.email;
        for (var a in mission.resultados) {
          if (a["aluno"] == _userID) {
            resultados = a;
            _done = resultados["done"];
            _counterVisited = resultados["counterVisited"];
            _timeVisited = resultados["timeVisited"];
          }
        }
      });
    });

    WidgetsBinding.instance.addObserver(this);

    _start = DateTime.now();
    super.initState();
  }

  AppLifecycleState state;

  @override
  void deactivate() {
    _counterVisited = _counterVisited + 1;
    _end = DateTime.now();
    _timeSpentOnThisScreen = _end.difference(_start).inSeconds;
    _timeVisited = _timeVisited + _timeSpentOnThisScreen;
    updateMissionTimeAndCounterVisitedInFirestore(
        mission, _userID, _timeVisited, _counterVisited);
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _paused = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      _returned = DateTime.now();
    }
    _totalPaused = _returned.difference(_paused).inSeconds;
    _timeVisited = _timeVisited - _totalPaused;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/movie.png"),
          fit: BoxFit.cover,
        ),
      ),
//      decoration: BoxDecoration(
//        gradient: LinearGradient(
//          begin: Alignment.topLeft,
//          end: Alignment.bottomCenter,
//          stops: [0.0, 1.0],
//          colors: [
//            Color(0xFFFCF477),
//            Color(0xFFF6A51E),
//          ],
//        ),
//      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Video",
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.black),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
            alignment: Alignment.center,
            children: [
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 0.25,
                child: Container(
//                        height: 130,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/clouds_bottom_navigation_white.png'),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      )),
                ),
              ),
            ),
          ),
          Positioned(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom:20.0),
                      child: Text(
                        mission.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 36,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    ChewieDemo(link: mission.linkVideo, ),
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: SizedBox(
                        width: double.infinity,
                        height: 65,
                        child: FlatButton(
                          child: setButton(),
                          onPressed: () {
                            setState(() {
                              _state = 1;
                              _loadButton();
                            });
                          },
                          color: Color(0xFFF3C463),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ]),
      ),
    );
  }

  Widget setButton() {
    if (_done == false) {
      if (_state == 0) {
        return new Text(
          "Okay",
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 20,
                color: Colors.white,
              ),),
        );
      } else
        return ColorLoader();
    } else {
      return new Text(
        "Feita",
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 20,
            color: Colors.white,
          ),),
      );
    }
  }

  void _loadButton() {
    if (_done == true) {
      print('back');
      Navigator.pop(context);
    } else {
      Timer(Duration(milliseconds: 3000), () {
        updateMissionDoneInFirestore(mission, _userID);
        Navigator.pop(context);
      });
    }
  }
}
