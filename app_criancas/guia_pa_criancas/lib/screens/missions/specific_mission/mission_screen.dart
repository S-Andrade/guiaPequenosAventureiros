import 'package:app_criancas/screens/missions/specific_mission/questionario_screen_tablet.dart';
import 'package:flutter/material.dart';
import '../../../models/mission.dart';
import '../../../responsive/orientation_layout.dart';
import '../../../responsive/screen_type_layout.dart';
import '../specific_mission/activity_screen_tablet.dart';
import '../specific_mission/audio_screen_tablet.dart';
import '../specific_mission/image_screen_tablet.dart';
import '../specific_mission/quiz_screen_tablet.dart';
import '../specific_mission/text_screen_tablet.dart';
import '../specific_mission/upload_example_screen_tablet.dart';
import '../specific_mission/upload_screen_tablet.dart';
import '../specific_mission/video_screen_tablet.dart';


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

        else if (mission.type == 'Activity') {
      return ScreenTypeLayout(
        mobile: OrientationLayout(
          portrait: ActivityScreenTabletPortrait(mission),
        ),
      );
    } 

      else if (mission.type == 'Quiz') {
      return ScreenTypeLayout(
        mobile: OrientationLayout(
          portrait: QuizScreenTabletPortrait(mission),
        ),
      );
    } 
    
    else if (mission.type == 'UploadImage') {
      return ScreenTypeLayout(
        mobile: OrientationLayout(
          portrait: UploadImageScreenTabletPortrait(mission),
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

    else if (mission.type == 'Audio') {
      return ScreenTypeLayout(
        mobile: OrientationLayout(
          portrait: AudioScreenTabletPortrait(mission),
        ),
      );
    }
    
    else if (mission.type == 'UploadExample') {
      return ScreenTypeLayout(
        mobile: OrientationLayout(
          portrait: UploadExampleScreenTabletPortrait(mission),
        ),
      );
    }
    else if (mission.type == 'Questionario') {
      return ScreenTypeLayout(
        mobile: OrientationLayout(
          portrait: QuestionarioScreen(mission),
        ),
      );
    }

    
  }
}
