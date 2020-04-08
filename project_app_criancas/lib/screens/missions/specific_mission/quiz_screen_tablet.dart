import 'package:flutter/material.dart';
import 'package:project_app_criancas/models/mission.dart';
import 'package:project_app_criancas/screens/missions/specific_mission/quiz_page_tablet.dart';

class QuizScreenTabletPortrait extends StatefulWidget {
  final Mission mission;

  QuizScreenTabletPortrait(this.mission);

  @override
  _QuizScreenTabletPortraitState createState() =>
      _QuizScreenTabletPortraitState(mission);
}

class _QuizScreenTabletPortraitState extends State<QuizScreenTabletPortrait> {
  Mission mission;
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
                  bottom: 200,
                  child: new MaterialButton(
                    height: 100,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return QuizPage();
                      }));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                    child: new Text("Começar!",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Amatic SC',
                          letterSpacing: 4,
                        )),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
