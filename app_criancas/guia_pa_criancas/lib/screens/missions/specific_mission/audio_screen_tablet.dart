import 'dart:async';
import 'dart:io';
import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:app_criancas/services/recompensas_api.dart';
import 'package:app_criancas/widgets/color_loader_5.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../widgets/color_parser.dart';
import '../../../widgets/player_widget.dart';
import '../../../auth.dart';

class AudioScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  AudioScreenTabletPortrait(this.mission);

  @override
  _AudioScreenTabletPortraitState createState() =>
      _AudioScreenTabletPortraitState(mission);
}

class _AudioScreenTabletPortraitState extends State<AudioScreenTabletPortrait>
    with WidgetsBindingObserver {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  Mission mission;

  _AudioScreenTabletPortraitState(this.mission);

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String localFilePath;
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
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      advancedPlayer.startHeadlessService();
    }
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
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    String audioUrl = mission.linkAudio;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/movie.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Audio Example',
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
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: Stack(children: [
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
          Positioned.fill(child: Align(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              heightFactor: 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mission.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenHeight < 700 ? 26 : 30,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: EdgeInsets.all(screenHeight < 700 ? 10 : 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
//                          boxShadow: [
//                            BoxShadow(
//                              color: parseColor("#320a5c"),
//                              blurRadius: 10.0,
//                            )
//                          ]
                        ),
                        child: PlayerWidget(url: audioUrl)),
                  ),
                  FractionallySizedBox(
                    widthFactor: screenHeight < 700 ? 0.4 : 0.5,
                    child: SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                        padding: EdgeInsets.all(screenHeight < 700 ? 16 : 20),
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
            ),
          )),
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
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(5))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Text(
                          'text',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.pangolin(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
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

        ]),
      ),
    );
  }

  Widget setButton() {
    if (_done == false) {
      if (_state == 0) {
        return new Text(
          "Acabei",
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: screenHeight < 700 ? 16 : 20,
              color: Colors.white,
            ),
          ),
        );
      } else
        return ColorLoader();
    } else {
      return new Text(
        "Feita",
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: screenHeight < 700 ? 16 : 20,
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
            title: Text("Ganhas-te pontos",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    color: Colors.white),
              ),
            ),
            content: FractionallySizedBox(
              heightFactor: 0.3,
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
                      Text("+$points",  textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 50,
                              color: Color(0xFFffcc00)),
                        ),),
                      SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          color: Color(0xFFEF807A),
                          child: new Text("Fechar",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),),
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
            // retorna um objeto do tipo Dialog
            return Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
              child: AlertDialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text("Ganhas-te um cromo",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        color: Color(0xFFffcc00)),
                  ),
                ),
                content: FractionallySizedBox(
                  heightFactor: 0.6,
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
                                  borderRadius: new BorderRadius.circular(10.0)),
                              color: Color(0xFFEF807A),
                              child: new Text("Fechar",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),),
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
    if (cromos[1] != []) {
      for (String i in cromos[1]) {
        Image image;

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
            // retorna um objeto do tipo Dialog
            return Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
              child: AlertDialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text("Ganhas-te um cromo\npara a turma",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        color: Color(0xFFffcc00)),
                  ),
                ),
                content: FractionallySizedBox(
                  heightFactor: 0.6,
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
                                  borderRadius: new BorderRadius.circular(10.0)),
                              color: Color(0xFFEF807A),
                              child: new Text("Fechar",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),),
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
