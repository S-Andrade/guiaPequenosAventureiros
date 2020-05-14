import 'package:flutter/material.dart';
import 'package:feature_missoes_moderador/screens/aventura/aventura_details.dart';
import 'escola_details.dart';
import 'escola.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../aventura/aventura.dart';
import 'package:feature_missoes_moderador/services/database.dart';
import '../turma/turma.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../widgets/color_loader.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';





class EscolaTile extends StatelessWidget {

  String escola;
  Aventura aventura;
  EscolaTile({ this.escola, this.aventura });

  Escola escolafinal;
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
            future: getEscola(),
            builder: (context, AsyncSnapshot<void> snapshot) {

              if(!flag){
                          return ColorLoader();
              }else{
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
                        trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){deleteEscola(context);}),
                      ),
                    ),
                  ),
                );
              }
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
        flag = true;
      }
      else{
        print("No such escola");
      }
    });
  }

  Future<void> deleteEscola(BuildContext context) async  {
    DocumentReference documentReference = Firestore.instance.collection("escola").document(escolafinal.id);
    await documentReference.delete();

    List escolas = aventura.escolas;
    escolas.remove(escolafinal.id);
    DatabaseService().updateAventuraData(aventura.id, aventura.historia, aventura.data, aventura.local, escolas, aventura.moderador, aventura.nome, aventura.capa);

    for(String id_turma in  escolafinal.turmas){
      Turma turma;
      DocumentReference documentReference = Firestore.instance.collection("turma").document(id_turma);
      await documentReference.get().then((datasnapshot) async {
        if (datasnapshot.exists) {
          turma = Turma(
            id: datasnapshot.data['id'].toString() ?? '',
            nome:datasnapshot.data['nome'].toString() ?? '',
            professor: datasnapshot.data['professor'].toString() ?? '',
            nAlunos: datasnapshot.data['nAlunos'] ?? 0,
            alunos: datasnapshot.data['alunos'] ?? [],
            file: datasnapshot.data['file'].toString() ?? '',
          );
        }
        else{
          print("No such Turma");
        }
      });
      await documentReference.delete();
      
       final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(turma.file);

            var url =  await firebaseStorageRef.getDownloadURL();

        
         await deleteUser(url);

      

      for(String id_aluno in turma.alunos){
        DocumentReference documentReference = Firestore.instance.collection("aluno").document(id_aluno);
        await documentReference.delete();
      }

      await firebaseStorageRef.delete();

    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => AventuraDetails(aventura:aventura)));
    

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
          
             AuthResult result = await auth.signInWithEmailAndPassword(email: a[0].trim(), password: a[1].trim());
              FirebaseUser user = await auth.currentUser();
              user.delete();
          }
        }
        
      });
    });
  }
}