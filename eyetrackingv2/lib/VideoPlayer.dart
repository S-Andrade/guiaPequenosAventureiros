import 'package:video_player/video_player.dart';

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
  



class VideoPlayerTiming extends StatefulWidget {

  final CameraDescription camera;

  const VideoPlayerTiming({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  _VideoPlayerTiming createState() => _VideoPlayerTiming();
}

class _VideoPlayerTiming extends State<VideoPlayerTiming> {

  VideoPlayerController _videocontroller;
  Future<void> _initializeVideoPlayerFuture;

  Timer timer;

  List<bool> resultado = [];

  CameraController _cameracontroller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _videocontroller = VideoPlayerController.network('https://firebasestorage.googleapis.com/v0/b/guia-pa-bc0b3.appspot.com/o/bed.mp4?alt=media&token=cf7300d4-452f-489f-9083-02583f240701');
    _initializeVideoPlayerFuture = _videocontroller.initialize();

    _cameracontroller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _cameracontroller.initialize();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => checkForFace());


  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
    _videocontroller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: 
               Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 50, right: 30),
              child: Container(
                height: 600,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue,
                        blurRadius: 10.0,
                      )
                    ]),
                child: Column(children: [
                    Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AspectRatio(
                          aspectRatio: _videocontroller.value.aspectRatio,
                          child: VideoPlayer(_videocontroller),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.green[200],
                    onPressed: () {
                      setState(() {
                        if (_videocontroller.value.isPlaying) {
                          _videocontroller.pause();
                        } else {
                          _videocontroller.play();
                        }
                      });
                    },
                    child: Icon(
                      _videocontroller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                  Text(resultado.toString())
                ])
                
                
                
                ),
              ),
            ),
    ));
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
        if (_videocontroller.value.isPlaying) {
          _videocontroller.pause();
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
            if (_videocontroller.value.isPlaying) {
              _videocontroller.pause();
            }
            resultado.add(false);
          });
        }

    }

    faceDetector.close();


  }
}