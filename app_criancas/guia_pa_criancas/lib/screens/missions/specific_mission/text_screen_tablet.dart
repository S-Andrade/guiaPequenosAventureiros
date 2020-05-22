import 'dart:async';

import 'package:flutter/material.dart';
import '../../../models/mission.dart';
import '../../../services/missions_api.dart';
import '../../../widgets/color_loader.dart';
import '../../../widgets/color_parser.dart';
import '../../../auth.dart';
import '../../../services/recompensas_api.dart';
import 'package:firebase_storage/firebase_storage.dart';


class TextScreenTabletPortrait extends StatefulWidget {
  Mission mission;

  TextScreenTabletPortrait(this.mission);

  @override
  _TextScreenTabletPortraitState createState() =>
      _TextScreenTabletPortraitState(mission);
}

class _TextScreenTabletPortraitState extends State<TextScreenTabletPortrait>
     {
  Mission mission;
  int _state = 0;
  DateTime _start;
  DateTime _end;
  int _timeSpentOnThisScreen;
  int _timeVisited;
  int _counterVisited;
  DateTime _paused;
  DateTime _returned;
  int _totalPaused;
  String _userID;
  Map resultados;
  bool _done;


  _TextScreenTabletPortraitState(this.mission);

  @override
  void initState() {
    Auth().getUser().then((user) {
      setState(() {
        _userID = user.email;
        for (var a in mission.resultados) {
          if (a["aluno"] == _userID) {
            resultados = a;
            _done = resultados["done"];
            _counterVisited = resultados["counterVisited"];
            _timeVisited = resultados["timeVisited"];
          }
        }
      });
    });

    
    _start = DateTime.now();
    
     super.initState();

    
  }


  
  

  @override
  void dispose() {
    print('dispose');
    
    super.dispose();
      
   

  }

  AppLifecycleState state;

  @override
  void deactivate() {
    _counterVisited = _counterVisited + 1;
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
  Widget build(BuildContext context) {
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
                        height: 530,
                        width: 630,
                        color: parseColor('#320a5c'),
                        child: Column(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 30, top: 100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    mission.content,
                                    style: TextStyle(
                                        fontSize: 50,
                                        color: Colors.white,
                                        fontFamily: 'Amatic SC',
                                        letterSpacing: 4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    )),
                Positioned(
                    top: 180,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image(
                          height: 300.0,
                          width: 320.0,
                          image: AssetImage("assets/images/text.png"),
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

  void _loadButton() async {
    if (_done == true) {
      print('back');

       // await updatePoints(_userID, mission.points);

      Navigator.pop(context);
    } else {
      Timer(Duration(milliseconds: 3000), () async {
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
    if( cromos[0] != null){

      Image image;


       await FirebaseStorage.instance.ref().child(cromos[0]).getDownloadURL().then((downloadUrl) {
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
    if( cromos[1] != null){
      Image image;


       await FirebaseStorage.instance.ref().child(cromos[1]).getDownloadURL().then((downloadUrl) {
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

/////////// MOBILE PORTRAIT

class TextScreenMobilePortrait extends StatefulWidget {
  Mission mission;

  TextScreenMobilePortrait(this.mission);

  @override
  _TextScreenMobilePortraitState createState() =>
      _TextScreenMobilePortraitState(mission);
}

class _TextScreenMobilePortraitState extends State<TextScreenMobilePortrait>
     {
  Mission mission;
  int _state = 0;
  DateTime _start;
  DateTime _end;
  int _timeSpentOnThisScreen;
  int _timeVisited;
  int _counterVisited;
  DateTime _paused;
  DateTime _returned;
  int _totalPaused;
  String _userID;
  Map resultados;
  bool _done;

  

  _TextScreenMobilePortraitState(this.mission);

  @override
  void initState() {
    Auth().getUser().then((user) {
      setState(() {
        _userID = user.email;
        for (var a in mission.resultados) {
          if (a["aluno"] == _userID) {
            resultados = a;
            _done = resultados["done"];
            _counterVisited = resultados["counterVisited"];
            _timeVisited = resultados["timeVisited"];
          }
        }
      });
    });

    
    _start = DateTime.now();

    super.initState();

      

  
    
      
 
   
  }


  
  
  @override
  void dispose() {
    print('dispose');
  
    super.dispose();
    
  }

  AppLifecycleState state;

  @override
  void deactivate() {
    _counterVisited = _counterVisited + 1;
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back6.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                    top: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            mission.title,
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Amatic SC',
                                color: Colors.white,
                                letterSpacing: 4),
                          )
                        ],
                      ),
                    )),
                Positioned(
                    top: 140,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 370,
                        width: 330,
                        color: parseColor('#320a5c'),
                        child: Column(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 30, top: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    mission.content,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: 'Amatic SC',
                                        letterSpacing: 4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    )),
                Positioned(
                    top: 60,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image(
                          height: 150.0,
                          width: 170.0,
                          image: AssetImage("assets/images/text.png"),
                          fit: BoxFit.fill,
                        ))),
                Positioned(
                  top: 560,
                  child: MaterialButton(
                      child: setButton(),
                      onPressed: () {
                        setState(() {
                          _state = 1;
                          _loadButton();
                        });
                      },
                      height: 50,
                      minWidth: 100,
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
    if (_done == false) {
      if (_state == 0) {
        return new Text(
          "okay",
          style: const TextStyle(
            fontFamily: 'Amatic SC',
            letterSpacing: 4,
            color: Colors.white,
            fontSize: 20.0,
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
          fontSize: 20.0,
        ),
      );
    }
  }

  void _loadButton() async {
    if (_done == true) {
      print('back');

         //  await updatePoints(_userID, mission.points);

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
