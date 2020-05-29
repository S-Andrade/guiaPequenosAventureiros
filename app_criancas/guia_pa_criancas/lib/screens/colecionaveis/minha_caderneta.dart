import 'package:app_criancas/screens/colecionaveis/caderneta_turma.dart';
import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:app_criancas/services/recompensas_api.dart';
import 'package:app_criancas/widgets/color_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth.dart';

class MinhaCaderneta extends StatefulWidget {
  @override
  _MinhaCadernetaState createState() => _MinhaCadernetaState();
}

class _MinhaCadernetaState extends State<MinhaCaderneta> {
  FirebaseUser user;
  String _userID;
  String _urlImage;
  List _cromos = [];
  List<String> imageCromo = [];

  @override
  initState() {
    getAll();
    super.initState();
  }

  Future<void> _refreshList() async {
    getAll();
    print('refresh');
  }

  @override
  Widget build(BuildContext context) {
    if (_cromos.length != imageCromo.length && (_cromos[0] != '')) {
      return ColorLoader();
    } else if (imageCromo.isEmpty && _cromos.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blue3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: Color(0xFF30246A), //change your color here
              ),
              title: Text(
                "Caderneta da Turma",
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Color(0xFF30246A)),
                ),
              ),
            ),
            body: Text('Completa missões para ganhar Cromos!')),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blue3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Color(0xFF30246A), //change your color here
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              "Os meus Cromos",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Color(0xFF30246A)),
              ),
            ),
          ),
          body: Stack(
            children: <Widget>[
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
                  ),
                ),
              ),
              Positioned.fill(
                child: FractionallySizedBox(
                  heightFactor: 0.7,
                  widthFactor: 0.9,
                  child: RefreshIndicator(
                      onRefresh: _refreshList,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: GridView.count(
                                crossAxisCount: 2,
                                children: List.generate(imageCromo.length, (index) {
                                  return Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image:
                                          NetworkImage(imageCromo[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                })),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.7,
                            child: SizedBox(
                              width: double.infinity,
                              child: FlatButton(
                                  color: Color(0xFFF3C463),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Caderneta da turma',
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return CadernetaTurma();
                                      }),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: FractionallySizedBox(
                    heightFactor: 0.15,
                    widthFactor: 0.8,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black45.withOpacity(0.8),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(5))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Text(
                              "Olha só o que já juntamos!",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.pangolin(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
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
                    alignment: Alignment.topRight, child: CompanheiroAppwide()),
              ),
            ],
          ),
        ),
      );
    }
  }

  getAll() async {
    user = await Auth().getUser();
    List temp = await getUserCromos(user.email);
    setState(() {
      _cromos = temp;
      _userID = user.email;
    });
    if (_cromos.isEmpty) {
      imageCromo = [];
      _cromos.add('');
    } else {
      await getImages();
    }
  }

  getImages() {
    List<String> temp = [];
    _cromos.forEach((element) async {
      String cromo = element;
      var ref = FirebaseStorage.instance.ref().child("cromos/aluno/$cromo");
      await ref.getDownloadURL().then((value) {
        _urlImage = value;
        temp.add(_urlImage);
        setState(() {
          imageCromo = temp;
        });
      });
    });
  }
}
