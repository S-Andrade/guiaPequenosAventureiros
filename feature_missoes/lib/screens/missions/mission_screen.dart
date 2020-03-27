import 'package:flutter/material.dart';
import 'package:guia_pa_feature_missoes/models/mission.dart';
import 'package:guia_pa_feature_missoes/responsive/orientation_layout.dart';
import 'package:guia_pa_feature_missoes/responsive/screen_type_layout.dart';
import 'package:guia_pa_feature_missoes/screens/missions/image_screen_tablet.dart';
import 'package:guia_pa_feature_missoes/screens/missions/text_screen_tablet.dart';
import 'package:guia_pa_feature_missoes/screens/missions/upload_screen_tablet.dart';
import 'package:guia_pa_feature_missoes/screens/missions/video_screen_tablet.dart';

class MissionScreen extends StatelessWidget {
  Mission mission;

  MissionScreen(this.mission);

  @override
  Widget build(BuildContext context) {
    if (mission.type == 'Video') {
      return ScreenTypeLayout(
        mobile: OrientationLayout(
          portrait: VideoScreenTabletPortrait(mission),
        ),
      );
    } 
    
    else if (mission.type == 'Upload') {
      return ScreenTypeLayout(
        mobile: OrientationLayout(
          portrait: UploadScreenTabletPortrait(mission),
        ),
      );
    } 

    else if (mission.type == 'Image') {
      return ScreenTypeLayout(
        mobile: OrientationLayout(
          portrait: ImageScreenTabletPortrait(mission),
        ),
      );
    }

    else if (mission.type == 'Text') {
      return ScreenTypeLayout(
        mobile: OrientationLayout(
          portrait: TextScreenTabletPortrait(mission),
        ),
      );
    }
    
    else {
      return Scaffold(
        body: SafeArea(
          child: Container(
            child: Row(children: [
              Text(mission.done.toString()),
              IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 60,
                color: Colors.yellow,
                tooltip: 'Missao completada',
                onPressed: () {
                  mission.done = true;
                  Navigator.pop(context);
                },
              )
            ]),
          ),
        ),
      );
    }
  }
}
