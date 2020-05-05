import 'package:flutter/material.dart';
import '../escola/escola_list.dart';
import '../escola/escola_create.dart';
import 'aventura.dart';

class AventuraDetails extends StatefulWidget {

  Aventura aventura;
  AventuraDetails({this.aventura});

  @override
  _AventuraDetails createState() => _AventuraDetails(aventura: aventura);
}

class _AventuraDetails extends State<AventuraDetails> {

  Aventura aventura;
  _AventuraDetails({this.aventura});

  @override
  Widget build(BuildContext context) {
        return  new Scaffold(
            appBar: new AppBar(title: new Text("Escolas")),
            body: EscolaList(aventura: aventura),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => EscolaCreate(aventura: aventura)));
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
          );
  }
}