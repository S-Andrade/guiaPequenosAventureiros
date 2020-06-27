import 'package:flutter/material.dart';
import 'capitulo.dart';
import '../../services/database.dart';
import 'package:provider/provider.dart';
import 'capitulo_list.dart';

class CapitulosDetails extends StatelessWidget {
  final List capitulos;
  CapitulosDetails({this.capitulos});

  @override
  Widget build(context) {
    return StreamProvider<List<Capitulo>>.value(
        value: DatabaseService().capitulo,
        child: CapituloList(capitulos: capitulos));
  }
}
