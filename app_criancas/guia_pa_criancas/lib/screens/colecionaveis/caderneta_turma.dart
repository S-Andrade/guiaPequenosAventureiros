import 'package:app_criancas/screens/colecionaveis/minha_caderneta.dart';
import 'package:app_criancas/screens/companheiro/companheiro_appwide.dart';
import 'package:app_criancas/services/recompensas_api.dart';
import 'package:app_criancas/widgets/color_loader.dart';
import 'package:app_criancas/widgets/color_loader_5.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth.dart';

class CadernetaTurma extends StatefulWidget {
  @override
  _CadernetaTurmaState createState() => _CadernetaTurmaState();
}

class _CadernetaTurmaState extends State<CadernetaTurma> {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

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

  final ScrollController _controllerScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    if (_cromos.length != imageCromo.length && (_cromos[0] != '')) {
      return ColorLoader5();
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
            body: Text(
                'Completa missões e icentiva os teus colegas de turma a fazer as missões para ganharem Cromos!')),
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
              "Caderneta da Turma",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth > 800 ? 30 : 24,
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
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: 0.8,
                    widthFactor: screenWidth > 800 ? 0.8 : 0.9,
                    child: RefreshIndicator(
                        onRefresh: _refreshList,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Scrollbar(
                                controller: _controllerScroll,
                                child: GridView.count(
                                    crossAxisCount: screenWidth > 800 ? 3 : 2,
                                    children:
                                        List.generate(imageCromo.length, (index) {
                                      return Padding(
                                        padding: EdgeInsets.all(screenWidth > 800 ? 16 : screenHeight < 700 ? 6 : 10),
                                        child: DelayedDisplay(
                                          delay: Duration(milliseconds: 200*index),
                                          fadingDuration:
                                          const Duration(milliseconds: 800),
                                          slidingBeginOffset:
                                          const Offset(-0.0, 0.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image:
                                                  NetworkImage(imageCromo[index]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),),
                                      );
                                    })),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical:screenHeight > 1000 ? 40 : screenHeight<700?16.0:20),
                              child: FractionallySizedBox(
                                widthFactor: screenWidth > 800 ? 0.5 : 0.7,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: FlatButton(
                                      padding: EdgeInsets.all(screenWidth > 800 ? 22 : 16.0),
                                      color: Color(0xFFF3C463),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Text(
                                        'A minha caderneta',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenWidth > 800 ? 24 : screenHeight < 700 ? 16 : 18,
                                              color: Colors.white),
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
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    widthFactor: screenHeight < 700 ? 0.8 : screenWidth > 800 ? 0.77 : 0.9,
                    heightFactor: screenHeight < 700 ? 0.14 : screenHeight < 1000 ? 0.14 : 0.20,
                    child: Stack(
                      children: [
                        FlareActor(
                          "assets/animation/dialog.flr",
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.center,
//                        controller: _controller,
                          artboard: 'Artboard',
                          animation: 'open_dialog',
                        ),
                        Center(
                          child: DelayedDisplay(
                            delay: Duration(seconds: 1),
                            fadingDuration: const Duration(milliseconds: 800),
                            slidingBeginOffset: const Offset(0, 0.0),
                            child: Padding(
                              padding: EdgeInsets.only(left: screenHeight > 1000 ? 40 : screenHeight < 700 ? 16 : 20.0, right: screenHeight > 1000 ? 130 : screenHeight < 700 ? 60 : 100),
                              child: Text(
                                "Bom trabalho de equipa!",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.pangolin(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: screenHeight < 700 ? 16 : screenHeight < 1000 ? 20 : 32,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
