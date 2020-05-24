import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
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
      systemNavigationBarColor: Color(0xFFC499FA),
    ));
    return Scaffold(
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
            Column(children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Expanded(
                  child: ShowHistoriaDetails(idHistoria: aventura.historia)),
            ]),
            CompanheiroAppwide(),
          ],
        ));
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
