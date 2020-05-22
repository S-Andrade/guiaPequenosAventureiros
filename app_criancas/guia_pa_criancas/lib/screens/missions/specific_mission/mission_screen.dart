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
import '../specific_mission/upload_video_screen_tablet.dart';
import '../specific_mission/upload_image_screen_tablet.dart';
import '../specific_mission/video_screen_tablet.dart';

class MissionScreen extends StatelessWidget {
  Mission mission;

  MissionScreen(this.mission);

  @override
  Widget build(BuildContext context) {
    if (mission.type == 'Video') {
      return VideoScreenTabletPortrait(mission);
    } else if (mission.type == 'Activity') {
      return ActivityScreenTabletPortrait(mission);
    } else if (mission.type == 'Quiz') {
      return QuizScreenTabletPortrait(mission);
    } else if (mission.type == 'Questionario') {
      return QuestionarioScreen(mission);
    } else if (mission.type == 'UploadImage') {
      return UploadImageScreenTabletPortrait(mission);
    } else if (mission.type == 'Image') {
      return ImageScreenTabletPortrait(mission);
    } else if (mission.type == 'Text') {
      return ScreenTypeLayout(
          tablet: OrientationLayout(
            portrait: TextScreenTabletPortrait(mission),
          ),
          mobile: OrientationLayout(
            portrait: TextScreenMobilePortrait(mission),
          ));
    } else if (mission.type == 'Audio') {
      return AudioScreenTabletPortrait(mission);
    } else if (mission.type == 'UploadVideo') {
      return UploadVideoScreenTabletPortrait(mission);
    }
  }
}
