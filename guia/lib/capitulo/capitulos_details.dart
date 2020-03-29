
import 'package:flutter/material.dart';
import 'package:guia/capitulo/capitulo.dart';
import 'package:guia/database/database.dart';
//import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guia/capitulo/capitulo_list.dart';
//import 'package:guia/aventura.dart';


class CapitulosDetails extends StatelessWidget {

  final List capitulos;
  CapitulosDetails({ this.capitulos });

   @override
  Widget build(context) {
    return StreamProvider<List<Capitulo>>.value(
      value : DatabaseService().capitulo,
      child: Scaffold( 
        body: CapituloList(capitulos: capitulos)
      )
    );
  }
}