import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guia_pa_feature_missoes/api/missions_api.dart';
import 'package:guia_pa_feature_missoes/models/mission.dart';
import 'package:guia_pa_feature_missoes/notifiers/missions_notifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  UploadScreenTabletPortrait(this.mission);

  @override
  _UploadScreenTabletPortraitState createState() =>
      _UploadScreenTabletPortraitState(mission);
}

class _UploadScreenTabletPortraitState
    extends State<UploadScreenTabletPortrait> {
  Mission mission;

  _UploadScreenTabletPortraitState(this.mission);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String _imageUrl;
  File _video;
  File _image;
  String _titulo;
  var video;
  var image;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Upload Example'),
        ),
        body: Column(children: <Widget>[
          Form(key:_formKey,
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
                _titulo=value;
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
                child: Text('Carregar para o Firebase'),
                onPressed: _upload,
              ),
            ),
          ),
        ]));
  }

  _upload(){

    if (_formKey.currentState.validate()) {

      if (video != null) {
        _video = video;
        addUploadedVideoToFirebaseStorage( _video,_titulo);
      }
      if (image != null) {
        _image = image;
        addUploadedImageToFirebaseStorage(_image,_titulo);
      }

    }
  }
}
