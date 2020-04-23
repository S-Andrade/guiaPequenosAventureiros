import 'package:flutter/material.dart';
import 'escola_tile.dart';

class EscolaList extends StatefulWidget {

  List escolas;
  EscolaList({this.escolas});

  @override
  _EscolaList createState() => _EscolaList(escolas: escolas);
}

class _EscolaList extends State<EscolaList> {

  List escolas;
  _EscolaList({this.escolas});

  @override
  Widget build(BuildContext context) {
        return  ListView.builder(
                itemCount: escolas.length,
                itemBuilder: (context,index) {
                  return EscolaTile(escola: escolas[index]);
                }
              );
  }
}