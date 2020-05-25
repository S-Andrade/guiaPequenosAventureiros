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
        tablet: OrientationLayout(
          portrait: VideoScreenTabletPortrait(mission),
        ),
        //mobile:OrientationLayout(portrait: VideoScreenMobilePortrait(mission),)
      );
    } 
        else if (mission.type == 'Activity') {
      return ScreenTypeLayout(
        tablet: OrientationLayout(
          portrait: ActivityScreenTabletPortrait(mission),
          
        ),
        //mobile:OrientationLayout(portrait: ActivityScreenMobilePortrait(mission),)
      );
    } 

      else if (mission.type == 'Quiz') {
      return ScreenTypeLayout(
        tablet: OrientationLayout(
          portrait: QuizScreenTabletPortrait(mission),
        ),
        //mobile:OrientationLayout(portrait: QuizScreenMobilePortrait(mission),)
      );
    } 
    else if (mission.type == 'Questionario') {
      return ScreenTypeLayout(
        tablet: OrientationLayout(
          portrait: QuestionarioScreen(mission),
        ),
        //mobile:OrientationLayout(portrait: QuizScreenMobilePortrait(mission),)
      );
    } 
    
    else if (mission.type == 'UploadImage') {
      return ScreenTypeLayout(
        tablet: OrientationLayout(
          portrait: UploadImageScreenTabletPortrait(mission),
        ),
        //mobile:OrientationLayout(portrait: UploadImageScreenMobilePortrait(mission),)
      );
    } 

    else if (mission.type == 'Image') {
      return ScreenTypeLayout(
        tablet: OrientationLayout(
          portrait: ImageScreenTabletPortrait(mission),
        ),
        //mobile:OrientationLayout(portrait: ImageScreenMobilePortrait(mission),)
      );
    }

    else if (mission.type == 'Text') {
      return ScreenTypeLayout(
        tablet: OrientationLayout(
          portrait: TextScreenTabletPortrait(mission),
        ),
        mobile:OrientationLayout(portrait: TextScreenMobilePortrait(mission),)
      );
    }

    else if (mission.type == 'Audio') {
      return ScreenTypeLayout(
        tablet: OrientationLayout(
          portrait: AudioScreenTabletPortrait(mission),
        ),
        //mobile:OrientationLayout(portrait: AudioScreenMobilePortrait(mission),)
      );
    }
    
    else if (mission.type == 'UploadExample') {
      return ScreenTypeLayout(
        tablet: OrientationLayout(
          portrait: UploadExampleScreenTabletPortrait(mission),
        ),
        //mobile:OrientationLayout(portrait: UploadExampleScreenMobilePortrait(mission),)
      );
    }

    
  }
}
