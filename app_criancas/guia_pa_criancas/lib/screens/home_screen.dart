import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'aventura/aventura.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import 'aventura/aventura_list.dart';
import 'companheiro/companheiro_appwide.dart';
import 'package:flutter/services.dart';

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Color(0xFFC499FA),
    ));
    return MaterialApp(
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
                  image: AssetImage('assets/images/background_app.png'),
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
                          fontSize: 28,
                          color: Color(0xFF30246A)),
                    ),
                  ),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              body: Center(
                child: Stack(children: <Widget>[
                  // Aventuras
                  Positioned.fill(child: AventuraList(user: user)),
                  // Bottom clouds
                  Positioned(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(
                              'assets/images/clouds_bottom_navigation_purple.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        )),
                      ),
                    ),
                  ),
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
                              borderRadius: BorderRadius.all(
                                  Radius.circular(40)),
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
//                    right: 30,
                    child: Align(
                        alignment: Alignment.topRight,
                        child: CompanheiroAppwide()),
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
    );
  }
}
