import 'package:flutter/material.dart';
import 'historia.dart';
import 'historia_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoriaDetails extends StatelessWidget {
  String id = "";
  HistoriaDetails({this.id});
  Historia historia = Historia();
  bool flag = false;

  @override
  Widget build(context) {
    return FutureBuilder<void>(
        future: getHistoria(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError)
                return new Text("Erro");
              else
                return HistoriaTile(historia: historia);
              break;
            default:
              return Container();
          }
        });
  }

  Future<void> getHistoria() async {
    DocumentReference documentReference =
        Firestore.instance.collection("historia").document(id);
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        historia = Historia(
            id: datasnapshot.data['id'].toString(),
            titulo: datasnapshot.data['titulo'].toString(),
            capitulos: datasnapshot.data['capitulos'],
            capa: datasnapshot.data['capa'].toString());
        flag = true;
      } else {
        print("No such historia");
      }
    });
  }
}
