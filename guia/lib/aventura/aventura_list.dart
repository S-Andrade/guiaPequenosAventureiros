import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guia/aventura/aventura.dart';
import 'package:provider/provider.dart';
import 'package:guia/aventura/aventura_tile.dart';

class AventuraList extends StatefulWidget {
  @override
  _AventuraListState createState() => _AventuraListState();
}

class _AventuraListState extends State<AventuraList> {
  @override
  Widget build(BuildContext context) {
    final aventura = Provider.of<List<Aventura>>(context);
   
    return ListView.builder(
      itemCount: aventura.length,
      itemBuilder: (context,index) {
        return AventuraTile(aventura: aventura[index]);
      }
    );
  }
}