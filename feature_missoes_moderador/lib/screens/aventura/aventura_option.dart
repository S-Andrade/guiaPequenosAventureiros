import 'package:feature_missoes_moderador/screens/participantes/participantes.dart';
import 'package:flutter/material.dart';
import 'aventura.dart';
import 'aventura_details.dart';
import 'aventura_capitulo.dart';

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
        return  Scaffold(
            appBar: new AppBar(title: new Text("Guia de Pequenos Aventureiros")),
            body: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 200), 
                  child: Center(
                    child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ParticipantesScreen(escolasId:aventura.escolas,aventuraId: aventura.id,)));
                          },
                          child: Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                  )
                                ]),
                            child: Center(
                                child: Text(
                              'Participantes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.0,
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Amatic SC'),
                            )),
                          ),
                  ),
                  )),
                Padding(
                  padding: const EdgeInsets.only(top: 100), 
                  child: Center(
                  child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AventuraCapitulo(aventura: aventura)));
                          },
                          child: Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                  )
                                ]),
                            child: Center(
                                child: Text(
                              'Capitulos',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.0,
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Amatic SC'),
                            )),
                          ),
                        ),
                ),
                  ),
              ],
              )
          );
  }
}