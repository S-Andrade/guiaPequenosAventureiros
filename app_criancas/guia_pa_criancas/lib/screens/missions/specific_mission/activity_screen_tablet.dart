import 'dart:async';
import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:app_criancas/services/recompensas_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/activity.dart';
import 'package:flutter/material.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
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

  int _speechHeight;

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
    ));
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
          image: AssetImage("assets/images/yellow3.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: Text(
              mission.title,
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
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              SingleChildScrollView(
                                padding: EdgeInsets.symmetric(vertical: 95),
                                child: Column(
                                  children:
                                      List.generate(activities.length, (index) {
                                    return FractionallySizedBox(
                                      widthFactor: 0.90,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius:
                                                      2.0, // has the effect of softening the shadow
                                                  spreadRadius:
                                                      1.0, // has the effect of extending the shadow
                                                  offset: Offset(
                                                    0.0, // horizontal
                                                    3, // vertical
                                                  ),
                                                )
                                              ]),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Wrap(children: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(20),
                                                    child: Text(
                                                      activities[index]
                                                          .description,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topCenter,
//                                      heightFactor: 0.4,
//                                              widthFactor: 1,
                                                    child: (activities[index]
                                                                .linkImage !=
                                                            null)
                                                        ? Image(
                                                            image: NetworkImage(
                                                                activities[
                                                                        index]
                                                                    .linkImage),
                                                            fit: BoxFit.contain,
                                                          )
                                                        : Container(),
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
              Positioned(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: SizedBox(
                      child: FlatButton(
                          padding: EdgeInsets.all(20),
//                          enableFeedback: true,
                          highlightColor: Colors.blue,
                          child: setButton(),
                          onPressed: () {
                            setState(() {
                              _state = 1;
                              _loadButton();
                            });
                          },
                          color: Color(0xFF59BBA6),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0))),
                    ),
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
                              "Prepara os ingredientes, e mãos na massa!",
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
            ],
          )),
    );
  }

  Widget setButton() {
    HapticFeedback.vibrate();
    if (_done == false) {
      if (_state == 0) {
        return new Text(
          "Okay",
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
        );
      } else
        return ColorLoader();
    } else {
      return new Text(
        "Feito",
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      );
    }
  }

  void _loadButton() {
    HapticFeedback.vibrate();
    if (_done == true) {
      print('back');
      Navigator.pop(context);
    } else {
      Timer(Duration(milliseconds: 3000), () async {
        await updatePoints(_userID, mission.points);
        updateMissionDoneInFirestore(mission, _userID);
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
        return AlertDialog(
          title: new Text("Ganhas-te pontos"),
          content: new Text("+$points"),
          actions: <Widget>[
            // define os botões na base do dialogo
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
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
            return AlertDialog(
              title: new Text("Ganhas-te um cromo para a tua caderneta"),
              content: image,
              actions: <Widget>[
                // define os botões na base do dialogo
                new FlatButton(
                  child: new Text("Fechar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
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
            return AlertDialog(
              title: new Text("Ganhas-te um cromo para a caderneta da turma"),
              content: image,
              actions: <Widget>[
                // define os botões na base do dialogo
                new FlatButton(
                  child: new Text("Fechar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
