import 'package:app_criancas/auth.dart';
import 'package:app_criancas/screens/companheiro/companheiro_message.dart';
import 'package:app_criancas/screens/colecionaveis/caderneta_turma.dart';
import 'package:app_criancas/screens/colecionaveis/minha_caderneta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  int pontuacao_aluno;
  int pontuacao_turma;
  String id_turma;
  String aa;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              Positioned.fill(
                child: FractionallySizedBox(
                  heightFactor: 0.6,
                  widthFactor: 0.8,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Olá, $aa!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.pangolin(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                " A tua pontuação é de " +
                                    pontuacao_aluno.toString(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                " A pontuação da tua turma " +
                                    pontuacao_turma.toString(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                    color: Color(0xFFF3C463),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0)),
                                    onPressed: () {
                                      //ir para a caderneta do aluno
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MinhaCaderneta()),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0),
                                      child: Text(
                                        'Minha Caderneta',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                    color: Color(0xFF01BBB6),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0)),
                                    onPressed: () {
                                      //ir para a caderneta da turma
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>CadernetaTurma()),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0),
                                      child: Text(
                                        'Caderneta de turma',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
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
              Positioned(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: 0.25,
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
              Positioned(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                      10.0,
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Logout',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Color(0xFFFF2929),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                        widthFactor: 0.6,
//                      heightFactor:0.4 ,
                        child: CompanheiroMessage())),
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
