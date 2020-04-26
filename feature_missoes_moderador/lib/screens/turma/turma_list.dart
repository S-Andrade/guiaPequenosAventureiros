import 'package:flutter/material.dart';
import 'turma_tile.dart';

class TurmaList extends StatefulWidget {

  List turmas;
  TurmaList({this.turmas});

  @override
  _TurmaList createState() => _TurmaList(turmas: turmas);
}

class _TurmaList extends State<TurmaList> {

  List turmas;
  _TurmaList({this.turmas});

  @override
  Widget build(BuildContext context) {
        return  ListView.builder(
                itemCount: turmas.length,
                itemBuilder: (context,index) {
                  return TurmaTile(turma: turmas[index]);
                }
              );
  }
}