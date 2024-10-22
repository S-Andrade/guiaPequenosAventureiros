import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/notifier/missions_notifier.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';

class QuestionarioQuestionExist extends StatefulWidget {
  List<Question> selectedQ;
  QuestionarioQuestionExist(this.selectedQ);
  @override
  _QuestionarioQuestionExistState createState() =>
      new _QuestionarioQuestionExistState(this.selectedQ);
}

class _QuestionarioQuestionExistState extends State<QuestionarioQuestionExist> {
  var isSelected = false;
  var mycolor = Colors.white;
  bool first = true;
  List<Question> selectedQ;
  List selected = [];
  int nSelected = 0;

  _QuestionarioQuestionExistState(this.selectedQ);

  @override
  void initState() {
    nSelected = 0;
    isSelected = false;
    first = true;
    MissionsNotifier missionsNotifier =
        Provider.of<MissionsNotifier>(context, listen: false);
    getQuestions(missionsNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    List<Question> questions = missionsNotifier.allQuestions;
    setState(() {
      selectedQ.forEach((f) {
        selected.add(f.question);
      });
      nSelected = selected.length;
    });
  
    print(missionsNotifier.selectedQuestions.toString());
    missionsNotifier.selectedQuestions.clear();
    
    print(missionsNotifier.selectedQuestions.toString());
    print(selected.toString());
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/19.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Container(
            color: Colors.white,
            width: 840,
            height: 500,
            child: Column(
              children: <Widget>[
                Row(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 50.0, bottom: 20, left: 50),
                    child: MaterialButton(
                      height: 50,
                      minWidth: 70,
                      color: parseColor("#FFCE02"),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      child: first
                          ? Text(
                              'Selecionar todas',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Monteserrat',
                                  color: Colors.black,
                                  letterSpacing: 2),
                            )
                          : Text(
                              'Não selecionar nenhuma',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Monteserrat',
                                  color: Colors.black,
                                  letterSpacing: 2),
                            ),
                      onPressed: () {
                        setState(() {
                          if (first) {
                            questions.forEach((f) {
                              if (!selected.contains(f.question)) {
                                selected.add(f.question);
                              }
                            });
                            first = false;
                          } else {
                            selected.clear();
                            selectedQ.clear();
                            first = true;
                          }
                          nSelected = selectedQ.length;
                        });
                      },
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 250,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Card(
                              color: selected.contains(
                                          questions[index].question) ==
                                      true
                                  ? parseColor("F4F19C")
                                  : Colors.white,
                              child: ListTile(
                                title: Text(
                                  questions[index].question,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Monteserrat',
                                      letterSpacing: 2,
                                      fontSize: 15),
                                ),
                                onTap: () {
                                  print(index);
                                  setState(() {
                                    if (selected
                                        .contains(questions[index].question)) {
                                      selected
                                          .remove(questions[index].question);
                                      print(
                                          'removiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
                                    } else {
                                      print(
                                          'adicioneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiiiiiiiiiii');
                                      selected.add(questions[index].question);
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: questions.length),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 50, bottom: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        nSelected != 0
                            ? 'Selecionou ' +
                                nSelected.toString() +
                                ' perguntas'
                            : 'Selecione as perguntas que quer adicionar ao Questionário',
                        style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Monteserrat',
                            letterSpacing: 2,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          questions.forEach((f) {
                            if (selected.contains(f.question)) {
                              if(!missionsNotifier.selectedQuestions.contains(f))
                                missionsNotifier.selectedQuestions.add(f);
                            }
                          });
                          Navigator.pop(context);
                      
                        },
                        child: Text("Adicionar")),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar"))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
