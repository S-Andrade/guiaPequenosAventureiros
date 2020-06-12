import 'package:google_fonts/google_fonts.dart';

import 'historia.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../capitulo/capitulos_details.dart';

class HistoriaTile extends StatelessWidget {
  final Historia historia;
  HistoriaTile({this.historia});
  String url = "";
  bool flag = false;

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  @override
  Widget build(BuildContext context) {

    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    /*return FutureBuilder<void>(
        future: loadImage(),
        builder: (context, AsyncSnapshot<void> snapshot) {
         switch (snapshot.connectionState) {
           case ConnectionState.done:
           if(snapshot.hasError)
           return new Text("Erro");
           else */
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight > 1000 ? screenHeight/6 : 110),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//                  Image.network(url),
//                  Text(historia.titulo),
//                  Text('Capítulos'),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Toca e escolhe o capítulo:",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Color(0xFF30246A)),
              ),
            ),
          ),
          Expanded(
            child: CapitulosDetails(capitulos: historia.capitulos),
          ),
        ],
      ),
    );

    /* break;
            default:
            return Container();
  }*/
  }

  /*Future<void> loadImage() async {
    url = await FirebaseStorage.instance
        .ref()
        .child(historia.capa)
        .getDownloadURL();
    flag = true;
  }*/

}
