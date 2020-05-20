import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/capitulos_chart_grouped.dart';
import 'package:feature_missoes_moderador/widgets/color_loader.dart';
import 'package:feature_missoes_moderador/screens/perfil/perfil_aluno.dart';
import 'package:flutter/material.dart';

class ParticipantesScreen extends StatefulWidget {
  List<dynamic> escolasId;
  String aventuraId;

  ParticipantesScreen({this.escolasId, this.aventuraId});

  @override
  _ParticipantesScreenState createState() => _ParticipantesScreenState(
      escolasId: this.escolasId, aventuraId: this.aventuraId);
}

class _ParticipantesScreenState extends State<ParticipantesScreen> {
  List<dynamic> escolasId;
  String aventuraId;
  bool escolas, turmas, alunos, questionariosGeral;
  Map<String, Map> mapaEscolas = {};
  Map<String, List> alunosPorTurma = {};
  Map mapaTurmas = {};
  List escolasList = [];
  List turmasList = [];
  List respostasFinal = [];
  bool _umaVez = true;
  List todosAlunos=[];

  _ParticipantesScreenState({this.escolasId, this.aventuraId});

  @override
  void initState() {
    super.initState();
    escolas = false;
    turmas = false;
    alunos = false;

    questionariosGeral = false;

    Map respostas = {};
    List lista = [];

    for (var escola in escolasId) {
      getDoneByCapituloForEscola(escola).then((value) {
        setState(() {
          mapaEscolas[escola] = value[0];

          escolasList = mapaEscolas.keys.toList();
        });

        for (var turma in value[1]) {
          getAlunosForTurma(turma).then((value2) {
            setState(() {
              turmasList.add(turma);
              for(var aluno in value2) todosAlunos.add(aluno);
              alunosPorTurma[turma] = value2;
            });
          });
        }

        getDoneByCapituloForTurma(escola,value[1]).then((value3) {
          setState(() {
            mapaTurmas.addAll(value3[0]);
          });
        });

        if (value[2].length != 0 && _umaVez == true) {
       
          getPerguntasDoQuestionarioForAventura(value[2]).then((perguntas) {
            respostas = getQuestionarioRespostasGeralDaAventura(perguntas,todosAlunos);

            for (var a in respostas.entries) {
              List novaLista = [];
              var media;
              for (List cada in a.value) {
                media = 0;
                media = getMedia(cada);
                novaLista.add(media);
              }

              lista.add([a.key, novaLista]);
            }

            if (lista.length != 0) {
              for (var a in lista) while (a[1].length != 3) a[1].add("-");
              setState(() {
                respostasFinal = lista;
              });
            }
          });
        } else if (value[2].length == 0 && _umaVez == true) {
          respostasFinal = ["null"];
        }
        setState(() {
          _umaVez = false;
        });
      });
    }

    /* O QUE OBTEMOS ( EXEMPLO) :
    escolas: {2: {0: {total: 8.0, dones: 0.0}, 1: {total: 10.0, dones: 0.0}}, 1: {0: {total: 12.0, dones: 3.0}, 1: {total: 15.0, dones: 5.0}}}
    alunos: {2: [test1@01.pt], 3: [test2@01.pt], 4a: [gan01@cucu.pt, test1@01.pt], 1: [teste@01.pt]}
    turmas: {1: {4a: {0: {total: 8.0, dones: 3.0}, 1: {total: 
10.0, dones: 5.0}}, 1: {0: {total: 4.0, dones: 0.0}, 1: {total: 5.0, dones: 0.0}}}, 2: {2: {0: {total: 4.0, dones: 0.0}, 1: {total: 5.0, dones: 0.0}}, 3: 
{0: {total: 4.0, dones: 0.0}, 1: {total: 5.0, dones: 0.0}}}}
*/
  }

