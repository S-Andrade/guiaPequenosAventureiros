import 'dart:async';

import 'package:feature_missoes_moderador/models/aluno.dart';
import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/capitulos_chart.dart';
import 'package:feature_missoes_moderador/widgets/color_loader.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:feature_missoes_moderador/widgets/video_player.dart';
import 'package:flutter/material.dart';

class PerfilAlunoScreen extends StatefulWidget {
  String alunoId;

  PerfilAlunoScreen({this.alunoId});

  @override
  _PerfilAlunoScreenState createState() =>
      _PerfilAlunoScreenState(alunoId: this.alunoId);
}

class _PerfilAlunoScreenState extends State<PerfilAlunoScreen> {
  String alunoId;
  Aluno aluno;
  Map resultsByCapitulo;
  bool _small;
  List<Map> perguntasResults;
  List<Question> perguntas;
  Map<String, Map> questionarioFinal = {};
  bool _little;
  bool _video;
  List uploaded;
  bool _questExists;
  List respostasFinal = [];
  String escolaNome = "";
  String aventuraNome = "";

  _PerfilAlunoScreenState({this.alunoId});

  @override
  void initState() {
    super.initState();
    aluno = null;
    _video = false;
    uploaded = [];
    resultsByCapitulo = {};
    _questExists = true;
    _little = true;

    getAlunoById(alunoId).then((value) {
      setState(() {
        aluno = value;
      });

      getDoneByCapitulo(value.id, value.turma, value.escola).then((value2) {
        getEscolaNome(value.escola).then((escola) => {
              setState(() {
                escolaNome = escola;
              })
            });

        if (value2[2].length == 0)
          setState(() {
            uploaded.add(
                "https://cdn.dribbble.com/users/598368/screenshots/3890110/dribble_no_data.jpg");
          });
        else
          setState(() {
            uploaded = value2[2];
          });

        setState(() {
          aventuraNome = value2[3];
          resultsByCapitulo = value2[0];
          if (resultsByCapitulo.length <= 3)
            _small = true;
          else
            _small = false;
          Map<String, List> perguntaRespostas = {};
          Map<String, List> respostas = {};
          List lista = [];
          if (value2[1] != []) {
            for (var i = 0; i < value2[1].length; i++) {
              getPerguntasDoQuestionario(value2[1][i]).then((perguntas) {
                respostas = getQuestionarioRespostas(
                    perguntas, alunoId, perguntaRespostas);
                if (i == (value2[1].length - 1))
                  for (var a in respostas.entries) {
                    lista.add([a.key, a.value]);
                    while (a.value.length != 3) a.value.add(" ");
                  }

                if (lista.length != 0)
                  setState(() {
                    respostasFinal = lista;
                  });
              });
            }
          } else
            setState(() {
              respostasFinal = ["null"];
            });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _refresh() async {}
    if (aluno != null) {
      if (aluno.idadeAluno != 'idade') {
        if (resultsByCapitulo.length != 0) {
          if (respostasFinal.length != 0) {
            if (respostasFinal[0] == "null")
              setState(() {
                _questExists = false;
              });
            if (uploaded.length != 0) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage("assets/images/12.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(children: [
                        Column(
                          children: <Widget>[
                            Container(
                                height: 400,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 150.0, left: 130),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 180,
                                        height: 180,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    "https://cdn.dribbble.com/users/3284565/screenshots/7041226/media/1ce032ff143cbfe83bf24146262e85c5.png"))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                            fontSize: 30,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
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
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 50,
                                                  top: 30.0,
                                                  bottom: 30),
                                              child: Container(
                                                  height: 200,
                                                  width: 420,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 30,
                                                                      bottom: 20,
                                                                      top: 20),
                                                              child: Text(
                                                                aluno.id,
                                                                style: TextStyle(
                                                                    fontSize: 25,
                                                                    color: parseColor(
                                                                        "#f4a09c"),
                                                                    letterSpacing:
                                                                        1,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ]),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 30.0,
                                                                      bottom: 15),
                                                              child: Text(
                                                                aluno.idadeAluno +
                                                                    " anos",
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  letterSpacing:
                                                                      1,
                                                                ),
                                                              ),
                                                            ),
                                                          ]),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 30.0,
                                                                      bottom: 10),
                                                              child: Text(
                                                                "Turma " +
                                                                    aluno.turma,
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  letterSpacing:
                                                                      1,
                                                                ),
                                                              ),
                                                            ),
                                                          ]),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 33.0,
                                                                      bottom: 0),
                                                              child: Text(
                                                                  "Escola " +
                                                                      escolaNome,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: 20,
                                                                    letterSpacing:
                                                                        1,
                                                                  )),
                                                            ),
                                                          ]),
                                                    ],
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0, right: 40),
                                              child: Column(children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      bottom: 30.0),
                                                  child: Row(children: <Widget>[
                                                    Text(
                                                      'Dados sócio-demográficos',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _openSocioDemo(
                                                        context, aluno);
                                                  },
                                                  child: Container(
                                                    width: 120,
                                                    height: 60,
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                        child: Text("  Ver ",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors.white,
                                                              letterSpacing: 1,
                                                            )),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            parseColor("#f4a09c"),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20.0),
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
                                                  ),
                                                )
                                              ]),
                                            ),
                                            FlatButton(
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
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width: 800,
                                        height: 0.5,
                                        color: Colors.black),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 80.0),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 10, bottom: 30),
                                            child: Column(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 60.0),
                                                child: Row(children: <Widget>[
                                                  Text(
                                                    'Estatísticas Capítulos',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                              Row(children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 80.0, right: 40),
                                                  child: Container(
                                                      height: 130,
                                                      width: 170,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20.0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.black
                                                                  .withOpacity(
                                                                      0.1),
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
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                                "Total Capítulos",
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: parseColor(
                                                                      "#f4a09c"),
                                                                  letterSpacing:
                                                                      1,
                                                                )),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                                resultsByCapitulo
                                                                    .length
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  fontSize: 60,
                                                                  color: Colors
                                                                      .black,
                                                                  letterSpacing:
                                                                      1,
                                                                )),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 0.0),
                                                  child: Container(
                                                      height: 130,
                                                      width: 170,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20.0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.black
                                                                  .withOpacity(
                                                                      0.1),
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
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                                "Atual",
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: parseColor(
                                                                      "#f4a09c"),
                                                                  letterSpacing:
                                                                      1,
                                                                )),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                               "3",
                                                                style: TextStyle(
                                                                  fontSize: 60,
                                                                  color: Colors
                                                                      .black,
                                                                  letterSpacing:
                                                                      1,
                                                                )),
                                                          )
                                                        ],
                                                      )),
                                                )
                                              ]),
                                            ]),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(children: <Widget>[
                                              Row(children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 50.0, right: 20),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20.0),
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
                                                    height: 350,
                                                    width: 550,
                                                    child: new Builder(
                                                      builder: (BuildContext
                                                              context) =>
                                                          _small
                                                              ? Center(
                                                                  child:
                                                                      Container(
                                                                    height: 400,
                                                                    width: 300,
                                                                    child: BarChartSample1(
                                                                        results:
                                                                            resultsByCapitulo),
                                                                  ),
                                                                )
                                                              : Container(

                                                                  //child: BarChartSample1(results:resultsByCapitulo),
                                                                  ),
                                                    ),
                                                  ),
                                                ),
                                              ])
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 160.0, top: 100, bottom: 50),
                                      child: Row(children: [
                                        Text(
                                          "Estatísticas dos Questionários",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ]),
                                    ),
                                    Row(children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 30.0, bottom: 30, left: 130),
                                        child: _questExists
                                            ? Container(
                                                height: 600,
                                                width: 1000,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 30.0,
                                                            right: 30,
                                                            top: 30),
                                                    child: Container(
                                                        height: 70,
                                                        color: Colors.white,
                                                        child: Row(children: [
                                                          Text(
                                                            '     Questão                                                                Q 1               Q 2           Q 3',
                                                            style: TextStyle(
                                                              fontSize: 25,
                                                              letterSpacing: 1,
                                                              color: parseColor(
                                                                  "#f4a09c"),
                                                              fontWeight:
                                                                  FontWeight.w700,
                                                            ),
                                                          )
                                                        ])),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 30,
                                                            left: 30.0,
                                                            right: 30),
                                                    child: Container(
                                                        height: 450,
                                                        child: new ListView
                                                            .separated(
                                                          itemBuilder: (context,
                                                              int index) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10.0,
                                                                      right: 10),
                                                              child: Column(
                                                                  children: [
                                                                    Container(
                                                                        height:
                                                                            90,
                                                                        color: Colors
                                                                            .white,
                                                                        child:
                                                                            Container(
                                                                          child: Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: 550,
                                                                                  child: Row(children: [
                                                                                    Expanded(
                                                                                        child: ListView(children: [
                                                                                      Text(
                                                                                        respostasFinal[index][0],
                                                                                        style: TextStyle(
                                                                                          fontSize: 18,
                                                                                          letterSpacing: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ])),
                                                                                  ]),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 30.0),
                                                                                  child: Text(respostasFinal[index][1][0], style: const TextStyle(fontSize: 15.0)),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 30.0),
                                                                                  child: Text(respostasFinal[index][1][1], style: const TextStyle(fontSize: 15.0)),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 30.0),
                                                                                  child: Text(respostasFinal[index][1][2], style: const TextStyle(fontSize: 15.0)),
                                                                                )
                                                                              ]),
                                                                        ))
                                                                  ]),
                                                            );
                                                          },
                                                          itemCount:
                                                              respostasFinal
                                                                  .length,
                                                          separatorBuilder:
                                                              (context,
                                                                  int index) {
                                                            return Divider(
                                                                height: 20,
                                                                color: Colors
                                                                    .black12);
                                                          },
                                                        )),
                                                  )
                                                ]),
                                              )
                                            : Container(
                                                height: 250,
                                                width: 1100,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
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
                                                  child: Text(
                                                    "Ainda não foram feitos questonários..",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontFamily: 'Amatic SC',
                                                        letterSpacing: 2,
                                                        fontSize: 30),
                                                  ),
                                                )),
                                      )
                                    ]),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 160.0, top: 70, bottom: 50),
                                      child: Row(children: [
                                        Text(
                                          "Galeria de itens carregados",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ]),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 30.0, bottom: 30, left: 130),
                                          child: Container(
                                              height: _little ? 380 : 700,
                                              width: 1000,
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
                                              child: GridView.count(
                                                // Create a grid with 2 columns. If you change the scrollDirection to
                                                // horizontal, this produces 2 rows.
                                                crossAxisCount: 3,
                                                // Generate 100 widgets that display their index in the List.
                                                children: List.generate(
                                                    uploaded.length, (index) {
                                                  if (uploaded[index]
                                                      .contains("mp4"))
                                                    setState(() {
                                                      _video = true;
                                                    });
                                                  else
                                                    setState(() {
                                                      _video = false;
                                                    });

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 40.0,
                                                            bottom: 30,
                                                            top: 40,
                                                            right: 40),

                                                    //onTap: () {

                                                    //},
                                                    child: _video
                                                        ? Container(
                                                            height: 200,
                                                            width: 200,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.1),
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
                                                            child: ChewieDemo(
                                                                link: uploaded[
                                                                    index]),
                                                          )
                                                        : GestureDetector(
                                                            onTap: () {
                                                              _openImage(
                                                                  context,
                                                                  uploaded[
                                                                      index]);
                                                            },
                                                            child: Container(
                                                              height: 200,
                                                              width: 200,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: NetworkImage(
                                                                          uploaded[
                                                                              index])),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.1),
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
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                    )),
              );
            } else
              return Scaffold(
                  body: Container(
                      color: Colors.transparent,
                      child: Center(
                          child: Container(
                              child: ColorLoader(
                       
                      )))));
          } else
            return Scaffold(
                body: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage("assets/images/12.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                        child: Container(
                            child: ColorLoader(
                    
                    )))));
        } else
          return Scaffold(
              body: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage("assets/images/12.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                      child: Container(
                          child: ColorLoader(
                    
                  )))));
      } else
        return Scaffold(
            body: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage("assets/images/12.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 170.0, right: 250),
                      child: Text(
                        "\n\n\n\n\n\n\n\nAinda não há dados para este aluno...\n\nIsto significa que ele ainda não fez uma única vez login.",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Monteserrat',
                            letterSpacing: 2,
                            fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 80.0,
                        right: 950,
                      ),
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
                  ],
                ))));
    }
    return Scaffold(
              body: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage("assets/images/12.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                      child: Container(
                          child: ColorLoader(
                   
                  )))));
  }

  _openImage(BuildContext context, link) {
    Widget continuaButton = FlatButton(
      child: Text(
        "Ok",
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alertImage = AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: 700,
          height: 400,
          child: Container(
            height: 230,
            width: 700,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: NetworkImage(link),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      actions: [
        continuaButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertImage;
      },
    );
  }

  _openSocioDemo(BuildContext context, Aluno aluno) {
    _isEE(idade) {
      if (idade == aluno.idadeEE) {
        return true;
      } else
        return false;
    }

    Widget continuaButton = FlatButton(
      child: Text(
        "Ok",
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alertImage = AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: 700,
          height: 400,
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15.0, right: 30, bottom: 20),
                    child: Row(children: [
                      Text(
                        "Criança",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Monteserrat',
                            letterSpacing: 2,
                            fontSize: 20),
                      )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Data de nascimento : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          (DateTime.parse(aluno.dataNascimentoAluno
                                  .toDate()
                                  .toString()))
                              .toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Género : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          aluno.generoAluno,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Nacionalidade : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          aluno.nacionalidadeAluno,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Frequentou pré-escolar : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          aluno.frequentouPre.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Idade ingresso : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          aluno.idadeIngresso,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Mais info: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          aluno.maisInfo,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30.0, right: 30, bottom: 20),
                    child: Row(children: [
                      _isEE(aluno.idadeMae)
                          ? Text(
                              "Mãe   [ Encarregada de Educação ]",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Monteserrat',
                                  letterSpacing: 2,
                                  fontSize: 20),
                            )
                          : Text(
                              "Mãe",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Monteserrat',
                                  letterSpacing: 2,
                                  fontSize: 20),
                            )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Idade : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          aluno.idadeMae,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Profissão : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          aluno.profissaoMae,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Nacionalidade : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          aluno.nacionalidadeMae,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Habilitações : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          aluno.habilitacoesMae,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30.0, right: 30, bottom: 20),
                    child: Row(children: [
                      _isEE(aluno.idadePai)
                          ? Text(
                              "Pai   [ Encarregado de Educação ]",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Monteserrat',
                                  letterSpacing: 2,
                                  fontSize: 20),
                            )
                          : Text(
                              "Pai",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Monteserrat',
                                  letterSpacing: 2,
                                  fontSize: 20),
                            )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Idade : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          aluno.idadePai,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Profissão : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          aluno.profissaoPai,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Nacionalidade : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          aluno.nacionalidadePai,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Habilitações : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                        Text(
                          aluno.habilitacoesPai,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 2,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        continuaButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertImage;
      },
    );
  }
}
