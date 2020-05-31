import 'package:google_fonts/google_fonts.dart';

import '../missions/all_missions/all_missions_screen.dart';
import 'dart:math' as math;
import 'capitulo.dart';
import 'package:flutter/material.dart';

class CapituloTile extends StatelessWidget {
  final Capitulo capitulo;
  CapituloTile({this.capitulo});

  Widget build(BuildContext context) {
    if (!capitulo.bloqueado) {
      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AllMissionsScreen(capitulo.missoes)));
        } ,
        child:Container(
          child: Card(
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),

            child: ListTile(
              title: Text(capitulo.id, style: TextStyle(color: Colors.blue)),
              subtitle: Text(capitulo.bloqueado.toString(),style: TextStyle(color: Colors.blue)),
            ),
          ),
        ),
      );
    }else{
      return  Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          child: Card(
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: ListTile(
              title: Text(capitulo.nome.toString()),
              subtitle: Text(capitulo.bloqueado.toString()),
            ),
          ),
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
