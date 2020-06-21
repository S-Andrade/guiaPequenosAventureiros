import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo_details.dart';
import 'package:feature_missoes_moderador/screens/tab/tab.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/models/mission.dart';
import 'package:feature_missoes_moderador/notifier/missions_notifier.dart';
import 'package:feature_missoes_moderador/screens/missions/all/choose_mission_sreen.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:feature_missoes_moderador/widgets/popupConfirm.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:feature_missoes_moderador/screens/aventura/aventura.dart';

class CreateMissionScreen extends StatefulWidget {
  Capitulo capitulo;
  Aventura aventura;

  CreateMissionScreen({this.capitulo, this.aventura});

  @override
  _CreateMissionScreenState createState() =>
      _CreateMissionScreenState(capitulo: capitulo, aventura: aventura);
}

class _CreateMissionScreenState extends State<CreateMissionScreen> {
  Aventura aventura;

  Capitulo capitulo;
  List<Mission> missions;

  _CreateMissionScreenState({this.capitulo, this.aventura});

  @override
  void initState() {
    if (capitulo.missoes.length != 0) {
      MissionsNotifier missionsNotifier =
          Provider.of<MissionsNotifier>(context, listen: false);
      getMissions(missionsNotifier, capitulo.missoes);
    } else
      print("vazio");
    super.initState();
    
  }

  _getCurrentCapitulo(capituloId) async {
    DocumentReference documentReference =
        Firestore.instance.collection("capitulo").document(capituloId);
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        setState(() {
          capitulo = new Capitulo(
              id: datasnapshot.data['id'] ?? '',
              bloqueado: datasnapshot.data['bloqueado'] ?? null,
              missoes: datasnapshot.data['missoes'] ?? []);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MissionsNotifier missionsNotifier;
    missionsNotifier = Provider.of<MissionsNotifier>(context);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    String _imagem;

    Future<void> _refreshList() async {
      print("refresh");
      _getCurrentCapitulo(capitulo.id)
          .then((dynamic) => {getMissions(missionsNotifier, capitulo.missoes)});
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
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
                          "Missões Configuradas",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 50,
                              fontFamily: 'Amatic SC',
                              letterSpacing: 4),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ])),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    height: 900,
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
                            padding: const EdgeInsets.only(left:20.0,right:20,top:100,bottom:50),
                            child: Text(
                                "Missões deste capítulo: " ,
                                   
                                style: TextStyle(
                                    fontSize: 20.0,
                                    letterSpacing: 2,
                                  
                                    color: Colors.black,
                                    fontFamily: 'Monteserrat')),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: new RefreshIndicator(
                              onRefresh: _refreshList,
                              child: Container(
                                  height: 500,
                                  width: 800,
                                  
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: new Builder(
                                      builder: (BuildContext) => (capitulo
                                                  .missoes.length !=
                                              0)
                                          ? new ListView.separated(
                                              itemBuilder: (context, int index) {
                                                Mission mission = missionsNotifier
                                                    .missionsList[index];

                                                if (mission.type == 'Text')
                                                  _imagem =
                                                      'assets/images/text.png';
                                                else if (mission.type == 'Audio')
                                                  _imagem =
                                                      'assets/images/audio.png';
                                                else if (mission.type == 'Video')
                                                  _imagem =
                                                      'assets/images/video.png';
                                                else if (mission.type == 'Quiz')
                                                  _imagem =
                                                      'assets/images/quiz.png';
                                                else if (mission.type ==
                                                    'Activity')
                                                  _imagem =
                                                      'assets/images/atividade.png';
                                                else if (mission.type ==
                                                    'UploadVideo')
                                                  _imagem =
                                                      'assets/images/upload.png';
                                                else if (mission.type ==
                                                    'UploadImage')
                                                  _imagem =
                                                      'assets/images/upload.png';
                                                else if (mission.type == 'Image')
                                                  _imagem =
                                                      'assets/images/image.png';
                                                else if (mission.type ==
                                                    'Questionario')
                                                  _imagem =
                                                      'assets/images/quiz.png';

                                                return Stack(children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(
                                                        20.0),
                                                    child: Container(
                                                        key: UniqueKey(),
                                                        height: 160,
                                                        decoration: BoxDecoration(
                                                            image:
                                                                new DecorationImage(
                                                              image:
                                                                  ExactAssetImage(
                                                                      _imagem),
                                                              colorFilter:
                                                                  new ColorFilter
                                                                          .mode(
                                                                      Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.8),
                                                                      BlendMode
                                                                          .dstIn),
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                            ),
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.2),
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
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 30),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    Center(
                                                                      child: Text(
                                                                        mission
                                                                            .title,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                25,
                                                                            fontFamily:
                                                                                'Monteserrat',
                                                                            letterSpacing:
                                                                                2),
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            650),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: <
                                                                      Widget>[
                                                                    IconButton(
                                                                      icon: Icon(
                                                                          FontAwesomeIcons
                                                                              .trash),
                                                                      iconSize:
                                                                          40,
                                                                      color: Colors
                                                                          .red,
                                                                      tooltip:
                                                                          'Remover missão',
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _remover(
                                                                              mission);
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ])
                                                          ],
                                                        )),
                                                  ),
                                                ]);
                                              },
                                              itemCount: missionsNotifier
                                                  .missionsList.length,
                                              separatorBuilder:
                                                  (context, int index) {
                                                return Divider(
                                                    height: 30,
                                                    color: parseColor("#FFCE02"));
                                              },
                                            )
                                          : ListView(children: [
                                              Container(
                                                  height: 260,
                                                  width: 700,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
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
                                                  child: Center(
                                                    child: new Text(
                                                      "Ainda não há missões configuradas",
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontFamily: 'Monteserrat',
                                                          letterSpacing: 4),
                                                    ),
                                                  )),
                                            ]),
                                    ),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(FontAwesomeIcons.plusCircle),
                                  iconSize: 80,
                                  color:parseColor("F4F19C"),
                                  tooltip: 'Adicionar missão nova',
                                  onPressed: () {
                                    setState(() {
                                      _navegarParaEscolherMissao(context);
                                    });
                                  },
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _navegarParaMissao(BuildContext context, Mission mission) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChooseMissionScreen()),
    );
  }

  _navegarParaEscolherMissao(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ChooseMissionScreen(aventura: aventura, capitulo: capitulo)),
    );
  }

  _remover(Mission mission) {
    final popup = BeautifulPopup.customize(
      context: context,
      build: (options) => MyTemplateConfirmation(options),
    );

    print("a remover missao");
    Widget cancelaButton = FlatButton(
      child: Text(
        "Cancelar",
        style: TextStyle(
            color: Colors.red,
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
      ),
      onPressed: () async {
        Navigator.pop(context);
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
          await deleteMissionInFirestore(mission, capitulo.id);
          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CapituloDetails(
                                    capitulo: capitulo, aventura: aventura)));
        });

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
      content: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Flexible(
          child: Text(
            "Tem a certeza que pretende remover a missão?",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Monteserrat',
                letterSpacing: 2,
                fontSize: 20),
          ),
        ),
      ]),
      actions: [
        continuaButton,
        cancelaButton,
      ],
    );
  }

  pedir_refresh(BuildContext context) {
    // configura o button

    // configura o  AlertDialog
    AlertDialog alerta = AlertDialog(
      title: Text(
        "Para ver as alterações feitas dê refresh!",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
    );

    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
    Timer(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}
