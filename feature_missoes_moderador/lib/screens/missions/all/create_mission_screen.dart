import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/tab/tab.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/models/mission.dart';
import 'package:feature_missoes_moderador/notifier/missions_notifier.dart';
import 'package:feature_missoes_moderador/screens/missions/all/choose_mission_sreen.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CreateMissionScreen extends StatefulWidget {
  
  Capitulo capitulo;
 String aventuraId;

  CreateMissionScreen({this.capitulo,this.aventuraId});

  @override
  _CreateMissionScreenState createState() =>
      _CreateMissionScreenState(capitulo: capitulo,aventuraId:aventuraId);
}

class _CreateMissionScreenState extends State<CreateMissionScreen> {
  
  String aventuraId;
  bool _missoes;
  Capitulo capitulo;
  List<Mission> missions;


  _CreateMissionScreenState({this.capitulo,this.aventuraId});

  @override
  void initState() {

    
     MissionsNotifier missionsNotifier =
        Provider.of<MissionsNotifier>(context, listen: false);
    getMissions(missionsNotifier,capitulo.missoes);
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

    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    String _imagem;

    Future<void> _refreshList() async {
      print("refresh");
   _getCurrentCapitulo(capitulo.id).then((dynamic) => {
       getMissions(missionsNotifier,capitulo.missoes)
    
    });
    }

    
    if (missionsNotifier.missionsList != []) {
      setState(() {
        _missoes = true;
      });
    } else {
      setState(() {
        _missoes = false;
      });
    }
  

    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back11.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Missões",
                  style: TextStyle(
                      fontSize: 25, fontFamily: 'Amatic SC', letterSpacing: 4, fontWeight: FontWeight.w900),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    height: 470,
                    width: 700,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: parseColor("#320a5c"),
                            blurRadius: 10.0,
                          )
                        ]),
                    child: new RefreshIndicator(
                        onRefresh: _refreshList,
                        child: new Builder(
                          builder: (BuildContext) => _missoes
                              ? new ListView.separated(
                                  itemBuilder: (context, int index) {
                                    Mission mission =
                                        missionsNotifier.missionsList[index];

                                    if (mission.type == 'Text')
                                      _imagem = 'assets/images/text.png';
                                    else if (mission.type == 'Audio')
                                      _imagem = 'assets/images/audio.png';
                                    else if (mission.type == 'Video')
                                      _imagem = 'assets/images/video.png';
                                    else if (mission.type == 'Quiz')
                                      _imagem = 'assets/images/quiz.png';
                                    else if (mission.type == 'Activity')
                                      _imagem = 'assets/images/atividade.png';
                                    else if (mission.type == 'UploadVideo')
                                      _imagem = 'assets/images/upload.png';
                                    else if (mission.type == 'UploadImage')
                                      _imagem = 'assets/images/upload.png';
                                    else if (mission.type == 'Image')
                                      _imagem = 'assets/images/image.png';
                                    else if (mission.type == 'Questionario')
                                      _imagem = 'assets/images/quiz.png';

                                    return Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Container(
                                            key: UniqueKey(),
                                            height: 160,
                                            decoration: BoxDecoration(
                                                image: new DecorationImage(
                                                  image:
                                                      ExactAssetImage(_imagem),
                                                  colorFilter:
                                                      new ColorFilter.mode(
                                                          Colors.white
                                                              .withOpacity(0.8),
                                                          BlendMode.dstIn),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        parseColor("#320a5c"),
                                                    blurRadius: 10.0,
                                                  )
                                                ]),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 30),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Center(
                                                          child: Text(
                                                            mission.title,
                                                            style: TextStyle(
                                                                fontSize: 45,
                                                                fontFamily:
                                                                    'Amatic SC',
                                                                letterSpacing:
                                                                    4),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                                Row(children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 500),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        IconButton(
                                                          icon: Icon(
                                                              FontAwesomeIcons
                                                                  .arrowRight),
                                                          iconSize: 40,
                                                          color: parseColor(
                                                              "#320a5c"),
                                                          tooltip:
                                                              'Passar para a missão',
                                                          onPressed: () {
                                                            setState(() {
                                                              _navegarParaMissao(
                                                                  context,
                                                                  mission);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        IconButton(
                                                          icon: Icon(
                                                              FontAwesomeIcons
                                                                  .trash),
                                                          iconSize: 40,
                                                          color: parseColor(
                                                              "#320a5c"),
                                                          tooltip:
                                                              'Passar para a missão',
                                                          onPressed: () {
                                                            setState(() {
                                                              _remover(mission);
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
                                  itemCount:
                                      missionsNotifier.missionsList.length,
                                  separatorBuilder: (context, int index) {
                                    return Divider(
                                        height: 30, color: Colors.black12);
                                  },
                                )
                              : Container(
                                  height: 470,
                                  width: 700,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: parseColor("#320a5c"),
                                          blurRadius: 10.0,
                                        )
                                      ]),
                                  child: Center(
                                    child: new Text(
                                      "Ainda não há missões configuradas",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: 'Amatic SC',
                                          letterSpacing: 4),
                                    ),
                                  )),
                        ))),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(FontAwesomeIcons.plus),
                      iconSize: 50,
                      color: parseColor("#320a5c"),
                      tooltip: 'Passar para a missão',
                      onPressed: () {
                        setState(() {
                          _navegarParaEscolherMissao(context);
                        });
                      },
                    ),
                    
                  ]),
            ],
          ),
        ));
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
      MaterialPageRoute(builder: (context) => ChooseMissionScreen(aventuraId:aventuraId,capitulo:capitulo)),
    );
  }

 

  _remover(Mission mission) {
    print("AAAAAAAA:"+mission.id);
    Widget cancelaButton = FlatButton(
      child: Text(
        "Cancelar",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget continuaButton = FlatButton(
      child: Text(
        "Sim",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      onPressed: () {
        deleteMissionInFirestore(mission,capitulo.id);
       Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (_) => TabBarMissions(
                capitulo: capitulo, aventuraId: aventuraId)));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Confirmação",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      content: Text(
        "Tem a certeza que pretende remover a missão?",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );

    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
