
import 'package:feature_missoes_moderador/notifier/missions_notifier.dart';
import 'package:feature_missoes_moderador/screens/login/login_screen_tablet.dart';
import './screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';


void main() => runApp(MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) =>
    MissionsNotifier()
    )
    ],
    child:MyApp()));



class MyApp extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

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
    }
    else{
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return false;
    }
  }
 
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
      home: LoginTabletPortrait(),
    );
  }
}
