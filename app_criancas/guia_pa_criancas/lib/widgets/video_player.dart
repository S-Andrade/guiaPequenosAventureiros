import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';


class ChewieDemo extends StatefulWidget {
  String link;

  ChewieDemo({this.link});

    _ChewieDemoState _chewieDemoState;

  @override
  State<StatefulWidget> createState() {
    _chewieDemoState = _ChewieDemoState(link:this.link);
    return _chewieDemoState;
  }
  void pauseVideo(){
    _chewieDemoState.pauseVideo();
  }

  bool isPlaying(){
    return _chewieDemoState.isPlaying();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
  String link;

  _ChewieDemoState({this.link});

  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(
        link);
    
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
  
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                _chewieController.enterFullScreen();
              },
              child: Text('Ver em ecrã inteiro',textAlign: TextAlign.center,
                style: GoogleFonts.pangolin(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.white),
                ),),
            ),
            
            
          ],
        ),
      );
    
  }

  void pauseVideo(){
    _chewieController.pause();
  }

  bool isPlaying(){
    return _videoPlayerController1.value.isPlaying;
  }
}