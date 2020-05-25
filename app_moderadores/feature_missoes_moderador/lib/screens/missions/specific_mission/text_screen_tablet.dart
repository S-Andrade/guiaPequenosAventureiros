import 'dart:async';
import 'package:app_criancas/screens/companheiro/companheiro_message.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../widgets/color_parser.dart';
import '../../../auth.dart';

class TextScreenMobilePortrait extends StatefulWidget {
  Mission mission;

  TextScreenMobilePortrait(this.mission);

  @override
  _TextScreenMobilePortraitState createState() =>
      _TextScreenMobilePortraitState(mission);
}

class _TextScreenMobilePortraitState extends State<TextScreenMobilePortrait> {
  Mission mission;
  int _state = 0;
  DateTime _start;
  DateTime _end;
  int _timeSpentOnThisScreen;
  int _timeVisited;
  int _counterVisited;
  DateTime _paused;
  DateTime _returned;
  int _totalPaused;
  String _userID;
  Map resultados;
  bool _done;

  _TextScreenMobilePortraitState(this.mission);

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

    _start = DateTime.now();

    super.initState();
  }

  @override
  void dispose() {
    print('dispose');

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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/blue.png"),
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
          title: Flexible(
            child: Text(
              'Mensagem',
//              mission.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Color(0xFF30246A)),
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
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
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                heightFactor: 0.6,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          mission.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20)),
                            color: Colors.white.withOpacity(0.6),
                          ),
//                        height: 500,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Flexible(
                              child: Center(
                                child: Text(
                                  mission.content,
                                  style: GoogleFonts.pangolin(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 22,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.5,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                                child: setButton(),
                                onPressed: () {
                                  setState(() {
                                    _state = 1;
                                    _loadButton();
                                  });
                                },
                                color: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.0))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
            Positioned(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                      widthFactor: 0.6,
//                      heightFactor:0.4 ,
                      child: CompanheiroMessage())),
            ),
          ],
        ),
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
      ),
      ),);
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
