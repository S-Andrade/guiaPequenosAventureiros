import 'historia.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../capitulo/capitulos_details.dart';

class HistoriaTile extends StatelessWidget {
  final Historia historia;
  HistoriaTile({this.historia});
  String url = "";
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    /*return FutureBuilder<void>(
        future: loadImage(),
        builder: (context, AsyncSnapshot<void> snapshot) {
         switch (snapshot.connectionState) {
           case ConnectionState.done:
           if(snapshot.hasError)
           return new Text("Erro");
           else */
    return Column(
//                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
//                  Image.network(url),
//                  Text(historia.titulo),
//                  Text('Capítulos'),
        Expanded(
          child: CapitulosDetails(capitulos: historia.capitulos),
        ),
      ],
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
