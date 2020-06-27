import 'package:app_criancas/flare/idle_controller.dart';
import 'package:app_criancas/models/companheiro.dart';
import 'package:app_criancas/services/companheiro_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import '../../auth.dart';

class CompanheiroMessage extends StatefulWidget {
  CompanheiroMessageState createState() => CompanheiroMessageState();
}

class CompanheiroMessageState extends State<CompanheiroMessage> {
  String userID;

  // Companheiro
  IdleControls _controller;
  Companheiro companheiro;
  String numberEyes;
  String companheiroMouth;
  String companheiroHeadTop;
  String companheiroBodyPart;
  int companheiroColour;
  bool flag;

  getComp() async {
    Companheiro tempCompanheiro = await getCompanheiro(userID);
    setState(() {
      companheiro = tempCompanheiro;
    });
  }

  @override
  initState() {
    _controller = IdleControls();
    Auth().getUser().then((user) {
      setState(() {
        userID = user.email;
        getComp();
      });
    });
    getComp();
    super.initState();
  }

  void _setColour(int companheiroColour) {
    setState(() {
      _controller.changeShapeColour(companheiroColour);
      _controller.isActive.value = true;
    });
  }

  void _setEyes(String numberEyes) {
    setState(() {
      _controller.changeEye(numberEyes);
      _controller.isActive.value = true;
    });
  }

  void _setMouth(String companheiroMouth) {
    setState(() {
      _controller.changeMouth(companheiroMouth);
      _controller.isActive.value = true;
    });
  }

  void _setBodyPart(String selectedBodyPart) {
    setState(() {
      _controller.changeBodyPart(selectedBodyPart);
      _controller.isActive.value = true;
    });
  }

  void _selectHeadTop(String selectedHeadTop) {
    setState(() {
      _controller.changeHeadTop(selectedHeadTop);
      _controller.isActive.value = true;
    });
  }
//  String _selectShape = 'square';
//  void _selectArtboard(String selectShape) {
//    setState(() {
//      effectsPlayer.play('button_click_drop.mp3');
//      _selectShape = selectShape;
//      _flareController.isActive.value = true;
//      _flareController.changeShape();
//    });
//  }

  // SVG ARROWS
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    flag = false;

    if (companheiro != null) {
      numberEyes = companheiro.eyes;
      companheiroColour = companheiro.color;
      companheiroHeadTop = companheiro.headTop;
      companheiroMouth = companheiro.mouth;
      companheiroBodyPart = companheiro.bodyPart;
      setState(() {
        flag = true;
      });
    }

    if (flag) {
      _setEyes(numberEyes);
      _setColour(companheiroColour);
      _selectHeadTop(companheiroHeadTop);
      _setMouth(companheiroMouth);
      _setBodyPart(companheiroBodyPart);
      return Container(
        margin: EdgeInsets.only(top: screenHeight > 100 ? 100 : 0),
        child: FlareActor(
          "assets/animation/shapes3.flr",
          animation: "animation",
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
          controller: _controller,
          artboard: companheiro.shape,
        ),
      );
    } else {
      return Container();
    }
  }
}
