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
  List<List<double>> olhinhos =  [];
  int carinhas = 0 ;
  List<List<double>> cabeca = [];
  List nariz = [];
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
                Text(nariz.toString())
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
        List<double> olhos = [];
        olhos.add(face.leftEyeOpenProbability);
        olhos.add(face.rightEyeOpenProbability);

        List<double> cabecorra = []; 
        cabecorra.add(face.headEulerAngleY);
        cabecorra.add(face.headEulerAngleZ);

        var focinho = face.getLandmark(FaceLandmarkType.noseBase);

        setState(() {  
          olhinhos.add(olhos);
          cabeca.add(cabecorra);
          nariz.add(focinho.position);
        });
    }

    faceDetector.close();


  }

}