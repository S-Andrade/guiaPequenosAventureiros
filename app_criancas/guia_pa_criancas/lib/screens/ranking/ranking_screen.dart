import 'package:app_criancas/notifier/missions_notifier.dart';
import 'package:app_criancas/screens/aventura/aventura.dart';
import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:app_criancas/services/missions_api.dart';
import 'package:app_criancas/services/recompensas_api.dart';
import 'package:app_criancas/widgets/color_loader.dart';
import 'package:app_criancas/widgets/color_loader_5.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:app_criancas/screens/turma/turma.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../auth.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  List<Turma> turmas = [];
  String userId = "";
  FirebaseUser user;
  Aventura aventura;
  @override
  initState() {
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context, listen: false);
    getAll();
    super.initState();
  }

  Future<void> _refreshList() async {
    getAll();
    print('refresh');
  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

     MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
     aventura = missionsNotifier.currentAventura;
    if (turmas.isEmpty) {
      return ColorLoader5();
    } else {
      return Container(
//        decoration: BoxDecoration(
//            gradient: LinearGradient(
//                begin: Alignment.bottomCenter,
//                end: Alignment.topCenter,
//                colors: [
//              Color(0xFFFFAF02),
//              Color(0xFFFFCE00),
//            ])),
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/images/stars.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Color(0xFFFFCB39), //change your color here
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              "Ranking das turmas",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Color(0xFFFFCB39)),
              ),
            ),
          ),
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    heightFactor: 0.6,
                    child: RefreshIndicator(
                        onRefresh: _refreshList,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical:60),
                                itemBuilder: (BuildContext context, int index) {
                                  print(turmas[index].pontuacao.toString());
                                  if (turmas[index].alunos.contains(userId)) {
                                    return FractionallySizedBox(
                                      widthFactor: 0.7,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Color(0xFFFF5757),
                                                    Color(0xFFFF5757),
                                                  ])),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('A tua turma',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.quicksand(
                                                    textStyle: TextStyle(
                                                        fontWeight: FontWeight.normal,
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Text(
                                                  turmas[index].pontuacao.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.quicksand(
                                                    textStyle: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 30,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return FractionallySizedBox(
                                      widthFactor: 0.5,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Color(0xFF01BBB6),
                                                    Color(0xFF01BBB6),
                                                  ])),
//                              colors: [Color(0xFF00A8FF),Color(0xFF00A8FF),])),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              turmas[index].pontuacao.toString(),
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
                                      ),
                                    );
                                  }
                                },
                                itemCount: turmas.length,
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    widthFactor: screenHeight < 700 ? 0.8 : screenWidth > 800 ? 0.77 : 0.9,
                    heightFactor: screenHeight < 700 ? 0.14 : screenHeight < 1000 ? 0.14 : 0.20,
                    child: Stack(
                      children: [
                        FlareActor(
                          "assets/animation/dialog.flr",
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.center,
//                        controller: _controller,
                          artboard: 'Artboard',
                          animation: 'open_dialog',
                        ),
                        Center(
                          child: DelayedDisplay(
                            delay: Duration(seconds: 1),
                            fadingDuration: const Duration(milliseconds: 800),
                            slidingBeginOffset: const Offset(0, 0.0),
                            child: Padding(
                              padding: EdgeInsets.only(left: screenHeight > 1000 ? 40 : screenHeight < 700 ? 16 : 20.0, right: screenHeight > 1000 ? 130 : screenHeight < 700 ? 60 : 100),
                              child: Text(
                                "Bom trabalho de equipa!",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.pangolin(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: screenHeight < 700 ? 16 : screenHeight < 1000 ? 20 : 32,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Align(
                    alignment: Alignment.topRight,
                    child: DelayedDisplay(
//                          delay: Duration(seconds: 1),
                        fadingDuration: const Duration(milliseconds: 800),
//                          slidingBeginOffset: const Offset(-0.5, 0.0),
                        child: CompanheiroAppwide()
                    )
                ),
              ),
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

  getAll() async {
    print('entreiiiiii');
    user = await Auth().getUser();
    List<Turma> temp = await getAllTurmasPontuacao(aventura);
    setState(() {
      turmas = temp;
      userId = user.email;
      turmas.sort((a, b) => b.pontuacao.compareTo(a.pontuacao));
      print('aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
    });
  }
}
