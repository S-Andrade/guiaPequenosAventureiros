import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_app_criancas/models/mission.dart';
import 'package:project_app_criancas/screens/missions/all_missions/all_missions_screen.dart';
import 'package:project_app_criancas/services/missions_api.dart';
import 'package:project_app_criancas/widgets/color_loader.dart';
import 'package:project_app_criancas/widgets/color_parser.dart';

class QuizScreenTabletPortrait extends StatefulWidget {
  final Mission mission;

  QuizScreenTabletPortrait(this.mission);

  @override
  _QuizScreenTabletPortraitState createState() =>
      _QuizScreenTabletPortraitState(mission);
}

class _QuizScreenTabletPortraitState extends State<QuizScreenTabletPortrait> {
  Mission mission;
  int _state = 0;
  int nQuestion = 0;
  int score = 0;
  List allAnswers;

  _QuizScreenTabletPortraitState(this.mission);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    allAnswers = mission.content.questions[nQuestion].sortedListAnswers();
    allAnswers.shuffle();
    print('aquiiii');

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
                    top: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            mission.title,
                            style: TextStyle(
                                fontSize: 70,
                                fontFamily: 'Amatic SC',
                                color: Colors.white,
                                letterSpacing: 4),
                          )
                        ],
                      ),
                    )),
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
                                    mission
                                        .content.questions[nQuestion].question,
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
            title: new Text("Resultado", style: new TextStyle(
              color: parseColor('#320a5c'),
              fontSize: 50,               
              fontFamily: 'Amatic SC',
              letterSpacing: 4),
            
              ),
        content: new Container( 
          child: new Text("${mission.content.result} %\n Esta é a tua tentativa número ${mission.counter} \n Queres repetir? ", style: new TextStyle(
          color: Colors.black,
          fontSize: 30,               
          fontFamily: 'Amatic SC',
          letterSpacing: 4,),
          ),
          ),
          actions: <Widget>[
            new MaterialButton(
              onPressed: (){
                _loadButton();
              },
              color: Colors.red,
              child: new Text('Sair', style: new TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: 'Amatic SC',
                letterSpacing: 4,
              ),
              ),
              ),
              new MaterialButton(
                onPressed: (){
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return new QuizScreenTabletPortrait(this.mission);
                    }));
                  });  
              },
              color: Colors.green,
              child: new Text("Repetir", style: new TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: 'Amatic SC',
                letterSpacing: 4,
              )),)
          ],
          );
        }
    );
  }

 

  void _loadButton() {
      Timer(Duration(milliseconds: 3000), () {
        updateMissionDoneInFirestore(mission);
        updateMissionCounterInFirestore(mission);
        updateMissionQuizResultInFirestore(mission);
        Navigator.push(context, MaterialPageRoute( builder: (context){
                      return new AllMissionsScreen();
        }),);
      });
  }

  List<Widget> _listAnswers() {
    List<Widget> lines = [];
    List<Widget> buttons = [];
    for (int n = 0; n < 4; n++) {
      Widget button = new MaterialButton(
        height: 50,
        minWidth: 100,
        color: parseColor('#320a5c'),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)),
        onPressed: () {
          setState(() {
            if (allAnswers[n] ==
                mission.content.questions[nQuestion].correctAnswer) {
              score++;
            }
            if (nQuestion == mission.content.questions.length - 1) {
              print('ultima');
              score = ((score * 100) / mission.content.questions.length).round();
              mission.content.result=score;
              mission.counter++;
              mission.done=true;
              print(score);
              createDialog(context);
            } else {
              nQuestion++;
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
}
