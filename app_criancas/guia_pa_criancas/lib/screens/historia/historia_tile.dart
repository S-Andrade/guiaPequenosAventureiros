import 'package:app_criancas/widgets/color_loader.dart';

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
    return FutureBuilder<void>(
        future: loadImage(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (flag) {
            return new Scaffold(
              body: new Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
//                  Image.network(url),
                  Text(historia.titulo),
                  Expanded(
                    child: CapitulosDetails(capitulos: historia.capitulos),
                  ),
                ],
              ),
            );
          } else {
            return ColorLoader();
          }
        });
  }

  Future<void> loadImage() async {
    url = await FirebaseStorage.instance
        .ref()
        .child(historia.capa)
        .getDownloadURL();
    flag = true;
  }
}
