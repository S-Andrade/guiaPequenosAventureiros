import 'dart:async';

import 'package:app_criancas/services/recompensas_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../widgets/color_parser.dart';
import '../../../auth.dart';

class ImageScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  ImageScreenTabletPortrait(this.mission);

  @override
  _ImageScreenTabletPortraitState createState() =>
      _ImageScreenTabletPortraitState(mission);
}

class _ImageScreenTabletPortraitState extends State<ImageScreenTabletPortrait>
    with WidgetsBindingObserver {
  Mission mission;
  int _state = 0;
String _userID;
  Map resultados;
  bool _done;
  int _timeSpentOnThisScreen;
  int _timeVisited;
  int _counterVisited;
  DateTime _paused;
  DateTime _returned;
  int _totalPaused;
  DateTime _start;
  DateTime _end;

  _ImageScreenTabletPortraitState(this.mission);

  @override
  void initState() {
    Auth().getUser().then((user) {
                  setState(() {
                    _userID = user.email;
                    for (var a in mission.resultados) {
                      if (a["aluno"] == _userID) {
                        resultados = a;
                        _done = resultados["done"];
                        _counterVisited=resultados["counterVisited"];
                        _timeVisited=resultados["timeVisited"];
                      }
                    }
                  });
                });

    WidgetsBinding.instance.addObserver(this);
   
    _start=DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    print('dispose');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


   AppLifecycleState state;

  @override
  void deactivate() {
      _counterVisited=_counterVisited+1;
    _end=DateTime.now();
    _timeSpentOnThisScreen=_end.difference(_start).inSeconds;
    _timeVisited=_timeVisited+_timeSpentOnThisScreen;
    updateMissionTimeAndCounterVisitedInFirestore(mission,_userID,_timeVisited,_counterVisited);
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _paused = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      _returned = DateTime.now();
    }
    _totalPaused = _returned.difference(_paused).inSeconds;
    _timeVisited = _timeVisited - _totalPaused;
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      mission.title,
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Amatic SC',
                          color: Colors.white,
                          letterSpacing: 4),
                    )
                  ],
                ),
                Container(
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
                    child: Image(
                      image: _image,
                      fit: BoxFit.cover,
                    )),
                Image(
//                  height: 150.0,
//                  width: 170.0,
                  image: AssetImage("assets/images/image.png"),
                  fit: BoxFit.fill,
                ),
                MaterialButton(
                    child: setButton(),
                    onPressed: () {
                      setState(() {
                        _state = 1;
                        _loadButton();
                      });
                    },
//                    height: 90,
//                    minWidth: 300,
                    color: parseColor('#320a5c'),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0))),
              ],
            ),
          )),
    );
  }

  Widget setButton() {
    if (_done == false) {
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
    if (_done == true) {
      print('back');
      Navigator.pop(context);
    } else {
      Timer(Duration(milliseconds: 3000), () async{
        updateMissionDoneInFirestore(mission, _userID);
        await updatePoints(_userID, mission.points);
        Navigator.pop(context);
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
