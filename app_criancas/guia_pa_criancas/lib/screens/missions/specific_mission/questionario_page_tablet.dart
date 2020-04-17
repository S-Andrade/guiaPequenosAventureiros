import 'package:app_criancas/notifier/missions_notifier.dart';
import 'package:app_criancas/widgets/color_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionarioPage extends StatefulWidget {
  @override
  _QuestionarioPageState createState() => _QuestionarioPageState();
}

class _QuestionarioPageState extends State<QuestionarioPage> {
  int currentPage = 1;
  int currentStep = 0;
  List<Step> steps = [];
  List allQuestions;
  Step step;
  double resposta;
  List allAnswers;

  @override
  Widget build(BuildContext context) {
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    allQuestions = missionsNotifier.currentMission.content.questions;
    allAnswers =
        missionsNotifier.currentMission.content.question[currentStep].answers;
    
    bool complete = false;

    goTo(int step) {
      setState(() => currentStep = step);
    }
    next() {
      currentStep + 1 != steps.length
          ? goTo(currentStep + 1)
          : setState(() => complete = true);
    }

    allQuestions.forEach((question) {
      step = Step(
          title: Text(currentPage.toString()),
          isActive: true,
          state: StepState.indexed,
          content: new Column(
            children: <Widget>[
              Positioned(
                top: 340,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 430,
                    width: 530,
                    color: parseColor('#320a5c'),
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 30, top: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                allQuestions[currentStep].question,
                                style: TextStyle(
                                    fontSize: 50,
                                    color: Colors.white,
                                    fontFamily: 'Amatic SC',
                                    letterSpacing: 4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              Positioned(
                top: 820,
                child: Slider(
                  value: resposta,
                  onChanged: (novaresposta) {
                    setState(() {
                      resposta = novaresposta;
                    });
                  },
                  divisions: allAnswers.length,
                  label: allAnswers[resposta.toInt()],
                ),
              )
            ],
          ));
      steps.add(step);
    });
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
            body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back6.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: 110,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Stepper(
                          type: StepperType.horizontal,
                          steps: steps,
                          currentStep: currentStep,
                          onStepContinue: next,
                          onStepTapped: (step) => goTo(step),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
