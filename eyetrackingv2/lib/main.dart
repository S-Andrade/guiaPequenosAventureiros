import 'package:eyetrackingv2/Timing.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';
//import 'TakePictureScreen.dart';



Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();


  runApp(MyApp(cameras: cameras));
}


class MyApp extends StatefulWidget {

  final List<CameraDescription> cameras;
  MyApp({this.cameras});

  @override
  _MyHomePageState createState() => _MyHomePageState(cameras: cameras);
}

class _MyHomePageState extends State<MyApp> {


 final List<CameraDescription> cameras;
  _MyHomePageState({this.cameras});


  @override
  Widget build(BuildContext context){

    return MaterialApp(
      theme: ThemeData.dark(),
      home: Timing(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: cameras.last,
      ),
    );
  }
}  