import 'dart:async';
import 'package:app_criancas/services/recompensas_api.dart';
import 'package:app_criancas/widgets/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../widgets/color_parser.dart';
import 'package:video_player/video_player.dart';
import '../../../auth.dart';

class VideoScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  VideoScreenTabletPortrait(this.mission);

  @override
  _VideoScreenTabletPortraitState createState() =>
      _VideoScreenTabletPortraitState(mission);
}

class _VideoScreenTabletPortraitState extends State<VideoScreenTabletPortrait>
    with WidgetsBindingObserver {
  Mission mission;

  _VideoScreenTabletPortraitState(this.mission);
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

  AppLifecycleState state;

  @override
  void deactivate() {
    _counterVisited=_counterVisited+1;
    _end = DateTime.now();
    _timeSpentOnThisScreen = _end.difference(_start).inSeconds;
    _timeVisited = _timeVisited + _timeSpentOnThisScreen;
    updateMissionTimeAndCounterVisitedInFirestore(
        mission, _userID, _timeVisited, _counterVisited);
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
  void dispose() {

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
        child: Column(children: [
          Stack(children: [
            Positioned(
              top: 90,
              left: 50,
              child: Row(children: [
                Text(
                  mission.title,
                  style: TextStyle(
                      fontSize: 70,
                      fontFamily: 'Amatic SC',
                      color: Colors.white,
                      letterSpacing: 4),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 250, right: 30),
              child: Container(
                height: 600,
                decoration: BoxDecoration(
                    color: parseColor("#320a5c"),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: parseColor("#320a5c"),
                        blurRadius: 10.0,
                      )
                    ]),
                child: ChewieDemo(
                                                      link: mission.linkVideo),
              ),
            ),
         
          ]),
          Padding(
            padding: const EdgeInsets.all(70.0),
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
        ]),
      ),
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
      Timer(Duration(milliseconds: 3000), () async {
        updateMissionDoneInFirestore(mission, _userID);
        await updatePontuacao(_userID, mission.points);
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
