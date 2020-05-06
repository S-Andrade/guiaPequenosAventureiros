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
  File image;
  List<Face> faces = [];

  @override
  Widget build(BuildContext context) {
    suminho();
    return  FutureBuilder<void>(
            future: suminho(),
            builder: (context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(children: <Widget>[
        Image.file(File(imagePath)),
        Text(faces.length.toString())
      ],) 
    );
            }
    );
  }

  Future<void> suminho() async {

    print("HELLO0000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    final data = await File(imagePath).readAsBytes();
    await decodeImageFromList(data).then(
    (value) {
      setState(() {
        image = value;
        isLoading = false;
     });
    },
    );

    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> f = await faceDetector.processImage(image);
    setState(() {
      faces = f;
    });

    print("AIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
    print(faces);
    
    

  }

}