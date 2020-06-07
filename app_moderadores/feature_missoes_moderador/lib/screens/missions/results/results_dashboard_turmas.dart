import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_missoes_moderador/models/mission.dart';
import 'package:feature_missoes_moderador/screens/aventura/aventura.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/home_screen.dart';
import 'package:feature_missoes_moderador/screens/missions/results/missions_turma.dart';
import 'package:feature_missoes_moderador/screens/tab/tab.dart';
import 'package:feature_missoes_moderador/screens/turma/turma.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/color_loader.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:feature_missoes_moderador/widgets/popupConfirm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResultsDashboardTurmasScreen extends StatefulWidget {
  Aventura aventuraId;
  Capitulo capitulo;

  ResultsDashboardTurmasScreen({this.capitulo, this.aventuraId});

  @override
  _ResultsDashboardTurmasScreenState createState() =>
      _ResultsDashboardTurmasScreenState(
          capitulo: capitulo, aventuraId: aventuraId);
}

class _ResultsDashboardTurmasScreenState
    extends State<ResultsDashboardTurmasScreen> {
  Aventura aventuraId;
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
    if (capitulo.missoes.length != 0) getTurmasForThisAventura(aventuraId.id);
    print(capitulo.disponibilidade.toString());
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
        getTurmasForThisAventura(aventuraId.id);
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
                                  "Resultados Por Turmas",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 50,
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
                                          fontSize: 20.0,
                                          letterSpacing: 2,
                                          color: Colors.black,
                                          fontFamily: 'Monteserrat')),
                                ),
                                Expanded(
                                  child: GridView.count(
                                    // Create a grid with 2 columns. If you change the scrollDirection to
                                    // horizontal, this produces 2 rows.
                                    crossAxisCount: 3,
                                    // Generate 100 widgets that display their index in the List.
                                    children:
                                        List.generate(turmas.length, (index) {
                                     return (capitulo.disponibilidade[turmas[index].id]==true) ? Padding(
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
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      "Turma " +
                                                          turmas[index].nome,
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          letterSpacing: 2,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                                          Colors.yellow,
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
                                                          fontSize: 15.0,
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
                                      ) 
                                      :
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0,
                                            bottom: 20,
                                            top: 30,
                                            right: 20),
                                        
                                          child: Container(
                                          
                                              
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top:10.0),
                                                  child: Text(
                                                      "Turma " +
                                                          turmas[index].nome,
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          letterSpacing: 2,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Monteserrat')),
                                                ),
                                               
                                                GestureDetector(
                                                  onTap: () {showConfirmar(context,turmas[index].nome,capitulo,aventuraId);}, 
                                                                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(top:120.0),
                                                    child: Text(
                                                        "DESBLOQUEAR",
                                                        style: TextStyle(
                                                            fontSize:33.0,
                                                            letterSpacing: 2,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w900,
                                                            fontFamily:
                                                                'Monteserrat')),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                                 image: DecorationImage(
                    image: AssetImage("assets/images/unlock.jpg"),
                    fit: BoxFit.cover,
                  ),
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
                                        
                                      ) ;
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
            return Center(child: ColorLoader());
        } else {
          return Center(child: ColorLoader());
        } 
      } 
        else
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: RefreshIndicator(
                onRefresh: _refresh,
                child: Stack(children: [
                    Positioned(
               top:50,left:100,
                      child: FlatButton(
                        color: parseColor("F4F19C"),
                        textColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => HomeScreen(user: this.user)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(FontAwesomeIcons.home),
                        ),
                      ),
                    ),Center(
                  child: 
                    Container(
                      height: 200,
                      width: 600,
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
                              fontSize: 25,
                              fontFamily: 'Monteserrat',
                              letterSpacing: 4),
                        ),
                      ),
                    ),
                    )],
                )));
    } else {
          return Center(child: ColorLoader());
        } 
   
  }

  showConfirmar(BuildContext context, 
      String turma,Capitulo capitulo,Aventura aventura) {
    final popup = BeautifulPopup.customize(
      context: context,
      build: (options) => MyTemplateConfirmation(options),
    );

    Widget cancelaButton = FlatButton(
      child: Text(
        "Cancelar",
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget continuaButton = FlatButton(
      child: Text(
        "Sim",
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
      ),
      onPressed: () async {
        await desbloquearCapituloParaTurma(capitulo,turma);
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (_) =>
                TabBarMissions(capitulo: capitulo, aventura: aventura)));
       

      },
    );

    popup.show(
      close: Container(),
      title: Text(
        "",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      content: Text(
        "\nTem a certeza que pretende desbloquer o capítulo para a turma "+turma+"?",
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
  }

  
}
