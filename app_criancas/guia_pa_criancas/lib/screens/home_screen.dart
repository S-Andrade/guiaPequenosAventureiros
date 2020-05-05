import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'aventura/aventura.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import 'aventura/aventura_list.dart';
import 'companheiro/companheiro_appwide.dart';

class HomeScreen extends StatefulWidget {
  final FirebaseUser user;
  HomeScreen({this.user});

  @override
  _HomeScreen createState() => _HomeScreen(user: user);
}

class _HomeScreen extends State<HomeScreen> {
  final FirebaseUser user;
  _HomeScreen({this.user});

  @override
  Widget build(BuildContext context) {
    //DatabaseService().updateAventuraData("1", "1", Timestamp.now() , "Cucujães", ["1"], "Antonieta", "Que o patinho fique bonito!");
    //DatabaseService().updateAventuraData("2", "2", Timestamp.now() , "Aveiro", ["2"], "Joaquim", "Que a Boneca de neve não derreta!");
    //DatabaseService().updateHistoriaData("1", "Patinho feio", ["1","2"], "capas/patinho.jpg");
    //DatabaseService().updateHistoriaData("2", "Boneca de neve", ["1","2"], "capas/branca.webp");
    //DatabaseService().updateCapituloData("1", false, ["1","2"]);
    //DatabaseService().updateCapituloData("2", true, ["1","2"]);
    //DatabaseService().updateEscolaData("1", "Gandarinha", ["4a"]);
    //DatabaseService().updateTurmaData("4a", "Antonio", 2, ["gan01@cucu.pt","gan02@cucu.pt"]);
    //DatabaseService().updateAlunoData("gan01@cucu.pt", "sdvgsiudg", "Zezinho");
    //DatabaseService().updateAlunoData("gan02@cucu.pt", "dskfhgik", "Vanessa");
    return MaterialApp(
      title: 'Guia dos Aventureiros',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamProvider<List<Aventura>>.value(
        value: DatabaseService().aventura,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            colors: [
              Color(0xFF62D7A2),
              Color(0xFF00C9C9),
            ],
          )),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text("As tuas Aventuras")),
            body: Stack(children: <Widget>[
              AventuraList(user: user),
              CompanheiroAppwide(),
            ]),
          ),
        ),
      ),
    );
  }
}
