import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../auth.dart';
import '../../../models/mission.dart';
import '../../../notifier/missions_notifier.dart';
import '../specific_mission/mission_screen.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_parser.dart';
import 'package:provider/provider.dart';

///////// VISTA TABLET PORTRAIT

class AllMissionsTabletPortrait extends StatefulWidget {
  List missoes;
  AllMissionsTabletPortrait(this.missoes);

  @override
  _AllMissionsTabletPortraitState createState() =>
      _AllMissionsTabletPortraitState(missoes);
}

class _AllMissionsTabletPortraitState extends State<AllMissionsTabletPortrait> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List missoes;
  String _userID;
  Map resultados;
  bool _done;


  _AllMissionsTabletPortraitState(this.missoes);

  @override
  void initState() {
    Auth().getUser().then((user) {
      _userID = user.email;
    });
    _done = false;
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context, listen:false);
    getMissions(missionsNotifier, missoes, _userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    double _completada;
    String _imagem;

    Future<void> _refreshList() async {
      print('refresh');
      getMissions(missionsNotifier, missoes, _userID);
    }

    return new Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back6.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: new RefreshIndicator(
            onRefresh: _refreshList,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
               Mission mission = missionsNotifier.missionsList[index];
                for (var a in mission.resultados) {
                  if (a["aluno"] == _userID) {
                    resultados = a;
                    _done = resultados["done"];
                  }
                }

                if (_done == true)
                  _completada = 0.2;
                else if (_done == false) _completada = 0.8;

                if (mission.type == 'Text')
                  _imagem = 'assets/images/text.png';
                else if (mission.type == 'Audio')
                  _imagem = 'assets/images/audio.png';
                else if (mission.type == 'Video')
                  _imagem = 'assets/images/video.png';
                else if (mission.type == 'Quiz')
                  _imagem = 'assets/images/quiz.png';
                else if (mission.type == 'Questionario')
                  _imagem = 'assets/images/quiz.png';
                else if (mission.type == 'Activity')
                  _imagem = 'assets/images/atividade.png';
                else if (mission.type == 'UploadExample')
                  _imagem = 'assets/images/upload.png';
                else if (mission.type == 'UploadImage')
                  _imagem = 'assets/images/upload.png';
                else if (mission.type == 'Image')
                  _imagem = 'assets/images/image.png';

                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                          key: UniqueKey(),
                          height: 160,
                          decoration: BoxDecoration(
                              image: new DecorationImage(
                                image: ExactAssetImage(_imagem),
                                colorFilter: new ColorFilter.mode(
                                    Colors.white.withOpacity(_completada),
                                    BlendMode.dstIn),
                                fit: BoxFit.fitHeight,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: parseColor("#320a5c"),
                                  blurRadius: 10.0,
                                )
                              ]),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          mission.title,
                                          style: TextStyle(
                                              fontSize: 45,
                                              fontFamily: 'Amatic SC',
                                              letterSpacing: 4),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    new Builder(
                                      builder: (BuildContext context) => _done
                                          ? IconButton(
                                              icon: Icon(FontAwesomeIcons.redo),
                                              iconSize: 50,
                                              color: Colors.green[300],
                                              tooltip: 'Repetir a missão',
                                              onPressed: () {
                                                missionsNotifier.currentMission = mission;
                                                setState(() {
                                                  _navegarParaMissao(
                                                      context, mission);
                                                });
                                              },
                                            )
                                          : IconButton(
                                              icon: Icon(
                                                  FontAwesomeIcons.arrowRight),
                                              iconSize: 50,
                                              color: parseColor("#320a5c"),
                                              tooltip: 'Passar para a missão',
                                              onPressed: () {
                                                missionsNotifier.currentMission = mission;
                                                setState(() {
                                                  _navegarParaMissao(
                                                      context, mission);
                                                });
                                              },
                                            ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                   
                  ],
                );
              },
              itemCount: missoes.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(height: 70, color: Colors.black12);
              },
            ),
          ),
        ));
  }



  _navegarParaMissao(BuildContext context, Mission mission) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MissionScreen(mission)),
    );
  }
}

///////// VISTA TABLET LANDSCAPE

class AllMissionsTabletLandscape extends StatefulWidget {
  @override
  _AllMissionsTabletLandscapeState createState() =>
      _AllMissionsTabletLandscapeState();
}

class _AllMissionsTabletLandscapeState
    extends State<AllMissionsTabletLandscape> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        height: 30,
        width: 30,
      ),
    );
  }
}











///// MOBILE PORTRAIT
///
///
class AllMissionsMobilePortrait extends StatefulWidget {
  List missoes;
  AllMissionsMobilePortrait(this.missoes);

  @override
  _AllMissionsMobilePortraitState createState() =>
      _AllMissionsMobilePortraitState(missoes);
}

class _AllMissionsMobilePortraitState extends State<AllMissionsMobilePortrait> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  List missoes;
  String _userID;
  Map resultados;
  bool _done;
  _AllMissionsMobilePortraitState(this.missoes);

  @override
  void initState() {
    Auth().getUser().then((user) {
      _userID = user.email;
    });
    _done = false;
    MissionsNotifier missionsNotifier =
        Provider.of<MissionsNotifier>(context, listen: false);
    getMissions(missionsNotifier, missoes, _userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    double _completada;
    String _imagem;

    Future<void> _refreshList() async {
      print('refresh');
      getMissions(missionsNotifier, missoes, _userID);
    }

    return new Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back6.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: new RefreshIndicator(
            onRefresh: _refreshList,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                Mission mission = missionsNotifier.missionsList[index];

                for (var a in mission.resultados) {
                  if (a["aluno"] == _userID) {
                    resultados = a;
                    _done = resultados["done"];
                  }
                }

                if (_done == true)
                  _completada = 0.2;
                else if (_done == false) _completada = 0.8;

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
                else if (mission.type == 'UploadExample')
                  _imagem = 'assets/images/upload.png';
                else if (mission.type == 'UploadImage')
                  _imagem = 'assets/images/upload.png';
                else if (mission.type == 'Image')
                  _imagem = 'assets/images/image.png';

                return Stack(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                        key: UniqueKey(),
                        height: 80,
                        decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: ExactAssetImage(_imagem),
                              colorFilter: new ColorFilter.mode(
                                  Colors.white.withOpacity(_completada),
                                  BlendMode.dstIn),
                              fit: BoxFit.fitHeight,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: parseColor("#320a5c"),
                                blurRadius: 10.0,
                              )
                            ]),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        mission.title,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Amatic SC',
                                            letterSpacing: 4),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  new Builder(
                                    builder: (BuildContext context) => _done
                                        ? IconButton(
                                            icon: Icon(FontAwesomeIcons.redo),
                                            iconSize: 20,
                                            color: Colors.green[300],
                                            tooltip: 'Repetir a missão',
                                            onPressed: () {
                                              missionsNotifier.currentMission =
                                                  mission;
                                              setState(() {
                                                _navegarParaMissao(
                                                    context, mission);
                                              });
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(
                                                FontAwesomeIcons.arrowRight),
                                            iconSize: 20,
                                            color: parseColor("#320a5c"),
                                            tooltip: 'Passar para a missão',
                                            onPressed: () {
                                              missionsNotifier.currentMission =
                                                  mission;
                                              setState(() {
                                                _navegarParaMissao(
                                                    context, mission);
                                              });
                                            },
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                ]);
              },
              itemCount: missionsNotifier.missionsList.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(height: 10, color: Colors.black12);
              },
            ),
          ),
        ));
  }

  _navegarParaMissao(BuildContext context, Mission mission) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MissionScreen(mission)),
    );
  }
}
