import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_missoes_moderador/models/mission.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/home_screen.dart';
import 'package:feature_missoes_moderador/screens/missions/results/missions_turma.dart';
import 'package:feature_missoes_moderador/screens/turma/turma.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/color_loader.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:feature_missoes_moderador/screens/missions/results/results_turma_tab.dart';

class ResultsDashboardTurmasScreen extends StatefulWidget {
  String aventuraId;
  Capitulo capitulo;

  ResultsDashboardTurmasScreen({this.capitulo, this.aventuraId});

  @override
  _ResultsDashboardTurmasScreenState createState() =>
      _ResultsDashboardTurmasScreenState(
          capitulo: capitulo, aventuraId: aventuraId);
}

class _ResultsDashboardTurmasScreenState
    extends State<ResultsDashboardTurmasScreen> {
  String aventuraId;
  Capitulo capitulo;
  Turma turma;
  List<Turma> turmas;
  int missionsNumber;
  bool firstTime;
  Map percentagens;
  List<Mission> missionsList;
  Map alunosTurma;
  var user;

  _ResultsDashboardTurmasScreenState({this.capitulo, this.aventuraId});

  @override
  void initState() {
    firstTime = true;
    missionsNumber = 0;
    turmas = [];
    percentagens = {};
    missionsList = [];
    alunosTurma = {};
    getCurrentUser().then((userR) => setState(() {
          this.user = userR;
        }));
    if (capitulo.missoes.length != 0) getTurmasForThisAventura(aventuraId);

    super.initState();
  }

  getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    return user;
  }

  getTurmasForThisAventura(aventuraId) async {
    List<dynamic> turmasIds = [];

    turmasIds = await getTurmas(aventuraId);

    turmasIds.forEach((element) {
      getTurma(element).then((value) {
        setState(() {
          turmas.add(value);
        });
      });
    });
  }

  Future<Turma> getTurma(element) async {
    Turma turma;
    DocumentReference documentReference =
        Firestore.instance.collection("turma").document(element);
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        turma = Turma(
            id: datasnapshot.data['id'] ?? '',
            nAlunos: datasnapshot.data['nAlunos'] ?? null,
            file: datasnapshot.data['file'] ?? '',
            nome: datasnapshot.data['nome'] ?? '',
            professor: datasnapshot.data['professor'] ?? '',
            alunos: datasnapshot.data['alunos'] ?? []);
      } else {
        print("No such historia");
      }
    });

    return turma;
  }

  getGeralResultsForTurma(Capitulo capitulo, String turmaId) async {
    List<Mission> missions = [];
    List<String> alunos = [];
    int numberMissionsDone = 0;
    int numeroTotalDeMissoesPorTodosOsAlunos = 0;
    double percentagemMissoesFeitasPorTurma = 0;

    alunos = await getAlunosForTurma(turmaId);
    missions = await getMissionsForCapitulo(capitulo.id);
    setState(() {
      missionsList = missions;
      alunosTurma[turmaId] = alunos;
    });
    numberMissionsDone = getDonesForTurma(alunos, missions);

    if (missions.length != 0 && alunos.length != 0) {
      numeroTotalDeMissoesPorTodosOsAlunos = (missions.length * alunos.length);
      percentagemMissoesFeitasPorTurma =
          (numberMissionsDone * 100) / numeroTotalDeMissoesPorTodosOsAlunos;
    }

    return (percentagemMissoesFeitasPorTurma / 100);
  }

  haveTurma(String turmaId) {
    if (percentagens.containsKey(turmaId)) return true;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _refresh() async {
      setState(() {
        turmas = [];
        firstTime = true;

        print("refresh");
        getTurmasForThisAventura(aventuraId);
      });
    }

    if (user != null) {
      if (capitulo.missoes.length != 0) {
        if (turmas.length != 0) {
          if (firstTime == true) {
            turmas.forEach((element) async {
              double percentagemTurma =
                  await getGeralResultsForTurma(this.capitulo, element.id);
              setState(() {
                percentagens[element.id] = percentagemTurma;
                firstTime = false;
              });
            });
          }
          if (percentagens.length == turmas.length) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: RefreshIndicator(
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 70,
                            color: Colors.transparent,
                            child: Stack(children: [
                              Center(
                                child: Text(
                                  "Resultados por turmas",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 70,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 4),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Positioned(
                                top: 5,
                                left: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: FlatButton(
                                    color: parseColor("F4F19C"),
                                    textColor: Colors.black,
                                    padding: EdgeInsets.all(8.0),
                                    onPressed: () {
                                      print(this.user);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  HomeScreen(user: this.user)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(FontAwesomeIcons.home),
                                    ),
                                  ),
                                ),
                              ),
                            ])),
                        Container(
                            height: 600 * (turmas.length / 4),
                             decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius:
                              5.0, // has the effect of softening the shadow
                          spreadRadius:
                              2.0, // has the effect of extending the shadow
                          offset: Offset(
                            0.0, // horizontal
                            2.5, // vertical
                          ),
                        )
                      ]),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20,
                                      top: 100,
                                      bottom: 50),
                                  child: Text(
                                      "Percentagens de missões feitas por cada turma: ",
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          letterSpacing: 2,
                                          color: Colors.black,
                                          fontFamily: 'Monteserrat')),
                                ),
                                Expanded(
                                  child: GridView.count(
                                    // Create a grid with 2 columns. If you change the scrollDirection to
                                    // horizontal, this produces 2 rows.
                                    crossAxisCount: 4,
                                    // Generate 100 widgets that display their index in the List.
                                    children:
                                        List.generate(turmas.length, (index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0,
                                            bottom: 20,
                                            top: 30,
                                            right: 20),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        ResultsTurmaByMission(
                                                            missions: this
                                                                .missionsList,
                                                            alunos: this
                                                                    .alunosTurma[
                                                                turmas[index]
                                                                    .id],
                                                            turma: this.turmas[
                                                                index])));
                                          },
                                          child: Container(
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      "Turma " +
                                                          turmas[index].id,
                                                      style: TextStyle(
                                                          fontSize: 30.0,
                                                          letterSpacing: 2,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontFamily:
                                                              'Monteserrat')),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    height: 160,
                                                    width: 160,
                                                    child:
                                                        new CircularPercentIndicator(
                                                      radius: 140.0,
                                                      animation: true,
                                                      animationDuration: 2000,
                                                      lineWidth: 20.0,
                                                      startAngle: 45.0,
                                                      percent: percentagens[
                                                          turmas[index].id],
                                                      center: new Text(
                                                        (percentagens[turmas[
                                                                            index]
                                                                        .id] *
                                                                    100)
                                                                .round()
                                                                .toString() +
                                                            "%",
                                                        style: new TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 27.0),
                                                      ),
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .butt,
                                                      backgroundColor:
                                                          parseColor("F4F19C"),
                                                      progressColor:
                                                          parseColor("#E04C36"),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      turmas[index]
                                                              .alunos
                                                              .length
                                                              .toString() +
                                                          " alunos",
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          letterSpacing: 2,
                                                          color: parseColor(
                                                              "#432F49"),
                                                          fontFamily:
                                                              'Monteserrat')),
                                                ),
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius:
                                                        5.0, // has the effect of softening the shadow
                                                    spreadRadius:
                                                        2.0, // has the effect of extending the shadow
                                                    offset: Offset(
                                                      0.0, // horizontal
                                                      2.5, // vertical
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  )),
            );
          } else
            return Center(
                child: ColorLoader(
            
            ));
        } else {
          return Center(
              child: ColorLoader(
        
          ));
        }
      } else
        return Scaffold(
            body: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(children: [
                  Container(
                      height: 625,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/11.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 200,
                          width: 700,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius:
                                      5.0, // has the effect of softening the shadow
                                  spreadRadius:
                                      2.0, // has the effect of extending the shadow
                                  offset: Offset(
                                    0.0, // horizontal
                                    2.5, // vertical
                                  ),
                                )
                              ]),
                          child: Center(
                            child: new Text(
                              "Ainda não há resultados...",
                              style: TextStyle(
                                  fontSize: 35,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 4),
                            ),
                          ),
                        ),
                      )),
                ])));
    } else {
      return Center(
          child: ColorLoader(
      
      ));
    }
  }
}
