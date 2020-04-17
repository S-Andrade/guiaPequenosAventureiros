import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './screens/login/login_screen.dart';
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      home: LoginScreen(),
    );
  }
}
