import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:app_criancas/services/missions_api.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import '../../bottom_navigation_bar.dart';
import 'aventura.dart';
import 'package:flutter/material.dart';
import '../historia/historia_details.dart';

class AventuraDetails extends StatelessWidget {
  final Aventura aventura;
  AventuraDetails({this.aventura});

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  List<String> frases = ["Boa escolha!","Das minhas favoritas!"];

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
//      systemNavigationBarColor: Color(0xFFBBA9F9),
    ));
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/background_sky.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          )),
      child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          bottomNavigationBar: BottomBar(1, aventura),
          appBar: AppBar(
              iconTheme: IconThemeData(
                color: Color(0xFF30246A), //change your color here
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                aventura.nome,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Color(0xFF30246A)),
                ),
              )),
          body: Stack(
            children: <Widget>[
              Positioned(
                  child: Align(
                      alignment: Alignment.center,
                      child: FractionallySizedBox(
                          widthFactor: screenWidth > 800 ? 0.8 : 0.9,
                          child: ShowHistoriaDetails(
                              idHistoria: aventura.historia)))),
              Positioned(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: 0.25,
                    child: Container(
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
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    widthFactor: screenWidth > 800 ? 0.75 : 0.9,
                    heightFactor: screenHeight < 1000 ? 0.13 : 0.18,
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
                              padding:
                                  const EdgeInsets.only(left: 60.0, right: 100),
                              child: Text(
                                    frases[
                                        math.Random().nextInt(frases.length)] +
                                    "\nEm que capítulo iamos?",
                                textAlign: TextAlign.right,
                                style: GoogleFonts.pangolin(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: screenHeight < 1000 ? 18 : 28,
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
                        child: CompanheiroAppwide())),
              ),
            ],
          )),
    );
  }
}

class ShowHistoriaDetails extends StatelessWidget {
  final String idHistoria;
  ShowHistoriaDetails({this.idHistoria});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: HistoriaDetails(id: idHistoria));
  }
}
