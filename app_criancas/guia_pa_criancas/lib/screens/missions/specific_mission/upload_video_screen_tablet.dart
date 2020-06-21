import 'dart:async';
import 'dart:io';
import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:app_criancas/services/recompensas_api.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../models/mission.dart';
import '../../../notifier/missions_notifier.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../widgets/color_parser.dart';
import 'package:provider/provider.dart';
import '../../../auth.dart';

class UploadVideoScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  UploadVideoScreenTabletPortrait(this.mission);

  @override
  _UploadVideoScreenTabletPortraitState createState() =>
      _UploadVideoScreenTabletPortraitState(mission);
}

class _UploadVideoScreenTabletPortraitState
    extends State<UploadVideoScreenTabletPortrait> {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  Mission mission;

  _UploadVideoScreenTabletPortraitState(this.mission);


  File _video;
  String _titulo;
  bool _loaded;
  var video;
  int _state = 0;

  String _userID;
  Map resultados;
  bool _done;


  // PIN PAD
  String currentText  = "";
  StreamController<ErrorAnimationType> errorController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool hasError = false;
  String errorMessage;


  @override
  void initState() {
    MissionsNotifier missionNotifier =
        Provider.of<MissionsNotifier>(context, listen: false);
    _loaded = false;
    Auth().getUser().then((user) {
      setState(() {
        _userID = user.email;
        for (var a in mission.resultados) {
          if (a["aluno"] == _userID) {
            resultados = a;
            _done = resultados["done"];
          }
        }
      });
    });
    super.initState();
  }

  Future getVideo() async {
    video = await ImagePicker.pickVideo(source: ImageSource.gallery);

    if (video != null)
      setState(() {
        _loaded = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    _titulo = 'upload_video_crianca_' + mission.id;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.blueAccent.withOpacity(0.5), BlendMode.darken),
          image: AssetImage("assets/images/59721.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          key: _scaffoldKey,
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: Color(0xFF30246A), //change your color here
            ),
            title: Text(
              'Carregar Vídeo',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Color(0xFF30246A)),
              ),
            ),
          ),
          body: Stack(children: <Widget>[
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
            Positioned.fill(
                child: Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                heightFactor: 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            mission.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenHeight < 700 ? 26 : 30,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            mission.content,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenHeight < 700 ? 18 : 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 2 Exp
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                      Expanded(
//                        child: Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Builder(
//                            builder: (BuildContext) => _loaded
//                                ? FlatButton(
//                                child: setButton(),
//                                onPressed: () {
//                                  setState(() {
//                                    _state = 1;
//                                    _loadButton();
//                                  });
//                                },
//                                padding: EdgeInsets.all(20),
//                                color: Color(0xFFEF6EA5),
//                                shape: RoundedRectangleBorder(
//                                    borderRadius:
//                                    BorderRadius.circular(
//                                        10.0)))
//                                : Container(),
//                          ),
//                        ),
//                      ),
                      Builder(
                          builder: (BuildContext) => _loaded
                              ? new Icon(
                                  FontAwesomeIcons.checkCircle,
                                  color: Colors.lightGreenAccent,
                                  size: 30.0,
                                )
                              : Container()),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Builder(
                              builder: (BuildContext) => _done
                                  ? FlatButton(
                                      padding: EdgeInsets.all(
                                          screenHeight < 700 ? 16 : 20),
                                      color: Color(0xFFEBECEC).withOpacity(0.8),
                                      disabledTextColor: Colors.grey,
                                      disabledColor:
                                          Color(0xFFEBECEC).withOpacity(0.8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Text(
                                        'Já carregado',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize:
                                                screenHeight < 700 ? 16 : 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      onPressed: () => _loadButton())
                                  : FlatButton(
                                      padding: EdgeInsets.all(
                                          screenHeight < 700 ? 16 : 20),
                                      color: Color(0xFF1e85e6),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Text(
                                        'Escolher',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize:
                                                screenHeight < 700 ? 16 : 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      onPressed: getVideo,
                                    )),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Builder(
                            builder: (BuildContext) => _loaded
                                ? FlatButton(
                                    child: setButton(),
                                    onPressed: () {
                                      setState(() {
                                        _state = 1;
                                        _loadButton();
                                      });
                                    },
                                    padding: EdgeInsets.all(
                                        screenHeight < 700 ? 16 : 20),
                                    color: Color(0xFF5de8c5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)))
                                : Container(),
//                                : FlatButton(
//                                disabledTextColor: Colors.grey,
//                                disabledColor: Color(0xFFEBECEC)
//                                    .withOpacity(0.8),
//                                child: setButton(),
//                                onPressed: null,
//                                padding: EdgeInsets.all(20),
//                                color: Color(0xFFEF6EA5),
//                                shape: RoundedRectangleBorder(
//                                    borderRadius:
//                                    BorderRadius.circular(
//                                        10.0))),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            )),
            Positioned(
              child: Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  widthFactor: screenHeight < 700 ? 0.8 : screenWidth > 800 ? 0.77 : 0.9,
                  heightFactor: screenHeight < 700 ? 0.14 : screenHeight < 1000 ? 0.13 : 0.20,
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
                            padding: EdgeInsets.only(left: screenHeight > 1000 ? 40 : screenHeight < 700 ? 16 : 20.0, right: screenHeight > 1000 ? 130 : screenHeight < 700 ? 60 : 100),
                            child: Text(
                              "Pede a um adulto para autorizar o carregamento",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.pangolin(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: screenHeight < 700 ? 16 : screenHeight < 1000 ? 20 : 32,
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
                  alignment: Alignment.topRight,
                  child: DelayedDisplay(
//                          delay: Duration(seconds: 1),
                      fadingDuration: const Duration(milliseconds: 800),
//                          slidingBeginOffset: const Offset(-0.5, 0.0),
                      child: CompanheiroAppwide())),
            ),
          ])),
    );
  }

  Widget setButton() {
    if (_done == false) {
      if (_state == 0) {
        return Text(
          "Carregar",
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenHeight < 700 ? 16 : 18,
              color: Colors.white,
            ),
          ),
        );
      } else
        return ColorLoader();
    } else {
      return Text(
        "Já carregado",
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: screenHeight < 700 ? 16 : 18,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  void _loadButton() {
    if (_done == true) {
      Timer(Duration(milliseconds: 500), () {
        Navigator.pop(context);
      });
    } else {
      enviarDialog();
    }
  }

  enviarDialog() {
    final TextEditingController _pin = TextEditingController();
    int _pinIntro = 0;

    TextEditingController pinController = TextEditingController();
    errorController = StreamController<ErrorAnimationType>();

    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text("Para enviar pede ajuda aos teus pais!",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF30246A)),
              ),
            ),
            content: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    '(Introduza o seu ano de nascimento para verificação)',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.black45),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: formKey,
                      child: PinCodeTextField(
                        length: 4,
                        obsecureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor:
                          hasError ? Colors.yellowAccent : Colors.white,
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: true,
                        errorAnimationController: errorController,
                        controller: pinController,
//                    onCompleted: (v) {
//                      print("Completed");
//                      print(currentText);
//                      print(currentText.runtimeType);
//                    },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            currentText = value;
                            _pinIntro = int.parse(currentText);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),

//                  child: SizedBox(
//                      width: double.infinity,
//                      child: TextField(
//                        controller: _pin,
//                        onChanged: (value) {
//                          setState(() {
//                            _pinIntro = int.parse(value);
//                          });
//                        },
//                        decoration: InputDecoration(
//                          contentPadding: EdgeInsets.all(10.0),
//                          hintText: "Insira o ano em que nasceu",
//                        ),
//                      )),
            ),
            actions: <Widget>[
              SizedBox(
                width: 100,
                child: FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  color: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  child: Text(
                    "Cancelar",
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize:  16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: FlatButton(
                  onPressed:() async {
                    List datas = await getUserInfoEEPaiMae(_userID);
                    if (datas.contains(_pinIntro)) {
                      Timer(Duration(milliseconds: 3000), () async {
                        _upload();
                        await updatePoints(_userID, mission.points);
                        Navigator.pop(context);
                      });
                      Navigator.pop(context);
                      setState(() {
                        _done = true;
                        _loadButton();
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "Verifique se inseriu o pin correto",
                          backgroundColor: Colors.black,
                          textColor: Colors.white);
                    }
                  },
                  color: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  child: Text(
                    "Enviar",
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize:  16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  //adiciona a pontuação e os cromos ao aluno e turma
  //melhorar frontend
  updatePoints(String aluno, int points) async {
    List cromos = await updatePontuacao(aluno, points);
    print("tellle");
    print(cromos);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
          ),
          child: AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              "Ganhas-te pontos",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    color: Colors.white),
              ),
            ),
            content: FractionallySizedBox(
              heightFactor: 0.3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "+$points",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 50,
                              color: Color(0xFFffcc00)),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          color: Color(0xFFEF807A),
                          child: new Text(
                            "Fechar",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    if (cromos[0] != []) {
      for (String i in cromos[0]) {
        Image image;

        await FirebaseStorage.instance
            .ref()
            .child(i)
            .getDownloadURL()
            .then((downloadUrl) {
          image = Image.network(
            downloadUrl.toString(),
            fit: BoxFit.scaleDown,
          );
        });

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            // retorna um objeto do tipo Dialog
            return Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
              child: AlertDialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text(
                  "Ganhas-te um cromo",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        color: Color(0xFFffcc00)),
                  ),
                ),
                content: FractionallySizedBox(
                  heightFactor: 0.6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          image,
                          SizedBox(
                            width: double.infinity,
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0)),
                              color: Color(0xFFEF807A),
                              child: new Text(
                                "Fechar",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    }
    if (cromos[1] != []) {
      for (String i in cromos[1]) {
        Image image;

        await FirebaseStorage.instance
            .ref()
            .child(i)
            .getDownloadURL()
            .then((downloadUrl) {
          image = Image.network(
            downloadUrl.toString(),
            fit: BoxFit.scaleDown,
          );
        });

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            // retorna um objeto do tipo Dialog
            return Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
              child: AlertDialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text(
                  "Ganhas-te um cromo\npara a turma",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        color: Color(0xFFffcc00)),
                  ),
                ),
                content: FractionallySizedBox(
                  heightFactor: 0.6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          image,
                          SizedBox(
                            width: double.infinity,
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0)),
                              color: Color(0xFFEF807A),
                              child: new Text(
                                "Fechar",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  _upload() async {
    if (video != null) {
      _video = video;
      addUploadedVideoToFirebaseStorage(_video, _titulo).then((value) =>
          {updateMissionDoneWithLinkInFirestore(mission, _userID, value)});
    }
  }
}
