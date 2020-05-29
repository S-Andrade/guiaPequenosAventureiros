import 'dart:async';

import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../widgets/color_parser.dart';
import '../../../auth.dart';

class ImageScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  ImageScreenTabletPortrait(this.mission);

  @override
  _ImageScreenTabletPortraitState createState() =>
      _ImageScreenTabletPortraitState(mission);
}

class _ImageScreenTabletPortraitState extends State<ImageScreenTabletPortrait>
    with WidgetsBindingObserver {
  Mission mission;
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

  _ImageScreenTabletPortraitState(this.mission);

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
    NetworkImage _image;
    if (mission.linkImage != null) _image = NetworkImage(mission.linkImage);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/blue3.png"),
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
            "Espreita",
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
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  heightFactor: 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[

                    Text(
                      mission.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                            color: Colors.white),
                      ),
                    ),

                      SingleChildScrollView(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Align(
                            alignment: Alignment.topCenter,
//                      heightFactor: 0.8,
//                      widthFactor: 0.8,
                            child: Image(
                              image: _image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.5,
                        child: SizedBox(
                          width: double.infinity,
                          child: FlatButton(
                              padding: EdgeInsets.all(20),
                              child: setButton(),
                              onPressed: () {
                                setState(() {
                                  _state = 1;
                                  _loadButton();
                                });
                              },
//                    height: 90,
//                    minWidth: 300,
                              color: Color(0xFFFF418E),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.topLeft,
                child: FractionallySizedBox(
                  heightFactor: 0.15,
                  widthFactor: 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black45.withOpacity(0.8),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(10))),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Aqui estou a dizer algo mesmo muito pertinente",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Align(
                  alignment: Alignment.topRight, child: CompanheiroAppwide()),
            ),
          ],
        ),
      ),
    );
  }

  Widget setButton() {
    if (_done == false) {
      if (_state == 0) {
        return Text(
          "Okay",
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
              color: Colors.white,
            ),),
        );
      } else
        return ColorLoader();
    } else {
      return Text(
        "Feita",
        textAlign: TextAlign.center,
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 18,
            color: Colors.white,
          ),
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
