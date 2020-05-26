import 'package:app_criancas/screens/colecionaveis/minha_caderneta.dart';
import 'package:app_criancas/services/recompensas_api.dart';
import 'package:app_criancas/widgets/color_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth.dart';

class CadernetaTurma extends StatefulWidget {
  @override
  _CadernetaTurmaState createState() => _CadernetaTurmaState();
}

class _CadernetaTurmaState extends State<CadernetaTurma> {
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
    if (_cromos.length != imageCromo.length && (_cromos[0]!='')) {
      return ColorLoader();
    }else if (imageCromo.isEmpty && _cromos.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Cromos da Turma",
          ),
        ),
          body: Text('Completa missões e icentiva os teus colegas de turma a fazer as missões para ganharem Cromos!'));
    } else {
      return Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(
            "Cromos da Turma",
          ),
        ),
        body: Stack(
          children: <Widget>[
            RefreshIndicator(
                onRefresh: _refreshList,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: GridView.count(
                          crossAxisCount: 4,
                          children: List.generate(imageCromo.length, (index) {
                            return Center(
                              child:
                                  Image(image: NetworkImage(imageCromo[index])),
                            );
                          })),
                    ),
                    Row(
                      children: <Widget>[
                        FlatButton(
                            color: Color(0xFFF3C463),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'A minha caderneta',
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return MinhaCaderneta();
                                }),
                              );
                            }),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      );
    }
  }

  getAll() async {
    user = await Auth().getUser();
    List temp = await getUserTurmaCromos(user.email);
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
      var ref = FirebaseStorage.instance.ref().child("cromos/turma/$cromo");
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
