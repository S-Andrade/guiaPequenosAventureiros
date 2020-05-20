import 'dart:async';
import 'package:app_criancas/widgets/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../widgets/color_parser.dart';
import '../../../auth.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';


class VideoScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  VideoScreenTabletPortrait({this.mission});

  @override
  _VideoScreenTabletPortraitState createState() => _VideoScreenTabletPortraitState(mission);
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
                        _counterVisited=resultados["counterVisited"];
                        _timeVisited=resultados["timeVisited"];
                        _counterPause=resultados["counterPause"];
                      }
                    }
                  });
                });

    WidgetsBinding.instance.addObserver(this);
   
    _start=DateTime.now();

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
    _counterVisited=_counterVisited+1;
    _end = DateTime.now();
    _timeSpentOnThisScreen = _end.difference(_start).inSeconds;
    _timeVisited = _timeVisited + _timeSpentOnThisScreen;
    updateMissionTimeAndCounterVisitedInFirestore(
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back6.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          Stack(children: [
            Positioned(
              top: 90,
              left: 50,
              child: Row(children: [
                Text(
                  mission.title,
                  style: TextStyle(
                      fontSize: 70,
                      fontFamily: 'Amatic SC',
                      color: Colors.white,
                      letterSpacing: 4),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 250, right: 30),
              child: Container(
                height: 600,
                decoration: BoxDecoration(
                    color: parseColor("#320a5c"),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: parseColor("#320a5c"),
                        blurRadius: 10.0,
                      )
                    ]),
                child: chewieDemo,
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(70.0),
            child: MaterialButton(
                child: setButton(),
                onPressed: () {
                  setState(() {
                    _state = 1;
                    _loadButton();
                  });
                },
                height: 90,
                minWidth: 300,
                color: parseColor('#320a5c'),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0))),
          ),
          Text(resultado.toString()),
        ]),
      ),
    );
  }

  Widget setButton() {
    if (_done == false) {
      if (_state == 0) {
        return new Text(
          "okay",
          style: const TextStyle(
            fontFamily: 'Amatic SC',
            letterSpacing: 4,
            color: Colors.white,
            fontSize: 40.0,
          ),
        );
      } else
        return ColorLoader();
    } else {
      return new Text(
        "Feita",
        style: const TextStyle(
          fontFamily: 'Amatic SC',
          letterSpacing: 4,
          color: Colors.white,
          fontSize: 40.0,
        ),
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
      setState(() {
        if (chewieDemo.isPlaying()) {
          chewieDemo.pauseVideo();
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
