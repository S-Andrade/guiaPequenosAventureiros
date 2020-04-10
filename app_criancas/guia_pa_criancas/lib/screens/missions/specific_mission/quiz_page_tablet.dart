import 'dart:async';
import 'package:flutter/material.dart';
import '../../../notifier/missions_notifier.dart';
import '../all_missions/all_missions_screen.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_parser.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageTabletState createState() => _QuizPageTabletState();
}

class _QuizPageTabletState extends State<QuizPage> {
  int nQuestion = 0;
  int score =0;
  List allAnswers;
  List allQuestions;
  List quizQuestions;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    quizQuestions = missionsNotifier.currentMission.content.questions;
    allQuestions=quizQuestions;
    allQuestions.sort((a,b)=> a.question.length.compareTo(b.question.length));
    if(missionsNotifier.completed == false){
      score=missionNotifier.currentScore;
      nQuestion=0;
      quizQuestions.forEach((question){
        if(question.done==true){
          nQuestion++;
        }
      });
    }
    allAnswers = allQuestions[nQuestion].sortedListAnswers();
    allAnswers.shuffle();
    

    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
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
                    top: 50,
                    right: 50,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: new MaterialButton(
                          color: parseColor("320a5c"),
                          onPressed: () {
                            setState(() {
                              print(score);
                              missionsNotifier.completed = false;
                              missionNotifier.currentMission.done = false;
                              missionNotifier.allQuestions =allQuestions;
                              missionNotifier.currentScore = score;
                              _loadButton();
                            });
                          },
                          child: new Text("X",
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 4)),
                        )),
                  ),
                  Positioned(
                    top: 820,
                    child: new Column(
                      children: _listAnswers(),
                    ),
                  ),
                ],
              ),
            )),
      ),
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
                "${missionNotifier.currentMission.content.result} %\n Esta é a tua tentativa número ${missionNotifier.currentMission.counter + 1} \n Queres repetir? ",
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
                  setState(() {
                    missionNotifier.currentMission.counter++;
                    missionNotifier.currentMission.done = true;
                    allQuestions.forEach((question) {
                      question.done = false;
                      question.success = false;
                      updateMissionQuizQuestionDone(question);
                      updateMissionQuizQuestionSuccess(question);
                    });
                    _loadButton();
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
                    missionNotifier.currentMission.counter++;
                    missionNotifier.currentMission.done = true;
                    allQuestions.forEach((question) {
                      question.done = false;
                      question.success = false;
                      updateMissionQuizQuestionDone(question);
                      updateMissionQuizQuestionSuccess(question);
                    });
                    updateMissionCounterInFirestore(
                        missionNotifier.currentMission);
                    updateMissionDoneInFirestore(
                        missionNotifier.currentMission);
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
          return new AllMissionsScreen(missionNotifier.missionsList);
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
            missionNotifier.completed=true;
            if (nQuestion == allQuestions.length - 1) {
              if (allAnswers[n] == allQuestions[nQuestion].correctAnswer) {
                if(allQuestions[nQuestion].success==false){
                 score++;
                }
                missionNotifier.currentScore = score;
                allQuestions[nQuestion].done = true;
                updateMissionQuizQuestionDone(allQuestions[nQuestion]);
                allQuestions[nQuestion].success = true;
                score = ((score * 100) / allQuestions.length).round();
                missionNotifier.currentMission.content.result = score;
                createDialog(context);
              } else {
                allQuestions[nQuestion].done = true;
                updateMissionQuizQuestionDone(allQuestions[nQuestion]);
                allQuestions[nQuestion].success = false;
                updateMissionQuizQuestionSuccess(allQuestions[nQuestion]);
                createDialogQuestion(context);
              }
            } else {
              if (allAnswers[n] == allQuestions[nQuestion].correctAnswer) {
                 if(allQuestions[nQuestion].success==false){
                  score++;
                }
                missionNotifier.currentScore = score;
                allQuestions[nQuestion].done = true;
                updateMissionQuizQuestionDone(allQuestions[nQuestion]);
                allQuestions[nQuestion].success = true;
                updateMissionQuizQuestionSuccess(allQuestions[nQuestion]);
                nQuestion++;
              } else {
                allQuestions[nQuestion].done = true;
                updateMissionQuizQuestionDone(allQuestions[nQuestion]);
                allQuestions[nQuestion].success = false;
                updateMissionQuizQuestionSuccess(allQuestions[nQuestion]);
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
      if(question==allQuestions[nQuestion]){
        Widget button = new MaterialButton(
          height: 20,
          minWidth: 20,
          shape: Border.all(style: BorderStyle.solid, width: 2, color: Colors.orange),
          color: Colors.blueGrey,
          onPressed: () {
            setState(() {
              missionNotifier.completed=true;
              nQuestion = allQuestions.indexOf(question);
              question.done =false;
              updateMissionQuizQuestionDone(question);
            });
          },
          child: new Text((allQuestions.indexOf(question) + 1).toString(),
              style: new TextStyle(fontSize: 32, color: Colors.white)),
        );
        questions.add(button);
        questions.add(new Padding(padding: EdgeInsets.all(10)));
      }
      else if (question.done == false) {
        Widget button = new MaterialButton(
          height: 20,
          minWidth: 20,
          color: Colors.blueGrey,
          onPressed: () {
            setState(() {
              missionNotifier.completed=true;
              nQuestion = allQuestions.indexOf(question);
              question.done =false;
              updateMissionQuizQuestionDone(question);
            });
          },
          child: new Text((allQuestions.indexOf(question) + 1).toString(),
              style: new TextStyle(fontSize: 32, color: Colors.white)),
        );
        questions.add(button);
        questions.add(new Padding(padding: EdgeInsets.all(10)));
      } else if (question.success == false) {
          Widget button = new MaterialButton(
            height: 20,
            minWidth: 20,
            color: Colors.red,
            onPressed: () {
              setState(() {
                missionNotifier.completed=true;
                nQuestion = allQuestions.indexOf(question);
                question.done =false;
                updateMissionQuizQuestionDone(question);
              });
            },
            child: new Text((allQuestions.indexOf(question) + 1).toString(),
                style: new TextStyle(fontSize: 32, color: Colors.white)),
          );
          questions.add(button);
          questions.add(new Padding(padding: EdgeInsets.all(10)));
        } else if(question.success==true){
          Widget button = new MaterialButton(
            height: 20,
            minWidth: 20,
            color: Colors.green,
            onPressed: () {
              setState(() {
                missionNotifier.completed=true;
                nQuestion = allQuestions.indexOf(question);
                question.done =false;
                updateMissionQuizQuestionDone(question);
              });
            },
            child: new Text((allQuestions.indexOf(question) + 1).toString(),
                style: new TextStyle(fontSize: 32, color: Colors.white)),
          );
          questions.add(button);
          questions.add(new Padding(padding: EdgeInsets.all(10)));
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
                      missionNotifier.completed = true;
                      score = ((score * 100) / allQuestions.length).round();
                      missionNotifier.currentMission.content.result = score;
                      createDialog(context);
                    } else {
                      nQuestion++;
                      updateMissionQuizQuestionDone(allQuestions[nQuestion]);
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
