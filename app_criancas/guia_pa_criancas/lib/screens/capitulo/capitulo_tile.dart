import 'package:app_criancas/screens/capitulo/capitulo.dart';
import 'package:google_fonts/google_fonts.dart';
import '../missions/all_missions/all_missions_screen.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class CapituloTile extends StatelessWidget {
  final Capitulo capitulo;
  CapituloTile({this.capitulo});

  Widget build(BuildContext context) {
    if (!capitulo.bloqueado) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AllMissionsScreen(capitulo.missoes)));
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                  color: Colors.white,
//                color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.8),
                  image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(0.8),
                        BlendMode.overlay),
                    image: AssetImage('assets/images/blue.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Expanded(
                  child: Center(
                child: Text(capitulo.nome.toString(),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 70,
                          color: Colors.white.withOpacity(0.5)),
                    )),
              ))),
        ),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/yellow2.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Expanded(
                  child: Center(
                    child: Icon(
                      Icons.lock,
                      color: Colors.white.withOpacity(0.5),
                      size: 70.0,
                    ),
//                child: Text(capitulo.id,
//                    textAlign: TextAlign.right,
//                    style: GoogleFonts.quicksand(
//                      textStyle: TextStyle(
//                          fontWeight: FontWeight.w900,
//                          fontSize: 70,
//                          color: Colors.white.withOpacity(0.5)),
//                    )),
              ))));
    }
  }
}