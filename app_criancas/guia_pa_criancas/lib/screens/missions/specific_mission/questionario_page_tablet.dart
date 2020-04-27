import 'package:app_criancas/notifier/missions_notifier.dart';
import 'package:app_criancas/services/missions_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth.dart';

class QuestionarioPage extends StatefulWidget {
  @override
  _QuestionarioPageState createState() => _QuestionarioPageState();
}

class _QuestionarioPageState extends State<QuestionarioPage> {
  int currentPage = 1;
  int currentStep = 0;
  List<Step> steps = [];
  List allQuestions;
  double resposta = 0;
  List allAnswers;
  String feedback = "Nunca";
  String _userID = "";
  bool complete = false;

  @override
  void initState() {
    Auth().getUser().then((user) {
      setState(() {
        MissionsNotifier missionsNotifier =
            Provider.of<MissionsNotifier>(context, listen: false);
        _userID = user.email;
        currentStep = missionsNotifier.currentPage;
        allQuestions[currentStep].resultados.forEach((aluno) {
          if (aluno['aluno'] == _userID) {
            if (aluno['respostaEscolhida'] != null) {
              feedback = aluno['respostaEscolhida'];
            }
            if (aluno['respostaNumerica'] != null) {
              resposta = aluno['respostaNumerica'].toDouble();
            }
          }
        });
        print(resposta);
        print(feedback);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    allQuestions = missionsNotifier.currentMission.content.questions;
    allAnswers = [];
    steps = [];
    currentPage = 1;

    goTo(int step) {
      setState(() {
        currentStep = step;
        allQuestions[currentStep].resultados.forEach((aluno) {
          if (aluno['aluno'] == _userID) {
            if (aluno['respostaEscolhida'] != null) {
              feedback = aluno['respostaEscolhida'];
            }
            if (aluno['respostaNumerica'] != null) {
              resposta = aluno['respostaNumerica'].toDouble();
            }
          }
        });
        print(resposta);
        print(feedback);
      });
    }

    next() {
      if (feedback != "") {
        updateAnswerQuestion(allQuestions[currentStep], _userID);
        currentStep + 1 != steps.length
            ? goTo(currentStep + 1)
            : setState(() {
                complete = true;
                showDialog(
                    context: context,
                    builder: (context) {
                      return new AlertDialog(
                          content: new Text(
                              "Parabéns chegaste à última questão! Clica em entregar para submeter :)"));
                    });
              });
      }
    }

    cancel() {
      if (currentStep > 0) {
        goTo(currentStep - 1);
      }
    }

    allQuestions.forEach((question) {
      allAnswers = question.answers;
      steps.add(Step(
          title: Text(currentPage.toString()),
          content: new Column(children: <Widget>[
            Text(
              question.question,
              style: TextStyle(fontSize: 20),
            ),
            Padding(padding: EdgeInsets.all(20)),
            Text(feedback, style: TextStyle(fontSize: 25)),
            Slider(
                value: resposta,
                min: 0,
                max: allAnswers.length.toDouble(),
                onChanged: (novaresposta) {
                  setState(() {
                    resposta = novaresposta;
                    if (resposta >= 0 && resposta < 1) {
                      feedback = allAnswers[0];
                    } else if (resposta >= 1 && resposta < 2) {
                      feedback = allAnswers[1];
                    } else if (resposta >= 2 && resposta < 3) {
                      feedback = allAnswers[2];
                    } else if (resposta >= 3 && resposta < 4) {
                      feedback = allAnswers[3];
                    } else if (resposta >= 1 && resposta < 5) {
                      feedback = allAnswers[4];
                    }
                    missionsNotifier
                        .currentMission
                        .content
                        .questions[allQuestions.indexOf(question)]
                        .respostaEscolhida = feedback;
                    question.respostaEscolhida = feedback;
                    question.respostaNumerica = resposta;
                  });
                },
                label: feedback),
          ])));
      currentPage++;
    });

    _close() {
      setState(() {
        missionsNotifier.currentPage = currentStep;
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }

    return new Scaffold(
      appBar: AppBar(
        leading: new FlatButton(
          child: Icon(Icons.close),
          onPressed: () {
            _close();
          },
        ),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: Stepper(
            steps: steps,
            type: StepperType.vertical,
            currentStep: currentStep,
            onStepContinue: next,
            onStepTapped: (step) => goTo(step),
            onStepCancel: cancel,
          ),
        ),
        FlatButton(
            child: new Text(
              'Entregar',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              if (complete) {
                updateMissionCounterInFirestore(missionNotifier.currentMission, _userID, 1);
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return new AlertDialog(
                          content: new Text(
                              "Tens de preencher todas as questões antes de submeter :)"));
                    });
              }
            }),
      ]),
    );
  }
}
