import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_app_criancas/models/mission.dart';
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

  _QuizScreenTabletPortraitState(this.mission);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        height: 530,
                        width: 630,
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
                                    mission.content.questions[nQuestion].question,
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
                  top: 920,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //button 1
                      new SizedBox(height: 100, width: 100,),
                      RaisedButton(
                        color: parseColor('#320a5c'),
                        onPressed: () {
                          setState(() {
                            if (nQuestion ==
                                mission.content.questions.length - 1) {
                                  print('ultima');
                            } else {
                              nQuestion++;
                            }
                          });
                        },
                        child: new Text(
                            mission
                                .content.questions[nQuestion].wrongAnswers[0],
                            style:
                                TextStyle(fontSize: 32, color: Colors.white)),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget setButton() {
    if (mission.done == false) {
      if (_state == 0 && nQuestion == mission.content.questions.length - 1) {
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
    if (mission.done == true) {
      print('back');
      Navigator.pop(context);
    } else {
      Timer(Duration(milliseconds: 3000), () {
        updateMissionDoneInFirestore(mission);
        Navigator.pop(context);
      });
    }
  }
}
