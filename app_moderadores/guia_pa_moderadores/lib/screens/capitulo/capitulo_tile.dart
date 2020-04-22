import 'package:flutter/material.dart';
import 'capitulo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'capitulo_details.dart';


class CapituloTile extends StatelessWidget {

  String capitulo_id;
  CapituloTile({ this.capitulo_id });

  Capitulo capitulo;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
            future: getCapitulo(),
            builder: (context, AsyncSnapshot<void> snapshot) {
              return  Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CapituloDetails(capitulo: capitulo)));
                  } ,
                  child:Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    
                    child: ListTile(
                      title: Text(capitulo.id),
                    ),
                  ),
                ),
              ); 
            });    
  }


  Future<void> getCapitulo() async{
     DocumentReference documentReference = Firestore.instance.collection("capitulo").document(capitulo_id); 
      await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        capitulo = Capitulo(
        id: datasnapshot.data['id'] ?? '',
        bloqueado: datasnapshot.data['bloqueado'] ?? null,
        missoes: datasnapshot.data['missoes'] ?? []
      );
      }
      else{
        print("No such historia");
      }
    });
  }


}