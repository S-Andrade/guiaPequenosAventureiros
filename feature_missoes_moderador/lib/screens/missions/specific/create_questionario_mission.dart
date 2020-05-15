import 'dart:async';
import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/models/questionario.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/tab/tab.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'create_questionario_question_screen.dart';
import 'exist_question.dart';
import 'package:feature_missoes_moderador/screens/aventura/aventura.dart';

class CreateQuestionarioMissionScreen extends StatefulWidget {
  Aventura aventuraId;
  Capitulo capitulo;
  CreateQuestionarioMissionScreen(this.capitulo, this.aventuraId);

  @override
  _CreateQuestionarioMissionScreenState createState() =>
      _CreateQuestionarioMissionScreenState(this.capitulo, this.aventuraId);
}

class _CreateQuestionarioMissionScreenState
    extends State<CreateQuestionarioMissionScreen> {
  Capitulo capitulo;
  Aventura aventuraId;
  Questionario _questionario;
  String _titulo;
  List<Question> _perguntas;
  List<Question> selectedQ = [];

  final _text = TextEditingController();

  _CreateQuestionarioMissionScreenState(this.capitulo, this.aventuraId);

  @override
  void initState() {
    _titulo = "";
    _perguntas = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (missionNotifier.currentQuestion != null) {
      if (!_perguntas.contains(missionNotifier.currentQuestion)) {
        _perguntas.add(missionNotifier.currentQuestion);
      }
    }
    if (selectedQ.isNotEmpty) {
      selectedQ.forEach((f) {
        if(!_perguntas.contains(f)){
          _perguntas.add(f);
        }
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2.8,
                  height: MediaQuery.of(context).size.height,
                  color: parseColor("#320a5c"),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 85.0, right: 50.0, left: 50.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 60.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Text(
                              "Criar um Questionario",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 40,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 4),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Text(
                              "Nesta secção, poderão ser criadas as questões para o Questionario.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 4),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 100.0,
                          ),
                          FlatButton(
                            color: Colors.purple[100],
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Voltar atrás",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 2,
                                  fontSize: 30),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    padding:
                        EdgeInsets.only(top: 100.0, left: 70.0, bottom: 10.0),
                    child: Column(children: <Widget>[
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Row(
                            children: <Widget>[
                              Container(
                                width: 100.0,
                                child: Text(
                                  "Título",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 2,
                                      fontSize: 30),
                                ),
                              ),
                              SizedBox(
                                width: 40.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3.7,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.purple[50],
                                ),
                                child: TextField(
                                  controller: _text,
                                  onChanged: (value) {
                                    _titulo = value;
                                  },
                                  maxLength: 50,
                                  maxLengthEnforced: true,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 4,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue[50],
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    hintText: "Insira o título",
                                    fillColor: Colors.blue[50],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 50.0),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: parseColor("#320a5c"),
                                      blurRadius: 10.0,
                                    )
                                  ]),
                              child: Column(children: [
                                Container(
                                    height: 300,
                                    width: 700,
                                    child: ListView.separated(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Column(children: [
                                            Row(
                                              children: <Widget>[
                                                IconButton(
                                                  icon: Icon(FontAwesomeIcons
                                                      .question),
                                                  iconSize: 10,
                                                  color: parseColor("#320a5c"),
                                                  onPressed: null,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                      width: 170,
                                                      child: Row(children: [
                                                        Flexible(
                                                          child: Text(
                                                            _perguntas[index]
                                                                .question,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontFamily:
                                                                    'Amatic SC',
                                                                letterSpacing:
                                                                    2,
                                                                fontSize: 40),
                                                          ),
                                                        ),
                                                      ])),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                      FontAwesomeIcons.trash),
                                                  iconSize: 10,
                                                  color: parseColor("#320a5c"),
                                                  onPressed: () {
                                                    setState(() {
                                                      _perguntas
                                                          .removeAt(index);
                                                      missionNotifier
                                                              .currentQuestion =
                                                          null;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ]);
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                              height: 70,
                                              color: Colors.black12);
                                        },
                                        itemCount: _perguntas.length)),
                                FlatButton(
                                    child: Icon(FontAwesomeIcons.plus),
                                    onPressed: () {
                                      //pop up
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Nova Questão'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Nova'),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CreateQuestionarioQuestion()));
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                    'De outro Questionário'),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              QuestionarioQuestionExist(
                                                                  selectedQ)));
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Sair'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    })
                              ]))),
                      SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 200.0,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          FlatButton(
                            color: Colors.purple[100],
                            onPressed: () async {
                              missionNotifier.currentQuestion = null;
                              if (_text.text.length > 0 &&
                                  _perguntas.length != 0)
                                showConfirmar(context, _titulo, _perguntas);
                              else
                                await showError();
                            },
                            child: Text(
                              "Submeter missão",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 2,
                                  fontSize: 30),
                            ),
                          ),
                        ],
                      ),
                    ])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showError() async {
    AlertDialog alerta = AlertDialog(
      title: Text(
        "Falta inserir um título ou criar, pelo menos, uma questão!",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alerta;
      },
    );
    Timer(Duration(seconds: 2), () async {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  showConfirmar(BuildContext context, String titulo, List questions) {
    Widget cancelaButton = FlatButton(
      child: Text(
        "Cancelar",
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

    Widget continuaButton = FlatButton(
      child: Text(
        "Sim",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      onPressed: () {
        createMissionQuestinario(titulo, questions, aventuraId.id, capitulo.id);
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (_) =>
                TabBarMissions(capitulo: capitulo, aventura: aventuraId)));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Confirmação",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      content: Text(
        "Tem a certeza que pretende submeter?",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
