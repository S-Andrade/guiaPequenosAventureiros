import 'package:flutter/material.dart';
import 'aventura.dart';
import 'package:provider/provider.dart';
import 'aventura_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AventuraList extends StatefulWidget {

  final FirebaseUser user;
  AventuraList({this.user});
  
  @override
  _AventuraListState createState() => _AventuraListState(user: user);
}

class _AventuraListState extends State<AventuraList> {

  final FirebaseUser user;
  _AventuraListState({this.user});
  
  List<Aventura> aventuras = [];
  List<Aventura> aventura;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
            future: getAventuras(context),
            builder: (context, AsyncSnapshot<void> snapshot) {
              return ListView.builder(
                itemCount: aventuras.length,
                itemBuilder: (context,index) {
                  return AventuraTile(user:user, aventura: aventuras[index]);
                }
              );
            }
      ); 
  }

  Future<void> getAventuras(BuildContext context) async{
    aventuras = [];
    aventura = Provider.of<List<Aventura>>(context);

    for (Aventura a in aventura){
      if(a.moderador == user.email){
        aventuras.add(a);
      }
    }
 
  }
}