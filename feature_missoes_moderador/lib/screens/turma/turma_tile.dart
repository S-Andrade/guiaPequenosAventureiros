import 'package:flutter/material.dart';
import 'package:feature_missoes_moderador/services/database.dart';
import 'turma_details.dart';
import 'turma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../escola/escola.dart';
import '../escola/escola_details.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../widgets/color_loader.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';






class TurmaTile extends StatelessWidget {

  String turma;
  Escola escola;
  TurmaTile({ this.turma, this.escola });

  Turma turmafinal;
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
            future: getTurma(),
            builder: (context, AsyncSnapshot<void> snapshot) {

              if(!flag){
                          return ColorLoader();
              }else{
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
                        trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){deleteTurma(context);}),
                      ),
                    ),
                  ),
                );
              }
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
        flag=true;
      }
      else{
        print("No such Turma");
      }
    });
  }

  Future<void> deleteTurma(BuildContext context) async  {


   
   DocumentReference documentReference = Firestore.instance.collection("turma").document(turmafinal.id);
    await documentReference.delete();


    List turmas = escola.turmas;
    turmas.remove(turmafinal.id);
    DatabaseService().updateEscolaData(escola.id, escola.nome, turmas);

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(turmafinal.file);

    var url =  await firebaseStorageRef.getDownloadURL();
    
    await deleteUser(url);

   
    
    for(String id_aluno in turmafinal.alunos){
      DocumentReference documentReference = Firestore.instance.collection("aluno").document(id_aluno);
      await documentReference.delete();
    }

     await firebaseStorageRef.delete();

    Navigator.push(context, MaterialPageRoute(builder: (context) => EscolaDetails(escola: escola)));
    print(turmafinal.alunos);

  }
 

  Future<void> deleteUser(String url) async{
    new HttpClient().getUrl(Uri.parse(url))
    .then((HttpClientRequest request) => request.close())
    .then((HttpClientResponse response) {
      
      response.transform(new Utf8Decoder()).listen((contents) async{
        List lista = contents.split("\n");
        final FirebaseAuth auth = FirebaseAuth.instance;
        for (String crianca in lista){
          if(crianca != ""){
            List a = crianca.split(" -> ");
            print(a);
             AuthResult result = await auth.signInWithEmailAndPassword(email: a[0].trim(), password: a[1].trim());
              FirebaseUser user = await auth.currentUser();
              user.delete();
          }
        }
        
      });
    });
  }
}