import 'package:flutter/material.dart';
import './screens/login/login_screen.dart';
import './auth.dart';

void main() => runApp(MyApp());



class MyApp extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    //criar users na base de dados
    //Auth().signUp('gan01@cucu.pt','password');
    return MaterialApp(
      title: 'Guia de Pequenos Aventureiros',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF7C4DFF),
        accentColor: Color(0xFF64FFDA),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      home: LoginScreen(),
    );
  }
}