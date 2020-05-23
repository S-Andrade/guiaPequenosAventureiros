import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_criancas/services/recompensas_api.dart';
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
    List<Activity> activities = mission.content;

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ListView(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    mission.title,
                    style: TextStyle(
                        fontSize: 70,
                        fontFamily: 'Amatic SC',
                        color: parseColor("#320a5c"),
                        letterSpacing: 4),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: List.generate(activities.length, (index) {
                return Column(children: [
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(FontAwesomeIcons.star),
                        iconSize: 40,
                        color: parseColor("#320a5c"),
                        onPressed: null,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                            width: (activities[index].linkImage != null)
                                ? 370
                                : 600,
                            child: Row(children: [
                              Flexible(
                                child: Text(
                                  activities[index].description,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 2,
                                      fontSize: 40),
                                ),
                              ),
                            ])),
                      ),
                      Container(
                          width: (activities[index].linkImage != null)
                              ? 300.0
                              : 10,
                          height: (activities[index].linkImage != null)
                              ? 300.0
                              : 10,
                          decoration: (activities[index].linkImage != null)
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  image: DecorationImage(
                                    image: new NetworkImage(
                                        activities[index].linkImage),
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : BoxDecoration(
                                  color: Colors.grey,
                                )),
                    ],
                  ),
                ]);
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0, left: 300, right: 300),
            child: MaterialButton(
                child: setButton(),
                onPressed: () {
                  setState(() {
                    _state = 1;
                    _loadButton();
                  });
                },
                height: 90,
                color: parseColor('#320a5c'),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0))),
          )
        ],
      ),
    ));
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
        await updatePoints(_userID, mission.points);
        updateMissionDoneInFirestore(mission, _userID);
        Navigator.pop(context);
      });
    }
  }

//adiciona a pontuação e os cromos ao aluno e turma
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
