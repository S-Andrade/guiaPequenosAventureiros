import 'capitulo.dart';
import 'package:flutter/material.dart';

import 'capitulo_missoes.dart';

class CapituloTile extends StatelessWidget {

  final Capitulo capitulo;
  CapituloTile({ this.capitulo });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: bloqueio(context)
    ); 
  }

  Widget bloqueio(BuildContext context){
    if (!capitulo.bloqueado){
      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CapitulosDetailsMissoes(missoes: capitulo.missoes, id: capitulo.id)));
        } ,
        child:Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          
          child: ListTile(
            title: Text(capitulo.id, style: TextStyle(color: Colors.blue)),
            subtitle: Text(capitulo.bloqueado.toString(),style: TextStyle(color: Colors.blue)),
          ),
        ),
      );
    }else{
      return  Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            title: Text(capitulo.id),
            subtitle: Text(capitulo.bloqueado.toString()),
          ),
        ),
      );
    }
  }
}
