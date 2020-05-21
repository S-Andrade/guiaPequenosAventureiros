import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:feature_missoes_moderador/screens/aventura/aventura_create.dart';
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
    
    return MaterialApp(
      title: 'Guia dos Pequenos Aventureiros',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     home: StreamProvider<List<Aventura>>.value(
      value : DatabaseService().aventura,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: parseColor("#FFCE02"),
          title: Text("Home")
        ),
        body: Scaffold(
            body: AventuraList(user: user),
            floatingActionButton: FloatingActionButton(
              tooltip: "Criar Aventura Nova",
              
              onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => AventuraCreate(user:user)));
              },
              child: Icon(Icons.add),
              
              backgroundColor: parseColor("#432F49"),
            ),
          )
      ),
      
    ),
    );
  }
}