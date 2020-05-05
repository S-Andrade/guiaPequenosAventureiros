import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter/widgets.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
//import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//
import 'package:flare_flutter/flare_actor.dart';
//import 'package:guiacompanheiro/flare/flare_controller.dart';
//
//import 'package:guiacompanheiro/synthesizeText.dart';
//
//// MOVER AO MERGE
//import 'package:audioplayers/audio_cache.dart';

class CompanheiroAppwide extends StatefulWidget {
  CompanheiroAppwideState createState() => CompanheiroAppwideState();
}

class CompanheiroAppwideState extends State<CompanheiroAppwide> {
  // Sound Effects
//  static AudioCache effectsPlayer = AudioCache(prefix: 'audio/');
//  // Text to Speech Synth
//  Synth reader = Synth(); //
//  AnimationControls _flareController;

  @override
  initState() {
//    _flareController = AnimationControls();
//    effectsPlayer.loadAll(['button_click_drop.mp3','cartoon_bubble_pop_007','cartoon_bubble_001']); nao tava no otro
    super.initState();
  }

//  void _changeColour(int selectColour) {
//    setState(() {
//      effectsPlayer.play('cartoon_bubble_001.mp3');
//      _flareController.changeShapeColour(selectColour);
//      // advance the controller
//      _flareController.isActive.value = true;
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
    return Positioned.fill(
      child: Align( alignment: Alignment.topRight,
        child: FractionallySizedBox(widthFactor: 0.4,heightFactor: 0.2,
          child: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            colors: [
              Color(0xFF62D7A2),
              Color(0xFF00C9C9),
            ],
          )),
            child:Text('TESTE- Espaço do comp'),

          ),
        ),
      ),
    );
  }
}
