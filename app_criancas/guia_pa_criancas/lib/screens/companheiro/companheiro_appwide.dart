import 'package:app_criancas/flare/idle_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class CompanheiroAppwide extends StatefulWidget {
  CompanheiroAppwideState createState() => CompanheiroAppwideState();
}

class CompanheiroAppwideState extends State<CompanheiroAppwide> {
  IdleControls _controller;

  @override
  initState() {
    _controller = IdleControls();
    super.initState();
  }

  void _setColour(int selectColour) {
    setState(() {
//      _controller.changeShapeColour(selectColour);
//      _controller.isActive.value = true;
    });
  }

// functions do creator
//  void _selectEye(int numberEyes) {
//    setState(() {
//      effectsPlayer.play('cartoon_bubble_pop_007.mp3');
//      _flareController.changeEye(numberEyes);
//      _flareController.isActive.value = true;
//    });
//  }
//  void _selectMouth(int selectedMouth) {
//    setState(() {
//      effectsPlayer.play('button_click_drop.mp3');
//
//      _flareController.changeMouth(selectedMouth);
//      _flareController.isActive.value = true;
//    });
//  }
//  void _selectBodyPart(int selectedBodyPart) {
//    setState(() {
//      effectsPlayer.play('button_click_drop.mp3');
//
//      _flareController.changeBodyPart(selectedBodyPart);
//      _flareController.isActive.value = true;
//    });
//  }
//  void _selectHeadTop(int selectedHeadTop) {
//    setState(() {
//      effectsPlayer.play('button_click_drop.mp3');
//
//      _flareController.changeHeadTop(selectedHeadTop);
//      _flareController.isActive.value = true;
//    });
//  }
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
    return FractionallySizedBox(
      widthFactor: 0.3,
      heightFactor: 0.18,
      child: GestureDetector(
        child: FlareActor(
          "assets/animation/shapes3.flr",
          animation: "animation",
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
          controller: _controller,
          artboard: "square",
        ),
      ),
    );
  }
}
