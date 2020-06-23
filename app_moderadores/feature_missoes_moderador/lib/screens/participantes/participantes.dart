import 'package:feature_missoes_moderador/screens/home_screen.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/capitulos_chart_grouped.dart';
import 'package:feature_missoes_moderador/widgets/color_loader.dart';
import 'package:feature_missoes_moderador/screens/perfil/perfil_aluno.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  List todosAlunos = [];
  Map nomes;
  var user;

  _ParticipantesScreenState({this.escolasId, this.aventuraId});

  @override
  void initState() {
    super.initState();
    escolas = false;
    turmas = false;
    alunos = false;
    nomes={};

    questionariosGeral = false;

    Map respostas = {};
    List lista = [];

    getCurrentUser().then((userR) => setState(() {
          this.user = userR;
        }));

    for (var escola in escolasId) {
      getDoneByCapituloForEscola(escola).then((value) {
        
        setState(() {
          nomes.addAll(value[3]);
          mapaEscolas[value[4]] = value[0];
          escolasList = mapaEscolas.keys.toList();
        });

        for (var turma in value[1]) {
          getAlunosForTurma(turma).then((value2) {
            setState(() {
              turmasList.add(turma);
              for (var aluno in value2) todosAlunos.add(aluno);
              alunosPorTurma[turma] = value2;
            });
          });
        }

        getDoneByCapituloForTurma(escola, value[1]).then((value3) {
          
          setState(() {
            mapaTurmas.addAll(value3[0]);
          });
        });

        if (value[2].length != 0 && _umaVez == true) {
          getPerguntasDoQuestionarioForAventura(value[2]).then((perguntas) {
            respostas =
                getQuestionarioRespostasGeralDaAventura(perguntas, todosAlunos);

            for (var a in respostas.entries) {
              List novaLista = [];
              List numeroRespostas = [];
              var media;
              for (List cada in a.value) {
                media = 0;
                int nao = 0;
                for (var ui in cada) {
                  if (ui == 0) nao++;
                }
                if (nao != cada.length) {
                  var resposta = getMedia(cada);
                  media = resposta[0];
                  numeroRespostas.add(resposta[1]);
                  novaLista.add(media.round());
                } else {
                  novaLista.add("-");
                  numeroRespostas.add(0);
                }
              }

              lista.add([a.key, novaLista, numeroRespostas]);
            }

            if (lista.length != 0) {
              for (var a in lista) while (a[1].length != 3) a[1].add("");
              setState(() {
                respostasFinal = lista;
              });
            }
          });
        } else if (value[2].length == 0 && _umaVez == true) {
          respostasFinal = ["nada"];
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

  getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      if (mapaEscolas.length >= 1) {
        if (alunosPorTurma.length != 0) {
          if (mapaTurmas.length == nomes.length) {
         
            if (respostasFinal.length != 0) {
              
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/animated6.gif"),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Container(
                        child: ListView(children: [
                      Column(children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    "Resultados Gerais",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 50,
                                        fontFamily: 'Amatic SC',
                                        letterSpacing: 4),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  left: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: FlatButton(
                                      color: parseColor("F4F19C"),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => HomeScreen(
                                                    user: this.user)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(FontAwesomeIcons.home),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
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
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 100, bottom: 70.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Resultados, de missões feitas, por cada escola:",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Monteserrat',
                                            letterSpacing: 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 400,
                                      width: 380,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/animated17.gif"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                        height: 400,
                                        width: 550,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0,
                                              bottom: 30,
                                              top: 0,
                                              right: 20),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
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
                                            child: BarChartSample2(
                                                results: mapaEscolas),
                                          ),
                                        ))
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 100, bottom: 40.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Resultados, de missões feitas, por cada turma e lista de alunos:",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Monteserrat',
                                            letterSpacing: 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, bottom: 50.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        " Clique no nome de uma criança, para ver perfil... ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Monteserrat',
                                            letterSpacing: 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                        height: 460,
                                        width: 550,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0,
                                              bottom: 30,
                                              top: 30,
                                              right: 30),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
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
                                            child: BarChartSample2(
                                                results: mapaTurmas),
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0,
                                          bottom: 30,
                                          top: 30,
                                          right: 20),
                                      child: Container(
                                          height: 400,
                                          width: 350,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
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
                                          child: new ListView.separated(
                                            itemBuilder: (context, int index) {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 230,
                                                            top: 20,
                                                            bottom: 20),
                                                    child: Text(
                                                        "Turma " +
                                                            nomes[turmasList[index]],
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          letterSpacing: 1,
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Container(
                                                      height: 90,
                                                      child: GridView.count(
                                                        crossAxisCount: 2,
                                                        childAspectRatio:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                300,
                                                        children: List.generate(
                                                            alunosPorTurma[
                                                                    turmasList[
                                                                        index]]
                                                                .length,
                                                            (index1) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (_) =>
                                                                                PerfilAlunoScreen(alunoId: alunosPorTurma[turmasList[index]][index1])));
                                                              },
                                                              child: Container(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          0.0),
                                                                  child: Center(
                                                                    child: Text(
                                                                        alunosPorTurma[turmasList[index]]
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
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.1),
                                                                        blurRadius:
                                                                            5.0, // has the effect of softening the shadow
                                                                        spreadRadius:
                                                                            2.0, // has the effect of extending the shadow
                                                                        offset:
                                                                            Offset(
                                                                          0.0, // horizontal
                                                                          2.5, // vertical
                                                                        ),
                                                                      )
                                                                    ]),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      ),
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
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 100, bottom: 0.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Resultados gerais, dos Questionários, para esta Aventura:  \n",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Monteserrat',
                                            letterSpacing: 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, bottom: 40.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "São apresentados valores médios para cada um, tendo em conta o número de respostas dadas até ao momento.\n\n                                                           Clique numa média para ver número total de respostas. ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Monteserrat',
                                            letterSpacing: 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(children: [
                                   new Builder(
                                      builder: (BuildContext) => (
                                              respostasFinal[0]!="nada")
                                          ? 
                                  Container(
                                      height: 700,
                                      width: 950,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0,
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
                                                        '     Questão                                                                                               1º    2º   3º',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          letterSpacing: 1,
                                                          color: parseColor(
                                                              "#f4a09c"),
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                                    height: 500,
                                                    child:
                                                        new ListView.separated(
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
                                                                                padding: const EdgeInsets.only(left: 5.0, bottom: 10, top: 10, right: 5.0),
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
                                                                          Tooltip(
                                                                            message: (respostasFinal[index][1][0].toString() == "")
                                                                                ? "Sem Questionário ainda "
                                                                                : respostasFinal[index][2][0].toString() + " resposta(s) no total",
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 40.0),
                                                                              child: Text(respostasFinal[index][1][0].toString(), style: const TextStyle(fontSize: 20.0)),
                                                                            ),
                                                                          ),
                                                                          Tooltip(
                                                                             message: (respostasFinal[index][1][1].toString() == "")
                                                                                ? "Sem Questionário ainda "
                                                                                : respostasFinal[index][2][1].toString() + " resposta(s) no total",
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 30.0),
                                                                              child: Text(respostasFinal[index][1][1].toString(), style: const TextStyle(fontSize: 20.0)),
                                                                            ),
                                                                          ),
                                                                          Tooltip(
                                                                            message: (respostasFinal[index][1][2].toString() == "")
                                                                                ? "Sem Questionário ainda "
                                                                                : respostasFinal[index][2][2].toString() + " resposta(s) no total",
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 40.0),
                                                                              child: Text(respostasFinal[index][1][2].toString(), style: const TextStyle(fontSize: 20.0)),
                                                                            ),
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
                                      :
                                      Container(
                                      height: 300,
                                      width: 950,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0,
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
                                     
                                                  child: Center(
                                                    child: new Text(
                                                      "Ainda não foram feitos Questionários.",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontFamily: 'Monteserrat',
                                                          letterSpacing: 4),
                                                    ),
                                                  )))))

                                ])
                              ],
                            ),
                          ),
                        ),
                      ])
                    ]))),
              );
            } else
              return Scaffold(
                  body: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/animated6.gif"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(child: Container(child: ColorLoader()))));
          } else
            return Scaffold(
                body: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/animated6.gif"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(child: Container(child: ColorLoader()))));
        } else
          return Scaffold(
              body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/animated6.gif"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(child: Container(child: ColorLoader()))));
      } else
        return Scaffold(
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/animated6.gif"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(child: Container(child: ColorLoader()))));
    } else
      return Scaffold(
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/animated6.gif"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(child: Container(child: ColorLoader()))));
  }

  getMedia(listaNums) {
    var sum = 0.0;
    var length = 0;
    for (var i = 0; i < listaNums.length; i++) {
      if (listaNums[i] != 0) {
        sum += listaNums[i];
        length++;
      }
    }
    return [sum / length, length];
  }
}
