import 'dart:async';
import 'package:app_criancas/widgets/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../auth.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

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
    chewieDemo =  ChewieDemo(link: mission.linkVideo);
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

      availableCameras().then((cameras){
        CameraDescription camera = cameras.last;
          _cameracontroller = CameraController(
          camera,
          ResolutionPreset.medium,
          );
        _initializeControllerFuture = _cameracontroller.initialize();
        timer = Timer.periodic(Duration(seconds: 5), (Timer t) => checkForFace());
      }); 
    
    if(_counterPause == null){
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
    updateMissionTimeAndCounterVisitedInFirestoreVideo(
        mission, _userID, _timeVisited, _counterVisited, _counterPause);
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
//      decoration: BoxDecoration(
//        gradient: LinearGradient(
//          begin: Alignment.topLeft,
//          end: Alignment.bottomCenter,
//          stops: [0.0, 1.0],
//          colors: [
//            Color(0xFFFCF477),
//            Color(0xFFF6A51E),
//          ],
//        ),
//      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Video",
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
        body: Stack(children: [
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
          Positioned(
              child: Center(
            child: FractionallySizedBox(
              heightFactor: 0.8,
              child: Column(
                children: [
                  Text(
                    mission.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 36,
                          color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: chewieDemo,
                  ),
                  FlatButton(
                    child: setButton(),
                    onPressed: () {
                      setState(() {
                        _state = 1;
                        _loadButton();
                      });
                    },
                    color: Color(0xFFF3C463),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                  ),
                  //AQUI É ONDE APARECE OS RESULTADOS
                  Text(resultado.toString())
                ],
              ),
            ),
          )),
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
              ),),
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
          ),),
      );
    }
  }

  void _loadButton() {
    if (_done == true) {
      print('back');
      Navigator.pop(context);
    } else {
      Timer(Duration(milliseconds: 3000), () {
        updateMissionDoneInFirestore(mission, _userID);
        Navigator.pop(context);
      });
    }
  }

   void checkForFace() async{
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

  void getResult(String imagePath) async{
    final File imageFile = File(imagePath);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
        enableLandmarks: true,
        enableClassification: true
        ));
    final List<Face> faces = await faceDetector.processImage(visionImage);
   /* print(faces);
    setState(() {
      carinhas = faces.length;
    });*/

    if(faces.length == 0){
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


        if((-20 <= olhoesquerdox && olhoesquerdox <= 500) 
          && (0 <= olhoesquerdoy && olhoesquerdoy <= 650)
          && (50 <= olhodireitox && olhodireitox <= 700)
          && (0 <= olhodireitoy && olhodireitoy <= 650)
          && (-50 <= cabecay && cabecay <= 50)
          && (-100 <= cabecaz && cabecaz <= 100)
          && (0 <= narizx && narizx <= 700)
          && (0 <= narizy && narizy <= 700)){
            setState(() {
              resultado.add(true); 
            });
        }else{
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