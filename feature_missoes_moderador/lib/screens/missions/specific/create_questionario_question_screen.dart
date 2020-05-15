import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
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
  int max;
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
      body: Form(
        child: Builder(
          builder: (BuildContext context) {
            return AlertDialog(
                content: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 100.0,
                    child: Text(
                      "Pergunta",
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
                      controller: _textQuestion,
                      onChanged: (value) {
                        q.question = value;
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
                        hintText: "Insira a pergunta",
                        fillColor: Colors.blue[50],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 100.0,
                    child: Text(
                      "Número de respostas",
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
                      controller: _numeroRespotas,
                      onChanged: (value) {
                        valorMax = value;
                        max = int.parse(value);
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
                        FontAwesomeIcons.checkSquare,
                      ),
                      onPressed: () {
                        addAnsRow(max);
                      })
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 100.0,
                    child: Text(
                      "Respostas",
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
                  Column(
                    children: List.generate(widgetsAns.length, (i) {
                      return widgetsAns[i];
                    }),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                      child: Text('Submeter'),
                      onPressed: addQuestionToQuestionario)
                ],
              )
            ]));
          },
        ),
      ),
    );
  }

  addQuestionToQuestionario() {
    if (widgetsAns.isNotEmpty &&
        q.question.length > 0) {
      missionNotifier.currentQuestion = q;
      for (RowAnswer r in widgetsAns) {
        if (r._textAnsWrong.text.length > 0) {
          _respostas.add(r._textAnsWrong.text);
        }
      }
      q.answers = _respostas;
      _respostas = [];
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Preencha todos os campos",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Amatic SC',
                  letterSpacing: 2,
                  fontSize: 30),
            ),
          );
        },
      );
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
    return Row(
      children: <Widget>[
        Container(
          width: 100.0,
          child: Text(
            text,
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
            controller: _textAnsWrong,
            onChanged: (value) {
              _resposta = value;
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
              hintText: "Resposta",
              fillColor: Colors.blue[50],
            ),
          ),
        )
      ],
    );
  }
}
