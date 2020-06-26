import 'package:app_criancas/screens/capitulo/capitulo.dart';
import 'package:app_criancas/widgets/color_loader_5.dart';
import 'package:google_fonts/google_fonts.dart';
import '../missions/all_missions/all_missions_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CapituloTile extends StatefulWidget {
  final Capitulo capitulo;
  CapituloTile({this.capitulo});

  @override
  _CapituloTile createState() => _CapituloTile(capitulo: capitulo);
}

class _CapituloTile extends State<CapituloTile> {
  final Capitulo capitulo;
  _CapituloTile({this.capitulo});

  bool bloqueado;
  bool flag = false;

  List<Color> colors = [
    Color(0xFFFF555E).withOpacity(0.9),
    Color(0xFFFF7E47).withOpacity(0.9),
    Color(0xFFFFE013).withOpacity(0.9),
    Color(0xFF5CE5D3).withOpacity(0.9),
    Color(0xFF9B6EF3),
    Color(0xFF5842B3),
    Color(0xFF3DBDFF),
    Color(0xFF124CA2),
    Color(0xFFF564A9),
  ];

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    return FutureBuilder<void>(
        future: getBloqueado(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (!flag) {
            return ColorLoader5();
          } else {
            if (bloqueado) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AllMissionsScreen(capitulo.missoes)));
                },
                child: Padding(
                  padding: EdgeInsets.all(screenWidth > 800 ? 12 : 6.0),
                  child: Container(
                      clipBehavior: Clip.none,
                      decoration: BoxDecoration(
                          color: colors[capitulo.nome.hashCode % colors.length],
//                        color: colors[math.Random().nextInt(colors.length)],
//                        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15)),
                      child: Expanded(
                          child: Center(
                        child: Text(capitulo.nome.toString(),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 70,
                                  color: Colors.white.withOpacity(0.6)),
                            )),
                      ))),
                ),
              );
            } else {
              return Padding(
                  padding: EdgeInsets.all(screenWidth > 800 ? 12 : 6.0),
                  child: Container(
                      clipBehavior: Clip.none,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.7),
//                          image: DecorationImage(
//                            image: AssetImage('assets/images/yellow2.png'),
//                            fit: BoxFit.cover,
//                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: Expanded(
                          child: Center(
                        child: Icon(
                          Icons.lock,
                          color: Colors.white.withOpacity(0.8),
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
        });
  }

  getBloqueado() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String turma = prefs.getString("turma");
    Map all = capitulo.disponibilidade;
    if (all.containsKey(turma)) {
      bloqueado = all[turma];
    }
    print(capitulo.id);
    print(bloqueado);
    flag = true;
  }
}
