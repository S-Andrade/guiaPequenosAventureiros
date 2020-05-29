import 'package:app_criancas/models/mission.dart';
import 'package:app_criancas/notifier/missions_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../auth.dart';
import 'questionario_page_tablet.dart';

class QuestionarioScreen extends StatefulWidget {
  final Mission mission;
  QuestionarioScreen(this.mission);
  @override
  _QuestionarioScreenState createState() => _QuestionarioScreenState(mission);
}

class _QuestionarioScreenState extends State<QuestionarioScreen> {
  Mission mission;
  _QuestionarioScreenState(this.mission);

  String _userID = "";

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
            if (a["counter"] > 0) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return new AlertDialog(
                        content: new Text('O Questionário já foi preenchido'));
                  });
              Navigator.pop(context);
            }
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/green_question.png"),
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
            "Questionário",
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
          alignment: Alignment.center,
          children: <Widget>[
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
            Positioned(
                child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      mission.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 36,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0, right: 40, top: 0, bottom: 20),
                    child: Flexible(
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: SizedBox(
                      width: double.infinity,
                      height: 65,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return QuestionarioPage();
                          }));
                        },
                        color: Color(0xFFF3C463),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        child: Text(
                          "COMEÇAR",
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
            // Bottom clouds
          ],
        ),
      ),
    );
  }
}
