import 'package:flutter/material.dart';
import 'package:guia_pa_feature_missoes/models/mission.dart';
import 'package:video_player/video_player.dart';


class VideoScreenTabletPortrait extends StatefulWidget {

  Mission mission;
  
  VideoScreenTabletPortrait(this.mission);


  @override
  _VideoScreenTabletPortraitState createState() => _VideoScreenTabletPortraitState(mission);
}

class _VideoScreenTabletPortraitState extends State<VideoScreenTabletPortrait> {

  Mission mission;

  _VideoScreenTabletPortraitState(this.mission);

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {

    _controller = VideoPlayerController.network(
      mission.linkVideo
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    super.initState();

  }


  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(mission.linkVideo);
    return Scaffold(
      body: Column(children:[Padding(
        padding: const EdgeInsets.only(left:30.0,top:150,right: 30),
        child: Container(
          
          height:600,
  
          decoration: BoxDecoration(
                         
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow,
                              blurRadius: 4.0,
                            )
                          ]),

          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 60,
            color: Colors.yellow,
            tooltip: 'Missao completada',
            onPressed: () {
              mission.done = true;
              Navigator.pop(context);
            })
      ]
      ),


      floatingActionButton: FloatingActionButton(
        
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
       
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ), 
    );
    
  }
  
}
