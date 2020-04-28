import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_missoes_moderador/models/mission.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/turma/turma.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';
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

  _ResultsDashboardTurmasScreenState({this.capitulo, this.aventuraId});

  @override
  void initState() {
    firstTime = true;
    missionsNumber = 0;
    turmas = [];
    percentagens = {};
    missionsList=[];
    alunosTurma={};
    getTurmasForThisAventura(aventuraId);
    super.initState();
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
            nome:datasnapshot.data['nome'] ?? '',
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
      missionsList=missions;
      alunosTurma[turmaId]=alunos;
    });
    numberMissionsDone = getDonesForTurma(alunos, missions);

   

    numeroTotalDeMissoesPorTodosOsAlunos = (missions.length * alunos.length);
    percentagemMissoesFeitasPorTurma =
        (numberMissionsDone * 100) / numeroTotalDeMissoesPorTodosOsAlunos;
  

    return (percentagemMissoesFeitasPorTurma / 100);
  }

  haveTurma(String turmaId) {
    if (percentagens.containsKey(turmaId)) return true;
  }

  @override
  Widget build(BuildContext context) {

 

    Future<void> _refresh() async {
      setState((){
        turmas=[];
        firstTime=true;
     
      print("refresh");
      getTurmasForThisAventura(aventuraId);
      
       
    
    });
    }



    if (turmas.length != 0) {
      if (firstTime == true) {
        print("first");
         turmas.forEach((element) async {
          double percentagemTurma =
              await getGeralResultsForTurma(this.capitulo, element.id);
          setState(() {
            percentagens[element.id] = percentagemTurma;
            firstTime = false;
          });
        });
        
      }
      if(percentagens.length!=0){

      return Scaffold(
          body: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back11.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 4,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(turmas.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 30, top: 30, right: 20),
                  child: GestureDetector(
                    onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ResultsTurmaTab(missions:this.missionsList,alunos:this.alunosTurma[turmas[index].id],turma:this.turmas[index])));
                          },
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 60,
                            left: 52,
                            child: Container(
                              height: 160,
                              width: 160,
                              child: new CircularPercentIndicator(
                                radius: 140.0,
                                animation: true,
                                animationDuration: 2000,
                                lineWidth: 20.0,
                                startAngle: 45.0,
                                percent: percentagens[turmas[index].id],
                                center: new Text(
                                  (percentagens[turmas[index].id] * 100).round()
                                          .toString() +
                                      "%",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                circularStrokeCap: CircularStrokeCap.butt,
                                backgroundColor: Colors.grey[200],
                                progressColor: Colors.deepPurpleAccent,
                              ),
                            ),
                          ),
                          Positioned(
                              top: 220,
                              left: 80,
                              child: Text(
                                "alunos..",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Amatic SC',
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 4),
                              )),
                          Positioned(
                              top: 10,
                              left: 75,
                              child: Text(
                                "Turma " + turmas[index].id,
                                style: TextStyle(
                                    fontSize: 35,
                                    fontFamily: 'Amatic SC',
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 4),
                              ))
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: parseColor("#320a5c"),
                              blurRadius: 10.0,
                            )
                          ]),
                    ),
                  ),
                );
              }),
            )),
      ));
      }
      else return Container();
    } else {
      return Container();
    }
  }
}
