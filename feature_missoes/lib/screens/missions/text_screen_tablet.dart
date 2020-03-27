import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guia_pa_feature_missoes/models/mission.dart';

class TextScreenTabletPortrait extends StatefulWidget {

  Mission mission;

  TextScreenTabletPortrait(this.mission);

  @override
  _TextScreenTabletPortraitState createState() =>
      _TextScreenTabletPortraitState(mission);
}

class _TextScreenTabletPortraitState extends State<TextScreenTabletPortrait> {
 
  Mission mission;

  _TextScreenTabletPortraitState(this.mission);

 

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Text Example'),
      ),
      body: Text(mission.content)
    );
  }
}
