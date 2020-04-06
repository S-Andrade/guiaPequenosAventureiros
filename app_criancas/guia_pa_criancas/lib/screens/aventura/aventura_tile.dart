import 'aventura.dart';
import 'package:flutter/material.dart';
import 'aventura_details.dart';

class AventuraTile extends StatelessWidget {

  final Aventura aventura;
  AventuraTile({ this.aventura });

  @override
  Widget build(BuildContext context) {
    print(aventura);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AventuraDetails(aventura: aventura)));
        } ,
        child:Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          
          child: ListTile(
            title: Text(aventura.nome),
            subtitle: Text(aventura.moderador),
          ),
        ),
      ),
    );
  }
}