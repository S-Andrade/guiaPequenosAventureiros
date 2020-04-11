import 'package:flutter/material.dart';

import '../../widgets/app drawer/app_drawer.dart';

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
                                controller: myControllerEmail,
                                textAlign: TextAlign.center,
                                style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
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
                                borderRadius: BorderRadius.circular(20.0),
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
                                style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Palavra-passe não inserido';
                                    }
                                  },
                                  onSaved: (input){
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
                            print("------PASS-----");
                            print(myControllerPass.text);
                            Auth().signIn(context,myControllerEmail.text,myControllerPass.text);
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

}




///////// VISTA TABLET LANDSCAPE



class LoginTabletLandscape extends StatefulWidget {
  @override
  _LoginTabletLandscapeState createState() => _LoginTabletLandscapeState();
}


class _LoginTabletLandscapeState extends State<LoginTabletLandscape> {
  String email = "";
  String pass = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final myControllerPass = TextEditingController();
  final myControllerEmail = TextEditingController();
  
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
                                controller: myControllerEmail,
                                textAlign: TextAlign.center,
                                style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
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
                                borderRadius: BorderRadius.circular(20.0),
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
                                style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Palavra-passe não inserido';
                                    }
                                  },
                                  onSaved: (input){
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
                             Auth().signIn(context,myControllerEmail.text,myControllerPass.text);
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

}