  @override
  Widget build(BuildContext context) {
    if (mapaEscolas.length != 0) {
      if (alunosPorTurma.length != 0) {
        if (mapaTurmas.length != 0) {
          if (respostasFinal.length != 0) {
           
            return Scaffold(
                appBar: new AppBar(
                    backgroundColor: Colors.indigoAccent,
                    title: new Text('Perfil do aluno')),
                body: Container(
                    color: Colors.indigoAccent[50],
                    child: ListView(children: [
                      Column(children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              escolas = !escolas;
                            });
                          },
                          child: Text(
                            "Ver escolas",
                          ),
                        ),
                        Row(
                          children: [
                            escolas
                                ? Container(
                                    height: 600,
                                    width: 1200,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 100.0,
                                          bottom: 30,
                                          top: 30,
                                          right: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.indigoAccent,
                                                blurRadius: 10.0,
                                              )
                                            ]),
                                        child: BarChartSample2(
                                            results: mapaEscolas),
                                      ),
                                    ))
                                : Container(),
                          ],
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              turmas = !turmas;
                            });
                          },
                          child: Text(
                            "Ver turmas",
                          ),
                        ),
                        Row(
                          children: [
                            turmas
                                ? Container(
                                    height: 600,
                                    width: 1200,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 100.0,
                                          bottom: 30,
                                          top: 30,
                                          right: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.indigoAccent,
                                                blurRadius: 10.0,
                                              )
                                            ]),
                                        child: BarChartSample2(
                                            results: mapaTurmas),
                                      ),
                                    ))
                                : Container(),
                          ],
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              alunos = !alunos;
                            });
                          },
                          child: Text(
                            "Ver alunos",
                          ),
                        ),
                        Row(
                          children: [
                            alunos
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 100.0,
                                        bottom: 30,
                                        top: 30,
                                        right: 20),
                                    child: Container(
                                        height: 500,
                                        width: 1090,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.indigoAccent,
                                                blurRadius: 10.0,
                                              )
                                            ]),
                                        child: new ListView.separated(
                                          itemBuilder: (context, int index) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 850.0,
                                                          top: 30,
                                                          bottom: 30),
                                                  child: Text(
                                                      "Turma " +
                                                          turmasList[index],
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        letterSpacing: 1,
                                                      )),
                                                ),
                                                Container(
                                                  height: 130,
                                                  width: 1000,
                                                  child: GridView.count(
                                                    crossAxisCount: 5,
                                                    childAspectRatio:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            450,
                                                    children: List.generate(
                                                        alunosPorTurma[
                                                                turmasList[
                                                                    index]]
                                                            .length, (index1) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        PerfilAlunoScreen(
                                                                            alunoId:
                                                                                alunosPorTurma[turmasList[index]][index1])));
                                                          },
                                                          child: Container(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Center(
                                                                child: Text(
                                                                    alunosPorTurma[
                                                                            turmasList[index]]
                                                                        [
                                                                        index1],
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      letterSpacing:
                                                                          1,
                                                                    )),
                                                              ),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .indigoAccent,
                                                                    blurRadius:
                                                                        10.0,
                                                                  )
                                                                ]),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          itemCount: turmasList.length,
                                          separatorBuilder:
                                              (context, int index) {
                                            return Divider(
                                                height: 20,
                                                color: Colors.white);
                                          },
                                        )),
                                  )
                                : Container(),
                          ],
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              questionariosGeral = !questionariosGeral;
                            });
                          },
                          child: Text(
                            "Ver questionarios",
                          ),
                        ),
                        Row(
                          children: [
                            questionariosGeral
                                ? Container(
                                    height: 600,
                                    width: 1200,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 100.0,
                                          bottom: 30,
                                          top: 30,
                                          right: 20),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.indigoAccent,
                                                  blurRadius: 10.0,
                                                )
                                              ]),
                                          child: Column(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30.0,
                                                  right: 30,
                                                  top: 30),
                                              child: Container(
                                                  height: 70,
                                                  color: Colors.white,
                                                  child: Row(children: [
                                                    Text(
                                                      '     Questão       [ São apresentadas as médias globais da Aventura ]                       Q 1         Q 2        Q 3',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        letterSpacing: 1,
                                                        color:
                                                            Colors.indigoAccent,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    )
                                                  ])),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30,
                                                  left: 30.0,
                                                  right: 30),
                                              child: Container(
                                                  height: 400,
                                                  child: new ListView.separated(
                                                    itemBuilder:
                                                        (context, int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0,
                                                                right: 70),
                                                        child: Column(
                                                            children: [
                                                              Container(
                                                                  height: 90,
                                                                  color: Colors
                                                                      .white,
                                                                  child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              ListView(children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 5.0, bottom: 10, top: 10, right: 30),
                                                                              child: Container(
                                                                                child: Text(
                                                                                  respostasFinal[index][0],
                                                                                  style: TextStyle(
                                                                                    fontSize: 20,
                                                                                    letterSpacing: 1,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 40.0),
                                                                          child: Text(
                                                                              respostasFinal[index][1][0].toString(),
                                                                              style: const TextStyle(fontSize: 20.0)),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 40.0),
                                                                          child: Text(
                                                                              respostasFinal[index][1][1].toString(),
                                                                              style: const TextStyle(fontSize: 20.0)),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 40.0),
                                                                          child: Text(
                                                                              respostasFinal[index][1][2].toString(),
                                                                              style: const TextStyle(fontSize: 20.0)),
                                                                        )
                                                                      ]))
                                                            ]),
                                                      );
                                                    },
                                                    itemCount:
                                                        respostasFinal.length,
                                                    separatorBuilder:
                                                        (context, int index) {
                                                      return Divider(
                                                          height: 20,
                                                          color:
                                                              Colors.black12);
                                                    },
                                                  )),
                                            )
                                          ])),
                                    ))
                                : Container(),
                          ],
                        ),
                      ])
                    ])));
          } else
            return Scaffold(
                appBar: new AppBar(
                    backgroundColor: Colors.indigoAccent,
                    title: new Text('Participantes')),
                body: Container(
                    color: Colors.indigoAccent[50],
                    child: Center(
                        child: Container(
                            child: ColorLoader(
                      color1: Colors.indigoAccent,
                      color2: Colors.yellowAccent,
                      color3: Colors.deepPurpleAccent,
                    )))));
        } else
          return Scaffold(
              appBar: new AppBar(
                  backgroundColor: Colors.indigoAccent,
                  title: new Text('Participantes')),
              body: Container(
                  color: Colors.indigoAccent[50],
                  child: Center(
                      child: Container(
                          child: ColorLoader(
                    color1: Colors.indigoAccent,
                    color2: Colors.yellowAccent,
                    color3: Colors.deepPurpleAccent,
                  )))));
      } else
        return Scaffold(
            appBar: new AppBar(
                backgroundColor: Colors.indigoAccent,
                title: new Text('Participantes')),
            body: Container(
                color: Colors.indigoAccent[50],
                child: Center(
                    child: Container(
                        child: ColorLoader(
                  color1: Colors.indigoAccent,
                  color2: Colors.yellowAccent,
                  color3: Colors.deepPurpleAccent,
                )))));
    } else
      return Scaffold(
          appBar: new AppBar(
              backgroundColor: Colors.indigoAccent,
              title: new Text('Participantes')),
          body: Container(
              color: Colors.indigoAccent[50],
              child: Center(
                  child: Container(
                      child: ColorLoader(
                color1: Colors.indigoAccent,
                color2: Colors.yellowAccent,
                color3: Colors.deepPurpleAccent,
              )))));
  }

  getMedia(listaNums) {
    var sum = 0.0;
    for (var i = 0; i < listaNums.length; i++) {
      sum += listaNums[i];
    }
    return sum / listaNums.length;
  }
}
