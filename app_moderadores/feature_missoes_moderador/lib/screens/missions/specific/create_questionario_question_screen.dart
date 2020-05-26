import 'dart:async';

import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateQuestionarioQuestion extends StatefulWidget {
  @override
  _CreateQuestionarioQuestionState createState() =>
      _CreateQuestionarioQuestionState();
}

List _respostas;

class _CreateQuestionarioQuestionState
    extends State<CreateQuestionarioQuestion> {
  List<RowAnswer> widgetsAns;
  final _textQuestion = TextEditingController();
  final _numeroRespotas = TextEditingController();
  String valorMax;
  int max = 0;
  Question q = new Question();

  @override
  void initState() {
    _respostas = [];
    widgetsAns = [];
    super.initState();
  }

  Future<void> addAnsRow(int max) {
    setState(() {
      for (int r = 0; r < max; r++) {
        Widget newR = new RowAnswer(r);
        widgetsAns.add(newR);
      }
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/19.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Form(
          child: Builder(
            builder: (BuildContext context) {
              return AlertDialog(
                  content: SingleChildScrollView(
                      child: Container(
                          width: 840,
                          height: 400,
                          child: ListView(children: [
                            Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 230.0,
                                      child: Text(
                                        "Pergunta",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Monteserrat',
                                            letterSpacing: 2,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.4,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: parseColor("F4F19C"),
                                    ),
                                    child: TextField(
                                      controller: _textQuestion,
                                      onChanged: (value) {
                                        q.question = value;
                                      },
                                      maxLength: 150,
                                      maxLengthEnforced: true,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Monteserrat',
                                          letterSpacing: 2,
                                          fontSize: 20),
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue[50],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        hintText: "Insira a pergunta",
                                        fillColor: Colors.blue[50],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 240.0,
                                      child: Text(
                                        "Número de respostas",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontFamily: 'Monteserrat',
                                            letterSpacing: 2,
                                            fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40.0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          4.0,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: parseColor("F4F19C"),
                                      ),
                                      child: TextField(
                                        controller: _numeroRespotas,
                                        onChanged: (value) {
                                          valorMax = value;
                                          max = int.parse(value);
                                        },
                                        maxLength: 50,
                                        maxLengthEnforced: true,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Monteserrat',
                                            letterSpacing: 2,
                                            fontSize: 20),
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blue[50],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          hintText: "valor máximo: ex. 5",
                                          fillColor: Colors.blue[50],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40.0,
                                    ),
                                    FlatButton(
                                        child: Icon(
                                          FontAwesomeIcons.plus,
                                          color: parseColor("F4F19C"),
                                        ),
                                        onPressed: () {
                                          if (max != 0)
                                            addAnsRow(max);
                                          else {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "Não inseriu o número de respostas!",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Monteserrat',
                                                        letterSpacing: 2,
                                                        fontSize: 20),
                                                  ),
                                                );
                                              },
                                            );
                                            Timer(Duration(seconds: 2),
                                                () async {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            });
                                          }
                                        }),
                                    Text("Criar respostas")
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 227.0,
                                      child: Text(
                                        "Respostas",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'Monteserrat',
                                            letterSpacing: 2,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                  ),
                                  Column(
                                    children:
                                        List.generate(widgetsAns.length, (i) {
                                      return widgetsAns[i];
                                    }),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    FlatButton(
                                        child: Text(
                                          'Submeter',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Monteserrat',
                                              letterSpacing: 2,
                                              fontSize: 20),
                                        ),
                                        onPressed: addQuestionToQuestionario),
                                    FlatButton(
                                        child: Text(
                                          'Cancelar',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Monteserrat',
                                              letterSpacing: 2,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context))
                                  ],
                                ),
                              )
                            ])
                          ]))));
            },
          ),
        ),
      ),
    );
  }

  addQuestionToQuestionario() {
    if (widgetsAns.isNotEmpty && q.question.length > 0) {
      for (RowAnswer r in widgetsAns) {
        if (r._textAnsWrong.text.length > 0) {
          _respostas.add(r._textAnsWrong.text);
          r._textAnsWrong.clear();
        }
      }
      q.answers = _respostas;
      missionNotifier.currentQuestion = q;
      _respostas = [];
      _textQuestion.clear();
      _numeroRespotas.clear();
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Falta inserir campos",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Monteserrat',
                  letterSpacing: 2,
                  fontSize: 20),
            ),
          );
        },
      );
      Timer(Duration(seconds: 2), () async {
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }
}

class RowAnswer extends StatelessWidget {
  final _textAnsWrong = TextEditingController();
  String _resposta; //é usada sim
  String text;
  int numero;
  RowAnswer(int r) {
    this.numero = r;
  }
  @override
  Widget build(BuildContext context) {
    String text = (this.numero + 1).toString();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 100.0,
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Monteserrat',
                  letterSpacing: 2,
                  fontSize: 20),
            ),
          ),
          SizedBox(
            width: 40.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3.9,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: parseColor("F4F19C"),
            ),
            child: TextField(
              controller: _textAnsWrong,
              onChanged: (value) {
                _resposta = value;
              },
              maxLength: 25,
              maxLengthEnforced: true,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Monteserrat',
                  letterSpacing: 2,
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
                hintText: "Resposta possível",
                fillColor: Colors.blue[50],
              ),
            ),
          )
        ],
      ),
    );
  }
}
