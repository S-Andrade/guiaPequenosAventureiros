import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
  

class Timing extends StatefulWidget {

  final CameraDescription camera;

  const Timing({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  _Timing createState() => _Timing();
}

class _Timing extends State<Timing> {

  Timer timer;

  List<bool> resultado = [];

  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();

    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => checkForFace());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          return Scaffold(
            body: Column(children: <Widget>[
              Container(
                height: 500,
                width: 500,
                child: CameraPreview(_controller)
              ),
              Text(resultado.toString()),
            ],) 
          );
        }));}

  void checkForFace() async{
      try {
            await _initializeControllerFuture;

            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            await _controller.takePicture(path);

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
      resultado.add(false);
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
            resultado.add(false);
          });
        }

    }

    faceDetector.close();


  }

}