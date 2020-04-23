import 'package:flutter/material.dart';
import 'escola_details.dart';
import 'escola.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EscolaTile extends StatelessWidget {

  final String escola;
  EscolaTile({ this.escola });

  Escola escolafinal;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
            future: getEscola(),
            builder: (context, AsyncSnapshot<void> snapshot) {
              return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EscolaDetails(escola: escolafinal)));
                    } ,
                    child:Card(
                      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                      
                      child: ListTile(
                        title: Text(escolafinal.nome),
                      ),
                    ),
                  ),
                );
            }
    );
  }

  Future<void> getEscola() async {
    DocumentReference documentReference = Firestore.instance.collection("escola").document(escola); 
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        escolafinal = Escola(
          id: datasnapshot.data['id'].toString() ?? '',
          nome: datasnapshot.data['nome'].toString() ?? '',
          turmas: datasnapshot.data['turmas'] ?? []
        );
      }
      else{
        print("No such historia");
      }
    });
  }

}