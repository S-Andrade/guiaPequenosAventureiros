import 'package:app_criancas/flare/idle_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flare_flutter/flare_actor.dart';
import '../../synthesizeText.dart';

// MOVER AO MERGE
import 'package:audioplayers/audio_cache.dart';


class WelcomePage extends StatefulWidget {
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  // Sound Effects
  static AudioCache effectsPlayer = AudioCache(prefix: 'audio/');
  // Text to Speech Synth
  Synth reader = Synth(); //

  IdleControls _flareController;

  @override
  initState() {
    _flareController = IdleControls();
//    effectsPlayer.loadAll(['button_click_drop.mp3','cartoon_bubble_pop_007','cartoon_bubble_001']);
    _controller = PageController(initialPage: 0);
    super.initState();
  }

// SHOW PART FROM THE NEXT -> PageController(viewportFraction: 0.8)
  PageController _controller;

  void _changeColour(int selectColour) {
    setState(() {
      effectsPlayer.play('cartoon_bubble_001.mp3');
      _flareController.changeShapeColour(selectColour);
      // advance the controller
      _flareController.isActive.value = true;
    });
  }

  void _selectEye(String numberEyes) {
    setState(() {
      effectsPlayer.play('cartoon_bubble_pop_007.mp3');
      _flareController.changeEye(numberEyes);
      _flareController.isActive.value = true;
    });
  }

  void _selectMouth(String selectedMouth) {
    setState(() {
      effectsPlayer.play('button_click_drop.mp3');

      _flareController.changeMouth(selectedMouth);
      _flareController.isActive.value = true;
    });
  }

  void _selectBodyPart(String selectedBodyPart) {
    setState(() {
      effectsPlayer.play('button_click_drop.mp3');

      _flareController.changeBodyPart(selectedBodyPart);
      _flareController.isActive.value = true;
    });
  }

  void _selectHeadTop(String selectedHeadTop) {
    setState(() {
      effectsPlayer.play('button_click_drop.mp3');

      _flareController.changeHeadTop(selectedHeadTop);
      _flareController.isActive.value = true;
    });
  }

  String _selectShape = 'square';

  void _selectArtboard(String selectShape) {
    setState(() {
      effectsPlayer.play('button_click_drop.mp3');
      _selectShape = selectShape;
      _flareController.isActive.value = true;
      _flareController.changeShape();
    });
  }

  // SVG ARROWS
  final String assetArrowTwist = 'assets/svg/arrow_twist.svg';
  final String assetArrow5 = 'assets/svg/arrow-5.svg';
  final String assetArrow5Back = 'assets/svg/arrow-5-back.svg';
  // SVG SHAPES
  final String assetPentagon = 'assets/svg/pentagon-rounded.svg';
  final String assetSquare = 'assets/svg/square-rounded.svg';
  final String assetHalfCircle = 'assets/svg/half-circle.svg';
  final String assetTriangle = 'assets/svg/triangle.svg';
  final String assetDiamond = 'assets/svg/diamond-rounded.svg';
  final String assetCircle = 'assets/svg/circle.svg';

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(title: Text('title')),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          //Center(

