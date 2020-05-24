import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth.dart';
import '../../../bottom_navigation_bar.dart';
import '../../../models/mission.dart';
import '../../../notifier/missions_notifier.dart';
import '../specific_mission/mission_screen.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_parser.dart';
import '../../../widgets/color_loader.dart';
import 'package:provider/provider.dart';

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
  bool flag;

  _AllMissionsTabletPortraitState(this.missoes);

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
//      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));

    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    double _completada;
    String _imagem;
    flag = false;

    if (missoes.length == missionsNotifier.missionsList.length) {
      setState(() {
        flag = true;
      });
    }

    Future<void> _refreshList() async {
      print('refresh');
      getMissions(missionsNotifier, missoes, _userID);
    }

    if (flag) {
      return Container(
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//            stops: [0.0, 1.0],
//            colors: [
//              Color(0xFF62D7A2),
//              Color(0xFF00C9C9),
//            ],
//          ),
//        ),
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            begin: Alignment.topLeft,
//            end: Alignment.bottomCenter,
//            stops: [0.0, 1.0],
//            colors: [
//              Color(0xFFFCF477),
//              Color(0xFFF6A51E),
//            ],
//          ),
//        ),
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/images/.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            )),
        child: Scaffold(
//          extendBody: true,
            bottomNavigationBar: BottomBar(1,missionNotifier.currentAventura),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Color(0xFF30246A), //change your color here
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                "As tuas missões",
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Color(0xFF30246A)),
                ),
              ),
            ),
            key: _scaffoldKey,
            body: Stack(
              children: <Widget>[
                RefreshIndicator(
                  onRefresh: _refreshList,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                              padding: EdgeInsets.symmetric(vertical:130),
                              itemBuilder: (BuildContext context, int index) {
                                Mission mission =
                                    missionsNotifier.missionsList[index];
                                for (var a in mission.resultados) {
                                  if (a["aluno"] == _userID) {
                                    resultados = a;
                                    _done = resultados["done"];
                                  }
                                }

                                if (_done == true)
                                  _completada = 0.4;
                                else if (_done == false) _completada = 1;

                                if (mission.type == 'Text')
                                  _imagem = 'assets/images/background.png';
                                else if (mission.type == 'Audio')
                                  _imagem = 'assets/images/audio.png';
                                else if (mission.type == 'Video')
                                  _imagem = 'assets/images/movie.png';
                                else if (mission.type == 'Quiz')
                                  _imagem = 'assets/images/quiz3.png';
                                else if (mission.type == 'Questionario')
                                  _imagem = 'assets/images/green_question.png';
                                else if (mission.type == 'Activity')
                                  _imagem = 'assets/images/yellow2.png';
                                else if (mission.type == 'UploadVideo')
                                  _imagem = 'assets/images/upload.png';
                                else if (mission.type == 'UploadImage')
                                  _imagem = 'assets/images/green.png';
                                else if (mission.type == 'Image')
                                  _imagem = 'assets/images/grass_green.png';

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: Container(
                                      key: UniqueKey(),
                                      height: 120,
                                      decoration: BoxDecoration(
                                          image: new DecorationImage(
                                            image: ExactAssetImage(_imagem),
                                            colorFilter: new ColorFilter.mode(
                                                Colors.white
                                                    .withOpacity(_completada),
                                                BlendMode.dstIn),
                                            fit: BoxFit.fitWidth,
                                            alignment: Alignment.center,
                                          ),
//                                      color: Color(0xFF01BBB6),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16.0),
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.black.withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Flexible(
                                                  child: Text(
                                                    mission.type,
                                                    style: GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    mission.title,
                                                    style: GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 22,
                                                          color: Colors.black),
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    'Pontos: '+mission.points.toString(),
                                                    style: GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 22,
                                                          color: Colors.black),
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                new Builder(
                                                  builder: (BuildContext context) =>
                                                      _done
                                                          ? IconButton(
                                                              icon: Icon(
                                                                  FontAwesomeIcons
                                                                      .redo),
                                                              iconSize: 20,
                                                              color: Colors.white,
                                                              tooltip:
                                                                  'Repetir a missão',
                                                              onPressed: () {
                                                                missionsNotifier
                                                                        .currentMission =
                                                                    mission;
                                                                setState(() {
                                                                  _navegarParaMissao(
                                                                      context,
                                                                      mission);
                                                                });
                                                              },
                                                            )
                                                          : IconButton(
                                                              icon: Icon(
                                                                  FontAwesomeIcons
                                                                      .arrowRight),
                                                              iconSize: 30,
                                                              color: parseColor(
                                                                  "#320a5c"),
                                                              tooltip:
                                                                  'Passar para a missão',
                                                              onPressed: () {
                                                                missionsNotifier
                                                                        .currentMission =
                                                                    mission;
                                                                setState(() {
                                                                  print(
                                                                      'aquiiiiii');
                                                                  _navegarParaMissao(
                                                                      context,
                                                                      mission);
                                                                });
                                                              },
                                                            ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              },
                              itemCount: missoes.length,
                            ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: Align
                    ( alignment: Alignment.topLeft,
                      child: CompanheiroAppwide()),
                ),
                Positioned(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/clouds_bottom_navigation_purple.png'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          )),
                    ),
                  ),
                ),

              ],
            )),
      );
    } else {
      return ColorLoader();
    }
  }

  _navegarParaMissao(BuildContext context, Mission mission) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MissionScreen(mission)),
    );
  }
}
