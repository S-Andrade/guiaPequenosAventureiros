import 'dart:async';

import 'package:flutter/material.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../widgets/color_parser.dart';


class ImageScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  ImageScreenTabletPortrait(this.mission);

  @override
  _ImageScreenTabletPortraitState createState() =>
      _ImageScreenTabletPortraitState(mission);
}

class _ImageScreenTabletPortraitState extends State<ImageScreenTabletPortrait> {
  Mission mission;
  int _state = 0;

  _ImageScreenTabletPortraitState(this.mission);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage _image;

    if (mission.linkImage != null) _image = new NetworkImage(mission.linkImage);

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back6.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                    top: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            mission.title,
                            style: TextStyle(
                                fontSize: 70,
                                fontFamily: 'Amatic SC',
                                color: Colors.white,
                                letterSpacing: 4),
                          )
                        ],
                      ),
                    )),
                Positioned(
                    top: 340,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                          decoration: BoxDecoration(
                              color: parseColor("#320a5c"),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: parseColor("#320a5c"),
                                  blurRadius: 10.0,
                                )
                              ]),
                          height: 530,
                          width: 630,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                              image: _image,
                              fit: BoxFit.cover,
                            ),
                          )),
                    )),
                Positioned(
                    top: 250,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image(
                          height: 150.0,
                          width: 170.0,
                          image: AssetImage("assets/images/image.png"),
                          fit: BoxFit.fill,
                        ))),
                Positioned(
                  top: 920,
                  child: MaterialButton(
                      child: setButton(),
                      onPressed: () {
                        setState(() {
                          _state = 1;
                          _loadButton();
                        });
                      },
                      height: 90,
                      minWidth: 300,
                      color: parseColor('#320a5c'),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),
              ],
            ),
          )),
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