          child: Stack(
            children: <Widget>[
              Container(
//                height: 700.0,
                child: PageView(
                  controller: _controller,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = _controller.page.round();
                      _flareController.isActive.value = true;
                    });
                  },
                  pageSnapping: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
//                    Container(
//                      height: 300,
//                      decoration: BoxDecoration(
//                          image: DecorationImage(
//                              image: AssetImage('images/background.png'),
//                              fit: BoxFit.cover)),
//                      child: FlareActor(
//                        "assets/logo.flr",
//                        animation: "logo",
//                        fit: BoxFit.none,
//                        alignment: Alignment.topCenter,
////                      controller: _flareController,
//                        artboard: "logo",
//                      ),
//                    ),
                    Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: [
                              Color(0xFF62D7A2),
                              Color(0xFF00C9C9),
                            ],
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 10, top: 0),
                                child: InkWell(
                                  onTap: () => reader.synthesizeText('Olá!'),
                                  child: Flexible(
                                    child: Text(
                                      'Olá!',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            height: 1,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 30,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 0),
                                child: InkWell(
                                  onTap: () => reader.synthesizeText(
                                      'Vou ser o teu companheiro de Aventuras'),
                                  child: Flexible(
                                    child: Text(
                                      'Vou ser o teu \ncompanheiro de Aventuras',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            height: 1,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 24,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 0, top: 10),
                                child: InkWell(
                                  onTap: () => reader.synthesizeText(
                                      'mas ainda não estou pronto, dás-me uma ajuda?'),
                                  child: Flexible(
                                    child: Center(
                                      child: Text(
                                        '...mas ainda não estou pronto, dás-me uma ajuda?\n',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              height: 1,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 22,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
//                                  color: Colors.blueGrey,
//                                border: Border.all(width: 1),
                                    ),
                                height: 270,
                                child: FlareActor(
                                  "assets/shapes3.flr",
                                  animation: "stanby",
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  controller: _flareController,
                                  artboard: _selectShape,
                                ),
                              ),
                              InkWell(
                                onTap: () => reader.synthesizeText(
                                    'para escolher toca na forma'),
                                child: Flexible(
                                  child: Text(
                                    'É preciso estar em forma!\nToca na forma que mais gostas',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.pangolin(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 22,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () =>
                                            _selectArtboard('pentagon'),
                                        child: SvgPicture.asset(
                                          assetPentagon,
                                          color: Color(0x99FFFFFF),
                                          width: 45,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () => _selectArtboard('square'),
                                        child: SvgPicture.asset(
                                          assetSquare,
                                          color: Color(0x99FFFFFF),
                                          width: 37,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () => _selectArtboard('circle'),
                                        child: SvgPicture.asset(
                                          assetCircle,
                                          color: Color(0x99FFFFFF),
                                          width: 47,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () =>
                                            _selectArtboard('triangle'),
                                        child: SvgPicture.asset(
                                          assetTriangle,
                                          color: Color(0x99FFFFFF),
                                          width: 40,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () => _selectArtboard('half'),
                                        child: SvgPicture.asset(
                                          assetHalfCircle,
                                          color: Color(0x99FFFFFF),
                                          width: 45,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () => _selectArtboard('diamond'),
                                        child: SvgPicture.asset(
                                          assetDiamond,
                                          matchTextDirection: false,
                                          color: Color(0x99FFFFFF),
                                          width: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ])),
                    Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: [
                              Color(0xFF00C9C9),
                              Color(0xFF0097E2),
                            ],
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 10),
                                child: InkWell(
                                  onTap: () => reader.synthesizeText(
                                      'Humm, acho preciso de um pouco de cor!'),
                                  child: Flexible(
                                    child: Text(
                                      'Humm, acho preciso de um pouco de cor!',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 28,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
//                                border: Border.all(width: 1),
                                    ),
                                height: 300,
                                child: FlareActor(
                                  "assets/shapes3.flr",
                                  animation: "standby",
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  controller: _flareController,
                                  artboard: _selectShape,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
//                              border: Border.all(width: 1),
                                      ),
//                          height: 500,
                                  child: Center(
                                    child: InkWell(
                                      onTap: () => reader.synthesizeText(
                                          'para escolher toca na forma'),
                                      child: Flexible(
                                        child: Text(
                                          'Escolhe uma cor para pintar',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.pangolin(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 24,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ButtonBar(
                                        alignment:
                                            MainAxisAlignment.spaceEvenly,
                                        //mainAxisSize: MainAxisSize.max,
                                        //layoutBehavior: ButtonBarLayoutBehavior.padded,
                                        buttonHeight: 40,
                                        children: <Widget>[
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                FlatButton(
                                                  //child: Text('Ok'),
                                                  color: Color(0xffFE595A),
                                                  onPressed: () =>
                                                      _changeColour(0),
                                                  padding: EdgeInsets.all(16),
                                                  shape: CircleBorder(),
                                                ),
                                                FlatButton(
                                                  //child: Text(''),
                                                  color: Color(0xffFF842A),
                                                  onPressed: () =>
                                                      _changeColour(1),
                                                  padding: EdgeInsets.all(16),
                                                  shape: CircleBorder(),
                                                ),
                                                FlatButton(
                                                  //child: Text(''),
                                                  color: Color(0xffFEE32B),
                                                  onPressed: () =>
                                                      _changeColour(2),
                                                  padding: EdgeInsets.all(16),
                                                  shape: CircleBorder(),
                                                ),
                                                FlatButton(
                                                  //child: Text('Ok'),
                                                  color: Color(0xff48D597),
                                                  onPressed: () =>
                                                      _changeColour(3),
                                                  padding: EdgeInsets.all(16),
                                                  shape: CircleBorder(),
                                                ),
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                FlatButton(
                                                  //child: Text(''),
                                                  color: Color(0xff00B5E2),
                                                  onPressed: () =>
                                                      _changeColour(4),
                                                  padding: EdgeInsets.all(16),
                                                  shape: CircleBorder(),
                                                ),
                                                FlatButton(
                                                  //child: Text(''),
                                                  color: Color(0xff825DC7),
                                                  onPressed: () =>
                                                      _changeColour(5),
                                                  padding: EdgeInsets.all(16),
                                                  shape: CircleBorder(),
                                                ),
                                                FlatButton(
                                                  //child: Text(''),
                                                  color: Color(0xffFB637E),
                                                  onPressed: () =>
                                                      _changeColour(6),
                                                  padding: EdgeInsets.all(16),
                                                  shape: CircleBorder(),
                                                ),
                                              ]),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ])),
                    Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: [
                              Color(0xFF829BDB),
                              Color(0xFF8081DD),
                            ],
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 10),
                                child: InkWell(
                                  onTap: () => reader
                                      .synthesizeText('Quantos olhos preciso?'),
                                  child: Flexible(
                                    child: Text(
                                      'Temos de estar atentos nas Aventuras!',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 28,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 30),
                                child: InkWell(
                                  onTap: () => reader.synthesizeText(
                                      'Muitos pares de olhos ou um muito grande?'),
                                  child: Flexible(
                                    child: Text(
                                      'Muitos pares de olhos ou um muito grande?',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 22,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
//                                border: Border.all(width: 1),
                                    ),
                                height: 300,
                                child: FlareActor(
                                  "assets/shapes3.flr",
                                  animation: "standby",
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  controller: _flareController,
                                  artboard: _selectShape,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Escolhe quantos olhos',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.pangolin(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 22,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ButtonBar(
                                      alignment: MainAxisAlignment.spaceEvenly,
                                      //mainAxisSize: MainAxisSize.max,
                                      //layoutBehavior: ButtonBarLayoutBehavior.padded,
                                      buttonHeight: 40,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            OutlineButton(
                                              borderSide: BorderSide(
                                                  width: 2,
                                                  color: Colors.white),
                                              child: Text(
                                                '1',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              color: Color(0xffFE595A),
                                              onPressed: () => _selectEye(''),
                                              padding: EdgeInsets.all(12),
                                              shape: CircleBorder(),
                                            ),
                                            OutlineButton(
                                              borderSide: BorderSide(
                                                  width: 2,
                                                  color: Colors.white),
                                              child: Text(
                                                '2',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              color: Color(0xffFE595A),
                                              onPressed: () => _selectEye(''),
                                              padding: EdgeInsets.all(12),
                                              shape: CircleBorder(),
                                            ),
                                            OutlineButton(
                                              borderSide: BorderSide(
                                                  width: 2,
                                                  color: Colors.white),
                                              child: Text(
                                                '3',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              color: Color(0xffFE595A),
                                              onPressed: () => _selectEye(''),
                                              padding: EdgeInsets.all(12),
                                              shape: CircleBorder(),
                                            ),
                                            OutlineButton(
                                              borderSide: BorderSide(
                                                  width: 2,
                                                  color: Colors.white),
                                              child: Text(
                                                '+',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              color: Color(0xffFE595A),
                                              onPressed: () => _selectEye(''),
                                              padding: EdgeInsets.all(12),
                                              shape: CircleBorder(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ])),
                    Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: [
                              Color(0xFFFE727F),
                              Color(0xFFF765A3),
                            ],
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 10),
                                child: Flexible(
                                  child: Text(
                                    'Um sorriso é sempre muito importante!',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 28,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
//                              Padding(
//                                padding: EdgeInsets.only(
//                                    left: 30, right: 30, bottom: 30),
//                                child: Flexible(
//                                  child: Center(
//                                    child: Text(
//                                      '... ou quem sabe umas asas?',
//                                      textAlign: TextAlign.center,
//                                      style: GoogleFonts.quicksand(
//                                        textStyle: TextStyle(
//                                            fontWeight: FontWeight.w700,
//                                            fontSize: 22,
//                                            color: Colors.black),
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ),
                              Container(
                                decoration: BoxDecoration(
//                                border: Border.all(width: 1),
                                    ),
                                height: 300,
                                child: FlareActor(
                                  "assets/shapes3.flr",
                                  animation: "standby",
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  controller: _flareController,
                                  artboard: _selectShape,
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Escolhe o teu favorito',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.pangolin(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 22,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: OutlineButton(
                                          child: Text(
                                            'Sorriso 1',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.pangolin(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          color: Colors.white,
                                          onPressed: () => _selectMouth(''),
                                          padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: OutlineButton(
                                          child: Text(
                                            'Sorriso 2',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.pangolin(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),

                                          color: Colors.white,
                                          onPressed: () => _selectMouth(''),
                                          padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

//                              Padding(
//                                padding: EdgeInsets.all(25.0),
//                                child: Row(
//                                  children: <Widget>[
//                                    FlatButton(
//                                      child: Text('Boca 1'),
//                                      color: Colors.white,
//                                      onPressed: () =>
//                                          _selectMouth(1),
//                                      padding: EdgeInsets.all(16),
////                                              shape: CircleBorder(),
//                                    ),
//                                    FlatButton(
//                                      child: Text('Boca 2'),
//                                      color: Colors.white,
//                                      onPressed: () =>
//                                          _selectMouth(2),
//                                      padding: EdgeInsets.all(16),
////                                              shape: CircleBorder(),
//                                    ),
//                                  ],
//                                ),
//                              ),
                            ])),
                    Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: [
                              Color(0xFFffDAAD),
                              Color(0xFFFFA29D),
                            ],
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 10),
                                child: Flexible(
                                  child: Text(
                                    'Acho que me falta alguma coisa...',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 28,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 30),
                                child: Flexible(
                                  child: Center(
                                    child: Text(
                                      'Já sei, que tal algo para a cabeça?',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 22,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
//                                border: Border.all(width: 1),
                                    ),
                                height: 300,
                                child: FlareActor(
                                  "assets/shapes3.flr",
                                  animation: "standby",
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  controller: _flareController,
                                  artboard: _selectShape,
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'O que achas dá mais jeito?',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.pangolin(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 22,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: OutlineButton(
                                          child: Text(
                                            'Antenas',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.pangolin(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          color: Colors.white,
                                          onPressed: () => _selectHeadTop(''),
                                          padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: OutlineButton(
                                          child: Text(
                                            'Tufo de cabelo',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.pangolin(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),

                                          color: Colors.white,
                                          onPressed: () => _selectHeadTop(''),
                                          padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ])),
                    Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: [
                              Color(0xFFFCF477),
                              Color(0xFFF6A51E),
                            ],
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 10),
                                child: Flexible(
                                  child: Text(
                                    'Vou precisar de uma mãozinha...',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 28,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 30),
                                child: Flexible(
                                  child: Center(
                                    child: Text(
                                      '... ou quem sabe umas asas?',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 22,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
//                                border: Border.all(width: 1),
                                    ),
                                height: 300,
                                child: FlareActor(
                                  "assets/shapes3.flr",
                                  animation: "standby",
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  controller: _flareController,
                                  artboard: _selectShape,
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'O que achas dá mais jeito?',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.pangolin(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 22,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: OutlineButton(
                                          child: Text(
                                            'Asas',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.pangolin(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          color: Colors.white,
                                          onPressed: () => _selectBodyPart(''),
                                          padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: OutlineButton(
                                          child: Text(
                                            'Tentáculos',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.pangolin(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),

                                          color: Colors.white,
                                          onPressed: () => _selectHeadTop(''),
                                          padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: OutlineButton(
                                          child: Text(
                                            'Braços',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.pangolin(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),

                                          color: Colors.white,
                                          onPressed: () => _selectHeadTop(''),
                                          padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ])),
                    Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: [
                              Color(0xFFF6A51E),
                              Color(0xFFf65f1e),
                            ],
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 10),
                                child: Flexible(
                                  child: Text(
                                    'name',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 28,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 30),
                                child: Flexible(
                                  child: Center(
                                    child: Text(
                                      '... ou quem sabe umas asas?',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 22,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
//                                border: Border.all(width: 1),
                                    ),
                                height: 300,
                                child: FlareActor(
                                  "assets/shapes3.flr",
                                  animation: "standby",
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  controller: _flareController,
                                  artboard: _selectShape,
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'O que achas dá mais jeito?',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.pangolin(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 22,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: TextField(
                                      decoration:
                                          InputDecoration(hintText: 'Name'),
                                    ),
                                  ),
                                ],
                              ),
                            ])),
                    Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: [
                              Color(0xFFff6e4a),
                              Color(0xFFf03333),
                            ],
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 10),
                                child: Flexible(
                                  child: Text(
                                    'Name',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 28,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 30),
                                child: Flexible(
                                  child: Center(
                                    child: Text(
                                      '... ou quem sabe umas asas?',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 22,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
//                                border: Border.all(width: 1),
                                    ),
                                height: 300,
                                child: FlareActor(
                                  "assets/shapes3.flr",
                                  animation: "standby",
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  controller: _flareController,
                                  artboard: _selectShape,
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'O que achas dá mais jeito?',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.pangolin(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 22,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: TextField(
                                      decoration:
                                          InputDecoration(hintText: 'Name'),
                                    ),
                                  ),
                                ],
                              ),
                            ])),
                  ],
                ),
              ),
              Positioned.fill(
                bottom: 25,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child: _currentPage == 5
                        ? Container()
                        : SmoothPageIndicator(
                            controller: _controller,
                            count: 7,
                            effect: JumpingDotEffect(
                                spacing: 10.0,
                                radius: 13.0,
                                dotWidth: 13.0,
                                dotHeight: 13.0,
                                dotColor: Colors.white,
                                paintStyle: PaintingStyle.fill,
                                strokeWidth: 0,
                                activeDotColor: Colors.deepOrange),
                          ),
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 0,
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: _currentPage == 5
                        ? Container(
                            child: FlatButton(
                              color: Colors.red,
                              textColor: Colors.white,
//                              disabledColor: Colors.white,
                              disabledTextColor: Colors.black,
                              padding: EdgeInsets.all(20.0),
                              splashColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(
                                'Estamos prontos!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.pangolin(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : Container()),
              ),
              Positioned(
                bottom: 25,
                left: 20,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: _currentPage == 0
                      ? Container()
                      :
//                           IconButton(
//                              icon: Icon(Icons.arrow_back_ios),
//                              alignment: Alignment.center,
//                              iconSize: 30,
//                              color: Colors.white,
//                              splashColor: Colors.orangeAccent,
//                              onPressed: () => _controller.previousPage(
//                                  duration: const Duration(milliseconds: 600),
//                                  curve: Curves.easeInExpo),
//                            ),
                      GestureDetector(
                          onTap: () => _controller.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut),
                          child: SvgPicture.asset(
                            assetArrow5Back,
                            matchTextDirection: false,
                            color: Colors.white,
                            width: 50,
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 25,
                right: 20,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: _currentPage == 5
                      ? Container()
                      : GestureDetector(
                          onTap: () => _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut),
                          child: SvgPicture.asset(
                            assetArrow5,
                            color: Colors.white,
                            width: 50,
                          ),
                        ),
                ),
              ),
            ],
          )),
    );
  }
}
