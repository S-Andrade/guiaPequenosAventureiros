import 'package:flutter/material.dart';
import 'capitulo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'capitulo_details.dart';


class CapituloTile extends StatelessWidget {

  String capituloId;
  String aventuraId;

  CapituloTile({ this.capituloId,this.aventuraId });

  Capitulo capitulo;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      
            future: getCapitulo(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
              case ConnectionState.done:
                return  Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CapituloDetails(capitulo: capitulo,aventuraId:aventuraId)));
                    } ,
                    child:Card(
                      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                      
                      child: ListTile(
                        title: Text(capitulo.id),
                      ),
                    ),
                  ),
                ); 
                break;
              default:
              print("erro");
                return Container();
              }
            });    
  }


  Future<void> getCapitulo() async{
     DocumentReference documentReference = Firestore.instance.collection("capitulo").document(capituloId); 
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