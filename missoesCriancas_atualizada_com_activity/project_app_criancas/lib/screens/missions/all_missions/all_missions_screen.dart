import 'package:flutter/material.dart';
import 'package:project_app_criancas/responsive/orientation_layout.dart';
import 'package:project_app_criancas/responsive/screen_type_layout.dart';

import 'all_missions_screen_tablet.dart';


class AllMissionsScreen extends StatelessWidget {
  AllMissionsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: AllMissionsTabletPortrait(),
        landscape: AllMissionsTabletLandscape(),
      ),
    );
  }
}