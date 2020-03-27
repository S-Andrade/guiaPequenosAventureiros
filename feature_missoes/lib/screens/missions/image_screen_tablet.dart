import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guia_pa_feature_missoes/models/mission.dart';

class ImageScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  ImageScreenTabletPortrait(this.mission);

  @override
  _ImageScreenTabletPortraitState createState() =>
      _ImageScreenTabletPortraitState(mission);
}

class _ImageScreenTabletPortraitState extends State<ImageScreenTabletPortrait> {
  Mission mission;

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
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Column(children: [
        Center(
          child: _image == null ? Text('No image.') : Image(image: _image),
        ),
        IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 60,
            color: Colors.yellow,
            tooltip: 'Missao completada',
            onPressed: () {
              mission.done = true;
              Navigator.pop(context);
            })
      ]),
    );
  }
}
