import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:app_criancas/services/missions_api.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bottom_navigation_bar.dart';
import 'aventura.dart';
import 'package:flutter/material.dart';
import '../historia/historia_details.dart';

class AventuraDetails extends StatelessWidget {
  final Aventura aventura;
  AventuraDetails({this.aventura});



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
//      systemNavigationBarColor: Color(0xFFBBA9F9),
    ));
    return Container(
    decoration: BoxDecoration(
    color: Colors.white,
    image: DecorationImage(
    image: AssetImage('assets/images/background_app_4.png'),
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
                          widthFactor: 0.8,
                          child: ShowHistoriaDetails(
                              idHistoria: aventura.historia)))),
              Positioned(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: 0.2,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(
                            'assets/images/clouds_bottom_navigation_purple2.png'),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      )),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: FractionallySizedBox(
                    heightFactor: 0.15,
                    widthFactor: 0.8,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black45.withOpacity(0.8),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(5))),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "Boa escolha!",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.pangolin(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Align(
                    alignment: Alignment.topRight, child: CompanheiroAppwide()),
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
    return Scaffold(body: HistoriaDetails(id: idHistoria));
  }
}
