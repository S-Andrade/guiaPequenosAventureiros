import 'package:flutter/material.dart';
import 'package:feature_missoes_moderador/screens/escola/escola.dart';
import '../turma/turma_list.dart';
import '../turma/turma_create.dart';


class EscolaDetails extends StatefulWidget {

  Escola escola;
  EscolaDetails({this.escola});
  @override
  _EscolaDetails createState() => _EscolaDetails(escola:escola);
}

class _EscolaDetails extends State<EscolaDetails> {

  Escola escola;
  _EscolaDetails({this.escola});

  @override
  Widget build(BuildContext context) {
    
     return  new Scaffold(
            body: TurmaList(turmas: escola.turmas),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TurmaCreate(escola: escola)));
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            ),
          );
  }
}