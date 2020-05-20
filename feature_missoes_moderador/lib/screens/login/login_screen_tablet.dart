import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import '../home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../moderador/moderador.dart';
import '../../services/database.dart';

///////// VISTA TABLET PORTRAIT

class LoginTabletPortrait extends StatefulWidget {
  @override
  _LoginTabletPortraitState createState() => _LoginTabletPortraitState();
}

class _LoginTabletPortraitState extends State<LoginTabletPortrait> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Moderador> listModerador;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<List<Moderador>>.value(
              value: DatabaseService().moderador),
        ],
        child: Builder(builder: (BuildContext context) {
          return FutureBuilder<void>(
              future: getListModerador(context),
              builder: (context, AsyncSnapshot<void> snapshot) {
                return Scaffold(
                    key: _scaffoldKey,
                    body: Form(
                        key: _formKey,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/background_sky.png'),
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
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        /*Container(
                              height:150,width:150,child: SvgPicture.asset(
                            'assets/images/logo_temp.svg',
//                            width: 50,
                              ),),
                            */
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 120, bottom: 50),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text('Moderadores',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: 2,
                                                        fontFamily:
                                                            'Monteserrat'))
                                              ]),
                                        ),
                                        Container(
                                            width: 350,
                                            height: 80,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0x99D3D3D3),
                                                    blurRadius: 4.0,
                                                  )
                                                ]),
                                            child: Center(
                                              child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'Monteserrat',
                                                      letterSpacing: 1),
                                                  validator: (input) {
                                                    if (input.isEmpty) {
                                                      return '    E-mail não inserido';
                                                    }
                                                  },
                                                  onSaved: (input) =>
                                                      _email = input,
                                                  decoration: InputDecoration(
                                                    hintText: 'E-mail',
                                                    fillColor: Colors.white,
                                                    border: InputBorder.none,
                                                  )),
                                            )),
                                        SizedBox(height: 50),
                                        Container(
                                            width: 350,
                                            height: 80,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0x99D3D3D3),
                                                    blurRadius: 4.0,
                                                  )
                                                ]),
                                            child: Center(
                                              child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'Monteserrat',
                                                      letterSpacing: 1),
                                                  validator: (input) {
                                                    if (input.isEmpty) {
                                                      return '    Password não inserida';
                                                    }
                                                  },
                                                  onSaved: (input) =>
                                                      _password = input,
                                                  obscureText: true,
                                                  decoration: InputDecoration(
                                                    hintText: 'Password',
                                                    fillColor: Colors.white,
                                                    border: InputBorder.none,
                                                  )),
                                            )),
                                        SizedBox(height: 50),
                                        GestureDetector(
                                          onTap: () {
                                            autenticar(context);
                                          },
                                          child: Container(
                                            width: 350,
                                            height: 80,
                                            decoration: BoxDecoration(
                                                color: parseColor('#EBBA4E'),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
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
                                                  fontSize: 20.0,
                                                  letterSpacing: 1,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'Monteserrat'),
                                            )),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )));
              });
        }));
  }

  Future<void> autenticar(BuildContext context) async {
    final formState = _formKey.currentState;
    final popup = BeautifulPopup(
          context: context,
          template: TemplateFail,
        );

    await getListModerador(context);

    if (formState.validate()) {
      formState.save();

      bool flag = false;
      for (Moderador m in listModerador) {
        if (m.id == _email) {
          flag = true;
        }
      }

      if (flag) {
        try {
          final FirebaseAuth auth = FirebaseAuth.instance;
          AuthResult result = await auth.signInWithEmailAndPassword(
              email: _email.trim(), password: _password.trim());
          FirebaseUser user = result.user;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
        } catch (e) {
          popup.show(
                title: new Text("Problema na autenticação",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontFamily: 'Monteserrat')),
                content: Center(
                  child: new Text("\nE-mail ou password não está correto!",
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontFamily: 'Monteserrat')),
                ),
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
         
        }
      } else {
      

        popup.show(
          close:Container(),
          title: new Text("Problema na autenticação",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: 'Monteserrat')),
          content: Center(
            child: new Text("\nEmail ou password não está correto!",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontFamily: 'Monteserrat')),
          ),
          actions: <Widget>[
            // define os botões na base do dialogo
            new FlatButton(
              child: new Text("Fechar",
                  style: TextStyle(
                      fontSize: 15.0,
                      color: parseColor("#56C9B4"),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Monteserrat')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    }
  }

  Future<void> getListModerador(BuildContext context) async {
    listModerador = Provider.of<List<Moderador>>(context, listen: false);
  }
}

///////// VISTA TABLET LANDSCAPE

class LoginTabletLandscape extends StatefulWidget {
  @override
  _LoginTabletLandscapeState createState() => _LoginTabletLandscapeState();
}

class _LoginTabletLandscapeState extends State<LoginTabletLandscape> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Moderador> listModerador;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<List<Moderador>>.value(
              value: DatabaseService().moderador),
        ],
        child: Builder(builder: (BuildContext context) {
          return FutureBuilder<void>(
              future: getListModerador(context),
              builder: (context, AsyncSnapshot<void> snapshot) {
                return Scaffold(
                    key: _scaffoldKey,
                    backgroundColor: Colors.white,
                    body: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 7),
                                              child: Text(
                                                  "Moderadores: Guia de Pequenos Aventureiros",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 60.0,
                                                      letterSpacing: 5,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'Monteserrat')),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30, bottom: 20),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('LOGIN',
                                                style: TextStyle(
                                                    fontSize: 50,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 7,
                                                    fontFamily: 'Monteserrat'))
                                          ]),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      child: Container(
                                          height: 10,
                                          width: 140,
                                          color: Colors.yellow[600]),
                                    ),
                                    Container(
                                        width: 460,
                                        height: 120,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.yellow[600],
                                                blurRadius: 4.0,
                                              )
                                            ]),
                                        child: Center(
                                          child: TextFormField(
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontFamily: 'Monteserrat',
                                                  letterSpacing: 4),
                                              validator: (input) {
                                                if (input.isEmpty) {
                                                  return 'E-mail não inserido';
                                                }
                                              },
                                              onSaved: (input) =>
                                                  _email = input,
                                              decoration: InputDecoration(
                                                hintText: 'E-mail   ',
                                                fillColor: Colors.white,
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 10.0,
                                                    left: 50.0,
                                                    right: 10.0),
                                              )),
                                        )),
                                    SizedBox(height: 50),
                                    Container(
                                        width: 460,
                                        height: 120,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.yellow[600],
                                                blurRadius: 4.0,
                                              )
                                            ]),
                                        child: Center(
                                          child: TextFormField(
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontFamily: 'Monteserrat',
                                                  letterSpacing: 4),
                                              validator: (input) {
                                                if (input.isEmpty) {
                                                  return 'Password não inserida';
                                                }
                                              },
                                              onSaved: (input) =>
                                                  _password = input,
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                hintText: 'Password   ',
                                                fillColor: Colors.white,
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 10.0,
                                                    left: 50.0,
                                                    right: 10.0),
                                              )),
                                        )),
                                    SizedBox(height: 50),
                                    GestureDetector(
                                      onTap: () {
                                        autenticar(context);
                                      },
                                      child: Container(
                                        width: 460,
                                        height: 120,
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius:
                                                BorderRadius.circular(20.0),
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
                                              fontFamily: 'Monteserrat'),
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))));
              });
        }));
  }

  Future<void> autenticar(BuildContext context) async {
    final formState = _formKey.currentState;
    await getListModerador(context);

    if (formState.validate()) {
      formState.save();

      bool flag = false;
      for (Moderador m in listModerador) {
        if (m.id == _email) {
          flag = true;
        }
      }

      if (flag) {
        try {
          final FirebaseAuth auth = FirebaseAuth.instance;
          AuthResult result = await auth.signInWithEmailAndPassword(
              email: _email.trim(), password: _password.trim());
          FirebaseUser user = result.user;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
        } catch (e) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Problema na autenticação"),
                content: new Text("Email ou password não está correto!"),
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
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Problema na autenticação"),
                content: new Text("Email ou password não está correto!"),
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
            });
      }
    }
  }

  Future<void> getListModerador(BuildContext context) async {
    listModerador = Provider.of<List<Moderador>>(context, listen: false);
  }
}
