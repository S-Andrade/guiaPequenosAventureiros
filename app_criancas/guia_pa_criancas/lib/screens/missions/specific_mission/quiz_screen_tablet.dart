import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/mission.dart';
import 'quiz_page_tablet.dart';
import '../../../widgets/color_parser.dart';

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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/purple3.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color(0xFF30246A), //change your color here
          ),
          title: Text(
            "Quiz",
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Color(0xFF30246A)),
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
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40.0),
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
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: SizedBox(
                      width: double.infinity,
                      height: 65,
                      child: FlatButton(

                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return QuizPage();
                          }));
                        },
                        color: parseColor("#320a5c"),
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
          ],
        ),
      ),
    );
  }
}
