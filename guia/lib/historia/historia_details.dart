import 'package:flutter/material.dart';
import 'package:guia/historia/historia.dart';
import 'package:guia/historia/historia_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoriaDetails extends StatelessWidget {

  final String id;
  HistoriaDetails({ this.id });
  Historia historia = Historia();


   @override
  Widget build(context) {
    return FutureBuilder<void>(
      future: getHistoria(),
      builder: (context, AsyncSnapshot<void> snapshot) {
        return HistoriaTile(historia: historia);
      }
    );
  }

  Future<void> getHistoria() async {
    DocumentReference documentReference = Firestore.instance.collection("historia").document(id); 
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        historia = Historia(
          id: datasnapshot.data['id'].toString(),
          titulo: datasnapshot.data['titulo'].toString(),
          capitulos: datasnapshot.data['capitulos'],
          capa: datasnapshot.data['capa'].toString()
        );
      }
      else{
        print("No such historia");
      }
    });
  }

}

