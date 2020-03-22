import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(child:Text("Sucesso")),
    );
  }
}