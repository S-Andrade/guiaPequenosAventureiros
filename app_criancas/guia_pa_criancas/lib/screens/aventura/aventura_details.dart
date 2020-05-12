import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:google_fonts/google_fonts.dart';

import 'aventura.dart';
import 'package:flutter/material.dart';
import '../historia/historia_details.dart';

class AventuraDetails extends StatelessWidget {
  final Aventura aventura;
  AventuraDetails({this.aventura});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,

            title: Center(
              child: Text(
                aventura.nome,
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      color: Color(0xFF30246A)),
                ),
              ),
            )),
        body: Stack(children: <Widget>[
          ShowHistoriaDetails(idHistoria: aventura.historia),
          CompanheiroAppwide(),
        ]));
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
