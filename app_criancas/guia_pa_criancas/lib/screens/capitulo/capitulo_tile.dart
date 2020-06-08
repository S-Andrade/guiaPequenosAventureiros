import 'package:app_criancas/screens/capitulo/capitulo.dart';
import 'package:app_criancas/widgets/color_loader_5.dart';
import 'package:google_fonts/google_fonts.dart';
import '../missions/all_missions/all_missions_screen.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CapituloTile extends StatefulWidget {
  final Capitulo capitulo;
  CapituloTile({this.capitulo});

  @override
  _CapituloTile createState() => _CapituloTile(capitulo: capitulo);
}

class _CapituloTile extends State<CapituloTile>{
  final Capitulo capitulo;
  _CapituloTile({this.capitulo});

  bool bloqueado;
  bool flag = false;


  Widget build(BuildContext context) {
    if(!flag){
      getBloqueado();
      return ColorLoader5();
    }else{
    return FutureBuilder<void>(
            future: getBloqueado(),
            builder: (context, AsyncSnapshot<void> snapshot) {
              if (bloqueado) {
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
            });}

  }

  getBloqueado() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String turma = prefs.getString("turma");
    Map all = capitulo.disponibilidade;
    if(all.containsKey(turma)){
      bloqueado = all[turma];
    }
    print(capitulo.id);
    print(bloqueado);
    flag = true; 
  }

}