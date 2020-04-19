import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../home_screen.dart';
import 'user_data_screen_tablet.dart';

///////// VISTA TABLET PORTRAIT

class LoginTabletPortrait extends StatefulWidget {
  @override
  _LoginTabletPortraitState createState() => _LoginTabletPortraitState();
}

class _LoginTabletPortraitState extends State<LoginTabletPortrait> {
  String email = "";
  String pass = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  final myControllerEmail = TextEditingController();
  final myControllerPass = TextEditingController();
  bool isLoggedIn = false;

   @override
  void initState() {
    autoLogIn();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerEmail.dispose();
    myControllerPass.dispose();
    super.dispose();
  }

  final String logoSVG = 'assets/images/logo.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,

        body: Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background_sky.png'),
                      fit: BoxFit.cover)
//                gradient: LinearGradient(
//                  begin: Alignment.topCenter,
//                  end: Alignment.bottomCenter,
//                  stops: [0.0, 1.0],
//                  colors: [
//                    Color(0xFF62D7A2),
//                    Color(0xFF00C9C9),
//                  ],
//                ),
                  ),
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FractionallySizedBox(
                          // 1 ta a segurar a largura, mudar
                          widthFactor: 1,
                          child: SvgPicture.asset(
                            'assets/images/logo_temp.svg',
//                            width: 50,
                          ),
                        ),
                        FractionallySizedBox(
                            widthFactor: 0.6,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4.0,
                                          )
                                        ]),
                                    child: TextFormField(
                                        controller: myControllerEmail,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Amatic SC',
                                            letterSpacing: 4),
                                        validator: (input) {
                                          if (input.isEmpty) {
                                            return 'Nome do utilizador não inserido';
                                          }
                                        },
                                        onSaved: (input) {
                                          email = input;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Nome do utilizador   ',
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              bottom: 10.0, left: 50.0, right: 10.0),
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4.0,
                              )
                            ]),
                        child: TextFormField(
                            controller: myControllerPass,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 4),
                            validator: (input) {
                              if (input.isEmpty) {
                                  return 'Palavra-passe não inserido';
                              }
                            },
                            onSaved: (input) {
                              pass = input;
                            },
                            decoration: InputDecoration(
                              hintText: 'Palavra-passe   ',
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                    bottom: 10.0, left: 50.0, right: 10.0),
                            )),
                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: FractionallySizedBox(
                                    widthFactor: 0.4,
                                    child: GestureDetector(
                                      onTap: () {
                                        loginUser();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 4.0,
                                              )
                                            ]),
                                        child: Center(
                                            child: Text(
                                              'Entrar',
                                              style: TextStyle(
                                                  fontSize: 26.0,
                                                  letterSpacing: 3,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Amatic SC'),
                                            )),
                                      ),
                                    ),
                                  ),
                                )

                              ],
                            )),

                      ],
                    ),
                  )
                ],
              ),
            )));
  }
  //se já tiver feito login uma vez
  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');
    final String password = prefs.getString('password');

    if (userId != null) {
      setState(() async {
        email = userId;
        pass = password;
        isLoggedIn = true;
        AuthResult result;
        result = await auth.signInWithEmailAndPassword(email:email.trim(), password: pass);
        FirebaseUser user = result.user;
        isLoggedIn=true;
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user:user)));
      });
      return;
    }
  }
  
  //inicia a primeira vez

  Future<void> loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', myControllerEmail.text);
    prefs.setString('password', myControllerPass.text);
    setState(() async {
      email = myControllerEmail.text;
      pass = myControllerPass.text;
      print(email);
      print(pass);
      AuthResult result;
      try{
        result = await auth.signInWithEmailAndPassword(email:email.trim(), password: pass);
        FirebaseUser user = result.user;
        isLoggedIn=true;
        Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserData(user:user)));
      }catch(e){
        print(e.toString());
        showDialog(
              context: context,
              builder: (BuildContext context) {
                // retorna um objeto do tipo Dialog
                return AlertDialog(
                  title: new Text("Problema de autenticação"),
                  content: new Text("Nome do utilizador ou palavra-passe incorreta!"),
                  actions: <Widget>[
                    // define os botões na base do dialogo
                    new FlatButton(
                      child: new Text("Fechar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
      }
    });
    myControllerEmail.clear();
    myControllerPass.clear();
  }
}

///////// VISTA TABLET LANDSCAPE

class LoginTabletLandscape extends StatefulWidget {
  @override
  _LoginTabletLandscapeState createState() => _LoginTabletLandscapeState();
}

class _LoginTabletLandscapeState extends State<LoginTabletLandscape> {
  String email = "";
  String pass = "";
  bool isLoggedIn = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final myControllerPass = TextEditingController();
  final myControllerEmail = TextEditingController();

  @override
  void initState() {
    autoLogIn();
    super.initState();
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerEmail.dispose();
    myControllerPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.yellow[600],
        body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.yellow[600],
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 70),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Text(
                                      "Crianças: Guia de Pequenos Aventureiros",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                          fontSize: 60.0,
                                          letterSpacing: 5,
                                          fontWeight: FontWeight.bold,
                                         ))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '...mas ainda não estou pronto, dás-me uma ajuda?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                  ,
                                  color: Colors.white),
                            ),
                          ),
                        ),
//                        Padding(
//                          padding: const EdgeInsets.only(top: 50, bottom: 20),
//                          child: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Text('LOGIN',
//                                  style: GoogleFonts.quicksand(
//                                    textStyle: TextStyle(
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 20
//                                        ,
//                                        color: Colors.white),
//                                  ),)
//                              ]),
//                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 90),
                          child: Container(
                              height: 10, width: 140, color: Colors.black),
                        ),
                        Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                  )
                                ]),
                            child: Center(
                              child: TextFormField(
                                  controller: myControllerEmail,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 4),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Nome do utilizador não inserido';
                                    }
                                  },
                                  onSaved: (input) {
                                    email = input;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Nome do utilizador   ',
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 50.0, right: 10.0),
                                  )),
                            )),
                        Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                  )
                                ]),
                            child: Center(
                              child: TextFormField(
                                  controller: myControllerPass,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 4),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Palavra-passe não inserido';
                                    }
                                  },
                                  onSaved: (input) {
                                    pass = input;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Palavra-passe   ',
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 50.0, right: 10.0),
                                  )),
                            )),
                        SizedBox(height: 50),
                        GestureDetector(
                          onTap: () {
                            print("-----EMAIL------");
                            print(myControllerEmail.text);
                            loginUser();
                          },
                          child: Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                  )
                                ]),
                            child: Center(
                                child: Text(
                              'Entrar',
                              style: TextStyle(
                                  fontSize: 26.0,
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Amatic SC'),
                            )),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  //se já tiver feito login uma vez
  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');
    final String password = prefs.getString('password');

    if (userId != null) {
      setState(() {
        email = userId;
        pass = password;
        isLoggedIn = true;
      });
      return;
    }
  }
  
  //inicia a primeira vez
  Future<Null> loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', myControllerEmail.text);
    prefs.setString('password', myControllerPass.text);
    setState(() {
      email = myControllerEmail.text;
      pass = myControllerPass.text;
      isLoggedIn=true;
    });
    myControllerEmail.clear();
    myControllerPass.clear();
  }



}
