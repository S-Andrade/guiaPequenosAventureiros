import 'dart:async';

import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateQuestion extends StatefulWidget {
  @override
  _CreateQuestionState createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  List<RowAnswer> widgetsAns;
  final _textQuestion = TextEditingController();
  final _textAnsCorrect = TextEditingController();
  Question q = new Question();
  @override
  void initState() {
    _respostasErradas = [];
    widgetsAns = [];
    super.initState();
  }

  addAnsRow() {
    setState(() {
      Widget newR = new RowAnswer();
      widgetsAns.add(newR);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/11.png"),
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
                              width:220,
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
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color:  parseColor("F4F19C"),
                            ),
                            child: TextField(
                              controller: _textQuestion,
                              onChanged: (value) {
                                q.question = value;
                              },
                              maxLength: 70,
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
                              width: 227.0,
                              child: Text(
                                "Resposta Correta",
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
                              width: MediaQuery.of(context).size.width / 2.3,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                               color: parseColor("F4F19C"),
                              ),
                              child: TextField(
                                controller: _textAnsCorrect,
                                onChanged: (value) {
                                  q.correctAnswer = value;
                                },
                                maxLength: 40,
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
                                  hintText: "Insira a resposta Correta ",
                                  fillColor: Colors.blue[50],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 227.0,
                              child: Text(
                                "Respostas Erradas",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Monteserrat',
                                    letterSpacing: 2,
                                    fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            Column(
                              children: List.generate(widgetsAns.length, (i) {
                                return widgetsAns[i];
                              }),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left:50.0),
                            child: FlatButton(
                                child: Icon(FontAwesomeIcons.plus,color: parseColor("F4F19C"),),
                                onPressed: () {
                                  addAnsRow();
                                }),
                          )
                        ]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                              child: Text('Submeter',style:TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Monteserrat',
                                    letterSpacing: 2,
                                    fontSize: 20),),
                              onPressed: addQuestionToQuiz),
                          FlatButton(
                              child: Text('Cancelar',style:TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Monteserrat',
                                    letterSpacing: 2,
                                    fontSize: 20),),
                              onPressed: () => Navigator.pop(context))
                        ],
                      )
                    ]),
                  ]),
                ),
              ));
            },
          ),
        ),
      ),
    );
  }

  addQuestionToQuiz() {
    if (widgetsAns.isNotEmpty &&
        q.correctAnswer.length > 0 &&
        q.question.length > 0) {
      missionNotifier.currentQuestion = q;
      for (RowAnswer r in widgetsAns) {
        if (r._textAnsWrong.text.length > 0) {
          _respostasErradas.add(r._textAnsWrong.text);
        }
      }
      q.wrongAnswers = _respostasErradas;
      _respostasErradas = [];
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Falta inserir campos!",
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

List _respostasErradas;

class RowAnswer extends StatelessWidget {
  final _textAnsWrong = TextEditingController();
  String _resposta;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2.3,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color:  parseColor("F4F19C"),
          ),
          child: TextField(
            controller: _textAnsWrong,
            onChanged: (value) {
              _resposta = value;
            },
            maxLength: 40,
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
              hintText: "Resposta Errada",
              fillColor: Colors.blue[50],
            ),
          ),
        )
      ],
    );
  }
}
