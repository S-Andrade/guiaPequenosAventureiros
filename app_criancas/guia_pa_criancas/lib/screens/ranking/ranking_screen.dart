import 'package:app_criancas/services/recompensas_api.dart';
import 'package:app_criancas/widgets/color_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_criancas/screens/turma/turma.dart';

import '../../auth.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Turma> turmas = [];
  String userId = "";
  FirebaseUser user;
  @override
  initState() {
    getAll();
    super.initState();
  }

  Future<void> _refreshList() async {
    getAll();
    print('refresh');
  }

  @override
  Widget build(BuildContext context) {
    if (turmas.isEmpty) {
      return ColorLoader();
    } else {
      return Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(
            "Vê em que lugar está a tua turma!",
          ),
        ),
        body: Stack(
          children: <Widget>[
            RefreshIndicator(
                onRefresh: _refreshList,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (BuildContext context, int index) {
                          print(turmas[index].pontuacao.toString());
                          if(turmas[index].alunos.contains(userId)){
                            return Row(
                            children: <Widget>[
                              Text('A MINHA TURMA -->'),
                              Text(turmas[index].pontuacao.toString())
                            ],
                          );
                          }else{
                          return Row(
                            children: <Widget>[
                              Text(turmas[index].pontuacao.toString())
                            ],
                          );}
                        },
                        itemCount: turmas.length,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      );
    }
  }

  getAll() async {
    print('entreiiiiii');
    user  = await Auth().getUser();
    List<Turma> temp = await getAllTurmasPontuacao();
    setState(() {
      turmas = temp;
      userId = user.email;
      turmas.sort((a,b)=> b.pontuacao.compareTo(a.pontuacao));
      print('aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
    });
  }
}
