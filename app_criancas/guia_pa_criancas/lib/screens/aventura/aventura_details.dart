import 'aventura.dart';
import 'package:flutter/material.dart';
import '../historia/historia_details.dart';

class AventuraDetails extends StatelessWidget {

  final Aventura aventura;
  AventuraDetails({ this.aventura });

  @override
  Widget build(BuildContext context) {
    print(aventura);
    return Scaffold(
      appBar: AppBar(
        title: Text(aventura.nome)
      ),
      body: ShowHistoriaDetails(idHistoria: aventura.historia)
    );
  }

}

class ShowHistoriaDetails extends StatelessWidget {

  final String idHistoria;
  ShowHistoriaDetails({ this.idHistoria });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: HistoriaDetails(id: idHistoria)
    );
      
  }
}