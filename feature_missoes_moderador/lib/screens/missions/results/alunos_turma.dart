import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/turma/turma.dart';
import 'package:flutter/material.dart';


class ResultsTurmaByAlunos extends StatelessWidget {
  
 
  List<String> alunos;

  ResultsTurmaByAlunos({this.alunos});

  
  @override
  Widget build(BuildContext context) {



   
      return Scaffold(
        
       
        body: Container(child:Text(alunos.toList().toString())));
  }
            
}