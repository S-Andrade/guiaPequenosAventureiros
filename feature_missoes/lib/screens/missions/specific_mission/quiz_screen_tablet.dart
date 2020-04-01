import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guia_pa_feature_missoes/api/missions_api.dart';
import 'package:guia_pa_feature_missoes/models/mission.dart';
import 'package:guia_pa_feature_missoes/widgets/color_loader.dart';
import 'package:guia_pa_feature_missoes/widgets/color_parser.dart';

class QuizScreenTabletPortrait extends StatefulWidget {
  
  Mission mission;

  QuizScreenTabletPortrait(this.mission);

  @override
  _QuizScreenTabletPortraitState createState() =>
      _QuizScreenTabletPortraitState(mission);
}

class _QuizScreenTabletPortraitState extends State<QuizScreenTabletPortrait> {
  
  Mission mission;
  int _state = 0;

  _QuizScreenTabletPortraitState(this.mission);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back6.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          ),
    );
  }

  Widget setButton() {
    if (mission.done == false) {
      if (_state == 0) {
        return new Text(
          "okay",
          style: const TextStyle(
            fontFamily: 'Amatic SC',
            letterSpacing: 4,
            color: Colors.white,
            fontSize: 40.0,
          ),
        );
      } else
        return ColorLoader();
    } else {
      return new Text(
        "Feita",
        style: const TextStyle(
          fontFamily: 'Amatic SC',
          letterSpacing: 4,
          color: Colors.white,
          fontSize: 40.0,
        ),
      );
    }
  }

  void _loadButton() {
    if (mission.done == true) {
      print('back');
      Navigator.pop(context);
    } else {
      Timer(Duration(milliseconds: 3000), () {
        updateMissionDoneInFirestore(mission);
        Navigator.pop(context);
      });
    }
  }
}
