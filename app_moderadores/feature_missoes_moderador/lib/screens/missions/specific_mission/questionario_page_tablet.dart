import 'package:app_criancas/notifier/missions_notifier.dart';
import 'package:app_criancas/services/missions_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:light/light.dart';
import 'package:sensors/sensors.dart';
import '../../../auth.dart';
import 'dart:async';

class QuestionarioPage extends StatefulWidget {
  @override
  _QuestionarioPageState createState() => _QuestionarioPageState();
}

class _QuestionarioPageState extends State<QuestionarioPage>
    with WidgetsBindingObserver {
  int currentPage = 1;
  int currentStep = 0;
  List<Step> steps = [];
  List allQuestions;
  double resposta = 1;
  List allAnswers;
  String feedback = "Arrasta para responder";
  String _userID = "";
  bool complete = false;
  List<double> _movementData = List();
  List<int> _lightData = List();
  DateTime _start;
  DateTime _end;
  int _timeSpentOnThisScreen;
  int _timeVisited;
  int _counterVisited;
  DateTime _paused;
  DateTime _returned;
  int _totalPaused;
  Light _light;
  StreamSubscription _subscription;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

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
            if (aluno['respostaEscolhida'] != "" &&
                aluno['respostaEscolhida'] != null) {
              feedback = aluno['respostaEscolhida'];
            }
            if (aluno['respostaNumerica'] != 0 &&
                aluno['respostaNumerica'] != null) {
              resposta = aluno['respostaNumerica'].toDouble();
            }
          }
        });
        for (var a in missionsNotifier.currentMission.resultados) {
          if (a["aluno"] == _userID) {
            _counterVisited = a["counterVisited"];
            _timeVisited = a["timeVisited"];
          }
        }
        print(resposta);
        print(feedback);
      });
    });

    WidgetsBinding.instance.addObserver(this);

    _start = DateTime.now();

    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _movementData.add(event.x);
      });
    }));

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    startListening();
  }

  void startListening() {
    _light = new Light();
    try {
      _subscription = _light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  void onData(int luxValue) async {
    _lightData.add(luxValue);
    print(luxValue);
  }

  void stopListening() {
    _subscription.cancel();
  }

  @override
  void dispose() {
    print('dispose');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    stopListening();
  }

  AppLifecycleState state;

  @override
  void deactivate() {
    MissionsNotifier missionsNotifier =
        Provider.of<MissionsNotifier>(context, listen: false);
    _counterVisited = _counterVisited + 1;
    _end = DateTime.now();
    _timeSpentOnThisScreen = _end.difference(_start).inSeconds;
    _timeVisited = _timeVisited + _timeSpentOnThisScreen;
    updateMissionTimeAndCounterVisitedInFirestore(
        missionsNotifier.currentMission,
        _userID,
        _timeVisited,
        _counterVisited);
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _paused = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      _returned = DateTime.now();
    }

    _totalPaused = _returned.difference(_paused).inSeconds;
    _timeVisited = _timeVisited - _totalPaused;
  }

  @override
  Widget build(BuildContext context) {
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    allQuestions = missionsNotifier.currentMission.content.questions;
    allAnswers = [];
    steps = [];
    currentPage = 1;

    goTo(int step) {
      if (feedback != "Arrasta para responder") {
        updateAnswerQuestion(allQuestions[currentStep], _userID);
        setState(() {
          currentStep = step;
          allQuestions[currentStep].resultados.forEach((aluno) {
            if (aluno['aluno'] == _userID) {
              if (aluno['respostaEscolhida'] != "" &&
                  aluno['respostaEscolhida'] != null) {
                feedback = aluno['respostaEscolhida'];
              } else {
                feedback = 'Arrasta para responder';
              }
              if (aluno['respostaNumerica'] != 0 &&
                  aluno['respostaNumerica'] != null) {
                resposta = aluno['respostaNumerica'].toDouble();
              } else {
                resposta = 1;
              }
            }
          });
        });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return new AlertDialog(
                  content:
                      new Text("Responde para passares à pergunta seguinte!"));
            });
      }
    }

    next() {
      if (feedback != "Arrasta para responder") {
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
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return new AlertDialog(
                  content:
                      new Text("Responde para passares à pergunta seguinte!"));
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
          content: Column(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  question.question,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  5,
                  (index) => Text(
                    (index + 1).toString(),
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            Slider(
              value: resposta,
              min: 1,
              max: allAnswers.length.toDouble(),
              onChanged: (novaresposta) {
                print(novaresposta);
                setState(() {
                  resposta = novaresposta;
                  if (resposta >= 1 && resposta < 2) {
                    feedback = allAnswers[0];
                    resposta = 1;
                  } else if (resposta >= 2 && resposta < 3) {
                    feedback = allAnswers[1];
                    resposta = 2;
                  } else if (resposta >= 3 && resposta < 4) {
                    feedback = allAnswers[2];
                    resposta = 3;
                  } else if (resposta >= 4 && resposta < 5) {
                    feedback = allAnswers[3];
                    resposta = 4;
                  } else if (resposta == 5) {
                    feedback = allAnswers[4];
                    resposta = 5;
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
              label: feedback,
              divisions: allAnswers.length - 1,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Resposta: ' + feedback,
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
            ),
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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/green_question.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: new Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Questionário",
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.black),
            ),
          ),
          leading: new FlatButton(
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              _close();
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.25,
                  child: Container(
//                        height: 130,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(
                          'assets/images/clouds_bottom_navigation_white.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    )),
                  ),
                ),
              ),
            ),
            Column(children: <Widget>[
              Expanded(
                child: Stepper(
                  steps: steps,
                  controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue,
                      VoidCallback onStepCancel}) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: FlatButton(
                            color: Color(0xFF0081C2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            onPressed: onStepContinue,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Próxima',
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: FlatButton(
                            color: Color(0xFFEF807A),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            onPressed: onStepCancel,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Anterior',
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  type: StepperType.vertical,
                  currentStep: currentStep,
                  onStepContinue: next,
                  onStepTapped: (step) => goTo(step),
                  onStepCancel: cancel,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FlatButton(
                      color: Color(0xFFF3C463),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Entregar',
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: () {
                        int respondidas = 0;
                        allQuestions.forEach((element) {
                          element.resultados.forEach((aluno) {
                            if (aluno['aluno'] == _userID) {
                              if (aluno['respostaEscolhida'] != "" &&
                                  aluno['respostaEscolhida'] != null) {
                                respondidas++;
                              }
                            }
                          });
                        });
                        if (respondidas == allQuestions.length) {
                          updateMissionCounterInFirestore(
                              missionNotifier.currentMission, _userID, 1);
                          updateMissionDoneInFirestore(
                              missionNotifier.currentMission, _userID);
                          saveMissionMovementAndLightDataInFirestore(
                              missionNotifier.currentMission,
                              _userID,
                              _movementData,
                              _lightData);
                          for (StreamSubscription<dynamic> subscription
                              in _streamSubscriptions) {
                            subscription.cancel();
                          }
                          stopListening();
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
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}