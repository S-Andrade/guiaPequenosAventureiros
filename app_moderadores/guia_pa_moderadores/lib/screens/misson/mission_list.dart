import 'package:flutter/material.dart';
import 'package:guia_pa_moderadores/screens/capitulo/capitulo.dart';
import 'mission_tile.dart';

class MissionList extends StatefulWidget {

  Capitulo capitulo;
  MissionList({this.capitulo});

  @override
  _MissionList createState() => _MissionList(capitulo: capitulo);
}

class _MissionList extends State<MissionList> {
  
  Capitulo capitulo;
  _MissionList({this.capitulo});

  List missions;

 /// pelo que tem no git aqui podemos fazer getMissions e em vez de as missions serem só capitulo.missoes
 /// assim no tile já tens a missão correta
 
  @override
  Widget build(BuildContext context) {
    
    missions = capitulo.missoes;
    //getMissions(MissionsNotifier missionsNotifier, missions) ????

    return  ListView.builder(
            itemCount: missions.length,
            itemBuilder: (context,index) {
              return MissionTile(mission_referencia: missions[index]);
            }
          );
  }
}