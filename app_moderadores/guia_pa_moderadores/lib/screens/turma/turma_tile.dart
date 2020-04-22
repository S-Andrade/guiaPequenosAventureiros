import 'package:flutter/material.dart';
import 'turma_details.dart';
import 'turma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TurmaTile extends StatelessWidget {

  String turma;
  TurmaTile({ this.turma });

  Turma turmafinal;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
            future: getTurma(),
            builder: (context, AsyncSnapshot<void> snapshot) {
              return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TurmaDetails(turma: turmafinal)));
                    } ,
                    child:Card(
                      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                      
                      child: ListTile(
                        title: Text(turmafinal.nome),
                        trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){deleteTurma();}),
                      ),
                    ),
                  ),
                );
            }
    );
  }

  Future<void> getTurma() async {
    DocumentReference documentReference = Firestore.instance.collection("turma").document(turma); 
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        turmafinal = Turma(
          id: datasnapshot.data['id'].toString() ?? '',
          nome:datasnapshot.data['nome'].toString() ?? '',
          professor: datasnapshot.data['professor'].toString() ?? '',
          nAlunos: datasnapshot.data['nAlunos'] ?? 0,
          alunos: datasnapshot.data['alunos'] ?? [],
          file: datasnapshot.data['file'].toString() ?? '',
        );
      }
      else{
        print("No such historia");
      }
    });
  }

  Future<void> deleteTurma() async  {
    print(turmafinal.alunos);
  }
 
}