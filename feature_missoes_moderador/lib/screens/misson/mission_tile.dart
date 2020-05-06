import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mission.dart';

class MissionTile extends StatelessWidget {

  //aqui estou a passar um DocumentREference, mas se passar a Missão era muito melhor, 
  //para isso na mission_list.dart é preciso fazer o getMissoes como tem nas crianças
  
  DocumentReference mission_referencia;
  MissionTile({ this.mission_referencia });

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () {
                    ////
                  } ,
                  child:Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    
                    child: ListTile(
                      title: Text(mission_referencia.toString()),
                    ),
                  ),
                ),
              );    
  }


}