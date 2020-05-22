import 'package:app_criancas/notifier/missions_notifier.dart';
import 'package:app_criancas/services/missions_api.dart';
import 'package:app_criancas/services/recompensas_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  double resposta = 0;
  List allAnswers;
  String feedback = "Nunca";
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
  int points;
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
        //ir buscar os pontos da missao
        points = missionsNotifier.currentMission.points;
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
        for (var a in missionsNotifier.currentMission.resultados) {
          if (a["aluno"] == _userID) {
            _counterVisited = a["counterVisited"];
            _timeVisited = a["timeVisited"];
          }
        }
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
    super.initState();
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
            onPressed: () async {
              if (complete) {
                //adicionar para atualizar a pontuacao
                await updatePoints(_userID, points);
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
      ]),
    );
  }

  //adiciona a pontuação e os cromos ao aluno e turma
  updatePoints(String aluno, int points) async {
    List cromos = await updatePontuacao(aluno, points);
    print("tellle");
    print(cromos);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Ganhas-te pontos"),
          content: new Text("+$points"),
          actions: <Widget>[
            // define os botões na base do dialogo
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    if (cromos[0] != null) {
      Image image;
      await FirebaseStorage.instance
          .ref()
          .child(cromos[0])
          .getDownloadURL()
          .then((downloadUrl) {
        image = Image.network(
          downloadUrl.toString(),
          fit: BoxFit.scaleDown,
        );
      });
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: new Text("Ganhas-te um cromo para a tua caderneta"),
            content: image,
            actions: <Widget>[
              // define os botões na base do dialogo
              new FlatButton(
                child: new Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    if (cromos[1] != null) {
      Image image;
      await FirebaseStorage.instance
          .ref()
          .child(cromos[1])
          .getDownloadURL()
          .then((downloadUrl) {
        image = Image.network(
          downloadUrl.toString(),
          fit: BoxFit.scaleDown,
        );
      });
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: new Text("Ganhas-te um cromo para a caderneta da turma"),
            content: image,
            actions: <Widget>[
              // define os botões na base do dialogo
              new FlatButton(
                child: new Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
