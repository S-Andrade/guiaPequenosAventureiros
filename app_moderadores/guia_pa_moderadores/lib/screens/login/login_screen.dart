
import 'package:flutter/material.dart';
import 'package:guia_pa_moderadores/screens/login/login_screen_tablet.dart';
import 'package:guia_pa_moderadores/responsive/orientation_layout.dart';
import 'package:guia_pa_moderadores/responsive/screen_type_layout.dart';


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