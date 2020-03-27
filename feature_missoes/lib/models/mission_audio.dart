import 'package:guia_pa_feature_missoes/models/mission.dart';

class MissionAudio extends Mission{


  String content;

  MissionAudio.fromMap(Map<String,dynamic>data) : super.fromMap(data);


  @override
  fromMap(Map<String,dynamic> data) {
    id=data['id'];
    title=data['title'];
    counter=data['counter'];
    type=data['type'];
    done=data['done'];
    
    
  }
}