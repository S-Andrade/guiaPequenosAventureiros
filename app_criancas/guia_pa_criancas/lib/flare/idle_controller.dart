import 'dart:ui';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';

class IdleControls extends FlareController {
  FlutterActorArtboard myartboard;

  // EYES
  ActorNode oneEye;
  ActorNode twoEyes;
  ActorNode threeEyes;
  ActorNode multiEyes;
  double oneEyeOpacity = 0.0;
  double twoEyesOpacity = 0.0;
  double threeEyesOpacity = 0.0;
  double multiEyesOpacity = 0.0;
  // MOUTH
  ActorNode silly;
  ActorNode vampire;
  double sillyMouthOpacity = 0.0;
  double vampireMouthOpacity = 0.0;

  // HEAD
  FlutterColorFill _fillPineapple;
  FlutterColorFill _fillAntenas;
  Color _fillPineappleColor = Color(0x00E5E5E5);
  Color _fillAntenasColor = Color(0x00E5E5E5);

  // BODY PARTS
  FlutterColorFill _fillBody;
  FlutterColorFill _fillWings;
  FlutterColorFill _fillTentacles;
  FlutterColorFill _fillArms;
  Color _fillBodyColor = Color(0xFFE5E5E5);
  Color _fillWingsColor = Color(0x00E5E5E5);
  Color _fillTentaclesColor = Color(0x00E5E5E5);
  Color _fillArmsColor = Color(0x00E5E5E5);

  void initialize(FlutterActorArtboard artboard) {
    myartboard = artboard;

    // EYES
    oneEye = myartboard.getNode("1_eyes");
    twoEyes = myartboard.getNode("2_eyes");
    threeEyes = myartboard.getNode("3_eyes");
    multiEyes = myartboard.getNode("multi_eyes");
    // MOUTH
    silly = myartboard.getNode("mouth_silly");
    vampire = myartboard.getNode("mouth_vampire");
    // HEAD
    FlutterActorShape pineapple = myartboard.getNode("pineapple");
    FlutterActorShape antenas = myartboard.getNode("antenas");
    _fillPineapple = pineapple?.fill as FlutterColorFill;
    _fillAntenas = antenas?.fill as FlutterColorFill;
    // BODY PARTS
    FlutterActorShape body = myartboard.getNode("body");
    FlutterActorShape wings = myartboard.getNode("bat_wings");
    FlutterActorShape tentacles = myartboard.getNode("tentacles");
    FlutterActorShape arms = myartboard.getNode("arms");
    _fillBody = body?.fill as FlutterColorFill;
    _fillWings = wings?.fill as FlutterColorFill;
    _fillTentacles = tentacles?.fill as FlutterColorFill;
    _fillArms = arms?.fill as FlutterColorFill;
  }

  void setViewTransform(Mat2D viewTransform) {}

  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if (_fillBody != null) {
      // BODY PARTS
      _fillBody.uiColor = _fillBodyColor;
      _fillWings.uiColor = _fillWingsColor;
      _fillTentacles.uiColor = _fillTentaclesColor;
      _fillArms.uiColor = _fillArmsColor;
      // HEAD
      _fillPineapple.uiColor = _fillPineappleColor;
      _fillAntenas.uiColor = _fillAntenasColor;
      // EYES
      oneEye.opacity = oneEyeOpacity;
      twoEyes.opacity = twoEyesOpacity;
      threeEyes.opacity = threeEyesOpacity;
      multiEyes.opacity = multiEyesOpacity;
      // MOUTH
      silly.opacity = sillyMouthOpacity;
      vampire.opacity = vampireMouthOpacity;
    }
    return false;
  }

  List<Color> availableColours = <Color>[
    Color(0xfff24e4e),
    Color(0xffff9d47),
    Color(0xffffea5c),
    Color(0xff48D597),
    Color(0xff3bd8ff),
    Color(0xffb38aff),
    Color(0xffff96bb),
  ];

  void changeShapeColour(int selectColour) {
    // BODY
    _fillBodyColor = availableColours[selectColour];
    if (_fillWingsColor.value > Color(0x00E5E5E5).value) {
      _fillWingsColor = availableColours[selectColour];
    }
    if (_fillArmsColor.value > Color(0x00E5E5E5).value) {
      _fillArmsColor = availableColours[selectColour];
    }
    if (_fillTentaclesColor.value > Color(0x00E5E5E5).value) {
      _fillTentaclesColor = availableColours[selectColour];
    }

    //HEAD
    if (_fillPineappleColor.value > Color(0x00E5E5E5).value) {
      _fillPineappleColor = availableColours[selectColour];
    }
    if (_fillAntenasColor.value > Color(0x00E5E5E5).value) {
      _fillAntenasColor = availableColours[selectColour];
    }

    isActive.value = true;
  }

  void changeEye(String howManyEyes) {
    if (howManyEyes == 'one_eye') {
      oneEyeOpacity = 1.0;
      twoEyesOpacity = 0.0;
      threeEyesOpacity = 0.0;
      multiEyesOpacity = 0.0;
    } else if (howManyEyes == 'two_eyes') {
      oneEyeOpacity = 0.0;
      twoEyesOpacity = 1.0;
      threeEyesOpacity = 0.0;
      multiEyesOpacity = 0.0;
    } else if (howManyEyes == 'three_eyes') {
      oneEyeOpacity = 0.0;
      twoEyesOpacity = 0.0;
      threeEyesOpacity = 1.0;
      multiEyesOpacity = 0.0;
    } else {
      oneEyeOpacity = 0.0;
      twoEyesOpacity = 0.0;
      threeEyesOpacity = 0.0;
      multiEyesOpacity = 1.0;
    }

    isActive.value = true;
  }

  void changeMouth(String selectedMouth) {
    if (selectedMouth == 'silly') {
      sillyMouthOpacity = 1.0;
      vampireMouthOpacity = 0.0;
    } else {
      sillyMouthOpacity = 0.0;
      vampireMouthOpacity = 1.0;
    }
  }

  void changeBodyPart(String selectBodyPart) {
    if (selectBodyPart == 'bat_wings') {
      _fillWingsColor = _fillBodyColor;
      _fillTentaclesColor = Color(0x00E5E5E5);
      _fillArmsColor = Color(0x00E5E5E5);
    } else if (selectBodyPart == 'tentacles') {
      _fillTentaclesColor = _fillBodyColor;
      _fillArmsColor = Color(0x00E5E5E5);
      _fillWingsColor = Color(0x00E5E5E5);
    } else if (selectBodyPart == 'arms') {
      _fillArmsColor = _fillBodyColor;
      _fillTentaclesColor = Color(0x00E5E5E5);
      _fillWingsColor = Color(0x00E5E5E5);
    } else {
      _fillArmsColor = Color(0x00E5E5E5);
      _fillTentaclesColor = Color(0x00E5E5E5);
      _fillWingsColor = Color(0x00E5E5E5);
    }
    isActive.value = true;
  }

  void changeHeadTop(String selectedHeadTop) {
    if (selectedHeadTop == 'antenas') {
      _fillAntenasColor = _fillBodyColor;
      _fillPineappleColor = Color(0x00E5E5E5);
    } else if (selectedHeadTop == 'pineapple') {
      _fillPineappleColor = _fillBodyColor;
      _fillAntenasColor = Color(0x00E5E5E5);
    } else {
      _fillPineappleColor = Color(0x00E5E5E5);
      _fillAntenasColor = Color(0x00E5E5E5);
    }
    isActive.value = true;
  }

  void changeShape() {
    isActive.value = true;
  }
}
