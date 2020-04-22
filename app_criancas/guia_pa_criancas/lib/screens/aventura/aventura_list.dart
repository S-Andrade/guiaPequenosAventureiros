import 'package:flutter/material.dart';
import 'aventura.dart';
import 'package:provider/provider.dart';
import 'aventura_tile.dart';
import '../turma/turma.dart';
import '../../services/database.dart';
import '../escola/escola.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AventuraList extends StatefulWidget {

  final FirebaseUser user;
  AventuraList({this.user});
  
  @override
  _AventuraListState createState() => _AventuraListState(user: user);
}

class _AventuraListState extends State<AventuraList> {

  final FirebaseUser user;
  _AventuraListState({this.user});
  
  List<Aventura> aventura ;
  List<Turma> turma;
  List<Escola> escola;
  List<Aventura> ave = [];
  Turma turmaIn;
  Escola escolaIn;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Turma>>.value(value: DatabaseService().turma),
        StreamProvider<List<Escola>>.value(value: DatabaseService().escola)
      ],
      child: Builder(
        builder: (BuildContext context) {
          return FutureBuilder<void>(
            future: getAventuras(context),
            builder: (context, AsyncSnapshot<void> snapshot) {
              return ListView.builder(
                itemCount: ave.length,
                itemBuilder: (context,index) {
                  return AventuraTile(aventura: ave[index]);
                }
              );
            }
            ); 
          },
      ),
    );
  }

  Future<void> getAventuras(BuildContext context) async{
    //print("aventura");
    //while(aventura != null){
      getAllAventuras(context);
    //}
    //print(aventura);

    //print("turma");
    //while(turma != null){
      getAllTurmas(context);
    //}
    //print(turma);

    //print("escola");
    //while(escola != null){
      getAllEscolas(context);
    //}
    //print(escola);

    await getTurma();

    await getEscola();

    await getAvent();
    
  }
  Future<void> getAllAventuras(BuildContext context) async{aventura = Provider.of<List<Aventura>>(context);}
  Future<void> getAllTurmas(BuildContext context) async{turma = Provider.of<List<Turma>>(context);}
  Future<void> getAllEscolas(BuildContext context) async{escola = Provider.of<List<Escola>>(context);}
  Future<void> getTurma() async{
    if(turma != null){
      for (Turma t in turma){
        //print(t.id);
        //print(t.alunos);
        //print(user.email);
        if(t.alunos.contains(user.email)){
          turmaIn = t;
        }
      }
    }
  }
  Future<void> getEscola() async{
    if(escola != null){
      for (Escola e in escola){
        if(e.turmas.contains(turmaIn.id)){
          escolaIn = e;
        }
      }
    }
  }
  Future<void> getAvent() async{
    ave = [];
    if(aventura != null){
      for (Aventura a in aventura){
        if(a.escolas.contains(escolaIn.id)){
          ave.add(a);
        }
      }
    }
  }
}