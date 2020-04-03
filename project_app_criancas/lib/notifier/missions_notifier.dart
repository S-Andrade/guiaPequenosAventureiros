import 'dart:collection';
import 'package:project_app_criancas/models/quiz.dart';

import '../models/mission.dart';
import 'package:flutter/cupertino.dart';

class MissionsNotifier with ChangeNotifier{

  List<Mission> _missionsList = [];
  Mission _currentMission;
  dynamic _missionContent;

  UnmodifiableListView<Mission> get missionsList => UnmodifiableListView(_missionsList);
  
  

  Mission get currentMission => _currentMission;
  Quiz get missionContent => _missionContent;

  set missionsList(List<Mission> missionList) {
    _missionsList = missionList;
    notifyListeners();
  }

  set currentMission(Mission mission) {
    _currentMission = mission;
    notifyListeners();
  }

  set missionContent(dynamic content){
    _missionContent = content;
    notifyListeners();
  }

  addMission(Mission mission) {
    _missionsList.insert(0, mission);
    notifyListeners();
  }

  deleteMission(Mission mission) {
    _missionsList.removeWhere((_mission) => _mission.id == mission.id);
    notifyListeners();
  }
}