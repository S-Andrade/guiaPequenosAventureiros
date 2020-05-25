import 'dart:collection';
import '../models/question.dart';
import '../models/quiz.dart';

import '../models/mission.dart';
import 'package:flutter/cupertino.dart';

class MissionsNotifier with ChangeNotifier{

  List<Mission> _missionsList = [];
  Mission _currentMission;
  dynamic _missionContent;
  bool _completed;
  int _currentScore;
  List<Question> _allQuestions;

  UnmodifiableListView<Mission> get missionsList => UnmodifiableListView(_missionsList);
  UnmodifiableListView<Question> get allQuestions => UnmodifiableListView(_allQuestions);

  bool get completed => _completed;
  int get currentScore => _currentScore; 

  Mission get currentMission => _currentMission;
  Quiz get missionContent => _missionContent;

  set missionsList(List<Mission> missionList) {
    _missionsList = missionList;
    notifyListeners();
  }

  set allQuestions(List<Question> list) {
    _allQuestions = list;
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

  set completed(bool completed){
    _completed =completed;
    notifyListeners();
  }
  set currentScore(int score){
    _currentScore = score;
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