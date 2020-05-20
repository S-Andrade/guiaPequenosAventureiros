import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';
import 'aventura.dart';
import '../capitulo/capitulo_list.dart';

class AventuraCapitulo extends StatefulWidget {

  Aventura aventura;
  AventuraCapitulo({this.aventura});

  @override
  _AventuraCapitulo createState() => _AventuraCapitulo(aventura: aventura);
}

class _AventuraCapitulo extends State< AventuraCapitulo> {

  Aventura aventura;
  _AventuraCapitulo({this.aventura});

  @override
  Widget build(BuildContext context) {
        return  new Scaffold(
            appBar: new AppBar(title: new Text("Capítulos de "+aventura.nome),backgroundColor: parseColor("#432F49"),),
            body: Container(decoration:
              BoxDecoration(
              image: DecorationImage(
          image: AssetImage("assets/images/mais_back.png"),
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),),
              child: CapituloList(aventura: aventura)),
          );
  }
}