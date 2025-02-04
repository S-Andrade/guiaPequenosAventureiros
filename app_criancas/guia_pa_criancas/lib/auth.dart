
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  //psicologo
  //Future<String> signUp(String email, String password) async {
  //  AuthResult result = await auth.createUserWithEmailAndPassword(
  //      email: email, password: password);
  //  FirebaseUser user = result.user;
  //  print(user.uid);
  //  return user.uid;
  //}

  //usado no 1º login
  Future<AuthResult> signIn(
      BuildContext context, String email, String password) async {
    AuthResult result;
    try {
      result = await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      return result;
    } catch (e) {
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
  }

  Future<FirebaseUser> getUser() async {
    return await auth.currentUser();
  }

  Future<AuthResult> logOut() async{
    auth.currentUser();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String nome = preferences.get('myName');
    preferences.clear();
    preferences.setString('myName', nome);
  }
}
