import 'package:feature_missoes_moderador/models/mission.dart';
import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/screens/turma/turma.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/color_loader.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

class ResultsByMissionQuestionarioForTurma extends StatefulWidget {
  Mission mission;
  List<String> alunos;
  Turma turma;

  ResultsByMissionQuestionarioForTurma({this.mission, this.alunos, this.turma});

  @override
  _ResultsByMissionQuestionarioForTurmaState createState() =>
      _ResultsByMissionQuestionarioForTurmaState(
          mission: this.mission, alunos: this.alunos, turma: this.turma);
}

class _ResultsByMissionQuestionarioForTurmaState
    extends State<ResultsByMissionQuestionarioForTurma> {
  Mission mission;
  List<String> alunos;
  Turma turma;
  Map results;

  List<Question> perguntas;
  List<Map> perguntasResults;

  _ResultsByMissionQuestionarioForTurmaState(
      {this.mission, this.alunos, this.turma});

  @override
  void initState() {
    super.initState();
    results = {};
    perguntas = [];
    perguntasResults = [];

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

    getPerguntasDoQuestionario(mission.content).then((value) => setState(() {
          perguntas = value;
          for (var i in value) {
            Map alunoResposta = {};
            alunoResposta['pergunta'] = i.question;

            for (var aluno in alunos) {
              for (var campo in i.resultados) {
                if (campo['aluno'] == aluno) {
                  alunoResposta[aluno] = campo['respostaEscolhida'];

                  break;
                }
              }
            }

            perguntasResults.add(alunoResposta);
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (perguntasResults.length != 0) {
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
                        top: 50.0, bottom: 20, right: 40, left: 50),
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
                          '        Aluno',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 13),
                        ),
                        Text(
                          '               Missão feita',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 13),
                        ),
                        Text(
                          '       Tempo passado\n           na missão',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 13),
                        ),
                        Text(
                          '      Nº de vezes\n      que entrou',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 13),
                        ),
                        Text(
                          '       Movimento',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 13),
                        ),
                        Text(
                          '         Luz\n       Ambiental',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 13),
                        ),
                        Text(
                          '     Respostas',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 13),
                        ),
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
                                        left: 15.0,
                                      ),
                                      child: Container(
                                        height: 50,
                                        width: 120,
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
                                      padding:
                                          const EdgeInsets.only(left: 30.0),
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
                                          const EdgeInsets.only(left: 30.0),
                                      child: CircularPercentIndicator(
                                        radius: 110.0,
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
                                                fontSize: 15)),
                                        circularStrokeCap:
                                            CircularStrokeCap.butt,
                                        backgroundColor: Colors.yellow,
                                        progressColor: parseColor("#E04C36"),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 30.0),
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
                                              fontSize: 13)),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: new Builder(
                                          builder: (BuildContext) => results[
                                                  alunos[index]]['done']
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: FlatButton(
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    18.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .indigo,
                                                                width: 5)),
                                                    color: Colors.white,
                                                    textColor: Colors.black,
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    onPressed: () {
                                                      showGraficoMovimento(
                                                          context,
                                                          results[
                                                              alunos[index]]);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "Ver gráfico"
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 10.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: new Builder(
                                          builder: (BuildContext) => results[
                                                  alunos[index]]['done']
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: FlatButton(
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    18.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .indigo,
                                                                width: 5)),
                                                    color: Colors.white,
                                                    textColor: Colors.black,
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    onPressed: () {
                                                      showGraficoLuz(
                                                          context,
                                                          results[
                                                              alunos[index]]);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        "Ver gráfico"
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 10.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(),
                                      child: new Builder(
                                          builder: (BuildContext) => results[
                                                  alunos[index]]['done']
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: FlatButton(
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    18.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .indigo,
                                                                width: 5)),
                                                    color: Colors.white,
                                                    textColor: Colors.black,
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    onPressed: () {
                                                      showRespostas(
                                                          context,
                                                          perguntasResults,
                                                          alunos[index]);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "Ver respostas"
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 10.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container()),
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
      return Scaffold(
         
          body: Container(
             
              child: Center(
                  child: Container(
                      child: ColorLoader(
               
              )))));
  }

// POP UP DAS RESPOSTAS DO ALUNO AO QUESTIONÁRIO

  showRespostas(BuildContext context, perguntas, aluno) {
    Widget continuaButton = FlatButton(
      child: Text(
        "Ok",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            fontFamily: 'Monteserrat',
            letterSpacing: 2),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Respostas do aluno ao Questionário",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            fontFamily: 'Monteserrat',
            letterSpacing: 2),
      ),
      content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 700,
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 260,
              width: 700,
              child: new ListView.separated(
                itemBuilder: (context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 30, top: 40),
                    child: Column(children: [
                      Container(
                          height: 90,
                          color: Colors.white,
                          child: Row(children: [
                            Expanded(
                              child: ListView(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 30),
                                  child: Container(
                                    height: 250,
                                    width: 400,
                                    child: Text(
                                      perguntas[index]['pergunta'],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          fontFamily: 'Monteserrat',
                                          letterSpacing: 2),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(perguntas[index][aluno],
                                  style: const TextStyle(fontSize: 15.0)),
                            ),
                          ]))
                    ]),
                  );
                },
                itemCount: perguntas.length,
                separatorBuilder: (context, int index) {
                  return Divider(height: 20, color: Colors.black12);
                },
              ),
            ),
          ),
        ),
      ),
      actions: [
        continuaButton,
      ],
    );

    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// POP UP DO MOVIMENTO

  showGraficoMovimento(BuildContext context, graficos) {
    Widget continuaButton = FlatButton(
      child: Text(
        "Ok",
        style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Monteserrat',
            letterSpacing: 2),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Gráfico de movimento ao realizar a missão",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            fontFamily: 'Monteserrat',
            letterSpacing: 2),
      ),
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: 700,
          height: 400,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "Picos acentuados assinalam momento em que o aluno moveu demasiado o dispositivo.",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Monteserrat',
                    letterSpacing: 2),
              ),
            ),
            Container(
              height: 230,
              width: 700,
              child: new Sparkline(
                lineWidth: 6.0,
                lineGradient: new LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.red[800], Colors.red[200]],
                ),
                data: graficos["movementData"].cast<double>(),
              ),
            ),
          ]),
        ),
      ),
      actions: [
        continuaButton,
      ],
    );

    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// POP UP DA LUZ AMBIENTAL

  showGraficoLuz(BuildContext context, graficos) {
    Map<String, double> dataMap = {};
    double _muitaLuz = 0;
    double _poucaLuz = 0;
    double _algumaLuz = 0;
    double _nenhumaLuz = 0;
    for (var luz in graficos["lightData"]) {
      if ((luz >= 0) & (luz < 4))
        _nenhumaLuz++;
      else if ((luz >= 3) & (luz < 20))
        _poucaLuz++;
      else if ((luz >= 20) & (luz < 40))
        _algumaLuz++;
      else
        _muitaLuz++;
    }
    dataMap.putIfAbsent("Muita luz", () => _muitaLuz);
    dataMap.putIfAbsent("Alguma luz", () => _algumaLuz);
    dataMap.putIfAbsent("Pouca luz", () => _poucaLuz);
    dataMap.putIfAbsent("Muito pouca luz", () => _nenhumaLuz);

    Widget continuaButton = FlatButton(
      child: Text(
        "Ok",
        style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Monteserrat',
            letterSpacing: 2),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Gráfico da luz ambiental ao realizar a missão",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            fontFamily: 'Monteserrat',
            letterSpacing: 2),
      ),
      content: Container(
        width: 700,
        height: 400,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "Valores de luz ambiental durante a realização da missão.",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Monteserrat',
                  letterSpacing: 2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              height: 230,
              width: 700,
              child: new PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32.0,
                legendStyle: TextStyle(fontSize: 20.0),
                chartValueStyle: TextStyle(fontSize: 25.0, color: Colors.black),
                chartRadius: MediaQuery.of(context).size.width / 2.7,
                showChartValuesInPercentage: true,
                showChartValues: true,
              ),
            ),
          ),
        ]),
      ),
      actions: [
        continuaButton,
      ],
    );

    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
