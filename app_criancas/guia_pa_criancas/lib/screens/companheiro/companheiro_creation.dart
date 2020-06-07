import 'package:app_criancas/flare/idle_controller.dart';
import 'package:app_criancas/services/companheiro_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flare_flutter/flare_actor.dart';
import '../../auth.dart';
import '../../synthesizeText.dart';
// MOVER AO MERGE
import 'package:audioplayers/audio_cache.dart';

class CreateCompanheiro extends StatefulWidget {
  CreateCompanheiroState createState() => CreateCompanheiroState();
}

class CreateCompanheiroState extends State<CreateCompanheiro> {
  String userID;
  String _bodyPart;
  int _colour;
  String _eyes;
  String _headTop;
  String _mouth;
  String _selectedShape = 'square';
  String _shapeName = 'Quadrado';

  // Sound Effects
  static AudioCache effectsPlayer = AudioCache(prefix: 'audio/');
  // Text to Speech Synth
  Synth reader = Synth(); //

  IdleControls _flareController;

  final myController = TextEditingController();
  List<bool> _isSelectedEyes = [false, false, false, false];
  List<bool> _isSelectedShape = [false, true, false, false, false, false];
  List<bool> _isSelectedColor = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<bool> _isSelectedSmile = [false, false];
  List<bool> _isSelectedHeadTop = [false, false, false];
  List<bool> _isSelectedBodyParts = [false, false, false, false];

