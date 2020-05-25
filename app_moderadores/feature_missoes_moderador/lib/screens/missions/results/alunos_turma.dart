
import 'package:feature_missoes_moderador/screens/perfil/perfil_aluno.dart';

import 'package:flutter/material.dart';

class ResultsTurmaByAlunos extends StatelessWidget {
  List<String> alunos;

  ResultsTurmaByAlunos({this.alunos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back11.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: new ListView.separated(
        itemBuilder: (context, int index) {
          return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 30),
              child: 
                Container(
                    height: 90,
                    color: Colors.white,
                  
                         child: Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 30),
                            child: GestureDetector(onTap : () { Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PerfilAlunoScreen(alunoId:this.alunos[index])));},
                                                          child: Container(
                                height: 150,
                                width: 400,
                                child: Text(
                                  alunos[index],
                                  style: TextStyle(
                                      fontSize: 20,
                                      letterSpacing: 4,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ),
              
                )
             );
        },
        itemCount: alunos.length,
        separatorBuilder: (context, int index) {
          return Divider(height: 30, color: Colors.black12);
        },
      ),
    ));
  }
}
