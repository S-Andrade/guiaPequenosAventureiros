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

  @override
  Widget build(BuildContext context) {
    numberEyes = companheiro.eyes;
    companheiroColour = companheiro.color;
    companheiroHeadTop = companheiro.headTop;
    companheiroMouth = companheiro.mouth;
    companheiroBodyPart = companheiro.bodyPart;
    _setEyes(numberEyes);
    _setColour(companheiroColour);
    _selectHeadTop(companheiroHeadTop);
    _setMouth(companheiroMouth);
    _setBodyPart(companheiroBodyPart);

    return FlareActor(
      "assets/animation/shapes3.flr",
      animation: "animation",
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
      controller: _controller,
      artboard: companheiro.shape,
    );
  }
}
