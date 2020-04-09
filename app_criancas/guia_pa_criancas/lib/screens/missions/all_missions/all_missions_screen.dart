import 'package:flutter/material.dart';
import '../../../responsive/orientation_layout.dart';
import '../../../responsive/screen_type_layout.dart';

import 'all_missions_screen_tablet.dart';


class AllMissionsScreen extends StatelessWidget {
  List missoes; 
  AllMissionsScreen({this.missoes});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: AllMissionsTabletPortrait(missoes: missoes),
        landscape: AllMissionsTabletLandscape(),
      ),
    );
  }
}