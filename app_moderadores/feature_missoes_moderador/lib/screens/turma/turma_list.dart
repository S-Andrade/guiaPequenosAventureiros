import 'package:flutter/material.dart';
import 'turma_tile.dart';
import '../escola/escola.dart';

class TurmaList extends StatefulWidget {

  Escola escola;
  TurmaList({this.escola});

  @override
  _TurmaList createState() => _TurmaList(escola: escola);
}

class _TurmaList extends State<TurmaList> {

  
  Escola escola;
  _TurmaList({this.escola});

  @override
  Widget build(BuildContext context) {
        return  ListView.builder(
                itemCount: escola.turmas.length,
                itemBuilder: (context,index) {
                  return TurmaTile(turma: escola.turmas[index], escola: escola);
                }
              );
  }
}