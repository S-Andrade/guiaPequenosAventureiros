import 'package:feature_missoes_moderador/models/mission.dart';
import 'package:feature_missoes_moderador/screens/turma/turma.dart';
import 'package:feature_missoes_moderador/widgets/video_player.dart';
import 'package:flutter/material.dart';

import '../../../widgets/color_parser.dart';

class ResultsByMissionUploadForTurma extends StatefulWidget {
  Mission mission;
  List<String> alunos;
  Turma turma;

  ResultsByMissionUploadForTurma({this.mission, this.alunos, this.turma});

  @override
  _ResultsByMissionUploadForTurmaState createState() =>
      _ResultsByMissionUploadForTurmaState(
          mission: this.mission, alunos: this.alunos, turma: this.turma);
}

class _ResultsByMissionUploadForTurmaState
    extends State<ResultsByMissionUploadForTurma> {
  Mission mission;
  List<String> alunos;
  Turma turma;
  Map results;
  String url;

  _ResultsByMissionUploadForTurmaState({this.mission, this.alunos, this.turma});

  @override
  void initState() {
    super.initState();
    results = {};

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
  }

  @override
  Widget build(BuildContext context) {
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
                        '                   Aluno                    Missão feita         Ficheiro carregado',
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
                                        left: 50.0, right: 30),
                                    child: Container(
                                      height: 100,
                                      width: 170,
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
                                    padding: const EdgeInsets.only(left: 60.0),
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
                                                          side:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .indigo,
                                                                  width: 5)),
                                                  color: Colors.white,
                                                  textColor: Colors.black,
                                                  padding: EdgeInsets.all(8.0),
                                                  onPressed: () {
                                                    showImageOrVideo(
                                                        context,
                                                        results[alunos[index]]
                                                            ['linkUploaded'],
                                                        mission);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Ver".toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container()),
                                  )
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
  }

  showImageOrVideo(BuildContext context, link, mission) {
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
      title: Text(
        "Imagem carregada pela criança:",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
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

    AlertDialog alertVideo = AlertDialog(
      title: Text(
        "Vídeo carregado pela criança:",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      content: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, top: 10, right: 20, bottom: 0),
        child: Container(
          width: 700,
          height: 450,
          child: Stack(children: [
            Positioned(
              top: 5,
              left: 100,
              child: Container(
                width: 500,
                height: 370,
                decoration: BoxDecoration(
                    color: parseColor("#320a5c"),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: parseColor("#320a5c"),
                        blurRadius: 10.0,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ChewieDemo(link: link),
                ),
              ),
            ),
          ]),
        ),
      ),
      actions: [
        continuaButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (mission.type == 'UploadImage') {
          return alertImage;
        } else {
          return alertVideo;
        }
      },
    );
  }
}
