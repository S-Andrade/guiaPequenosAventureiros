import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'aventura/aventura.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import 'aventura/aventura_list.dart';



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
        primarySwatch: Colors.yellow,
      ),
     home: StreamProvider<List<Aventura>>.value(
      value : DatabaseService().aventura,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Guia dos pequenos Aventureiros")
        ),
        body: AventuraList(user: user),
      ),
      
    ),
    );
  }
}