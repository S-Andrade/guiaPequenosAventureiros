import 'package:flutter/material.dart';
import 'capitulo.dart';
import '../mission/mission_list.dart';

class CapituloDetails extends StatefulWidget {

  Capitulo capitulo;
  CapituloDetails({this.capitulo});

  @override
  _CapituloDetails createState() => _CapituloDetails(capitulo: capitulo);
}

class _CapituloDetails extends State<CapituloDetails> {

  Capitulo capitulo;
  _CapituloDetails({this.capitulo});

  @override
  Widget build(BuildContext context) {
        return  new Scaffold(
            body: MissionList(capitulo: capitulo),
        );
            
  }
}