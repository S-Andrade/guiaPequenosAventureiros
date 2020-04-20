import 'package:app_criancas/screens/login/user_data_screen_tablet.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  //psicologo
  Future<String> signUp(String email, String password) async {
    AuthResult result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    print(user.uid);
    return user.uid;
  }

  //usado no 1º login
  Future<void> signIn(
      BuildContext context, String email, String password) async {
    FirebaseUser user;
    AuthResult result;
    try {
      result = await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      user = result.user;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => UserData(user: user)));
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
}
