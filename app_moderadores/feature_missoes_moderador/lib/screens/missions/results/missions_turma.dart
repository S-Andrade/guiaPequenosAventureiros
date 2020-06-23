import 'package:feature_missoes_moderador/models/mission.dart';
import 'package:feature_missoes_moderador/screens/missions/results/list_normal.dart';
import 'package:feature_missoes_moderador/screens/missions/results/list_quiz.dart';
import 'package:feature_missoes_moderador/screens/missions/results/list_upload.dart';
import 'package:feature_missoes_moderador/screens/missions/results/list_questionario.dart';
import 'package:feature_missoes_moderador/screens/turma/turma.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';

class ResultsTurmaByMission extends StatelessWidget {
  List<Mission> missions;
  List<String> alunos;
  Turma turma;

  ResultsTurmaByMission({this.missions, this.alunos, this.turma});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Container(
          child: Row(children: [
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width / 1.8,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                          Padding(
                            padding: const EdgeInsets.only(right:300.0,top:50),
                            child: FlatButton(
                              color:parseColor("F4F19C"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Voltar atrás",
                                style: TextStyle(
                                    color: Colors.black,
                                   
                                    fontFamily: 'Monteserrat',
                                    letterSpacing: 2,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 30),
                      child: Text(
                        "Resultados gerais da turma " +
                            turma.nome +
                            " em cada missão: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            fontFamily: 'Amatic SC',
                            letterSpacing: 3),
                      ),
                    ),
                    Text(
                      "( Selecione para ver ) ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Monteserrat',
                          letterSpacing: 2),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 300,
                width: 1000,
                child: Row(children: [
                  Expanded(
                    child: GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio:
                            MediaQuery.of(context).size.height / 60,
                        children: List.generate(missions.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              if (missions[index].type == 'Video' ||
                                  missions[index].type == 'Image' ||
                                  missions[index].type == 'Text' ||
                                  missions[index].type == 'Audio' ||
                                  missions[index].type == 'Activity') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ResultsByMissionNormalForTurma(
                                                mission: this.missions[index],
                                                alunos: this.alunos,
                                                turma: this.turma)));
                              } else if (missions[index].type ==
                                      'UploadImage' ||
                                  missions[index].type == 'UploadVideo') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ResultsByMissionUploadForTurma(
                                                mission: this.missions[index],
                                                alunos: this.alunos,
                                                turma: this.turma)));
                              } else if (missions[index].type == 'Quiz') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ResultsByMissionQuizForTurma(
                                                mission: this.missions[index],
                                                alunos: this.alunos,
                                                turma: this.turma)));
                              } else if (missions[index].type ==
                                  'Questionario') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ResultsByMissionQuestionarioForTurma(
                                                mission: this.missions[index],
                                                alunos: this.alunos,
                                                turma: this.turma)));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: Center(
                                  child: Text(
                                    missions[index].title,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Monteserrat',
                                        letterSpacing: 2,
                                        fontSize: 15),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xff72d8bf)
                                            .withOpacity(0.7),
                                        blurRadius:
                                            5.0, // has the effect of softening the shadow
                                        spreadRadius:
                                            2.0, // has the effect of extending the shadow
                                        offset: Offset(
                                          0.0, // horizontal
                                          2.5, // vertical
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          );
                        })),
                  ),
                ]),
              ),
            ),
          ]),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2.3,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("assets/images/32.png"),
              fit: BoxFit.contain,
            ),
          ),
        )
      ])),
    );
  }
}
