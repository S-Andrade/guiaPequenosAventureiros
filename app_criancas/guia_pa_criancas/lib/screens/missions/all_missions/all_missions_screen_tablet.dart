import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:app_criancas/widgets/color_loader_5.dart';
import 'package:flare_flutter/flare_actor.dart';
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
import 'package:provider/provider.dart';
import 'package:delayed_display/delayed_display.dart';

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
  List<Mission> _missionListNotDone = [];
  List<Mission> _missionListDone = [];
  List<Mission> missionListFinal = [];

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

  getMissoesOrdenadas(List<Mission> missons) {
    _missionListNotDone = [];
    _missionListDone = [];
    missons.forEach((mission) {
      bool missionDone = false;
      for (var a in mission.resultados) {
        if (a["aluno"] == _userID) {
          missionDone = a["done"];
        }
      }

      if (missionDone == false) {
        _missionListNotDone.add(mission);
      } else {
        _missionListDone.add(mission);
      }
      setState(() {
        missionListFinal = _missionListNotDone + _missionListDone;
      });
    });
  }

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  @override
  Widget build(BuildContext context) {
    print(missionListFinal.toString());
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
//    print(screenHeight);
//    print(screenWidth);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
//      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));

    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    getMissoesOrdenadas(missionsNotifier.missionsList);
    double _completada;
    String _imagem;
    flag = false;

    if (missoes.length == missionListFinal.length) {
      setState(() {
        flag = true;
      });
    }

    Future<void> _refreshList() async {
      print('refresh');
      getMissions(missionsNotifier, missoes, _userID);
      getMissoesOrdenadas(missionsNotifier.missionsList);
      print(missionListFinal.toString());
    }

    if (flag) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/images/background_sky2.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            )),
        child: Scaffold(
            extendBody: true,
            bottomNavigationBar: BottomBar(1, missionNotifier.currentAventura),
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
                      fontSize: screenWidth > 800 ? 30 : 24,
                      color: Color(0xFF30246A)),
                ),
              ),
            ),
            key: _scaffoldKey,
            body: Stack(
              children: <Widget>[
                Scrollbar(
                  child: RefreshIndicator(
                    onRefresh: _refreshList,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                                bottom: screenHeight > 1000
                                    ? screenHeight / 4
                                    : 170,
                                top: screenHeight > 1000
                                    ? screenHeight / 5.5
                                    : 120),
                            itemBuilder: (BuildContext context, int index) {
                              Mission mission = missionListFinal[index];
                              for (var a in mission.resultados) {
                                if (a["aluno"] == _userID) {
                                  resultados = a;
                                  _done = resultados["done"];
                                }
                              }

                              if (_done == true)
                                _completada = 0.5;
                              else if (_done == false) _completada = 1;

                              if (mission.type == 'Text')
                                _imagem = 'assets/images/background.png';
                              else if (mission.type == 'Audio')
                                _imagem = 'assets/images/audio_back.png';
                              else if (mission.type == 'Video')
                                _imagem = 'assets/images/movie.png';
                              else if (mission.type == 'Quiz')
                                _imagem = 'assets/images/quiz3.png';
                              else if (mission.type == 'Questionario')
                                _imagem = 'assets/images/green_question.png';
                              else if (mission.type == 'Activity')
                                _imagem = 'assets/images/yellow2.png';
                              else if (mission.type == 'UploadVideo')
                                _imagem = 'assets/images/green.png';
                              else if (mission.type == 'UploadImage')
                                _imagem = 'assets/images/green.png';
                              else if (mission.type == 'Image')
                                _imagem = 'assets/images/grass_green.png';

                              return Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      screenWidth > 800 ? screenWidth / 8 : 20,
                                  right:
                                      screenWidth > 800 ? screenWidth / 8 : 20,
                                  top: screenWidth > 800
                                      ? 16
                                      : screenHeight < 700 ? 8 : 10,
                                  bottom: screenWidth > 800
                                      ? 16
                                      : screenHeight < 700 ? 8 : 10,
                                ),
                                child: DelayedDisplay(
                                  delay: Duration(milliseconds: 600),
                                  fadingDuration:
                                      const Duration(milliseconds: 800),
                                  slidingBeginOffset: const Offset(0, 0.0),
                                  child: Container(
                                      key: UniqueKey(),
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
                                        borderRadius:
                                            BorderRadius.circular(16.0),
//                                      boxShadow: [
//                                        BoxShadow(
//                                          color: Colors.black.withOpacity(0.1),
//                                          blurRadius:
//                                              2.0, // has the effect of softening the shadow
//                                          spreadRadius:
//                                              2.0, // has the effect of extending the shadow
//                                          offset: Offset(
//                                            0.0, // horizontal
//                                            3, // vertical
//                                          ),
//                                        )
//                                      ]
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: screenWidth > 800 ? 30 : 20,
                                            right: screenWidth > 800 ? 30 : 20,
                                            top: screenWidth > 800
                                                ? 30
                                                : screenHeight < 700
                                                    ? 16
                                                    : 20.0,
                                            bottom: screenWidth > 800
                                                ? 30
                                                : screenHeight < 700
                                                    ? 12
                                                    : 20.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                      mission.type ==
                                                              'UploadVideo'
                                                          ? ' Carregar Vídeo '
                                                          : mission.type ==
                                                                  'UploadImage'
                                                              ? ' Carregar Imagem '
                                                              : mission.type ==
                                                                      'Audio'
                                                                  ? ' Áudio '
                                                                  : mission.type ==
                                                                          'Text'
                                                                      ? ' Mensagem '
                                                                      : mission.type ==
                                                                              'Quiz'
                                                                          ? ' Quiz '
                                                                          : mission.type == 'Activity'
                                                                              ? ' Actividade '
                                                                              : mission.type == 'Video' ? ' Vídeo ' : mission.type == 'Questionario' ? ' Questionário ' : mission.type == 'Image' ? ' Imagem ' : mission.type,
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        textStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize:
                                                                screenWidth >
                                                                        800
                                                                    ? 20
                                                                    : 14,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  mission.points.toString() +
                                                      ' pontos',
                                                  style: GoogleFonts.quicksand(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize:
                                                            screenWidth > 800
                                                                ? 22
                                                                : 16,
                                                        color: Colors.yellow),
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    mission.title,
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: screenWidth >
                                                                  800
                                                              ? 28
                                                              : screenHeight <
                                                                      700
                                                                  ? 20
                                                                  : 22,
                                                          color: Colors.black),
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                new Builder(
                                                  builder: (BuildContext
                                                          context) =>
                                                      _done
                                                          ? IconButton(
                                                              icon: Icon(
                                                                  FontAwesomeIcons
                                                                      .redo),
                                                              iconSize: 20,
                                                              color:
                                                                  Colors.white,
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
                                ),
                              );
                            },
                            itemCount: missoes.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: FractionallySizedBox(
                      widthFactor: screenHeight < 700
                          ? 0.8
                          : screenWidth > 800 ? 0.77 : 0.9,
                      heightFactor: screenHeight < 700
                          ? 0.14
                          : screenHeight < 1000 ? 0.14 : 0.20,
                      child: Stack(
                        children: [
                          FlareActor(
                            "assets/animation/dialog.flr",
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.center,
//                        controller: _controller,
                            artboard: 'Artboard',
                            animation: 'open_dialog',
                          ),
                          Center(
                            child: DelayedDisplay(
                              delay: Duration(seconds: 1),
                              fadingDuration: const Duration(milliseconds: 800),
                              slidingBeginOffset: const Offset(0, 0.0),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: screenHeight > 1000
                                        ? 40
                                        : screenHeight < 700 ? 16 : 20.0,
                                    left: screenHeight > 1000
                                        ? 130
                                        : screenHeight < 700 ? 60 : 100),
                                child: Text(
                                  "Aqui estou a dizer algo mesmo muito pertinente",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.pangolin(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: screenHeight < 700
                                            ? 16
                                            : screenHeight < 1000 ? 20 : 32,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: DelayedDisplay(
//                          delay: Duration(seconds: 1),
                          fadingDuration: const Duration(milliseconds: 800),
//                          slidingBeginOffset: const Offset(-0.5, 0.0),
                          child: CompanheiroAppwide())),
                ),
                Positioned(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: 0.25,
                      child: Container(
//                        height: 130,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(
                              'assets/images/clouds_bottom_navigation_white.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      );
    } else {
      return ColorLoader5();
    }
  }

  _navegarParaMissao(BuildContext context, Mission mission) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MissionScreen(mission)),
    );
  }
}
