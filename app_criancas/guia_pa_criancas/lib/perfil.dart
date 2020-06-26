import 'package:app_criancas/auth.dart';
import 'package:app_criancas/screens/companheiro/companheiro_message.dart';
import 'package:app_criancas/screens/colecionaveis/caderneta_turma.dart';
import 'package:app_criancas/screens/colecionaveis/minha_caderneta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class Perfil extends StatefulWidget {
  FirebaseUser user;
  Perfil({this.user});

  @override
  _Perfil createState() => _Perfil(user: user);
}

class _Perfil extends State<Perfil> {
  FirebaseUser user;
  _Perfil({this.user});

  String nomeUser;

  int pontuacao_aluno;
  int pontuacao_turma;
  String id_turma;
  String aa;
  bool checkNome = false;

  @override
  void initState() {
    getInfo();
    _getNomeUser();
    super.initState();
  }

  _getNomeUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    nomeUser = sp.getString('myName');
    checkNome = true;
  }

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      statusBarColor: Colors.transparent,
//      systemNavigationBarColor:Colors.white,
//    ));

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/blue.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          )),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          appBar: AppBar(
            title: Text(
              "O teu perfil",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            children: [
              Positioned(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: screenWidth > 800 ? 0.25 : 0.35,
                        child: Container(
//                        height: 130,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                                'assets/images/clouds_bottom_navigation_white.png'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          )),
                        ),
                      ))),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: DelayedDisplay(
                    delay: Duration(milliseconds: 400),
                    fadingDuration: const Duration(milliseconds: 800),
//                          slidingBeginOffset: const Offset(-0.5, 0.0),
                    child: FractionallySizedBox(
                      heightFactor: screenHeight > 1000 ? 0.55 : 0.6,
                      widthFactor: screenWidth > 800 ? 0.8 : 0.9,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  (nomeUser != null && !checkNome)
                                      ? "Olá, $aa!"
                                      : "Olá, $nomeUser!",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.pangolin(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: screenWidth > 800
                                          ? 40
                                          : screenHeight < 700 ? 26 : 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: " A tua pontuação é de ",
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: screenWidth > 800
                                              ? 34
                                              : screenHeight < 700 ? 20 : 24,
                                          color: Colors.black,
                                        ),
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: pontuacao_aluno.toString(),
                                          style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: screenWidth > 800
                                                  ? 38
                                                  : screenHeight < 700
                                                      ? 20
                                                      : 24,
                                              color: Color(0xFFF3C463),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: " A pontuação da tua turma ",
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: screenWidth > 800
                                              ? 34
                                              : screenHeight < 700 ? 20 : 22,
                                          color: Colors.black,
                                        ),
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: pontuacao_turma.toString(),
                                          style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: screenWidth > 800
                                                  ? 38
                                                  : screenHeight < 700
                                                      ? 20
                                                      : 22,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          screenWidth > 800 ? 20 : 8.0),
                                      child: FlatButton(
                                        color: Color(0xFFF3C463),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    10.0)),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MinhaCaderneta()),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: screenHeight < 700
                                                  ? 10
                                                  : 20.0),
                                          child: Text(
                                            'Minha Caderneta',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: screenWidth > 800
                                                    ? 24
                                                    : screenHeight < 700
                                                        ? 16
                                                        : 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          screenWidth > 800 ? 20 : 8.0),
                                      child: FlatButton(
                                        color: Color(0xFF01BBB6),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    10.0)),
                                        onPressed: () {
                                          //ir para a caderneta da turma
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CadernetaTurma()),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: screenHeight < 700
                                                  ? 10
                                                  : 20.0),
                                          child: Text(
                                            'Caderneta de turma',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: screenWidth > 800
                                                    ? 24
                                                    : screenHeight < 700
                                                        ? 16
                                                        : 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight > 700 ? 10 : 0 ),
                      child: OutlineButton.icon(
                        icon:
                            Icon(Icons.exit_to_app, color: Colors.grey, size: 16),

                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                          5.0,
                        )),
//                  color: Color(0xFFFF2929),
                        onPressed: () async {
                          await Auth().logOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return MyApp();
                            }),
                          );
                        },
                        label: Text(
                          'Terminar sessão',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: screenHeight < 700 ? 12 : 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: DelayedDisplay(
//                          delay: Duration(seconds: 1),
                      fadingDuration: const Duration(milliseconds: 800),
//                          slidingBeginOffset: const Offset(-0.5, 0.0),
                      child: FractionallySizedBox(
                          widthFactor: 0.6,
                          heightFactor: 0.4,
                          child: CompanheiroMessage()),
                    )),
              ),
            ],
          )),
    );
  }

  getInfo() async {
    user = await Auth().getUser();
    await getAluno();
    await getTurma();
    print(user.uid);
    print(user.email);
  }

  getAluno() async {
    DocumentReference documentReference =
        Firestore.instance.collection("aluno").document(user.email);
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        setState(() {
          pontuacao_aluno = datasnapshot.data['pontuacao'];
          id_turma = datasnapshot.data['turma'];
          String sexo = datasnapshot.data['generoAluno'];
          if (sexo == "Masculino") {
            aa = "Amigo";
          }
          if (sexo == "Feminino") {
            aa = "Amiga";
          }
        });
      } else {
        print("No such Aluno");
      }
    });
  }

  getTurma() async {
    DocumentReference documentReference =
        Firestore.instance.collection("turma").document(id_turma);
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        setState(() {
          pontuacao_turma = datasnapshot.data['pontuacao'];
        });
      } else {
        print("No such Turma");
      }
    });
  }
}
