import 'package:app_criancas/screens/companheiro/companheiro_creation.dart';
import 'package:app_criancas/screens/login/user_data_screen_tablet.dart';
import 'package:app_criancas/services/missions_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../home_screen.dart';
import '../../auth.dart';

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

  final myControllerEmail = TextEditingController();
  final myControllerPass = TextEditingController();

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  @override
  void initState() {
    autoLogIn();
    super.initState();
  }

  bool isLoggedIn = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerEmail.dispose();
    myControllerPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    return Scaffold(
        key: _scaffoldKey,
        body: Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background_sky.png'),
                      fit: BoxFit.cover)),
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FractionallySizedBox(
                        // Filling c/ 1
                        widthFactor: 1,
                        child: FractionallySizedBox(
                          widthFactor: screenHeight < 700 ? 0.7 : 0.8,
                          child: SvgPicture.asset(
                            'assets/images/logo_temp.svg',
//                            width: 50,
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                          widthFactor: 0.65,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Bem-vindo!',
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenHeight < 700 ? 24 : 28,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, bottom: 8.0),
                                child: Text(
                                  'Introduza aqui os dados de acesso fornecidos',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: screenHeight < 700 ? 16 : 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                    screenHeight < 700 ? 4 : 10.0),
                                child: TextFormField(
                                    controller: myControllerEmail,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenHeight < 700 ? 16 : 18,
                                      ),
                                    ),
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Nome do utilizador não inserido';
                                      }
                                    },
                                    onSaved: (input) {
                                      email = input;
                                    },
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(0.0),
                                        fillColor: Colors.white,
                                        hoverColor: Colors.white,
                                        filled: true,
                                        hintText: 'Código de utilizador',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0x99D3D3D3),
                                              width: 1),
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(10.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(10.0),
                                            ),
                                            borderSide: BorderSide(
                                                color: Color(0x55FF2C5A),
                                                width: 2))
//                                        border: InputBorder.none,
//
                                        )),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.all(screenHeight < 700 ? 4 : 10),
                                child: TextFormField(
                                    controller: myControllerPass,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenHeight < 700 ? 16 : 18,
                                      ),
                                    ),
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Chave de acesso não inserida';
                                      }
                                    },
                                    onSaved: (input) {
                                      pass = input;
                                    },
                                    decoration: InputDecoration(
//                                        icon: new Icon(Icons.lock, color: Color(0xff224597)),
                                        contentPadding: EdgeInsets.all(0.0),
                                        fillColor: Colors.white,
                                        hoverColor: Colors.white,
                                        filled: true,
                                        hintText: 'Chave de acesso',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0x99D3D3D3),
                                              width: 1),
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(10.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(10.0),
                                            ),
                                            borderSide: BorderSide(
                                                color: Color(0x55FF9B24),
                                                width: 2))
//                                        border: InputBorder.none,
//
                                        )),
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                    screenHeight < 700 ? 4 : 10.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: FlatButton(
                                    color: Color(0xFFFF9B24),
                                    textColor: Colors.white,
                                    disabledColor: Color(0x55FFFFFF),
                                    padding: EdgeInsets.all(12.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    child: Text(
                                      'Entrar',
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize:
                                              screenHeight < 700 ? 16 : 20,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      loginUser();
                                    },
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            )));
  }

  getInfo(email) async {
    bool data = await getUserInfo(email);
    print(data);
    return data;
  }

  getCompInfo(email) async {
    bool data = await getUserAmigo(email);
    print('Amigo');
    print(data);
    return data;
  }

  //se já tiver feito login uma vez
  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');
    final String password = prefs.getString('password');
    if (userId != null) {
      AuthResult result;
      result = await auth.signInWithEmailAndPassword(
          email: userId, password: password);
      FirebaseUser user = result.user;
      bool flag = await getInfo(userId);
      bool flag2 = await getCompInfo(userId);
      if (flag) {
        if (flag2) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateCompanheiro()));
        }
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserData(user: user)));
      }
      setState(() {
        email = userId;
        pass = password;
        isLoggedIn = true;
      });
      return;
    }
  }

  //inicia a primeira vez
  Future<void> loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', myControllerEmail.text);
    prefs.setString('password', myControllerPass.text);
    AuthResult result;
    result = await Auth()
        .signIn(context, myControllerEmail.text, myControllerPass.text);
    FirebaseUser user = result.user;
    setState(() {
      email = myControllerEmail.text;
      pass = myControllerPass.text;
      print(email);
      print(pass);
    });
    bool flag = await getInfo(email);
    bool flag2 = await getCompInfo(email);
    if (flag) {
      if (flag2) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreateCompanheiro()));
      }
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => UserData(user: user)));
    }
    myControllerEmail.clear();
    myControllerPass.clear();
  }
}
