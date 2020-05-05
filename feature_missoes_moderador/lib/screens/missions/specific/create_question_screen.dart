import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/notifier/missions_notifier.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CreateQuestion extends StatefulWidget {
  @override
  _CreateQuestionState createState() => _CreateQuestionState();
}


class _CreateQuestionState extends State<CreateQuestion> {
  List<RowAnswer> widgetsAns = [];
  final _textQuestion = TextEditingController();
  final _textAnsCorrect = TextEditingController(); 
  Question q = new Question();
  @override
  void initState() {
    _respostasErradas = [];
    _errada = null;
    super.initState();
  }

  addAnsRow() {
    setState(() {
      widgetsAns.add(new RowAnswer());
      if(_errada!=null){
        _respostasErradas.add(_errada);
      }
    });
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
                      "Resposta Correta",
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
                      controller: _textAnsCorrect,
                      onChanged: (value) {
                        q.correctAnswer = value;
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
                        hintText: "Resposta Correta ",
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
                      "Respostas Erradas",
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
              Row(children: <Widget>[
                FlatButton(
                    child: Icon(FontAwesomeIcons.plus),
                    onPressed: () {
                      addAnsRow();
                    })
              ]),
              Row(
                children: <Widget>[
                  FlatButton(
                      child: Text('Submeter'), onPressed: addQuestionToQuiz)
                ],
              )
            ]));
          },
        ),
      ),
    );
  }

  addQuestionToQuiz() {
    missionNotifier.currentQuestion = q;
    _respostasErradas.add(_errada);
    q.wrongAnswers = _respostasErradas;
    _respostasErradas = [];
    Navigator.pop(context);
  }
}
List _respostasErradas;
String _errada;
class RowAnswer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 3.7,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.purple[50],
          ),
          child: TextField(
            onChanged: (value) {
              print(value);
              _errada =value;
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
              hintText: "Resposta Errada",
              fillColor: Colors.blue[50],
            ),
          ),
        )
      ],
    );
  }
}
