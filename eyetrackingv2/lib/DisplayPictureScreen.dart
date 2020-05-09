import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
  


class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  _DisplayPictureScreen createState() => _DisplayPictureScreen(imagePath: imagePath);

}

class _DisplayPictureScreen extends State<DisplayPictureScreen>{

  final String imagePath;
  _DisplayPictureScreen({Key key, this.imagePath});

  bool isLoading = true;
  List<List> olhinhos =  [];
  int carinhas = 0 ;
  List<List<double>> cabeca = [];
  List nariz = [];
  bool ver = false;
  @override
  void initState(){
    super.initState();
    suminho();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
              appBar: AppBar(title: Text('Display the Picture')),
              // The image is stored as a file on the device. Use the `Image.file`
              // constructor with the given path to display the image.
              body: Column(children: <Widget>[
                Image.file(File(imagePath)),
                Text(carinhas.toString()),
                Text(olhinhos.toString()),
                Text(cabeca.toString()),
                Text(nariz.toString()),
                Text(ver.toString())
              ],) 
            );
 
  }

    

   Future<void> suminho() async {
    final File imageFile = File(imagePath);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
        enableLandmarks: true,
        enableClassification: true
        ));
    final List<Face> faces = await faceDetector.processImage(visionImage);
    print(faces);
    setState(() {
      carinhas = faces.length;
    });

    for (Face face in faces) {
       
        List olhos = [];
        var olhoesquerdo = face.getLandmark(FaceLandmarkType.leftEye).position;
        double olhoesquerdox = olhoesquerdo.dx;
        double olhoesquerdoy = olhoesquerdo.dy;
        var olhodireito = face.getLandmark(FaceLandmarkType.rightEye).position;
        double olhodireitox = olhodireito.dx;
        double olhodireitoy = olhodireito.dy;

        olhos.add(olhoesquerdo);
        olhos.add(olhodireito);

        List<double> cabecorra = []; 
        double cabecay = face.headEulerAngleY;
        double cabecaz = face.headEulerAngleZ;
        cabecorra.add(cabecay);
        cabecorra.add(cabecaz);

        var focinho = face.getLandmark(FaceLandmarkType.noseBase).position;
        double narizx = focinho.dx;
        double narizy = focinho.dy;

        setState(() {  
          olhinhos.add(olhos);
          cabeca.add(cabecorra);
          nariz.add(focinho);
        });

        if((-20 <= olhoesquerdox && olhoesquerdox <= 500) 
          && (0 <= olhoesquerdoy && olhoesquerdoy <= 650)
          && (50 <= olhodireitox && olhodireitox <= 700)
          && (0 <= olhodireitoy && olhodireitoy <= 650)
          && (-50 <= cabecay && cabecay <= 50)
          && (-100 <= cabecaz && cabecaz <= 100)
          && (0 <= narizx && narizx <= 700)
          && (0 <= narizy && narizy <= 700)){
          ver = true;
        }


    }

    faceDetector.close();


  }

}