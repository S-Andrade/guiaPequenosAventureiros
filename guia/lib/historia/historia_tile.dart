import 'package:guia/historia/historia.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:guia/capitulo/capitulos_details.dart';

class HistoriaTile extends StatelessWidget {

  final Historia historia;
  HistoriaTile({this.historia});
  String url = "";

   @override
    Widget build(BuildContext context) {
      return FutureBuilder<void>(
      future: loadImage(),
      builder: (context, AsyncSnapshot<void> snapshot) {
        return  new Scaffold(
            body: new Column(mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.network(url),
                Text(historia.titulo),
                Expanded(
                  child: 
                    CapitulosDetails(capitulos: historia.capitulos),
                ),
              ],
            ),
          );
      }
    );
  }

  Future<void> loadImage() async {
    url = await FirebaseStorage.instance.ref().child(historia.capa).getDownloadURL();
  }


}