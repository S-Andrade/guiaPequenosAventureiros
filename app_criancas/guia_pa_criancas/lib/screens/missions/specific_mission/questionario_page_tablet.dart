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
  String feedback = '';
  String _userID = "";

  @override
  void initState() {
    Auth().getUser().then((user) {
      setState(() {
        _userID = user.email;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    allQuestions = missionsNotifier.currentMission.content.questions;
    allAnswers = [];
    steps = [];
    bool complete = false;
    currentPage = 1;

    goTo(int step) {
      setState(() {
        currentStep = step;
        resposta = 0;
        feedback = "";
      });
    }

    next() {
      updateAnswerQuestion(allQuestions[currentStep], _userID);
      currentStep + 1 != steps.length
          ? goTo(currentStep + 1)
          : setState(() {
              complete = true;
              Navigator.pop(context);
              Navigator.pop(context);
            });
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
                  });
                },
                label: feedback)
          ])));
      currentPage++;
    });

    return new Scaffold(
      body: new WillPopScope(
        onWillPop: () async => false,
        child: Column(children: <Widget>[
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
        ]),
      ),
    );
  }
}
