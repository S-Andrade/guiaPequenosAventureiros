import 'package:app_criancas/auth.dart';
import 'package:app_criancas/screens/colecionaveis/caderneta_turma.dart';
import 'package:app_criancas/screens/colecionaveis/minha_caderneta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'models/aluno.dart';
import 'screens/turma/turma.dart';

class Perfil extends StatefulWidget {

  FirebaseUser user;
  Perfil({this.user});

  @override
  _Perfil createState() => _Perfil(user: user);
}

class _Perfil extends State<Perfil> {

  FirebaseUser user;
  _Perfil({this.user});

  int pontuacao_aluno;
  int pontuacao_turma;
  String id_turma;
  String aa;


  @override
  void initState() {
    getInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
        return Scaffold(
            appBar: new AppBar(title: new Text("Criar turmas")),
             body: Column(
               children: [
                 Text("Olá, $aa!"),
                 Text(" A tua pontuação é de " + pontuacao_aluno.toString()),
                 Text(" A pontuação da tua turma "+ pontuacao_turma.toString()),
                 RaisedButton(
                    onPressed: () {
                      Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return MinhaCaderneta();
                                }),
                              );
                    },
                    child: const Text('Minha Caderneta', style: TextStyle(fontSize: 20)),
                  ),
                  RaisedButton(
                    onPressed: () {  
                      Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return CadernetaTurma();
                                }),
                              );
                    },
                    child: const Text('Caderneta de turma', style: TextStyle(fontSize: 20)),
                  ),
                  RaisedButton(
                    onPressed: () async{
                      await Auth().logOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return  MyApp();
                        }),
                      );
                    },
                    child: const Text('Logout', style: TextStyle(fontSize: 20)),
                  ),
                
               ]  
             )
        );

  }

  getInfo() async{
    user = await Auth().getUser();
    await getAluno();
    await getTurma();
    print(user.uid);
    print(user.email);
  } 

  getAluno() async {
    DocumentReference documentReference = Firestore.instance.collection("aluno").document(user.email); 
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        setState(() {
          pontuacao_aluno = datasnapshot.data['pontuacao'];
          id_turma = datasnapshot.data['turma'];
          String sexo = datasnapshot.data['generoAluno'];
          if(sexo == "Masculino"){
            aa = "Amigo";
          }
          if(sexo == "Feminino"){
            aa = "Amiga";
          } 
        });
       
      }
      else{
        print("No such Aluno");
      }
    });
  }

  getTurma() async {
    DocumentReference documentReference =
        Firestore.instance.collection("turma").document(id_turma);
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        setState(() {
          pontuacao_turma = datasnapshot.data['pontuacao'];
        });
      } else {
        print("No such Turma");
      }
    });
  }
}
