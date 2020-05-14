import 'package:flutter/material.dart';
import 'capitulo.dart';
import '../aventura/aventura.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'capitulo_details.dart';
import '../../widgets/color_loader.dart';


class CapituloTile extends StatelessWidget {

String capituloId;
  Aventura aventura;

  CapituloTile({ this.capituloId,this.aventura });

  Capitulo capitulo;
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
            future: getCapitulo(),
            builder: (context, AsyncSnapshot<void> snapshot) {
              if(!flag){
                          return ColorLoader();
              }else{

              return  Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CapituloDetails(capitulo: capitulo,aventura:aventura)));
                  } ,
                  child:Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    
                    child: ListTile(
                      title: Text(capitulo.id),
                    ),
                  ),
                ),
              );
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
      flag = true;
      }
      else{
        print("No such capitulo");
      }
    });
  }


}