import 'package:flutter/material.dart';
import 'package:project_app_criancas/screens/missions/all_missions/all_missions_screen.dart';
import 'package:provider/provider.dart';
import 'notifier/missions_notifier.dart';

void main() => runApp(MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) =>
    MissionsNotifier()
    ),
    ],
    child:MyApp()));



class MyApp extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    
    
    return MaterialApp(
      title: 'Guia de Pequenos Aventureiros',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF7C4DFF),
        accentColor: Color(0xFF64FFDA),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      home: AllMissionsScreen(),
    );
  }
}
