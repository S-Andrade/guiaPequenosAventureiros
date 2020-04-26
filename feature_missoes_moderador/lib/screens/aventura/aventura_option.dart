import 'package:flutter/material.dart';
import 'aventura.dart';
import 'aventura_details.dart';
import '../capitulo/capitulo_list.dart';

class AventuraOption extends StatefulWidget {

  Aventura aventura;
  AventuraOption({this.aventura});

  @override
  _AventuraOption createState() => _AventuraOption(aventura: aventura);
}

class _AventuraOption extends State<AventuraOption> {

  Aventura aventura;
  _AventuraOption({this.aventura});

  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Guia dos Aventureiros',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: Scaffold(
            body: Column(
              children: <Widget>[
                 new RaisedButton(
                  onPressed: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => AventuraDetails(aventura: aventura)));
                  },
                  child: Text("Participantes"),
                  color: Colors.green,
                ),
                new RaisedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CapituloList(aventura: aventura)));
                  },
                  child: Text("Capitulos"),
                  color: Colors.red,
                ),
              ],
              )
          )
          );
  }
}