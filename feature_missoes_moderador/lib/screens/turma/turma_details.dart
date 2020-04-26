import 'package:flutter/material.dart';
import 'turma.dart';

class TurmaDetails extends StatefulWidget {

  Turma turma;
  TurmaDetails({this.turma});

  @override
  _TurmaDetails createState() => _TurmaDetails(turma: turma);
}

class _TurmaDetails extends State<TurmaDetails> {

  Turma turma;
  _TurmaDetails({this.turma});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(child:Text(turma.id)),
    );
  }
}