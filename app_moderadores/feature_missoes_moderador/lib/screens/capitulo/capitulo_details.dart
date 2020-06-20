import 'package:feature_missoes_moderador/screens/tab/tab.dart';
import 'package:flutter/material.dart';
import 'capitulo.dart';
import '../aventura/aventura.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';

class CapituloDetails extends StatefulWidget {

  Capitulo capitulo;
  Aventura aventura;

  CapituloDetails({this.capitulo,this.aventura});

  @override
  _CapituloDetails createState() => _CapituloDetails(capitulo: capitulo,aventura:aventura);
}

class _CapituloDetails extends State<CapituloDetails> {

  Aventura aventura;
  Capitulo capitulo;
  _CapituloDetails({this.capitulo,this.aventura});

  @override
  Widget build(BuildContext context) {
      return FutureBuilder<void>(
        future: getCapitulo(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError)
                return new Text('Erro: ${snapshot.error}');
              else
                return             
        new Scaffold(
            body: TabBarMissions(capitulo:capitulo,aventura:aventura),
        );
          break;
            default:
              return Container();
          }});

            
  }
   Future<void> getCapitulo() async {
    DocumentReference documentReference =
        Firestore.instance.collection("capitulo").document(capitulo.id);
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        capitulo = Capitulo(
            id: datasnapshot.data['id'] ?? '',
            bloqueado: datasnapshot.data['bloqueado'] ?? null,
            missoes: datasnapshot.data['missoes'] ?? [],
            nome: datasnapshot.data['nome'] ?? 0,
            disponibilidade: datasnapshot.data['disponibilidade'] ?? {});
      
      } else {
        print("No such capitulo");
      }
    });
  }
}