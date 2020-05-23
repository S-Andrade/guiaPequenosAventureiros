import 'package:app_criancas/models/mission.dart';
import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../notifier/missions_notifier.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_parser.dart';
import 'package:provider/provider.dart';
import '../../../auth.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageTabletState createState() => _QuizPageTabletState();
}

class _QuizPageTabletState extends State<QuizPage> with WidgetsBindingObserver {
  int nQuestion = 0;
  int score = 0;
  List allAnswers;
  List allQuestions;
  List quizQuestions;
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
  int _counter;
  Mission mission;

  @override
  void initState() {
    Auth().getUser().then((user) {
      setState(() {
        _userID = user.email;
        MissionsNotifier missionsNotifier =
            Provider.of<MissionsNotifier>(context, listen: false);
        mission = missionsNotifier.currentMission;
        for (var a in mission.resultados) {
          if (a["aluno"] == _userID) {
            resultados = a;
            _done = resultados["done"];
            _counterVisited = resultados["counterVisited"];
            _timeVisited = resultados["timeVisited"];
            _counter = resultados["counter"];
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
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
//      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));

    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    mission = missionsNotifier.currentMission;
    quizQuestions = missionsNotifier.currentMission.content.questions;
    allQuestions = quizQuestions;
    allQuestions.sort((a, b) => a.question.length.compareTo(b.question.length));
    if (missionsNotifier.completed == false) {
      score = missionNotifier.currentScore;
      nQuestion = 0;
      quizQuestions.forEach((question) {
        if (question.done == true) {
          nQuestion++;
        }
      });
    }
    allAnswers = allQuestions[nQuestion].sortedListAnswers();
    allAnswers.shuffle();

    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/purple3.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              )),
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Color(0xFF30246A), //change your color here
              ),
              title: Center(
                child: Text(
                  "Quiz",
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
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      print(score);
                      missionsNotifier.completed = false;
                      missionNotifier.allQuestions = allQuestions;
                      missionNotifier.currentScore = score;
                      _loadButton();
                    });
                  },
                ),
              ],
            ),
            body: Stack(
//              fit: StackFit.loose,
              children: <Widget>[
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
//                    heightFactor: 0.9,
//                    padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 700,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _listQuestions(),
                            ),
                            Container(
                              decoration: BoxDecoration(
//                            color: Color(0xFF01BBB6).withOpacity(1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        allQuestions[nQuestion].question,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

//                  RESPOSTAS
                            FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: _listAnswers(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //Bottom clouds
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
                //Companheiro fundo
                Positioned(
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: CompanheiroAppwide()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  createDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
            ),
            child: AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                "Resultado",
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                      color: Colors.yellow),
                ),
              ),
              content: FractionallySizedBox(
                heightFactor: 0.4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          "${missionNotifier.currentMission.content.result} %\n Esta é a tua tentativa número ${_counter + 1}.\n Queres repetir? ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 20,
                                color: Color(0xFF30246A)),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            onPressed: () {
                              setState(() {
                                _counter = _counter + 1;
                                _done = true;
                                allQuestions.forEach((question) {
                                  question.done = false;
                                  question.success = false;
                                  updateMissionQuizQuestionTDone(question);
                                  updateMissionQuizQuestionTSuccess(question);
                                });
                                Navigator.pop(context);
                                _loadButton();
                              });
                            },
                            color: Colors.red,
                            child: new Text(
                              'Terminar',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            onPressed: () {
                              setState(() {
                                _counter = _counter + 1;
                                _done = true;
                                allQuestions.forEach((question) {
                                  question.done = false;
                                  question.success = false;
                                  updateMissionQuizQuestionTDone(question);
                                  updateMissionQuizQuestionTSuccess(question);
                                });
                                updateMissionCounterInFirestore(
                                    missionNotifier.currentMission,
                                    _userID,
                                    _counter);
                                updateMissionDoneInFirestore(
                                    missionNotifier.currentMission, _userID);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return new QuizPage();
                                }));
                              });
                            },
                            color: Colors.green,
                            child: new Text(
                              "Recomeçar",
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[],
            ),
          );
        });
  }

  void _loadButton() {
    updateMissionDoneInFirestore(missionNotifier.currentMission, _userID);
    updateMissionCounterInFirestore(
        missionNotifier.currentMission, _userID, _counter);
    updateMissionQuizResultInFirestore(
        missionNotifier.currentMission, _userID, missionNotifier.currentScore);

    _end = DateTime.now();
    _timeSpentOnThisScreen = _end.difference(_start).inSeconds;
    _timeVisited = _timeVisited + _timeSpentOnThisScreen;
    updateMissionTimeAndCounterVisitedInFirestore(
        mission, _userID, _timeVisited, _counterVisited);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  List<Widget> _listAnswers() {
    List<Widget> lines = [];
    List<Widget> buttons = [];
    for (int n = 0; n < 4; n++) {
      Widget button = MaterialButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onPressed: () {
          setState(() {
            missionNotifier.completed = true;
            if (nQuestion == allQuestions.length - 1) {
              if (allAnswers[n] == allQuestions[nQuestion].correctAnswer) {
                if (allQuestions[nQuestion].success == false) {
                  score++;
                }
                missionNotifier.currentScore = score;
                allQuestions[nQuestion].done = true;
                updateMissionQuizQuestionDone(allQuestions[nQuestion], _userID);
                allQuestions[nQuestion].success = true;
                score = ((score * 100) / allQuestions.length).round();
                missionNotifier.currentMission.content.result = score;
                createDialog(context);
              } else {
                allQuestions[nQuestion].done = true;
                updateMissionQuizQuestionDone(allQuestions[nQuestion], _userID);
                allQuestions[nQuestion].success = false;
                updateMissionQuizQuestionSuccess(
                    allQuestions[nQuestion], _userID);
                createDialogQuestion(context);
              }
            } else {
              if (allAnswers[n] == allQuestions[nQuestion].correctAnswer) {
                if (allQuestions[nQuestion].success == false) {
                  score++;
                }
                missionNotifier.currentScore = score;
                allQuestions[nQuestion].done = true;
                updateMissionQuizQuestionDone(allQuestions[nQuestion], _userID);
                allQuestions[nQuestion].success = true;
                updateMissionQuizQuestionSuccess(
                    allQuestions[nQuestion], _userID);
                nQuestion++;
              } else {
                allQuestions[nQuestion].done = true;
                updateMissionQuizQuestionDone(allQuestions[nQuestion], _userID);
                allQuestions[nQuestion].success = false;
                updateMissionQuizQuestionSuccess(
                    allQuestions[nQuestion], _userID);
                createDialogQuestion(context);
              }
            }
          });
        },
        // Lista de RESPOSTAS
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            allAnswers[n],
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black),
            ),
          ),
        ),
      );
      buttons.add(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[button],
      ));
      buttons.add(new Padding(
        padding: EdgeInsets.all(8),
      ));
    }
    lines = buttons;
    return lines;
  }

  List<Widget> _listQuestions() {
    List<Widget> questions = [];
    allQuestions.forEach((question) {
      if (question == allQuestions[nQuestion]) {
        Widget button = FlatButton(
          shape: CircleBorder(side: BorderSide(color: Colors.white, width: 3)),
          color: Color(0xFF30246A),
          onPressed: () {
            setState(() {
              missionNotifier.completed = true;
              nQuestion = allQuestions.indexOf(question);
              question.done = false;
              updateMissionQuizQuestionDone(question, _userID);
            });
          },
          child: Text(
            (allQuestions.indexOf(question) + 1).toString(),
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
//              color: Color(0xFF30246A)),
                  color: Colors.white),
            ),
          ),
        );
        questions.add(button);
      } else if (question.done == false) {
        Widget button = FlatButton(
          shape: CircleBorder(),
          color: Colors.yellow,
          onPressed: () {
            setState(() {
              missionNotifier.completed = true;
              nQuestion = allQuestions.indexOf(question);
              question.done = false;
              updateMissionQuizQuestionDone(question, _userID);
            });
          },
          child: Text(
            (allQuestions.indexOf(question) + 1).toString(),
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
//              color: Color(0xFF30246A)),
                  color: Color(0xFF30246A)),
            ),
          ),
        );
        questions.add(button);
      } else if (question.success == false) {
        Widget button = FlatButton(
          shape: CircleBorder(),
          color: Colors.red,
          onPressed: () {
            setState(() {
              missionNotifier.completed = true;
              nQuestion = allQuestions.indexOf(question);
              question.done = false;
              updateMissionQuizQuestionDone(question, _userID);
            });
          },
          child: Text(
            (allQuestions.indexOf(question) + 1).toString(),
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
//              color: Color(0xFF30246A)),
                  color: Colors.white),
            ),
          ),
        );
        questions.add(button);
      } else if (question.success == true) {
        Widget button = FlatButton(
          shape: CircleBorder(),
          color: Colors.green,
          onPressed: () {
            setState(() {
              missionNotifier.completed = true;
              nQuestion = allQuestions.indexOf(question);
              question.done = false;
              updateMissionQuizQuestionDone(question, _userID);
            });
          },
          child: Text(
            (allQuestions.indexOf(question) + 1).toString(),
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
//              color: Color(0xFF30246A)),
                  color: Colors.white),
            ),
          ),
        );
        questions.add(button);
      }
    });
    return questions;
  }

  createDialogQuestion(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
            ),
            child: new AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: FractionallySizedBox(
                heightFactor: 0.4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Text(
                            "A tua resposta não está certa! :(",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                  color: Color(0xFF30246A)),
                            ),
                          ),
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                              if (nQuestion == allQuestions.length - 1) {
                                missionNotifier.completed = true;
                                score = ((score * 100) / allQuestions.length)
                                    .round();
                                missionNotifier.currentMission.content.result =
                                    score;
                                createDialog(context);
                              } else {
                                nQuestion++;
                                updateMissionQuizQuestionDone(
                                    allQuestions[nQuestion], _userID);
                              }
                            });
                          },
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Próxima',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Tenta de novo",
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
//              new MaterialButton(
//                onPressed: () {
//                  setState(() {
//                    Navigator.pop(context);
//                    if (nQuestion == allQuestions.length - 1) {
//                      missionNotifier.completed = true;
//                      score = ((score * 100) / allQuestions.length).round();
//                      missionNotifier.currentMission.content.result = score;
//                      createDialog(context);
//                    } else {
//                      nQuestion++;
//                      updateMissionQuizQuestionDone(
//                          allQuestions[nQuestion], _userID);
//                    }
//                  });
//                },
//                color: Colors.red,
//                child: new Text(
//                  'Sair',
//                  style: new TextStyle(
//                    color: Colors.white,
//                    fontSize: 25,
//                    fontFamily: 'Amatic SC',
//                    letterSpacing: 4,
//                  ),
//                ),
//              ),
//              new MaterialButton(
//                onPressed: () {
//                  setState(() {
//                    Navigator.pop(context);
//                  });
//                },
//                color: Colors.green,
//                child: new Text("Repetir",
//                    style: new TextStyle(
//                      color: Colors.white,
//                      fontSize: 25,
//                      fontFamily: 'Amatic SC',
//                      letterSpacing: 4,
//                    )),
//              ),
              ],
            ),
          );
        });
  }
}
