import 'dart:async';
import 'dart:io';
import 'package:app_criancas/services/recompensas_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
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


class UploadImageScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  UploadImageScreenTabletPortrait(this.mission);

  @override
  _UploadImageScreenTabletPortraitState createState() =>
      _UploadImageScreenTabletPortraitState(mission);
}

class _UploadImageScreenTabletPortraitState
    extends State<UploadImageScreenTabletPortrait> {
  Mission mission;

  _UploadImageScreenTabletPortraitState(this.mission);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  File _image;
  String _titulo;
  bool _loaded;
  var image;
  int _state = 0;
  
    String _userID;
    Map resultados;
    bool _done;

  @override
  void initState() {
    MissionsNotifier missionNotifier =
        Provider.of<MissionsNotifier>(context, listen: false);
    _loaded = false;
    _done=false;
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

  Future getImage() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    if (image != null)
      setState(() {
        _loaded = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    _titulo = 'upload_foto_crianca_' + mission.id;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Upload Foto Example'),
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
              padding: const EdgeInsets.only(top: 40.0, left: 30),
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
              padding: const EdgeInsets.only(top: 50.0, left: 35),
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
              padding: const EdgeInsets.only(top: 90.0, left: 35),child:
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [new Builder(
              
                      builder: (BuildContext) => _loaded
                          ? new Container(
                              height: 300,
                              width:300,
                              child: new Image.file(image),
                            )
                          : Container()),],),),
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
                        'Foto já carregada',
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
                        'Escolher foto',
                        style: TextStyle(
                            fontSize: 45,
                            fontFamily: 'Amatic SC',
                            color: Colors.white,
                            letterSpacing: 4),
                      ),
                      onPressed: getImage,
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
        "foto já carregada",
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
      Timer(Duration(milliseconds: 500), () async{
        //await updatePoints(_userID, mission.points);
        Navigator.pop(context);
      });
    } else {
      Timer(Duration(milliseconds: 3000), () async{
        _upload();
        await updatePoints(_userID, mission.points);
        Navigator.pop(context);
      });
    }
  }

  _upload() {
    if (image != null) {
      _image = image;
      addUploadedImageToFirebaseStorage(_image, _titulo).then((value)=>{
        updateMissionDoneWithLinkInFirestore(mission,_userID,value)
      });
      
    }
  }

  updatePoints(String aluno, int points) async{
    List cromos = await updatePontuacao(aluno, points);
    print("tellle");
    print(cromos);
   
    await showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Ganhas-te pontos"),
                content: new Text("+$points"),
                actions: <Widget>[
                  // define os botões na base do dialogo
                  new FlatButton(
                    child: new Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
    if( cromos[0] != []){

      for (String i in cromos[0]){
          Image image;


       await FirebaseStorage.instance.ref().child(i).getDownloadURL().then((downloadUrl) {
        image = Image.network(
            downloadUrl.toString(),
            fit: BoxFit.scaleDown,
          );
        }
       );

    
      await showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Ganhas-te um cromo para a tua caderneta"),
                content: image,
                actions: <Widget>[
                  // define os botões na base do dialogo
                  new FlatButton(
                    child: new Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
      }
      
    }
    if( cromos[1] != []){

      for (String i in cromos[1]){
         Image image;


       await FirebaseStorage.instance.ref().child(i).getDownloadURL().then((downloadUrl) {
        image = Image.network(
            downloadUrl.toString(),
            fit: BoxFit.scaleDown,
          );
        }
       );

    
      await showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Ganhas-te um cromo para a caderneta da turma"),
                content: image,
                actions: <Widget>[
                  // define os botões na base do dialogo
                  new FlatButton(
                    child: new Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
      }

     
    }

  }
}
