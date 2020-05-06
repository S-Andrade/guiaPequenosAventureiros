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
            appBar: new AppBar(title: new Text("Capitulos")),
            body: CapituloList(aventura: aventura),
          );
  }
}