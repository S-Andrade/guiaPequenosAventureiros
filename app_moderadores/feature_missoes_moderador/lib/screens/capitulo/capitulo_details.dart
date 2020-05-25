import 'package:feature_missoes_moderador/screens/tab/tab.dart';
import 'package:flutter/material.dart';
import 'capitulo.dart';
import '../aventura/aventura.dart';


class CapituloDetails extends StatefulWidget {

  Capitulo capitulo;
  Aventura aventura;

  CapituloDetails({this.capitulo,this.aventura});

  @override
  _CapituloDetails createState() => _CapituloDetails(capitulo: capitulo,aventura:aventura);
}

class _CapituloDetails extends State<CapituloDetails> {

  Aventura aventura;
  Capitulo capitulo;
  _CapituloDetails({this.capitulo,this.aventura});

  @override
  Widget build(BuildContext context) {
        return  new Scaffold(
            body: TabBarMissions(capitulo:capitulo,aventura:aventura),
        );
            
  }
}