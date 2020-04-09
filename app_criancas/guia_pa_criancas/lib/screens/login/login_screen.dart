
import 'package:flutter/material.dart';
import 'package:guia_pa/screens/login/login_screen_tablet.dart';
import 'package:guia_pa/responsive/orientation_layout.dart';
import 'package:guia_pa/responsive/screen_type_layout.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: LoginTabletPortrait(),
        landscape: LoginTabletLandscape(),
      ),
    );
  }
}