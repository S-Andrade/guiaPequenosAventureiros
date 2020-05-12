import 'dart:ui';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';

class IdleControls extends FlareController {

  FlutterActorArtboard myartboard;

  void initialize(FlutterActorArtboard artboard) {
    myartboard = artboard;
  }
  void setViewTransform(Mat2D viewTransform) {}

  bool advance(FlutterActorArtboard artboard, double elapsed) {
    return false;
  }


}
