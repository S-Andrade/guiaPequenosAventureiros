import 'dart:async';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/activity.dart';
import 'package:flutter/material.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../widgets/color_parser.dart';
import '../../../auth.dart';

class ActivityScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  ActivityScreenTabletPortrait(this.mission);

  @override
  _ActivityScreenTabletPortraitState createState() =>
      _ActivityScreenTabletPortraitState(mission);
}

class _ActivityScreenTabletPortraitState
    extends State<ActivityScreenTabletPortrait> with WidgetsBindingObserver {
  Mission mission;
  int _state = 0;
  double padValue = 0;
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
  bool _imageExists;

  _ActivityScreenTabletPortraitState(this.mission);

  @override
  void initState() {
    _imageExists = false;
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

  @override
  void dispose() {
    print('dispose');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
  Widget build(BuildContext context) {
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      statusBarColor: Colors.transparent,
//      systemNavigationBarColor: Colors.white,
////      systemNavigationBarIconBrightness: Brightness.dark,
//      statusBarIconBrightness: Brightness.light,
//    ));

    List<Activity> activities = mission.content;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/yellow2.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Color(0xFF30246A), //change your color here
            ),
            title: Text(
              mission.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Color(0xFF30246A)),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            children: [
//              Text(
//                mission.title,
//              ),
              Positioned(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: 0.25,
                    child: Container(
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
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Container(
//                      height: 700,
                      child: Column(
//                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                Column(
                                  children: List.generate(activities.length, (index) {
                                    return Row(children: [
                                        Flexible(
                                          child: Text(
                                            activities[index].description,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Amatic SC',
                                                letterSpacing: 2,
                                                fontSize: 20),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20.0),
                                          child: Align(
                                            alignment: Alignment.topCenter,
//                                      heightFactor: 0.4,
//                                      widthFactor: 0.8,
                                            child: (activities[index].linkImage != null)
                                                ? Image(
                                                    height: 150,
                                                    image: NetworkImage(
                                                        activities[index].linkImage),
                                                    fit: BoxFit.contain,
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                    ]);
                                  }),
                                ),
                              ],
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.6,
                            child: FlatButton(
                                child: setButton(),
                                onPressed: () {
                                  setState(() {
                                    _state = 1;
                                    _loadButton();
                                  });
                                },
                                color: parseColor('#320a5c'),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(10.0))),
                          )

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget setButton() {
    if (_done == false) {
      if (_state == 0) {
        return new Text(
          "okay",
          style: const TextStyle(
            fontFamily: 'Amatic SC',
            color: Colors.white,
            fontSize: 20.0,
          ),
        );
      } else
        return ColorLoader();
    } else {
      return new Text(
        "Feita",
        style: const TextStyle(
          fontFamily: 'Amatic SC',
          color: Colors.white,
          fontSize: 20.0,
        ),
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
