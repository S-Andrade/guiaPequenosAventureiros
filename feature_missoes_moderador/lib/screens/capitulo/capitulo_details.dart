import 'package:flutter/material.dart';
import 'capitulo.dart';
import 'package:feature_missoes_moderador/screens/tab/tab.dart';


class CapituloDetails extends StatefulWidget {

  Capitulo capitulo;
  String aventuraId;

  CapituloDetails({this.capitulo,this.aventuraId});

  @override
  _CapituloDetails createState() => _CapituloDetails(capitulo: capitulo,aventuraId:aventuraId);
}

class _CapituloDetails extends State<CapituloDetails> {

  String aventuraId;
  Capitulo capitulo;
  _CapituloDetails({this.capitulo,this.aventuraId});

  @override
  Widget build(BuildContext context) {
        return  new Scaffold(
            body: TabBarMissions(capitulo:capitulo,aventuraId:aventuraId),
        );
            
  }
}