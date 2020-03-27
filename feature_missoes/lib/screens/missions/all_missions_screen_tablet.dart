import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guia_pa_feature_missoes/models/mission_text.dart';
import 'package:guia_pa_feature_missoes/notifiers/missions_notifier.dart';
import 'package:provider/provider.dart';
import 'package:guia_pa_feature_missoes/widgets/app drawer/app_drawer.dart';
import 'package:guia_pa_feature_missoes/api/missions_api.dart';
import './mission_screen.dart';
import 'package:guia_pa_feature_missoes/models/mission.dart';

///////// VISTA TABLET PORTRAIT

class AllMissionsTabletPortrait extends StatefulWidget {
  @override
  _AllMissionsTabletPortraitState createState() =>
      _AllMissionsTabletPortraitState();
}

class _AllMissionsTabletPortraitState extends State<AllMissionsTabletPortrait> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    MissionsNotifier missionsNotifier =
        Provider.of<MissionsNotifier>(context, listen: false);
    getMissions(missionsNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    double _completada;

    String _imagem;

    Future<void> _refreshList() async {
      print('refresh');
      getMissions(missionsNotifier);
    }

    return Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        body: new RefreshIndicator(
          onRefresh: _refreshList,
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                Mission mission = missionsNotifier.missionsList[index];

                if (mission.done == true)
                  _completada = 0;
                else if (mission.done == false) _completada = 0.6;

                if (mission.type == 'Text')
                  _imagem = 'assets/images/texto.png';
                else if (mission.type == 'Audio')
                  _imagem = 'assets/images/audio.png';
                else if (mission.type == 'Video')
                  _imagem = 'assets/images/video.png';
                else if (mission.type == 'Quiz')
                  _imagem = 'assets/images/quiz.png';
                else if (mission.type == 'Activity')
                  _imagem = 'assets/images/atividade.png';
                else if (mission.type == 'Upload')
                  _imagem = 'assets/images/upload.png';
                else if (mission.type == 'Image')
                  _imagem = 'assets/images/image.png';

                return Stack(children: [
                  Container(
                      height: 260,
                      decoration: BoxDecoration(
                          image: new DecorationImage(
                            image: ExactAssetImage(_imagem),
                            colorFilter: new ColorFilter.mode(
                                Colors.white.withOpacity(_completada),
                                BlendMode.dstATop),
                            fit: BoxFit.fitHeight,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow,
                              blurRadius: 4.0,
                            )
                          ]),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 90),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      mission.title,
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontFamily: 'Amatic SC',
                                          letterSpacing: 4),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, right: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  iconSize: 60,
                                  color: Colors.yellow,
                                  tooltip: 'Passar para a missão',
                                  onPressed: () {
                                    setState(() {
                                      _navegarParaMissao(context, mission);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ]);
              },
              itemCount: missionsNotifier.missionsList.length,
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
