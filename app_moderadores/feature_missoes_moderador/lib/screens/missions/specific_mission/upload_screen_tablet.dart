import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/mission.dart';
import '../../../notifier/missions_notifier.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../widgets/color_parser.dart';
import 'package:provider/provider.dart';
import '../../../auth.dart';

class UploadVideoScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  UploadVideoScreenTabletPortrait(this.mission);

  @override
  _UploadVideoScreenTabletPortraitState createState() =>
      _UploadVideoScreenTabletPortraitState(mission);
}

class _UploadVideoScreenTabletPortraitState
    extends State<UploadVideoScreenTabletPortrait> {
  Mission mission;

  _UploadVideoScreenTabletPortraitState(this.mission);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  File _video;
  String _titulo;
  bool _loaded;
  var video;
  int _state = 0;
  
    String _userID;
    Map resultados;
    bool _done;

  @override
  void initState() {
    MissionsNotifier missionNotifier =
        Provider.of<MissionsNotifier>(context, listen: false);
    _loaded = false;
    Auth().getUser().then((user) {
                  setState(() {
                    _userID = user.email;
                    for (var a in mission.resultados) {
                      if (a["aluno"] == _userID) {
                        resultados = a;
                        _done = resultados["done"];
                      }
                    }
                  });
                });
    super.initState();
  }

  Future getVideo() async {
    video = await ImagePicker.pickVideo(source: ImageSource.gallery);

    if (video != null)
      setState(() {
        _loaded = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    _titulo = 'upload_video_crianca_' + mission.id;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Upload Video Example'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back6.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 70.0, left: 30),
              child: Row(
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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 130.0, left: 35),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      mission.content,
                      style: TextStyle(
                          fontSize: 45,
                          fontFamily: 'Amatic SC',
                          color: Colors.white,
                          letterSpacing: 4),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:150.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Builder(
                builder: (BuildContext) => _done ?
                  Center(
                    child: MaterialButton(
                      height: 90,
                      minWidth: 300,
                      color: parseColor('#320a5c'),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                      child: Text(
                        'Vídeo já carregado',
                        style: TextStyle(
                            fontSize: 45,
                            fontFamily: 'Amatic SC',
                            color: Colors.white,
                            letterSpacing: 4),
                      ),
                      onPressed: () => _loadButton()
                    ),
                  )
                  :
                  Center(
                    child: MaterialButton(
                      height: 90,
                      minWidth: 300,
                      color: parseColor('#320a5c'),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                      child: Text(
                        'Escolher vídeo',
                        style: TextStyle(
                            fontSize: 45,
                            fontFamily: 'Amatic SC',
                            color: Colors.white,
                            letterSpacing: 4),
                      ),
                      onPressed: getVideo,
                    ),
                  )),
                
                Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child: new Builder(
                      builder: (BuildContext) => _loaded
                          ? new Icon(
                              FontAwesomeIcons.checkCircle,
                              color: Colors.green,
                              size: 50.0,
                            )
                          : Container()),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top:130.0,right:70),
              child: new Builder(
                builder: (BuildContext) => _loaded
                    ? MaterialButton(
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
                      shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0))
                    )
                    : Container(),
              ),
            )
          ]),
        ));
  }




  Widget setButton() {
    if (_done == false) {
      if (_state == 0) {
        return new Text(
          "Carregar",
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
        "Vídeo já carregado",
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
    if (_done == true) {
      print('back');
      Timer(Duration(milliseconds: 500), () {
        
        Navigator.pop(context);
      });
    } else {
      Timer(Duration(milliseconds: 3000), () {
        _upload();
        Navigator.pop(context);
      });
    }
  }

  _upload() async {
   
    if (video != null) {
      _video = video;
      addUploadedVideoToFirebaseStorage(_video, _titulo).then((value)=>{
updateMissionDoneWithLinkInFirestore(mission,_userID,value)
      });}
      
      
    
  }
}