import 'dart:async';
import 'dart:io';
import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:app_criancas/services/recompensas_api.dart';
import 'package:app_criancas/widgets/video_player.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../auth.dart';
import 'package:camera/camera.dart';

class VideoScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  VideoScreenTabletPortrait(this.mission);

  @override
  _VideoScreenTabletPortraitState createState() =>
      _VideoScreenTabletPortraitState(mission);
}

class _VideoScreenTabletPortraitState extends State<VideoScreenTabletPortrait>
    with WidgetsBindingObserver {
  Mission mission;

  _VideoScreenTabletPortraitState(this.mission);
  int _state = 0;

  String _userID;
  Map resultados;
  bool _done;
  int _timeSpentOnThisScreen;
  int _timeVisited;
  int _counterVisited;
  DateTime _paused;
  DateTime _returned;
  int _totalPaused;
  DateTime _start;
  DateTime _end;
  ChewieDemo chewieDemo;
  Timer timer;
  List<bool> resultado = [];
  CameraController _cameracontroller;
  Future<void> _initializeControllerFuture;
  int _counterPause;

  @override
  void initState() {
    chewieDemo = ChewieDemo(link: mission.linkVideo);
    Auth().getUser().then((user) {
      setState(() {
        _userID = user.email;
        for (var a in mission.resultados) {
          if (a["aluno"] == _userID) {
            resultados = a;
            _done = resultados["done"];
            _counterVisited = resultados["counterVisited"];
            _timeVisited = resultados["timeVisited"];
            _counterPause = resultados["counterPause"];
          }
        }
      });
    });

    WidgetsBinding.instance.addObserver(this);

    _start = DateTime.now();

    availableCameras().then((cameras) {
      CameraDescription camera = cameras.last;
      _cameracontroller = CameraController(
        camera,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _cameracontroller.initialize();
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) => checkForFace());
    });

    if (_counterPause == null) {
      _counterPause = 0;
    }

    super.initState();
  }

  AppLifecycleState state;

  @override
  void deactivate() {
    _counterVisited = _counterVisited + 1;
    _end = DateTime.now();
    _timeSpentOnThisScreen = _end.difference(_start).inSeconds;
    _timeVisited = _timeVisited + _timeSpentOnThisScreen;
    updateMissionTimeAndCounterVisitedInFirestore(
        mission, _userID, _timeVisited, _counterVisited);
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _paused = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      _returned = DateTime.now();
    }
    _totalPaused = _returned.difference(_paused).inSeconds;
    _timeVisited = _timeVisited - _totalPaused;
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/movie.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Ver Video",
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.black),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(alignment: Alignment.center, children: [
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
              heightFactor: 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      mission.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  ChewieDemo(
                    link: mission.linkVideo,
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                        padding: EdgeInsets.all(20),
                        child: setButton(),
                        onPressed: () {
                          setState(() {
                            _state = 1;
                            _loadButton(context);
                          });
                        },
                        color: Color(0xFFF3C463),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                      ),
                    ),
                  ),
                  //AQUI É ONDE APARECE OS RESULTADOS
                  //Alterar frontend
                  Text(resultado.toString())
                ],
              ),
            ),
          )),
          Positioned(
            child: Align(
              alignment: Alignment.topLeft,
              child: FractionallySizedBox(
                heightFactor: 0.15,
                widthFactor: 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black45.withOpacity(0.8),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(5))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Text(
                          "Vamos estar atentos para o quiz que vem ai...",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.pangolin(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: Align(
                alignment: Alignment.topRight, child: CompanheiroAppwide()),
          ),
        ]),
      ),
    );
  }

  Widget setButton() {
    if (_done == false) {
      if (_state == 0) {
        return new Text(
          "Okay",
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        );
      } else
        return ColorLoader();
    } else {
      return new Text(
        "Feita",
        style: GoogleFonts.quicksand(
          textStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  void _loadButton(BuildContext context) {
    if (_done == true) {
      print('back');
      Navigator.pop(context);
    } else {
      Timer(Duration(milliseconds: 3000), () async {
        updateMissionDoneInFirestore(mission, _userID);
        await updatePoints(_userID, mission.points, context);
        Navigator.pop(context);
      });
    }
  }

  //adiciona a pontuação e os cromos ao aluno e turma
  //melhorar frontend
  updatePoints(String aluno, int points, BuildContext context) async {
    List cromos = await updatePontuacao(aluno, points);
    print("tellle");
    print(cromos);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Ganhas-te pontos"),
          content: new Text("+$points"),
          actions: <Widget>[
            // define os botões na base do dialogo
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
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
            return AlertDialog(
              title: new Text("Ganhas-te um cromo para a tua caderneta"),
              content: image,
              actions: <Widget>[
                // define os botões na base do dialogo
                new FlatButton(
                  child: new Text("Fechar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
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
            return AlertDialog(
              title: new Text("Ganhas-te um cromo para a caderneta da turma"),
              content: image,
              actions: <Widget>[
                // define os botões na base do dialogo
                new FlatButton(
                  child: new Text("Fechar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  void checkForFace() async {
    try {
      await _initializeControllerFuture;

      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      await _cameracontroller.takePicture(path);

      getResult(path);
    } catch (e) {
      print(e);
    }
  }

  void getResult(String imagePath) async {
    final File imageFile = File(imagePath);
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(
        FaceDetectorOptions(
            mode: FaceDetectorMode.accurate,
            enableLandmarks: true,
            enableClassification: true));
    final List<Face> faces = await faceDetector.processImage(visionImage);
    /* print(faces);
    setState(() {
      carinhas = faces.length;
    });*/

    if (faces.length == 0) {
      print("helllllooooooooooooooooooooo");
      setState(() {
        if (chewieDemo.isPlaying()) {
          chewieDemo.pauseVideo();
          //O VIDEO PAROU AQUI
          _counterPause += 1;
        }
        resultado.add(false);
      });
    }

    for (Face face in faces) {
      //List olhos = [];
      var olhoesquerdo = face.getLandmark(FaceLandmarkType.leftEye).position;
      double olhoesquerdox = olhoesquerdo.dx;
      double olhoesquerdoy = olhoesquerdo.dy;
      var olhodireito = face.getLandmark(FaceLandmarkType.rightEye).position;
      double olhodireitox = olhodireito.dx;
      double olhodireitoy = olhodireito.dy;

      //olhos.add(olhoesquerdo);
      //olhos.add(olhodireito);

      //List<double> cabecorra = [];
      double cabecay = face.headEulerAngleY;
      double cabecaz = face.headEulerAngleZ;
      //cabecorra.add(cabecay);
      //cabecorra.add(cabecaz);

      var focinho = face.getLandmark(FaceLandmarkType.noseBase).position;
      double narizx = focinho.dx;
      double narizy = focinho.dy;

      /* setState(() {  
          olhinhos.add(olhos);
          cabeca.add(cabecorra);
          nariz.add(focinho);
        });*/

      if ((-20 <= olhoesquerdox && olhoesquerdox <= 500) &&
          (0 <= olhoesquerdoy && olhoesquerdoy <= 650) &&
          (50 <= olhodireitox && olhodireitox <= 700) &&
          (0 <= olhodireitoy && olhodireitoy <= 650) &&
          (-50 <= cabecay && cabecay <= 50) &&
          (-100 <= cabecaz && cabecaz <= 100) &&
          (0 <= narizx && narizx <= 700) &&
          (0 <= narizy && narizy <= 700)) {
        setState(() {
          resultado.add(true);
        });
      } else {
        setState(() {
          if (chewieDemo.isPlaying()) {
            chewieDemo.pauseVideo();
            //O VIDEO PAROU AQUI
            _counterPause += 1;
          }
          resultado.add(false);
        });
      }
    }

    faceDetector.close();

    print(resultado);
  }
}
