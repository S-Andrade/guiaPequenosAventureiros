import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../aventura/aventura.dart';
import 'capitulo_tile.dart';
import '../historia/historia.dart';

class CapituloList extends StatefulWidget {

  Aventura aventura;
  CapituloList({this.aventura});
  
  @override
  _CapituloList createState() => _CapituloList(aventura: aventura);
}

class _CapituloList extends State<CapituloList> {

  Aventura aventura;
  _CapituloList({this.aventura});
  
  List capitulos;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
            future: getHistoria(),
            builder: (context, AsyncSnapshot<void> snapshot) {
              return ListView.builder(
                itemCount: capitulos.length,
                itemBuilder: (context,index) {
                  print("aqui");
                  return CapituloTile(capituloId: capitulos[index],aventuraId:aventura.id);
                }
              );
            }
      ); 
  }

  Future<void> getHistoria() async{
     Historia historia;
     DocumentReference documentReference = Firestore.instance.collection("historia").document(aventura.historia); 
      await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        historia = Historia(
          id: datasnapshot.data['id'].toString() ?? '',
          titulo: datasnapshot.data['titulo'].toString() ?? '',
          capitulos: datasnapshot.data['capitulos'] ?? [],
          capa: datasnapshot.data['capa'] ?? '',
        );
      }
      else{
        print("No such historia");
      }
    });

    capitulos = historia.capitulos;

  }
}