import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guia/aventura/aventura.dart';
import 'package:guia/database/database.dart';
import 'package:provider/provider.dart';
import 'package:guia/aventura/aventura_list.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guia dos Aventureiros',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
     home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //DatabaseService().updateAventuraData("1", "1", Timestamp.now() , "Cucujães", ["1"], "Antonieta", "Que o patinho fique bonito!");
    //DatabaseService().updateAventuraData("2", "2", Timestamp.now() , "Aveiro", ["2"], "Joaquim", "Que a Boneca de neve não derreta!");
    //DatabaseService().updateHistoriaData("1", "Patinho feio", ["1","2"], "patinho.jpg");
    //DatabaseService().updateHistoriaData("2", "Boneca de neve", ["1","2"], "branca.webp");
    //DatabaseService().updateCapituloData("1", false, ["1","2"]);
    //DatabaseService().updateCapituloData("2", true, ["1","2"]);
    //DatabaseService().updateEscolaData("1", "Gandarinha", ["4a"]);
    //DatabaseService().updateTurmaData("4a", "Antonio", 2, ["gan1","gan2"]);
    //DatabaseService().updateAlunoData("gan1", "sdvgsiudg", "Zezinho");
    //DatabaseService().updateAlunoData("gan2", "dskfhgik", "Vanessa");
    return StreamProvider<List<Aventura>>.value(
      value : DatabaseService().aventura,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Guia dos pequenos Aventureiros")
        ),
        body: AventuraList(),
      ),
      
    );
  }
}