  @override
  initState() {
    _flareController = IdleControls();
//    effectsPlayer.loadAll(['button_click_drop.mp3','cartoon_bubble_pop_007','cartoon_bubble_001']);
    _controller = PageController(initialPage: 0);
    Auth().getUser().then((user) {
      setState(() {
        userID = user.email;
        print('este é o user'+userID);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

// SHOW PART FROM THE NEXT -> PageController(viewportFraction: 0.8)
  PageController _controller;

  void _changeColour(int selectedColour) {
    for (int i = 0; i < _isSelectedColor.length; i++) {
      if (i == selectedColour) {
        _isSelectedColor[i] = true;
      } else {
        _isSelectedColor[i] = false;
      }
    }
    setState(() {
      effectsPlayer.play('cartoon_bubble_001.mp3');
      _flareController.changeShapeColour(selectedColour);
      _colour = selectedColour;
      // advance the controller
      _flareController.isActive.value = true;
    });
  }

  void _selectEye(String howManyEyes, int index) {
    setState(() {
      for (int i = 0; i < _isSelectedEyes.length; i++) {
        if (i == index) {
          _isSelectedEyes[i] = true;
        } else {
          _isSelectedEyes[i] = false;
        }
      }
      effectsPlayer.play('cartoon_bubble_pop_007.mp3');
      _flareController.changeEye(howManyEyes);
      _eyes = howManyEyes;

      _flareController.isActive.value = true;
    });
  }

  void _selectMouth(String selectedMouth, int index) {
    setState(() {
      for (int i = 0; i < _isSelectedSmile.length; i++) {
        if (i == index) {
          _isSelectedSmile[i] = true;
        } else {
          _isSelectedSmile[i] = false;
        }
      }
      effectsPlayer.play('button_click_drop.mp3');
      _flareController.changeMouth(selectedMouth);
      _flareController.isActive.value = true;
      _mouth = selectedMouth;
    });
  }

  void _selectBodyPart(String selectedBodyPart, int index) {
    setState(() {
      for (int i = 0; i < _isSelectedBodyParts.length; i++) {
        if (i == index) {
          _isSelectedBodyParts[i] = true;
        } else {
          _isSelectedBodyParts[i] = false;
        }
      }
      effectsPlayer.play('button_click_drop.mp3');

      _flareController.changeBodyPart(selectedBodyPart);
      _flareController.isActive.value = true;
      _bodyPart = selectedBodyPart;
    });
  }

  void _selectHeadTop(String selectedHeadTop, int index) {
    setState(() {
      for (int i = 0; i < _isSelectedHeadTop.length; i++) {
        if (i == index) {
          _isSelectedHeadTop[i] = true;
        } else {
          _isSelectedHeadTop[i] = false;
        }
      }
      effectsPlayer.play('button_click_drop.mp3');
      _flareController.changeHeadTop(selectedHeadTop);
      _flareController.isActive.value = true;
      _headTop = selectedHeadTop;
    });
  }

  void _selectArtboard(String selectedShape, int index) {
    setState(() {
      for (int i = 0; i < _isSelectedShape.length; i++) {
        if (i == index) {
          _isSelectedShape[i] = true;
        } else {
          _isSelectedShape[i] = false;
        }
      }
      effectsPlayer.play('button_click_drop.mp3');
      _selectedShape = selectedShape;
      if (_selectedShape == 'pentagon') {
        _shapeName = 'Pentágono';
      } else if (_selectedShape == 'square') {
        _shapeName = 'Quadrado';
      } else if (_selectedShape == 'circle') {
        _shapeName = 'Círculo';
      } else if (_selectedShape == 'triangle') {
        _shapeName = 'Triângulo';
      } else if (_selectedShape == 'half') {
        _shapeName = 'Semi-círculo';
      } else if (_selectedShape == 'diamond') {
        _shapeName = 'Losango';
      }

      _flareController.isActive.value = true;
      _flareController.changeShape();
    });
  }

  _saveNameSharedPref(String myName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('myName', myName);
    print(sp.getString('myName'));
  }

  _submitCreation(myName) {
    _saveNameSharedPref(myName);
    createCompanheiro(
        _bodyPart, _colour, _eyes, _headTop, userID, _mouth, _selectedShape);
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
//        resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          //Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: <Widget>[
                Container(
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
                                    "assets/animation/shapes3.flr",
                                    animation: "animation",
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                    controller: _flareController,
                                    artboard: _selectedShape,
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
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () =>
                                              _selectArtboard('pentagon', 0),
                                          child: SvgPicture.asset(
                                            assetPentagon,
                                            color: _isSelectedShape[0]
                                                ? Colors.yellowAccent
                                                    .withOpacity(0.6)
                                                : Color(0x99FFFFFF),
                                            width: 45,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () =>
                                              _selectArtboard('square', 1),
                                          child: SvgPicture.asset(
                                            assetSquare,
                                            color: _isSelectedShape[1]
                                                ? Colors.yellowAccent
                                                    .withOpacity(0.6)
                                                : Color(0x99FFFFFF),
                                            width: 37,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () =>
                                              _selectArtboard('circle', 2),
                                          child: SvgPicture.asset(
                                            assetCircle,
                                            color: _isSelectedShape[2]
                                                ? Colors.yellowAccent
                                                    .withOpacity(0.6)
                                                : Color(0x99FFFFFF),
                                            width: 47,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () =>
                                              _selectArtboard('triangle', 3),
                                          child: SvgPicture.asset(
                                            assetTriangle,
                                            color: _isSelectedShape[3]
                                                ? Colors.yellowAccent
                                                    .withOpacity(0.6)
                                                : Color(0x99FFFFFF),
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () =>
                                              _selectArtboard('half', 4),
                                          child: SvgPicture.asset(
                                            assetHalfCircle,
                                            color: _isSelectedShape[4]
                                                ? Colors.yellowAccent
                                                    .withOpacity(0.6)
                                                : Color(0x99FFFFFF),
                                            width: 45,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () =>
                                              _selectArtboard('diamond', 5),
                                          child: SvgPicture.asset(
                                            assetDiamond,
                                            matchTextDirection: false,
                                            color: _isSelectedShape[5]
                                                ? Colors.yellowAccent
                                                    .withOpacity(0.6)
                                                : Color(0x99FFFFFF),
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  _shapeName,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: Color(0x99FFFFFF)),
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
                                    "assets/animation/shapes3.flr",
                                    animation: "standby",
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                    controller: _flareController,
                                    artboard: _selectedShape,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ButtonBar(
                                          alignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Wrap(
                                                direction: Axis.horizontal,
                                                alignment: WrapAlignment.center,
                                                spacing: 10.0,
                                                runSpacing: 5.0,
                                                children: <Widget>[
                                                  MaterialButton(
                                                    elevation:
                                                        _isSelectedColor[0]
                                                            ? 6
                                                            : 0,
                                                    child: Text(''),
                                                    color: Color(0xffFE595A),
                                                    onPressed: () =>
                                                        _changeColour(0),
                                                    padding: EdgeInsets.all(16),
                                                    shape: CircleBorder(),
                                                  ),
                                                  MaterialButton(
                                                    elevation:
                                                        _isSelectedColor[1]
                                                            ? 6
                                                            : 0,
                                                    child: Text(''),
                                                    color: Color(0xffFF842A),
                                                    onPressed: () =>
                                                        _changeColour(1),
                                                    padding: EdgeInsets.all(16),
                                                    shape: CircleBorder(),
                                                  ),
                                                  MaterialButton(
                                                    elevation:
                                                        _isSelectedColor[2]
                                                            ? 6
                                                            : 0,
                                                    child: Text(''),
                                                    color: Color(0xffFEE32B),
                                                    onPressed: () =>
                                                        _changeColour(2),
                                                    padding: EdgeInsets.all(16),
                                                    shape: CircleBorder(),
                                                  ),
                                                  MaterialButton(
                                                    elevation:
                                                        _isSelectedColor[3]
                                                            ? 6
                                                            : 0,
                                                    child: Text(''),
                                                    color: Color(0xff48D597),
                                                    onPressed: () =>
                                                        _changeColour(3),
                                                    padding: EdgeInsets.all(16),
                                                    shape: CircleBorder(),
                                                  ),
                                                  MaterialButton(
                                                    elevation:
                                                        _isSelectedColor[4]
                                                            ? 6
                                                            : 0,
                                                    child: Text(''),
                                                    color: Color(0xff00B5E2),
                                                    onPressed: () =>
                                                        _changeColour(4),
                                                    padding: EdgeInsets.all(16),
                                                    shape: CircleBorder(),
                                                  ),
                                                  MaterialButton(
                                                    elevation:
                                                        _isSelectedColor[5]
                                                            ? 6
                                                            : 0,
                                                    child: Text(''),
                                                    color: Color(0xff825DC7),
                                                    onPressed: () =>
                                                        _changeColour(5),
                                                    padding: EdgeInsets.all(16),
                                                    shape: CircleBorder(),
                                                  ),
                                                  MaterialButton(
                                                    elevation:
                                                        _isSelectedColor[6]
                                                            ? 6
                                                            : 0,
                                                    child: Text(''),
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
                                    onTap: () => reader.synthesizeText(
                                        'Quantos olhos preciso?'),
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
                                    "assets/animation/shapes3.flr",
                                    animation: "standby",
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                    controller: _flareController,
                                    artboard: _selectedShape,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: ButtonBar(
                                        alignment:
                                            MainAxisAlignment.spaceEvenly,
//                                        mainAxisSize: MainAxisSize.max,
//                                        layoutBehavior: ButtonBarLayoutBehavior.padded,
                                        buttonHeight: 40,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              OutlineButton(
                                                borderSide: BorderSide(
                                                  width: _isSelectedEyes[0]
                                                      ? 4
                                                      : 2,
                                                  color: _isSelectedEyes[0]
                                                      ? Colors.greenAccent
                                                      : Colors.white,
                                                ),
                                                child: Text(
                                                  '1',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.quicksand(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color:
                                                            _isSelectedEyes[0]
                                                                ? Colors
                                                                    .greenAccent
                                                                : Colors.white),
                                                  ),
                                                ),
                                                color: Color(0xffFE595A),
                                                onPressed: () =>
                                                    _selectEye('one_eye', 0),
                                                padding: EdgeInsets.all(12),
                                                shape: CircleBorder(),
                                              ),
                                              OutlineButton(
                                                borderSide: BorderSide(
                                                  width: _isSelectedEyes[1]
                                                      ? 4
                                                      : 2,
                                                  color: _isSelectedEyes[1]
                                                      ? Colors.greenAccent
                                                      : Colors.white,
                                                ),
                                                child: Text(
                                                  '2',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.quicksand(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color:
                                                            _isSelectedEyes[1]
                                                                ? Colors
                                                                    .greenAccent
                                                                : Colors.white),
                                                  ),
                                                ),
                                                color: Color(0xffFE595A),
                                                onPressed: () =>
                                                    _selectEye('two_eyes', 1),
                                                padding: EdgeInsets.all(12),
                                                shape: CircleBorder(),
                                              ),
                                              OutlineButton(
                                                borderSide: BorderSide(
                                                  width: _isSelectedEyes[2]
                                                      ? 4
                                                      : 2,
                                                  color: _isSelectedEyes[2]
                                                      ? Colors.greenAccent
                                                      : Colors.white,
                                                ),
                                                child: Text(
                                                  '3',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.quicksand(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color:
                                                            _isSelectedEyes[2]
                                                                ? Colors
                                                                    .greenAccent
                                                                : Colors.white),
                                                  ),
                                                ),
                                                color: Color(0xffFE595A),
                                                onPressed: () =>
                                                    _selectEye('three_eyes', 2),
                                                padding: EdgeInsets.all(12),
                                                shape: CircleBorder(),
                                              ),
                                              OutlineButton(
                                                borderSide: BorderSide(
                                                  width: _isSelectedEyes[3]
                                                      ? 4
                                                      : 2,
                                                  color: _isSelectedEyes[3]
                                                      ? Colors.greenAccent
                                                      : Colors.white,
                                                ),
                                                child: Text(
                                                  '+',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.quicksand(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color:
                                                            _isSelectedEyes[3]
                                                                ? Colors
                                                                    .greenAccent
                                                                : Colors.white),
                                                  ),
                                                ),
                                                color: Color(0xffFE595A),
                                                onPressed: () =>
                                                    _selectEye('multi_eyes', 3),
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
                                    "assets/animation/shapes3.flr",
                                    animation: "standby",
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                    controller: _flareController,
                                    artboard: _selectedShape,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: OutlineButton(
                                            borderSide: BorderSide(
                                              width:
                                                  _isSelectedSmile[0] ? 3 : 1,
                                              color: _isSelectedSmile[0]
                                                  ? Colors.white
                                                  : Colors.black54,
                                            ),
                                            child: Text(
                                              'Sorriso Pateta',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.pangolin(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: _isSelectedSmile[0]
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            color: Colors.white,
                                            onPressed: () =>
                                                _selectMouth('silly', 0),
                                            padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: OutlineButton(
                                            borderSide: BorderSide(
                                              width:
                                                  _isSelectedSmile[1] ? 3 : 1,
                                              color: _isSelectedSmile[1]
                                                  ? Colors.white
                                                  : Colors.black54,
                                            ),
                                            child: Text(
                                              'Dentinhos',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.pangolin(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: _isSelectedSmile[1]
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),

                                            color: Colors.white,
                                            onPressed: () =>
                                                _selectMouth('vampire', 1),
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
                                    "assets/animation/shapes3.flr",
                                    animation: "standby",
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                    controller: _flareController,
                                    artboard: _selectedShape,
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
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.spaceAround,
                                        spacing: 10.0,
                                        runSpacing: 5.0,
                                        children: <Widget>[
                                          OutlineButton(
                                            borderSide: BorderSide(
                                              width:
                                                  _isSelectedHeadTop[0] ? 3 : 1,
                                              color: _isSelectedHeadTop[0]
                                                  ? Colors.white
                                                  : Colors.black54,
                                            ),
                                            child: Text(
                                              'Antenas',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.pangolin(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: _isSelectedHeadTop[0]
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            color: Colors.white,
                                            onPressed: () =>
                                                _selectHeadTop('antenas', 0),
                                            padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
                                          ),
                                          OutlineButton(
                                            borderSide: BorderSide(
                                              width:
                                                  _isSelectedHeadTop[1] ? 3 : 1,
                                              color: _isSelectedHeadTop[1]
                                                  ? Colors.white
                                                  : Colors.black54,
                                            ),
                                            child: Text(
                                              'Tufo de cabelo',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.pangolin(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: _isSelectedHeadTop[1]
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),

                                            color: Colors.white,
                                            onPressed: () =>
                                                _selectHeadTop('pineapple', 1),
                                            padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
                                          ),
                                          OutlineButton(
                                            borderSide: BorderSide(
                                              width:
                                                  _isSelectedHeadTop[2] ? 3 : 1,
                                              color: _isSelectedHeadTop[2]
                                                  ? Colors.white
                                                  : Colors.black54,
                                            ),
                                            child: Text(
                                              'Carecada',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.pangolin(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: _isSelectedHeadTop[2]
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),

                                            color: Colors.white,
                                            onPressed: () =>
                                                _selectHeadTop('bald', 2),
                                            padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
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
                                    "assets/animation/shapes3.flr",
                                    animation: "standby",
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                    controller: _flareController,
                                    artboard: _selectedShape,
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
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      runAlignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 10.0,
                                      runSpacing: 5.0,
                                      children: <Widget>[
                                        OutlineButton(
                                          borderSide: BorderSide(
                                            width:
                                                _isSelectedBodyParts[0] ? 3 : 1,
                                            color: _isSelectedBodyParts[0]
                                                ? Colors.white
                                                : Colors.black54,
                                          ),
                                          child: Text(
                                            'Asas',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.pangolin(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18,
                                                color: _isSelectedBodyParts[0]
                                                    ? Colors.white
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          color: Colors.white,
                                          onPressed: () =>
                                              _selectBodyPart('bat_wings', 0),
                                          padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
                                        ),
                                        OutlineButton(
                                          borderSide: BorderSide(
                                            width:
                                                _isSelectedBodyParts[1] ? 3 : 1,
                                            color: _isSelectedBodyParts[1]
                                                ? Colors.white
                                                : Colors.black54,
                                          ),
                                          child: Text(
                                            'Tentáculos',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.pangolin(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18,
                                                color: _isSelectedBodyParts[1]
                                                    ? Colors.white
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),

                                          color: Colors.white,
                                          onPressed: () =>
                                              _selectBodyPart('tentacles', 1),
                                          padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
                                        ),
                                        OutlineButton(
                                          borderSide: BorderSide(
                                            width:
                                                _isSelectedBodyParts[2] ? 3 : 1,
                                            color: _isSelectedBodyParts[2]
                                                ? Colors.white
                                                : Colors.black54,
                                          ),
                                          child: Text(
                                            'Braços',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.pangolin(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18,
                                                color: _isSelectedBodyParts[2]
                                                    ? Colors.white
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),

                                          color: Colors.white,
                                          onPressed: () =>
                                              _selectBodyPart('arms', 2),
                                          padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
                                        ),
                                        OutlineButton(
                                          borderSide: BorderSide(
                                            width:
                                                _isSelectedBodyParts[3] ? 3 : 1,
                                            color: _isSelectedBodyParts[3]
                                                ? Colors.white
                                                : Colors.black54,
                                          ),
                                          child: Text(
                                            'Não preciso nada',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.pangolin(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18,
                                                color: _isSelectedBodyParts[3]
                                                    ? Colors.white
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),

                                          color: Colors.white,
                                          onPressed: () =>
                                              _selectBodyPart('nothing', 3),
                                          padding: EdgeInsets.all(10),
//                                              shape: CircleBorder(),
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
                                      'Wow... Estou perfeito!',
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
                                  padding: EdgeInsets.only(left: 30, right: 30),
                                  child: Flexible(
                                    child: Center(
                                      child: Text(
                                        'E como é que os teus amigos te costumam chamar?',
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
                                ),
                                Container(
                                  decoration: BoxDecoration(
//                                border: Border.all(width: 1),
                                      ),
                                  height: 300,
                                  child: FlareActor(
                                    "assets/animation/shapes3.flr",
                                    animation: "standby",
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                    controller: _flareController,
                                    artboard: _selectedShape,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 60.0),
                                  child: Column(
                                    children: [
//                                      Text(
//                                        'Como os teus amigos te costumam chamar?',
//                                        textAlign: TextAlign.center,
//                                        style: GoogleFonts.pangolin(
//                                          textStyle: TextStyle(
//                                              fontWeight: FontWeight.normal,
//                                              fontSize: 22,
//                                              color: Colors.black),
//                                        ),
//                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 0.0),
                                        child: TextField(
                                          autofocus: true,
                                          maxLength: 30,
                                          controller: myController,
                                          decoration: InputDecoration(
                                              hintText: 'Escreve aqui...',
                                              labelStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0)),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.pangolin(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 22,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),

                                      Container(
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                ),
                              ])),
//                    Container(
//                        decoration: BoxDecoration(
//                          gradient: LinearGradient(
//                            begin: Alignment.topLeft,
//                            end: Alignment.bottomCenter,
//                            stops: [0.0, 1.0],
//                            colors: [
//                              Color(0xFFff6e4a),
//                              Color(0xFFf03333),
//                            ],
//                          ),
//                        ),
//                        child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.stretch,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              Padding(
//                                padding: EdgeInsets.only(
//                                    left: 30, right: 30, bottom: 10),
//                                child: Flexible(
//                                  child: Text(
//                                    'Name',
//                                    textAlign: TextAlign.center,
//                                    style: GoogleFonts.quicksand(
//                                      textStyle: TextStyle(
//                                          fontWeight: FontWeight.w900,
//                                          fontSize: 28,
//                                          color: Colors.white),
//                                    ),
//                                  ),
//                                ),
//                              ),
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
//                              Container(
//                                decoration: BoxDecoration(
////                                border: Border.all(width: 1),
//                                    ),
//                                height: 300,
//                                child: FlareActor(
//                                  "assets/animation/shapes3.flr",
//                                  animation: "standby",
//                                  fit: BoxFit.contain,
//                                  alignment: Alignment.center,
//                                  controller: _flareController,
//                                  artboard: _selectedShape,
//                                ),
//                              ),
//                              Column(
//                                children: [
//                                  Padding(
//                                    padding: const EdgeInsets.all(8.0),
//                                    child: Text(
//                                      'O que achas dá mais jeito?',
//                                      textAlign: TextAlign.center,
//                                      style: GoogleFonts.pangolin(
//                                        textStyle: TextStyle(
//                                            fontWeight: FontWeight.normal,
//                                            fontSize: 22,
//                                            color: Colors.black),
//                                      ),
//                                    ),
//                                  ),
//                                  Center(
//                                    child: TextField(
//                                      decoration:
//                                          InputDecoration(hintText: 'Name'),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ])),
                    ],
                  ),
                ),
                Positioned.fill(
                  bottom: 25,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: _currentPage == 6
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
                      child: _currentPage == 6
                          ? Container(
                              child: FlatButton(
                                onPressed: () =>
                                    _submitCreation(myController.text),
                                color: Colors.transparent,
                                textColor: Colors.white,
//                              disabledColor: Colors.white,
//                                disabledTextColor: Colors.black,
                                padding: EdgeInsets.all(20.0),
//                                splashColor: Colors.blueAccent,
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
                    child: _currentPage == 6
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
            ),
          )),
    );
  }
}
