import 'dart:io';
import 'package:app_criancas/auth.dart';
import 'package:app_criancas/services/missions_api.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'notifier/missions_notifier.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => MissionsNotifier()),
    ], child: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  FirebaseAnalytics analytics = FirebaseAnalytics();

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
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Clica duas vezes para sair da aplicação",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return true;
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return showDialogPin();
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

  showDialogPin() {
    final _pin = TextEditingController();
    int _pinIntro = 0;
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
            ),
            child: AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                "Insira o seu pin",
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                      color: Colors.yellow),
                ),
              ),
              content: FractionallySizedBox(
                heightFactor: 0.4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: [
                      Text(
                        "Para sair da aplicação deves pedir ajuda aos teus pais!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                              color: Color(0xFF30246A)),
                        ),
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: _pin,
                            onChanged: (value) {
                              setState(() {
                                 _pinIntro = int.parse(value);
                              });
                            },
                            decoration: InputDecoration(
                               contentPadding: EdgeInsets.all(10.0),
                               hintText: "Insira o ano em que nasceu",
                            ),
                          )),
                      SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          onPressed: () {
                            Auth().getUser().then((user){
                              List datas = getUserInfoEEPaiMae(user.email);
                              print(datas);
                          });
                          },
                          color: Colors.red,
                          child: new Text(
                            'Sair',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
