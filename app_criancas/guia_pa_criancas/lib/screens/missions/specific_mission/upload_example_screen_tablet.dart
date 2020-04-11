import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/mission.dart';
import '../../../notifier/missions_notifier.dart';
import '../../../services/missions_api.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class UploadExampleScreenTabletPortrait extends StatefulWidget {

  Mission mission;

  UploadExampleScreenTabletPortrait(this.mission);

  @override
  _UploadExampleScreenTabletPortraitState createState() =>
      _UploadExampleScreenTabletPortraitState(mission);
}

class _UploadExampleScreenTabletPortraitState
    extends State<UploadExampleScreenTabletPortrait> {

  Mission mission;

  _UploadExampleScreenTabletPortraitState(this.mission);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  File _video;
  File _image;
  File _audio;
  String _titulo;
  var video;
  var image;
  var audio;


  @override
  void initState() {
    MissionsNotifier missionNotifier =
        Provider.of<MissionsNotifier>(context, listen: false);
    super.initState();
  }

  Future getImage() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
  }

  Future getVideo() async {
    video = await ImagePicker.pickVideo(source: ImageSource.gallery);
  }

  Future getAudio() async {
    audio = await FilePicker.getFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Upload Example'),
        ),
        body: Column(children: <Widget>[
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Título: '),
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Insira o título';
                }
                if (value.length < 3 || value.length > 20) {
                  return 'O título tem de ter entre 3 a 20 caratéres';
                }
                _titulo = value;
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Center(
              child: RaisedButton(
                child: Text('IMAGEM'),
                onPressed: getImage,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Center(
              child: RaisedButton(
                child: Text('VIDEO'),
                onPressed: getVideo,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Center(
              child: RaisedButton(
                child: Text('AUDIO'),
                onPressed: getAudio,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Center(
              child: RaisedButton(
                child: Text('Carregar para o Firebase'),
                onPressed: _upload,
              ),
            ),
          ),
        ]));
  }

  _upload() {
    if (_formKey.currentState.validate()) {
      if (video != null) {
        _video = video;
        addUploadedVideoToFirebaseStorage(_video, _titulo);
      }
      if (image != null) {
        _image = image;
        addUploadedImageToFirebaseStorage(_image, _titulo);
      }
      if (audio != null) {
        _audio = audio;
        addUploadedAudioToFirebaseStorage(_audio, _titulo);
      }
    }
  }
}
