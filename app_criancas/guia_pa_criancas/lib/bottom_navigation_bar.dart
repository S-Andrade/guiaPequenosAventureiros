import 'package:app_criancas/auth.dart';
import 'package:app_criancas/perfil.dart';
import 'package:app_criancas/screens/aventura/aventura.dart';
import 'package:app_criancas/screens/aventura/aventura_details.dart';
import 'package:app_criancas/screens/colecionaveis/minha_caderneta.dart';
import 'package:app_criancas/screens/ranking/ranking_screen.dart';
import 'package:app_criancas/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomBar extends StatelessWidget {
  Color _navIconBarColor;
  int index;
  Aventura aventura;
  BottomBar(this.index, this.aventura);
  FirebaseUser user;
  Future<FirebaseUser> getUserA() async {
    user = await Auth().getUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    if (index == 1) {
      _navIconBarColor = Colors.white;
    }
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      selectedItemColor: Colors.black54,
      unselectedItemColor: _navIconBarColor,
      currentIndex: index,
      onTap: (int i) async {
        if (i == 0) {
          user = await getUserA();
          print(user.email);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return HomeScreen(user: user);
            }),
          );
        } else if (i == 1) {
          user = await getUserA();
          print(user.email);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return AventuraDetails(aventura: aventura);
            }),
          );
        } else if (i == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return Perfil(user: user);
            }),
          );
        } else if (i == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return RankingScreen();
            }),
          );
        } else if (i == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return MinhaCaderneta();
            }),
          );
        }
      },
      elevation: 0,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.list),
          title: Text('Capítulos'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          title: Text('Perfil'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.trophy),
          title: Text('Ranking'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.th),
          title: Text('Caderneta'),
        ),
      ],
    );
  }
}
