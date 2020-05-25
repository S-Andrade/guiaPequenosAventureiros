import 'package:feature_missoes_moderador/models/mission.dart';
import 'package:feature_missoes_moderador/models/quiz.dart';
import 'package:feature_missoes_moderador/screens/turma/turma.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:flutter/material.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResultsByMissionQuizForTurma extends StatefulWidget {
  Mission mission;
  List<String> alunos;
  Turma turma;

  ResultsByMissionQuizForTurma({this.mission, this.alunos, this.turma});

  @override
  _ResultsByMissionQuizForTurmaState createState() =>
      _ResultsByMissionQuizForTurmaState(
          mission: this.mission, alunos: this.alunos, turma: this.turma);
}

class _ResultsByMissionQuizForTurmaState
    extends State<ResultsByMissionQuizForTurma> {
  Mission mission;
  List<String> alunos;
  Turma turma;
  Map results;
  Map quizResults;
  Quiz quiz;

  _ResultsByMissionQuizForTurmaState({this.mission, this.alunos, this.turma});

  @override
  void initState() {
    super.initState();
    results = {};
    quizResults = {};
    for (var aluno in alunos) {
      for (var campo in mission.resultados) {
        if (campo['aluno'] == aluno) {
          setState(() {
            results[aluno] = campo;
          });
          break;
        }
      }
    }

    getQuiz(mission.content).then((value) => {
          setState(() {
            quiz = value;
            for (var aluno in alunos) {
              for (var campo in value.resultados) {
                if (campo['aluno'] == aluno) {
                  quizResults[aluno] = campo['result'];

                  break;
                }
              }
            }
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    if (quizResults.length != 0) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: ListView(children: [
            Column(
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/13.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 50.0, bottom: 20, right: 20, left: 50),
                    child: FlatButton(
                      color: parseColor("F4F19C"),
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
                    padding: const EdgeInsets.only(top: 50, bottom: 20),
                    child: Text(
                      "Resultados para a missão  '" +
                          mission.title +
                          "'  dos " +
                          turma.nAlunos.toString() +
                          " alunos da turma " +
                          turma.nome +
                          " : ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          fontFamily: 'Monteserrat',
                          letterSpacing: 2),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, right: 30, top: 30, bottom: 10),
                  child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
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
                      child: Row(children: [
                        Text(
                          '      Aluno                    Missão feita      Tempo passado na missão        Visitas                 Último score ',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        )
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, right: 30, top: 10, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
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
                    height: (170 * alunos.length.toDouble()),
                    child: Row(children: [
                      Expanded(
                        child: new ListView.separated(
                          itemBuilder: (context, int index) {
                            return Column(children: [
                              Container(
                                  height: 150,
                                  color: Colors.white,
                                  child: Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 30),
                                      child: Container(
                                        height: 70,
                                        width: 140,
                                        child: Center(
                                          child: Text(
                                            alunos[index],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Monteserrat',
                                                letterSpacing: 2,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: new Builder(
                                          builder: (BuildContext) => results[
                                                  alunos[index]]['done']
                                              ? Container(
                                                  height: 60,
                                                  width: 100,
                                                  child: Center(
                                                    child: Text("Feita",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Monteserrat',
                                                            letterSpacing: 2,
                                                            fontSize: 15)),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.green[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
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
                                                )
                                              : Container(
                                                  height: 60,
                                                  child: Center(
                                                    child: Text("Não feita",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Monteserrat',
                                                            letterSpacing: 2,
                                                            fontSize: 15)),
                                                  ),
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
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
                                                )),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 50.0),
                                      child: CircularPercentIndicator(
                                        radius: 130.0,
                                        animation: true,
                                        animationDuration: 2000,
                                        lineWidth: 20.0,
                                        startAngle: 45.0,
                                        percent: (results[alunos[index]]
                                                        ['timeVisited'] /
                                                    60)
                                                .round() /
                                            120,
                                        center: new Text(
                                            ((results[alunos[index]][
                                                                'timeVisited'] /
                                                            60)
                                                        .round())
                                                    .toString() +
                                                " min",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Monteserrat',
                                                letterSpacing: 2,
                                                fontSize: 20)),
                                        circularStrokeCap:
                                            CircularStrokeCap.butt,
                                        backgroundColor: Colors.yellow,
                                        progressColor: parseColor("#E04C36"),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 60.0),
                                      child: Text(
                                          "Entrou " +
                                              results[alunos[index]]
                                                      ["counterVisited"]
                                                  .toString() +
                                              " vezes",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Monteserrat',
                                              letterSpacing: 2,
                                              fontSize: 15)),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 60.0),
                                      child: results[alunos[index]]['done']
                                          ? Text(
                                              "Acertou " +
                                                  quizResults[alunos[index]]
                                                      .toString() +
                                                  " / " +
                                                  quiz.questions.length
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Monteserrat',
                                                  letterSpacing: 2,
                                                  fontSize: 15))
                                          : Text(""),
                                    ),
                                  ]))
                            ]);
                          },
                          itemCount: alunos.length,
                          separatorBuilder: (context, int index) {
                            return Divider(height: 30, color: Colors.black12);
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            )
          ]),
        ),
      );
    } else
      return Container();
  }
}
