import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_app_criancas/models/mission.dart';
import 'package:project_app_criancas/services/missions_api.dart';
import 'package:project_app_criancas/widgets/color_loader.dart';

class ActivityScreenTabletPortrait extends StatefulWidget {
  
  Mission mission;

  ActivityScreenTabletPortrait(this.mission);

  @override
  _ActivityScreenTabletPortraitState createState() =>
      _ActivityScreenTabletPortraitState(mission);
}

class _ActivityScreenTabletPortraitState extends State<ActivityScreenTabletPortrait> {
  
  Mission mission;
  int _state = 0;

  _ActivityScreenTabletPortraitState(this.mission);

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
