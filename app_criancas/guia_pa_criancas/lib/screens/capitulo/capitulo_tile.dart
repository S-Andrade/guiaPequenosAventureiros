import '../missions/all_missions/all_missions_screen.dart';
import 'capitulo.dart';
import 'package:flutter/material.dart';

class CapituloTile extends StatelessWidget {
  final Capitulo capitulo;
  CapituloTile({this.capitulo});

  Widget build(BuildContext context) {
    if (!capitulo.bloqueado) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AllMissionsScreen(capitulo.missoes)));
        },
        child: Container(
          child: Card(
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: ListTile(
              title: Text(capitulo.id, style: TextStyle(color: Colors.blue)),
              subtitle: Text(capitulo.bloqueado.toString(),
                  style: TextStyle(color: Colors.blue)),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          child: Card(
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: ListTile(
              title: Text(capitulo.nome.toString()),
              subtitle: Text(capitulo.bloqueado.toString()),
            ),
          ),
        ),
      );
    }
  }
}
