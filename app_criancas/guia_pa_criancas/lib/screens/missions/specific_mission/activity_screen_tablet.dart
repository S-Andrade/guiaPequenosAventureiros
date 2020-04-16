import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../models/activity.dart';
import 'package:flutter/material.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../widgets/color_parser.dart';

class ActivityScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  ActivityScreenTabletPortrait(this.mission);

  @override
  _ActivityScreenTabletPortraitState createState() =>
      _ActivityScreenTabletPortraitState(mission);
}

class _ActivityScreenTabletPortraitState
    extends State<ActivityScreenTabletPortrait> {
  Mission mission;
  int _state = 0;

  double padValue = 0;

  _ActivityScreenTabletPortraitState(this.mission);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Activity> activities = mission.content;
    NetworkImage _image;

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ListView(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    mission.title,
                    style: TextStyle(
                        fontSize: 70,
                        fontFamily: 'Amatic SC',
                        color: parseColor("#320a5c"),
                        letterSpacing: 4),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: List.generate(activities.length, (index) {
                if (activities[index].linkImage != null)
                  _image = new NetworkImage(activities[index].linkImage);
                return Column(children: [
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(FontAwesomeIcons.star),
                        iconSize: 40,
                        color: parseColor("#320a5c"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                            width: 370,
                            child: Row(children: [
                              Flexible(
                                child: Text(
                                  activities[index].description,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 2,
                                      fontSize: 40),
                                ),
                              ),
                            ])),
                      ),
                      Container(
                        width: 300.0,
                        height: 300.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          image: DecorationImage(
                            image: _image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]);
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0, left: 300, right: 300),
            child: MaterialButton(
                child: setButton(),
                onPressed: () {
                  setState(() {
                    _state = 1;
                    _loadButton();
                  });
                },
                height: 90,
                color: parseColor('#320a5c'),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0))),
          )
        ],
      ),
    ));
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
