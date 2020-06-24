import 'dart:async';
import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:app_criancas/services/recompensas_api.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
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
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

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
    } 

     if (state == AppLifecycleState.inactive) {
    
      _paused = DateTime.now();
    }
    
    else if (state == AppLifecycleState.resumed) {
      _returned = DateTime.now();
    }
    _totalPaused = _returned.difference(_paused).inSeconds;
    _timeVisited = _timeVisited - _totalPaused;
  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

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
                alignment: Alignment.topCenter,
                child: DelayedDisplay(
                  delay: Duration(milliseconds: 800),
                  fadingDuration: const Duration(milliseconds: 800),
                  slidingBeginOffset: const Offset(0.0, 0.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
//                  heightFactor: 0.6,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.all(screenHeight < 700 ? 10 : 20.0),
                            child: Text(
                              mission.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: screenHeight < 700 ? 24 : 28,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            width: screenHeight < 700
                                ? screenWidth * 0.6
                                : screenWidth * 0.7,
                            height: screenHeight < 700
                                ? screenWidth * 0.6
                                : screenWidth * 0.7,
//                          padding: EdgeInsets.all(20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Image(
//                              height:  screenHeight < 700 ? screenHeight/2.5 : screenHeight,
                                  image: _image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight < 700 ? 16 : 20.0),
                            child: FractionallySizedBox(
                              widthFactor: 0.4,
                              child: SizedBox(
                                width: double.infinity,
                                child: FlatButton(
                                    padding: EdgeInsets.all(
                                        screenHeight < 700 ? 16 : 20),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  widthFactor:
                      screenHeight < 700 ? 0.8 : screenWidth > 800 ? 0.77 : 0.9,
                  heightFactor: screenHeight < 700
                      ? 0.14
                      : screenHeight < 1000 ? 0.14 : 0.20,
                  child: Stack(
                    children: [
                      FlareActor(
                        "assets/animation/dialog.flr",
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.center,
//                        controller: _controller,
                        artboard: 'Artboard',
                        animation: 'open_dialog',
                      ),
                      Center(
                        child: DelayedDisplay(
                          delay: Duration(seconds: 1),
                          fadingDuration: const Duration(milliseconds: 800),
                          slidingBeginOffset: const Offset(0, 0.0),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: screenHeight > 1000
                                    ? 40
                                    : screenHeight < 700 ? 16 : 20.0,
                                right: screenHeight > 1000
                                    ? 130
                                    : screenHeight < 700 ? 60 : 100),
                            child: Text(
                              "Aqui estou a dizer algo mesmo muito pertinente",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.pangolin(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: screenHeight < 700
                                        ? 16
                                        : screenHeight < 1000 ? 20 : 32,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              child: Align(
                  alignment: Alignment.topRight,
                  child: DelayedDisplay(
//                          delay: Duration(seconds: 1),
                      fadingDuration: const Duration(milliseconds: 800),
//                          slidingBeginOffset: const Offset(-0.5, 0.0),
                      child: CompanheiroAppwide())),
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
              fontSize: screenHeight < 700 ? 16 : 18,
              color: Colors.white,
            ),
          ),
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
            fontSize: screenHeight < 700 ? 16 : 18,
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
      Timer(Duration(milliseconds: 3000), () async {
        updateMissionDoneInFirestore(mission, _userID);
        await updatePoints(_userID, mission.points);
        Navigator.pop(context);
      });
    }
  }

  //adiciona a pontuação e os cromos ao aluno e turma
  //melhorar frontend
  updatePoints(String aluno, int points) async {
    List cromos = await updatePontuacao(aluno, points);
    print("tellle");
    print(cromos);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
          ),
          child: AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              "Ganhas-te pontos",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    color: Colors.white),
              ),
            ),
            content: FractionallySizedBox(
              heightFactor: screenHeight < 700 ? 0.6 : 0.4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "+$points",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 50,
                              color: Color(0xFFffcc00)),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          color: Color(0xFFEF807A),
                          child: new Text(
                            "Fechar",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    if (cromos[0] != []) {
      for (String i in cromos[0]) {
        Image image;
        if (i != null) {
          await FirebaseStorage.instance
              .ref()
              .child(i)
              .getDownloadURL()
              .then((downloadUrl) {
            image = Image.network(
              downloadUrl.toString(),
              fit: BoxFit.fitWidth,
            );
          });

          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                ),
                child: AlertDialog(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    "Ganhas-te um cromo",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: Color(0xFFffcc00)),
                    ),
                  ),
                  content: FractionallySizedBox(
                    heightFactor: 0.8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            image,
                            SizedBox(
                              width: double.infinity,
                              child: FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                                color: Color(0xFFEF807A),
                                child: new Text(
                                  "Fechar",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      }
    }
    if (cromos[1] != []) {
      for (String i in cromos[1]) {
        Image image;
        if (i != null) {
          await FirebaseStorage.instance
              .ref()
              .child(i)
              .getDownloadURL()
              .then((downloadUrl) {
            image = Image.network(
              downloadUrl.toString(),
              fit: BoxFit.scaleDown,
            );
          });

          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                ),
                child: AlertDialog(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    "Ganhas-te um cromo\npara a turma",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: Color(0xFFffcc00)),
                    ),
                  ),
                  content: FractionallySizedBox(
                    heightFactor: 0.8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            image,
                            SizedBox(
                              width: double.infinity,
                              child: FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                                color: Color(0xFFEF807A),
                                child: new Text(
                                  "Fechar",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      }
    }
  }
}
