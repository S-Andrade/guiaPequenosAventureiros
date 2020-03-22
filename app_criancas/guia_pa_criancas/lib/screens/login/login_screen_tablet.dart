import 'package:flutter/material.dart';
import '../home_screen.dart';
import 'package:guia_pa/widgets/app drawer/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';



///////// VISTA TABLET PORTRAIT 



class LoginTabletPortrait extends StatefulWidget {
  @override
  _LoginTabletPortraitState createState() => _LoginTabletPortraitState();
}

class _LoginTabletPortraitState extends State<LoginTabletPortrait> {
  String _codigo;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
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
                          padding: const EdgeInsets.only(top: 120),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Text("Crianças: Guia de Pequenos Aventureiros",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 60.0,
                                          letterSpacing: 5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Amatic SC')),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 180, bottom: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('LOGIN',
                                    style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 7,
                                        fontFamily: 'Amatic SC'))
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: Container(
                              height: 10, width: 140, color: Colors.black),
                        ),
                        Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                  )
                                ]),
                            child: Center(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Código de acesso não inserido';
                                    }
                                  },
                                  onSaved: (input) => _codigo = input,
                                  decoration: InputDecoration(
                                    hintText: 'Código de acesso   ',
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 50.0, right: 10.0),
                                  )),
                            )),
                           
                        SizedBox(height: 50),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HomeScreen()));
                          },
                          child: Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
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



//////// AUTENTICAÇÃO FIREBASE PERSONALIZADA


  Future<void> autenticar() async {

     final formState = _formKey.currentState;

    if (formState.validate()) {
      formState.save();

      try {

        final FirebaseAuth auth = FirebaseAuth.instance;

        Future<AuthResult> result = auth.signInWithCustomToken(token: _codigo);
      
        Future<FirebaseUser> user = auth.currentUser();

        print('User:'+user.toString());

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      
        print('Novo utilizador criado!');

  
        
        
      } catch (e) {
        print('falha' + e.message);
      }
    }
  }


}




///////// VISTA TABLET LANDSCAPE



class LoginTabletLandscape extends StatefulWidget {
  @override
  _LoginTabletLandscapeState createState() => _LoginTabletLandscapeState();
}


class _LoginTabletLandscapeState extends State<LoginTabletLandscape> {
  String _codigo;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
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
                                  child: Text("Crianças: Guia de Pequenos Aventureiros",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 60.0,
                                          letterSpacing: 5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Amatic SC')),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50, bottom: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('LOGIN',
                                    style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 7,
                                        fontFamily: 'Amatic SC'))
                              ]),
                        ),
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
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                  )
                                ]),
                            child: Center(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Código de acesso não inserido';
                                    }
                                  },
                                  onSaved: (input) => _codigo = input,
                                  decoration: InputDecoration(
                                    hintText: 'Código de acesso   ',
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 50.0, right: 10.0),
                                  )),
                            )),
                        SizedBox(height: 50),
                        GestureDetector(
                          onTap: () {
                            autenticar();
                          },
                          child: Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
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








//////// AUTENTICAÇÃO FIREBASE PERSONALIZADA


  Future<void> autenticar() async {

     final formState = _formKey.currentState;

    if (formState.validate()) {
      formState.save();

      try {

        final FirebaseAuth auth = FirebaseAuth.instance;

        Future<AuthResult> result = auth.signInWithCustomToken(token: _codigo);
      
        Future<FirebaseUser> user = auth.currentUser();

        print('User:'+user.toString());

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      
        print('Novo utilizador criado!');

  
        
        
      } catch (e) {
        print('falha' + e.message);
      }
    }
  
  }

}