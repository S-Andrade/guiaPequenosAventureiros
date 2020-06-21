import 'dart:async';

import 'package:app_criancas/services/missions_api.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'aventura/aventura.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import 'aventura/aventura_list.dart';
import 'companheiro/companheiro_appwide.dart';
import 'package:flutter/services.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:pin_code_fields/pin_code_fields.dart';



class HomeScreen extends StatefulWidget {
  final FirebaseUser user;
  HomeScreen({this.user});

  @override
  _HomeScreen createState() => _HomeScreen(user: user);
}

class _HomeScreen extends State<HomeScreen> with AnimationMixin {
  // PIN PAD
  String currentText  = "";
  StreamController<ErrorAnimationType> errorController;
  final formKey = GlobalKey<FormState>();
//  int pinLength = 4;
  bool hasError = false;
  String errorMessage;


  final FirebaseUser user;
  _HomeScreen({this.user});

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onBackPressed() {
    final TextEditingController _pin = TextEditingController();
      TextEditingController pinController = TextEditingController();
    errorController = StreamController<ErrorAnimationType>();


    int _pinIntro = 0;

    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text('Sair da aplicação',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF30246A)),
              ),
            ),
            content: FractionallySizedBox(
                heightFactor: 1,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
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
                      Form(
                        key: formKey,
                        child: PinCodeTextField(
                          length: 4,
                          obsecureText: false,
                          animationType: AnimationType.fade,
//                        validator: (v) {
//                          if (v.length < 3) {
//                            return "I'm from validator";
//                          } else {
//                            return null;
//                          }
//                        },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor:
                            hasError ? Colors.orange : Colors.white,
                          ),
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: Colors.blue.shade50,
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: pinController,
                          onCompleted: (v) {
                            print("Completed");
                            print(currentText);
                            print(currentText.runtimeType);
                          },
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                        ),
                      ),
//                          SizedBox(
//                              width: double.infinity,
//                              child: TextField(
//                                controller: _pin,
//                                onChanged: (value) {
//                                  setState(() {
//                                    _pinIntro = int.parse(value);
//                                  });
//                                },
//                                decoration: InputDecoration(
//                                  contentPadding: EdgeInsets.all(10.0),
//                                  hintText: "Insira o ano em que nasceu",
//                                ),
//                              )),
                    ]))),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("Não"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () async {
                  List datas = await getUserInfoEEPaiMae(user.email);
                  if (datas.contains(_pinIntro)) {
                    print('yes');
                    Navigator.of(context).pop(true);
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  } else {
                    Fluttertoast.showToast(
                        msg: "Verifique se inseriu o pin correto",
                        backgroundColor: Colors.black,
                        textColor: Colors.white);
                  }
                },
                child: Text("Sim"),
              ),
            ],
          ),
        ) ??
        Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Color(0xFFBBA9F9),
    ));

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        title: 'Guia dos Aventureiros',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamProvider<List<Aventura>>.value(
          value: DatabaseService().aventura,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/images/background_sky.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  )),
              child: Scaffold(
                extendBody: true,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Center(
                    child: Text(
                      "Embarcar na Aventura",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: screenHeight > 1000 ? 32 : 24,
                            color: Color(0xFF30246A)),
                      ),
                    ),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.white.withOpacity(0.0),
                ),
                body: Center(
                  child: Stack(children: <Widget>[
                    // Bottom clouds
                    Positioned(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: 0.20,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/clouds_bottom_navigation_white.png'),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            )),
                          ),
                        ),
                      ),
                    ),
                    // Aventuras
                    Positioned.fill(child: AventuraList(user: user)),
                    // Zona do Assistente
                    Positioned(
                        child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF01BBB6).withOpacity(0.4),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                              ),
                              height: 80,
//                            child: Center(
//                              child: Text(
//                                'Em que aventura vamos embarcar hoje?',
//                                textAlign: TextAlign.left,
//                                style: GoogleFonts.pangolin(
//                                  textStyle: TextStyle(
//                                      fontWeight: FontWeight.normal,
//                                      fontSize: 20,
//                                      color: Colors.black),
//                                ),
//                              ),
//                            ),
//                            duration: Duration(seconds: 2),
                            ),
                          ),
                        ],
                      ),
                    )),
                    Positioned(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: FractionallySizedBox(
                          widthFactor: screenHeight < 700 ? 0.8 : screenWidth > 800 ? 0.77 : 0.9,
                          heightFactor: screenHeight < 700 ? 0.14 : screenHeight < 1000 ? 0.14 : 0.20,
                          child: Stack(
                            children: [
                              FlareActor(
                                "assets/animation/dialog.flr",
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.center,
//                        controller: _controller,
                                artboard: 'Artboard',
                                animation: 'open_dialog',
                              ),
                              Center(
                                child: DelayedDisplay(
                                  delay: Duration(seconds: 1),
                                  fadingDuration: const Duration(milliseconds: 800),
                                  slidingBeginOffset: const Offset(0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: screenHeight > 1000 ? 40 : screenHeight < 700 ? 16 : 20.0, right: screenHeight > 1000 ? 130 : screenHeight < 700 ? 60 : 100),
                                    child: Text(
                                    "Vamos escolher uma aventura para começar a diversão?",
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.pangolin(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: screenHeight < 700 ? 16 : screenHeight < 1000 ? 20 : 32,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Align(
                          alignment: Alignment.topRight,
                          child: DelayedDisplay(
//                          delay: Duration(seconds: 1),
                              fadingDuration: const Duration(milliseconds: 800),
//                          slidingBeginOffset: const Offset(-0.5, 0.0),
                              child: CompanheiroAppwide())),
                    ),
                  ]),
                ),
//              bottomNavigationBar: BottomNavigationBar(
////              type: BottomNavigationBarType.shifting,
//                backgroundColor: Colors.transparent,
//                selectedItemColor: Colors.black,
//                unselectedItemColor: Colors.white,
//                elevation: 0,
//                items: const <BottomNavigationBarItem>[
//                  BottomNavigationBarItem(
//                    icon: Icon(Icons.home),
//                    title: Text('Home'),
//                  ),
//                  BottomNavigationBarItem(
//                    icon: Icon(Icons.business),
//                    title: Text('Business'),
//                  ),
//                  BottomNavigationBarItem(
//                    icon: Icon(Icons.school),
//                    title: Text('School'),
//                  ),
//                ],
//              ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
