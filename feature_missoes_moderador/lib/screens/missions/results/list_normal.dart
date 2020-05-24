import 'package:feature_missoes_moderador/models/mission.dart';
import 'package:feature_missoes_moderador/screens/turma/turma.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_beautiful_popup/main.dart';

class ResultsByMissionNormalForTurma extends StatefulWidget {
  Mission mission;
  List<String> alunos;
  Turma turma;

  ResultsByMissionNormalForTurma({this.mission, this.alunos, this.turma});

  @override
  _ResultsByMissionNormalForTurmaState createState() =>
      _ResultsByMissionNormalForTurmaState(
          mission: this.mission, alunos: this.alunos, turma: this.turma);
}

class _ResultsByMissionNormalForTurmaState
    extends State<ResultsByMissionNormalForTurma> {
  Mission mission;
  List<String> alunos;
  Turma turma;
  Map results;

  _ResultsByMissionNormalForTurmaState({this.mission, this.alunos, this.turma});

  @override
  void initState() {
    super.initState();
    results = {};

    for (var aluno in alunos) {
      for (var campo in mission.resultados) {
        if (campo['aluno'] == aluno) {
          setState(() {
            results[aluno] = campo;
          });
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     
      body: Container(
        child: ListView(children: [
          Column(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/13.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                              children:[ 
                                      Padding(
                                        padding: const EdgeInsets.only(top:50.0,bottom:20,right:100,left:50),
                                        child: FlatButton(
                            color:parseColor("F4F19C"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Voltar atrás",
                              style: TextStyle(
                                  color: Colors.black,
                                 
                                  fontFamily: 'Monteserrat',
                                  letterSpacing: 2,
                                  fontSize: 20),
                            ),
                          ),
                                      ),
                                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 20),
                  child: Text(
                    "Resultados para a missão  '" +
                        mission.title +
                        "'  dos " +
                        turma.nAlunos.toString() +
                        " alunos da turma " +
                        turma.nome +
                        " : ",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        fontFamily: 'Monteserrat',
                        letterSpacing: 2),
                  ),
                ),]
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30, top: 30, bottom: 10),
                child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
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
                    child: Row(children: [
                      Text(
                        '                Aluno                  Missão feita      Tempo passado na missão         Nº de vezes que entrou        ',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Monteserrat',
                            letterSpacing: 2,
                            fontSize: 15),
                      ),
                      Text(
                        (mission.type == "Video")
                            ? "Nº de vezes que não esteve atento"
                            : "",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Monteserrat',
                            letterSpacing: 2,
                            fontSize: 15),
                      )
                    ])),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30, top: 10, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
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
                  height: (170 * alunos.length.toDouble()),
                  child: Row(children: [
                    Expanded(
                      child: new ListView.separated(
                        itemBuilder: (context, int index) {
                          return Column(children: [
                            Container(
                                height: 150,
                                color: Colors.white,
                                child: Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 30),
                                    child: Container(
                                      height: 100,
                                      width: 170,
                                      child: Center(
                                        child: Text(
                                          alunos[index],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Monteserrat',
                                              letterSpacing: 2,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: new Builder(
                                        builder: (BuildContext) => results[
                                                alunos[index]]['done']
                                            ? Container(
                                                height: 80,
                                                width: 130,
                                                child: Center(
                                                  child: Text("Feita",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Monteserrat',
                                                          letterSpacing: 2,
                                                          fontSize: 20)),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.green[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
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
                                              )
                                            : Container(
                                                height: 80,
                                                child: Center(
                                                  child: Text("Não feita",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Monteserrat',
                                                          letterSpacing: 2,
                                                          fontSize: 20)),
                                                ),
                                                width: 130,
                                                decoration: BoxDecoration(
                                                    color: Colors.red[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
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
                                              )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50.0),
                                    child: CircularPercentIndicator(
                                      radius: 130.0,
                                      animation: true,
                                      animationDuration: 2000,
                                      lineWidth: 20.0,
                                      startAngle: 45.0,
                                      percent: (results[alunos[index]]
                                                      ['timeVisited'] /
                                                  60)
                                              .round() /
                                          120,
                                      center: new Text(
                                          ((results[alunos[index]]
                                                              ['timeVisited'] /
                                                          60)
                                                      .round())
                                                  .toString() +
                                              " min",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Monteserrat',
                                              letterSpacing: 2,
                                              fontSize: 20)),
                                      circularStrokeCap: CircularStrokeCap.butt,
                                      backgroundColor: Colors.grey[200],
                                      progressColor: parseColor("#E04C36"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 120.0),
                                    child: Text(
                                        "Entrou " +
                                            results[alunos[index]]
                                                    ["counterVisited"]
                                                .toString() +
                                            " vezes",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Monteserrat',
                                            letterSpacing: 2,
                                            fontSize: 20)),
                                  ),
                                  new Builder(
                                    builder: (BuildContext) => (mission.type ==
                                            "Video")
                                        ? Row(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 130.0),
                                              child: results[alunos[index]]
                                                      ['done']
                                                  ? Text(
                                                      results[alunos[index]][
                                                                  "counterPause"]
                                                              .toString() +
                                                          " vezes",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Monteserrat',
                                                          letterSpacing: 2,
                                                          fontSize: 20))
                                                  : Text(""),
                                            ),
                                            new Builder(
                                                builder: (BuildContext) =>
                                                    (results[alunos[index]]
                                                            ['done'])
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 30.0),
                                                            child: IconButton(
                                                              icon: Icon(
                                                                  FontAwesomeIcons
                                                                      .infoCircle),
                                                              iconSize: 25,
                                                              color:
                                                                  Colors.blue,
                                                              tooltip:
                                                                  'Informação',
                                                              onPressed: () {
                                                                _showInfo();
                                                              },
                                                            ),
                                                          )
                                                        : Container())
                                          ])
                                        : Container(),
                                  )
                                ]))
                          ]);
                        },
                        itemCount: alunos.length,
                        separatorBuilder: (context, int index) {
                          return Divider(height: 30, color: Colors.black12);
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  _showInfo() {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateBlueRocket,
    );

    Widget cancelaButton = FlatButton(
      child: Text(
        "Ok",
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

    popup.show(
      title: Text(
        "EyeTracking",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 4,
            fontSize: 20),
      ),
      content: Center(
        child: Text(
          "Este número corresponde ao número de vezes que o nosso senstor detetou que a criança estava desatenta, não estando a olhar para o ecrã do dispositivo.",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Monteserrat',
              letterSpacing: 2,
              fontSize: 15),
        ),
      ),
      actions: [
        cancelaButton,
      ],
    );
  }
}
