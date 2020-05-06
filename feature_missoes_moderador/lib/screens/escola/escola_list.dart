import 'package:flutter/material.dart';
import 'escola_tile.dart';
import '../aventura/aventura.dart';


class EscolaList extends StatefulWidget {

  Aventura aventura;
  EscolaList({this.aventura});

  @override
  _EscolaList createState() => _EscolaList(aventura: aventura);
}

class _EscolaList extends State<EscolaList> {

  Aventura aventura;
  _EscolaList({this.aventura});

  @override
  Widget build(BuildContext context) {
        return  ListView.builder(
                itemCount: aventura.escolas.length,
                itemBuilder: (context,index) {
                  return EscolaTile(escola: aventura.escolas[index], aventura:aventura);
                }
              );
  }
}