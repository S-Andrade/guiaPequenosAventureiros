//import 'package:eyetrackingv2/Timing.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'VideoPlayer.dart';
//import 'TakePictureScreen.dart';



Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();


  runApp(MyApp());
}


class MyApp extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {



  @override
  Widget build(BuildContext context){

    return MaterialApp(
      theme: ThemeData.dark(),
      home: VideoPlayerTiming(
        // Pass the appropriate camera to the TakePictureScreen widget.
      ),
    );
  }
}  