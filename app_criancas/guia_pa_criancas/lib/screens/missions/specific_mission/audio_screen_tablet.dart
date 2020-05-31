import 'dart:async';
import 'dart:io';
import 'package:app_criancas/services/recompensas_api.dart';
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
    String audioUrl = mission.linkAudio;

    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Example'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back6.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 108.0),
            child: Text(
              mission.title,
              style: TextStyle(
                  fontSize: 70,
                  fontFamily: 'Amatic SC',
                  color: Colors.white,
                  letterSpacing: 4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120.0, left: 30, right: 30),
            child: Container(
                decoration: BoxDecoration(
                    color: parseColor("#320a5c"),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: parseColor("#320a5c"),
                        blurRadius: 10.0,
                      )
                    ]),
                child: PlayerWidget(url: audioUrl)),
          ),
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: MaterialButton(
                child: setButton(),
                onPressed: () {
                  setState(() {
                    _state = 1;
                    _loadButton();
                  });
                },
                height: 90,
                minWidth: 300,
                color: parseColor('#320a5c'),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0))),
          )
        ]),
      ),
    );
  }

  Widget setButton() {
    if (_done == false) {
      if (_state == 0) {
        return new Text(
          "okay",
          style: const TextStyle(
            fontFamily: 'Amatic SC',
            letterSpacing: 4,
            color: Colors.white,
            fontSize: 40.0,
          ),
        );
      } else
        return ColorLoader();
    } else {
      return new Text(
        "Feita",
        style: const TextStyle(
          fontFamily: 'Amatic SC',
          letterSpacing: 4,
          color: Colors.white,
          fontSize: 40.0,
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
