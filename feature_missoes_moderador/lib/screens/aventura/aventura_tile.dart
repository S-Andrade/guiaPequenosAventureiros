import 'aventura.dart';
import 'package:flutter/material.dart';
import 'aventura_option.dart';
import 'aventura_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AventuraTile extends StatelessWidget {

  final Aventura aventura;
  final FirebaseUser user;
  AventuraTile({ this.user, this.aventura });

  @override
  Widget build(BuildContext context) {
    print(aventura);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AventuraOption(aventura: aventura)));
        } ,
        child:Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          
          child: ListTile(
            title: Text(aventura.nome),
            subtitle: Text(aventura.moderador),
            trailing: IconButton(icon: Icon(Icons.edit), onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => AventuraEdit(user: user , aventura: aventura)));
            }),
          ),
        ),
      ),
    );
  }
}