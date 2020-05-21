import 'package:app_criancas/flare/idle_controller.dart';
import 'package:app_criancas/models/companheiro.dart';
import 'package:app_criancas/services/companheiro_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../auth.dart';

class CompanheiroAppwide extends StatefulWidget {
  CompanheiroAppwideState createState() => CompanheiroAppwideState();
}

class CompanheiroAppwideState extends State<CompanheiroAppwide> {
  IdleControls _controller;
  String userID;
  Companheiro companheiro;

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
      });
    });
    getComp();
    super.initState();
  }

//  void _setColour(int selectColour) {
//    setState(() {
////      _controller.changeShapeColour(selectColour);
////      _controller.isActive.value = true;
//    });
//  }

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
    print('the last printolas');
    print(companheiro);
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FractionallySizedBox(
          widthFactor: 0.3,
          heightFactor: 0.2,
          child: GestureDetector(
            child: Text(''),
//            FlareActor(
//              "assets/animation/shapes3.flr",
//              animation: "animation",
//              fit: BoxFit.contain,
//              alignment: Alignment.topCenter,
//              controller: _controller,
//              artboard: "square",
//            ),
          ),
        ),
      ),
    );
  }
}
