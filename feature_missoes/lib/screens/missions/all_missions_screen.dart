
import 'package:flutter/material.dart';
import 'package:guia_pa_feature_missoes/screens/missions/all_missions_screen_tablet.dart';
import 'package:guia_pa_feature_missoes/responsive/orientation_layout.dart';
import 'package:guia_pa_feature_missoes/responsive/screen_type_layout.dart';


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