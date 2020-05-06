import 'package:flutter/material.dart';
import '../home_screen.dart';

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
        StreamProvider<List<Moderador>>.value(value: DatabaseService().moderador),
       
      ],
      child: Builder(
        builder: (BuildContext context) { 
          return FutureBuilder<void>(
            future: getListModerador(context),
            builder: (context, AsyncSnapshot<void> snapshot) {
          return  Scaffold(
      key:_scaffoldKey,
  
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
                          padding: const EdgeInsets.only(top: 120),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Text(
                                      "Moderadores: Guia de Pequenos Aventureiros",
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
                          padding: const EdgeInsets.only(top: 120, bottom: 20),
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
                              height: 10, width: 140, color: Colors.yellow[600]),
                        ),
                        Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.yellow[600],
                                    blurRadius: 4.0,
                                  )
                                ]),
                            child: Center(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'E-mail não inserido';
                                    }
                                  },
                                  onSaved: (input) => _email = input,
                                  decoration: InputDecoration(
                                    hintText: 'E-mail   ',
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                  
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 50.0, right: 10.0),
                                  )),
                            )),
                        SizedBox(height: 50),
                        Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.yellow[600],
                                    blurRadius: 4.0,
                                  )
                                ]),
                            child: Center(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Password não inserida';
                                    }
                                  },
                                  onSaved: (input) => _password = input,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Password   ',
                                    
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                  
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 50.0, right: 10.0),
                                  )),
                            )),
                        SizedBox(height: 50),
                        GestureDetector(
                          onTap: () {
                            print('login');
                            autenticar(context);
                          },
                          child: Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.yellow[600],
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
            ))));
          
          
          
          });
          
          
          
          
          
         
          
    }));}
    

  Future<void> autenticar(BuildContext context) async {
    final formState = _formKey.currentState;
    await getListModerador(context);

    if (formState.validate()) {
      formState.save();
      try {
       
        bool flag = false;
        for(Moderador m in listModerador){
          if(m.id == _email){
            flag = true;
          }
        }

        if(flag){
          final FirebaseAuth auth = FirebaseAuth.instance;
          AuthResult result = await auth.signInWithEmailAndPassword(email: _email.trim(), password: _password.trim());
          FirebaseUser user = result.user;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
        }else{
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
    }
  }

  Future<void> getListModerador(BuildContext context) async{
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
    return  MultiProvider(
      providers: [
        StreamProvider<List<Moderador>>.value(value: DatabaseService().moderador),
       
      ],
      child: Builder(
        builder: (BuildContext context) { 
          return  FutureBuilder<void>(
            future: getListModerador(context),
            builder: (context, AsyncSnapshot<void> snapshot) {
          return  Scaffold(
      key:_scaffoldKey,
  
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Text(
                                      "Moderadores: Guia de Pequenos Aventureiros",
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
                          padding: const EdgeInsets.only(top: 30, bottom: 20),
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
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Container(
                              height: 10, width: 140, color: Colors.yellow[600]),
                        ),
                        Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.yellow[600],
                                    blurRadius: 4.0,
                                  )
                                ]),
                            child: Center(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'E-mail não inserido';
                                    }
                                  },
                                  onSaved: (input) => _email = input,
                                  decoration: InputDecoration(
                                    hintText: 'E-mail   ',
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                  
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 50.0, right: 10.0),
                                  )),
                            )),
                        SizedBox(height: 50),
                        Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.yellow[600],
                                    blurRadius: 4.0,
                                  )
                                ]),
                            child: Center(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Password não inserida';
                                    }
                                  },
                                  onSaved: (input) => _password = input,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Password   ',
                                    
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                  
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 50.0, right: 10.0),
                                  )),
                            )),
                        SizedBox(height: 50),
                        GestureDetector(
                          onTap: () {
                            print('login');
                            autenticar(context);
                          },
                          child: Container(
                            width: 460,
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.yellow[600],
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
            ))));
          
          
          });
          
          
          
          
         
          
      
      
      
      }));}
    
    
    
   Future<void> autenticar(BuildContext context) async {
    final formState = _formKey.currentState;
    await getListModerador(context);

    if (formState.validate()) {
      formState.save();
      try {
        print(listModerador);
        print(_email);
        print(_password);
        bool flag = false;
        for(Moderador m in listModerador){
          if(m.id == _email){
            flag = true;
          }
        }

        if(flag){
          final FirebaseAuth auth = FirebaseAuth.instance;
          AuthResult result = await auth.signInWithEmailAndPassword(email: _email.trim(), password: _password.trim());
          FirebaseUser user = result.user;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
        }else{
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Problema na autenticação"),
                content: new Text("Email não está correto!"),
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

        
      } catch (e) {
        print('falha' + e.message);
      }
    }
  }

  Future<void> getListModerador(BuildContext context) async{
      listModerador = Provider.of<List<Moderador>>(context, listen: false);
    }

}
