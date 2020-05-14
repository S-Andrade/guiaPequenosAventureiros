import 'dart:async';

import 'package:feature_missoes_moderador/models/aluno.dart';
import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/capitulos_chart.dart';
import 'package:feature_missoes_moderador/widgets/color_loader.dart';
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
      if (aluno.idadeAluno != 'idade') {
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
             int index=0;
            
            while( index < value2[1].length) {
             
                getPerguntasDoQuestionario(value2[1][index]).then((perguntas) {
              
                  respostas = getQuestionarioRespostas(
                      perguntas, alunoId, perguntaRespostas);
                    
                     

                  if (index == (value2[1].length - 1)){
                      
                    for (var a in respostas.entries) {
                      lista.add([a.key, a.value]);
                      while (a.value.length != 3) a.value.add("-");
                    }
                  }

                  if (lista.length != 0)
                    setState(() {
                      respostasFinal = lista;
                    });
                });
                index=index+1;
              }
            } else
              setState(() {
                respostasFinal = ["null"];
              });
          });
        });
      }
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
         
              return Scaffold(
                  appBar: new AppBar(
                      backgroundColor: Colors.indigoAccent,
                      title: new Text('Perfil do aluno')),
                  body: RefreshIndicator(
                    onRefresh: _refresh,
                    child: Container(
                      color: Colors.indigoAccent[50],
                      child: ListView(
                        children: [
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(35.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.indigoAccent,
                                          blurRadius: 10.0,
                                        )
                                      ]),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50, top: 20.0),
                                        child: Container(
                                            height: 240,
                                            width: 400,
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  width: 150,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              "https://www.pngitem.com/pimgs/m/169-1696687_smile-smileyface-creepy-smiley-hd-png-download.png"))),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Text(
                                                    "Sinto-me feliz!",
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                      letterSpacing: 2,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 80, top: 30.0, bottom: 30),
                                        child: Container(
                                            height: 200,
                                            width: 420,
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
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
                                                              fontSize: 30,
                                                              color: Colors
                                                                  .indigoAccent,
                                                              letterSpacing: 1,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                      ),
                                                    ]),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
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
                                                            letterSpacing: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 30.0,
                                                                bottom: 5),
                                                        child: Text(
                                                          "Turma " +
                                                              aluno.turma,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            letterSpacing: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
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
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              letterSpacing: 1,
                                                            )),
                                                      ),
                                                    ]),
                                              ],
                                            )),
                                      ),
                                      Column(children: [
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
                                            _openSocioDemo(context, aluno);
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 80,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text("  Ver ",
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.white,
                                                      letterSpacing: 1,
                                                    )),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.indigoAccent,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.indigoAccent,
                                                    blurRadius: 10.0,
                                                  )
                                                ]),
                                          ),
                                        )
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50, top: 30),
                                    child: Column(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 30.0),
                                        child: Row(children: <Widget>[
                                          Text(
                                            'Aventura: ' + aventuraNome,
                                            style: TextStyle(
                                              color: Colors.indigoAccent,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ]),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 30.0),
                                        child: Row(children: <Widget>[
                                          Text(
                                            'Estatisticas Capítulos',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ]),
                                      ),
                                      Row(children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(30.0),
                                          child: Container(
                                              height: 180,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          Colors.indigoAccent,
                                                      blurRadius: 10.0,
                                                    )
                                                  ]),
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        Text("Total Capítulos",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .indigoAccent,
                                                              letterSpacing: 1,
                                                            )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                        resultsByCapitulo.length
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 100,
                                                          color: Colors.black,
                                                          letterSpacing: 1,
                                                        )),
                                                  )
                                                ],
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30.0),
                                          child: Container(
                                              height: 180,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          Colors.indigoAccent,
                                                      blurRadius: 10.0,
                                                    )
                                                  ]),
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        Text("Total Capítulos",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .indigoAccent,
                                                              letterSpacing: 1,
                                                            )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                        resultsByCapitulo.length
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 100,
                                                          color: Colors.black,
                                                          letterSpacing: 1,
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
                                                    BorderRadius.circular(20.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.indigoAccent,
                                                    blurRadius: 10.0,
                                                  )
                                                ]),
                                            height: 350,
                                            width: 630,
                                            child: new Builder(
                                              builder: (BuildContext) => _small
                                                  ? Center(
                                                      child: Container(
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 100.0, top: 70, bottom: 20),
                                child: Row(children: [
                                  Text(
                                    "Estatísticas dos Questionários",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  )
                                ]),
                              ),
                              Row(children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30.0, bottom: 30, left: 90),
                                  child: _questExists
                                      ? Container(
                                          height: 600,
                                          width: 1100,
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
                                                      '     Questão                                                                               Q 1         Q 2        Q 3',
                                                      style: TextStyle(
                                                        fontSize: 25,
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
                                                  height: 450,
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
                                                                              respostasFinal[index][1][0],
                                                                              style: const TextStyle(fontSize: 20.0)),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 40.0),
                                                                          child: Text(
                                                                              respostasFinal[index][1][1],
                                                                              style: const TextStyle(fontSize: 20.0)),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 40.0),
                                                                          child: Text(
                                                                              respostasFinal[index][1][2],
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
                                          ]),
                                        )
                                      : Container(
                                          height: 250,
                                          width: 1100,
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
                                          child: Center(
                                            child: Text(
                                              "Ainda não foram feitos questonários..",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'Amatic SC',
                                                  letterSpacing: 2,
                                                  fontSize: 30),
                                            ),
                                          )),
                                )
                              ]),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 100.0, top: 70, bottom: 20),
                            child: Row(children: [
                              Text(
                                "Galeria de itens uploaded",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            ]),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, bottom: 30, left: 90),
                                child: Container(
                                    height: _little ? 380 : 700,
                                    width: 1100,
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
                                    child: GridView.count(
                                      // Create a grid with 2 columns. If you change the scrollDirection to
                                      // horizontal, this produces 2 rows.
                                      crossAxisCount: 3,
                                      // Generate 100 widgets that display their index in the List.
                                      children: List.generate(uploaded.length,
                                          (index) {
                                        if (uploaded[index].contains("mp4"))
                                          setState(() {
                                            _video = true;
                                          });
                                        else
                                          setState(() {
                                            _video = false;
                                          });

                                        return Padding(
                                          padding: const EdgeInsets.only(
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
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                                  .indigoAccent[
                                                              100],
                                                          blurRadius: 10.0,
                                                        )
                                                      ]),
                                                  child: ChewieDemo(
                                                      link: uploaded[index]),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    _openImage(context,
                                                        uploaded[index]);
                                                  },
                                                  child: Container(
                                                    height: 200,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                uploaded[
                                                                    index])),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                    .indigoAccent[
                                                                100],
                                                            blurRadius: 10.0,
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
                  ));
            } else
              return Scaffold(
                  appBar: new AppBar(
                      backgroundColor: Colors.indigoAccent,
                      title: new Text('Perfil do aluno')),
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
                    title: new Text('Perfil do aluno')),
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
                  title: new Text('Perfil do aluno')),
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
                title: new Text('Perfil do aluno')),
            body: Container(
                color: Colors.indigoAccent[50],
                child: Center(
                    child: Text(
                  "Ainda não há dados para este aluno...\n Isto significa que ele ainda não fez uma única vez login",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Amatic SC',
                      letterSpacing: 2,
                      fontSize: 40),
                ))));
    }
    return Scaffold(
        appBar: new AppBar(
            backgroundColor: Colors.indigoAccent,
            title: new Text('Perfil do aluno')),
        body: Container(
            color: Colors.indigoAccent[50],
            child: Center(
                child: Text(
              "Ainda não há dados para este aluno...",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Amatic SC',
                  letterSpacing: 2,
                  fontSize: 40),
            ))));
  }

  _openImage(BuildContext context, link) {
    Widget continuaButton = FlatButton(
      child: Text(
        "Ok",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
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
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
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
                        "Aluno",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            fontSize: 30),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          (DateTime.parse(aluno.dataNascimentoAluno
                                  .toDate()
                                  .toString()))
                              .toString(),
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          aluno.generoAluno,
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          aluno.nacionalidadeAluno,
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          aluno.frequentouPre.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          aluno.idadeIngresso,
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          aluno.maisInfo,
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  fontSize: 30),
                            )
                          : Text(
                              "Mãe",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  fontSize: 30),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          aluno.idadeMae,
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          aluno.profissaoMae,
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          aluno.nacionalidadeMae,
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          aluno.habilitacoesMae,
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  fontSize: 30),
                            )
                          : Text(
                              "Pai",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  fontSize: 30),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          aluno.idadePai,
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          aluno.profissaoPai,
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          aluno.nacionalidadePai,
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
                              letterSpacing: 2,
                              fontSize: 20),
                        ),
                        Text(
                          aluno.habilitacoesPai,
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 20),
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
