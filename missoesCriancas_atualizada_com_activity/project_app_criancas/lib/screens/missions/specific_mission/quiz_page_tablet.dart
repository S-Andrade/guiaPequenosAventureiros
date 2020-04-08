import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_app_criancas/notifier/missions_notifier.dart';
import 'package:project_app_criancas/screens/missions/all_missions/all_missions_screen.dart';
import 'package:project_app_criancas/services/missions_api.dart';
import 'package:project_app_criancas/widgets/color_parser.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageTabletState createState() => _QuizPageTabletState();
}

class _QuizPageTabletState extends State<QuizPage> {
  int nQuestion = 0;
  int score = 0;
  List allAnswers;
  List allQuestions;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    allQuestions = missionsNotifier.currentMission.content.questions;
    allAnswers = allQuestions[nQuestion].sortedListAnswers();
    allAnswers.shuffle();
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back6.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: 110,
                  child: Column(
                    children: <Widget>[
                      new Row(
                        children: _listQuestions(),
                      )
                    ],
                  ),
                ),
                Positioned(
                    top: 340,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 430,
                        width: 530,
                        color: parseColor('#320a5c'),
                        child: Column(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 30, top: 100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    allQuestions[nQuestion].question,
                                    style: TextStyle(
                                        fontSize: 50,
                                        color: Colors.white,
                                        fontFamily: 'Amatic SC',
                                        letterSpacing: 4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    )),
                Positioned(
                    top: 180,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image(
                          height: 200.0,
                          width: 220.0,
                          image: AssetImage("assets/images/quiz.png"),
                          fit: BoxFit.fill,
                        ))),
                Positioned(
                  top: 820,
                  child: new Column(
                    children: _listAnswers(),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  createDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            backgroundColor: Colors.white,
            title: new Text(
              "Resultado",
              style: new TextStyle(
                  color: parseColor('#320a5c'),
                  fontSize: 50,
                  fontFamily: 'Amatic SC',
                  letterSpacing: 4),
            ),
            content: new Container(
              child: new Text(
                "${missionNotifier.currentMission.content.result} %\n Esta é a tua tentativa número ${missionNotifier.currentMission.counter} \n Queres repetir? ",
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Amatic SC',
                  letterSpacing: 4,
                ),
              ),
            ),
            actions: <Widget>[
              new MaterialButton(
                onPressed: () {
                  _loadButton();
                },
                color: Colors.red,
                child: new Text(
                  'Sair',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'Amatic SC',
                    letterSpacing: 4,
                  ),
                ),
              ),
              new MaterialButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return new QuizPage();
                    }));
                  });
                },
                color: Colors.green,
                child: new Text("Repetir",
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Amatic SC',
                      letterSpacing: 4,
                    )),
              )
            ],
          );
        });
  }

  void _loadButton() {
    Timer(Duration(milliseconds: 3000), () {
      updateMissionDoneInFirestore(missionNotifier.currentMission);
      updateMissionCounterInFirestore(missionNotifier.currentMission);
      updateMissionQuizResultInFirestore(missionNotifier.currentMission);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return new AllMissionsScreen();
        }),
      );
    });
  }

  List<Widget> _listAnswers() {
    List<Widget> lines = [];
    List<Widget> buttons = [];
    for (int n = 0; n < 4; n++) {
      Widget button = new MaterialButton(
        height: 50,
        minWidth: 100,
        color: parseColor("320a5c"),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)),
        onPressed: () {
          setState(() {
            if (nQuestion == allQuestions.length - 1) {
              if (allAnswers[n] == allQuestions[nQuestion].correctAnswer) {
                score++;
                print(score);
                allQuestions[nQuestion].done = true;
                allQuestions[nQuestion].success = true;
                score = ((score * 100) / allQuestions.length).round();
                missionNotifier.currentMission.content.result = score;
                missionNotifier.currentMission.counter++;
                missionNotifier.currentMission.done = true;
                createDialog(context);
              } else {
                allQuestions[nQuestion].done = true;
                allQuestions[nQuestion].success = false;
                createDialogQuestion(context);
              }
            } else {
              if (allAnswers[n] == allQuestions[nQuestion].correctAnswer) {
                score++;
                allQuestions[nQuestion].done = true;
                allQuestions[nQuestion].success = true;
                nQuestion++;
              } else {
                allQuestions[nQuestion].done = true;
                allQuestions[nQuestion].success = false;
                createDialogQuestion(context);
              }
            }
          });
        },
        child: new Text(allAnswers[n],
            style: TextStyle(fontSize: 32, color: Colors.white)),
      );
      buttons.add(new Row(
        children: [button],
      ));
      buttons.add(new Padding(
        padding: EdgeInsets.all(20),
      ));
    }
    lines = buttons;
    return lines;
  }

  List<Widget> _listQuestions() {
    List<Widget> questions = [];
    allQuestions.forEach((question) {
      if (question.done == false) {
        Widget button = new MaterialButton(
          height: 20,
          minWidth: 20,
          color: Colors.blueGrey,
          onPressed: () {
            setState(() {
              nQuestion = allQuestions.indexOf(question);
            });
          },
          child: new Text((allQuestions.indexOf(question) + 1).toString(),
              style: new TextStyle(fontSize: 32, color: Colors.white)),
        );
        questions.add(button);
      } else {
        if (question.success == false) {
          Widget button = new MaterialButton(
            height: 20,
            minWidth: 20,
            color: Colors.red,
            onPressed: () {
              setState(() {
                nQuestion = allQuestions.indexOf(question);
              });
            },
            child: new Text((allQuestions.indexOf(question) + 1).toString(),
                style: new TextStyle(fontSize: 32, color: Colors.white)),
          );
          questions.add(button);
        } else {
          Widget button = new MaterialButton(
            height: 20,
            minWidth: 20,
            color: Colors.green,
            onPressed: () {
              setState(() {
                nQuestion = allQuestions.indexOf(question);
              });
            },
            child: new Text((allQuestions.indexOf(question) + 1).toString(),
                style: new TextStyle(fontSize: 32, color: Colors.white)),
          );
          questions.add(button);
        }
      }
    });
    return questions;
  }

  createDialogQuestion(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            content: new Text(
              "A tua resposta não está certa! :(",
              style: new TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontFamily: 'Amatic SC',
                letterSpacing: 4,
              ),
            ),
            actions: <Widget>[
              new MaterialButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    if (nQuestion == allQuestions.length - 1) {
                      score = ((score * 100) / allQuestions.length).round();
                      missionNotifier.currentMission.content.result = score;
                      missionNotifier.currentMission.counter++;
                      missionNotifier.currentMission.done = true;
                      createDialog(context);
                    } else {
                      print('alliiiiiiiiiiiiiiiiiiii');
                      nQuestion++;
                    }
                  });
                },
                color: Colors.red,
                child: new Text(
                  'Sair',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'Amatic SC',
                    letterSpacing: 4,
                  ),
                ),
              ),
              new MaterialButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                color: Colors.green,
                child: new Text("Repetir",
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Amatic SC',
                      letterSpacing: 4,
                    )),
              )
            ],
          );
        });
  }
}
