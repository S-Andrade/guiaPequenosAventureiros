import 'dart:io';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'notifier/missions_notifier.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => MissionsNotifier()),
    ], child: MyApp()));
} 

class MyApp extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  DateTime backbuttonpressedTime;

  bool myInterceptor(bool stopDefaultButtonEvent) {
    DateTime currentTime = DateTime.now();
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 4);
    if (backButton) {
      print('aqui');
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Clica duas vezes para sair da aplicação",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return true;
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate, // if it's a RTL language
      ],
      supportedLocales: [
        const Locale('pt', 'PT'), // include country code too
      ],
      title: 'Guia de Pequenos Aventureiros',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF7C4DFF),
        accentColor: Color(0xFF64FFDA),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      home: LoginScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
